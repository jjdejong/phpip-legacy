<?php

class Application_Form_Event_Add extends Zend_Form
{
    public function init()
    {
         $this->setMethod('post');

         $this->addElement('text', 'code', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'name', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('textarea', 'notes', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'rows' => '2',
                    'cols' => '62'
                ));

         $this->addElement('text', 'default_responsible', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('radio', 'is_task', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('radio', 'status_event', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('radio', 'use_matter_resp', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('radio', 'unique', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

        $this->addElement('radio', 'uqtrigger', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));


         $this->addElement('radio', 'killer', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->clearDecorators();
         $this->setElementDecorators(array(
                'viewHelper',
         ));
         $this->addDecorator('formElements');
    }
}
