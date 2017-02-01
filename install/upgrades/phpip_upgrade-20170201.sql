-- Change the matter "updated" field also when attached elements are updated

USE `phpip`;

DELIMITER $$

DROP TRIGGER IF EXISTS event_after_insert$$
CREATE DEFINER=`root`@`localhost` TRIGGER `event_after_insert` AFTER INSERT ON `event` FOR EACH ROW trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
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

  SELECT type_code, dead, expire_date, term_adjust INTO vtype, vdead, vexpiry, vpta FROM matter WHERE matter.id=NEW.matter_id;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  
  IF (vdead OR Now() > vexpiry) THEN
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

	
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=NEW.matter_id)) THEN
		ITERATE create_tasks;
	END IF;

	
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;

	
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

    
    IF vclear_task THEN
      UPDATE task, event SET task.done=1, task.done_date=NEW.event_date WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id AND done=0;
      ITERATE create_tasks;
    END IF;

    
    IF vdelete_task THEN
      DELETE task FROM event INNER JOIN task WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id;
      ITERATE create_tasks;
    END IF;

    
	IF (vunique OR NEW.code='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=NEW.matter_id AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=NEW.matter_id AND task.rule_used=vrule_id;
		END IF;
	END IF;

	
    IF (!vuse_parent AND !vuse_priority AND (vunique OR NEW.code='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_id=NEW.matter_id AND code=NEW.code;
      IF vbase_date < NEW.event_date THEN
		
        ITERATE create_tasks;
      END IF;
    END IF;

    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_id=NEW.matter_id) AND vdue_date < NEW.event_date) THEN
		SET vdue_date = NEW.event_date + INTERVAL 4 MONTH;
	END IF;

	
    IF (vdue_date < Now() AND vtask != 'EXP') THEN
      ITERATE create_tasks;
    END IF;

    IF vtask='EXP' THEN
		UPDATE matter SET expire_date = vdue_date + INTERVAL vpta DAY WHERE matter.id=NEW.matter_id;
	ELSEIF vid_uqtask > 0 THEN
		UPDATE task SET trigger_id=NEW.id, due_date=vdue_date WHERE ID=vid_uqtask;
	ELSE
		
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency,assigned_to) values (NEW.id,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency,vresponsible);
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

  
  IF NEW.code IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  
  SELECT killer INTO vdead FROM event_name WHERE NEW.code=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
  END IF;
  
  -- Check that we are not in a nested trigger before updating the matter change time
  IF NEW.code != 'CRE' THEN
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=NEW.matter_ID;
  END IF;

END trig$$
DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS event_after_update$$
CREATE DEFINER=`root`@`localhost` TRIGGER `event_after_update` AFTER UPDATE ON `event` FOR EACH ROW trig: BEGIN

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

    UPDATE task set due_date=vdue_date WHERE ID=vtask_id;

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
  
  UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=NEW.matter_ID;

END trig$$
DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS event_after_delete$$
CREATE DEFINER=`root`@`localhost` TRIGGER `event_after_delete` AFTER DELETE ON `event` FOR EACH ROW BEGIN
	IF OLD.code IN ('PRI','PFIL') THEN
		CALL recalculate_tasks(OLD.matter_id, 'FIL');
	END IF;

	IF OLD.code='FIL' THEN
		UPDATE matter SET expire_date=NULL WHERE matter.id=OLD.matter_id;
	END IF;

	UPDATE matter, event_name SET matter.dead=0 WHERE matter.id=OLD.matter_id AND OLD.code=event_name.code AND event_name.killer=1 
		AND (matter.expire_date > Now() OR matter.expire_date IS NULL)
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_id=OLD.matter_id AND event.code=ename.code AND ename.killer=1);
        
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=OLD.matter_ID;
END$$
DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS malnk_after_insert$$
CREATE DEFINER=`root`@`localhost` TRIGGER `malnk_after_insert` AFTER INSERT ON `matter_actor_lnk` FOR EACH ROW BEGIN
	DECLARE vcli_ann_agt INT DEFAULT NULL;

	-- Delete renewal tasks when the special actor "CLIENT" is set as the annuity agent
	IF NEW.role='ANN' THEN
		SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
		IF NEW.actor_id=vcli_ann_agt THEN
			DELETE task FROM event INNER JOIN task ON task.trigger_id=event.id
			WHERE task.code='REN' AND event.matter_id=NEW.matter_id;
		END IF;
	END IF;

	-- Check that we are not in a nested trigger before updating the matter change time
	IF (SELECT count(1) FROM default_actor WHERE NEW.actor_id = actor_id) = 0 THEN
		UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=NEW.matter_ID;
	END IF;

