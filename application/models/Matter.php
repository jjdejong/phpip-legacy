<?php
/************************************************************************
 
 phpIP, a patent and other IP matters management system
 Copyright (C) 2011 Omnipat <http://www.omnipat.fr>
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 *************************************************************************/
class Application_Model_Matter {
	protected $_id;
	protected $_category_code;
	protected $_caseref;
	protected $_country;
	protected $_origin;
	protected $_type_code;
	protected $_idx;
	protected $_parent_id;
	protected $_container_id;
	protected $_responsible;
	protected $_dead;
	protected $_notes;
	protected $_expire_date;
	protected $_term_adjust;
	protected $_creator;
	protected $_updated;
	protected $_updater;
	protected $_primary = "ID";
	protected $_dbTable;
	protected $_adapter;
	protected $_error;
	
	public function __construct(array $options = null) {
		if (is_array ( $options ))
			$this->setOptions ( $options );
	}
	public function __set($name, $value) {
		$method = 'set' . $name;
		if (('mapper' == $name) || ! method_exists ( $this, $method ))
			throw new Exception ( 'Invalid Matter Property' );
		$this->method ( $value );
	}
	public function __get($name) {
		$method = 'get' . $name;
		if (('mapper' == $name) || ! method_exists ( $this, $method ))
			throw new Exception ( 'Invalid Matter Property' );
	}
	public function setOptions(array $options) {
		$methods = get_class_methods ( $this );
		foreach ( $options as $key => $value ) {
			$method = 'set' . ucfirst ( $key );
			if (in_array ( $method, $methods ))
				$this->$method ( $value );
		}
		return $this;
	}
	public function setID($text) {
		$this->_id = ( string ) $text;
		return $this;
	}
	public function getID() {
		return $this->_id;
	}
	public function setDbTable($dbTable) {
		if (is_string ( $dbTable ))
			$dbTable = new $dbTable ();
		if (! $dbTable instanceof Zend_Db_Table_Abstract)
			throw new Exception ( 'Invalid table data gateway provided' );
		$this->_dbTable = $dbTable;
		$this->_adapter = $dbTable->getAdapter ();
		$this->_dbTable->getAdapter ()->query ( 'SET NAMES utf8' );
		return $this;
	}
	public function getDbTable($table = 'Application_Model_DbTable_Matter') {
		$this->setDbTable ( $table );
		return $this->_dbTable;
	}
	public function setError($text = 0) {
		$this->_error = ( string ) $text;
		return $this;
	}
	public function getError() {
		return $this->_error;
	}
	
	/**
	 * saves new matter record upon adding a matter
	 * *
	 */
	public function save($matter = array()) {
		if (empty ( $matter ))
			return false;
		if (! isset ( $matter ['caseref'] ) || empty ( $matter ['caseref'] ))
			return false;
		
		if (! isset ( $matter ['category_code'] ) || empty ( $matter ['category_code'] ))
			return false;
		if (! isset ( $matter ['country'] ) || empty ( $matter ['country'] ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		try {
			$this->_dbTable->insert ( $matter );
			$this->setID ( $this->_adapter->lastInsertID () );
			$this->receivedEvent ( $this->getID () );
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
		return $this->getID ();
	}
	
	/**
	 * creates a new child matter
	 * *
	 */
	public function child($matter = array()) {
		if (empty ( $matter ))
			return false;
		if (! isset ( $matter ['caseref'] ) || empty ( $matter ['caseref'] ))
			return false;
		
		if (! isset ( $matter ['category_code'] ) || empty ( $matter ['category_code'] ))
			return false;
		if (! isset ( $matter ['country'] ) || empty ( $matter ['country'] ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		if (! $this->isMatterUnique ( $matter )) {
			$matter ['idx'] = $this->getNextIdx ( $matter );
		}
		
		try {
			$this->_dbTable->insert ( $matter );
			$this->setID ( $this->_adapter->lastInsertID () );
			$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		} catch ( Exception $e ) {
			return false;
		}
		return $this->getID ();
	}
	
	/**
	 * to find whether a newly created matter has unique index
	 * return @boolean
	 * *
	 */
	public function isMatterUnique($matter = array(), $matter_id = null) {
		$extended = "";
		if (isset ( $matter_id )) {
			if ($matter ['idx'] == '' || ! isset ( $matter ['idx'] ))
				$extended = " AND idx is NULL AND ID !='" . $matter_id . "'";
			else
				$extended = " AND idx = '" . $matter ['idx'] . "' AND ID !='" . $matter_id . "'";
		}
		if ($matter ['origin'] == '' || ! isset ( $matter ['origin'] ))
			$origin_sq = "origin is NULL";
		else
			$origin_sq = "origin = '" . $matter ['origin'] . "'";
		
		if ($matter ['type_code'] == '' || ! isset ( $matter ['type_code'] ))
			$type_sq = "type_code is NULL";
		else
			$type_sq = "type_code = '" . $matter ['type_code'] . "'";
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'm' => 'matter' 
		) )->where ( "caseref = '" . $matter ['caseref'] . "' AND country='" . $matter ['country'] . "' AND " . $origin_sq . " AND " . $type_sq . " AND category_code='" . $matter ['category_code'] . "'" . $extended );
		$result = $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
		if (empty ( $result ))
			return true;
		else
			return false;
	}
	
	/**
	 * Creates Parent Filed event for a child matter
	 * *
	 */
	public function childParentFiledEvent($matter_id, $parent_id) {
		$this->setDbTable ( 'Application_Model_DbTable_Event' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'e' => 'event' 
		) )->where ( "matter_ID = " . $parent_id . " AND code='PFIL'" );
		$result = $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
		$data = array ();
		if (empty ( $result )) {
			$data ['code'] = 'PFIL';
			$data ['matter_ID'] = $matter_id;
			$data ['alt_matter_ID'] = $parent_id;
			$data ['event_date'] = date ( 'Y-m-d' );
			$this->_dbTable->insert ( $data );
		} else {
			unset ( $result ['ID'] );
			$result ['matter_ID'] = $matter_id;
			$this->_dbTable->insert ( $result );
		}
	}
	
	/**
	 * Creates a Priority claim event for a child matter
	 * *
	 */
	public function childPriClaimEvent($matter_id, $child_id) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Event' );
		$data ['code'] = 'PRI';
		$data ['matter_ID'] = $child_id;
		$data ['alt_matter_ID'] = $matter_id;
		$data ['event_date'] = date ( 'Y-m-d' );
		$this->_dbTable->insert ( $data );
	}
	
	/**
	 * creates a recieved event for a matter
	 * *
	 */
	public function receivedEvent($matter_id = null) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Event' );
		$data ['code'] = 'REC';
		$data ['matter_ID'] = $matter_id;
		$data ['event_date'] = date ( 'Y-m-d' );
		$this->_dbTable->insert ( $data );
	}
	
