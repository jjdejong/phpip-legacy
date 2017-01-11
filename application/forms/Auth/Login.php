<?php

class Application_Form_Auth_Login extends Zend_Form
{
    public function init()
    {
        $translate = Zend_Registry::get('ZT');

        $this->setMethod('post');
 
        $this->addElement(
            'text', 'Email', array(
                'label' => $translate->_('Username'),
                'required' => true,
                'filters'    => array('StringTrim'),
            ));
 
        $this->addElement('select', 'Language', array(
            'label' => $translate->_('Language'),
            'multiOptions' => array( 'en' => $translate->_('English'), 'fr' => $translate->_('French' )),
            'class' => 'login-input'
            ));
  
        $this->addElement('password', 'Password', array(
            'label' => $translate->_('Password'),
            ));
 
        $this->addElement('submit', 'submit', array(
            'ignore'   => true,
            'label'    => $translate->_('Login'),
            )); 
    }
}
