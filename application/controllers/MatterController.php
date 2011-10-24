<?php
class MatterController extends Zend_Controller_Action
{
  public function init()
  {
    $siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
    $this->userID = $siteInfoNamespace->userId;
    $this->username = $siteInfoNamespace->username;
  }

/**
 * Displays all Matters list
**/
  public function indexAction()
  {
    $filter_array['value'] = $this->_getParam('value');
    $filter_array['field'] = $this->_getParam('filter');

    if($filter_array['field'] == 'Ctnr'){
        $this->view->containers = 1;
    }

//    $sort_field = isset($this->_getParam('s'))? $this->_getParam('s') : 'caseref';
//    $sort_dir = isset($this->_getParam('d'))? $this->_getParam('d') : 'asc';
    $get_sort = $this->_getParam('sort');
    $get_dir = $this->_getParam('dir');
    $sort_field = isset($get_sort) ? $get_sort : 'caseref';
    $sort_dir = isset($get_dir) ? $get_dir : 'asc';
    $this->view->category_display = $this->_getParam('display');
    $this->view->display_style = $this->_getParam('displaystyle');

    //print_r($filter_array);

    $page = $this->_getParam('page',1);

    $mfs = new Zend_Session_Namespace('matter_filter');
    $mfs->filter_array = $filter_array;
    $mfs->sort_field = $sort_field;
    $mfs->sort_dir = $sort_dir;
    $mfs->multi_sort = array();
    $mfs->display_style = $this->view->display_style;
    $mfs->category_display = $this->view->category_display;

    $matterModel = new Application_Model_Matter();
    $paginator = $matterModel->paginateMatters($filter_array, $sort_field, $sort_dir, array(), $this->view->category_display);
    $paginator->setCurrentPageNumber($page);
    $paginator->setItemCountPerPage(25);

  /*  $containers = array();
    foreach($paginator as $container)
    {
        $containers[$container['ID']] = $matterModel->getFromContainer($container['ID']);
    }
*/
    $this->view->paginator = $paginator;
    $this->view->sort_id = 'caseref';
    $this->view->sort_dir = 'asc';
  //  $this->view->container = $containers;
  }
/**
 * to add a new Matter
**/
  public function addAction()
  {
    $this->_helper->layout->disableLayout();
    if($this->getRequest()->isPost()){
        $this->_helper->viewRenderer->setNoRender();
        $matter['category_code'] = $this->getRequest()->getPost('category_code');
        $matter['country'] = $this->getRequest()->getPost('country');
        $matter['origin'] = $this->getRequest()->getPost('origin');
        $matter['type_code'] = $this->getRequest()->getPost('type_code');
        $matter['caseref'] = $this->getRequest()->getPost('caseref');
        $matter['responsible'] = $this->getRequest()->getPost('responsible');

        if($matter['origin'] == '')
             unset($matter['origin']);

        if($matter['type_code'] == '')
             unset($matter['type_code']);

        $matterModel = new Application_Model_Matter();
        $result = $matterModel->save($matter);
        echo $result;
/*
        if(!is_int($result)){
           $msg = "Failed to add matter";
           $this->view->matter_status = false;
           $this->view->error_msg = $result;
           echo $result;
        }
        else{
           $msg = "Matter added successfully";
           $this->view->matter_status = true;
           echo $result;
        }
*/
    }else{
      $category_id = $this->_getParam('category_id');
      $category_arr = explode('-', $category_id);
      if(!isset($category_arr[1]))
         $category_arr[1] = "";
      $this->view->category = $category_arr[0];
      $this->view->category_code = $category_arr[1];
      $this->view->username = $this->username;

      $matterModel = new Application_Model_Matter();
      $matter_ref = $matterModel->getMatterRefPrefix($category_arr[1]);
      $caseref = $matterModel->getMatterCaseref($matter_ref['ref_prefix']);
      $this->view->caseref = $caseref[0]['id'];
      $this->view->matter_title = "Add new Matter";
      $this->view->matter_cap = "Add Matter";
      $this->view->matter_cap_id = "add-matter-submit";
//echo "caseref ".$this->view->caseref;exit();
    }
  }

/**
 * Matter detail page
**/
  public function viewAction()
  {
    $matter_id = $this->_getParam('id',0);
    #$matter_index = $this->_getParam('rid',0);
    #$matter_id = $this->_getParam('id');
    $matter_index = $this->_getParam('rid');


    $matterModel = new Application_Model_Matter();
    $this->view->matter_record = $matterModel->getMatter($matter_id);
    $this->view->matter_actors = $matterModel->getMatterActors($matter_id, $this->view->matter_record[0]['container_ID']);

    if($this->view->matter_record[0]['parent_ID'] > 0 )
    	$this->view->matter_parent = $matterModel->getMatterParent($this->view->matter_record[0]['parent_ID']);
    else 
    	$this->view->matter_parent = 0;

    $this->view->matter_events = $matterModel->getMatterEvents($matter_id);
    $this->view->matter_open_tasks = $matterModel->getOpenTasks($matter_id);
    $this->view->matter_open_tasks_ren = $matterModel->getOpenTasksREN($matter_id);
    //$this->view->matter_events_expired = $matterModel->getMatterEventsExpired($matter_id);
    $this->view->matter_expiry = $matterModel->getMatterExpiry($matter_id);
    $this->view->matter_classifier = $matterModel->getClassifier($matter_id);
    $this->view->matter_classifier_main = $matterModel->getClassifier($matter_id, 1);
    $this->view->matter_classifier_container = $matterModel->getClassifier($this->view->matter_record[0]['container_ID']);
    $this->view->matter_classifier_container_main = $matterModel->getClassifier($this->view->matter_record[0]['container_ID'], 1);
    $this->view->classifiers = $matterModel->getClassifiers($matter_id);
    $this->view->matter_id = $matter_id;
    $this->view->matter_index = $matter_index;
    $this->view->national_phase = 0;
    if(in_array($this->view->matter_record[0]['country'], array('EP', 'WO', 'OA'))){
      $this->view->national_phase = 1;
    }
  }

/**
 * to edit a Matter
**/
  public function editAction()
  {
    $request = $this->getRequest();
    $matterModel = new Application_Model_Matter();
    $this->_helper->layout->disableLayout();
    if($request->isPost()){
      $this->_helper->viewRenderer->setNoRender();
      $data = $request->getPost();
      $matter_id = $data['matter_id'];
      $caseref_prev = $data['caseref_prev'];
      unset($data['matter_id']);
      unset($data['caseref_prev']);
      if($data['origin'] == '')
           $data['origin'] = null;

      if($data['type_code'] == '')
           $data['type_code'] = null;

      if($data['parent_ID'] == '')
           $data['parent_ID'] = null;

      if($data['container_ID'] == '')
           $data['container_ID'] = null;

      if($data['idx'] == '')
        $data['idx'] = null;

      if(!$matterModel->isMatterUnique($data, $matter_id)){
          $nidx = $matterModel->getNextIdx($data);
        if($data['caseref'] == $caseref_prev){
             $data['idx'] = $nidx;
        }else{
          echo "caseidx-".$nidx;
          return;
        }
      }

      $matterModel->updateMatter($data, $matter_id);
      echo $matter_id;
    }else{
      $matter_id = $this->_getParam('mid');
      $matterInfo = $matterModel->getMatter($matter_id);

      if($matterModel->hasFiledEvent($matter_id))
        $this->view->cat_edit = 0;
      else
        $this->view->cat_edit = 1;

      if($matterModel->hasAutomaticTasks($matter_id))
        $this->view->country_edit = 0;
      else
        $this->view->country_edit = 1;

      $this->view->matter = $matterInfo[0];

      $origin_arr = $matterModel->getCountryByCode($matterInfo[0]['origin']);
      $this->view->origin_name = $origin_arr['name'];
      $this->view->origin_code = $origin_arr['iso'];

      $type_arr = $matterModel->getTypeCode($matterInfo[0]['type_code']);
      $this->view->type_name = $type_arr['type'];
      $this->view->type_code = $type_arr['code'];

      if($matterInfo[0]['parent_ID']){
        $this->view->parent = "(".$matterInfo[0]['parent_ID'].")".$matterModel->getMatterUID($matterInfo[0]['parent_ID']);
        $this->view->parent_id = $matterInfo[0]['parent_ID'];
      }
      if($matterInfo[0]['container_ID']){
        $this->view->container = "(".$matterInfo[0]['container_ID'].")".$matterModel->getMatterUID($matterInfo[0]['container_ID']);
        $this->view->container_id = $matterInfo[0]['container_ID'];
      }

      $this->view->cats = $matterModel->getAllCategories();
      $this->view->types = $matterModel->getMatterTypes();
      //$this->render('add');
    }
  }

/**
 * displays all task list
 * called upon clicking tasks box in matter view page
**/
  public function tasklistAction()
  {
    $this->_helper->layout->disableLayout();
    $matter_id = $this->_getParam('id');
    $matterModel = new Application_Model_Matter();
    $this->view->matter_event_tasks = $matterModel->getMatterEventTasks($matter_id);
    $this->view->renewal = 0;
    $this->view->matter_id = $matter_id;
//    $this->view->matter_events = $matterModel->getMatterAllEvents($matter_id);
  }

/**
 * displays all renewal tasks
 * called upon clicking renewal tasks box in matter view page
**/
  public function tasklistrenAction()
  {
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer('tasklist');
    $matter_id = $this->_getParam('id');
    $matterModel = new Application_Model_Matter();
    //$this->view->matter_open_tasks = $matterModel->getMatterAllTask($matter_id, 1);
    $this->view->matter_event_tasks = $matterModel->getMatterEventTasks($matter_id, 1);
    $this->view->renewal = 1;
    $this->view->matter_id = $matter_id;
  }

/**
 * displays all events
 * called upon clicking events box in matter view page
**/
  public function eventlistAction()
  {
    $this->_helper->layout->disableLayout();
    $matter_id = $this->_getParam('id');
    $matterModel = new Application_Model_Matter();
    $this->view->matter_events = $matterModel->getMatterAllEvents($matter_id);
    $this->view->matter_id = $matter_id;
  }

/**
 * Deprecated
**/
  public function actorlistAction()
  {
    $this->_helper->layout->disableLayout();
    $matter_id = $this->_getParam('matter_id');
    $container_id = $this->_getParam('container_id');
    $matterModel = new Application_Model_Matter();
    $this->view->matter_actors = $matterModel->getMatterActors($matter_id, $container_id);
  }

/**
 * Displays all classifiers list
 * called upon clicking classifier box in matter view page
**/
  public function classifierlistAction()
  {
    $this->_helper->layout->disableLayout();
    $matter_id = $this->_getParam('id');
    $matterModel = new Application_Model_Matter();
    $this->view->classifiers = $matterModel->getMatterClassifiers($matter_id);
  }

/**
 * Displays all actors from actor table
**/
  public function actorsTableAction()
  {
    //$this->_helper->layout->disableLayout();
    $matterModel = new Application_Model_Matter();
    $this->view->actors = $matterModel->getAllActors();
  }

/**
 * Displays filtered actors from actor table
 * called when filter term is entered in actor Name input in actors-table page
**/
  public function actorsFilterAction()
  {
    $this->_helper->layout->disableLayout();
    $term = $this->_getParam('term');
    $matterModel = new Application_Model_Matter();
    $this->view->actors = $matterModel->getAllActors($term);
  }

/**
 * Adds an actor to a selected role
**/
  public function mapActorRoleAction()
  {
    $this->_helper->layout->disableLayout();
    $this->view->matter_id = $this->_getParam('id');
    $this->view->role = $this->_getParam('role');
    $this->view->search_role = $this->_getParam('search_role');
    $this->view->role_search = $this->_getParam('role_search');

    if($this->view->role_search  == "")
        $this->view->role_search = $this->view->role;

    $matterModel = new Application_Model_Matter();
    $this->view->role_name = $matterModel->getRoleName($this->view->role);
    $this->view->all_roles = $matterModel->getAllRoles();

    $this->view->container_id = $matterModel->getMatterContainer($this->view->matter_id);

  }

/**
 * gets all actors for a role
 * used in autocomplete of actor fields
**/
  public function getAllActorsAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');
    $this->view->role = $this->_getParam('role');
    $matterModel = new Application_Model_Matter();
    $matter_actors = $matterModel->getAllActors($this->view->term);
    array_push($matter_actors, array('id' => 'cna786', 'value' => 'Create New Actor'));

