ALTER SCHEMA `phpip`  DEFAULT CHARACTER SET utf8;

DROP PROCEDURE IF EXISTS `recalculate_tasks_from_filed`;
DROP PROCEDURE IF EXISTS `recalculate_tasks`;

DROP TABLE IF EXISTS `User`;

DELIMITER ;;

CREATE DEFINER = `root`@`localhost` PROCEDURE `phpip`.`recalculate_tasks`(IN Pmatter_ID int, IN Ptrig_code char(5))
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
proc: BEGIN
	DECLARE vtrigevent_date, vdue_date, vbase_date DATE DEFAULT NULL;
	DECLARE vtask_id, vtrigevent_id, vdays, vmonths, vyears, vrecurring, vpta INT DEFAULT NULL;
	DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
	DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

	DECLARE cur_rule CURSOR FOR 
		SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
		FROM task_rules, task
		WHERE task.rule_used=task_rules.ID
		AND task.trigger_ID=vtrigevent_id;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	IF EXISTS (SELECT 1 FROM event_lnk_list WHERE matter_ID=Pmatter_ID AND code=Ptrig_code) THEN
		SELECT ID, event_date INTO vtrigevent_id, vtrigevent_date FROM event_lnk_list WHERE matter_ID=Pmatter_ID AND code=Ptrig_code;
	ELSE
		-- No such trigger event in matter - leave
		LEAVE proc;
	END IF;

	OPEN cur_rule;
	update_tasks: LOOP
		FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
		IF done THEN 
			LEAVE update_tasks; 
		END IF;

		-- Switch to parent information, if required
		IF vuse_parent THEN
			SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=Pmatter_ID;
		ELSE
			SET vbase_date=vtrigevent_date;
		END IF;

		-- Switch to priority information, if required
		IF vuse_priority THEN
			SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_ID=Pmatter_ID;
		END IF;

		SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
		IF vend_of_month THEN
			SET vdue_date=LAST_DAY(vdue_date);
		END IF;

		UPDATE task set due_date=vdue_date WHERE task.ID=vtask_id;
		
	END LOOP update_tasks;
	CLOSE cur_rule;
  
	-- Update expiry date according to the category of the matter
	IF Ptrig_code = 'FIL' THEN
		SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.ID=Pmatter_ID;
		SELECT months, years INTO vmonths, vyears FROM task_rules 
			WHERE task='EXP' 
			AND for_category=vcategory 
			AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
		SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=Pmatter_ID;
		SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
		UPDATE matter SET expire_date=vdue_date WHERE matter.ID=Pmatter_ID AND IFNULL(expire_date, '0000-00-00') != vdue_date;
	END IF;

END proc;;


DROP TRIGGER `event_before_insert`;;

DROP TRIGGER `event_after_insert`;;

DROP TRIGGER `event_before_update`;;

DROP TRIGGER `event_after_update`;;

DROP TRIGGER `event_after_delete`;;


CREATE TRIGGER `event_before_insert` BEFORE INSERT ON `event` FOR EACH ROW BEGIN
	DECLARE vdate DATE DEFAULT NULL;

	SET new.creator = SUBSTRING_INDEX(USER(),'@',1);
	
	-- Update the normally empty event_date for linked events
	IF NEW.alt_matter_ID IS NOT NULL THEN
		IF EXISTS (SELECT 1 FROM event WHERE code='FIL' AND NEW.alt_matter_ID=matter_ID AND event_date IS NOT NULL) THEN
			SELECT event_date INTO vdate FROM event WHERE code='FIL' AND NEW.alt_matter_ID=matter_ID;
			SET NEW.event_date = vdate;
		ELSE
			SET NEW.event_date = Now();
		END IF;
	END IF;
END;;

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
    AND (matter.category_code=for_category OR (for_category IS null AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND tr.trigger_event=NEW.code AND for_category=matter.category_code)))
    AND (matter.country=for_country OR (for_country IS null AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND tr.trigger_event=NEW.code AND for_country=matter.country)))
	AND (matter.origin=for_origin OR (for_origin IS null AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND tr.trigger_event=NEW.code AND for_origin=matter.origin)))
    AND (matter.type_code=for_type OR (for_type IS null AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND tr.trigger_event=NEW.code AND for_type=matter.type_code)))
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

