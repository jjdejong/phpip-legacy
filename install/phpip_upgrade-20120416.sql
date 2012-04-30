/*!50003 DROP PROCEDURE IF EXISTS `recalculate_tasks_from_filed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `recalculate_tasks_from_filed`(IN Pmatter_ID int)
proc: BEGIN
  DECLARE vfiled_date, vdue_date, vbase_date DATE DEFAULT NULL;
  DECLARE vtask_id, vfiled_id, vdays, vmonths, vyears, vrecurring, vpta INT DEFAULT NULL;
  DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
  DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

  DECLARE cur_rule CURSOR FOR 
    SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
    FROM task_rules, task
    WHERE task.rule_used=task_rules.ID
	AND task.trigger_ID=vfiled_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT ID, event_date INTO vfiled_id, vfiled_date FROM event_lnk_list WHERE matter_ID=Pmatter_ID AND code IN ('FIL', 'PRI');
  IF vfiled_id IS NULL THEN
    LEAVE proc;
  END IF;

  OPEN cur_rule;
  update_tasks: LOOP
    FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
    IF done THEN 
      LEAVE update_tasks; 
    END IF;
    
    IF vuse_parent THEN
      SELECT CAST(IFNULL(min(event_date), vfiled_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=Pmatter_ID;
    ELSE
      SET vbase_date=vfiled_date;
    END IF;
    
    IF vuse_priority THEN
      SELECT CAST(IFNULL(min(event_date), vfiled_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_ID=Pmatter_ID;
    END IF;

    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	UPDATE task set due_date=vdue_date WHERE task.ID=vtask_id;
		
  END LOOP update_tasks;
  CLOSE cur_rule;
  
  SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.ID=Pmatter_ID;
  SELECT months, years INTO vmonths, vyears FROM task_rules 
	WHERE task='EXP' 
	AND for_category=vcategory 
	AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
  SELECT CAST(IFNULL(min(event_date), vfiled_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_ID=Pmatter_ID;
  SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
  UPDATE matter SET expire_date=vdue_date WHERE matter.ID=Pmatter_ID AND expire_date != vdue_date;   

END proc */;;
DELIMITER ;