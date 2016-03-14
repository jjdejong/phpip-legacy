<?php
class Application_Model_User {
	protected $_id;
	protected $_email;
	protected $_firstname;
	protected $_lastname;
	protected $_password;
	protected $_passwordsalt;
	protected $_lastlogin;
	protected $_default_role;
	protected $_createDate;
	protected $_primary = "ID";
	protected $_dbTable;
	protected $_adapter;
	protected $_error;
	public function __construct(array $options = null) {
		if (is_array ( $options )) {
			$this->setOptions ( $options );
		}
	}
	public function __set($name, $value) {
		$method = 'set' . $name;
		if (('mapper' == $name) || ! method_exists ( $this, $method )) {
			throw new Exception ( 'Invalid User property' );
		}
		$this->$method ( $value );
	}
	public function __get($name) {
		$method = 'get' . $name;
		if (('mapper' == $name) || ! method_exists ( $this, $method )) {
			throw new Exception ( 'Invalid User property' );
		}
		return $this->$method ();
	}
	public function setOptions(array $options) {
		$methods = get_class_methods ( $this );
		foreach ( $options as $key => $value ) {
			$method = 'set' . ucfirst ( $key );
			if (in_array ( $method, $methods )) {
				$this->$method ( $value );
			}
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
		if (is_string ( $dbTable )) {
			$dbTable = new $dbTable ();
		}
		if (! $dbTable instanceof Zend_Db_Table_Abstract) {
			throw new Exception ( 'Invalid table data gateway provided' );
		}
		$this->_dbTable = $dbTable;
		$this->_adapter = $dbTable->getAdapter ();
		return $this;
	}
	public function getDbTable($tableName = 'Application_Model_DbTable_Actor') {
		$this->setDbTable ( $tableName );
		return $this->_dbTable;
	}
	public function getAll($username) {
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		$dbSelect = $this->_dbTable->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'u' => 'actor' 
		) )->where ( 'u.login = ?', $username );
		
		return $this->_dbTable->getAdapter ()->fetchRow ( $selectQuery );
	}
	public function updateLastLogin($userID) {
		$this->setDbTable ( 'Application_Model_DbTable_Actor' );
		
		$where = $this->_dbTable->getAdapter ()->quoteInto ( 'ID = ?', $userID );
		$data = array (
				'last_login' => date ( 'Y-m-d H:i:s' ) 
		);
		
		$this->_dbTable->update ( $data, $where );
	}
}
