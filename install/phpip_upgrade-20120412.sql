-- Changes since 2012-02-02

-- Fix task_list view (status not showing when the last event happened to be a non-status event)
CREATE OR REPLACE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER VIEW `phpip`.`matter_status_list` 
AS SELECT e1.matter_id,
en1.name AS status,
e1.event_date AS status_date 
FROM event e1 JOIN event_name en1 ON (en1.code = e1.code AND en1.status_event = 1) 
LEFT JOIN (event e2, event_name en2) ON (e2.code=en2.code AND en2.status_event=1 AND e1.matter_id=e2.matter_id AND e1.event_date < e2.event_date)
WHERE e2.matter_ID IS NULL;

-- Provide authentication information in the actor table instead of the User table
ALTER TABLE actor ADD COLUMN password varchar(32) DEFAULT NULL AFTER login, 
ADD COLUMN password_salt varchar(32) DEFAULT NULL AFTER password, 
ADD COLUMN last_login datetime DEFAULT NULL AFTER password_salt;

-- Migrate the information from the User table to the actor table
update actor join User on (User.username=actor.login) set actor.password=User.Password, actor.password_salt=User.PasswordSalt, actor.last_login=User.LastLogin; 

-- Update privileges of the system user "phpip"
REVOKE Update (LastLogin) ON TABLE User FROM `phpip`@`localhost`;
REVOKE Update ON TABLE User FROM `phpip`@`localhost`;
GRANT Update (last_login) ON TABLE actor TO `phpip`@`localhost`;

-- drop table User;