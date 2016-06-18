-- This field was not used. Changing it for warning purposes, such as bad payor
ALTER TABLE `phpip`.`actor` 
CHANGE COLUMN `pay_category` `warn` TINYINT(1) NULL DEFAULT 0 COMMENT 'The actor will be displayed in red in the matter view when set' ;
