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

class RuleController extends Zend_Controller_Action
{
  public function init()
  {
    $siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
    $this->userID = $siteInfoNamespace->userId;
    $this->username = $siteInfoNamespace->username;
  }

/**
 * Displays all Rules list
**/
  public function indexAction()
  {
    /*$filter_array['value'] = $this->_getParam('value');
    $filter_array['field'] = $this->_getParam('filter');

    $get_sort = $this->_getParam('sort');
    $get_dir = $this->_getParam('dir');
    $sort_field = isset($get_sort) ? $get_sort : 'task';
    $sort_dir = isset($get_dir) ? $get_dir : 'asc';
    $this->view->category_display = $this->_getParam('display');
    $this->view->display_style = $this->_getParam('displaystyle');

    $page = $this->_getParam('page',1);

    $mfs = new Zend_Session_Namespace('rule_filter');
    $mfs->filter_array = $filter_array;
    $mfs->sort_field = $sort_field;
    $mfs->sort_dir = $sort_dir;
    $mfs->multi_sort = array();
    $mfs->display_style = $this->view->display_style;
    $mfs->category_display = $this->view->category_display;*/

    $ruleModel = new Application_Model_DbTable_Rule();
    //$ruleslist = $ruleModel->fetchRules($filter_array, $sort_field, $sort_dir, array(), false, false);
    $ruleslist = $ruleModel->getAllRules();
    $this->view->ruleslist = $ruleslist;
//    $this->view->sort_id = 'task';
//    $this->view->sort_dir = 'asc';
  }

/**
 * displays and offers in-place edit of rule details
**/

    public function viewruleAction() {
                $this->_helper->layout->disableLayout ();
                $rule_id = $this->_getParam ( 'rule_id' );
                $ruleModel = new Application_Model_DbTable_Rule ();
                $ruleInfo = $ruleModel->getRuleInfo ( $rule_id );
                array_push ($ruleInfo, array('ID' => $ruleInfo['rule_id']));
                $this->view->ruleComments = $ruleModel->getTableComments ( 'task_rules' );
                $this->view->rule = $ruleInfo;
    }


        public function updateAction() {
                $this->_helper->layout->disableLayout ();
                $this->_helper->viewRenderer->setNoRender ();
                
                if (! $this->getRequest ()->isPost ())
                        return false;
                
                $post_data = $this->getRequest ()->getPost ();
                $rule_id = $post_data ['rule_id'];
                $field_name = $post_data ['field'];
                $field_value = $post_data ['value'];
                $dvalue = isset ( $post_data ['dvalue'] ) ? $post_data ['dvalue'] : NULL;
                $ruleModel = new Application_Model_DbTable_Rule ();
                $ruleModel->updateRule ( $rule_id, $field_name, $field_value );
                
                //if (! $ruleModel->getErrors ()) {
                        if (isset ( $dvalue ) ) {
                                $field_value = $dvalue;
                        }
                        echo $field_value;
                //} else {
                //      echo $ruleModel->getError ();
                //}
        }
        
        /**
         * deletes a rule
         * *
         */
        public function deleteAction() {
                $this->_helper->layout->disableLayout ();
                $this->_helper->viewRenderer->setNoRender ();
                if ($this->getRequest ()->isPost ()) {
                        $rule_id = $this->_getParam ( 'aid' );
                        file_put_contents('php://stderr', print_r("Controler ".$rule_id, TRUE));
                        $ruleModel = new Application_Model_DbTable_Rule ();
                        $result = $ruleModel->deleteRule ( $rule_id );
                        echo $result;
                }
        }

        /**
         * Displays filtered rules from task_rules table
         * called when filter term is entered in Rule task input in rules page
         * *
         */
        public function filterAction() {
                $this->_helper->layout->disableLayout ();
                $term = $this->_getParam ( 'term' );
                $co = $this->_getParam ( 'co' );
                $ruleModel = new Application_Model_DbTable_Rule ();
                if ($co == '0') {
                        $this->view->ruleslist = $ruleModel->getAllRules ( $term );
                        array_push ( $this->view->ruleslist, array (
                                'rule_id' => 'nomatch',
                                'task_name' => 'Create Rule' 
                        ) );
                } else {
                        $this->view->ruleslist = $ruleModel->getAllRulesByCountry ( $term );
                }
        }

         /**
         * add/create a new rule
         * *
         */
        public function addAction() {
                $this->_helper->layout->disableLayout ();
                $request = $this->getRequest ();
                $ruleModel = new Application_Model_DbTable_Rule ();
                $ruleForm = new Application_Form_Rule_Add ();
                if ($request->isPost ()) {
                        $post_data = $request->getPost ();
                        if ($ruleForm->isValid ( $post_data )) {
                                
                                $task_name = $post_data ['task_name'];
                                foreach ( $post_data as $key => $data ) {
                                        if ($data == "" || substr($key, -5) == '_name')
                                                unset ( $post_data [$key] );
                                }
                                
                                $rule_id = $ruleModel->addRule ( $post_data );
                                if ($rule_id) {
                                        $this->_helper->viewRenderer->setNoRender ();
                                        $json_data = array ();
                                        $json_data ['rule_name'] = $task_name;
                                        $json_data ['rule_id'] = $rule_id;
                                        echo json_encode ( $json_data );
                                        return;
                                }
                        } else {
                                $this->view->formErrors = $ruleForm->getMessages ();
                        }
                }
                $this->view->ruleComments = $ruleModel->getTableComments ( 'task_rules' );
                $this->view->ruleForm = $ruleForm;
        }

        public function getTaskNamesAction () {
                $this->_helper->layout->disableLayout ();
                $this->_helper->viewRenderer->setNoRender ();
                $ruleModel = new Application_Model_DbTable_Rule ();
                $results = $ruleModel->getTaskNames( $term= $this->_getParam ( 'term' ) );
                echo json_encode ( $results );
        }
}

