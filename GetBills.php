//Basic example of php coding - in this case retrieving a database record and returning it as json.

<?php

//standard db connection

$con=mysqli_connect("mysql2.fluidhosting.com", "[uid]", "[pw]") or die(mysql_error());
if (mysqli_connect_errno($con))
  {
  echo "Failed to connect to MySQL: " . mysql_connect_error();
  }

if (mysqli_connect_errno($con))
  {
  echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
mysqli_set_charset($con,'utf8');
$sql = "SELECT state, title, gcid, session, sponsors, summary FROM `alzmass_advocacy`.`Bills` WHERE state = 'MA'";
$result = mysqli_query($con,$sql) or trigger_error(mysqli_error()." in ".$sql);

if ($result){ 
		$rows = array();
		 while($r = mysqli_fetch_assoc($result)) {
				$rows[] = $r;
				}
			echo json_encode($rows);

		} else {
			echo "Unknown Error";	
		}
	//all done
mysqli_close($con);
?> 

