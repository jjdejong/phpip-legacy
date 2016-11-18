-- Add foreign key to task_rules.for_category and fix wrong for_category values to allow adding this key

update task_rules set for_category='OP' where for_category='POP';

ALTER TABLE `phpip`.`task_rules` 
ADD CONSTRAINT `fk_category`
  FOREIGN KEY (for_category)
  REFERENCES `phpip`.`matter_category` (code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;