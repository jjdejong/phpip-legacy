<?php
class Application_Plugins_AclController extends Zend_Controller_Plugin_Abstract {
	
	/**
	 *
	 * @var Zend_Auth
	 */
	protected $_auth;
	protected $_acl;
	protected $_action;
	protected $_controller;
	protected $_currentRole;
	public function __construct(Zend_Acl $acl, array $options = array()) {
		$this->_auth = Zend_Auth::getInstance ();
		$this->_acl = $acl;
	}
	public function preDispatch(Zend_Controller_Request_Abstract $request) {
		$this->_init ( $request );
		
		// if the current user role is not allowed to do something
		if (! $this->_acl->isAllowed ( $this->_currentRole, $this->_controller, $this->_action )) {
			
			if ('guest' == $this->_currentRole) {
				$request->setControllerName ( 'auth' )
					->setActionName ( 'login' );
			} else {
				throw new exception('Unauthorized');
				/*$request->setControllerName ( 'error' )
					->setActionName ( 'error' )
					->setDispatched ( true );*/
			}
		}
	}
	protected function _init($request) {
		$this->_action = $request->getActionName ();
		$this->_controller = $request->getControllerName ();
		$this->_currentRole = $this->_getCurrentUserRole ();
	}
	protected function _getCurrentUserRole() {
		if ($this->_auth->hasIdentity ()) {
			$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
			$role = $siteInfoNamespace->role;
			if ( $role != 'CLI')
				$role = 'DBADM';
		} else {
			$role = 'guest';
		}
		//echo $role;
		return $role;
	}
}