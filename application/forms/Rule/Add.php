<?php

class Application_Form_Rule_Add extends Zend_Form
{
    public function init()
    {
         $this->setMethod('post');

         $this->addElement('text', 'task_name', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'for_country_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'for_origin_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'for_type_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'for_category_name', array(
                    'required' => true,
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'detail', array(
                    'label' => '',
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

         $this->addElement('text', 'trigger_event_name', array(
                    'required' => true,
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'use_before', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'date-pick'
                ));

         $this->addElement('text', 'use_after', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'date-pick'
                ));

         $this->addElement('text', 'abort_on_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'responsible_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('radio', 'active', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '1'
                ));

         $this->addElement('radio', 'use_parent', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('radio', 'use_priority', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('radio', 'clear_task', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

        $this->addElement('radio', 'delete_task', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));


         $this->addElement('radio', 'end_of_month', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('text', 'use_after', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input  date-pick'
                ));

         $this->addElement('text', 'use_before', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input date-pick'
                ));

         $this->addElement('text', 'condition_event_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'days', array(
                    'required' => true,
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'value' => '0'
                ));

         $this->addElement('text', 'months', array(
                    'required' => true,
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'value' => '0'
                ));

         $this->addElement('text', 'years', array(
                    'required' => true,
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'value' => '0'
                ));

         $this->addElement('text', 'fee', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('radio', 'recurring', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => 'Yes', '0' => 'No' ),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('text', 'cost', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'currency', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'value' => 'EUR'
                ));

         $this->clearDecorators();
         $this->setElementDecorators(array(
                'viewHelper',
         ));
         $this->addDecorator('formElements');
    }
}
