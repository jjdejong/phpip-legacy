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
class ActorController extends Zend_Controller_Action {
	public function init() {
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$this->userID = $siteInfoNamespace->userId;
		$this->username = $siteInfoNamespace->username;
	}

	/**
	 * Displays all actors from actor table
	 * *
	 */
	public function indexAction() {
		// $this->_helper->layout->disableLayout();
		$actorModel = new Application_Model_Actor ();
		$this->view->actors = $actorModel->getAllActors ();
	}
	
	/**
	 * Displays all users from actor table
	**/
	public function usersAction() {
	    $actorModel = new Application_Model_Actor();
	    $this->view->users = $actorModel->getAllUsers();
	}

	/**
	 * Displays filtered actors from actor table
	 * called when filter term is entered in actor Name input in actors-table page
	 * *
	 */
	public function filterAction() {
		$this->_helper->layout->disableLayout ();
		$term = $this->_getParam ( 'term' );
		$co = $this->_getParam ( 'co' );
		$actorModel = new Application_Model_Actor ();
		if ($co == '0') {
			$this->view->actors = $actorModel->getAllActors ( $term );
			if (count ( $this->view->actors ) == 0)
				array_push ( $this->view->actors, array (
						'id' => 'nomatch',
						'name' => 'No match. Create Actor?' 
				) );
		} else {
			$this->view->actors = $actorModel->getAllActorsByCo ( $term );
		}
	}
	
	/**
	 * autocompletes companies from actor table (where phy_person=0)
	 * *
	 */
	public function getCompaniesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$actorModel = new Application_Model_Actor ();
		$matter_actors = $actorModel->getAllActors ( $this->view->term, 0 );
		
