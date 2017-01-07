<?php

class Application_Form_Actor_Changepwd extends Zend_Form
{
    public function init()
    {
        $translate = Zend_Registry::get('ZT');
        $this->setMethod('post');
 
 
        $this->addElement('password', 'Password', array(
            'label' => $translate->_('New password'),
            ));
 
        $this->addElement('submit', 'submit', array(
            'ignore'   => true,
            'label'    => $translate->_('Change'),
            )); 
    }
}
