<?php
class IndexController extends Zend_Controller_Action {
	public function init() {
		/* Initialize action controller here */
	}
	public function indexAction() {
		$matterModel = new Application_Model_Matter ();
		$this->view->categories = $matterModel->getCategoryMatterCount ();
		$this->view->open_tasks = $matterModel->getUserOpenTasks ();
		$this->view->ren_tasks = $matterModel->getUserOpenTasks ( null, 1 );
		$this->view->users_list = $matterModel->getUsersOpenTaskCount ();
	}
	public function userPageAction() {
		$username = $this->_getParam ( 'username' );
		$matterModel = new Application_Model_Matter ();
		$this->view->categories = $matterModel->getCategoryMatterCount ( $username );
		$this->view->open_tasks = $matterModel->getUserOpenTasks ( $username );
		$this->view->ren_tasks = $matterModel->getUserOpenTasks ( $username, 1 );
		$this->view->users_list = $matterModel->getUsersOpenTaskCount ();
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

