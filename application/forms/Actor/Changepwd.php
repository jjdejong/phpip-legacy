<?php

class Application_Form_Actor_Changepwd extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');
 
 
        $this->addElement('password', 'Password', array(
            'label' => 'New password',
            ));
 
        $this->addElement('submit', 'submit', array(
            'ignore'   => true,
            'label'    => 'Change',
            )); 
    }
}