		echo json_encode ( $matter_actors );
	}
	
	/**
	 * autocompletes roles from actor_role
	 * *
	 */
	public function getRolesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$actorModel = new Application_Model_Actor ();
		$actor_roles = $actorModel->getRoles ( $this->view->term );
		
		echo json_encode ( $actor_roles );
	}
	
	/**
	 * gets all actors for a role
	 * used in autocomplete of actor fields
	 * *
	 */
	public function getAllActorsAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$this->view->role = $this->_getParam ( 'role' );
		$actorModel = new Application_Model_Actor ();
		$actors = $actorModel->getAllActors ( $this->view->term );
		array_push ( $actors, array (
				'id' => 'cna786',
				'value' => '<font color="red">Create Actor</font>' 
		) );
		
		$this->view->matter_actor = $actors;
		echo @json_encode ( $actors );
	}
	
	/**
	 * gets all logins for a role
	 * used in autocomplete of responsible fields
	 * *
	 */
	public function getAllLoginsAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$this->view->role = $this->_getParam ( 'role' );
		$actorModel = new Application_Model_Actor ();
		$this->view->matter_login = $actorModel->getAllLogins ( $this->view->term );
		
		echo json_encode ( $this->view->matter_login );
	}
	
	/**
	 * add/create a new actor
	 * *
	 */
	public function addAction() {
		$this->_helper->layout->disableLayout ();
		$request = $this->getRequest ();
		$actorModel = new Application_Model_Actor ();
		$actorForm = new Application_Form_Actor_Add ();
		if ($request->isPost ()) {
			$post_data = $request->getPost ();
			if ($actorForm->isValid ( $post_data )) {
				
				foreach ( $post_data as $key => $data ) {
					if ($data == "")
						unset ( $post_data [$key] );
				}
				
				$actor_id = $actorModel->addActor ( $post_data );
				if ($actor_id) {
					$this->_helper->viewRenderer->setNoRender ();
					$json_data = array ();
					$json_data ['actor_name'] = $post_data ['name'];
					$json_data ['actor_id'] = $actor_id;
					echo json_encode ( $json_data );
					return;
				} else {
					$this->view->sqlErrors = $actorModel->getError ();
					$default_role = $actorForm->getValue ( 'default_role' );
				}
			} else {
				$this->view->formErrors = $actorForm->getMessages ();
				$default_role = $actorForm->getValue ( 'default_role' );
			}
		} else {
			$default_role = $this->_getParam ( 'role' );
		}
		$role_info = $actorModel->getActorRoleInfo ( $default_role );
		$this->view->actorComments = $actorModel->getTableComments ( 'actor' );
		$actorForm->getElement ( 'default_role' )->setValue ( $role_info ['name'] );
		$enumOpts = $actorModel->getEnumSet ( 'actor', 'pay_category' );
		$actorForm->getElement ( 'pay_category' )->setMultiOptions ( $enumOpts );
		$this->view->actorForm = $actorForm;
		$this->view->default_role = $role_info ['name'];
		$this->view->default_role_code = $role_info ['code'];
	}
	
	/**
	 * displays and offers in-place edit of actor details
	 * *
	 */
	public function viewAction() {
		$this->_helper->layout->disableLayout ();
		$actor_id = $this->_getParam ( 'actor_id' );
		$actorModel = new Application_Model_Actor ();
		$actorInfo = $actorModel->getActorInfo ( $actor_id );
		$this->view->enumOpts = $actorModel->getEnumSet ( 'actor', 'pay_category' );
		$this->view->actorComments = $actorModel->getTableComments ( 'actor' );
		$this->view->actor = $actorInfo;
	}
	
	/**
	 * updates actor field through in-place edit feature
	 * *
	 */
	public function updateAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		
		if (! $this->getRequest ()->isPost ())
			return false;
		
		$post_data = $this->getRequest ()->getPost ();
		$actor_id = $post_data ['actor_id'];
		$field_name = $post_data ['field'];
		$field_value = $post_data ['value'];
		$dvalue = isset ( $post_data ['dvalue'] ) ? $post_data ['dvalue'] : NULL;
		$actorModel = new Application_Model_Actor ();
		$actorModel->updateActor ( $actor_id, $field_name, $field_value );
		
		if (! $actorModel->getError ()) {
			if (isset ( $dvalue ) && ! $actorModel->getError ()) {
				$field_value = $dvalue;
			}
			
			if (in_array ( $field_name, array (
					'address',
					'address_mailing',
					'address_billing',
					'notes' 
			) )) {
				$field_value = nl2br ( $field_value );
			}
			
			echo $field_value;
		} else {
			echo $actorModel->getError ();
		}
	}
	
	/**
	 * deletes an actor
	 * *
	 */
	public function deleteAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		if ($this->getRequest ()->isPost ()) {
			$actor_id = $this->_getParam ( 'aid' );
			$actorModel = new Application_Model_Actor ();
			$result = $actorModel->deleteActor ( $actor_id );
			echo $result;
		}
	}

	/**
	 * permit a user
	**/
	public function permitUserAction() {
	    $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNoRender();
	    if($this->getRequest()->isPost()){
	        $actor_id = $this->_getParam('aid');
	        $actorModel = new Application_Model_Actor();
	        $result = $actorModel->permitUser($actor_id);
	    }
	  }

	/**
	 * ban an user
	**/
	public function banUserAction()
	  {
	    $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNoRender();
	    if($this->getRequest()->isPost()){
	        $actor_id = $this->_getParam('aid');
	        $actorModel = new Application_Model_Actor();
	        $result = $actorModel->banUser($actor_id);
	        $actorInfo = $actorModel->getActorInfo($actor_id);
	        $userModel = new Application_Model_User();
	        $result = $userModel->banLogUser($actorInfo['login']);
	    }
	  }

	
	/**
	 * show Actor Used in details
	 * *
	 */
	public function usedInAction() {
		$this->_helper->layout->disableLayout ();
		if ($this->getRequest ()->isPost ()) {
			$actor_id = $this->_getParam ( 'aid' );
			$actorModel = new Application_Model_Actor ();
			$this->view->matter_dependencies = $actorModel->getActorMatterDependencies ( $actor_id );
			$this->view->other_actor_dependencies = $actorModel->getActorOtherActorDependencies ( $actor_id );
		}
	}
}