<?php
class Application_Model_DbTable_Actor extends Zend_Db_Table_Abstract
{
    protected $_name = 'actor';
    protected $_primary = 'ID';
    
    /**
	 * retrieves all actors from actor table filtered by name
	 * $term --search term
	 * $phy_person --whether physical actor or other
	 * *
	 */
	public function getAllActors($term = null, $phy_person = null) {
		$this->getAdapter () ->query ( 'SET NAMES utf8' );
		$select = $this->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.name',
				'a.first_name',
				'a.display_name',
				'a.login',
				'value' => new Zend_Db_Expr ( "CONCAT_WS(', ', a.name, a.first_name, a.display_name)" )
		) )->joinLeft ( array (
				'c' => 'actor' 
		), 'c.ID = a.company_ID', array (
				'company_name' => 'c.name' 
		) )->order ( 'a.name asc' );
		if (isset ( $phy_person ))
			$select->where ( 'a.phy_person = ?', $phy_person );
		if (isset ( $term ))
			$select->where ( 'a.name like ?', $term . '%');
		return $this->fetchAll ( $select )->toArray ();
	}
	
	/**
	 * retrieves all users from actor table filtered by name
	 * $term --search term
	 */
	public function getAllUsers() {
		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		$select = $this->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.name',
				'a.last_login',
				'a.login' 
		) )->where ( "a.login IS NOT NULL" )->order ( 'name ASC' )
		->joinLeft ( array (
				'ar' => 'actor_role' 
		), 'a.default_role = ar.code', array (
				'drole_name' => 'ar.name' 
		) )
		->setIntegrityCheck(false);
		return $this->fetchAll ( $select )->toArray ();
	}
	/**
	 * retrieves all actors from actor table filtered by company
	 */
	public function getAllActorsByCo($term = null) {
		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		$select = $this->select ()->from ( array (
				'a' => 'actor' 
		), array (
				'a.id',
				'a.name',
				'a.first_name',
				'a.display_name',
				'a.login' 
		) )->joinLeft ( array (
				'c' => 'actor' 
		), 'c.ID = a.company_ID', array (
				'company_name' => 'c.name' 
		) )->where ( "c.name LIKE ?", $term . "%" )->order ( 'a.name ASC' );
		return $this->fetchAll ( $select )->toArray ();
	}
	
	/**
	 * retrieves all logins from actor table
	 * *
	 */
	public function getAllLogins($term = null) {
		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		$select = $this->select ()->from ( $this, array (
				'id',
				'value' => 'login',
				'first_name',
				'display_name' 
		) )->where ( 'login LIKE ? ', $term . '%' )->order ( 'login ASC' );
		return $this->fetchAll ( $select )->toArray ();
	}
	

	/**
	 * retrieves full details of an actor
	 * *
	 */
	public function getActorInfo($actor_id = 0) {
		if (! $actor_id)
			return null;
		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		$select = $this->select ()->from ( array (
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
		) )->where ( 'a.ID = ?', $actor_id )->setIntegrityCheck ( false );
		return $this->fetchRow ( $select )->toArray ();
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

		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		try {
			$this->update ( $data, array (
					'ID = ?' => $actor_id 
			) );
			return true;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * add a new actor
	 * *
	 */
	public function addActor($actor = array()) {
		$this->getAdapter ()->query ( 'SET NAMES utf8' );
		try {
			$this->insert ( $actor );
			return $this->getAdapter ()->lastInsertID ();
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}
	
	/**
	 * deletes an actor
	 * *
	 */
	public function deleteActor($actor_id = null) {
		if (! $actor_id)
			return;
		
		try {
			$this->delete ( 'ID = ?', $actor_id );
			return true;
		} catch ( Exception $e ) {
			return $e->getMessage ();
		}
	}

	/**
	 * change the password of an user
	 */
	public function changepwdUser( $newpwd = null) {
		if ( $newpwd == null)
			return "No new pwd";
		$config = Zend_Registry::get ( 'config' );
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$username = $siteInfoNamespace->username;
		$password = $siteInfoNamespace->password;
		$userId =  $siteInfoNamespace->userId;
		$db_detail = $this->getAdapter ()->getConfig ();
		$host = $db_detail ['host'];
		try {
			$dbm = new PDO ( "mysql:host=$host;dbname=mysql", $username, $password );
		} catch ( Exception $e ) {
			return 'Access denied';
		}
		try {
                        echo "Update in phpip";
                        $data ['password'] = md5 ( $newpwd . 'salt' );
                        $data ['password_salt'] = 'salt';
                        $this->update ( $data, array ( 'ID = ?' => $userId ) );
			$sql1 = "SET PASSWORD FOR '" .$username . "'@'localhost' =PASSWORD('" . $newpwd ."')";
			$count = $dbm->exec( $sql1 );
		} catch ( Exception $e ) {
			return "Unable to update password.";
		}
                $siteInfoNamespace->password = $newpwd;
	}
	
	/**
	 * give permission to a user
	 */
	public function permitUser($actor_id = null) {
		if (! $actor_id)
			return;
		$dbSelect = $this->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'u' => 'actor' 
		) )->where ( 'u.id = ?', $actor_id );
		$row = $this->getAdapter ()->fetchRow ( $selectQuery );
		$passwd = 'changeme';
		$login = $row ['login'];
		$config = Zend_Registry::get ( 'config' );
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$username = $siteInfoNamespace->username;
		$password = $siteInfoNamespace->password;
		$db_detail = $this->getAdapter ()->getConfig ();
		$host = $db_detail ['host'];
		try {
			$dbm = new PDO ( "mysql:host=$host;dbname=mysql", $username, $password );
		} catch ( Exception $e ) {
			return 'Access denied';
		}
		try {
			$sql1 = "CREATE USER '" . $login . "'@'%' IDENTIFIED BY '" . $passwd . "'";
			$sql2 = "GRANT ALL ON phpip.* TO '" . $login . "'@'%'";
			$dbm->exec ( $sql1 );
			$dbm->exec ( $sql2 );
		} catch ( Exception $e ) {
			return "Unable to insert the user. ";
		}
		$data ['password'] = md5 ( $passwd . 'salt' );
		$data ['password_salt'] = 'salt';
		$this->update ( $data, array (
				'ID = ?' => $actor_id 
		) );
	}
	
	/**
	 * unpermit a user
	 */
	public function banUser($actor_id = null) {
		if (! $actor_id)
			return;
		$dbSelect = $this->getAdapter ()->select ();
		
		$selectQuery = $dbSelect->from ( array (
				'u' => 'actor' 
		) )->where ( 'u.id = ?', $actor_id );
		$row = $this->getAdapter ()->fetchRow ( $selectQuery );
		$login = $row ['login'];
		$config = Zend_Registry::get ( 'config' );
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$username = $siteInfoNamespace->username;
		$password = $siteInfoNamespace->password;
		$db_detail = $this->getAdapter ()->getConfig ();
		$host = $db_detail ['host'];
		try {
			$dbm = new PDO ( "mysql:host=$host;dbname=mysql", $username, $password );
		} catch ( Exception $e ) {
			return 'Echec de la connexion à la base de données ' . $e;
		}
		try {
			$sql1 = "DROP USER '" . $login . "'@'%'";
			$dbm->exec ( $sql1 );
		} catch ( Exception $e ) {
			return "Echec de la suppression : " . $e->getMessage ();
		}
		$data ['login'] = null;
		$this->update ( $data, array (
				'ID = ?' => $actor_id 
		) );
	}
	
	/**
	 * actor's Matter Dependencies
	 * *
	 */
	public function getActorMatterDependencies($actor_id = null) {
		if (! $actor_id)
			return;
		$matter_dependencies_stmt = $this->getAdapter ()->query ( "select matter.id,
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
		$other_actor_dependencies_stmt = $this->getAdapter ()->query ( "select id, concat_ws(' ', name, first_name) as Actor,
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
	
	/**
	 * retrieves enum set defined for a column in a table
	 * *
	 */
	public function getEnumSet($table_name = null, $column_name = null) {
		if (! isset ( $table_name ) && ! isset ( $column_name ))
			return false;
		
		$infoDb = $this->getInfoDb ();
		$db_detail = $this->getAdapter ()->getConfig ();
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
		//$this->setDbTable ( 'Application_Model_DbTable_Matter' );
		$db_detail = $this->getAdapter ()->getConfig ();
		
		$db = new Zend_Db_Adapter_Pdo_Mysql ( array (
				'host' => $db_detail ["host"],
				'username' => $db_detail ["username"],
				'password' => $db_detail ["password"],
				'dbname' => 'information_schema' 
		) );
		return $db;
	}
}