    $this->view->matter_actor = $matter_actors;
    #echo '{"c++":"lang", "java":"lang1", "php":"lang2", "coldfusion":"lang3", "javascript":"lang4", "asp":"lang5", "ruby":"lang6"}';
    #echo '["c++", "java", "php", "coldfusion", "javascript", "asp", "ruby"]';
    #echo '[ { value: "jquery" }, { value: "jquery-ui" }, { value: "sizzlejs" } ]; ';
    #echo json_encode(array("c++", "java", "php", "coldfusion", "javascript", "asp", "ruby"));
    echo json_encode($matter_actors);
  }

/**
 * gets all logins for a role
 * used in autocomplete of responsible fields
**/
  public function getAllLoginsAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');
    $this->view->role = $this->_getParam('role');
    $matterModel = new Application_Model_Matter();
    $this->view->matter_login = $matterModel->getAllLogins($this->view->term);

    echo json_encode($this->view->matter_login);
  }

/**
 * gets all categories
 * used in autocomplete of category fields
**/
  public function getAllCategoriesAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');
    $matterModel = new Application_Model_Matter();
    $this->view->matter_categories = $matterModel->getAllCategories($this->view->term);

    echo json_encode($this->view->matter_categories);
  }

/**
 * displays actors for a particular role and provides editing and sorting of the list
 * called upon clicking role in actors' box in matter view page
**/
  public function roleActorsAction()
  {
  	$this->_helper->layout->disableLayout();
  	if(!$this->getRequest()->isPost())
  	  return;
  
  	$matter_id = $this->_getParam('matter_id');
  	$role_id = $this->_getParam('role_id');
  	
  	$matterModel = new Application_Model_Matter();
        $matter_record = $matterModel->getMatter($matter_id);
        //$container_id = $matterModel->getMatterContainer($matter_id);

  	$this->view->role_actors = $matterModel->getMatterActorsForRole($matter_record[0]['container_ID'], $matter_id, $role_id);
  	$this->view->role = $this->view->role_actors[0]['role_name'];
  	$this->view->matter_id = $matter_id;	
  	$this->view->actor_role = $matterModel->getActorRoleInfo($role_id);
        $this->view->actors_count = count($this->view->role_actors);
  }
  
