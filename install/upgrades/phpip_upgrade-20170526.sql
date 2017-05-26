USE `phpip`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `event_lnk_list`
AS SELECT
   `event`.`ID` AS `id`,
   `event`.`code` AS `code`,
   `event`.`matter_ID` AS `matter_id`,if(isnull(`event`.`alt_matter_ID`),`event`.`event_date`,
   `lnk`.`event_date`) AS `event_date`,if(isnull(`event`.`alt_matter_ID`),`event`.`detail`,
   `lnk`.`detail`) AS `detail`,
   `matter`.`country` AS `country`
FROM ((`event` left join `event` `lnk` on(((`event`.`alt_matter_ID` = `lnk`.`matter_ID`) and (`lnk`.`code` = 'FIL')))) left join `matter` on((`event`.`alt_matter_ID` = `matter`.`ID`)));

UPDATE `task_rules` set use_priority=1 WHERE id=1;

DROP TRIGGER IF EXISTS `phpip`.`event_after_insert`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `event_after_insert` AFTER INSERT ON `event` FOR EACH ROW trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vcontainer_id, vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
  DECLARE vtask, vtype, vcurrency CHAR(5) DEFAULT NULL;
  DECLARE vdetail, vresponsible VARCHAR(160) DEFAULT NULL;
  DECLARE done, vclear_task, vdelete_task, vend_of_month, vunique, vrecurring, vuse_parent, vuse_priority, vdead BOOLEAN DEFAULT 0;
  DECLARE vcost, vfee DECIMAL(6,2) DEFAULT null;

  
  DECLARE cur_rule CURSOR FOR 
    SELECT task_rules.id, task, clear_task, delete_task, detail, days, months, years, recurring, end_of_month, use_parent, use_priority, cost, fee, currency, task_rules.responsible, event_name.`unique`
    FROM task_rules, event_name, matter
    WHERE NEW.matter_id=matter.id
    AND event_name.code=task
    AND NEW.code=trigger_event
    AND (for_category, ifnull(for_country, matter.country), ifnull(for_origin, matter.origin), ifnull(for_type, matter.type_code))<=>(matter.category_code, matter.country, matter.origin, matter.type_code)
	AND (uqtrigger=0 
		OR (uqtrigger=1 AND NOT EXISTS (SELECT 1 FROM task_rules tr 
		WHERE (tr.task, tr.for_category, tr.for_country)=(task_rules.task, matter.category_code, matter.country) AND tr.trigger_event!=task_rules.trigger_event)))
    AND NOT EXISTS (SELECT 1 FROM event WHERE matter_id=NEW.matter_id AND code=abort_on)
    AND (condition_event IS null OR EXISTS (SELECT 1 FROM event WHERE matter_id=NEW.matter_id AND code=condition_event))
    AND (NEW.event_date < use_before OR use_before IS null)
    AND (NEW.event_date > use_after OR use_after IS null)
    AND active=1;

  
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_id=NEW.matter_id; 

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT container_id, type_code, dead, expire_date, term_adjust INTO vcontainer_id, vtype, vdead, vexpiry, vpta FROM matter WHERE matter.id=NEW.matter_id;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  -- Do not change anything in dead cases
  IF (vdead) THEN
    LEAVE trig;
  END IF;
  
  -- Set matter to "dead" if the expire date has been reached
  IF (!vdead AND Now() > vexpiry) THEN
	UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
    LEAVE trig;
  END IF;

  OPEN cur_rule;
  create_tasks: LOOP
	
	SET vid_uqtask=0;
	SET vbase_date = NEW.event_date;

    FETCH cur_rule INTO vrule_id, vtask, vclear_task, vdelete_task, vdetail, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority, vcost, vfee, vcurrency, vresponsible, vunique;
    IF done THEN 
      LEAVE create_tasks; 
    END IF;

	-- Skip renewal tasks if the client is the annuity agent
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=NEW.matter_id)) THEN
		ITERATE create_tasks;
	END IF;

	IF vuse_parent THEN
	-- Use parent filing date for task deadline calculation, if PFIL event exists
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;

	IF vuse_priority THEN
	-- Use earliest priority date for task deadline calculation, if a PRI event exists
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

    IF vclear_task THEN
    -- Clear the task identified by the rule (do not create anything)
      UPDATE task, event SET task.done=1, task.done_date=NEW.event_date WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id AND done=0;
      ITERATE create_tasks;
    END IF;

    IF (vdelete_task AND vcontainer_id IS NOT NULL) THEN
    -- Delete the task identified by the rule, only if the matter is a new family member (do not create anything)
      DELETE task FROM event INNER JOIN task WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id;
      ITERATE create_tasks;
    END IF;

    -- If the new event is unique or the event is a priority claim, retrieve a similar event if it already exists 
	IF (vunique OR NEW.code='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task JOIN event ON event.id=task.trigger_id WHERE event.matter_id=NEW.matter_id AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task JOIN event ON event.id=task.trigger_id WHERE event.matter_id=NEW.matter_id AND task.rule_used=vrule_id;
		END IF;
	END IF;

	-- If the unique event or a priority claim already exists and its date is earlier than the new date, do nothing. If its date is later than the new date, proceed with the new date
    IF (!vuse_parent AND !vuse_priority AND (vunique OR NEW.code='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_id=NEW.matter_id AND code=NEW.code;
      IF vbase_date < NEW.event_date THEN	
        ITERATE create_tasks;
      END IF;
    END IF;

	-- Calculate the deadline
    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	-- Dealine for renewals that have become due in a parent case when filing a divisional (EP 4-months rule)
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_id=NEW.matter_id) AND vdue_date < NEW.event_date) THEN
		SET vdue_date = NEW.event_date + INTERVAL 4 MONTH;
	END IF;

	-- Skip creating tasks having a deadline in the past, except if the event is the expiry
    IF (vdue_date < Now() AND vtask != 'EXP') THEN
      ITERATE create_tasks;
    END IF;

	-- Handle the expiry task (no task created). Otherwise replace an existing unique task with the current (unique) task, or insert the new (non-unique) task
    IF vtask='EXP' THEN
		UPDATE matter SET expire_date = vdue_date + INTERVAL vpta DAY WHERE matter.id=NEW.matter_id;
	ELSEIF vid_uqtask > 0 THEN
		UPDATE task SET trigger_id=NEW.id, due_date=vdue_date WHERE id=vid_uqtask;
	ELSE
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency,assigned_to) values (NEW.id,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency,vresponsible);
	END IF;

  END LOOP create_tasks;
  CLOSE cur_rule;

  SET done = 0;

  -- If the event is a filing, update the tasks of the matters linked by event (typically the tasks based on the priority date)
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

  -- Recalculate tasks based on the priority date or a parent case upon inserting a new priority claim or a parent filed event
  IF NEW.code IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  -- Set matter to dead upon inserting a killer event
  SELECT killer INTO vdead FROM event_name WHERE NEW.code=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
  END IF;
  
  -- Ensure that we are not in a nested trigger before updating the matter change time
  IF NEW.code != 'CRE' THEN
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;
  END IF;