	/**
	 * creates Filed, Published, Granted events copied from current matter to a new matter
	 * *
	 */
	public function nationalPhaseEvents($matter_cur = null, $matter_new = null) {
		if (! isset ( $matter_cur ) || ! isset ( $matter_new ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$query = "INSERT INTO event(code, matter_ID, event_date, alt_matter_ID, detail, notes) SELECT code, " . $matter_new . ", event_date, alt_matter_ID, detail, notes FROM `event` where code IN ('FIL', 'PUB', 'GRT') AND matter_ID =" . $matter_cur;
		$nquery = $this->_dbTable->getAdapter ()->prepare ( $query );
		$nquery->execute ();
	}
	
	/**
	 * creates an entered event for a matter with entered_date as specified or now()
	 * *
	 */
	public function enteredEvent($matter_id = null, $entered_date = null) {
		if (! $matter_id)
			return;
		
		if (! isset ( $entered_date ) || empty ( $entered_date )) {
			$entered_date = date ( 'Y-m-d' );
		}
		
		$this->setDbTable ( 'Application_Model_DbTable_Event' );
		$data ['code'] = 'ENT';
		$data ['matter_ID'] = $matter_id;
		$data ['event_date'] = $entered_date;
		$this->_dbTable->insert ( $data );
	}
	
	/**
	 * retrieves paginated list of matters with specified filters
	 * *
	 */
	public function fetchMatters($filter_array = array(), 
									$sortField = 'matter.caseref, matter.container_id, matter.origin, matter.country, matter.type_code, matter.idx', 
									$sortDir = '', 
									$multi_filter = array(), 
									$matter_category_display_type = false,
									$paginated = false) {
		
		if (array_key_exists ( 'Inventor1', $multi_filter )) {
			$inventor_filter = '';
		} else
			$inventor_filter = 'AND invlnk.display_order = 1';
		
		$sql = "SELECT CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', concat(caseref, matter.country), origin), matter.type_code), idx) AS Ref,
matter.country AS country,
matter.category_code AS Cat,
matter.origin,
event_name.name AS Status,
status.event_date AS Status_date,
IFNULL(cli.display_name, cli.name) AS Client,
clilnk.actor_ref AS ClRef,
IFNULL(agt.display_name, agt.name) AS Agent,
agtlnk.actor_ref AS AgtRef,
classifier.value AS Title,
CONCAT_WS(' ', inv.name, inv.first_name) as Inventor1,
fil.event_date AS Filed,
fil.detail AS FilNo,
pub.event_date AS Published,
pub.detail AS PubNo,
grt.event_date AS Granted,
grt.detail AS GrtNo,
matter.ID,
matter.container_ID,
matter.parent_ID,
matter.responsible,
del.login AS delegate,
matter.dead,
IF(isnull(matter.container_ID),1,0) AS Ctnr,
1 AS Pri
FROM matter IGNORE INDEX (category)
  JOIN matter_category FORCE INDEX (PRIMARY) ON (matter.category_code = matter_category.code)
  LEFT JOIN (matter_actor_lnk clilnk, actor cli) 
    ON (IFNULL(matter.container_ID,matter.ID) = clilnk.matter_ID AND clilnk.role = 'CLI' AND clilnk.display_order=1 AND cli.ID = clilnk.actor_ID) 
  LEFT JOIN (matter_actor_lnk invlnk,actor inv) 
    ON (ifnull(matter.container_ID,matter.ID) = invlnk.matter_ID AND invlnk.role = 'INV' " . $inventor_filter . " AND inv.ID = invlnk.actor_ID)
  LEFT JOIN (matter_actor_lnk agtlnk, actor agt) 
    ON (matter.ID = agtlnk.matter_ID AND agtlnk.role = 'AGT' AND agtlnk.display_order = 1 AND agt.ID = agtlnk.actor_ID)
  LEFT JOIN (matter_actor_lnk dellnk, actor del) 
    ON (ifnull(matter.container_ID,matter.ID) = dellnk.matter_ID AND dellnk.role = 'DEL' AND del.ID = dellnk.actor_ID)  
  LEFT JOIN event fil ON (matter.ID=fil.matter_ID AND fil.code='FIL')
  LEFT JOIN event pub ON (matter.ID=pub.matter_ID AND pub.code='PUB')
  LEFT JOIN event grt ON (matter.ID=grt.matter_ID AND grt.code='GRT')
  LEFT JOIN (event status, event_name) 
    ON (matter.ID=status.matter_ID AND event_name.code=status.code AND event_name.status_event=1)
      LEFT JOIN (event e2, event_name en2) ON e2.code=en2.code AND en2.status_event=1 AND status.matter_id=e2.matter_id AND status.event_date < e2.event_date 
  LEFT JOIN (classifier, classifier_type) 
    ON (classifier.matter_ID = IFNULL(matter.container_ID, matter.ID) AND classifier.type_code=classifier_type.code AND main_display=1 AND classifier_type.display_order=1)
WHERE e2.matter_id IS NULL ";
		
		$where_clause = '';
		if ($matter_category_display_type)
			$where_clause = "AND matter_category.display_with = '$matter_category_display_type' ";
		
		if (!empty ( $filter_array )) {			
			if ($filter_array ['field'] == 'Ctnr') {
				$where_clause .= "AND matter.container_ID IS NULL ";
			} else if ($filter_array ['field'] == 'Pri') {
				$where_clause .= "AND EXISTS(SELECT 1 FROM event WHERE event.code='PRI' AND alt_matter_ID=matter.ID) ";
			} else if ($filter_array ['value'] && $filter_array ['field']) {
				$where_clause .= "AND " . $filter_array ['field'] . " = '" . $filter_array ['value'] . "' ";
			}
		}
		
		$having_clause = '';
		if (! empty ( $multi_filter )) {
			foreach ( $multi_filter as $key => $value ) {
				if ($value != '' && $key != 'display' && $key != 'display_style') {
					if ($having_clause == '')
						$having_clause = "HAVING ";
					else
						$having_clause .= "AND ";
					if ($key == 'responsible')
						$having_clause .= "(responsible = '$value' OR delegate = '$value') ";
					else
						$having_clause .= "$key LIKE '$value%' ";
				}
			}
		}
		
		if ($sortField == 'caseref') {
			if ($sortDir == 'desc') {
				$sortField = 'matter.caseref DESC, matter.container_id, matter.origin, matter.country, matter.type_code, matter.idx';
			} elseif ($sortDir == 'asc') {
				$sortField = 'matter.caseref, matter.container_id, matter.origin, matter.country, matter.type_code, matter.idx';
			}
			$sortDir = '';
		} else
			$sortDir .= ', matter.caseref, matter.origin, matter.country';
		
		$sql .= $where_clause . $having_clause . 'ORDER BY ' . $sortField .' '. $sortDir; 
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ($sql);
		$results = $dbStmt->fetchAll ();

		if( $paginated ) {
			$adapter = new Zend_Paginator_Adapter_Array ( $results );
			return new Zend_Paginator ( $adapter );
		} else {
			return $results;
		}
	}
	
	/**
	 * gets complete details of a matter from matter table
	 * *
	 */
	public function getMatter($matter_id = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$uidsql = "CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', CONCAT(m.caseref, m.country), m.origin), m.type_code), m.idx)";
		$selectQuery = $db->select ()->from ( array (
				'm' => 'matter' 
		), array (
				'm.*',
				'UID' => new Zend_Db_Expr ( $uidsql ) 
		) )->joinLeft ( array (
				'c' => 'country' 
		), 'c.iso = m.country', array (
				'country_name' => 'c.name' 
		) )->joinLeft ( array (
				'mc' => 'matter_category' 
		), 'm.category_code = mc.code', array (
				'category' => 'mc.category' 
		) )->where ( 'ID = ?', $matter_id );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * returns container_ID of a matter
	 * *
	 */
	public function getMatterContainer($matter_id = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'm' => 'matter' 
		) )->where ( 'ID = ?', $matter_id );
		
		$matter = $db->fetchRow ( $selectQuery );
		if ($matter ['container_ID'] == null)
			return $matter_id;
		else
			return $matter ['container_ID'];
	}
	
	/**
	 * retrieves all actors linked to a matter from matter_actor_lnk
	 * *
	 */
	public function getMatterActors($matter_id = 0, $container_id = 0) {
		if (! $matter_id)
			return;
		
		if (! $container_id)
			$container_id = 0;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'mal' => 'matter_actor_lnk' 
		), array (
				'mal.*',
				'inherited' => 'if(mal.matter_ID =' . $container_id . ', 1,0)' 
		) )->joinLeft ( array (
				'a' => 'actor' 
		), 'a.ID = mal.actor_ID', array(
				'a.name', 'a.first_name', 'a.display_name'
		) )->joinLeft ( array (
				'ar' => 'actor_role' 
		), 'mal.role = ar.code', array (
				'role_name' => 'ar.name' 
		) )->joinLeft ( array (
				'aa' => 'actor' 
		), 'aa.ID = mal.company_ID', array (
				'company_name' => 'aa.name' 
		) )->order ( array (
				'ar.display_order',
				'mal.display_order',
				'ar.box',
				'ar.box_color' 
		) )->where ( 'matter_ID = ?', $matter_id )->orwhere ( 'matter_ID = ? and mal.shared = 1 and matter_ID != 0', $container_id );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrives actors for a given role and linked to a matter
	 * *
	 */
	public function getMatterActorsForRole($container_id = 0, $matter_id = 0, $role = '') {
		if (! $matter_id)
			return;
		
		if (! $container_id)
			$container_id = 0;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'mal' => 'matter_actor_lnk' 
		), array (
				'mal.*',
				'inherited' => 'if(mal.matter_ID =' . $container_id . ', 1,0)' 
		) )->joinLeft ( array (
				'a' => 'actor' 
		), 'a.ID = mal.actor_ID', array (
				'AID' => 'a.ID',
				'a.name',
				'a.first_name',
				'a.display_name' 
		) )->joinLeft ( array (
				'ar' => 'actor_role' 
		), 'mal.role = ar.code', array (
				'ar.name as role_name',
				'ar.code',
				'ar.shareable',
				'ar.notes',
				'ar.show_ref',
				'ar.show_company',
				'ar.show_date',
				'ar.show_rate' 
		) )->joinLeft ( array (
				'aa' => 'actor' 
		), 'aa.ID = mal.company_ID', array (
				'company_name' => 'aa.name' 
		) )->order ( array (
				'mal.display_order',
				'ar.box',
				'ar.box_color' 
		) )->where ( "matter_ID = " . $matter_id . " AND mal.role = '" . $role . "'" )->orwhere ( "matter_ID = " . $container_id . " AND mal.role = '" . $role . "' AND mal.shared = 1 AND matter_ID != 0" );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrives a record from actor_role for a given actor_role.code
	 * *
	 */
	public function getActorRoleInfo($role = null) {
		if ($role) {
			$this->setDbTable ( 'Application_Model_DbTable_ActorRole' );
			$db = $this->_dbTable->getAdapter ();
			
			$selectQuery = $db->select ()->from ( array (
					'ar' => 'actor_role' 
			) )->where ( "ar.code = ?", $role );
			
			return $db->fetchRow ( $selectQuery );
		}
	}
	
	/**
	 * retreives all status events of a given matter, and displays link information
	 * *
	 */
	public function getMatterEvents($matter_id = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'e' => 'event' 
		), array (
				'event_date' => 'DATE_FORMAT(ifnull(e2.event_date, e.event_date),"%d/%m/%Y")',
				'detail' => 'ifnull(concat(m2.country, e2.detail), e.detail)',
				'alt_matter_ID' 
		) )->join ( array (
				'en' => 'event_name' 
		), 'e.code = en.code' )->joinLeft ( array (
				'e2' => 'event' 
		), 'e2.matter_ID = e.alt_matter_ID and e2.code = "FIL"', array () )->joinLeft ( array (
				'm2' => 'matter' 
		), 'm2.ID = e.alt_matter_ID', array () )->where ( 'e.matter_ID = ? and en.status_event = 1', $matter_id )->order ( 'e.event_date asc' );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all events for a matter (for the full list opened when clicking on the status event box title)
	 * *
	 */
	public function getMatterAllEvents($matter_id = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'e' => 'event' 
		), array (
				'ID',
				'event_date' => 'DATE_FORMAT(e.event_date,"%d/%m/%Y")',
				'detail',
				'alt_matter_ID',
				'e.notes' 
		) )->join ( array (
				'en' => 'event_name' 
		), 'e.code = en.code', 'en.name' )->joinLeft ( array (
				'm' => 'matter' 
		), 'm.ID = e.alt_matter_ID', array (
				'alt_caseref' => 'm.caseref',
				'm.country',
				'm.origin' 
		) )->joinLeft ( array (
				'mt' => 'matter_type' 
		), 'mt.code = m.type_code', array (
				'matter_type' => 'mt.type' 
		) )->where ( 'matter_ID = ? ', $matter_id )->order ( 'e.event_date asc' );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all open tasks for a matter
	 * *
	 */
	public function getOpenTasks($matter_id = 0) { // NOT RENewal
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'tl' => "task_list" 
		), array (
				'tl.trigger_ID',
				'due_date' => 'DATE_FORMAT(tl.due_date,"%d/%m/%Y")',
				'posix_due_date' => 'tl.due_date',
				'task_name' => 'tl.name' 
		) )->join ( array (
				't' => 'task' 
		), 't.ID = tl.ID', array (
				't.detail',
				't.ID',
				't.notes' 
		) )->join ( array (
				'e' => 'event' 
		), 'e.ID=tl.trigger_ID', array (
				'e.code',
				'trigger_detail' => 'e.detail' 
		) )->join ( array (
				'en' => 'event_name' 
		), 'en.code=e.code', array (
				'trigger_name' => 'en.name' 
		) )->where ( 'tl.matter_ID = ?  AND t.code != "REN" AND t.done=0', $matter_id )->order ( array (
				'tl.trigger_ID',
				'tl.due_date asc' 
		) );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all renewal tasks for a matter
	 * *
	 */
	public function getOpenTasksREN($matter_id = 0) { // RENewal
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'tl' => "task_list" 
		), array (
				'tl.trigger_ID',
				'due_date' => 'DATE_FORMAT(tl.due_date,"%d/%m/%Y")',
				'posix_due_date' => 'tl.due_date',
				'task_name' => 'tl.name' 
		) )->join ( array (
				't' => 'task' 
		), 't.ID = tl.ID', array (
				't.detail',
				't.ID' 
		) )->join ( array (
				'e' => 'event' 
		), 'e.ID=tl.trigger_ID', array (
				'e.code' 
		) )->join ( array (
				'en' => 'event_name' 
		), 'en.code=e.code', array (
				'trigger_name' => 'en.name' 
		) )->where ( 'tl.matter_ID = ?  AND t.code = "REN" AND t.done=0', $matter_id )->order ( array (
				'tl.due_date asc',
				'tl.trigger_ID' 
		) )->limit ( 2, 0 );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves classifiers for a given matter
	 * main_display=1 gives main classifiers which are used as titles in a matter view table
	 * *
	 */
	public function getClassifier($matter_id = 0, $main_display = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		$selectQuery = $db->select ()->from ( array (
				'c' => "classifier" 
		), array (
				'c.ID',
				'c_value' => 'c.value',
				'lnk_matter_id' => 'if(' . $matter_id . ' = c.lnk_matter_id, matter_id, lnk_matter_id)' 
		) )->join ( array (
				'ct' => 'classifier_type' 
		), "ct.code = c.type_code AND ct.main_display=" . $main_display, array (
				'ct.type' 
		) )->joinLeft ( array (
				'cv' => 'classifier_value' 
		), 'cv.ID = c.value_ID', array (
				'cv_value' => 'cv.value' 
		) )->joinLeft ( array (
				'ctv' => 'classifier_type' 
		), 'cv.type_code = ctv.code', array (
				'cv_type' => 'ctv.type' 
		) )->joinLeft ( array (
				'm' => 'matter' 
		), 'c.lnk_matter_id = m.id', array (
				'caseref',
				'country',
				'origin' 
		) )->joinLeft ( array (
				'mt' => 'matter_type' 
		), 'mt.code = m.type_code', array (
				'matter_type' => 'mt.type' 
		) )->where ( 'c.matter_ID = ?', $matter_id )->orwhere ( 'c.lnk_matter_ID = ?', $matter_id )->order ( array (
				'ct.display_order',
				'c.display_order' 
		) );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * Retrieves non-main classifiers for display in the matter detail screen
	 * *
	 */
	public function getClassifiers($matter_id = 0) {
		if (! $matter_id)
			return 0;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		
		// The UNION clause retrieves the backward links
		$dbStmt = $this->_dbTable->getAdapter ()->query ( 
"(SELECT 
    classifier_type.type AS type,
    IFNULL(mlnk.caseref,
            IFNULL(classifier_value.`value`,
                    classifier.`value`)) AS value,
    IF(lnk_matter_id IS NULL,
        classifier.url,
        CONCAT('/matter/view/id/',
                IF(lnk_matter_id = IFNULL(m.container_id, m.id),
                    matter_id,
                    lnk_matter_id))) AS url
FROM
    matter m
        JOIN
    classifier ON (IFNULL(m.container_id, m.id) = classifier.matter_ID)
        JOIN
    classifier_type ON (classifier.type_code = classifier_type.`code`
        AND classifier_type.main_display = 0)
        LEFT JOIN
    classifier_value ON (classifier_value.id = classifier.value_id)
        LEFT JOIN
    matter mlnk ON (mlnk.id = classifier.lnk_matter_id)
WHERE m.id = " . $matter_id . "
ORDER BY classifier_type.type, classifier_type.display_order, classifier.display_order) 
UNION (SELECT 
    classifier_type.type AS type,
    mlnk.caseref AS value,
    CONCAT('/matter/view/id/', mlnk.id) AS url
FROM
    matter m
        JOIN
    classifier ON (IFNULL(m.container_id, m.id) = classifier.lnk_matter_ID)
        JOIN
    classifier_type ON (classifier.type_code = classifier_type.`code`
        AND classifier_type.main_display = 0)
        JOIN
    matter mlnk ON (mlnk.id = classifier.matter_id)
WHERE m.id = " . $matter_id . ")" );
		
		return $dbStmt->fetchAll ();
	}
	
	/**
	 * Retrieves non-main classifiers for display in the detailed classifier list
	 * *
	 */
	public function getMatterClassifiers($matter_id = 0) {
		if (! $matter_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		// For the links, this query only lists those included in the container
		$dbStmt = $this->_dbTable->getAdapter ()->query ( 
"SELECT 
    c.ID,
    ct.type,
    c.type_code,
    c.value_ID,
    IFNULL(cv.value, c.value) AS value,
    c.url,
    mlnk.caseref AS lnkTo
FROM
    classifier c
        JOIN
    classifier_type ct ON (c.type_code = ct.code
        AND ct.main_display = 0)
        LEFT JOIN
    classifier_value cv ON (cv.id = c.value_id)
        LEFT JOIN
    matter mlnk ON (mlnk.id = c.lnk_matter_id)
        JOIN
    matter m ON (c.matter_ID = IFNULL(m.container_id, m.id))
WHERE
    m.id = " . $matter_id . "
ORDER BY ct.type, ct.display_order, c.display_order" );
		
		return $dbStmt->fetchAll ();
	}
	
	/**
	 * retrieves all tasks for a matter with event details
	 * *
	 */
	public function getMatterEventTasks($matter_id = 0, $renewal = 0, $event_id = 0) {
		if (! $matter_id && ! $event_id)
			return;
		if ($renewal == 1)
			$rencomp = ' = ';
		else
			$rencomp = ' != ';
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		
		// Retrieve tasks linked to a matter, distinguising between renewals and others
		if ($matter_id != 0) {
			$selectQuery = $db->select ()->from ( array (
					'e' => 'event' 
			), array (
					'event_ID' => 'e.ID',
					'event_detail' => 'e.detail',
					'event_date' => 'DATE_FORMAT(e.event_date, "%d/%m/%Y")' 
			) )->joinLeft ( array (
					't' => 'task' 
			), "e.ID = t.trigger_ID AND t.code $rencomp 'REN'", array (
					'*',
					'done_date' => 'DATE_FORMAT(t.done_date,"%d/%m/%Y")',
					'due_date' => 'DATE_FORMAT(t.due_date,"%d/%m/%Y")',
					'posix_due_date' => 't.due_date',
					't.detail',
					't.ID',
					'task_notes' => 't.notes' 
			) )->join ( array (
					'en' => 'event_name' 
			), 'e.code = en.code', array (
					'event_name' => 'en.name' 
			) )->joinLeft ( array (
					'ent' => 'event_name' 
			), 't.code = ent.code', array (
					'task_name' => 'ent.name' 
			) )->where ( 'e.matter_ID = ?', $matter_id )->order ( array (
					'e.event_date',
					't.due_date' 
			) );
		}
		
		// Retrieve tasks linked to a specific event, distinguising between renewals and others
		if ($event_id != 0) {
			$selectQuery = $db->select ()->from ( array (
					'e' => 'event' 
			), array (
					'event_ID' => 'e.ID',
					'event_detail' => 'e.detail',
					'event_date' => 'DATE_FORMAT(e.event_date, "%d/%m/%Y")' 
			) )->joinLeft ( array (
					't' => 'task' 
			), "e.ID = t.trigger_ID AND t.code $rencomp 'REN'", array (
					'*',
					'done_date' => 'DATE_FORMAT(t.done_date,"%d/%m/%Y")',
					'due_date' => 'DATE_FORMAT(t.due_date,"%d/%m/%Y")',
					'posix_due_date' => 't.due_date',
					't.detail',
					't.ID',
					'task_notes' => 't.notes' 
			) )->joinInner ( array (
					'en' => 'event_name' 
			), 'e.code = en.code', array (
					'event_name' => 'en.name' 
			) )->joinLeft ( array (
					'ent' => 'event_name' 
			), 't.code = ent.code', array (
					'task_name' => 'ent.name' 
			) )->where ( 'e.ID = ?', $event_id )->order ( 't.due_date' );
		}
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all actors from actor table filterted by name
	 * $term --search term
	 * $phy_person --whether physical actor or other
	 * *
	 */
	public function getAllActors($term = null, $phy_person = null) {
		$phy_query = "";
		if (isset ( $phy_person )) {
			$phy_query = "AND a.phy_person = " . $phy_person;
		}
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.name',
				'a.first_name',
				'a.display_name',
				'a.login' 
		) )->joinLeft ( array (
				'aa' => 'actor' 
		), 'aa.ID = a.company_ID', array (
				'company_name' => 'aa.name' 
		) )->where ( "a.name like '" . $term . "%' " . $phy_query )->order ( 'a.name asc' );
		$result = $db->fetchAll ( $selectQuery );
		foreach ( $result as $key => $actor ) {
			$actor_display = $actor ['name'] . (($actor ['first_name'] == '') ? "" : (", " . $actor ['first_name'])) . (($actor ['display_name']) ? (" (" . $actor ['display_name'] . ")") : "");
			$result [$key] ['value'] = htmlentities ( $actor_display );
		}
		return $result;
	}

	/**
	 * retrieves all users from actor table filterted by name
	 * $term --search term
	**/
	public function getAllUsers($term = null) {
	    $phy_query = "";
	    if(isset($phy_person)){
	        $phy_query = " AND a.phy_person = ".$phy_person;
	    }
	    $this->setDbTable('Application_Model_DbTable_Matter');
	    $dbSelect = $this->_dbTable->getAdapter()->select();
	    $selectQuery = $dbSelect->from(array('a' => 'actor'), array('a.id', 'a.name', 'a.first_name','a.display_name','a.login', 'a.ipuser'))
	              ->joinLeft(array('aa' => 'actor'), 'aa.ID = a.company_ID', array('aa.name as company_name'))
	              ->where("a.name like '". $term . "%'  AND a.phy_person = 1 AND a.login is not null")
	              ->order('a.name asc');
	    $result = $this->_dbTable->getAdapter()->fetchAll($selectQuery);
	    foreach($result as $key => $actor){
	      $actor_display = $actor['name'] . (($actor['first_name'] == '')?"":(", ".$actor['first_name'])).( ($actor['display_name'])?(" (".$actor['display_name'].")"):"" );
	      $result[$key]['value'] = htmlentities($actor_display);
	    }
	    return $result;
	  }
	
	/**
	 * retrieves all actors from actor table filtered by company
	 */
	public function getAllActorsByCo($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.name',
				'a.first_name',
				'a.display_name',
				'a.login' 
		) )->joinLeft ( array (
				'aa' => 'actor' 
		), 'aa.ID = a.company_ID', array (
				'company_name' => 'aa.name' 
		) )->where ( "aa.name like '" . $term . "%'" )->order ( 'a.name asc' );
		$result = $db->fetchAll ( $selectQuery );
		foreach ( $result as $key => $actor ) {
			$actor_display = $actor ['name'] . (($actor ['first_name'] == '') ? "" : (", " . $actor ['first_name'])) . (($actor ['display_name']) ? (" (" . $actor ['display_name'] . ")") : "");
			$result [$key] ['value'] = htmlentities ( $actor_display );
		}
		return $result;
	}
	
	/**
	 * retrieves all logins from actor table
	 * *
	 */
	public function getAllLogins($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.login as value',
				'a.first_name',
				'a.display_name' 
		) )->where ( 'a.login like ? ', $term . '%' )->order ( 'a.login asc' );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all categories from matter_category filter by search term
	 * *
	 */
	public function getAllCategories($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'mc' => 'matter_category' 
		), array (
				'id' => 'mc.code',
				'value' => 'mc.category' 
		) )->where ( 'mc.category like ? ', $term . '%' )->order ( 'mc.category asc' );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * returns actor_role.name for given actor_role.code
	 * *
	 */
	public function getRoleName($role = 0) {
		if (! $role)
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'ar' => 'actor_role' 
		), array (
				'ar.code',
				'ar.name' 
		) )->where ( 'ar.code = ? ', $role )->order ( 'ar.name asc' );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * determines whether a role is shareable
	 *
	 * @return actor_role.shareable
	 *
	 */
	public function isRoleShareable($role = 0) {
		if (! $role)
			return null;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'ar' => 'actor_role' 
		), array (
				'ar.shareable' 
		) )->where ( 'ar.code = ? ', $role );
		$result = $db->fetchRow ( $selectQuery );
		return $result ['shareable'];
	}
	
	/**
	 * retrieves all records from actor_role sorted by name asc
	 * *
	 */
	public function getAllRoles() {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'ar' => 'actor_role' 
		), array (
				'ar.code',
				'ar.name',
				'ar.shareable' 
		) )->order ( 'ar.name asc' );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all records from actor_role filtered by search term
	 * *
	 */
	public function getActorRoles($term = '') {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'ar' => 'actor_role' 
		), array (
				'id' => 'ar.code',
				'value' => 'ar.name',
				'ar.shareable' 
		) )->order ( 'ar.name asc' )->where ( "ar.name like '" . $term . "%'" );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * updates a record of actor_role
	 * *
	 */
	public function saveRole($role_code = null, $data = array()) {
		if (! $role_code)
			return false;
		return $this->getDbTable ( 'Application_Model_DbTable_ActorRole' )->update ( $data, array (
				'code = ?' => $role_code 
		) );
	}
	
	/**
	 * updates a record of a matter_actor_lnk
	 * *
	 */
	public function saveMatterActor($matter_actor_id = 0, $data = array()) {
		if ($matter_actor_id && ! empty ( $data )) {
			$dbTable = $this->getDbTable ( 'Application_Model_DbTable_MatterActorLink' );
			// $dbTable->getAdapter()->query('SET NAMES utf8');
			return $dbTable->update ( $data, array (
					'ID = ?' => $matter_actor_id 
			) );
		}
	}
	
	/**
	 * deletes a record from matter_actor_lnk
	 * *
	 */
	public function deleteMatterActor($mal_id = null) { // We need to update here the display order index of the remaining actors of same role
	                                                    // update matter_actor_lnk set display_order = display_order-1 where matter_id=xx and role='xx' and display_order > xx;
		if ($mal_id) {
			$dbTable = $this->getDbTable ( 'Application_Model_DbTable_MatterActorLink' );
			// $row = $dbTable->find($mal_id);
			$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $mal_id );
			try {
				// $dbTable->query("UPDATE xx");
				$dbTable->delete ( $where );
				return 1;
			} catch ( Exception $e ) {
				return $e->getMessage ();
			}
		}
	}
	
	/**
	 * retrieves full details of an actor
	 * *
	 */
	public function getActorInfo($actor_id = 0) {
		if (! $actor_id)
			return null;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'a' => 'actor' 
		) )->joinLeft ( array (
				'ac' => 'actor' 
		), 'a.company_ID = ac.ID', array (
				'company_name' => 'ac.name' 
		) )->joinLeft ( array (
				'ap' => 'actor' 
		), 'a.parent_ID = ap.ID', array (
				'parent_name' => 'ap.name' 
		) )->joinLeft ( array (
				'as' => 'actor' 
		), 'a.site_ID = as.ID', array (
				'site_name' => 'as.name' 
		) )->joinLeft ( array (
				'ar' => 'actor_role' 
		), 'a.default_role = ar.code', array (
				'drole_name' => 'ar.name' 
		) )->joinLeft ( array (
				'c' => 'country' 
		), 'a.country = c.iso', array (
				'country_name' => 'c.name' 
		) )->joinLeft ( array (
				'cm' => 'country' 
		), 'a.country_mailing = cm.iso', array (
				'country_mailing' => 'cm.name' 
		) )->joinLeft ( array (
				'cb' => 'country' 
		), 'a.country_billing = cb.iso', array (
				'country_billing' => 'cb.name' 
		) )->joinLeft ( array (
				'na' => 'country' 
		), 'a.nationality = na.iso', array (
				'nationality_name' => 'na.name' 
		) )->where ( 'a.ID = ?', $actor_id );
		return $db->fetchRow ( $selectQuery );
	}
	
	/**
	 *
	 * @return next display order value for an actor newly linked to a matter
	 *        
	 */
	public function getNextDisplayOrder($matter_id = null, $container_id = 0, $role = null) {
		if (! $matter_id || ! $role)
			return null;
		
		if (! $container_id)
			$container_id = 0;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'mal' => 'matter_actor_lnk' 
		), array (
				'max_dis_order' => 'max(display_order)' 
		) )->where ( "matter_ID = " . $matter_id . " AND mal.role = '" . $role . "'" )->orwhere ( "matter_ID = " . $container_id . " AND mal.role = '" . $role . "'" );
		$result = $db->fetchRow ( $selectQuery );
		return (( int ) $result ['max_dis_order'] + 1);
	}
	
	/**
	 * links an actor to a matter i.e., a new record is added to matter_actor_lnk
	 * *
	 */
	public function addMatterActor($data = array()) {
		if (empty ( $data ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_MatterActorLink' );
		try {
			$this->_dbTable->insert ( $data );
		} catch ( Exception $e ) {
			$this->setError ( $e->getMessage () );
			return false;
		}
		return true;
	}
	
	/**
	 * retrives matter.expire_date for a given matter
	 * *
	 */
	public function getMatterExpiry($matter_id = 0) {
		if ($matter_id) {
			$this->setDbTable ( 'Application_Model_DbTable_Matter' );
			$db = $this->_dbTable->getAdapter ();
			$selectQuery = $db->select ()->from ( array (
					'm' => 'matter' 
			), array (
					'ID',
					'expire_date' => 'DATE_FORMAT(`expire_date`, "%d/%m/%Y")',
					'term_adjust' 
			) )->where ( 'ID = ?', $matter_id );
			return $db->fetchRow ( $selectQuery );
		}
	}
	
	/**
	 * shares a actor_role
	 * i.e., updates shareable column of actor_role to 1 for a give actor_role.code
	 * *
	 */
	public function shareRole($role = null) {
		if ($role) {
			$data ['shareable'] = 1;
			return $this->getDbTable ( 'Application_Model_DbTable_ActorRole' )->update ( $data, array (
					'code = ?' => $role_code 
			) );
		}
	}
	
	/**
	 * updates a field of an actor
	 * updated through in-place edit feature
	 * *
	 */
	public function updateActor($actor_id = null, $field_name = "", $field_value = "") {
		if (! isset ( $actor_id ))
			return false;
		
		$data = array ();
		$data ["$field_name"] = $field_value != "" ? $field_value : NULL;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Actor' );
		// $dbTable->getAdapter()->query('SET NAMES utf8');
		try {
			$dbTable->update ( $data, array (
					'ID = ?' => $actor_id 
			) );
			return true;
		} catch ( Exception $e ) {
			$this->setError ( $e->getMessage () );
			return false;
		}
		// return $dbTable->update($data, array('ID = ?' => $actor_id));
	}
	
	/**
	 * updates task details for a given column through in-place edit
	 * *
	 */
	public function saveTaskDetails($task_id = 0, $field_name = "", $field_value = "", $rule_id = null) {
		if (preg_match ( "/_date/", $field_name )) {
			if ($field_value == '')
				$data = array (
						"$field_name" => NULL 
				);
			else
				$data = array (
						"$field_name" => new Zend_Db_Expr ( "STR_TO_DATE('$field_value', '%d/%m/%Y' )" ) 
				);
		} else
			$data ["$field_name"] = $field_value;
		
		if ($field_name == 'due_date' && ! isset ( $rule_id ))
			$data ['rule_used'] = NULL;
		
		if ($field_name == 'done') {
			if ($field_value == 1)
				$this->updateTaskDoneDate ( $task_id );
			else
				$data ['done_date'] = NULL;
		}
		
		return $this->getDbTable ( 'Application_Model_DbTable_Task' )->update ( $data, array (
				'ID = ?' => $task_id 
		) );
	}
	
	/**
	 * clears a set of tasks i.e., task.done is set to 1 on done_date or now()
	 * *
	 */
	public function clearTasks($task_ids = array(), $done_date = '') {
		$data ['done'] = 1;
		if ($done_date == '')
			$data ['done_date'] = date ( 'Y-m-d' );
		else {
			$data ['done_date'] = new Zend_Db_Expr ( "STR_TO_DATE('$done_date', '%d/%m/%Y' )" );
		}
		
		$tids = implode ( ',', $task_ids );
		
		try {
			$this->getDbTable ( 'Application_Model_DbTable_Task' )->update ( $data, array (
					'ID IN (' . $tids . ')' 
			) );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * updates task.done_date to if(due_date < now(), due_date, now())
	 * *
	 */
	public function updateTaskDoneDate($task_id = 0) {
		if (! $task_id)
			return false;
		$db = $this->getDbTable ( 'Application_Model_DbTable_Task' )->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				't' => 'task' 
		) )->where ( "t.ID = " . $task_id . " AND done_date IS NULL" );
		
		$result = $db->fetchRow ( $selectQuery );
		
		if ($result) {
			$db->query ( "UPDATE task set done_date = if(due_date < now(), due_date, now()) where ID=$task_id" );
		}
	}
	
	/**
	 * updates an event record
	 * *
	 */
	public function saveEventDetails($event_id = 0, $data) {
		if (! $event_id)
			return false;
		
		return $this->getDbTable ( 'Application_Model_DbTable_Event' )->update ( $data, array (
				'ID = ?' => $event_id 
		) );
	}
	
	/**
	 * retrieves all matter caseref concatenated with country, detail and event_date
	 * filtered with search term
	 * *
	 */
	public function getAllMatterRefers($term = null) {
		$db = $this->getDbTable ()->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'm' => 'matter' 
		), array (
				'value' => "concat(caseref, country, ', ', e.detail, ', ', e.event_date)",
				'm.ID' 
		) )->joinLeft ( array (
				'e' => 'event' 
		), "m.ID=e.matter_ID AND e.code='FIL'", array (
				'number' => 'e.detail',
				'filing_date' => 'e.event_date' 
		) )->where ( "m.type_code IS NULL AND caseref LIKE '" . $term . "%'" );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves a list of caserefs of container matters
	 * *
	 */
	public function getContainerRefers($caseref = null, $term = null, $matter_id = null) {
		$db = $this->getDbTable ()->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'm' => 'matter' 
		), array (
				'value' => "concat(caseref, country, ', ', e.detail, ', ', e.event_date)",
				'm.ID' 
		) )->joinLeft ( array (
				'e' => 'event' 
		), "m.ID = e.matter_ID AND e.code = 'FIL'", array (
				'number' => 'e.detail',
				'filing_date' => 'e.event_date' 
		) )->where ( "m.caseref = '" . $caseref . "' AND m.ID != '" . $matter_id . "' AND container_ID IS NULL AND caseref LIKE '" . $term . "%'" );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 *
	 * @return UID of a matter
	 *        
	 */
	public function getMatterUID($matter_id = null) {
		if (! isset ( $matter_id ))
			return false;
		$uidsql = "CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', CONCAT(m.caseref, m.country), m.origin), m.type_code), m.idx)";
		$db = $this->getDbTable ()->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'm' => 'matter' 
		), array (
				'UID' => new Zend_Db_Expr ( $uidsql ) 
		) )->where ( 'm.ID = ?', $matter_id );
		$result = $db->fetchRow ( $selectQuery );
		return $result ['UID'];
	}
	
	/**
	 * retrieves all task names and codes from event_name for a given search term in autocomplete
	 * *
	 */
	public function getAllTasks($term = null) {
		$db = $this->getDbTable ( 'Application_Model_DbTable_Event' )->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				'en' => 'event_name' 
		), array (
				'value' => 'name',
				'id' => 'code' 
		) )->where ( "is_task = 1 AND name LIKE '" . $term . "%'" );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * inserts a new task to an event
	 * *
	 */
	public function addTaskToEvent($data = array()) {
		if (empty ( $data ))
			return null;
		
		try {
			$this->getDbTable ( 'Application_Model_DbTable_Task' )->insert ( $data );
			return 1;
		} catch ( Exception $e ) {
			$this->setError ( $e->getMessage () );
			return false;
		}
	}
	
	/**
	 * deletes a task
	 * *
	 */
	public function deleteTask($task_id = null) {
		if (! $task_id)
			return;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Task' );
		$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $task_id );
		try {
			$dbTable->delete ( $where );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * deletes a classifier
	 * *
	 */
	public function deleteClassifier($classifier_id = null) {
		if (! $classifier_id)
			return;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Classifier' );
		$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $classifier_id );
		try {
			$dbTable->delete ( $where );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * retrieves a list of events filtered by a search term
	 * *
	 */
	public function getAllEvents($term = null) {
		$dbSelect = $this->getDbTable ( 'Application_Model_DbTable_Event' )->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'en' => 'event_name' 
		), array (
				'name as value',
				'code as id' 
		) )->where ( "is_task = 0 AND name LIKE '" . $term . "%'" );
		
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * inserts a new event record
	 * *
	 */
	public function addEvent($data = array()) {
		if (empty ( $data ))
			return null;
		
		if (@$data ['alt_matter_ID'] == '')
			$data ['alt_matter_ID'] = NULL;
		
		try {
			$this->getDbTable ( 'Application_Model_DbTable_Event' )->insert ( $data );
			return 1;
		} catch ( Exception $e ) {
			$this->setError ( $e->getMessage () );
			return false;
		}
	}
	
	/**
	 * deletes an event
	 * *
	 */
	public function deleteEvent($event_id = null) {
		if (! $event_id)
			return;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Event' );
		$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $event_id );
		try {
			$dbTable->delete ( $where );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * retrieves count of matter for each category for given user
	 * *
	 */
	public function getCategoryMatterCount($user = null) {
		if (! isset ( $user )) {
			$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
			$user = $siteInfoNamespace->username;
		}
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'm' => 'matter' 
		), array (
				'm.category_code',
				'count(*) as no_of_matters',
				'm.responsible' 
		) )->join ( array (
				'mc' => 'matter_category' 
		), 'm.category_code = mc.code', array (
				'mc.category' 
		) )->where ( "responsible = '" . $user . "'" )->group ( 'category_code' );
		
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves open task or renewals which are assigned to a user or a user is responsible for.
	 * $flag = 1 gives only tasks assigned to the current user
	 */
	public function getUserOpenTasks($user = null, $ren = 0, $flag = 0) { // NOT RENewal
		if (! isset ( $user )) {
			$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
			$user = $siteInfoNamespace->username;
		}
		
		if ($ren == 0)
			$ren_condition = "  AND t.code != 'REN'";
		else if ($ren == 1)
			$ren_condition = "  AND t.code = 'REN'";
		
		if ($flag)
			$where = "(t.assigned_to='" . $user . "') AND t.trigger_ID = e.ID AND m.ID = e.matter_ID and t.code = en.code AND t.done=0 AND m.dead=0" . $ren_condition;
		else
			$where = "'" . $user . "' IN(t.assigned_to, m.responsible, a.login) AND t.trigger_ID = e.ID AND m.ID = e.matter_ID and t.code = en.code AND t.done=0 AND m.dead=0 AND t.due_date < DATE_ADD(NOW(), INTERVAL 1 YEAR)" . $ren_condition;
		
		$this->setDbTable ( 'Application_Model_DbTable_Task' );
		$db = $this->_dbTable->getAdapter ();
		$uidsql = "CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', CONCAT(m.caseref, m.country), m.origin), m.type_code), m.idx)";
		$selectQuery = $db->select ()->from ( array (
				't' => 'task' 
		), array (
				'task_ID' => 't.ID',
				't.code',
				'due_date' => 'DATE_FORMAT(t.due_date, "%d/%m/%Y")',
				'posix_due_date' => 't.due_date',
				'task_detail' => 't.detail',
				't.trigger_ID' 
		) )->join ( array (
				'e' => 'event' 
		), 't.trigger_ID = e.ID', array (
				'MID' => 'e.matter_ID' 
		) )->join ( array (
				'en' => 'event_name' 
		), 't.code=en.code', array (
				'task_name' => 'en.name' 
		) )->join ( array (
				'm' => 'matter' 
		), 'e.matter_ID = m.ID', array (
				'm.caseref',
				'm.country',
				'm.origin',
				'm.type_code',
				'UID' => new Zend_Db_Expr ( $uidsql ) 
		) )->joinLeft ( array (
				'mal' => 'matter_actor_lnk' 
		), "(ifnull(m.container_ID,m.ID) = mal.matter_ID AND mal.role='DEL')" )->joinLeft ( array (
				'a' => 'actor' 
		), "a.ID = mal.actor_ID" )->where ( $where )->order ( array (
				't.due_date',
				'm.caseref' 
		) );
		
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves count of open tasks for each user
	 * *
	 */
	public function getUsersOpenTaskCount() {
		$this->setDbTable ( 'Application_Model_DbTable_Task' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				't' => 'task',
				'm' => 'matter',
				'e' => 'event' 
		), array (
				'no_of_tasks' => 'count(*)',
				'urgent_date' => 'DATE_FORMAT(MIN(t.due_date), "%d/%m/%Y")',
				'posix_urgent_date' => 'MIN(t.due_date)' 
		) )->join ( array (
				'e' => 'event' 
		), 't.trigger_id=e.id' )->join ( array (
				'm' => 'matter' 
		), 'e.matter_id=m.id', array (
				'login' => 'ifnull(t.assigned_to, m.responsible)' 
		) )->where ( 'm.dead=0 AND t.done=0' )->group ( 'login' );
		return $db->fetchAll ( $selectQuery );
	}
	
	/**
	 * returns full details of an open task
	 * *
	 */
	public function getOpenTaskDetails($task_id = 0) {
		if ($task_id == 0)
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Task' );
		$db = $this->_dbTable->getAdapter ();
		$selectQuery = $db->select ()->from ( array (
				't' => 'task' 
		), array (
				't.*',
				'due_date' => 'DATE_FORMAT(t.due_date, "%d/%m/%Y")',
				'DATE_FORMAT(t.done_date, "%d/%m/%Y")' 
		) )->join ( array (
				'en' => 'event_name' 
		), 'en.code=t.code', array (
				'task_name' => 'en.name' 
		) )->where ( 't.ID = ?', $task_id );
		return $db->fetchRow ( $selectQuery );
	}
	
	/**
	 * retrieves list of country names and codes filtered by search term
	 * *
	 */
	public function getCountryCodes($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'c' => 'country' 
		), array (
				'c.iso as id',
				'c.name as value' 
		) )->where ( 'c.name like ? ', $term . '%' )->order ( 'c.name asc' );
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves all matter types filtered by seatch term
	 * *
	 */
	public function getMatterTypes($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'mt' => 'matter_type' 
		), array (
				'mt.code as id',
				'mt.type as value' 
		) )->where ( 'mt.type like ? ', $term . '%' )->order ( 'mt.type asc' );
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * returns caseref for a new matter filtered by caseref search term
	 * *
	 */
	public function getMatterCaseref($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'm' => 'matter' 
		), array (
				"max(caseref) as id",
				"max(caseref) as value" 
		) )->where ( "caseref like  '" . $term . "%' AND container_ID is NULL" );
		$returnval = $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
		if ($returnval [0] ['value'] == NULL) {
			$returnval [0] ['id'] = $term;
			$returnval [0] ['value'] = $term;
		} else {
			$suffix = preg_replace ( '#\D#', '', $returnval [0] ['value'] );
			$suffix = str_pad ( $suffix + 1, strlen ( $suffix ), '0', STR_PAD_LEFT );
			$prefix = preg_replace ( '#\d#', '', $returnval [0] ['value'] );
			$returnval [0] ['value'] = $prefix . $suffix;
			$returnval [0] ['id'] = $returnval [0] ['value'];
		}
		return $returnval;
	}
	
	/**
	 * retrieves all caserefs of matter which are containers
	 * *
	 */
	public function getAllContainerCaseref($term = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'm' => 'matter' 
		), array (
				'm.ID as id',
				'm.caseref as value' 
		) )->where ( "caseref like  '" . $term . "%' AND container_ID is NULL" );
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * return matter_category.ref_prefix for a given matter_category.code
	 * *
	 */
	public function getMatterRefPrefix($category_code = null) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'mc' => 'matter_category' 
		), array (
				'ref_prefix' 
		) )->where ( "mc.code = ?", $category_code );
		return $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
	}
	
	/**
	 * retrieves all main classifier types i.e., classifier_type.main_display=1
	 * these are used as titles in matter view page
	 * *
	 */
	public function getMainClassifierTypes($category = null) {
		if (! isset ( $category ))
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'ct' => 'classifier_type' 
		) )->where ( "(for_category = '" . $category . "' OR for_category IS NULL) AND main_display=1" );
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * retrieves classifier types whose classifier_type.main_display=0
	 * *
	 */
	public function getClassifierTypes() {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		$selectQuery = $dbSelect->from ( array (
				'ct' => 'classifier_type' 
		) )->where ( "main_display=0" );
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * add a new classifier
	 * *
	 */
	public function addClassifier($classifier = array()) {
		if (empty ( $classifier ))
			return false;
		
		$do = $this->getClassifierDisplayorder ( $classifier ['matter_ID'], $classifier ['type_code'] );
		if ($do)
			$classifier ['display_order'] = $do;
		
		$this->setDbTable ( 'Application_Model_DbTable_Classifier' );
		// $this->_dbTable->getAdapter()->query("SET NAMES utf8");
		try {
			$this->_dbTable->insert ( $classifier );
			return $this->_adapter->lastInsertID ();
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * retrieves classfier's next display order for a matter, for a type_code
	 * *
	 */
	public function getClassifierDisplayorder($matter_id = 0, $type_code = null) {
		if (! $matter_id || ! isset ( $type_code ))
			return false;
		
		$container_id = $this->getMatterContainer ( $matter_id );
		$this->setDbTable ( 'Application_Model_DbTable_Classifier' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT ifnull(max(display_order)+1,1) AS ndo FROM classifier WHERE matter_ID=" . $container_id . " AND type_code='" . $type_code . "'" );
		$result = $dbStmt->fetchAll ();
		if ($result ['ndo'] > 0)
			return $result ['ndo'];
		else
			return null;
	}
	
	/**
	 * edits a main (title) classifier
	 * *
	 */
	public function editClassifier($classifier_id = null, $value = null) {
		if (! isset ( $classifier_id ))
			return false;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Classifier' );
		
		if ($value == '') {
			try {
				$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $classifier_id );
				$dbTable->delete ( $where );
			} catch ( Exception $e ) {
				$this->setError ( $e->getMessage () );
				return false;
			}
		} else {
			$data ['value'] = $value;
			try {
				$dbTable->update ( $data, array (
						'ID = ?' => $classifier_id 
				) );
			} catch ( Exception $e ) {
				$this->setError ( $e->getMessage () );
				return false;
			}
		}
	}
	
	/**
	 * updates a classifier
	 * *
	 */
	public function updateClassifier($classifier_id = null, $data = array()) {
		if (! isset ( $classifier_id ) || empty ( $data ))
			return false;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Classifier' );
		
		$dbTable->update ( $data, array (
				'ID = ?' => $classifier_id 
		) );
	}
	
	/**
	 * add a new actor
	 * *
	 */
	public function addActor($actor = array()) {
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		try {
			$this->_dbTable->insert ( $actor );
			return $this->_adapter->lastInsertID ();
		} catch ( Exception $e ) {
			// $this->setError("Actor name '".$actor['name']."' is duplicate entry!" );
			$this->setError ( $e->getMessage () );
			return false;
		}
	}
	
	/**
	 * retrieves column comments defined for a table
	 * *
	 */
	public function getTableComments($table_name = null) {
		if (! isset ( $table_name )) {
			return false;
		}
		
		$infoDb = $this->getInfoDb ();
		$db_detail = $this->_dbTable->getAdapter ()->getConfig ();
		$query = "select column_name, column_comment from columns where table_schema='" . $db_detail ["dbname"] . "' AND table_name='" . $table_name . "'";
		$result = $infoDb->fetchAll ( $query );
		$comments = array ();
		foreach ( $result as $row ) {
			$col_name = $row ['column_name'];
			$comments ["$col_name"] = $row ['column_comment'];
		}
		return $comments;
	}
	
	/**
	 * retrieves enum set defined for a column in a table
	 * *
	 */
	public function getEnumSet($table_name = null, $column_name = null) {
		if (! isset ( $table_name ) && ! isset ( $column_name ))
			return false;
		
		$infoDb = $this->getInfoDb ();
		$db_detail = $this->_dbTable->getAdapter ()->getConfig ();
		$query = "select substring(column_type, 5) as enumset from columns where table_schema='" . $db_detail ["dbname"] . "' AND table_name='" . $table_name . "' and column_name='" . $column_name . "'";
		$result = $infoDb->fetchRow ( $query );
		$enumSet = substr ( $result ['enumset'], 1, - 1 );
		$enumArr = explode ( ",", $enumSet );
		$enums = array ();
		foreach ( $enumArr as $key => $value ) {
			$value = substr ( $value, 1, - 1 );
			$enums ["$value"] = $value;
		}
		return $enums;
	}
	
	/**
	 * Pdo_Mysql connection to database information_schema
	 * *
	 */
	public function getInfoDb() {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db_detail = $this->_dbTable->getAdapter ()->getConfig ();
		
		$db = new Zend_Db_Adapter_Pdo_Mysql ( array (
				'host' => $db_detail ["host"],
				'username' => $db_detail ["username"],
				'password' => $db_detail ["password"],
				'dbname' => 'information_schema' 
		) );
		return $db;
	}
	
	/**
	 * get the country details from country for a given country_code(iso)
	 * *
	 */
	public function getCountryByCode($country_code = null) {
		if (! isset ( $country_code ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'c' => 'country' 
		) )->where ( 'iso = ?', $country_code );
		
		return $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
	}
	
	/**
	 * matter_type details for a given type_code
	 * *
	 */
	public function getTypeCode($type_code = null) {
		if (! isset ( $type_code ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'mt' => 'matter_type' 
		) )->where ( 'code = ?', $type_code );
		
		return $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
	}
	
	/**
	 * this function clones actors from a matter to a newly cloned matter
	 * this is called upon cloning matter
	 * *
	 */
	public function cloneActors($matter_ID = null, $clone_ID = null) {
		if (! isset ( $matter_ID ) || ! isset ( $clone_ID ))
			return false;
		
		$container_ID = $this->getMatterContainer ( $matter_ID );
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$query = "replace into matter_actor_lnk (matter_id, actor_id, display_order, role, shared, actor_ref, company_id, rate, date)
select " . $clone_ID . ", actor_id, display_order, role, shared, actor_ref, company_id, rate, date
from matter_actor_lnk
where matter_id=" . $matter_ID . " or (matter_id=" . $container_ID . " and shared=1)";
		$clquery = $this->_dbTable->getAdapter ()->prepare ( $query );
		$clquery->execute ();
	}
	
	/**
	 * this function copies actors from parent matter to child matter upon creating child matter
	 * *
	 */
	public function childActors($matter_ID = null, $child_ID = null) {
		if (! isset ( $matter_ID ) || ! isset ( $clone_ID ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$query = "replace into matter_actor_lnk (matter_id, actor_id, display_order, role, shared, actor_ref, company_id, rate, date)
select " . $child_ID . ", actor_id, display_order, role, shared, actor_ref, company_id, rate, date
from matter_actor_lnk
where matter_id=" . $matter_ID; // . " or matter_id=(select container_id from matter where id=".$matter_ID.")) and shared=0";
		$clquery = $this->_dbTable->getAdapter ()->prepare ( $query );
		$clquery->execute ();
	}
	
	/**
	 * classifiers of a matter are copied to a clone matter upon creating a new clone for a matter
	 * *
	 */
	public function cloneClassifiers($matter_ID = null, $clone_ID = null) {
		if (! isset ( $matter_ID ) || ! isset ( $clone_ID ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$query = "insert into classifier (matter_id, type_code, value, url, value_id, display_order, lnk_matter_id)
select " . $clone_ID . ", type_code, value, url, value_id, display_order, lnk_matter_id
from classifier where matter_id=ifnull((select container_id from matter where id=" . $matter_ID . "), " . $matter_ID . ")";
		$clquery = $this->_dbTable->getAdapter ()->prepare ( $query );
		$clquery->execute ();
	}
	
	/**
	 * Priority events are copied from a matter to its newly created clone matter
	 * *
	 */
	public function clonePriorities($matter_ID = null, $clone_ID = null) {
		if (! isset ( $matter_ID ) || ! isset ( $clone_ID ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$query = "insert into event (code, matter_id, event_date, alt_matter_id, detail, notes)
select 'PRI', " . $clone_ID . ", event_date, alt_matter_id, detail, notes
from event where matter_id=" . $matter_ID . " and code='PRI';";
		$clquery = $this->_dbTable->getAdapter ()->prepare ( $query );
		$clquery->execute ();
	}
	
	/**
	 * deletes an actor
	 * *
	 */
	public function deleteActor($actor_id = null) {
		if (! $actor_id)
			return;
		
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Actor' );
		$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $actor_id );
		try {
			$dbTable->delete ( $where );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * give permission to an user
	**/
	  public function permitUser($actor_id = null)
	  {
	      if(!$actor_id)
	        return;
	      $this->setDbTable('Application_Model_DbTable_Actor');
	      $dbSelect = $this->_dbTable->getAdapter()->select();
	    	
	    	$selectQuery = $dbSelect->from(array('u'=>'actor'))
	        		->where('u.id = ?', $actor_id);
	      $row = $this->_dbTable->getAdapter()->fetchRow($selectQuery);
	      $passwd = 'changeme';
	      $login = $row['login'];
	      $config = Zend_Registry::get('config');
	      $siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
	      $username = $siteInfoNamespace->username;
	      $password = $siteInfoNamespace->password;
	      $db_detail = $this->_dbTable->getAdapter()->getConfig();
	      $host = $db_detail['host'];
	      try {
	        $dbm = new PDO("mysql:host=$host;dbname=mysql",$username,$password);
	      }
	      catch(Exception $e)
	      {
	        return 'Access denied';
	      }
	      try {
	        $sql1 = "CREATE USER '".$login."'@'%' IDENTIFIED BY '".$passwd."'";
	        $sql2 = "GRANT ALL ON phpip.* TO '".$login."'@'%'";
	        $dbm->exec($sql1);
	        $dbm->exec($sql2);
	      }
	      catch(Exception $e)
	      {
	        return "Unable to insert the user. ";
	      }
	      $this->setDbTable('Application_Model_DbTable_Actor');
	      $data['ipuser']=1;
	      $data['password'] = md5($passwd.'salt');
	      $data['password_salt'] = 'salt'; 
	      $this->getDbTable('Application_Model_DbTable_Actor')->update($data, array('ID = ?' => $actor_id));
	  }

	/**
	 * unpermit an user
	**/
	  public function banUser($actor_id = null)
	  {
	      if(!$actor_id)
	        return;
	    $this->setDbTable('Application_Model_DbTable_Actor');
	    $dbSelect = $this->_dbTable->getAdapter()->select();
    	
	      $selectQuery = $dbSelect->from(array('u'=>'actor'))
	        						->where('u.id = ?', $actor_id);
	      $row = $this->_dbTable->getAdapter()->fetchRow($selectQuery);
	      $login = $row['login'];
	      $config = Zend_Registry::get('config');
	      $siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
	      $username = $siteInfoNamespace->username;
	      $password = $siteInfoNamespace->password;
	      $db_detail = $this->_dbTable->getAdapter()->getConfig();
	      $host = $db_detail['host'];
	      try {
	        $dbm = new PDO("mysql:host=$host;dbname=mysql",$username,$password);
	      }
	      catch(Exception $e)
	      {
	        return 'Echec de la connexion à la base de données '.$e;
	      }
	      try {
	        $sql1 = "DROP USER '".$login."'@'%'";
	        $dbm->exec($sql1);
	      }
	      catch(Exception $e)
	      {
	        return "Echec de la suppression : ".$e->getMessage();
	      }
	      $data['ipuser']=0;
	      $this->getDbTable('Application_Model_DbTable_Actor')->update($data, array('ID = ?' => $actor_id));
	  }

	/**
	 * actor's Matter Dependencies
	 * *
	 */
	public function getActorMatterDependencies($actor_id = null) {
		if (! $actor_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$matter_dependencies_stmt = $this->_dbTable->getAdapter ()->query ( "select matter.id,
          CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', CONCAT(matter.caseref, matter.country), matter.origin), matter.type_code), matter.idx) AS UID,
          actor_role.name as role
          from  matter, matter_actor_lnk, actor_role
          where matter_actor_lnk.matter_id=matter.id
          and matter_actor_lnk.role=actor_role.code
          and matter_actor_lnk.actor_id=$actor_id" );
		return $matter_dependencies_stmt->fetchAll ();
	}
	
	/**
	 * actor's other Dependencies
	 * *
	 */
	public function getActorOtherActorDependencies($actor_id = null) {
		if (! $actor_id)
			return;
		
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$other_actor_dependencies_stmt = $this->_dbTable->getAdapter ()->query ( "select id, concat_ws(' ', name, first_name) as Actor,
         (case $actor_id
           when parent_id then 'Parent'
           when company_id then 'Company'
           when site_id then 'Site'
         end) as Dependency
         from actor
         where $actor_id in (parent_id, company_id, site_id)" );
		return $other_actor_dependencies_stmt->fetchAll ();
	}
	
	/**
	 * get next actor record sorted by actor name
	 * *
	 */
	public function getNextActor($actor_id = null) {
		if (! $actor_id)
			return;
		
		$actor = $this->getActorInfo ( $actor_id );
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT ID FROM actor where name>'" . addslashes ( $actor ['name'] ) . "' ORDER BY name ASC LIMIT 1" );
		$result = $dbStmt->fetchAll ();
		return $this->getActorInfo ( $result [0] ['ID'] );
	}
	
	/**
	 * get previous actor record sorted by actor name
	 * *
	 */
	public function getPrevActor($actor_id = null) {
		if (! $actor_id)
			return;
		
		$actor = $this->getActorInfo ( $actor_id );
		
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT ID FROM actor where name<'" . addslashes ( $actor ['name'] ) . "' ORDER BY name DESC LIMIT 1" );
		$result = $dbStmt->fetchAll ();
		return $this->getActorInfo ( $result [0] ['ID'] );
	}
	
	/**
	 * get an actor from list forwarded by $fwd(=10 default) actors
	 * *
	 */
	public function getForwardActor($actor_id = null, $fwd = 10) {
		if (! $actor_id)
			return;
		
		$actor = $this->getActorInfo ( $actor_id );
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT ID FROM actor where name>'" . addslashes ( $actor ['name'] ) . "' ORDER BY name ASC LIMIT " . ($fwd - 1) . ",1" );
		$result = $dbStmt->fetchAll ();
		return $this->getActorInfo ( $result [0] ['ID'] );
	}
	
	/**
	 * get an actor from list backwarded by $bwd(=10 default) actors
	 * *
	 */
	public function getBackwardActor($actor_id = null, $bwd = 10) {
		if (! $actor_id)
			return;
		
		$actor = $this->getActorInfo ( $actor_id );
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT ID FROM actor where name<'" . addslashes ( $actor ['name'] ) . "' ORDER BY name DESC LIMIT " . ($bwd - 1) . ",1" );
		$result = $dbStmt->fetchAll ();
		return $this->getActorInfo ( $result [0] ['ID'] );
	}
	
	/**
	 * retrieves countries whose ep/wo is set to 1
	 * *
	 */
	public function getFlagCountries($country_flag = null) {
		if (! isset ( $country_flag ))
			return 0;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "SELECT * from country WHERE " . $country_flag . " = 1" );
		return $dbStmt->fetchAll ();
	}
	
	/**
	 * determines whether a matter has filed event or not
	 *
	 * @return boolean
	 *
	 */
	public function hasFiledEvent($matter_id = null) {
		if (! isset ( $matter_id ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'e' => 'event' 
		) )->where ( "code = 'FIL' AND matter_ID='" . $matter_id . "'" );
		
		$result = $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
		if (empty ( $result ))
			return false;
		else
			return true;
	}
	
	/**
	 * updates a matter record
	 * *
	 */
	public function updateMatter($data = array(), $matter_id = 0) {
		if (empty ( $data ))
			return false;
			
			// $this->getDbTable('Application_Model_DbTable_Matter')->getAdapter()->query("SET NAMES utf8");
		$this->getDbTable ( 'Application_Model_DbTable_Matter' )->update ( $data, array (
				'ID = ?' => $matter_id 
		) );
	}
	
	/**
	 * deletes a matter
	 * *
	 */
	public function deleteMatter($matter_id = null) {
		$dbTable = $this->getDbTable ( 'Application_Model_DbTable_Matter' );
		$where = $dbTable->getAdapter ()->quoteInto ( 'ID = ?', $matter_id );
		try {
			$dbTable->delete ( $where );
			return 1;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * return next idx for a new matter created
	 * *
	 */
	public function getNextIdx($matter = array()) {
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		if ($matter ['origin'] == '' || ! isset ( $matter ['origin'] ))
			$origin_sq = "origin is NULL";
		else
			$origin_sq = "origin = '" . $matter ['origin'] . "'";
		
		if ($matter ['type_code'] == '' || ! isset ( $matter ['type_code'] ))
			$type_sq = "type_code is NULL";
		else
			$type_sq = "type_code = '" . $matter ['type_code'] . "'";
		
		$selectQuery = $dbSelect->from ( array (
				'm' => 'matter' 
		), 'max(idx) as midx' )->where ( "caseref = '" . $matter ['caseref'] . "' AND country='" . $matter ['country'] . "' AND " . $origin_sq . " AND " . $type_sq . " AND category_code='" . $matter ['category_code'] . "'" );
		
		$result = $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
		if ($result ['midx'] > 1)
			return ($result ['midx'] + 1);
		else
			return 2;
	}
	
	/**
	 * retrieves list of classifier values for a type_code and a search term
	 * *
	 */
	public function getClassifierValues($type_code = null, $term = '') {
		if (! isset ( $type_code ))
			return false;
		
		$this->setDbTable ( 'Application_Model_DbTable_Classifier' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'cv' => 'classifier_value' 
		), array (
				'cv.id as id',
				'cv.value as value',
				'cv.notes as notes' 
		) )->where ( "type_code = '" . $type_code . "' AND value LIKE '" . $term . "%'" );
		
		return $this->_dbTable->getAdapter ()->fetchAll ( $selectQuery );
	}
	
	/**
	 * adds a new record to classifier_value
	 * *
	 */
	public function addClassifierValue($data) {
		$this->setDbTable ( 'Application_Model_DbTable_ClassifierValue' );
		$this->_dbTable->insert ( $data );
		return $this->_adapter->lastInsertID ();
	}
	
	/**
	 * (Deprecated, use new fetchMatters with optional pagination) fetchMatters is used to navigate through filtered matter list
	 * *
	 */
	/*public function OLDfetchMatters($filter_array = array(), $sortField = "caseref, container_ID, origin, country, matter.type_code, idx", $sortDir = "ASC", $multi_filter = array(), $matter_category_display_type = false) {
		if ($matter_category_display_type)
			$dsiplay_with = " where display_with='$matter_category_display_type'";
		else
			$dsiplay_with = "";
		
		if (empty ( $filter_array ))
			$where_clause = "and (matter.category_code IN (select code from matter_category $dsiplay_with))";
		else {
			$where_clause = "and (matter.category_code IN (select code from matter_category $dsiplay_with))";
			if ($filter_array ['value'] && $filter_array ['field'])
				$where_clause .= " AND " . $filter_array ['field'] . " = '" . $filter_array ['value'] . "'";
			
			if ($filter_array ['field'] == 'Ctnr') {
				$where_clause = "AND matter.container_ID IS NULL";
			}
			
			if ($filter_array ['field'] == 'Pri') {
				$where_clause = "AND EXISTS(SELECT 1 FROM event WHERE event.code='PRI' AND alt_matter_ID=matter.ID)";
			}
		}
		
		if ($sortField == 'caseref') {
			if ($sortDir == 'desc') {
				$sortField = "caseref desc, container_id, origin, country, matter.type_code, idx";
				$sortDir = '';
			}
			if ($sortDir == 'asc') {
				$sortField = "caseref, container_id, origin, country, matter.type_code, idx";
				$sortDir = '';
			}
		}
		if ($sortField == 'Ref') {
			if ($sortDir == 'desc') {
				$sortField = "caseref desc, container_id, origin, country, matter.type_code, idx";
				$sortDir = '';
			}
			if ($sortDir == 'asc') {
				$sortField = "caseref, container_id, origin, country, matter.type_code, idx";
				$sortDir = '';
			}
		}
		
		if ($sortField == "")
			$sortField = "caseref, container_ID";
		
		$having_clause = '';
		if (! empty ( $multi_filter )) {
			foreach ( $multi_filter as $key => $value ) {
				if ($value != '' && $key != 'display' && $key != 'display_style') {
					if ($having_clause == '')
						if ($key == 'responsible')
							$having_clause = " HAVING (responsible = '" . $value . "' OR delegate = '" . $value . "')";
						else
							$having_clause = " HAVING " . $key . " LIKE '" . $value . "%'";
					else if ($key == 'responsible')
						$having_clause .= " AND (responsible = '" . $value . "' OR delegate = '" . $value . "')";
					else
						$having_clause .= " AND " . $key . " LIKE '" . $value . "%'";
				}
			}
		}
		$inventor_filter = 'AND invlnk.display_order = 1';
		if (array_key_exists ( 'Inventor1', $multi_filter )) {
			$inventor_filter = "HAVING inv.name LIKE '" . $multi_filter ['Inventor1'] . "%'";
			// $inventor_filter = '';
		}
		
		$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$dbStmt = $this->_dbTable->getAdapter ()->query ( "select distinct CONCAT_WS('', CONCAT_WS('-', CONCAT_WS('/', concat(caseref, matter.country), origin), matter.type_code), idx) AS Ref,
matter.category_code AS Cat,
matter.country AS country,
matter.origin,
event_name.name AS Status,
status.event_date AS Status_date,
IFNULL(cli.display_name, cli.name) AS Client,
clilnk.actor_ref AS ClRef,
IFNULL(agt.display_name, agt.name) AS Agent,
agtlnk.actor_ref AS AgtRef,
classifier.value AS Title,
CONCAT_WS(' ', inv.name, inv.first_name) as Inventor1,
fil.event_date AS Filed,
fil.detail AS FilNo,
pub.event_date AS Published,
pub.detail AS PubNo,
grt.event_date AS Granted,
grt.detail AS GrtNo,
matter.ID,
matter.container_ID,
matter.parent_ID,
matter.responsible,
del.login AS delegate,
matter.dead,
IF(isnull(matter.container_ID),1,0) AS Ctnr,
1 AS Pri
FROM matter 
  LEFT JOIN (matter_actor_lnk clilnk, actor cli) 
    ON (IFNULL(matter.container_ID,matter.ID) = clilnk.matter_ID AND clilnk.role = 'CLI' AND clilnk.display_order=1 AND cli.ID = clilnk.actor_ID) 
  LEFT JOIN (matter_actor_lnk invlnk,actor inv) 
    ON (ifnull(matter.container_ID,matter.ID) = invlnk.matter_ID AND invlnk.role = 'INV' " . $inventor_filter . " AND inv.ID = invlnk.actor_ID)
  LEFT JOIN (matter_actor_lnk agtlnk, actor agt) 
    ON (matter.ID = agtlnk.matter_ID AND agtlnk.role = 'AGT' AND agtlnk.display_order = 1 AND agt.ID = agtlnk.actor_ID)
  LEFT JOIN (matter_actor_lnk dellnk, actor del) 
    ON (ifnull(matter.container_ID,matter.ID) = dellnk.matter_ID AND dellnk.role = 'DEL' AND del.ID = dellnk.actor_ID)
  LEFT JOIN event fil ON (matter.ID=fil.matter_ID AND fil.code='FIL')
  LEFT JOIN event pub ON (matter.ID=pub.matter_ID AND pub.code='PUB')
  LEFT JOIN event grt ON (matter.ID=grt.matter_ID AND grt.code='GRT')
  LEFT JOIN (event status, event_name) 
    ON (matter.ID=status.matter_ID AND event_name.code=status.code AND event_name.status_event=1)
      LEFT JOIN (event e2, event_name en2) ON e2.code=en2.code AND en2.status_event=1 AND status.matter_id=e2.matter_id AND status.event_date < e2.event_date 
  LEFT JOIN (classifier, classifier_type) 
    ON (classifier.matter_ID = IFNULL(matter.container_ID, matter.ID) AND classifier.type_code=classifier_type.code AND main_display=1 AND classifier_type.display_order=1)
WHERE e2.matter_id IS NULL
" . $where_clause . " " . $having_clause . " order by " . $sortField . " " . $sortDir . ", matter.origin, matter.country" );
		return $dbStmt->fetchAll ();
	}*/
}
