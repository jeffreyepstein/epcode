<?php

//standard db connection
$con = mysqli_connect(XXXXXXXXXXXXXXXXXXXXXXX) or die(mysql_error());

if (mysqli_connect_errno($con))
  {
  echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
  
   //declare vars we will use later
   $sql = '';
   $choices = '';
   $gt = '';
   $sectionchoice = "";
   $gtonly = 0;
   $val = "";
	//form processing -- gt
  	if(!empty($_POST['gt'])){
	  $gt = $_POST['gt'];	  //if gt exists, put it into local var gt
	  
		  if ($gt == 'allgt') {		//in the form, "allgt" is the val of "Show me everything by groups" so if found abort loop here and make open query.
			$sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM XXXXXXXXXXXX ORDER BY Grouptype, State, Town ASC";
			$gtonly = 1;
		}
	}
	//form processing -- sectionchoice
	if(!empty($_POST['sectionchoice'])){
	  $sectionchoice = $_POST['sectionchoice'];			//if POST has sectionchoice, put it into local var sectionchoice
		foreach($sectionchoice as $val){					//loop over sectionchoice and get values
		 if ($val == 'ALL'){			//in the form, "ALL" is the val of "Show me everything" so if found abort loop here and make open query.
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM XXXXXXXXXXXX ORDER BY Section, State, Town";
		 break;				
		 } else if (strlen($choices) >= 1) {
			   $choices = $choices .= ','.$val;	
				   } else {
			   $choices = $val;  
			   }			//put each val found in the var choices
			}	
		}	
	//unless sectionchoice was "ALL" or gt was "allgt" we should not yet have a query. Proceed to build the SQL.
	if ($sql == '') {
			
		if ((strlen($gt) == 0) && (strlen($choices) > 0)) {	//choices only, no grouptype 
		$sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM XXXXXXXXXXXX WHERE SectionID IN ($choices) ORDER BY Section, State, Town";
		}
		
		else if ((strlen($gt) > 0) && (strlen($choices)== 0)){ //no section, grouptype only
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM XXXXXXXXXXXX WHERE grouptype LIKE '%$gt%' ORDER BY Section, State, Town";
		}
			 
		else if ((strlen($gt) > 0) && (strlen($choices) > 0)) { //both section and grouptype
		 $sql = "SELECT SQL_CACHE Section, Grouptype, State, Town, Name, Phone, Email, Time FROM XXXXXXXXXXXX WHERE grouptype LIKE '%$gt%' AND SectionID IN ($choices) ORDER BY Section, State, Town";
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
				  if ($row[trim('Section')] != $current_section) {
							echo '</table>'; // close the table	
							echo '	
								<br /><span class="sectionheader">'.$row['Section'].'</span>
								   <table class="contentsdisplay">
									<tr>
										<td width="30"><strong>ST</strong></td>
										<td width="120"><strong>Town</strong></td>
										<td width="170"><strong>Contact Name</strong></td>
										<td width="130"><strong>Telephone</strong></td>
										<td width="260"><strong>Email</strong></td>
										<td width="108"><strong>Group type</strong></td>
										<td width="52"><strong>Time</strong></td>
									</tr>
							';
								  
						$current_section = $row[trim('Section')];
					}
					if ($current_section = $row[trim('Section')]) {
				
							echo "<tr class=d$i><td width='30'>".$row['State']."</td><td width='120'>".$row['Town']."</td><td width='170'>".$row['Name']."</td><td width='130'>".$row['Phone']."</td><td width='260'>".$row['Email']."</td><td width='108'>".$row['Grouptype']."</td><td width='52'>".$row['Time']."</td></tr>";
							if ($i == 0) {
							$i++;
							} else {
								$i = 0;
							}
						}
				}
			} else {
			//grouptype-based output
				while ($row = $result->fetch_assoc()) {
				  if ($row[trim('Grouptype')] != $current_grouptype) {
							echo '</table>'; // close the table	
							echo '	
								<br /><span class="sectionheader">'.$row['Grouptype'].'</span>
								   <table class="contentsdisplay">
									<tr>
										<td width="30"><strong>ST</strong></td>
										<td width="120"><strong>Town</strong></td>
										<td width="170"><strong>Contact Name</strong></td>
										<td width="130"><strong>Telephone</strong></td>
										<td width="260"><strong>Email</strong></td>
										<td width="52"><strong>Time</strong></td>
									</tr>
							';
								  
						$current_grouptype = $row[trim('Grouptype')];
					}
					if ($current_grouptype = $row[trim('Grouptype')]) {
				
							echo "<tr class=d$i><td width='30'>".$row['State']."</td><td width='120'>".$row['Town']."</td><td width='170'>".$row['Name']."</td><td width='130'>".$row['Phone']."</td><td width='260'>".$row['Email']."</td><td width='52'>".$row['Time']."</td></tr>";
							if ($i == 0) {
							$i++;
							} else {
								$i = 0;
							}
						}
				}
			}
			// finish it off	
			echo '</table>'; // close the final table	
			} else {		//zero results case
				echo "<br /><div class='options'><span class='style21'>Zero (0) results. Your search did not return any matching items</span></div>";
			}
		}
	//all done
?> 
