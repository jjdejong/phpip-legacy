<?php

class Application_Model_DbTable_Rule extends Zend_Db_Table_Abstract
{
    protected $_name = 'task_rules';
    protected $_primary = 'ID';

        /**
         * retrieves column comments defined for a table
         * *
         */
        public function getTableComments($table_name = null) {
                if (! isset ( $table_name )) {
                        return false;
                }
                
                $infoDb = $this->getInfoDb ();
                $db_detail = $this->getAdapter ()->getConfig ();
                $query = "select column_name, column_comment from columns where table_schema='" . $db_detail ["dbname"] . "' AND table_name='" . $table_name . "'";
                $result = $infoDb->fetchAll ( $query );
                $comments = array ();
                foreach ( $result as $row ) {
                        $col_name = $row ['column_name'];
                        $comments ["$col_name"] = $row ['column_comment'];
                }
                return $comments;
        }
        
        public function getInfoDb() {
                //$this->setDbTable ( 'Application_Model_DbTable_Rule' );
                $db_detail = $this->getAdapter ()->getConfig ();
                
                $db = new Zend_Db_Adapter_Pdo_Mysql ( array (
                                'host' => $db_detail ["host"],
                                'username' => $db_detail ["username"],
                                'password' => $db_detail ["password"],
                                'dbname' => 'information_schema' 
                ) );
                return $db;
        }
    
        public function getRuleInfo($rule_id = 0) {
                if (! $rule_id)
                        return null;
                $this->getAdapter ()->query ( 'SET NAMES utf8' );
                $select = $this->select ()->from ( array (
                                'r' => 'task_rules' 
                ), array (
                                'rule_id' =>'r.id',
                                'task' =>'r.task',
                                'active' => 'r.active',
                                'for_category' =>'r.for_category',
                                'for_country' => 'r.for_country',
                                'for_origin' => 'r.for_origin',
                                'for_type' => 'r.for_type',
                                'detail' => 'r.detail',
                                'clear_task' =>'r.clear_task',
                                'delete_task' =>'r.delete_task',
                                'use_parent' => 'r.use_parent',
                                'use_before' => 'r.use_before',
                                'use_after' => 'r.use_after',
                                'use_priority' => 'r.use_priority',
                                'notes' => 'r.notes',
                                'days' =>'r.days' ,
                                'months' =>'r.months' ,
                                'years' =>'r.years' ,
                                'recurring' =>'r.recurring' ,
                                'end_of_month' =>'r.end_of_month' ,
                                'abort_on' =>'r.abort_on' ,
                                'condition_event' =>'r.condition_event' ,
                                'cost' =>'r.cost',
                                'fee' =>'r.fee',
                                'currency' =>'r.currency' ,
                                'responsible' =>'r.responsible' 
                ) )->joinLeft ( array (
                                'c' => 'country' 
                ), 'r.for_country = c.iso', array (
                                'country_name' => 'c.name' 
                ) )->joinLeft ( array (
                                'o' => 'country' 
                ), 'o.iso = r.for_origin', array (
                                'origin_name' => 'o.name' 
                ) )->joinLeft ( array (
                                'mc' => 'matter_category' 
                ), 'mc.code = r.for_category', array (
                                'category_name' => 'mc.category' 
                ) )->joinLeft ( array (
                                'en' => 'event_name' 
                ), 'en.code = r.trigger_event', array (
                                'trigger_event_name' => 'en.name' 
                ) )->joinLeft ( array (
                                'tn' => 'event_name' 
                ), 'tn.code = r.task', array (
                                'task_name' => 'tn.name' 
                ) )->joinLeft ( array (
                                'cn' => 'event_name' 
                ), 'cn.code = r.condition_event', array (
                                'condition_event_name' => 'cn.name' 
                ) )->joinLeft ( array (
                                'an' => 'event_name' 
                ), 'an.code = r.abort_on', array (
                                'abort_on_name' => 'an.name' 
                ) )->joinLeft ( array (
                                'a' => 'actor' 
                ), 'a.id = r.responsible', array (
                                'responsible_name' => 'a.login' 
                ) )->joinLeft ( array (
                                'mt' => 'matter_type' 
                ), 'mt.code = r.for_type', array (
                                'for_type_name' => 'mt.type' 
                ) )->where ( 'r.ID = ?', $rule_id )->setIntegrityCheck ( false );
                return $this->fetchRow ( $select )->toArray ();
        }

