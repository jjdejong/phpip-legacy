<?php
class Application_Model_User
{
	protected $_id;
	protected $_email;
	protected $_firstname;
	protected $_lastname;
	protected $_password;
	protected $_passwordsalt;
	protected $_question;
	protected $_secretanswer;
	protected $_lastlogin;
	protected $_ip;
	protected $_ipnum;
	protected $_browser;
	protected $_ipcity;
	protected $_createDate;
	protected $_primary = "ID";
  protected $_dbTable;
  protected $_adapter;
  protected $_error;
    
	public function __construct(array $options = null)
    {
        if (is_array($options)) {
            $this->setOptions($options);
        }
    }


    public function __set($name, $value)
    {
        $method = 'set' . $name;
        if (('mapper' == $name) || !method_exists($this, $method)) {
            throw new Exception('Invalid User property');
        }
        $this->$method($value);
    }

    public function __get($name)
    {
        $method = 'get' . $name;
        if (('mapper' == $name) || !method_exists($this, $method)) {
            throw new Exception('Invalid User property');
        }
        return $this->$method();
    }

    public function setOptions(array $options)
    {
        $methods = get_class_methods($this);
        foreach ($options as $key => $value) {
            $method = 'set' . ucfirst($key);
            if (in_array($method, $methods)) {
                $this->$method($value);
            }
        }
        return $this;
    }
    
	public function setID($text)
    {
        $this->_id = (string) $text;
        return $this;
    }

    public function getID()
    {
        return $this->_id;
    }
    
	  public function setDbTable($dbTable)
    {
        if (is_string($dbTable)) {
            $dbTable = new $dbTable();
        }
        if (!$dbTable instanceof Zend_Db_Table_Abstract) {
            throw new Exception('Invalid table data gateway provided');
        }
        $this->_dbTable = $dbTable;
        $this->_adapter = $dbTable->getAdapter();
        return $this;
    }
 
    public function getDbTable($tableName = 'Application_Model_DbTable_User')
    {
        $this->setDbTable($tableName);
        #Reflection::export(new ReflectionObject($this->_dbTable));
        #print_r($this->_dbTable);
        return $this->_dbTable;
    }
    
    public function getAll($username)
    {
    	$this->setDbTable('Application_Model_DbTable_User');
    	$dbSelect = $this->_dbTable->getAdapter()->select();
    	
    	$selectQuery = $dbSelect->from(array('u'=>'User'))
        						->where('u.Username = ?', $username);
        						
      return $this->_dbTable->getAdapter()->fetchRow($selectQuery);
    }
    
    public function getDisplayName($userID)
    {
    	$this->setDbTable('Application_Model_DbTable_UserProfile');
    	$dbSelect = $this->_dbTable->getAdapter()->select();
    	
    	$selectQuery = $dbSelect->from(array('up' => 'UserProfile'), array('DisplayName'))
    	                        ->where('up.UserID = ?', $userID);
    	
    	$row = $this->_dbTable->getAdapter()->fetchRow($selectQuery);
    	return $row['DisplayName'];
    }
    
    public function updateLastLogin($userID)
    {
    	$this->setDbTable('Application_Model_DbTable_User');
    	
    	$where = $this->_dbTable->getAdapter()->quoteInto('ID = ?', $userID);
    	$data = array('LastLogin' => date('Y-m-d H:i:s'));
    	
    	$this->_dbTable->update($data, $where);    	
    }
    
    public function save($post = array())
    {
    	if(!empty($post))
    	{
    		$this->setDbTable('Application_Model_DbTable_User');
    		$passwordSalt = "prtouch.".$post['Email'];
    		$password = md5($post['Password'].$passwordSalt);
    		$data = array(
    		          'Email' => $post['Email'],
    		          'Firstname' => $post['Firstname'],
    		          'Lastname' => $post['Lastname'],
    		          'Mobile' => $post['Mobile'],
    		          'Password' => $password,
    		          'PasswordSalt' => $passwordSalt,
    		          'ActivationKey' => $post['ActivationKey'],
                          'AccountType' => 1, //free user TODO
    		          'Question' => $post['Question'],
    		          'SecretAnswer' => $post['SecretAnswer'],
    		          'LastLogin' => date('Y-m-d H:i:s')
    		        );
    		        
    		$this->_dbTable->insert($data);
    		$this->setID($this->_adapter->lastInsertID());
    		
    		if($this->getID())
    		{
    			$data = array(
    			           'UserID' => $this->getID(),
    			           'DisplayName' => $post['DisplayName'],
    			           'iAddrLine1' => $post['iAddrLine1'],
    			           'iAddrLine2' => $post['iAddrLine2'],
    			           'iCity' => $post['iCity'],
    			           'iState' => $post['iState'],
    			           'iCountry' => $post['iCountry'],
    			           'iZip' => $post['iZip'],
    			        );
    			        
    			  $this->getDbTable('Application_Model_DbTable_UserProfile')->insert($data);

                          $member_count = array(
                                             'UserID' => $this->getID(),
                                          );
                          $this->getDbTable('Application_Model_DbTable_MemberCount')->insert($member_count);

                          $today = date('Y-m-d H:i:s');
                          $credits = array(
                                         'UserID' => $this->getID(),
                                         'ValidFrom' => $today,
                                         'ValidTo' => new Zend_Db_Expr("DATE_ADD('".$today."', INTERVAL 1 MONTH)"),
                                         'EmailsLeft' => 3000, // TODO
                                        );
                          $this->getDbTable('Application_Model_DbTable_UserCredits')->insert($credits);
    			  
    			  return $this->getID();
    		}else{
    			return false;
    		}
    	}
    	return false;
    }
    
    public function activateUser($actKey = null)
    {
    	if($actKey)
    	{
    		$this->setDbTable('Application_Model_DbTable_User');
    		$dbSelect = $this->_dbTable->getAdapter()->select();
    		
    		$selectQuery = $dbSelect->from('User', array('ID'))
    		                        ->where('ActivationKey = ?', $actKey);
    		                        
    		$result = $this->_dbTable->getAdapter()->fetchRow($selectQuery);
    		
    		if($result['ID']){
    			$data = array('Active' => 1);
    			$this->getDbTable()->update($data, array('ID = ?' => $result['ID']));
    			$this->initMemberCount($result['ID']);
    			return $result['ID'];
    		}
    	}
    	
    	return null;
    }
    
    public function initMemberCount($userID)
    {
    	if($userID){
    		$data = array('UserID' => $userID);
    		$this->getDbTable('Application_Model_DbTable_MemberCount')->insert($data);
    	}    	
    }
    
    public function initCredits($userID)
    {
    	$this->setDbTable('Application_Model_DbTable_User');
    	$dbSelect = $this->_dbTable->getAdapter()->select();
    	$selectQuery = $dbSelect->from('User')
    	                        ->where('ID = ?', $userID);
    	$userInfo = $this->_dbTable->getAdapter()->fetchRow($selectQuery);
    	
    	
    }
}
