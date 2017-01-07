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
 
        $this->addElement('text', 'Language', array(
            'label' => $translate->_('Language'),
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