        /**
         * retrieves paginated/unpaginated list of rules with specified filters
         */
        public function fetchRules( 
                        $filter_array,
                        $sortField = 'r.task', 
                        $sortDir = '', 
                        $multi_filter = array(), 
                        $matter_category_display_type = false, 
                        $paginated = false ) {
                
                $siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
                $userid = $siteInfoNamespace->userId;
                $role = $siteInfoNamespace->role;
                
                $sql = "SELECT r.ID AS rule_id,
                        r.task AS task,
                        r.active AS active,
                        r.trigger_event AS trigger_event,
                        r.clear_task AS clear_task,
                        r.delete_task  AS delete_task,
                        r.for_category AS category,
                        r.for_country AS country,
                        r.for_origin AS origin,
                        r.for_type AS f_type,
                        r.detail AS detail,
                        r.days AS days,
                        r.months AS months,
                        r.years AS years,
                        r.recurring AS recurring,
                        r.end_of_month AS end_of_month,
                        r.abort_on AS abort_on,
                        r.condition_event AS condition_event,
                        r.use_parent AS use_parent,
                        r.use_priority AS use_priority,
                        r.use_before AS use_before,
                        r.use_after AS use_after,
                        r.cost AS cost,
                        r.currency AS currency,
                        r.responsible AS responsible,
                        r.notes   AS notes,
                        c.name AS country_name,
                        mc.category AS category_name,
                        o.name AS origin_name,
                        an.name AS abort_on_name,
                        en.name AS trigger_event_name,
                        tn.name AS task_name

                        FROM task_rules AS r
                        LEFT JOIN country AS c ON r.for_country = c.iso 
                        LEFT JOIN country AS o ON r.for_origin = o.iso 
                        LEFT JOIN event_name AS en ON r.trigger_event = en.code 
                        LEFT JOIN event_name AS tn ON r.task = tn.code 
                        LEFT JOIN event_name AS an ON r.abort_on = an.code
                        LEFT JOIN matter_category AS mc ON r.for_category = mc.code ";
                
                $where_clause = '';
                
                $having_clause = '';
                if (! empty ( $multi_filter )) {
                        foreach ( $multi_filter as $key => $value ) {
                                if ($value != '' && $key != 'display' && $key != 'display_style') {
                                        if ($having_clause == '')
                                                $having_clause = "HAVING ";
                                        else
                                                $having_clause .= "AND ";
                                        if ($key == 'responsible')
                                                $having_clause .= "(responsible = '$value' ) ";
                                        else
                                                $having_clause .= "$key LIKE '$value%' ";
                                }
                        }
                }
                
                if ($sortField == 'task') {
                        if ($sortDir == 'desc') {
                                $sortField = 'task DESC, for_category, for_country, for_origin, for_type';
                        } elseif ($sortDir == 'asc') {
                                $sortField = 'task, for_category, for_country, for_origin, for_type';
                        }
                        $sortDir = ' task';
                } else
                        $sortDir .= ', task';
                
                $sql .= $where_clause . $having_clause . 'ORDER BY ' . $sortDir;
                
                $dbStmt = $this->getAdapter ()->query ( $sql );
                $results = $dbStmt->fetchAll ();
                if ( $paginated) {
                        $adapter = new Zend_Paginator_Adapter_Array ( $results );
                        return new Zend_Paginator ( $adapter );
                } else {
                        return $results;
                }
        }
        

    /**
         * retrieves all rules filtered by task
         * $term --search term
         * *
         */
        
        public function getAllRules($term = null) {
                $this->getAdapter () ->query ( 'SET NAMES utf8' );
                $select = $this->select ()->from ( array (
                                'r' => 'task_rules' 
                ), array (
                                'rule_id' =>'r.id',
                                'task' =>'r.task',
                                'category' =>'r.for_category',
                                'country' => 'r.for_country',
                                'origin' => 'r.for_origin',
                                'f_type' => 'r.for_type',
                                'detail' => 'r.detail' 
                ) )->joinLeft ( array (
                                'c' => 'country' 
                ), 'r.for_country = c.iso', array (
                                'country_name' => 'c.name' 
                ) )->joinLeft ( array (
                                'o' => 'country' 
                ), 'o.iso = r.for_origin', array (
                                'origin_name' => 'o.name' 
                ) )->joinLeft ( array (
                                'mc' => 'matter_category' 
                ), 'mc.code = r.for_category', array (
                                'category_name' => 'mc.category' 
                ) )->joinLeft ( array (
                                'tn' => 'event_name' 
                ), 'tn.code = r.task', array (
                                'task_name' => 'tn.name' 
                ) )->joinLeft ( array (
                                'mt' => 'matter_type' 
                ), 'mt.code = r.for_type', array (
                                'for_type_name' => 'mt.type' 
                ) )->joinLeft ( array (
                                'en' => 'event_name' 
                ), 'en.code = r.trigger_event', array (
                                'trigger_event_name' => 'en.name' 
                ) )->order ( 'r.task asc' );
                if (isset ( $term ))
                        $select->where ( 'r.task like ?', $term . '%');
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }
                
