CREATE OR REPLACE 
	ALGORITHM = UNDEFINED 
	DEFINER = `root`@`localhost` 
	SQL SECURITY DEFINER 
VIEW `matter_status_list` AS
    select 
        `e1`.`matter_ID` AS `matter_id`,
        `fil`.`event_date` AS `event_date`,
        `en1`.`name` AS `status`,
        `e1`.`event_date` AS `status_date`,
        `matter`.`dead` AS `dead`
    from
        ((((`event` `e1`
        join `event_name` `en1` ON (((`en1`.`code` = `e1`.`code`)
            and (`en1`.`status_event` = 1))))
        join `matter` ON ((`matter`.`ID` = `e1`.`matter_ID`)))
        left join (`event` `e2`
        join `event_name` `en2`) ON (((`e2`.`code` = `en2`.`code`)
            and (`en2`.`status_event` = 1)
            and (`e1`.`matter_ID` = `e2`.`matter_ID`)
            and (`e1`.`event_date` < `e2`.`event_date`))))
        left join `event` `fil` ON (((`e1`.`matter_ID` = `fil`.`matter_ID`)
            and (`fil`.`code` = 'FIL'))))
    where
        isnull(`e2`.`matter_ID`);

-- Added "category" to view
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `task_list` AS
    select 
        `task`.`ID` AS `ID`,
        `task`.`code` AS `code`,
        `event_name`.`name` AS `name`,
        `task`.`detail` AS `detail`,
        `task`.`due_date` AS `due_date`,
        `task`.`done` AS `done`,
        `task`.`done_date` AS `done_date`,
        `event`.`matter_ID` AS `matter_ID`,
        `task`.`cost` AS `cost`,
        `task`.`fee` AS `fee`,
        `task`.`trigger_ID` AS `trigger_ID`,
		`matter`.`category_code` AS `category`,
        `matter`.`caseref` AS `caseref`,
        `matter`.`country` AS `country`,
        `matter`.`origin` AS `origin`,
        `matter`.`type_code` AS `type_code`,
        `matter`.`idx` AS `idx`,
        ifnull(`task`.`assigned_to`,
                `matter`.`responsible`) AS `responsible`,
        `actor`.`login` AS `delegate`,
        `task`.`rule_used` AS `rule_used`,
        `matter`.`dead` AS `dead`
    from
        (((((`matter`
        left join `matter_actor_lnk` ON (((ifnull(`matter`.`container_ID`, `matter`.`ID`) = `matter_actor_lnk`.`matter_ID`)
            and (`matter_actor_lnk`.`role` = 'DEL'))))
        left join `actor` ON ((`actor`.`ID` = `matter_actor_lnk`.`actor_ID`)))
        join `event` ON ((`matter`.`ID` = `event`.`matter_ID`)))
        join `task` ON ((`task`.`trigger_ID` = `event`.`ID`)))
        join `event_name` ON ((`task`.`code` = `event_name`.`code`)));

-- Added "category" to view
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `event_list` AS
    select 
        `event`.`ID` AS `event_ID`,
        `event_name`.`status_event` AS `status_event`,
        `event`.`code` AS `code`,
        `event_name`.`name` AS `name`,
        `event`.`event_date` AS `event_date`,
        `event`.`detail` AS `detail`,
        `matter`.`ID` AS `matter_ID`,
        `matter`.`caseref` AS `caseref`,
        `matter`.`country` AS `country`,
        `matter`.`origin` AS `origin`,
		`matter`.`category_code` AS `category`,
        `matter`.`type_code` AS `type_code`,
        `matter`.`idx` AS `idx`,
        `matter`.`container_ID` AS `container_id`,
        `matter`.`dead` AS `dead`
    from
        ((`matter`
        join `event`)
        join `event_name`)
    where
        ((`event`.`matter_ID` = `matter`.`ID`)
            and (`event`.`code` = `event_name`.`code`))
    order by `matter`.`ID`;