/**
 * Updates actor_role  
**/
  public function saveRoleAction()
  {
  	$this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
    
  	if(!$this->getRequest()->isPost())
  	  return;
  	
  	$role_code = $this->getRequest()->getPost('role_code');
  	$role_data = $this->getRequest()->getPost();
  	unset($role_data['role_code']);
  	$matterModel = new Application_Model_Matter();
  	$matterModel->saveRole($role_code, $role_data);
  }

/**
 * Actor is linked to Matter
 * an entry is inserted into matter_actor_lnk
**/
  public function addMatterActorAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    
  	if(!$this->getRequest()->isPost())
  	  return;
    $data = array();

    $matterModel = new Application_Model_Matter();

    $matter_id = $this->getRequest()->getPost('matter_ID');
    $data['actor_ID'] = $this->getRequest()->getPost('actor_ID');
    $data['role'] = $this->getRequest()->getPost('role');
    $container_id = $matterModel->getMatterContainer($matter_id);

    $role_shareable = $this->getRequest()->getPost('role_shareable');

    $data['shared'] = $matterModel->isRoleShareable($data['role']);
//    echo "matter ID: ".$matter_id. " container: ".$container_id." yn: ".$this->getRequest()->getPost('add_container');exit();

    if($this->getRequest()->getPost('add_container') && $container_id)
    {
      $data['matter_ID'] = $container_id;
      if($role_shareable == 0)
        $data['shared'] = 1;
    }
    else
      $data['matter_ID'] = $matter_id;

    $actor_info = $matterModel->getActorInfo($data['actor_ID']);
    $data['company_ID'] = $actor_info['company_ID'];
    $data['display_order'] = $matterModel->getNextDisplayOrder($matter_id, $container_id, $data['role']);
    $data['date'] = date('Y-m-d');

    $result = $matterModel->addMatterActor($data);
    if($matterModel->getError()){
      echo $matterModel->getError();
    }
    if($result)
      echo "Actor linked to the Matter";
  }
  
/**
 * Updates a record in matter_actor_lnk
**/
  public function saveMatterActorAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    
  	if(!$this->getRequest()->isPost())
  	  return;
  	  
//  	print_r($this->getRequest()->getPost()); exit();
        $post_data = $this->getRequest()->getPost();
        $display_val = $post_data['value'];
        if(strcmp(substr($post_data['id'], 0, 10), 'company_ID') == 0)
        {
            $post_data['id'] = 'company_ID';
            $post_data['value'] = $post_data['company_id'];
        }
  	$data[$post_data['id']] = $post_data['value'];
  //	$matter_id = $post_data['matter_id'];
  //	$role_code = $post_data['role_code'];
        $matter_actor_id = $post_data['matter_actor_id'];
  	$matterModel = new Application_Model_Matter();
  	$matterModel->saveMatterActor($matter_actor_id, $data);
  	echo $display_val;
  }
  
