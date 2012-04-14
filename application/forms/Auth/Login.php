<?php

class Application_Form_Auth_Login extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');
 
        $this->addElement(
            'text', 'Email', array(
                'label' => 'Username',
                'required' => true,
                'filters'    => array('StringTrim'),
            ));
 
        $this->addElement('password', 'Password', array(
            'label' => 'Password',
            ));
 
        $this->addElement('submit', 'submit', array(
            'ignore'   => true,
            'label'    => 'Login',
            )); 
    }
}
