<?php
class Application_Model_DbTable_Role extends Zend_Db_Table_Abstract {
	protected $_name = 'actor_role';
	protected $_primary = 'code';

	public function getAllRoles() {
		return $this->fetchAll ()->toArray ();
	}
	public function findRoles($term = null) {
		$select = $this->select ()->from ( $this, array (
				'id' => 'code',
				'value' => 'name',
				'shareable' 
		) )->order ( 'name ASC' )->where ( "name LIKE ?", $term . "%" );
		return $this->fetchAll ( $select )->toArray ();
	}
	public function getRole($role = null) {
		if ($role) {
			return $this->fetchRow ( $this->select()->where ( 'code = ?', $role ) );
		}
	}
}