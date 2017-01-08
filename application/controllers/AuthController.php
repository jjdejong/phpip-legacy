<?php
class AuthController extends Zend_Controller_Action {
	public function init() {
		/* Initialize action controller here */
                $this->translate = Zend_Registry::get('ZT');
                $this->view->translate = $this->translate ;
                $siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
                $this->translate->setlocale($siteInfoNamespace->lang);
                $this->view->translate = $this->translate ;
	}
	public function indexAction() {
	}
	public function loginAction() {
		$auth = Zend_Auth::getInstance ();
		$identity = $auth->getIdentity ();
		// $registry = Zend_Registry::getInstance();
		
		if ($identity && $identity != "") {
			$this->_helper->redirector ( 'index', 'index' );
		} else {
                        $authTable = new Application_Model_DbTable_Actor ();
			$loginForm = new Application_Form_Auth_Login ( $_POST );
			$modelUser = new Application_Model_User ();
			
			$loginForm->getElement ( 'submit' )->setOptions ( array (
					'class' => 'button-style' 
			) );
			
			if ($loginForm->isValid ( $_POST )) {
				$adapter = new Zend_Auth_Adapter_DbTable ( $authTable->getAdapter (), 'actor', 'login', 'password', 'MD5(CONCAT(?, password_salt))' );
				
				$adapter->setIdentity ( $loginForm->getValue ( 'Email' ) );
				$adapter->setCredential ( $loginForm->getValue ( 'Password' ) );
				
				$result = $auth->authenticate ( $adapter );
				
				if ($result->isValid ()) {
					$siteInfoNamespace = new Zend_Session_Namespace ( 'siteInfoNamespace' );
					$userInfo = $modelUser->getAll ( $loginForm->getValue ( 'Email' ) );
					
					$modelUser->updateLastLogin ( $userInfo ['ID'] );
					
					$siteInfoNamespace->userId = $userInfo ['ID'];
					$siteInfoNamespace->Firstname = $userInfo ['name'];
					$siteInfoNamespace->username = $userInfo ['login'];
					$siteInfoNamespace->password = $loginForm->getValue ( 'Password' );
					$siteInfoNamespace->role = $userInfo ['default_role'];
					$locale = $loginForm->getValue ('Language');
                                        if ($this->translate->isAvailable($locale)) {
                                            $this->translate->setLocale($locale);
                                            $siteInfoNamespace->lang = $locale;
                                            }
					if ($siteInfoNamespace->requestURL) {
						$redirectURL = $siteInfoNamespace->requestURL;
						$siteInfoNamespace->requestURL = "";
						$this->_helper->redirector ( $redirectURL ['action'], $redirectURL ['controller'], $redirectURL ['module'] );
					} else {
						$this->_helper->redirector ( 'index', 'index' );
					}
					return;
				} else {
					$layout = Zend_Layout::getMvcInstance ();
					$layout->setLayout ( 'layout.login' );
					$code = array ();
					switch ($result->getCode ()) {
						case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND :
							$auth_error = $this->translate->_("Username not found!");
							$code [$result->getCode ()] = $auth_error;
							break;
						case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID :
							$auth_error = $this->translate->_("Invalid password!");
							$code [$result->getCode ()] = $auth_error;
							break;
						case Zend_Auth_Result::SUCCESS :
							$code [$result->getCode ()] = $this->translate->_("success");
							break;
						case Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS :
							$code [$result->getCode ()] = $this->translate->_("ambiguous");
							break;
						default :
							break;
					}
					$this->view->auth_code = $code;
					$this->view->auth_error = $auth_error;
				}
			} else {
				$layout = Zend_Layout::getMvcInstance ();
				$layout->setLayout ( 'layout.login' );
			}
		}
		
		$this->view->loginForm = $loginForm;
	}
	public function logoutAction() {
		$auth = Zend_Auth::getInstance ();
		$auth->clearIdentity ();
		Zend_Session::namespaceUnset ( "siteInfoNamespace" );
		$this->_helper->redirector ( 'login', 'auth' );
	}
	public function unauthorizedAction() {
		$this->_helper->layout->disableLayout ();
		$this->_helper->viewRenderer->setNoRender ();
		echo $this->translate->_('You are not authorized to access this resource');
	}
}
