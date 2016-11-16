ALTER TABLE `phpip`.`task` 
ADD INDEX `trigger_id` (`trigger_ID` ASC),
DROP INDEX `uqtask` ;