END$$
DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS matter_actor_lnk_AFTER_UPDATE$$
CREATE DEFINER = `root`@`localhost` TRIGGER `matter_actor_lnk_AFTER_UPDATE` AFTER UPDATE ON `matter_actor_lnk` FOR EACH ROW
BEGIN

	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=NEW.matter_ID;

END$$
DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS matter_actor_lnk_AFTER_DELETE$$
CREATE DEFINER = `root`@`localhost` TRIGGER `matter_actor_lnk_AFTER_DELETE` AFTER DELETE ON `matter_actor_lnk` FOR EACH ROW
BEGIN

	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.ID=OLD.matter_ID;

END$$
DELIMITER ;



-- Event for regularly handling expire dates. Was not exported to the skeleton

USE `phpip`;

DROP EVENT `kill_expired`; 
CREATE DEFINER=`root`@`localhost` EVENT `kill_expired` 
ON SCHEDULE EVERY 1 WEEK 
ON COMPLETION PRESERVE 
DISABLE ON SLAVE 
COMMENT 'Updates the expired status of matters' 
DO INSERT IGNORE INTO `event` (`code`, matter_id, event_date) SELECT 'EXP', matter.id, matter.expire_date FROM matter WHERE expire_date < Now() AND dead=0;

-- Changed trigger to update the 'dead' flag when the matter has expired

DELIMITER $$

DROP TRIGGER IF EXISTS phpip.event_after_insert$$
USE `phpip`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `event_after_insert` AFTER INSERT ON `event` FOR EACH ROW trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
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

  SELECT type_code, dead, expire_date, term_adjust INTO vtype, vdead, vexpiry, vpta FROM matter WHERE matter.id=NEW.matter_id;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  
  IF (vdead) THEN
    LEAVE trig;
  END IF;
  
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

	
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=NEW.matter_id)) THEN
		ITERATE create_tasks;
	END IF;

	
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;

	
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

    
    IF vclear_task THEN
      UPDATE task, event SET task.done=1, task.done_date=NEW.event_date WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id AND done=0;
      ITERATE create_tasks;
    END IF;

    
    IF vdelete_task THEN
      DELETE task FROM event INNER JOIN task WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id;
      ITERATE create_tasks;
    END IF;

    
	IF (vunique OR NEW.code='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=NEW.matter_id AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=NEW.matter_id AND task.rule_used=vrule_id;
		END IF;
	END IF;

	
    IF (!vuse_parent AND !vuse_priority AND (vunique OR NEW.code='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_id=NEW.matter_id AND code=NEW.code;
      IF vbase_date < NEW.event_date THEN
		
        ITERATE create_tasks;
      END IF;
    END IF;

    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_id=NEW.matter_id) AND vdue_date < NEW.event_date) THEN
		SET vdue_date = NEW.event_date + INTERVAL 4 MONTH;
	END IF;

	
    IF (vdue_date < Now() AND vtask != 'EXP') THEN
      ITERATE create_tasks;
    END IF;

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

  
  IF NEW.code IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  
  SELECT killer INTO vdead FROM event_name WHERE NEW.code=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
  END IF;
  
  -- Check that we are not in a nested trigger before updating the matter change time
  IF NEW.code != 'CRE' THEN
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;
  END IF;

END trig$$
DELIMITER ;