END trig$$
DELIMITER ;

DROP TRIGGER IF EXISTS `phpip`.`event_after_update`;

DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `event_after_update` AFTER UPDATE ON `event` FOR EACH ROW trig: BEGIN

  DECLARE vdue_date, vbase_date DATE DEFAULT NULL;
  DECLARE vtask_id, vdays, vmonths, vyears, vrecurring, vpta, vid INT DEFAULT NULL;
  DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
  DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

  
  DECLARE cur_rule CURSOR FOR
    SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
    FROM task_rules, task
    WHERE task.rule_used=task_rules.id
	AND task.trigger_id=NEW.id;

  
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_id=NEW.matter_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  
  IF (OLD.event_date = NEW.event_date AND NEW.alt_matter_id <=> OLD.alt_matter_id) THEN
    LEAVE trig;
  END IF;

  SET vbase_date=NEW.event_date;

  OPEN cur_rule;
  
  update_tasks: LOOP
    FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
    IF done THEN 
      LEAVE update_tasks; 
    END IF;
	
	
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;
	
	
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

	
    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

    UPDATE task set due_date=vdue_date WHERE id=vtask_id;

  END LOOP update_tasks;
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
		CALL recalculate_tasks(vid, 'PRI');
	  END LOOP recalc_linked;
	  CLOSE cur_linked;
  END IF;

  
  IF NEW.code IN ('PRI', 'PFIL') THEN  
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  IF NEW.code IN ('FIL', 'PFIL') THEN  
	
    SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.id=NEW.matter_id;
    SELECT months, years INTO vmonths, vyears FROM task_rules 
		WHERE task='EXP' 
		AND for_category=vcategory 
		AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
    SELECT IFNULL(min(event_date), NEW.event_date) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
    SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    UPDATE matter SET expire_date=vdue_date WHERE matter.id=NEW.matter_id;
  END IF;
  
  UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;

END trig$$
DELIMITER ;

DROP TRIGGER IF EXISTS `phpip`.`event_after_delete`;

DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `event_after_delete` AFTER DELETE ON `event` FOR EACH ROW BEGIN
	IF OLD.code IN ('PRI','PFIL') THEN
		CALL recalculate_tasks(OLD.matter_id, 'FIL');
	END IF;

	IF OLD.code='FIL' THEN 
		UPDATE matter SET expire_date=NULL WHERE matter.id=OLD.matter_id;
	END IF;

	UPDATE matter, event_name SET matter.dead=0 WHERE matter.id=OLD.matter_id AND OLD.code=event_name.code AND event_name.killer=1 
		AND (matter.expire_date > Now() OR matter.expire_date IS NULL)
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_id=OLD.matter_id AND event.code=ename.code AND ename.killer=1);
        
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=OLD.matter_id;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `phpip`.`task_before_update`;

DELIMITER $$
CREATE DEFINER=`root`@`%` TRIGGER `task_before_update` BEFORE UPDATE ON `task` FOR EACH ROW
BEGIN
	SET NEW.updater=SUBSTRING_INDEX(USER(),'@',1);
	IF NEW.done_date IS NOT NULL AND OLD.done_date IS NULL AND OLD.done = 0 THEN
		SET NEW.done = 1;
	END IF;
	IF NEW.done_date IS NULL AND OLD.done_date IS NOT NULL AND OLD.done = 1 THEN
		SET NEW.done = 0;
	END IF; 
	IF NEW.done = 1 AND OLD.done = 0 AND OLD.done_date IS NULL THEN
		SET NEW.done_date = Least(OLD.due_date, Now());
	END IF;
	IF NEW.done = 0 AND OLD.done = 1 AND OLD.done_date IS NOT NULL THEN
		SET NEW.done_date = NULL;
	END IF;
	/*IF NEW.due_date != OLD.due_date AND old.rule_used IS NOT NULL THEN
		SET NEW.rule_used = NULL;
	END IF;*/
END$$
DELIMITER ;
