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
class MatterController extends Zend_Controller_Action {
	public function init() {
		$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
		$this->userID = $siteInfoNamespace->userId;
		$this->username = $siteInfoNamespace->username;
	}

	/**
	 * Displays all Matters list
	 * *
	 */
	public function indexAction() {
		$get_sort = $this->_getParam ( 'sort' );
		$get_dir = $this->_getParam ( 'dir' );
		$sort_field = isset ( $get_sort ) ? $get_sort : 'caseref';
		$sort_dir = isset ( $get_dir ) ? $get_dir : 'asc';
		$this->view->category_display = $this->_getParam ( 'display' );
		$this->view->display_style = $this->_getParam ( 'displaystyle' );

		$page = $this->_getParam ( 'page', 1 );

		$mfs = new Zend_Session_Namespace ( 'matter_filter' );
		$mfs->sort_field = $sort_field;
		$mfs->sort_dir = $sort_dir;
		$mfs->multi_sort = array ();
		$mfs->display_style = $this->view->display_style;
		$mfs->category_display = $this->view->category_display;

		$matterModel = new Application_Model_Matter ();
		$paginator = $matterModel->fetchMatters ( $sort_field, $sort_dir, array (), $this->view->category_display, true );
		$paginator->setCurrentPageNumber ( $page );
		$paginator->setItemCountPerPage ( 25 );

		$this->view->paginator = $paginator;
		$this->view->sort_id = 'caseref';
		$this->view->sort_dir = 'asc';
	}