/**
 * Deletes an actor linked to matter from matter_actor_lnk
**/
  public function deleteMatterActorAction()
  {
      $this->_helper->layout->disableLayout();
      $this->_helper->viewRenderer->setNoRender();
 
      if(!$this->getRequest()->isPost())
  	  return;
  	  
      $mal_id = $this->getRequest()->getPost('mal_id');
      $matterModel = new Application_Model_Matter();
      $result = $matterModel->deleteMatterActor($mal_id);
      echo $result;
  }

/**
 * saves actors display order for a role
**/
  public function saveDisplayOrderAction() //actors display order
  {
      $this->_helper->layout->disableLayout();
      $this->_helper->viewRenderer->setNoRender();
 
      if(!$this->getRequest()->isPost())
  	  return;
      $mal_ids = $this->getRequest()->getPost('order_list');
      $mal_arr = explode(",", $mal_ids);
      $matterModel = new Application_Model_Matter();
      $data = array();
      foreach($mal_arr as $key => $value):
        $data['display_order'] = $key+1;
        $matterModel->saveMatterActor($value, $data);
      endforeach;
  }

/**
 * updates Matter for each field specified
 * used to update matter on in-place edit
**/
  public function updateMatterAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
  
    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $matter_id = $post_data['matter_id'];
    $field_name = $post_data['field'];
    $field_value = $post_data['value'];

    $data["$field_name"] = $field_value;
    $matterModel = new Application_Model_Matter();
    $matterModel->updateMatter($data, $matter_id);

    echo nl2br(htmlentities($field_value));
  }

/**
 * updates task for each field specified from in-place edit
**/
  public function updateTaskAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
  
    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $task_id = $post_data['task_id'];
    $field_name = $post_data['field'];
    $field_value = $post_data['value'];
    $rule_id = '';
    if(isset($post_data['rule_id']) && $post_data['rule_id'])
        $rule_id = NULL;

    if($field_name == 'done_date' && $fiel_value == '')
      $fiel_value = date('Y-m-d');

    $matterModel = new Application_Model_Matter();
    $matterModel->saveTaskDetails($task_id, $field_name, $field_value, $rule_id);

    echo $field_value;
  }

/**
 * clears a task for a given done_date or now()
**/
  public function clearTaskAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
  
    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $task_id = $post_data['task_id'];
    $matterModel = new Application_Model_Matter();
    $result = $matterModel->clearTask($task_id, $post_date['done_date']);
    echo $result;
  }

/**
 * clears multiple tasks for a given done_date
**/
  public function clearTasksAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
  
    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $task_ids = $post_data['task_ids'];
    $done_date = $post_data['done_date'];

    $matterModel = new Application_Model_Matter();
    $result = $matterModel->clearTasks($task_ids, $done_date);
    echo $result;
  }

/**
 * updates event for a specified field from in-place edit feature
**/
  public function updateEventAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $post_data = $this->getRequest()->getPost();
    $event_id = $post_data['event_id'];
    $field_name = $post_data['field'];
    $field_value = $post_data['value'];
    $data = array();
    $data["$field_name"] = $field_value;

    if($field_name == 'event_date')
        $data["$field_name"] = new Zend_Db_Expr("STR_TO_DATE('$field_value', '%d/%m/%Y' )");

    if($field_name == 'alt_matter_ID')
        $data["$field_name"] = $post_data['alt_matter'];

    $matterModel = new Application_Model_Matter();
    $matterModel->saveEventDetails($event_id, $data);

    echo $post_data['value'];
  }

/**
 * gets autocomplete list from all caserefs 
**/
  public function getAllRefersAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $term = $this->_getParam('term');
    $matterModel = new Application_Model_Matter();
    $matter_refers = $matterModel->getAllMatterRefers($term);
//print_r($matter_refers); exit();
    echo json_encode($matter_refers);
  }

/**
 * gets autocomplete list from caserefs of container matters
**/
  public function getContainerRefersAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $term = $this->_getParam('term');
    $caseref = $this->_getParam('caseref');
    $matter_id = $this->_getParam('matter_id');

    $matterModel = new Application_Model_Matter();
    $matter_refers = $matterModel->getContainerRefers($caseref, $term, $matter_id);
//print_r($matter_refers); exit();
    echo json_encode($matter_refers);
  }

/**
 * autocompletes task name
**/
  public function getAllTasksAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $matterModel = new Application_Model_Matter();
    $matter_tasks = $matterModel->getAllTasks($this->_getParam('term'));
    echo json_encode($matter_tasks);
  }

/**
 * Adds a task to an event 
**/
  public function addEventTaskAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return;

    $post_data = $this->getRequest()->getPost();

    
    $date = explode("/",$post_data[due_date]);
    $post_data[due_date] =  date("Y-m-d",mktime(0, 0, 0, $date[1], $date[0], $date[2]));

    $matterModel = new Application_Model_Matter();
    $result = $matterModel->addTaskToEvent($post_data);

    if($matterModel->getError())
      echo $matterModel->getError();
    else if($result)
      echo "Task added to the event successfully";
  }

/**
 * Adds a new event
**/
  public function addEventAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return;

    $post_data = $this->getRequest()->getPost();

    
    $date = explode("/",$post_data[event_date]);
    $post_data[event_date] =  date("Y-m-d",mktime(0, 0, 0, $date[1], $date[0], $date[2]));

    $matterModel = new Application_Model_Matter();
    $result = $matterModel->addEvent($post_data);

    if($matterModel->getError())
      echo $matterModel->getError();
    else if($result)
      echo "Task added to the event successfully";
  }

/**
 * Deletes a task
**/
  public function deleteTaskAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return;

    $task_id = $this->getRequest()->getPost('tid');
    $matterModel = new Application_Model_Matter();
    echo $matterModel->deleteTask($task_id);
  }

/**
 * autocompletes event names from all events
**/
  public function getAllEventsAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $matterModel = new Application_Model_Matter();
    $matter_events = $matterModel->getAllEvents($this->_getParam('term'));
    echo json_encode($matter_events);
  }

