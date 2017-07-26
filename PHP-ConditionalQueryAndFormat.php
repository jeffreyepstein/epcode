<?php
//standard db connection
$con = mysqli_connect("mysql2.fluidhosting.com", "[demo - uid]", "[demo - pw]") or die( "We are experiencing technical difficulties with our database at this time. Please call us at (800) 272-3900 and we'll help you find support groups."  );
//$con = mysqli_connect("mysql2.fluidhosting.com",  "[demo - uid]", "[demo - pw]") or die(mysql_error());
/*
if (mysqli_connect_errno($con))
  {
  echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
  */
   //declare vars we will use later
   $sql = '';
   $choices = '';
   $gt = '';
   $sectionchoice = "";
   $part = "";
   $gtonly = 0;
   $val = "";
	//form processing -- gt
  	if(!empty($_POST['gt'])){
	  $gt = $_POST['gt'];	  //if gt exists, put it into local var gt
	  
		  if ($gt == 'allgt') {		//in the form, "allgt" is the val of "Show me everything by groups" so if found abort loop here and make open query.
			$sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM `alzmass_admin`.`SGInfo` ORDER BY Grouptype, State, Town ASC";
			$gtonly = 1;
		}
	}
	//form processing -- sectionchoice
	if(!empty($_POST['sectionchoice'])){
	  $sectionchoice = $_POST['sectionchoice'];			//if POST has sectionchoice, put it into local var sectionchoice
		foreach($sectionchoice as $val){					//loop over sectionchoice and get values
		 if ($val == 'ALL'){			//in the form, "ALL" is the val of "Show me everything" so if found abort loop here and make open query.
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM `alzmass_admin`.`SGInfo` ORDER BY Section, State, Town";
		 break;				
		 } else if (strlen($choices) >= 1) {
			   $choices = $choices .= ','.$val;	
				   } else {
			   $choices = $val;  
			   }			//put each val found in the var choices
			}	
		$part = 'section';
		}	
	
	//unless sectionchoice was "ALL" or gt was "allgt" we should not yet have a query. Proceed to build the SQL.
	if ($sql == '') {
			
		if ((strlen($gt) == 0) && (strlen($choices) > 0)) {	//choices only, no grouptype 
		$sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM `alzmass_admin`.`SGInfo` WHERE SectionID IN ($choices) ORDER BY Section, State, Town";
		}
		else if ((strlen($gt) > 0) && (strlen($choices)== 0)){ //no section, grouptype only
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM `alzmass_admin`.`SGInfo` WHERE grouptype LIKE '%$gt%' ORDER BY Section, State, Town";
		}
		else if ((strlen($gt) > 0) && (strlen($choices) > 0)) { //both section and grouptype
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM `alzmass_admin`.`SGInfo` WHERE grouptype LIKE '%$gt%' AND SectionID IN ($choices) ORDER BY Section, State, Town";
		}
		else if ((strlen($choices)== 0) && (strlen($gt) == 0)) { //no section, no grouptype
			exit("<a class='searchagain' href='formpage.html' target='_self'>Search Again</a><br /><span class='exit'>You must select at least one checkbox!</span>&nbsp;&nbsp;	");
		}
	}
	//begin query processing
	if (strlen($sql) > 0) {
		//echo $sql;				//debug
		$result = mysqli_query($con,$sql);			//run the query

	} else {
		exit("<br /><div class='options'><span class='style21'>An error occurred. Please try a different search. Error 65SQL </span></div>");
	}
	//handle errors if query failed.  
	if (!$result){ 
		// probably a syntax error in the SQL, 
		// but could be some other error
		throw new Db_Query_Exception("DB Error: " . mysql_error()); 
	} else {
		mysqli_close($con);
		
		if ($result && $result->num_rows > 0) {
			$current_section = false;
			$current_grouptype = false;
			$i = 0;
			$lasti = 0;
			//section-based output
			if($gtonly == 0) {
				while ($row = $result->fetch_assoc()) {
				  if ($row[trim($part)] != $current_part) {
					echo '</div>'; // close the div
					echo '	
						<br /><span class="header">'.$row[$part].'</span>
						   <div class="contentsdisplay">
							<div class="row-wrap">
								<div class="cell col1">ST</div>
								<div class="cell col2">Town</div>
								<div class="cell col3">Contact Name</div>
								<div class="cell col4">Telephone</div>
								<div class="cell col5">Email</div>
								<div class="cell col6">Group type</div>
								<div class="cell col7">Time</div>
							</div>
					';
								  
						$current_part = $row[trim($part)];
					}
					if ($current_part = $row[trim($part)]) {
				
							echo "<div><div class='cell col1'>".$row['State']."</div><div class='cell col2'>".$row['Town']."</div><div class='cell col3'>".$row['Name']."</div><div class='cell col4'>".$row['Phone']."</div><div class='cell col5'>".$row['Email']."</div><div class='cell col6'>".$row['Grouptype']."</div><div class='cell col7'>".$row['Time']."</div></div>";
							if ($i == 0) {
							$i++;
							} else {
								$i = 0;
							}
						}
				}
			} 
			
			// finish it off	
			echo '</div>'; // close the final div
			} else {		//zero results case
				echo "<br /><div class='options'><span class='style21'>Zero (0) results. Your search did not return any matching items</span></div>";
			}
		}
	//all done
?> 