	/**
	 * to add a new Matter
	 * *
	 */
	public function addAction() {
		$this->_helper->layout->disableLayout ();
		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$matter ['category_code'] = $this->getRequest ()->getPost ( 'category_code' );
			$matter ['country'] = $this->getRequest ()->getPost ( 'country' );
			$matter ['origin'] = $this->getRequest ()->getPost ( 'origin' );
			$matter ['type_code'] = $this->getRequest ()->getPost ( 'type_code' );
			$matter ['caseref'] = $this->getRequest ()->getPost ( 'caseref' );
			$matter ['responsible'] = $this->getRequest ()->getPost ( 'responsible' );

			if ($matter ['origin'] == '')
				unset ( $matter ['origin'] );

			if ($matter ['type_code'] == '')
				unset ( $matter ['type_code'] );

			$matterModel = new Application_Model_Matter ();
			$result = $matterModel->save ( $matter );
			echo $result;
		} else {
			$category_id = $this->_getParam ( 'category_id' );
			$category_arr = explode ( '-', $category_id );
			if (! isset ( $category_arr [1] ))
				$category_arr [1] = "";
			$this->view->category = $category_arr [0];
			$this->view->category_code = $category_arr [1];
			$this->view->username = $this->username;

			$matterModel = new Application_Model_Matter ();
			$matter_ref = $matterModel->getMatterRefPrefix ( $category_arr [1] );
			$caseref = $matterModel->getMatterCaseref ( $matter_ref ['ref_prefix'] );
			$this->view->caseref = $caseref [0] ['id'];
			$this->view->matter_title = "Add new Matter";
			$this->view->matter_cap = "Add Matter";
			$this->view->matter_cap_id = "add-matter-submit";
		}
	}

	/**
	 * Matter detail page
	 * *
	 */
	public function viewAction() {
		$matter_id = $this->_getParam ( 'id', 0 );
		$matter_index = $this->_getParam ( 'rid' );

		$matterModel = new Application_Model_Matter ();
		$this->view->matter_record = $matterModel->getMatter ( $matter_id );
		$this->view->matter_actors = $matterModel->getMatterActors ( $matter_id, $this->view->matter_record [0] ['container_ID'] );

		if ($this->view->matter_record [0] ['parent_ID'] > 0)
			$this->view->matter_parent = $matterModel->getMatter ( $this->view->matter_record [0] ['parent_ID'] );
		else
			$this->view->matter_parent = 0;

		if ($this->view->matter_record [0] ['container_ID'] > 0)
			$this->view->matter_container = $matterModel->getMatter ( $this->view->matter_record [0] ['container_ID'] );
		else
			$this->view->matter_container = 0;

		$this->view->matter_events = $matterModel->getMatterEvents ( $matter_id );
		$this->view->matter_open_tasks = $matterModel->getOpenTasks ( $matter_id );
		$this->view->matter_open_tasks_ren = $matterModel->getOpenTasksREN ( $matter_id );
		$this->view->matter_expiry = $matterModel->getMatterExpiry ( $matter_id );
		$this->view->matter_classifier = $matterModel->getClassifier ( $matter_id );
		$this->view->matter_classifier_main = $matterModel->getClassifier ( $matter_id, 1 );
		$this->view->matter_classifier_container = $matterModel->getClassifier ( $this->view->matter_record [0] ['container_ID'] );
		$this->view->matter_classifier_container_main = $matterModel->getClassifier ( $this->view->matter_record [0] ['container_ID'], 1 );
		$this->view->classifiers = $matterModel->getClassifiers ( $matter_id );
		$this->view->matter_id = $matter_id;
		$this->view->matter_index = $matter_index;
		$this->view->national_phase = 0;
		if (in_array ( $this->view->matter_record [0] ['country'], array (
				'EP',
				'WO',
				'OA',
				'EM'
		) )) {
			$this->view->national_phase = 1;
		}
	}

	/**
	 * to edit a Matter
	 * *
	 */
	public function editAction() {
		$request = $this->getRequest ();
		$matterModel = new Application_Model_Matter ();
		$this->_helper->layout->disableLayout ();
		if ($request->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$data = $request->getPost ();
			$matter_id = $data ['matter_id'];
			$caseref_prev = $data ['caseref_prev'];
			unset ( $data ['matter_id'] );
			unset ( $data ['caseref_prev'] );

			foreach ( $data as $key => $val ) {
				if ($val == "")
					$data [$key] = NULL;
			}

			if (! $matterModel->isMatterUnique ( $data, $matter_id )) {
				$nidx = $matterModel->getNextIdx ( $data );
				if ($data ['caseref'] == $caseref_prev) {
					$data ['idx'] = $nidx;
				} else {
					echo "caseidx-" . $nidx;
					return;
				}
			}

			$matterModel->updateMatter ( $data, $matter_id );
			echo $matter_id;
		} else {
			$matter_id = $this->_getParam ( 'mid' );
			$matterInfo = $matterModel->getMatter ( $matter_id );

			if ($matterModel->hasFiledEvent ( $matter_id )) {
				$this->view->cat_edit = 0;
				$this->view->country_edit = 0;
			} else {
				$this->view->cat_edit = 1;
				$this->view->country_edit = 1;
			}

			$this->view->matter = $matterInfo [0];

			$origin_arr = $matterModel->getCountryByCode ( $matterInfo [0] ['origin'] );
			$this->view->origin_name = $origin_arr ['name'];
			$this->view->origin_code = $origin_arr ['iso'];

			$type_arr = $matterModel->getTypeCode ( $matterInfo [0] ['type_code'] );
			$this->view->type_name = $type_arr ['type'];
			$this->view->type_code = $type_arr ['code'];

			if ($matterInfo [0] ['parent_ID']) {
				$this->view->parent = $matterModel->getMatterUID ( $matterInfo [0] ['parent_ID'] ) . " (" . $matterInfo [0] ['parent_ID'] . ")";
				$this->view->parent_id = $matterInfo [0] ['parent_ID'];
			}
			if ($matterInfo [0] ['container_ID']) {
				$this->view->container = $matterModel->getMatterUID ( $matterInfo [0] ['container_ID'] ) . " (" . $matterInfo [0] ['container_ID'] . ")";
				$this->view->container_id = $matterInfo [0] ['container_ID'];
			}

			$this->view->cats = $matterModel->getAllCategories ();
			$this->view->types = $matterModel->getMatterTypes ();
		}
	}

	/**
	 * displays all task list
	 * called upon clicking tasks box in matter view page
	 * *
	 */
	public function tasklistAction($renewal = 0) {
		$this->_helper->layout->disableLayout ();
		$matter_id = $this->_getParam ( 'matter_id' );
		$event_id = $this->_getParam ( 'event_id' );
		$renewal = $this->_getParam ( 'renewal' );
		$matterModel = new Application_Model_Matter ();
		$this->view->matter_event_tasks = $matterModel->getMatterEventTasks ( $matter_id, $renewal, $event_id );
		$this->view->renewal = $renewal;
		$this->view->matter_id = $matter_id;
		$this->view->event_id = $event_id;
	}

	/**
	 * displays all events
	 * called upon clicking events box in matter view page
	 * *
	 */
	public function eventlistAction() {
		$this->_helper->layout->disableLayout ();
		$matter_id = $this->_getParam ( 'id' );
		$matterModel = new Application_Model_Matter ();
		$this->view->matter_events = $matterModel->getMatterAllEvents ( $matter_id );
		$this->view->matter_id = $matter_id;
	}

	/**
	 * Displays all classifiers list
	 * called upon clicking classifier box in matter view page
	 * *
	 */
	public function classifierlistAction() {
		$this->_helper->layout->disableLayout ();
		$matter_id = $this->_getParam ( 'id' );
		$matterModel = new Application_Model_Matter ();
		$this->view->classifiers = $matterModel->getMatterClassifiers ( $matter_id );
	}

	/**
	 * Adds an actor to a selected role
	 * *
	 */
	public function mapActorRoleAction() {
		$this->_helper->layout->disableLayout ();
		$this->view->matter_id = $this->_getParam ( 'id' );
		$this->view->role = $this->_getParam ( 'role' );
		$this->view->search_role = $this->_getParam ( 'search_role' );
		$this->view->role_search = $this->_getParam ( 'role_search' );

		if ($this->view->role_search == "")
			$this->view->role_search = $this->view->role;

		$matterModel = new Application_Model_Matter ();
		$roleModel = new Application_Model_DbTable_Role ();
		$this->view->all_roles = $roleModel->getAllRoles ();

		$this->view->container_id = $matterModel->getMatterContainer ( $this->view->matter_id );
	}

	/**
	 * gets all categories
	 * used in autocomplete of category fields
	 * *
	 */
	public function getAllCategoriesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );
		$matterModel = new Application_Model_Matter ();
		$this->view->matter_categories = $matterModel->getAllCategories ( $this->view->term );

		echo json_encode ( $this->view->matter_categories );
	}

	/**
	 * displays actors for a particular role and provides editing and sorting of the list
	 * called upon clicking role in actors' box in matter view page
	 * *
	 */
	public function roleActorsAction() {
		$this->_helper->layout->disableLayout ();
		if (! $this->getRequest ()->isPost ())
			return;

		$matter_id = $this->_getParam ( 'matter_id' );
		$role_id = $this->_getParam ( 'role_id' );

		$matterModel = new Application_Model_Matter ();
		$actorModel = new Application_Model_DbTable_Actor ();
		$roleModel = new Application_Model_DbTable_Role ();
		$matter_record = $matterModel->getMatter ( $matter_id );

		$this->view->role_actors = $matterModel->getMatterActorsForRole ( $matter_record [0] ['container_ID'], $matter_id, $role_id );
		$this->view->role = $this->view->role_actors [0] ['role_name'];
		$this->view->matter_id = $matter_id;
		$this->view->actor_role = $roleModel->getRole ( $role_id );
		$this->view->actors_count = count ( $this->view->role_actors );
	}

	/**
	 * Updates actor_role
	 * *
	 */
	public function saveRoleAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$role_code = $this->getRequest ()->getPost ( 'role_code' );
		$role_data = $this->getRequest ()->getPost ();
		unset ( $role_data ['role_code'] );
		$matterModel = new Application_Model_DbTable_Role ();
		$matterModel->update ( $role_data, array ( 'code = ?' => $role_code ) );
	}

	/**
	 * Actor is linked to Matter
	 * an entry is inserted into matter_actor_lnk
	 * *
	 */
	public function addMatterActorAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;
		$data = array ();

		$matterModel = new Application_Model_Matter ();
		$actorModel = new Application_Model_DbTable_Actor ();
		$roleModel = new Application_Model_DbTable_Role ();
		$matter_id = $this->getRequest ()->getPost ( 'matter_ID' );
		$data ['actor_ID'] = $this->getRequest ()->getPost ( 'actor_ID' );
		$data ['role'] = $this->getRequest ()->getPost ( 'role' );
		$container_id = $matterModel->getMatterContainer ( $matter_id );
		$data ['actor_ref'] = $this->getRequest ()->getPost ( 'actor_ref' );
		$role_shareable = $this->getRequest ()->getPost ( 'role_shareable' );
		$data ['shared'] = $roleModel->getRole ( $data ['role'] )['shareable'];

		if ($this->getRequest ()->getPost ( 'add_container' ) && $container_id) {
			$data ['matter_ID'] = $container_id;
			if ($role_shareable == 0)
				$data ['shared'] = 1;
		} else {
			$data ['matter_ID'] = $matter_id;
			$data ['shared'] = 0;
		}

		$actor_info = $actorModel->getActorInfo ( $data ['actor_ID'] );
		$data ['company_ID'] = $actor_info ['company_ID'];
		$data ['display_order'] = $matterModel->getNextDisplayOrder ( $matter_id, $container_id, $data ['role'] );
		$data ['date'] = date ( 'Y-m-d' );

		$result = $matterModel->addMatterActor ( $data );
		if ($matterModel->getError ()) {
			echo $matterModel->getError ();
		}
	}

	/**
	 * Updates a record in matter_actor_lnk
	 * *
	 */
	public function saveMatterActorAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$post_data = $this->getRequest ()->getPost ();
		$display_val = $post_data ['value'];
		if (isset ( $post_data ['field'] ))
			if ($post_data ['val'] == 0)
				$data [$post_data ['field']] = null;
			else
				$data [$post_data ['field']] = $post_data ['val'];
		else
			$data [$post_data ['id']] = $post_data ['value'];
		$matter_actor_id = $post_data ['matter_actor_id'];
		$matterModel = new Application_Model_Matter ();
		$matterModel->saveMatterActor ( $matter_actor_id, $data );
		echo $display_val;
	}

	/**
	 * Deletes an actor linked to matter from matter_actor_lnk
	 * *
	 */
	public function deleteMatterActorAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$mal_id = $this->getRequest ()->getPost ( 'mal_id' );
		$matterModel = new Application_Model_Matter ();
		$result = $matterModel->deleteMatterActor ( $mal_id );
		echo $result;
	}

	/**
	 * saves actors display order for a role
	 * *
	 */
	public function saveDisplayOrderAction() // actors display order
{
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;
		$mal_ids = $this->getRequest ()->getPost ( 'order_list' );
		$mal_arr = explode ( ",", $mal_ids );
		$matterModel = new Application_Model_Matter ();
		$data = array ();
		foreach ( $mal_arr as $key => $value ) :
			$data ['display_order'] = $key + 1;
			$matterModel->saveMatterActor ( $value, $data );
		endforeach
		;
	}

	/**
	 * updates Matter for each field specified
	 * used to update matter on in-place edit
	 * *
	 */
	public function updateMatterAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return false;

		$post_data = $this->getRequest ()->getPost ();
		$matter_id = $post_data ['matter_id'];
		$field_name = $post_data ['field'];
		$field_value = $post_data ['value'];

		$data ["$field_name"] = $field_value;
		$matterModel = new Application_Model_Matter ();
		$matterModel->updateMatter ( $data, $matter_id );

		echo nl2br ( $field_value );
	}

	/**
	 * updates task for each field specified from in-place edit
	 * *
	 */
	public function updateTaskAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return false;

		$post_data = $this->getRequest ()->getPost ();
		$task_id = $post_data ['task_id'];
		$field_name = $post_data ['field'];
		$field_value = $post_data ['value'];
		$rule_id = 'none';
		if (isset ( $post_data ['rule_id'] ) && $post_data ['rule_id'] )
			$rule_id = NULL;

		if ($field_name == 'done_date' && $field_value == '')
			$field_value = date ( 'Y-m-d' );
		elseif ($field_value == '')
			$field_value = NULL;

		$matterModel = new Application_Model_Matter ();
		$matterModel->saveTaskDetails ( $task_id, $field_name, $field_value, $rule_id );

		echo $field_value;
	}

	/**
	 * clears multiple tasks for a given done_date
	 * *
	 */
	public function clearTasksAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return false;

		$post_data = $this->getRequest ()->getPost ();
		$task_ids = $post_data ['task_ids'];
		$done_date = $post_data ['done_date'];

		$matterModel = new Application_Model_Matter ();
		$result = $matterModel->clearTasks ( $task_ids, $done_date );
		echo $result;
	}

	/**
	 * updates event for a specified field from in-place edit feature
	 * *
	 */
	public function updateEventAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$post_data = $this->getRequest ()->getPost ();
		$event_id = $post_data ['event_id'];
		$field_name = $post_data ['field'];
		$field_value = $post_data ['value'];
		$data = array ();
		if ($field_value == "")
			$data ["$field_name"] = NULL;
		else
			$data ["$field_name"] = $field_value;

		if ($field_name == 'event_date')
			$data ["$field_name"] = new Zend_Db_Expr ( "STR_TO_DATE('$field_value', '%d/%m/%Y' )" );

		if ($field_name == 'alt_matter_ID') {
			if ($post_data ['alt_matter'] == "")
				$data ["$field_name"] = NULL;
			else
				$data ["$field_name"] = $post_data ['alt_matter'];
		}
		$matterModel = new Application_Model_Matter ();
		$matterModel->saveEventDetails ( $event_id, $data );

		echo $post_data ['value'];
	}

	/**
	 * gets autocomplete list from all caserefs
	 * *
	 */
	public function getAllRefersAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$term = $this->_getParam ( 'term' );
		$matterModel = new Application_Model_Matter ();
		$matter_refers = $matterModel->getAllMatterRefers ( $term );
		// print_r($matter_refers); exit();
		echo json_encode ( $matter_refers );
	}

	/**
	 * gets autocomplete list from caserefs of container matters
	 * *
	 */
	public function getContainerRefersAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$term = $this->_getParam ( 'term' );
		$caseref = $this->_getParam ( 'caseref' );
		$matter_id = $this->_getParam ( 'matter_id' );

		$matterModel = new Application_Model_Matter ();
		$matter_refers = $matterModel->getContainerRefers ( $caseref, $term, $matter_id );
		// print_r($matter_refers); exit();
		echo json_encode ( $matter_refers );
	}

	/**
	 * autocompletes task name
	 * *
	 */
	public function getAllTasksAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$matterModel = new Application_Model_Matter ();
		$matter_tasks = $matterModel->getAllTasks ( $this->_getParam ( 'term' ) );
		echo json_encode ( $matter_tasks );
	}

	/**
	 * Adds a task to an event
	 * *
	 */
	public function addEventTaskAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$post_data = $this->getRequest ()->getPost ();

		$date = explode ( "/", $post_data ['due_date'] );
		$post_data ['due_date'] = date ( "Y-m-d", mktime ( 0, 0, 0, $date [1], $date [0], $date [2] ) );

		foreach ( $post_data as $key => $data ) {
			if ($data == "")
				unset ( $post_data [$key] );
		}

		$matterModel = new Application_Model_Matter ();
		$result = $matterModel->addTaskToEvent ( $post_data );

		if ($matterModel->getError ())
			echo $matterModel->getError ();
		else if ($result)
			echo "Task added";
	}

	/**
	 * Adds a new event
	 * *
	 */
	public function addEventAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$post_data = $this->getRequest ()->getPost ();

		foreach ( $post_data as $key => $data ) {
			if ($data == "")
				unset ( $post_data [$key] );
		}

		$date = explode ( "/", $post_data ['event_date'] );
		$post_data ['event_date'] = date ( "Y-m-d", mktime ( 0, 0, 0, $date [1], $date [0], $date [2] ) );

		$matterModel = new Application_Model_Matter ();
		$result = $matterModel->addEvent ( $post_data );

		if ($matterModel->getError ())
			echo $matterModel->getError ();
		else if ($result)
			echo "Event added";
	}

	/**
	 * Deletes a task
	 * *
	 */
	public function deleteTaskAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$task_id = $this->getRequest ()->getPost ( 'tid' );
		$matterModel = new Application_Model_Matter ();
		echo $matterModel->deleteTask ( $task_id );
	}

	/**
	 * autocompletes event names from all events
	 * *
	 */
	public function getAllEventsAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$matterModel = new Application_Model_Matter ();
		$matter_events = $matterModel->getAllEvents ( $this->_getParam ( 'term' ) );
		echo json_encode ( $matter_events );
	}

	/**
	 * Deletes an event
	 * *
	 */
	public function deleteEventAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$event_id = $this->getRequest ()->getPost ( 'eid' );
		$matterModel = new Application_Model_Matter ();
		echo $matterModel->deleteEvent ( $event_id );
	}

	/**
	 * autocompletes countries from country tables
	 * country.iso as id
	 * country.name as value
	 * *
	 */
	public function getCountryCodesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$matterModel = new Application_Model_Matter ();
		$country_codes = $matterModel->getCountryCodes ( $this->_getParam ( 'term' ) );
		echo json_encode ( $country_codes );
	}

	/**
	 * autocompletes matter.type from matter table
	 * *
	 */
	public function getMatterTypesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$matterModel = new Application_Model_Matter ();
		$matter_types = $matterModel->getMatterTypes ( $this->_getParam ( 'term' ) );
		echo json_encode ( $matter_types );
	}

	/**
	 * autocompletes caseref for a new matter
	 * returns max(caseref) + 1 where caseref matches like term
	 * *
	 */
	public function getMatterCaserefAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$matterModel = new Application_Model_Matter ();
		$matter_caseref = $matterModel->getMatterCaseref ( $this->_getParam ( 'term' ) );
		echo json_encode ( $matter_caseref );
	}

	/**
	 * add a title from "Add item" link in the matter view page
	 * titles are added to classifier table as main classifiers
	 * *
	 */
	public function addTitleAction() {
		$this->_helper->layout->disableLayout ();

		$matterModel = new Application_Model_Matter ();

		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$post_data = $this->getRequest ()->getPost ();
			if (! $post_data ['matter_ID'] || ! $post_data ['type_code']) {
				echo "false";
				return;
			}
			$matterModel = new Application_Model_Matter ();
			$result = $matterModel->addClassifier ( $post_data );
			echo $result;
		} else {
			$cat_code = $this->_getParam ( 'cat_code' );
			$this->view->classifier_types = $matterModel->getMainClassifierTypes ( $cat_code );
		}
	}

	/**
	 * adds a new classifier
	 * *
	 */
	public function addClassifierAction() {
		$this->_helper->layout->disableLayout ();

		$matterModel = new Application_Model_Matter ();

		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$post_data = $this->getRequest ()->getPost ();

			foreach ( $post_data as $key => $data ) {
				if ($data == "")
					unset ( $post_data [$key] );
			}

			if (! $post_data ['matter_ID'] || ! $post_data ['type_code']) {
				echo "false";
				return;
			}
			if (! isset ( $post_data ['value_ID'] )) {
				$cvs = $matterModel->getClassifierValues ( $post_data ['type_code'] );
				if (count ( $cvs ) > 0) {
					$data = array (
							'value' => $post_data ['value'],
							'type_code' => $post_data ['type_code'],
							'notes' => $post_data ['notes']
					);
					$post_data ['value_ID'] = $matterModel->addClassifierValue ( $data );
				}
			}

			$matterModel = new Application_Model_Matter ();
			$result = $matterModel->addClassifier ( $post_data );

			if ($matterModel->getError ()) {
				echo $matterModel->getError ();
			} else {
				echo $result;
			}
		} else {
			$this->view->type_code = $this->_getParam ( 'type_code' );
			$this->view->classifier_types = $matterModel->getClassifierTypes ();
		}
	}

	/**
	 * edits/updates a classifier upon inplace-edit feature
	 * *
	 */
	public function editClassifierAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$post_data = $this->getRequest ()->getPost ();
		$matterModel = new Application_Model_Matter ();
		$result = $matterModel->editClassifier ( $post_data ['cid'], $post_data ['value'] );
		if ($matterModel->getError ()) {
			echo $matterModel->getError ();
		} else {
			echo $post_data ['value'];
		}
	}

	/**
	 * retrieves matter list based on filters
	 * filter multiple fields
	 * sort field
	 * sort directions
	 */
	public function filterAction() {
		$category_display = $this->_getParam ( 'display' );
		$this->view->display_style = $this->_getParam ( 'display_style' );

		$get_sort = $this->_getParam ( 'sort' );
		$get_dir = $this->_getParam ( 'dir' );
		$sort_field = isset ( $get_sort ) ? $get_sort : 'caseref';
		$sort_dir = isset ( $get_dir ) ? $get_dir : 'asc';

		$this->view->sort_id = $sort_field;
		$this->view->sort_dir = $sort_dir;

		$page = $this->_getParam ( 'page', 1 );

		$post_data = $this->getRequest ()->getParams ();
		$post_data_arr = array ();

		foreach ( $post_data as $key => $data ) {
			$post_data_arr [$key] = preg_replace ( "/~~/", "/", $data );
		}

		$post_data = $post_data_arr;

		unset ( $post_data ['controller'] );
		unset ( $post_data ['action'] );
		unset ( $post_data ['module'] );
		unset ( $post_data ['page'] );
		unset ( $post_data ['filter'] );
		unset ( $post_data ['value'] );
		unset ( $post_data ['sort'] );
		unset ( $post_data ['dir'] );
		unset ( $post_data ['display_style'] );


		$mfs = new Zend_Session_Namespace ( 'matter_filter' );
		$mfs->sort_field = $sort_field;
		$mfs->sort_dir = $sort_dir;
		$mfs->multi_sort = $post_data;

		$this->view->responsible = @$post_data ['responsible'];

		$matterModel = new Application_Model_Matter ();
		$paginator = $matterModel->fetchMatters ( $sort_field, $sort_dir, $post_data, $category_display, true );
		$paginator->setCurrentPageNumber ( $page );
		$paginator->setItemCountPerPage ( 25 );

		$this->view->paginator = $paginator;

		if (! empty ( $_SERVER ['HTTP_X_REQUESTED_WITH'] ) && strtolower ( $_SERVER ['HTTP_X_REQUESTED_WITH'] ) == 'xmlhttprequest') {
			$this->_helper->layout->disableLayout ();
		} else {
			$this->view->filters = $post_data;
			$this->render ( 'index' );
		}
	}

	/**
	 * clones a matter
	 * *
	 */
	public function cloneAction() {
		$this->_helper->layout->disableLayout ();
		$matterModel = new Application_Model_Matter ();
		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$matter ['category_code'] = $this->getRequest ()->getPost ( 'category_code' );
			$matter ['country'] = $this->getRequest ()->getPost ( 'country' );
			$matter ['origin'] = $this->getRequest ()->getPost ( 'origin' );
			$matter ['type_code'] = $this->getRequest ()->getPost ( 'type_code' );
			$matter ['caseref'] = $this->getRequest ()->getPost ( 'caseref' );
			$matter ['responsible'] = $this->getRequest ()->getPost ( 'responsible' );
			$matter_id = $this->getRequest ()->getPost ( 'matter_ID' );

			if ($matter ['origin'] == '')
				unset ( $matter ['origin'] );

			if ($matter ['type_code'] == '')
				unset ( $matter ['type_code'] );

			$result = $matterModel->save ( $matter );
			if (! $result) {
				$msg = "Failed to clone matter";
				$this->view->matter_status = false;
				echo "false";
			} else {
				$matterModel->cloneActors ( $matter_id, $result );
				$matterModel->cloneClassifiers ( $matter_id, $result );
				$matterModel->clonePriorities ( $matter_id, $result );
				$msg = "Matter cloned successfully";
				$this->view->matter_status = true;
				echo $result;
			}
		} else {
			$category_id = $this->_getParam ( 'category_id' );
			$category_arr = explode ( '-', $category_id );
			$country_id = $this->_getParam ( 'country' );
			$country_arr = explode ( '-', $country_id );

			$origin = $this->_getParam ( 'origin' );
			$type_code = $this->_getParam ( 'type' );

			if (! isset ( $category_arr [1] ))
				$category_arr [1] = "";
			$this->view->category = $category_arr [0];
			$this->view->category_code = $category_arr [1];
			$this->view->country_name = $country_arr [0];
			$this->view->country_code = $country_arr [1];
			$this->view->username = $this->username;

			$matter_ref = $matterModel->getMatterRefPrefix ( $category_arr [1] );
			$caseref = $matterModel->getMatterCaseref ( $matter_ref ['ref_prefix'] );
			$this->view->caseref = $caseref [0] ['id'];
			$this->view->matter_title = "Clone to new Matter";

			$origin_arr = $matterModel->getCountryByCode ( $origin );
			$this->view->origin_name = $origin_arr ['name'];
			$this->view->origin_code = $origin_arr ['iso'];

			$type_arr = $matterModel->getTypeCode ( $type_code );
			$this->view->type_name = $type_arr ['type'];
			$this->view->type_code = $type_arr ['code'];

			$this->view->matter_cap = "Clone Matter";
			$this->view->matter_cap_id = "clone-matter-submit";
			$this->render ( 'add' );
		}
	}

	/**
	 * create a new child matter for a matter
	 * *
	 */
	public function childAction() {
		$this->_helper->layout->disableLayout ();
		$matterModel = new Application_Model_Matter ();
		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$matter ['category_code'] = $this->getRequest ()->getPost ( 'category_code' );
			$matter ['country'] = $this->getRequest ()->getPost ( 'country' );
			$matter ['origin'] = $this->getRequest ()->getPost ( 'origin' );
			$matter ['type_code'] = $this->getRequest ()->getPost ( 'type_code' );
			$matter ['caseref'] = $this->getRequest ()->getPost ( 'caseref' );
			$matter ['responsible'] = $this->getRequest ()->getPost ( 'responsible' );
			$priority = $this->getRequest ()->getPost ( 'priority' );
			$container = $this->getRequest ()->getPost ( 'container' );
			$matter_id = $this->getRequest ()->getPost ( 'matter_ID' );

			if ($matter ['origin'] == '')
				$matter ['origin'] = null;

			if ($matter ['type_code'] == '')
				$matter ['type_code'] = null;

			if ($priority == 0) {
				$matter ['parent_ID'] = $matter_id;
			}

			if ($container == 0) {
				$current_matter = $matterModel->getMatter ( $matter_id );
				$matter ['container_ID'] = $matterModel->getMatterContainer ( $matter_id );
				$matter ['responsible'] = $current_matter [0] ['responsible'];
			}

			$result = $matterModel->child ( $matter );
			if (! $result) {
				$msg = "Failed to create child matter";
				$this->view->matter_status = false;
				echo "false";
			} else {
				if ($container == 1) {
					$matterModel->cloneActors ( $matter_id, $result );
					$matterModel->cloneClassifiers ( $matter_id, $result );
				} else {
					$matterModel->childActors ( $matter_id, $result );
				}
				$matterModel->clonePriorities ( $matter_id, $result );
				if ($priority == 0) {
					$matterModel->childParentFiledEvent ( $result, $matter_id );
				} else {
					$matterModel->childPriClaimEvent ( $matter_id, $result );
				}
				$msg = "Child Matter created successfully";
				$this->view->matter_status = true;
				echo $result;
			}
		} else {
			$category_id = $this->_getParam ( 'category_id' );
			$category_arr = explode ( '-', $category_id );
			$country_id = $this->_getParam ( 'country' );
			$country_arr = explode ( '-', $country_id );

			$origin = $this->_getParam ( 'origin' );
			$type_code = $this->_getParam ( 'type' );
			$caseref = $this->_getParam ( 'caseref' );

			if (! isset ( $category_arr [1] ))
				$category_arr [1] = "";

			$this->view->category = $category_arr [0];
			$this->view->category_code = $category_arr [1];
			$this->view->country_name = $country_arr [0];
			$this->view->country_code = $country_arr [1];
			$this->view->username = $this->username;

			$this->view->caseref = $caseref;
			$this->view->matter_title = "New Child Matter";

			$origin_arr = $matterModel->getCountryByCode ( $origin );
			$this->view->origin_name = $origin_arr ['name'];
			$this->view->origin_code = $origin_arr ['iso'];

			$type_arr = $matterModel->getTypeCode ( $type_code );
			$this->view->type_name = $type_arr ['type'];
			$this->view->type_code = $type_arr ['code'];

			$this->view->matter_cap = "New Child";
			$this->view->matter_cap_id = "child-matter-submit";
			$this->view->child = 1;
			$this->render ( 'add' );
		}
	}

	/**
	 * Enter national phase, create new matters for a given matter with national phase options
	 * *
	 */
	public function nationalAction() {
		$this->_helper->layout->disableLayout ();
		$matterModel = new Application_Model_Matter ();
		if ($this->getRequest ()->isPost ()) {
			$this->_helper->viewRenderer->setNoRender ();
			$form_data = $this->getRequest ()->getPost ( 'fdata' );
			$matter_id = $this->getRequest ()->getPost ( 'matter_ID' );

			$param = array_shift ( $form_data );
			$matter ['caseref'] = $param ['value'];
			$param = array_shift ( $form_data );
			$matter ['category_code'] = $param ['value'];
			$param = array_shift ( $form_data );
			$matter ['origin'] = $param ['value'];

			$matter ['parent_ID'] = $matter_id;

			if ($matter ['origin'] == '')
				$matter ['origin'] = null;

			$current_matter = $matterModel->getMatter ( $matter_id );
			$matter ['container_ID'] = $matterModel->getMatterContainer ( $matter_id );
			$matter ['responsible'] = $current_matter [0] ['responsible'];

			$m = 0;
			for($i = 0; $i < count ( $form_data );) {
				if (substr ( $form_data [$i] ['name'], 0, 3 ) == "dis") {
					$i ++;
				}

				$matter ['country'] = $form_data [$i] ['value'];
				$entered_date = $form_data [$i + 2] ['value'];
				$result = $matterModel->child ( $matter );
				if ($result) {
					$matterModel->childActors ( $matter_id, $result );
					$matterModel->clonePriorities ( $matter_id, $result );
					$matterModel->nationalPhaseEvents ( $matter_id, $result );
					$matterModel->enteredEvent ( $result, $entered_date );
					$m ++;
				}
				$i += 3;
			}
			echo $m;
		} else {
			$category_id = $this->_getParam ( 'category_id' );
			$category_arr = explode ( '-', $category_id );
			$country_id = $this->_getParam ( 'country' );
			$country_arr = explode ( '-', $country_id );
			$caseref = $this->_getParam ( 'caseref' );

			if (! isset ( $category_arr [1] ))
				$category_arr [1] = "";

			$this->view->country_options = $matterModel->getFlagCountries ( strtolower ( $country_arr [1] ) );

			$this->view->category = $category_arr [0];
			$this->view->category_code = $category_arr [1];
			$this->view->country_name = $country_arr [0];
			$this->view->country_code = $country_arr [1];
			$this->view->username = $this->username;
			$this->view->caseref = $caseref;
		}
	}

	/**
	 * deletes a matter
	 * *
	 */
	public function deleteAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		if ($this->getRequest ()->isPost ()) {
			$matter_id = $this->_getParam ( 'matter_id' );
			$matterModel = new Application_Model_Matter ();
			$result = $matterModel->deleteMatter ( $matter_id );
			echo $result;
		}
	}

	/**
	 * autocompletes caserefs from container matters list
	 * *
	 */
	public function getContainerCaserefsAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$this->view->term = $this->_getParam ( 'term' );

		$matterModel = new Application_Model_Matter ();
		$container_caserefs = $matterModel->getAllContainerCaseref ( $this->view->term );
		echo json_encode ( $container_caserefs );
	}

	/**
	 * update a classifer field through in-place edit feature
	 * *
	 */
	public function updateClassifierAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return false;

		$post_data = $this->getRequest ()->getPost ();
		$classifier_id = $post_data ['classifier_id'];
		$field = $post_data ['field'];
		$value = $post_data ['value'];
		$display_value = $value;
		$data = array ();
		$matterModel = new Application_Model_Matter ();
		if ($field == 'value_id') {
			if ($post_data ['fvalue'] == '') {
				$cdat = array (
						'value' => $value,
						'type_code' => $post_data ['type_code']
				);
				$value = $matterModel->addClassifierValue ( $cdat );
			} else {
				$value = $post_data ['fvalue'];
			}
		}
		$data ["$field"] = $value;
		$matterModel->updateClassifier ( $classifier_id, $data );

		if (isset ( $post_data ['dvalue'] ) && ($post_data ['dvalue'] != ''))
			$display_value = $post_data ['dvalue'];

		echo $display_value;
	}

	/**
	 * autocompletes values from classifier_value table
	 * *
	 */
	public function getClassifierValuesAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		$term = $this->_getParam ( 'term' );
		$type_code = $this->_getParam ( 'type_code' );
		$matterModel = new Application_Model_Matter ();
		$classifier_values = $matterModel->getClassifierValues ( $type_code, $term );
		echo json_encode ( $classifier_values );
	}

	/**
	 * deletes a classifier
	 * *
	 */
	public function deleteClassifierAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;

		$classifier_id = $this->getRequest ()->getPost ( 'classifier_id' );
		$matterModel = new Application_Model_Matter ();
		echo $matterModel->deleteClassifier ( $classifier_id );
	}

	/**
	 * saves classifier display order
	 * *
	 */
	public function saveClassifierDisplayAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		if (! $this->getRequest ()->isPost ())
			return;
		$cids = $this->getRequest ()->getPost ( 'order_list' );
		$classifier_arr = explode ( ",", $cids );
		$matterModel = new Application_Model_Matter ();
		$data = array ();
		foreach ( $classifier_arr as $key => $value ) :
			$data ['display_order'] = $key;
			$matterModel->updateClassifier ( $value, $data );
		endforeach
		;
	}

	/**
	 * navigates through matter list either full list or filtered list
	 * *
	 */
	public function matterNavAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();

		$rid = $this->_getParam ( 'rid' );
		$mfs = new Zend_Session_Namespace ( 'matter_filter' );
		$sort_field = $mfs->sort_field;
		$sort_dir = $mfs->sort_dir;
		$post_data = $mfs->multi_sort;

		$matterModel = new Application_Model_Matter ();
		$matters = $matterModel->fetchMatters ( $sort_field, $sort_dir, $post_data, $mfs->category_display, false );
		$mcount = count ( $matters );

		if (preg_match ( "/matter/", $rid )) {
			$rid_array = explode ( "-", $rid );
			$position = 0;

			foreach ( $matters as $matter ) {
				if ($matter ['ID'] == $rid_array [2]) {
					if ($rid_array [1] == "previous")
						$rid = $position - 1;
					if ($rid_array [1] == "next")
						$rid = $position + 1;
				}
				$position ++;
			}
		}

		if ($mcount > 0)
			$rid = $rid % $mcount;

		if ($rid < 0)
			$rid = $mcount - 1;

		$matter_id = $matters [$rid] ['ID'];

		$this->_redirect ( '/matter/view/id/' . $matter_id . "/rid/" . $rid );
	}

	/**
	 * Exports Matters list
	 * *
	 */
	public function exportAction() {
		$this->_helper->viewRenderer->setNoRender ();
		$this->_helper->layout->disableLayout ();

		$category_display = $this->_getParam ( 'display' );

		$get_sort = $this->_getParam ( 'sort' );
		$get_dir = $this->_getParam ( 'dir' );
		$sort_field = isset ( $get_sort ) ? $get_sort : 'caseref';
		$sort_dir = isset ( $get_dir ) ? $get_dir : 'asc';

		$post_data = $this->getRequest ()->getParams ();
		$post_data_arr = array ();

		foreach ( $post_data as $key => $data ) {
			$post_data_arr [$key] = preg_replace ( "/~~/", "/", $data );
		}

		$post_data = $post_data_arr;

		unset ( $post_data ['controller'] );
		unset ( $post_data ['action'] );
		unset ( $post_data ['module'] );
		unset ( $post_data ['page'] );
		unset ( $post_data ['filter'] );
		unset ( $post_data ['value'] );
		unset ( $post_data ['sort'] );
		unset ( $post_data ['dir'] );

		$matterModel = new Application_Model_Matter ();
		$export = $matterModel->fetchMatters ( $sort_field, $sort_dir, $post_data, $category_display, false );

		$this->getResponse ()->setHeader ( 'Content-Type', 'application/csv' )->setHeader ( 'Content-disposition', 'attachment; filename=export.csv' );
		$export_csv = fopen ( 'php://memory', 'w' );
		$captions = array (
				'Omnipat',
				'Country',
				'Cat',
				'Origin',
				'Status',
				'Status date',
				'Client',
				'Client Ref',
				'Applicant',
				'Agent',
				'Agent Ref',
				'Licensee',
				'Title',
				'Title2',
				'Inventor 1',
				'Filed',
				'FilNo',
				'Published',
				'Pub. No',
				'Granted',
				'Grt No',
				'Expiry',
				'ID',
				'container_ID',
				'parent_ID',
				'Responsible',
				'Delegate',
				'Dead',
				'Ctnr'
		);
		fputcsv ( $export_csv, $captions, ';' );
		foreach ( $export as $row ) {
			fputcsv ( $export_csv, array_map ( "utf8_decode", $row ), ';' );
		}
		fseek ( $export_csv, 0 );
		fpassthru ( $export_csv );
	}

	/**
	 * Exports Matter detail for merging
	 * *
	 */
	public function exportMergeDataAction() {
		$this->_helper->viewRenderer->setNoRender ();
		$this->_helper->layout->disableLayout ();

		$matter_id = $this->_getParam ( 'id' );

		$matterModel = new Application_Model_Matter ();
		$export = $matterModel->getMatterMergeData ( $matter_id );

		$this->getResponse ()->setHeader ( 'Content-Type', 'application/csv' )->setHeader ( 'Content-disposition', 'attachment; filename=matter-merge.csv' );
		$export_csv = fopen ( 'php://memory', 'w' );
		$captions = array ('id',
				'NODOSSIER',
				'PAYS',
				'PROTECTION',
				'DEPOT',
				'NODEPOT',
				'PUBLICATIO',
				'NOPUBLICAT',
				'NOTITREPRI',
				'Granted',
				'GrantNo',
				'Registration',
				'RegNo',
				'PubReg',
				'PubRegNo',
				'ACCORD',
				'TEXTEACCOR',
				'EXPIRATION',
				'CLI1NOM',
				'CLI1NOM2',
				'CLI1RUE1',
				'CLI1PAYS',
				'BillingAddress',
				'REFERENC_1',
				'email',
				'VAT',
				'TITREFRANC',
				'TITREANGLA',
				'Title',
				'Trademark',
				'Class',
				'INV1NOM',
				'INV1RUE1',
				'DEP1NOM',
				'TIT1NOM',
				'CORRNOM',
				'REFERENCEC',
				'RESPONSABL',
				'Writer',
				'Contact',
				'AnnAgt',
				'AnnuityNo',
				'AnnuityDue',
				'AnnuityCost',
				'AnnuityFee'
		);
		fputcsv ( $export_csv, $captions, ';' );
		foreach ( $export as $row ) {
			fputcsv ( $export_csv, array_map ( "utf8_decode", $row ), ';' );
		}
		fseek ( $export_csv, 0 );
		fpassthru ( $export_csv );
	}
}