/**
 * Deletes an event
**/
  public function deleteEventAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return;

    $event_id = $this->getRequest()->getPost('eid');
    $matterModel = new Application_Model_Matter();
    echo $matterModel->deleteEvent($event_id);

  }

/**
 * autocompletes countries from country tables
 * country.iso as id
 * country.name as value
**/
  public function getCountryCodesAction()
  {
     $this->_helper->layout->disableLayout();
     $this->_helper->viewRenderer->setNoRender();

     $matterModel = new Application_Model_Matter();
     $country_codes = $matterModel->getCountryCodes($this->_getParam('term'));
     echo json_encode($country_codes);
  }

/**
 * autocompletes matter.type from matter table
**/
  public function getMatterTypesAction()
  {
     $this->_helper->layout->disableLayout();
     $this->_helper->viewRenderer->setNoRender();

     $matterModel = new Application_Model_Matter();
     $matter_types = $matterModel->getMatterTypes($this->_getParam('term'));
     echo json_encode($matter_types);
  }

/**
 * autocompletes caseref for a new matter
 * returns max(caseref) + 1 where caseref matches like term
**/
  public function getMatterCaserefAction()
  {
     $this->_helper->layout->disableLayout();
     $this->_helper->viewRenderer->setNoRender();

     $matterModel = new Application_Model_Matter();
     $matter_caseref = $matterModel->getMatterCaseref($this->_getParam('term'));
     echo json_encode($matter_caseref);
  }

/**
 * add a title from "Add item" link in the matter view page
 * titles are added to classifier table as main classifiers
**/
  public function addTitleAction()
  {
    $this->_helper->layout->disableLayout();

    $matterModel = new Application_Model_Matter();

    if($this->getRequest()->isPost()){
        $this->_helper->viewRenderer->setNoRender();
        $post_data = $this->getRequest()->getPost();
        if(!$post_data['matter_ID'] || !$post_data['type_code']){
          echo "false";
          return;
        }
        $matterModel = new Application_Model_Matter();
        $result = $matterModel->addClassifier($post_data);
      /*  if($result){
            echo "true";
            return;
        }
        else{
            echo "false";
            return;
        }*/
        echo $result;
    }else{
        $cat_code = $this->_getParam('cat_code');
        $this->view->classifier_types = $matterModel->getMainClassifierTypes($cat_code);
    }
  }

/**
 * adds a new classifier
**/
  public function addClassifierAction()
  {
    $this->_helper->layout->disableLayout();

    $matterModel = new Application_Model_Matter();

    if($this->getRequest()->isPost()){
        $this->_helper->viewRenderer->setNoRender();
        $post_data = $this->getRequest()->getPost();
        if(!$post_data['matter_ID'] || !$post_data['type_code']){
          echo "false";
          return;
        }
        if($post_data['value_ID'] == ''){
           $cvs = $matterModel->getClassifierValues($post_data['type_code']);
           if(count($cvs) > 0){
             $data = array( 'value' => $post_data['value'], 'type_code' => $post_data['type_code'] );
             $post_data['value_ID'] = $matterModel->addClassifierValue($data);
           }else{
             unset($post_data['value_ID']);
           }
        }

        if($post_data['lnk_matter_ID'] == '')
           unset($post_data['lnk_matter_ID']);

        $matterModel = new Application_Model_Matter();
        $result = $matterModel->addClassifier($post_data);
        
        if($matterModel->getError()){
            echo $matterModel->getError();
        } else {
            echo $result; 
        } 
/*
        if($result){
            echo "true";
            return;
        }
        else{
            echo "false";
            return;
        } */
    }else{
        $this->view->type_code = $this->_getParam('type_code');
        $this->view->classifier_types = $matterModel->getClassifierTypes();
    }
  }

/**
 * edits/updates a classifier upon inplace-edit feature 
**/
  public function editClassifierAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    $post_data = $this->getRequest()->getPost();
    $matterModel = new Application_Model_Matter();
    $result = $matterModel->editClassifier($post_data['cid'], $post_data['value']);
    if($matterModel->getError()){
        echo $matterModel->getError();
    } else {
        echo $post_data['value'];
    } 
  }

/**
 * retrieves matter list based on filters
 * filter field/fields
 * filter value/values
 * sort field
 * sort directions
**/
  public function filterAction()
  {
    $filter_array['value'] = $this->_getParam('value');
    $filter_array['field'] = $this->_getParam('filter');

    if($filter_array['field'] == 'Ctnr'){
        $this->view->containers = 1;
    }

    $category_display = $this->_getParam('display');
    $this->view->display_style = $this->_getParam('display_style');

    $get_sort = $this->_getParam('sort');
    $get_dir = $this->_getParam('dir');
    $sort_field = isset($get_sort) ? $get_sort : 'caseref';
    $sort_dir = isset($get_dir) ? $get_dir : 'asc';

    $this->view->sort_id = $sort_field;
    $this->view->sort_dir = $sort_dir;

    $page = $this->_getParam('page',1);

    $post_data = $this->getRequest()->getParams();
    unset($post_data['controller']);
    unset($post_data['action']);
    unset($post_data['module']);
    unset($post_data['page']);
    unset($post_data['filter']);
    unset($post_data['value']);
    unset($post_data['sort']);
    unset($post_data['dir']);

    $mfs = new Zend_Session_Namespace('matter_filter');
    $mfs->filter_array = $filter_array;
    $mfs->sort_field = $sort_field;
    $mfs->sort_dir = $sort_dir;
    $mfs->multi_sort = $post_data;

    $this->view->responsible = $post_data[responsible];

    $matterModel = new Application_Model_Matter();
    $paginator = $matterModel->paginateMatters($filter_array, $sort_field, $sort_dir, $post_data,$category_display);
    $paginator->setCurrentPageNumber($page);
    $paginator->setItemCountPerPage(25);

    $this->view->paginator = $paginator;
//    if(Zend_Controller_Request_Http::isXmlHttpRequest()){
    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest'){
//echo "ajax request";exit();
//    if($page == 1){
        $this->_helper->layout->disableLayout();
    }else{
        $this->view->filters = $post_data;
        $this->render('index');
    }
  }

