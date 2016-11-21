<?php

class Application_Model_DbTable_EventName extends Zend_Db_Table_Abstract
{
    protected $_name = 'event_name';
    protected $_primary = 'code';

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
                $db_detail = $this->getAdapter ()->getConfig ();
                
                $db = new Zend_Db_Adapter_Pdo_Mysql ( array (
                                'host' => $db_detail ["host"],
                                'username' => $db_detail ["username"],
                                'password' => $db_detail ["password"],
                                'dbname' => 'information_schema' 
                ) );
                return $db;
        }
    
        public function getEventInfo($event_id = "") {
                if ( $event_id == "")
                        return null;
                $this->getAdapter ()->query ( 'SET NAMES utf8' );
                $select = $this->selectEvent()->where ( 'e.code = ?', $event_id )->setIntegrityCheck ( false );
                $result = $this->fetchRow ( $select );
                return $result->toArray ();
        }


    /**
         * retrieves all events filtered by code
         * $term --search term
         * *
         */
        
        public function getAllEvents($term = null) {
                $this->getAdapter () ->query ( 'SET NAMES utf8' );
                $select = $this->selectEvent()->order ( 'e.name asc' );
                if (isset ( $term ))
                        $select->where ( 'e.code like ?', $term . '%');
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }
                
        /**
         * retrieves all events filtered by name
         */
        public function getAllEventsByName($term = null) {
                $this->getAdapter ()->query ( 'SET NAMES utf8' );
                $select = $this->selectEvent()->where ( "e.name LIKE ?", $term . "%" )->order ( 'e.name ASC' );
                $select = $select->setIntegrityCheck(false);
                return $this->fetchAll ( $select )->toArray ();
        }

        protected function selectEvent() {
                $select = $this->select ()->from ( array (
                                'e' => 'event_name' 
                ), array (
                                'e.code',
                                'e.name',
                                'e.is_task',
                                'e.status_event',
                                'e.default_responsible',
                                'e.use_matter_resp',
                                'e.unique',
                                'e.uqtrigger',
                                'e.killer',
                                'e.notes',
                                'event_id' => 'e.code'
                ) );
                return $select;
        }


        /**
         * updates a event record
         * *
         */
        public function updateEvent($event_id, $field_name, $field_value) {
                if ($event_id == "")
                        return false;
                $data = array ();
                $data ["$field_name"] = $field_value != "" ? $field_value : NULL;
                $this->update ( $data, array (
                                'code = ?' => $event_id 
                ) );
        }
        
        /**
         * add a new event
         * *
         */
        public function addEvent($event = array()) {
                try {
                        $this->insert ( $event );
                        return $this->getAdapter ()->lastInsertID ();
                } catch ( Exception $e ) {
                        return $e->getMessage ();
                }
        }

        /**
         * deletes a event
         * *
         */
        public function deleteEvent($event_id = null) {
                if (! $event_id)
                        return "Pas de numéro";
                
                try {
                        $this->delete ( 'code = "'. $event_id.'"');
                        return true;
                } catch ( Exception $e ) {
                        return $e->getMessage ();
                }
        }
        

}

