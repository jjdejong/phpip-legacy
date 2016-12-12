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

class EventController extends Zend_Controller_Action
{
  public function init()
  {
    $siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
    $this->userID = $siteInfoNamespace->userId;
    $this->username = $siteInfoNamespace->username;
  }

/**
 * Displays all Event names list
**/
  public function indexAction()
  {
    $eventModel = new Application_Model_DbTable_EventName();
    $eventslist = $eventModel->getAllEvents();
    $this->view->eventslist = $eventslist;
  }

/**
 * displays and offers in-place edit of event details
**/

    public function viewAction() {
                $this->_helper->layout->disableLayout ();
                $event_id = $this->_getParam ( 'event_id' );
                $eventModel = new Application_Model_DbTable_EventName ();
                $eventInfo = $eventModel->getEventInfo ( $event_id );
                array_push ($eventInfo, array('ID' => $eventInfo['code']));
                $this->view->eventComments = $eventModel->getTableComments ( 'event_name' );
                $this->view->event = $eventInfo;
    }


        public function updateAction() {
                $this->_helper->layout->disableLayout ();
                $this->_helper->viewRenderer->setNoRender ();
                
                if (! $this->getRequest ()->isPost ())
                        return false;
                
                $post_data = $this->getRequest ()->getPost ();
                $event_id = $post_data ['event_id'];
                $field_name = $post_data ['field'];
                $field_value = $post_data ['value'];
                $dvalue = isset ( $post_data ['dvalue'] ) ? $post_data ['dvalue'] : NULL;
                $eventModel = new Application_Model_DbTable_EventName ();
                $eventModel->updateEvent ( $event_id, $field_name, $field_value );
                
                if (isset ( $dvalue ) ) {
                        $field_value = $dvalue;
                }
                echo $field_value;
        }
        
        /**
         * deletes a event
         * *
         */
        public function deleteAction() {
                $this->_helper->layout->disableLayout ();
                $this->_helper->viewRenderer->setNoRender ();
                if ($this->getRequest ()->isPost ()) {
                        $event_id = $this->_getParam ( 'aid' );
                        $eventModel = new Application_Model_DbTable_EventName ();
                        $result = $eventModel->deleteEvent ( $event_id );
                        echo $result;
                }
        }

        /**
         * Displays filtered events from event_name table
         * called when filter term is entered in Rule task input in events page
         * *
         */
        public function filterAction() {
                $this->_helper->layout->disableLayout ();
                $term = $this->_getParam ( 'term' );
                $co = $this->_getParam ( 'co' );
                $eventModel = new Application_Model_DbTable_EventName ();
                if ($co == '0') {
                        $this->view->eventslist = $eventModel->getAllEvents ( $term );
                        array_push ( $this->view->eventslist, array (
                                'event_id' => 'nomatch',
                                'code' => 'Create Event Name' 
                        ) );
                } else {
                        $this->view->eventslist = $eventModel->getAllEventsByName ( $term );
                }
        }

         /**
         * add/create a new event
         * *
         */
        public function addAction() {
                $this->_helper->layout->disableLayout ();
                $request = $this->getRequest ();
                $eventModel = new Application_Model_DbTable_EventName ();
                $eventForm = new Application_Form_Event_Add ();
                if ($request->isPost ()) {
                        $post_data = $request->getPost ();
                        if ($eventForm->isValid ( $post_data )) {
                                
                                foreach ( $post_data as $key => $data ) {
                                        if ($data == "" || substr($key, -5) == '_name')
                                                unset ( $post_data [$key] );
                                }
                                
                                $event_id = $eventModel->addEvent ( $post_data );
                                if ($event_id) {
                                        $this->_helper->viewRenderer->setNoRender ();
                                        $json_data = array ();
                                        $json_data ['event_id'] = $event_id;
                                        echo json_encode ( $json_data );
                                        return;
                                }
                        } else {
                                $this->view->formErrors = $eventForm->getMessages ();
                        }
                }
                $this->view->eventComments = $eventModel->getTableComments ( 'event_name' );
                $this->view->eventForm = $eventForm;
        }

}

