<?php
$con=mysql_connect("localhost","root","");

if($con){
	mysql_select_db("test",$con);
}
else{
	die("Could not connect to database");
}
?>