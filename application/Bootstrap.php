<?php
class Bootstrap extends Zend_Application_Bootstrap_Bootstrap {
	protected function _initAutoload() {
		$this->getResourceLoader ()->addResourceTypes ( array (
				'plugins' => array (
						'path' => 'plugins/',
						'namespace' => 'Plugins' 
				) 
		) );
	}
	protected function _initAuth() {
		$plugin = new Application_Plugins_AuthPlugin ();
		Zend_Controller_Front::getInstance ()->registerPlugin ( $plugin );
	}
	protected function _initDoctype() {
		$this->bootstrap ( 'view' );
		$view = $this->getResource ( 'view' );
		$view->setEncoding ( 'UTF-8' );
		$view->doctype ( 'XHTML1_STRICT' );
		$view->headMeta ()->appendHttpEquiv ( 'Content-Type', 'text/html;charset=utf-8' );
	}

        public function _initTranslate() {
                $languageNamespace = new Zend_Session_Namespace('siteInfoNamespace');
                $translate = new Zend_Translate(
                            array(
                        'adapter' => 'gettext',
                        'content' => APPLICATION_PATH. '/translations',
                        'scan'  => Zend_Translate::LOCALE_FILENAME
                    )
                    );
                if (isset($languageNamespace->lang)) {
                    if ($translate->isAvailable($languageNamespace->lang)) {
                        $translate->setLocale($languageNamespace->lang);}
                    }
                else {
                    $localeB = Zend_Locale::BROWSER;
                    if ($translate->isAvailable($localeB)) {
                        $translate->setLocale($localeB);
                        }          
                }
                
                Zend_Registry::set('ZT', $translate);
                
                Zend_Validate_Abstract::setDefaultTranslator($translate); 
                Zend_Form::setDefaultTranslator($translate);
                return $translate;
            }
	protected function _initTopnav() {
		$this->bootstrap ( 'layout' );
		$layout = $this->getResource ( 'layout' );
		$view = $layout->getView ();
		
		$navConfig = new Zend_Config_Xml ( APPLICATION_PATH . '/configs/navigation.xml', 'nav' );
		$navContainer = new Zend_Navigation ( $navConfig );
		
		$view->navigation ( $navContainer )->setTranslator(Zend_Registry::get('ZT'));
	}
	protected function _initConfig() {
		$config = new Zend_Config ( $this->getOptions (), true );
		Zend_Registry::set ( 'config', $config );
	}
	protected function _initLoadAclIni() {
		$config = new Zend_Config_Ini ( APPLICATION_PATH . '/configs/acl.ini' );
		Zend_Registry::set ( 'acl', $config );
	}
	protected function _initAclControllerPlugin() {
		$this->bootstrap ( 'frontcontroller' );
		$this->bootstrap ( 'loadAclIni' );
		$front = Zend_Controller_Front::getInstance ();
		$aclPlugin = new Application_Plugins_AclController ( new Application_Model_Acl () );
		$front->registerPlugin ( $aclPlugin );
	}
}

