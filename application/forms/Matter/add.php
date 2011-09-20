<?php

class Application_Form_Matter_Add extends Zend_Form
{
    public function init()
    {
        $this->setMethod('POST');

        $this->addElement('text', 'category', array(
                   'label' => 'Category',
                   'required' => true,
                   'filters' => array('StringTrim')
               ));
    }
}