/**
 * autocompletes non-actors from actor table where phy_person=0
**/
  public function getNonActorsAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');
    $matterModel = new Application_Model_Matter();
    $matter_actors = $matterModel->getAllActors($this->view->term, 0);

    echo json_encode($matter_actors);
  }

/**
 * autocompletes roles from actor_role
**/
  public function getActorRolesAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');
    $matterModel = new Application_Model_Matter();
    $actor_roles = $matterModel->getActorRoles($this->view->term);

    echo json_encode($actor_roles);
  }

/**
 * add/create a new actor
**/
  public function addActorAction()
  {
    $this->_helper->layout->disableLayout();
    $request = $this->getRequest();
    $matterModel = new Application_Model_Matter();
    $actorForm = new Application_Form_Matter_Actor();
    if($request->isPost()){
        $post_data = $request->getPost();
        if($actorForm->isValid($post_data)){
            if($post_data['parent_ID'] == '')
                unset($post_data['parent_ID']);
            if($post_data['company_ID'] == '')
                unset($post_data['company_ID']);
            if($post_data['site_ID'] == '')
                unset($post_data['site_ID']);
            if($post_data['display_name'] == '')
                unset($post_data['display_name']);

            $actor_id = $matterModel->addActor($post_data);
          if($actor_id){
            $this->_helper->viewRenderer->setNoRender();
            $json_data = array();
            $json_data['actor_name'] = $post_data['name'];
            $json_data['actor_id'] = $actor_id;
            echo json_encode($json_data);
            return;
          }else{
             $this->view->sqlErrors = $matterModel->getError();
	     $default_role = $actorForm->getValue('default_role');
          }
        }else{
            $this->view->formErrors = $actorForm->getMessages();
            $default_role = $actorForm->getValue('default_role');
        }
    }else{
        $default_role = $this->_getParam('role');
    }
    $role_info = $matterModel->getActorRoleInfo($default_role);
    $this->view->actorComments = $matterModel->getTableComments('actor');
    $actorForm->getElement('default_role')->setValue($role_info['name']);
    $enumOpts = $matterModel->getEnumSet('actor', 'pay_category');
    $actorForm->getElement('pay_category')->setMultiOptions($enumOpts);
    $this->view->actorForm = $actorForm;
    $this->view->default_role = $role_info['name'];
    $this->view->default_role_code = $role_info['code'];
  }

/**
 * displays and offers in-place edit of actor details
**/
  public function actorAction()
  {
    $this->_helper->layout->disableLayout();
    $actor_id = $this->_getParam('actor_id');
    $matterModel = new Application_Model_Matter();
    $actorInfo = $matterModel->getActorInfo($actor_id);
    $this->view->enumOpts = $matterModel->getEnumSet('actor', 'pay_category');
    $this->view->actorComments = $matterModel->getTableComments('actor');
    $this->view->actor = $actorInfo;
  }

/**
 * updates actor field through in-place edit feature
**/
  public function updateActorAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
  
    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $actor_id = $post_data['actor_id'];
    $field_name = $post_data['field'];
    $field_value = $post_data['value'];
    $dvalue = $post_data['dvalue'];
    $matterModel = new Application_Model_Matter();
    $matterModel->updateActor($actor_id, $field_name, $field_value);
   
    if(!$matterModel->getError()){
        if(isset($dvalue) && !$matterModel->getError()){
         $field_value = $dvalue;
        }

        if(in_array($field_name, array('address', 'address_mailing', 'address_billing', 'notes'))){
          $field_value = nl2br($field_value);
        }

        echo $field_value;
    } else {
        echo $matterModel->getError() ;
    }
  }

/**
 * clones a matter
**/
  public function cloneAction()
   {
    $this->_helper->layout->disableLayout();
    $matterModel = new Application_Model_Matter();
    if($this->getRequest()->isPost()){
        $this->_helper->viewRenderer->setNoRender();
        $matter['category_code'] = $this->getRequest()->getPost('category_code');
        $matter['country'] = $this->getRequest()->getPost('country');
        $matter['origin'] = $this->getRequest()->getPost('origin');
        $matter['type_code'] = $this->getRequest()->getPost('type_code');
        $matter['caseref'] = $this->getRequest()->getPost('caseref');
        $matter['responsible'] = $this->getRequest()->getPost('responsible');
        $matter_id = $this->getRequest()->getPost('matter_ID');

        if($matter['origin'] == '')
             unset($matter['origin']);

        if($matter['type_code'] == '')
             unset($matter['type_code']);

        $result = $matterModel->save($matter);
        if(!$result){
           $msg = "Failed to clone matter";
           $this->view->matter_status = false;
           echo "false";
        }
        else{
           $matterModel->cloneActors($matter_id, $result);
           $matterModel->cloneClassifiers($matter_id, $result);
           $matterModel->clonePriorities($matter_id, $result);
           $msg = "Matter cloned successfully";
           $this->view->matter_status = true;
           echo $result;
        }
    }else{
      $category_id = $this->_getParam('category_id');
      $category_arr = explode('-', $category_id);
      $country_id = $this->_getParam('country');
      $country_arr = explode('-', $country_id);

      $origin = $this->_getParam('origin');
      $type_code = $this->_getParam('type');

      if(!isset($category_arr[1]))
         $category_arr[1] = "";
      $this->view->category = $category_arr[0];
      $this->view->category_code = $category_arr[1];
      $this->view->country_name = $country_arr[0];
      $this->view->country_code = $country_arr[1];
      $this->view->username = $this->username;

      $matter_ref = $matterModel->getMatterRefPrefix($category_arr[1]);
      $caseref = $matterModel->getMatterCaseref($matter_ref['ref_prefix']);
      $this->view->caseref = $caseref[0]['id'];
      $this->view->matter_title = "Clone to new Matter";
//echo "caseref ".$this->view->caseref;exit();

      $origin_arr = $matterModel->getCountryByCode($origin);
      $this->view->origin_name = $origin_arr['name'];
      $this->view->origin_code = $origin_arr['iso'];

      $type_arr = $matterModel->getTypeCode($type_code);
      $this->view->type_name = $type_arr['type'];
      $this->view->type_code = $type_arr['code'];

      $this->view->matter_cap = "Clone Matter";
      $this->view->matter_cap_id = "clone-matter-submit";
      $this->render('add');
    }
  }