        /**
         * retrieves all rules filtered by country
         */
        public function getAllRulesByCountry($term = null) {
                $this->getAdapter ()->query ( 'SET NAMES utf8' );
               $select = $this->select ()->from ( array (
                                'r' => 'task_rules' 
                ), array (
                                'rule_id' =>'r.id',
                                'task' =>'r.task',
                                'category' =>'r.for_category',
                                'country' => 'r.for_country',
                                'origin' => 'r.for_origin',
                                'f_type' => 'r.for_type',
                                'detail' => 'r.detail' 
                ) )->joinLeft ( array (
                                'c' => 'country' 
                ), 'c.iso = r.for_country', array (
                                'country_name' => 'c.name' 
                ) )->joinLeft ( array (
                                'o' => 'country' 
                ), 'o.iso = r.for_origin', array (
                                'origin_name' => 'o.name' 
                ) )->joinLeft ( array (
                                'mc' => 'matter_category' 
                ), 'mc.code = r.for_category', array (
                                'category_name' => 'mc.category' 
                ) )->joinLeft ( array (
                                'en' => 'event_name' 
                ), 'en.code = r.trigger_event', array (
                                'trigger_event_name' => 'en.name' 
                ) )->joinLeft ( array (
                                'an' => 'event_name' 
                ), 'an.code = r.abort_on', array (
                                'abort_on_name' => 'an.name' 
                ) )->joinLeft ( array (
                                'tn' => 'event_name' 
                ), 'tn.code = r.task', array (
                                'task_name' => 'tn.name' 
                ) )->where ( "r.for_country LIKE ?", $term . "%" )->order ( 'r.task ASC' );
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }

        /**
         * retrieves all event names from event_name table filtered by task
         * *
         */
        public function getTaskNames($term = null) {
                $this->getAdapter () ->query ( 'SET NAMES utf8' );
                /* $select = $this->select ()->from ( array (
                                'e' => 'event_name' 
                ), array (
                                'e.code',
                                'e.name'
                ) )
                ->where ( 'e.is_task = "1"');
                return $this->fetchAll ( $select )->toArray ();*/
                $sql = "SELECT e.code as id,
                        e.name as value

                        FROM event_name AS e 
                        WHERE e.is_task = 1 AND e.name LIKE '". $term . "%' ORDER BY value"
                        ;
                $dbStmt = $this->getAdapter ()->query ( $sql );
                $results = $dbStmt->fetchAll ();
                return $results;
                }

        /**
         * updates a rule record
         * *
         */
        public function updateRule($rule_id, $field_name, $field_value) {
                if ($rule_id == 0)
                        return false;
                $data = array ();
                if ($field_name == 'use_after' || $field_name == 'use_before') {
                    $data ["$field_name"] = $field_value != "" ? new Zend_Db_Expr ('STR_TO_DATE("$field_value", "%d/%m/%Y" )') : NULL;
                }
                else {
                    $data ["$field_name"] = $field_value != "" ? $field_value : NULL;
                }        
                 $this->update ( $data, array (
                                'ID = ?' => $rule_id 
                ) );
        }
        
        /**
         * add a new rule
         * *
         */
        public function addRule($rule = array()) {
                try {
                        $this->insert ( $rule );
                        return $this->getAdapter ()->lastInsertID ();
                } catch ( Exception $e ) {
                        return $e->getMessage ();
                }
        }

        /**
         * deletes a rule
         * *
         */
        public function deleteRule($rule_id = null) {
                if (! $rule_id)
                        return "Pas de numéro";
                
                try {
                        $this->delete ( 'ID = '. $rule_id );
                        return true;
                } catch ( Exception $e ) {
                        return $e->getMessage ();
                }
        }
        

}

