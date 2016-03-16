<?php
class IndexController extends Zend_Controller_Action {
	public function init() {
		/* Initialize action controller here */
	}
	public function indexAction() {
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$username = $siteInfoNamespace->username;
		$role = $siteInfoNamespace->role;
		if ( $role == 'CLI' )
			$this->view->restricted = 1; // For removing controls that give acces to unavailable actions
		else
			$this->view->restricted = 0;
		$matterModel = new Application_Model_Matter ();
		$this->view->categories = $matterModel->getCategoryMatterCount ();
		$this->view->open_tasks = $matterModel->getUserOpenTasks ();
		$this->view->ren_tasks = $matterModel->getUserOpenTasks ( null, 1 );
		$this->view->users_list = $matterModel->getUsersOpenTaskCount ();
		$this->view->responsible = $username;
	}
	public function userPageAction() {
		$username = $this->_getParam ( 'username' );
		$matterModel = new Application_Model_Matter ();
		$this->view->categories = $matterModel->getCategoryMatterCount ( $username );
		$this->view->open_tasks = $matterModel->getUserOpenTasks ( $username );
		$this->view->ren_tasks = $matterModel->getUserOpenTasks ( $username, 1 );
		$this->view->users_list = $matterModel->getUsersOpenTaskCount ();
		$this->view->responsible = $username;
		$this->view->restricted = 0; // This user-page action is not available from the index view
		$this->render ( 'index' );
	}
	public function taskFilterAction() {
		$this->_helper->layout->disableLayout ();
		$task_type = $this->_getParam ( 'task_type' );
		$task_filter = $this->_getParam ( 'filter' );
		$matterModel = new Application_Model_Matter ();
		if ($task_type == 'open')
			$this->view->open_tasks = $matterModel->getUserOpenTasks ( null, 0, $task_filter );
		else
			$this->view->open_tasks = $matterModel->getUserOpenTasks ( null, 1, $task_filter );
	}
}