END trig;;

CREATE TRIGGER `event_before_update` BEFORE UPDATE ON `event` FOR EACH ROW BEGIN
	DECLARE vdate DATE DEFAULT NULL;

	SET new.updater=SUBSTRING_INDEX(USER(),'@',1);
	-- Update the event_date for linked events (overriding any undesired manual change)
	IF NEW.alt_matter_ID IS NOT NULL THEN
		SELECT event_date INTO vdate FROM event WHERE code='FIL' AND NEW.alt_matter_ID=matter_ID;
		SET NEW.event_date = vdate;
	END IF;
END;;

CREATE TRIGGER `event_after_update` AFTER UPDATE ON `event` FOR EACH ROW trig: BEGIN

  DECLARE vdue_date, vbase_date DATE DEFAULT NULL;
  DECLARE vtask_id, vdays, vmonths, vyears, vrecurring, vpta, vid INT DEFAULT NULL;
  DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
  DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

  -- Cursor identifying tasks dependant on the current event
  DECLARE cur_rule CURSOR FOR 
    SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
    FROM task_rules, task
    WHERE task.rule_used=task_rules.ID
	AND task.trigger_ID=NEW.ID;

  -- Cursor identifying matters linked to the current event
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_ID=NEW.matter_ID;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- Do nothing if date hasn't changed
  IF (OLD.event_date = NEW.event_date AND NEW.alt_matter_ID <=> OLD.alt_matter_ID) THEN
    LEAVE trig;
  END IF;

  SET vbase_date=NEW.event_date;

  OPEN cur_rule;
  -- Fetch applicable rules
  update_tasks: LOOP
    FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
    IF done THEN 
      LEAVE update_tasks; 
    END IF;
	
	-- Switch to parent information, if required
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=NEW.matter_ID;
	END IF;
	
	-- Switch to priority information, if required
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_ID=NEW.matter_ID;
	END IF;

	-- Calculate deadline according to current rule of cur_rule, and update corresponding task
    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

    UPDATE task set due_date=vdue_date WHERE ID=vtask_id;

  END LOOP update_tasks;
  CLOSE cur_rule;

  SET done = 0;
 
  -- Now deal with the tasks in the matters linked to the matter of the currently updated (Filed) event
  IF NEW.code = 'FIL' THEN
	  OPEN cur_linked;
	  recalc_linked: LOOP
		FETCH cur_linked INTO vid;
		IF done THEN 
		  LEAVE recalc_linked; 
		END IF;
		CALL recalculate_tasks(vid, 'FIL');
		CALL recalculate_tasks(vid, 'PRI');
	  END LOOP recalc_linked;
	  CLOSE cur_linked;
  END IF;

  -- If the updated event affects the tasks triggered by the filing date, update those tasks too
  IF NEW.code IN ('PRI', 'PFIL') THEN  
    CALL recalculate_tasks(NEW.matter_ID, 'FIL');
  END IF;

  IF NEW.code IN ('FIL', 'PFIL') THEN  
	-- Update expiry date according to the category of the matter
    SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.ID=NEW.matter_ID;
    SELECT months, years INTO vmonths, vyears FROM task_rules 
		WHERE task='EXP' 
		AND for_category=vcategory 
		AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
    SELECT IFNULL(min(event_date), NEW.event_date) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=NEW.matter_ID;
    SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    UPDATE matter SET expire_date=vdue_date WHERE matter.ID=NEW.matter_ID;
  END IF;

END trig;;

CREATE TRIGGER `event_after_delete` AFTER DELETE ON `event` FOR EACH ROW BEGIN
	IF OLD.code IN ('PRI','PFIL') THEN
		CALL recalculate_tasks_from_filed(OLD.matter_ID);
	END IF;

	IF OLD.code='FIL' THEN
		UPDATE matter SET expire_date=NULL WHERE matter.ID=OLD.matter_ID;
	END IF;

	-- Unkill matter upon deleting a killer event
	UPDATE matter, event_name SET matter.dead=0 WHERE matter.ID=OLD.matter_ID AND OLD.code=event_name.code AND event_name.killer=1 AND matter.expire_date > Now()
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_ID=OLD.matter_ID AND event.code=ename.code AND ename.killer=1);
END;;