-- Added "category" to view

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `matter_actor_list` AS
    select 
        `lnk`.`ID` AS `lnk_id`,
        `actor`.`ID` AS `actor_id`,
        `actor`.`display_name` AS `display_name`,
        `actor`.`name` AS `name`,
        `actor`.`first_name` AS `first_name`,
        `lnk`.`role` AS `role`,
        `actor_role`.`name` AS `role_full`,
        `matter`.`ID` AS `matter_id`,
        `matter`.`caseref` AS `caseref`,
		`matter`.`category_code` AS `category`,
        `matter`.`country` AS `country`,
        `matter`.`origin` AS `origin`,
        `matter`.`type_code` AS `type_code`,
        `matter`.`idx` AS `idx`,
        `lnk`.`actor_ref` AS `actor_ref`,
        `co`.`name` AS `company`,
        if((`lnk`.`matter_ID` = `matter`.`container_ID`),
            1,
            0) AS `inherited`
    from
        ((((`matter`
        join `matter_actor_lnk` `lnk` ON (((`lnk`.`matter_ID` = `matter`.`ID`)
            or ((`lnk`.`shared` = 1)
            and (`lnk`.`matter_ID` = `matter`.`container_ID`)))))
        join `actor` ON ((`lnk`.`actor_ID` = `actor`.`ID`)))
        left join `actor` `co` ON ((`co`.`ID` = `lnk`.`company_ID`)))
        join `actor_role` ON ((`lnk`.`role` = `actor_role`.`code`)))
    order by `matter`.`ID` , `lnk`.`role`

-- Fix base date calculation error in task creation after the base date was changed in loop. Fix tasks having null for_country not showing in some situations
DELIMITER $$

DROP TRIGGER IF EXISTS phpip.event_after_insert$$
USE `phpip`$$
CREATE TRIGGER `event_after_insert` AFTER INSERT ON event FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
  DECLARE vtask, vtype, vcurrency CHAR(5) DEFAULT NULL;
  DECLARE vdetail, vresponsible VARCHAR(160) DEFAULT NULL;
  DECLARE done, vclear_task, vdelete_task, vend_of_month, vunique, vrecurring, vuse_parent, vuse_priority, vdead BOOLEAN DEFAULT 0;
  DECLARE vcost, vfee DECIMAL(6,2) DEFAULT null;

  -- Cursor for selecting all the rules that apply 
  DECLARE cur_rule CURSOR FOR 
    SELECT task_rules.id, task, clear_task, delete_task, detail, days, months, years, recurring, end_of_month, use_parent, use_priority, cost, fee, currency, task_rules.responsible, event_name.unique
    FROM task_rules, event_name, matter
    WHERE NEW.matter_ID=matter.ID
    AND event_name.code=task
    AND NEW.code=trigger_event
    AND (for_category, ifnull(for_country, matter.country), ifnull(for_origin, matter.origin), ifnull(for_type, matter.type_code))<=>(matter.category_code, matter.country, matter.origin, matter.type_code)
	AND (uqtrigger=0 
		OR (uqtrigger=1 AND NOT EXISTS (SELECT 1 FROM task_rules tr 
		WHERE (tr.task, tr.for_category, tr.for_country)=(task_rules.task, matter.category_code, matter.country) AND tr.trigger_event!=task_rules.trigger_event)))
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

  OPEN cur_rule;
  create_tasks: LOOP
	-- Reset reusable variables
	SET vid_uqtask=0;
	SET vbase_date = NEW.event_date;

    FETCH cur_rule INTO vrule_id, vtask, vclear_task, vdelete_task, vdetail, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority, vcost, vfee, vcurrency, vresponsible, vunique;
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
	ELSEIF vid_uqtask > 0 THEN
		UPDATE task SET trigger_ID=NEW.ID, due_date=vdue_date WHERE ID=vid_uqtask;
	ELSE
		-- Update the existing unique task
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency,assigned_to) values (NEW.ID,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency,vresponsible);
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

END trig
$$
DELIMITER ;


-- Updated trigger for using the matter responsible when responsible=0 in task_rules
DELIMITER $$

DROP TRIGGER IF EXISTS phpip.task_before_insert$$
USE `phpip`$$
CREATE TRIGGER `task_before_insert` BEFORE INSERT ON task FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN

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
	ELSEIF NEW.assigned_to = '0' THEN
		SET NEW.assigned_to = vresp;
	END IF;

END
$$
DELIMITER ;


-- Set "for_category" as non null and "recurring" as boolean
ALTER TABLE `phpip`.`task_rules` 
CHANGE COLUMN `for_category` `for_category` CHAR(5) NOT NULL DEFAULT 'PAT' COMMENT 'Category to which this rule applies.'  , 
CHANGE COLUMN `recurring` `recurring` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'If non zero, indicates the recurring period in months. Mainly for annuities'  ;

ALTER TABLE `phpip`.`task_rules` CHANGE COLUMN `warn_text` `responsible` CHAR(16) NULL DEFAULT NULL COMMENT 'The person (login) responsible for this task. If 0, insert the matter responsible.'  ;