/**
 * create a new child matter for a matter
**/
  public function childAction()
  {
    $this->_helper->layout->disableLayout();
    $matterModel = new Application_Model_Matter();
    if($this->getRequest()->isPost()){
        $this->_helper->viewRenderer->setNoRender();
        $matter['category_code'] = $this->getRequest()->getPost('category_code');
        $matter['country'] = $this->getRequest()->getPost('country');
        $matter['origin'] = $this->getRequest()->getPost('origin');
        $matter['type_code'] = $this->getRequest()->getPost('type_code');
        $matter['caseref'] = $this->getRequest()->getPost('caseref');
        $matter['responsible'] = $this->getRequest()->getPost('responsible');
        $priority = $this->getRequest()->getPost('priority');
        $container = $this->getRequest()->getPost('container');
        $matter_id = $this->getRequest()->getPost('matter_ID');

        if($matter['origin'] == '')
             $matter['origin'] = null;

        if($matter['type_code'] == '')
             $matter['type_code'] = null;

        if($priority == 0){
          $matter['parent_ID'] = $matter_id;
        }

        if($container == 0){
          $current_matter = $matterModel->getMatter($matter_id);
          $matter['container_ID'] = $matterModel->getMatterContainer($matter_id);
          $matter['responsible'] = $current_matter[0]['responsible'];
        }

        $result = $matterModel->child($matter);
        if(!$result){
           $msg = "Failed to create child matter";
           $this->view->matter_status = false;
           echo "false";
        }
        else{
           if($container == 1){
             $matterModel->cloneActors($matter_id, $result);
             $matterModel->cloneClassifiers($matter_id, $result);
           }else{
             $matterModel->childActors($matter_id, $result);
           }
           $matterModel->clonePriorities($matter_id, $result);
           if($priority == 0){
             $matterModel->childParentFiledEvent($result, $matter_id);
           }else{
             $matterModel->childPriClaimEvent($matter_id, $result);
           }
           $msg = "Child Matter created successfully";
           $this->view->matter_status = true;
           echo $result;
        }
    }else{
      $category_id = $this->_getParam('category_id');
      $category_arr = explode('-', $category_id);
      $country_id = $this->_getParam('country');
      $country_arr = explode('-', $country_id);

      $origin = $this->_getParam('origin');
      $type_code = $this->_getParam('type');
      $caseref = $this->_getParam('caseref');

      if(!isset($category_arr[1]))
         $category_arr[1] = "";

      $this->view->category = $category_arr[0];
      $this->view->category_code = $category_arr[1];
      $this->view->country_name = $country_arr[0];
      $this->view->country_code = $country_arr[1];
      $this->view->username = $this->username;

      //$matter_ref = $matterModel->getMatterRefPrefix($category_arr[1]);
      //$caseref = $matterModel->getMatterCaseref($matter_ref['ref_prefix']);
      $this->view->caseref = $caseref;
      $this->view->matter_title = "New Child Matter";
      //echo "caseref ".$this->view->caseref;exit();

      $origin_arr = $matterModel->getCountryByCode($origin);
      $this->view->origin_name = $origin_arr['name'];
      $this->view->origin_code = $origin_arr['iso'];

      $type_arr = $matterModel->getTypeCode($type_code);
      $this->view->type_name = $type_arr['type'];
      $this->view->type_code = $type_arr['code'];

      $this->view->matter_cap = "New Child";
      $this->view->matter_cap_id = "child-matter-submit";
      $this->view->child = 1;
      $this->render('add');
    }
  }

/**
 * Enter national phase, create new matters for a given matter with national phase options
**/
  public function nationalAction()
  {
    $this->_helper->layout->disableLayout();
    $matterModel = new Application_Model_Matter();
    if($this->getRequest()->isPost()){
      $this->_helper->viewRenderer->setNoRender();
      $form_data = $this->getRequest()->getPost('fdata');
      $matter_id = $this->getRequest()->getPost('matter_ID');

      $param = array_shift($form_data);
      $matter['caseref'] = $param['value'];
      $param = array_shift($form_data);
      $matter['category_code'] = $param['value'];
      $param = array_shift($form_data);
      $matter['origin'] = $param['value'];

      $matter['parent_ID'] = $matter_id;

      if($matter['origin'] == '')
        $matter['origin'] = null;

      $current_matter = $matterModel->getMatter($matter_id);
      $matter['container_ID'] = $matterModel->getMatterContainer($matter_id);
      $matter['responsible'] = $current_matter[0]['responsible'];

      //print_r($form_data);exit();
      $m = 0;
      for($i=0; $i < count($form_data);){
//        foreach($form_data as $country){
        if(substr($form_data[$i]['name'], 0, 3) == "dis"){
          $i++;
        }

        $matter['country'] = $form_data[$i]['value'];
        $entered_date = $form_data[$i+2]['value'];
//        $matter['type_code'] = $form_data[$i+1]['value'];
//        $matter['responsible'] = $form_data[$i+2]['value'];
        $result = $matterModel->child($matter);
        if($result){
          $matterModel->childActors($matter_id, $result);
          $matterModel->clonePriorities($matter_id, $result);
         // $matterModel->childParentFiledEvent($result, $matter_id);
          $matterModel->nationalPhaseEvents($matter_id, $result);
          $matterModel->enteredEvent($result, $entered_date);
          $m++;
        }
        $i += 3;
      }
      echo $m;
    }else{
      $category_id = $this->_getParam('category_id');
      $category_arr = explode('-', $category_id);
      $country_id = $this->_getParam('country');
      $country_arr = explode('-', $country_id);
      $caseref = $this->_getParam('caseref');
 
      if(!isset($category_arr[1]))
         $category_arr[1] = "";

      $this->view->country_options = $matterModel->getFlagCountries(strtolower($country_arr[1]));

      $this->view->category = $category_arr[0];
      $this->view->category_code = $category_arr[1];
      $this->view->country_name = $country_arr[0];
      $this->view->country_code = $country_arr[1];
      $this->view->username = $this->username;
      $this->view->caseref = $caseref;
    }
  }

