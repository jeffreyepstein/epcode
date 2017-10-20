<cfset variables.SiteAdminURL = "/siteAdmin/swsrAdmin/swsrAdmin.cfm">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>[CUSTOMER] Survey Redirect Administration</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="srsw.css" type="text/css">
<script src="/includes/js/jquery/jquery.js" type="text/javascript"></script>
<script src="/includes/js/jquery/jquery-ui-1.7.3.custom.min.js" type="text/javascript"></script>
<script>


$(document).ready(function() {
	$('a').click(function(){
		var myID = $(this).attr("id");
		var rowRef = ("div_" + myID);
		$('div' +'#' + rowRef).toggleClass('closed open');
		//var rowObj = $('div' +'#' + rowRef);
		//var tr = ("tr_" + myID);
		//var pos = $('tr').offset();
		//pos.bottom = pos.top + $('tr').height();
		//pos.right = pos.left + $('tr').width();
		// pos now contains top, left, bottom, and right in pixels
			//rowObj.toggleClass('closed open');
			//$('div' +'#' + rowRef).css({top:$('div' +'#' + rowRef).position().pos.top+'px'},{left:$('div' +'#' + rowRef).position().pos.left+'px'});
			//rowObj.css({top:rowObj.position().pos.top+'px'},{left:rowObj.position().pos.left+'px'});
			
	});
	
	$("a#delete").click(function(){
		var myID = $(this).attr("name");
		var rowRef = ("div_" + myID);
		var myForm = $('div' +'#' + rowRef + 'form').find('deleter');
		$('myForm').submit();
	});
	
	$("a#cancel").click(function(){
		var myID = $(this).attr("name");
		var rowRef = ("div_" + myID);
		$('div' +'#' + rowRef).toggleClass('open closed');
	});
	
	$("a#save").click(function(){
		var myID = $(this).attr("name");
		var rowRef = ("div_" + myID);
		var myForm = $('div' +'#' + rowRef).find('form');
		$('myForm').submit();
	});
});
</script>

<script type="text/javascript">

	function displayMessage(msg)
	{
	var redirect = confirm(msg);
	if (redirect) location.href="<cfoutput>#variables.SiteAdminURL#</cfoutput>";
	else location.href="<cfoutput>#variables.SiteAdminURL#</cfoutput>";
	
	}
</script>


</head>




<body>

<!--- [CUSTOMER] SURVEY REDIRECT ADMINISTRATION --->
<!--- This template displays the current data table for Survey Redirect and handles create, read, update, and delete actions against it  --->

<cfset variables.SiteAdminURL = "/siteAdmin/swsrAdmin/swsrAdmin.cfm">
<cfoutput>

<cftry>
		<cfif isDefined("form.type") and form.type is "c">
			<cfif isDefined("form.swverNew")>
				<cfset variables.objValcheck = createObject("component", "SurveyRedirect").validation(SWVer = "#trim(form.swverNew)#", SWSP =  "#trim(form.swspNew)#", SWLang =  "#trim(form.langNew)#", DestURL = "#trim(form.DestURLNew)#", CheckType="c")>
				<cfif variables.objValcheck is "OK">
					<cfset variables.objRunInsert = createObject("component", "SurveyRedirect").CreateData(SWVer = "#trim(form.swverNew)#", SWSP =  "#trim(form.swspNew)#", SWLang =  "#trim(form.langNew)#",  DestURL = "#trim(form.DestURLNew)#")>
					<cfif variables.objRunInsert is "OK">
						<cflocation url="#variables.SiteAdminURL#" addToken="No">
						
					</cfif>
				<cfelse>
					<script language="JavaScript">
						displayMessage(' ERROR:\n#variables.objValcheck#');
					</script>
				</cfif>
			<cfelse>
				<script language="JavaScript">
						displayMessage(' ERROR:\nPlease check your form entries');
				</script>
			</cfif>
			
		<cfelseif isDefined("url.type") and url.type is "d">
			<cfset variables.objRunDelete = createObject("component", "SurveyRedirect").DeleteData(ID="#trim(url.id)#")>
			<cfif variables.objRunDelete is "OK">
				<cflocation url="#variables.SiteAdminURL#" addToken="No">
			</cfif>
		<cfelseif isDefined("form.type") and form.type is "u">
			<cfset variables.objRunUpdate = createObject("component", "SurveyRedirect").UpdateData(ID="#trim(form.id)#", SWVer = "#trim(form.swver)#", SWSP =  "#trim(form.swsp)#", SWLang =  "#trim(form.lang)#",  DestURL = "#trim(form.DestURL)#")>
			<cfif variables.objRunUpdate is "OK">
				<cflocation url="#variables.SiteAdminURL#" addToken="No">
			</cfif>
		<cfelseif isDefined("form.type") and form.type is "eu">
			<cfset variables.objRunUpdate = createObject("component", "SurveyRedirect").UpdateDefault(DestURL="#trim(form.newURL)#", ID="#trim(form.duid)#")>
			<cfif variables.objRunUpdate is "OK">
				<cflocation url="#variables.SiteAdminURL#" addToken="No">
			</cfif>
		</cfif>
		<cfcatch type="Any">
			<cfmail from = "webmaster@[CUSTOMER].com" to = "webcferrors@[CUSTOMER].com" subject = "Site Administration Tool Error: SW Survey Redirect">
				<cfdump var = "#cfcatch#">
			</cfmail>
		</cfcatch>
