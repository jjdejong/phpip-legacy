-- Trademark organizations
insert into `country` ( `iso`, `name_DE`, `name`, `iso3`, `name_FR`, `numcode`) values ( 'EM', 'HABM', 'OHIM', 'EMA', 'OHMI', '0');
insert into `country` ( `iso`, `name_DE`, `name`, `iso3`, `name_FR`, `numcode`) values ( 'BX', 'Benelux', 'Benelux', 'BLX', 'Bénélux', '0');

ALTER TABLE `country` 
CHANGE COLUMN `ep` `ep` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for EP ratifications', 
CHANGE COLUMN `wo` `wo` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for PCT national phase', 
ADD COLUMN `em` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for EU trade mark' AFTER `wo`,
ADD COLUMN `oa` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for OA national phase' AFTER `em`;


ALTER TABLE `default_actor` 
ADD COLUMN `for_category` char(5) DEFAULT NULL AFTER `role`, 
CHANGE COLUMN `for_country` `for_country` char(2) DEFAULT NULL AFTER `for_category`, 
CHANGE COLUMN `for_client` `for_client` int(11) DEFAULT NULL AFTER `for_country`, 
CHANGE COLUMN `shared` `shared` tinyint(1) NOT NULL DEFAULT '0' AFTER `for_client`;


DROP TRIGGER `task_before_insert`;
DELIMITER ;;
CREATE TRIGGER `task_before_insert` BEFORE INSERT ON `task` FOR EACH ROW BEGIN

	DECLARE vflag BOOLEAN;
	DECLARE vresp CHAR(16);

	SET NEW.creator = SUBSTRING_INDEX(USER(),'@',1);

	SELECT use_matter_resp INTO vflag FROM event_name WHERE event_name.code=NEW.code;
	SELECT responsible INTO vresp FROM matter, event WHERE event.id=NEW.trigger_id AND matter.id=event.matter_id;

	IF NEW.assigned_to IS NULL THEN
		IF vflag = 0 THEN
			SET NEW.assigned_to = (SELECT default_responsible FROM event_name WHERE event_name.code=NEW.code);	
		ELSE
			SET NEW.assigned_to = (SELECT ifnull(default_responsible, vresp) FROM event_name WHERE event_name.code=NEW.code);
		END IF;
	END IF;

END;;
DELIMITER ;

ALTER TABLE `classifier_value` DROP INDEX `value`, ADD UNIQUE `uqclvalue` USING BTREE (`value`, type_code);


-- When a killer event is deleted, also unkill matter when expire date is null
DROP TRIGGER `event_after_delete`;
DELIMITER ;;
CREATE TRIGGER `event_after_delete` AFTER DELETE ON `event` FOR EACH ROW BEGIN
	IF OLD.code IN ('PRI','PFIL') THEN
		CALL recalculate_tasks(OLD.matter_ID, 'FIL');
	END IF;

	IF OLD.code='FIL' THEN
		UPDATE matter SET expire_date=NULL WHERE matter.ID=OLD.matter_ID;
	END IF;

	-- Unkill matter upon deleting a killer event
	UPDATE matter, event_name SET matter.dead=0 WHERE matter.ID=OLD.matter_ID AND OLD.code=event_name.code AND event_name.killer=1 
		AND (matter.expire_date > Now() OR matter.expire_date IS NULL)
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_ID=OLD.matter_ID AND event.code=ename.code AND ename.killer=1);
END;
DELIMITER ;


-- Fix default actors not being identified with multiple for_category values
DROP TRIGGER `matter_after_insert`;
DELIMITER ;;
CREATE TRIGGER `matter_after_insert` AFTER INSERT ON `matter` FOR EACH ROW BEGIN
	DECLARE vactorid, vshared INT DEFAULT NULL;
	DECLARE vrole CHAR(5) DEFAULT NULL;

	-- Insert "Created" event with today's date
	INSERT INTO event (code, matter_id, event_date) VALUES ('CRE', NEW.id, now());
	
	-- Fetch default actors defined in the "default_actor" table (multiple actors not allowed yet)
	SELECT actor_id, role, shared INTO vactorid, vrole, vshared FROM default_actor
	WHERE for_client IS NULL
	AND (for_country=NEW.country OR (for_country IS null AND NOT EXISTS (SELECT 1 FROM default_actor da WHERE da.for_country=NEW.country AND for_category=NEW.category_code)))
	AND for_category=NEW.category_code;

	-- Insert default actor depending on container and shared status
	IF (vactorid is NOT NULL AND (vshared=0 OR (vshared=1 AND NEW.container_ID IS NULL))) THEN
		INSERT INTO matter_actor_lnk (matter_id, actor_id, role, shared) VALUES (NEW.id, vactorid, vrole, vshared);
	END IF;