/**
 * deletes an actor
**/
  public function deleteActorAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    if($this->getRequest()->isPost()){
        $actor_id = $this->_getParam('aid');
        $matterModel = new Application_Model_Matter();
        $result = $matterModel->deleteActor($actor_id);
        echo $result;
    }
  }

/**
 * navigate through actors from actor view page
**/
  public function actornavAction()
  {
    $this->_helper->layout->disableLayout();

    $nav = $this->_getParam('nav');
    $actor_id = $this->_getParam('actor_id');

    $matterModel = new Application_Model_Matter();
    switch($nav){
      case "next":
          $actorInfo = $matterModel->getNextActor($actor_id);
          break;
      case "prev":
          $actorInfo = $matterModel->getPrevActor($actor_id);
          break;
      case "forward":
          $actorInfo = $matterModel->getForwardActor($actor_id, 10);
           break;
      case "backward":
          $actorInfo = $matterModel->getBackwardActor($actor_id, 10);
           break;
    }
    $this->view->enumOpts = $matterModel->getEnumSet('actor', 'pay_category');
    $this->view->actorComments = $matterModel->getTableComments('actor');
    $this->view->actor = $actorInfo;
    $this->render('actor');
  }

/**
 * deletes a matter
**/
  public function deleteAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    if($this->getRequest()->isPost()){
      $matter_id = $this->_getParam('matter_id');
      $matterModel = new Application_Model_Matter();
      $result = $matterModel->deleteMatter($matter_id);
      echo $result;
    }
  }

/**
 * autocompletes caserefs from container matters list 
**/
  public function getContainerCaserefsAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->view->term = $this->_getParam('term');

    $matterModel = new Application_Model_Matter();
    $container_caserefs = $matterModel->getAllContainerCaseref($this->view->term);
    echo json_encode($container_caserefs);
  }

/**
 * update a classifer field through in-place edit feature
**/
  public function updateClassifierAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return false;

    $post_data = $this->getRequest()->getPost();
    $classifier_id = $post_data['classifier_id'];
    $field = $post_data['field'];
    $value = $post_data['value'];
    $display_value = $value;
    $data = array();
    $matterModel = new Application_Model_Matter();
    if($field == 'value_id'){
      if($post_data['fvalue'] == ''){
        $cdat = array( 'value' => $value,
                       'type_code' => $post_data['type_code'] );
        $value = $matterModel->addClassifierValue($cdat);
      }else{
        $value = $post_data['fvalue'];
      }
    }
    $data["$field"] = $value;
    $matterModel->updateClassifier($classifier_id, $data);

    if(isset($post_data['dvalue']) && ($post_data['dvalue'] != ''))
      $display_value = $post_data['dvalue'];

    echo $display_value;
  }

/**
 * autocompletes values from classifier_value table
**/
  public function getClassifierValuesAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $term = $this->_getParam('term');
    $type_code = $this->_getParam('type_code');
    $matterModel = new Application_Model_Matter();
    $classifier_values = $matterModel->getClassifierValues($type_code, $term);
    echo json_encode($classifier_values);
  }

/**
 * deletes a classifier
**/
  public function deleteClassifierAction()
  {
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();

    if(!$this->getRequest()->isPost())
      return;

    $classifier_id = $this->getRequest()->getPost('classifier_id');
    $matterModel = new Application_Model_Matter();
    echo $matterModel->deleteClassifier($classifier_id);
  }

/**
 * saves classifier display order
**/
  public function saveClassifierDisplayAction()
  {
      $this->_helper->layout->disableLayout();
      $this->_helper->viewRenderer->setNoRender();
 
      if(!$this->getRequest()->isPost())
  	  return;
      $cids = $this->getRequest()->getPost('order_list');
      $classifier_arr = explode(",", $cids);
      $matterModel = new Application_Model_Matter();
      $data = array();
      foreach($classifier_arr as $key => $value):
        $data['display_order'] = $key;
        $matterModel->updateClassifier($value, $data);
      endforeach;
  }

/**
 * navigates through matter list either full list or filtered list
**/
  public function matterNavAction()
  {
      $this->_helper->layout->disableLayout();
      $this->_helper->viewRenderer->setNoRender();

      $rid = $this->_getParam('rid');
      $mfs = new Zend_Session_Namespace('matter_filter');
      $filter_array = $mfs->filter_array;
      $sort_field = $mfs->sort_field;
      $sort_dir = $mfs->sort_dir;
      $post_data = $mfs->multi_sort;


      $matterModel = new Application_Model_Matter();
      $matters = $matterModel->fetchMatters($filter_array, $sort_field, $sort_dir, $post_data, $mfs->category_display);
      $mcount = count($matters);

      if(preg_match("/matter/",$rid)){
          $rid_array = explode("-",$rid);
          $position = 0;
      
          foreach($matters as $matter){
              if ($matter['ID'] == $rid_array[2]){
                  if($rid_array[1] == "previous")
                      $rid = $position - 1; 
                  if($rid_array[1] == "next")
                      $rid = $position + 1; 
              }
              $position++;
          }
      }

      if($mcount > 0)
         $rid = $rid % $mcount;

      if($rid < 0)
         $rid = $mcount-1;

      $matter_id = $matters[$rid]['ID'];

      $this->_redirect('/matter/view/id/'.$matter_id."/rid/".$rid);
  }
}
