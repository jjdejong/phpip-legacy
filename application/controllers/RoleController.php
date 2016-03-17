<?php
class RoleController extends Zend_Controller_Action {
	public function init() {
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$this->userID = $siteInfoNamespace->userId;
		$this->username = $siteInfoNamespace->username;
	}
	public function indexAction() {
		//$this->_helper->layout->disableLayout();
		$this->_helper->viewRenderer->setNoRender ();
		$roleModel = new Application_Model_DbTable_Role ();
		//$this->view->roles = $roleModel->fetchRole ();
		echo json_encode ( $roleModel->getAllRoles () );
	}
	public function getRolesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$roleModel = new Application_Model_DbTable_Role ();
		$roles = $roleModel->getRoles ( $this->view->term );
	
		echo json_encode ( $roles );
		//print_r ($roles);
	}
}
