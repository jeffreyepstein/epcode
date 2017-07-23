<?php>
		$contents = stripslashes($_POST['contents']) ;
		$myfile = fopen("curBillsDetails.txt", "w") or die("Unable to open file!");
		fwrite($myfile, $contents);
		fclose($myfile);

		$to      = 'jepstein@alz.org';
		$subject = 'Advocacy Website Auto-Update: GetLegInfo ';
		$headers = 
		'From: ' . $to . "\r\n" .
		'Reply-To: ' . $to . "\r\n" .
		'X-Mailer: PHP/' . phpversion();
		$emailmessage = 'GetLegInfo succesfully run';
		mail($to, $subject, $emailmessage, $headers);		
?> 
