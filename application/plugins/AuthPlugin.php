<?php
class Application_Plugins_AuthPlugin extends Zend_Controller_Plugin_Abstract 
{
  public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request) 
  { 
    	$auth = Zend_Auth::getInstance();
        $result = $auth->getStorage();
        $identity = $auth->getIdentity();
        $registry = Zend_Registry::getInstance();
        $config = Zend_Registry::get('config');
        
        $module = strtolower($this->_request->getModuleName());
        $controller = strtolower($this->_request->getControllerName());
        $action = strtolower($this->_request->getActionName());
        
        
        if ($identity && $identity !="") {
       	 	$layout = Zend_Layout::getMvcInstance();
	  		$view = $layout->getView();
	  		$view->login = $identity;

	  		$siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
	       	
			$id = $siteInfoNamespace->userId;
			$view->firstname = $siteInfoNamespace->Firstname;
			$username = $siteInfoNamespace->username;
			$password = $siteInfoNamespace->password;

        	$db = new Zend_Db_Adapter_Pdo_Mysql(array(
                            'host'      => $config->resources->db->params->host,
                            'username'  => $username,
                            'password'  => $password,
                            'dbname'    => $config->resources->db->params->dbname
                        ));
        	Zend_Db_Table_Abstract::setDefaultAdapter($db);
	   	
         	return;
		}else{
	  		$siteInfoNamespace = new Zend_Session_Namespace('siteInfoNamespace');
	  		$siteInfoNamespace->requestURL = $this->_request->getParams();
	  		$this->_request->setModuleName('default');
	  		$this->_request->setControllerName('Auth');
	  		$this->_request->setActionName('login');
		}
    }
}
