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
         * retrieves all rules filtered by task
         * $term --search term
         * *
         */
        
        public function getAllRules($term = null) {
                $this->getAdapter () ->query ( 'SET NAMES utf8' );
                $select = $this->selectRule()->order ( 'r.task asc' );
                if (isset ( $term ))
                        $select->where ( 'tn.name like ?', $term . '%');
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }
                
        /**
         * retrieves all rules filtered by country
         */
        public function getAllRulesByCountry($term = null) {
                $this->getAdapter ()->query ( 'SET NAMES utf8' );
                $select = $this->selectRule()->where ( "r.for_country LIKE ?", $term . "%" )->order ( 'r.task ASC' );
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }

        protected function selectRule() {
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
                                'mt' => 'matter_type' 
                ), 'mt.code = r.for_type', array (
                                'for_type_name' => 'mt.type' 
                ) )->joinLeft ( array (
                                'tn' => 'event_name' 
                ), 'tn.code = r.task', array (
                                'task_name' => 'tn.name' 
                ) );
                return $select;
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

