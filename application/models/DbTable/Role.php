<?php
class Application_Model_DbTable_Role extends Zend_Db_Table_Abstract {
	protected $_name = 'actor_role';
	protected $_primary = 'code';
	public function fetchRole($term = 0) {
		if (! $term)
			return $this->fetchAll ();
		$select = $this->select ()->where ( 'name like ?', $term . '%' );
		return $this->fetchAll ( $select )->toArray ();
	}
	public function getAllRoles() {
		$select = $this->select ()->from ( $this, array (
				'code',
				'name',
				'shareable' 
		) )->order ( 'name ASC' );
		return $this->fetchAll ( $select )->toArray ();
	}
	public function getRoles($term = null) {
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