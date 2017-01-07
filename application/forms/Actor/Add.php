<?php

class Application_Form_Actor_Add extends Zend_Form
{
    public function init()
    {
         $translate = Zend_Registry::get('ZT');
         $this->setMethod('post');

         $this->addElement('text', 'name', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'first_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'display_name', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'login', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'default_role', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'function', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'parent_company', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'Employer', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'WorkSite', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('radio', 'phy_person', array(
                    'label' => '',
                    'required' => true,
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => $translate->_('Yes'), '0' => $translate->_('No' )),
                    'separator' => '',
                    'label_style' => 'width:78px;vertical-align:top;margin-left:0px;',
                    'value' => '1'
                ));

         $this->addElement('text', 'nationality', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));


         $this->addElement('radio', 'small_entity', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => $translate->_('Yes'), '0' => $translate->_('No' )),
                    'separator' => '',
                    'label_style' => 'width:83px;vertical-align:top;margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('textarea', 'address', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'rows' => '2',
                ));

         $this->addElement('text', 'country', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('textarea', 'address_mailing', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'rows' => '2',
                ));

         $this->addElement('text', 'country_mailing', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                ));

         $this->addElement('textarea', 'address_billing', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input',
                    'rows' => '2',
                ));

         $this->addElement('text', 'country_billing', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'email', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'phone', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'phone2', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('text', 'fax', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->addElement('radio', 'warn', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'multiOptions' => array( '1' => $translate->_( 'Yes'), '0' => $translate->_('No' )),
                    'separator' => '',
                    'label_style' => 'width:83px; vertical-align:top; margin-left:0px;',
                    'value' => '0'
                ));

         $this->addElement('textarea', 'notes', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'rows' => '2',
                    'cols' => '62'
                ));

         $this->addElement('text', 'VAT_number', array(
                    'label' => '',
                    'filters' => array('StringTrim'),
                    'class' => 'actor-input'
                ));

         $this->clearDecorators();
         $this->setElementDecorators(array(
                'viewHelper',
         ));
         $this->addDecorator('formElements');
    }
}
