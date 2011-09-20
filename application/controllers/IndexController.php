<?php

class IndexController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        // action body
        //$this->_redirect('/matter');
        $matterModel = new Application_Model_Matter();
        $this->view->categories = $matterModel->getCategoryMatterCount();
        $this->view->open_tasks = $matterModel->getUserOpenTasks();
        $this->view->ren_tasks = $matterModel->getUserOpenTasks(null, 1);
        $this->view->users_list = $matterModel->getUsersOpenTaskCount();
    }

    public function openTaskDetailsAction()
    {
        $this->_helper->layout->disableLayout();

        $task_id = $this->_getParam('task_id');

        $matterModel = new Application_Model_Matter();
        $this->view->task_details = $matterModel->getOpenTaskDetails($task_id);
    }

    public function userOpenTasksAction()
    {
        $username = $this->_getParam('username');

        $matterModel = new Application_Model_Matter();
        $this->view->open_tasks = $matterModel->getUserOpenTasks($username);
        $this->view->ren_tasks = $matterModel->getUserOpenTasks($username, 1);
    }

    public function userPageAction()
    {
        $username = $this->_getParam('username');
        $matterModel = new Application_Model_Matter();
        $this->view->categories = $matterModel->getCategoryMatterCount($username);
        $this->view->open_tasks = $matterModel->getUserOpenTasks($username);
        $this->view->ren_tasks = $matterModel->getUserOpenTasks($username, 1);
        $this->view->users_list = $matterModel->getUsersOpenTaskCount();

        $this->render('index');
    }

}