</cftry>
</cfoutput>
<cfset qReadData = createObject("component", "SurveyRedirect").ReadDataAll() >

<!--- parse to separate the defaultURL row --->
<cfquery name = "qDefaultURL" dbtype="query">
	SELECT ID, DestURL
	FROM qReadData
	WHERE Lang LIKE 'Default'
</cfquery >
<cfquery name = "qReadDataDisplay" dbtype="query">
	SELECT *
	FROM qReadData
	WHERE Lang NOT LIKE 'Default'
</cfquery >

	<div id="main">
			<div id="logo" style="float:left; margin-left:20px;">
				<img src="/cfimages/logo_sw.jpg"> <h3>Survey Redirect Administration</h3><br />
			</div> <!--- logo --->
	
		<div id="content" style="display: block; float:left; margin-left:20px; margin-top: 5px;">
	<!--- REMOVE TEST LINKS BELOW BEFORE PRODUCTION -- FOR QA AND UAT USE ONLY --->
	<h3>TEST LINKS - Sim urls to this app from within SW</H3>
	
	<a href="http://miscmsuatsw.[CUSTOMER].swk/swsr/swsrProcess.cfm?swver=2012&swsp=1&lang=en" target="_new" addToken="No">Link with SWVER=2012, SWSP=1, and Lang=EN</a>
	<br />
	<a href="http://miscmsuatsw.[CUSTOMER].swk/swsr/swsrProcess.cfm?swver=2010&swsp=1&lang=fr" target="_new" addToken="No">Link with SWVER=2010, SWSP=1, and Lang=FR</a>
	<br />
	<a href="http://miscmsuatsw.[CUSTOMER].swk/swsr/swsrProcess.cfm?swver=2010&swsp=5&lang=en" target="_new" addToken="No">Link with SWVER=2010, SWSP=5, and Lang=EN</a>
<br /><br />Current contents of Survey Redirect data table:<br />



			<table id = "datatable" border="0" cellpadding="2" >
				<tr class="color1"><td width="10">ID</td><td width="10">SWVER</td><td width="10">S. PACK</td><td width="10">LANG</td><td width="300">URL</td><td>EDIT</td><td>DELETE</td></tr>
				<cfoutput query="qReadDataDisplay">
				<tr id = "tr_a#id#" class="color2"><td>#ID#</td><td>#SWVER#</td><td>#SWSERVICEPACK#</td><td>#LANG#</td><td>#DESTURL#</td><td><a href="##" id="a#ID#"><img src="/cfimages/EDUsite_arrow.jpg" border="0"></a>EDIT</td><td><a href="swsrAdmin.cfm?type=d&id=#id#" name="a#ID#" id="delete"><img src="/cfimages/close.png" border="0" align="right"></a></td></tr>
				<div id="div_a#id#" class="closed"><form name="updater" id="updater" action="swsrAdmin.cfm" method="post"><input type = "hidden" name="type" value="u"><input size="1" type="text" name="ID" value="#trim(ID)#" readonly="yes"><input size="4" type="text" name= "SWVER" value="#SWVER#" ><input size="3" type="text" name= "SWSP" value="#SWSERVICEPACK#"><input size="3" type="text" name= "LANG" value="#LANG#"><input size="45" type="text" name= "DESTURL" value="#DESTURL#"><input id= "saveBut1"type="submit" value="Save"></form>&nbsp;&nbsp;<a href="##" name="a#ID#" id="cancel"><img src="/cfimages/EDUsite_arrow.jpg" border="0"></a>CANCEL</div>
			
				</cfoutput>
			</table>
				
			<h3>Add A New Row:</h3>
			<table border="0" cellpadding="2">
				<tr class="color1"><td width="10">ID</td><td width="10">SWVER</td><td width="10">S. PACK</td><td width="10">LANG</td><td width="300">URL</td><td>EDIT</td><td></td></tr>
				
				<form name="inserter" id="inserter" action="swsrAdmin.cfm" method="post">
				<input type = "hidden" name="type" value="c">
				<tr class="color1"><td></td><td><input type="text" name="swverNew" size="4" value="Ver"></td><td><input type="text" name="swspNew" size="4" value="SP"></td><td><input type="text" name="langNew" size="2" value="EN"></td><td><input type="text" name="destURLNew" size="45" value="www.[CUSTOMER].com"></td><td><input id = "savBut2" type="submit" value="Save"></td></td></tr>
				</form>
			</table>
			
			<h3>Manage Default URL:</h3>
			<cfoutput>
			<table border="0" cellpadding="2">
				<form name="changeDefault" id="changeDefault" action="swsrAdmin.cfm" method="post">
				<input type = "hidden" name="type" value="eu">
				<tr class="color2"><td><input type="text" name="newURL" size="70" value="#qDefaultURL.DestURL#"></td><td><input id = "savBut2" type="submit" value="Change Default URL"></td></tr>
				<input type="hidden" name="DUID" value = "#qDefaultURL.ID#">
				
				</form>
			</table>
			</cfoutput>
			
		</div>

	</div>
</body>
</html>