END;
DELIMITER ;


DROP TRIGGER `event_after_insert`;
DELIMITER ;;
CREATE TRIGGER `event_after_insert` AFTER INSERT ON `event` FOR EACH ROW trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vid_uqtask, vrule_id, vdays, vmonths, vyears, vrecurring, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
  DECLARE vtask, vtype, vcurrency CHAR(5) DEFAULT NULL;
  DECLARE vdetail, vwarn_text VARCHAR(160) DEFAULT NULL;
  DECLARE done, vclear_task, vdelete_task, vend_of_month, vunique, vuse_parent, vuse_priority, vdead BOOLEAN DEFAULT 0;
  DECLARE vcost, vfee DECIMAL(6,2) DEFAULT null;

  -- Cursor for selecting all the rules that apply 
  DECLARE cur_rule CURSOR FOR 
    SELECT task_rules.id, task, clear_task, delete_task, detail, days, months, years, recurring, end_of_month, use_parent, use_priority, cost, fee, currency, warn_text, event_name.unique
    FROM task_rules, event_name, matter
    WHERE NEW.matter_ID=matter.ID
    AND event_name.code=task
    AND NEW.code=trigger_event
    AND (ifnull(for_category, matter.category_code), ifnull(for_country, matter.country), ifnull(for_origin, matter.origin), ifnull(for_type, matter.type_code))<=>(matter.category_code, matter.country, matter.origin, matter.type_code)
    AND (uqtrigger=0 
        OR (uqtrigger=1 AND NOT EXISTS (SELECT 1 FROM task_rules tr 
        WHERE (tr.task, tr.for_category, tr.for_country)<=>(task_rules.task, matter.category_code, matter.country) AND tr.trigger_event!=task_rules.trigger_event)))
    AND NOT EXISTS (SELECT 1 FROM event WHERE matter_ID=NEW.matter_ID AND code=abort_on)
    AND (condition_event IS null OR EXISTS (SELECT 1 FROM event WHERE matter_ID=NEW.matter_ID AND code=condition_event))
    AND (NEW.event_date < use_before OR use_before IS null)
    AND (NEW.event_date > use_after OR use_after IS null)
    AND active=1;

  -- Cursor for finding the events that link to this matter, in case they need updating
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_ID=NEW.matter_ID; 

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT type_code, dead, expire_date, term_adjust INTO vtype, vdead, vexpiry, vpta FROM matter WHERE matter.ID=NEW.matter_ID;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  -- If case is dead or expired, don't create tasks
  IF (vdead OR Now() > vexpiry) THEN
    LEAVE trig;
  END IF;

  SET vbase_date = NEW.event_date;

  OPEN cur_rule;
  create_tasks: LOOP
	-- Reset reusable variables
	SET vid_uqtask=0;

    FETCH cur_rule INTO vrule_id, vtask, vclear_task, vdelete_task, vdetail, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority, vcost, vfee, vcurrency, vwarn_text, vunique;
    IF done THEN 
      LEAVE create_tasks; 
    END IF;

	-- Do not generate renewals if client is the annuity agent
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=NEW.matter_ID)) THEN
		ITERATE create_tasks;
	END IF;

	-- Switch to parent information, if required
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=NEW.matter_ID;
	END IF;

	-- Switch to priority information, if required
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_ID=NEW.matter_ID;
	END IF;

    -- Clear task function
    IF vclear_task THEN
      UPDATE task, event SET task.done=1, task.done_date=NEW.event_date WHERE task.trigger_ID=event.ID AND task.code=vtask AND matter_ID=NEW.matter_ID AND done=0;
      ITERATE create_tasks;
    END IF;

    -- Delete task function
    IF vdelete_task THEN
      DELETE task FROM event INNER JOIN task WHERE task.trigger_ID=event.ID AND task.code=vtask AND matter_ID=NEW.matter_ID;
      ITERATE create_tasks;
    END IF;

    -- Deal with unique tasks: the task should be based on the earliest date if there are several candidates - an existing task will be updated if required
	IF (vunique OR NEW.code='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task, event WHERE event.id=task.trigger_id AND event.matter_ID=NEW.matter_ID AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task, event WHERE event.id=task.trigger_id AND event.matter_ID=NEW.matter_ID AND task.rule_used=vrule_id;
		END IF;
	END IF;

	-- Modify vbase_date for unique task unless a parent or priority filing is used as the base date
    IF (!vuse_parent AND !vuse_priority AND (vunique OR NEW.code='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_ID=NEW.matter_ID AND code=NEW.code;
      IF vbase_date < NEW.event_date THEN
		-- The existing task is right, go to next
        ITERATE create_tasks;
      END IF;
    END IF;

    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	-- Past renewals are due for divisionals, set their due date from the divisional filing date, which should be the currently inserted event
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_ID=NEW.matter_ID) AND vdue_date < NEW.event_date) THEN
		SET vdue_date = NEW.event_date + INTERVAL 4 MONTH;
	END IF;

	-- Go to next task if deadline is past, unless we are setting the expiry date
    IF (vdue_date < Now() AND vtask != 'EXP') THEN
      ITERATE create_tasks;
    END IF;

    IF vtask='EXP' THEN
		UPDATE matter SET expire_date = vdue_date + INTERVAL vpta DAY WHERE matter.ID=NEW.matter_ID;
	ELSEIF vid_uqtask=0 THEN
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency) values (NEW.ID,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency);
	ELSE
		-- Update the existing unique task
		UPDATE task SET trigger_ID=NEW.ID, due_date=vdue_date WHERE ID=vid_uqtask;
	END IF;

  END LOOP create_tasks;
  CLOSE cur_rule;

  SET done = 0;

  IF NEW.code = 'FIL' THEN
	OPEN cur_linked;
	recalc_linked: LOOP
		FETCH cur_linked INTO vid;
		IF done THEN 
			LEAVE recalc_linked; 
		END IF;
		CALL recalculate_tasks(vid, 'FIL');
	END LOOP recalc_linked;
	CLOSE cur_linked;
  END IF;

  -- If the inserted event affects the tasks triggered by the filing date, update those tasks too
  IF NEW.code IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(NEW.matter_ID, 'FIL');
  END IF;

  -- Kill matter upon adding a killer event
  SELECT killer INTO vdead FROM event_name WHERE NEW.code=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead=1 WHERE matter.ID=NEW.matter_ID;
  END IF;

