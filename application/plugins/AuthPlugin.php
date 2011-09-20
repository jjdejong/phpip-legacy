<?php
class Application_Plugins_AuthPlugin extends Zend_Controller_Plugin_Abstract 
{
  public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request) 
  { 
    	$auth = Zend_Auth::getInstance();
        $result = $auth->getStorage();
        $identity = $auth->getIdentity();
        $registry = Zend_Registry::getInstance();
        
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
