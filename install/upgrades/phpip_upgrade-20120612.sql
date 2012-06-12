-- Update cost and fee for all pending tasks, not just the future ones
DROP TRIGGER trules_after_update;
DELIMITER ;;
CREATE TRIGGER trules_after_update AFTER UPDATE ON task_rules FOR EACH ROW BEGIN	
	IF (NEW.fee != OLD.fee OR NEW.cost != OLD.cost) THEN
		UPDATE task SET fee=NEW.fee, cost=NEW.cost WHERE rule_used=NEW.id AND done=0;
	END IF;
END;;
DELIMITER ;

-- Add idx, container_id and dead fields to view
CREATE OR REPLACE ALGORITHM = UNDEFINED DEFINER = root@localhost SQL SECURITY DEFINER VIEW phpip.filing_info AS 
select matter.ID, matter.caseref, matter.country, matter.origin,
matter.type_code, matter.idx, matter.container_id, matter.dead,
event.event_date AS filing_date,
event.detail AS filing_number 
from (matter join event) 
where ((matter.ID = event.matter_ID) and (event.code = 'FIL') and (matter.category_code = 'PAT'));

-- Add container_id and dead fields to view
CREATE OR REPLACE ALGORITHM = UNDEFINED DEFINER = root@localhost SQL SECURITY DEFINER VIEW phpip.event_list AS 
select event.ID, event_name.status_event, event.code,
event_name.name, event.event_date, event.detail,
matter.ID AS matter_ID, matter.caseref, matter.country, matter.origin,
matter.type_code, matter.idx, matter.container_id, matter.dead 
from ((matter join event) join event_name) 
where ((event.matter_ID = matter.ID) and (event.code = event_name.code)) order by matter.ID;

-- Set default display_order value to 1 instead of NULL
update classifier set display_order=1 where display_order is null;
ALTER TABLE phpip.classifier CHANGE COLUMN display_order display_order tinyint(4) NOT NULL DEFAULT '1';

-- Fix event delete trigger
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
	UPDATE matter, event_name SET matter.dead=0 WHERE matter.ID=OLD.matter_ID AND OLD.code=event_name.code AND event_name.killer=1 AND matter.expire_date > Now()
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_ID=OLD.matter_ID AND event.code=ename.code AND ename.killer=1);
END;;
DELIMITER ;