END trig;
DELIMITER ;


-- Add colum uqtrigger
ALTER TABLE `phpip`.`event_name` 
CHANGE COLUMN `is_task` `is_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the event is a task', 
CHANGE COLUMN `status_event` `status_event` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the event should be displayed as a status', 
CHANGE COLUMN `use_matter_resp` `use_matter_resp` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Set if the matter responsible should also be set as responsible for the task. Overridden if default_responsible is set', 
CHANGE COLUMN `unique` `unique` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Only one such event can exist', 
ADD COLUMN `uqtrigger` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Can only be triggered by one event' AFTER `unique`, 
CHANGE COLUMN `killer` `killer` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether this event kills the patent (set patent.dead to 1)' AFTER `uqtrigger`, 
CHANGE COLUMN `notes` `notes` varchar(160) DEFAULT NULL AFTER `killer`, 
CHANGE COLUMN `creator` `creator` char(16) DEFAULT NULL AFTER `notes`, 
CHANGE COLUMN `updated` `updated` timestamp NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER `creator`, 
CHANGE COLUMN `updater` `updater` char(16) DEFAULT NULL AFTER `updated`;



-- Update triggers for adjusting the expire date with PTA days
DROP TRIGGER `matter_before_update`;

DROP TRIGGER `matter_after_update`;
DELIMITER ;;
CREATE TRIGGER `matter_before_update` BEFORE UPDATE ON `matter` FOR EACH ROW BEGIN

set new.updater=SUBSTRING_INDEX(USER(),'@',1);

-- Update expiry date upon changing term extension
IF NEW.term_adjust != OLD.term_adjust THEN
	SET NEW.expire_date = OLD.expire_date + INTERVAL (NEW.term_adjust - OLD.term_adjust) DAY;
END IF;

END;;

CREATE TRIGGER `matter_after_update` AFTER UPDATE ON `matter` FOR EACH ROW BEGIN

-- Propagate updated matter responsible to tasks
IF NEW.responsible != OLD.responsible THEN
	UPDATE task JOIN event ON (task.trigger_id=event.id AND event.matter_id=NEW.id) SET task.assigned_to=NEW.responsible
	WHERE task.done=0 AND task.assigned_to=OLD.responsible;
END IF;

END;
DELIMITER ;