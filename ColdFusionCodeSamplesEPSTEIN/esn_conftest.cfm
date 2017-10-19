<!---esn_conftest.cfm---Conference Correspondent signup form.--->
<!---begin form processing on submit---->
<cfif isDefined("form.submit")>
<cfoutput>
	<cfparam name="form.correspondent" default="">
	<cfset idlist="">
	<!---parse all the fieldnames which are random generated--->
	<cfset thevars = "#form.fieldnames#">
	<!---loop thru and create a list of values--->
	<cfloop list="#thevars#" index="quack">
	<cfset thisone = "form"&"."&"#quack#">
		<cfset idlistcand = "#Evaluate(thisone)#">
		<!---only keep a value in the list if it is numeric and therefore an item ID--->
		<cfif isnumeric(idlistcand)>
		<cfset idlist = idlist & idlistcand&",">
		</cfif>
	</cfloop>
	<!---kludge to remove trailing comma--->
	<cfset count = len(idlist)>
	<!---this is our item value list to feed the query--->
	<cfset newlist = "#removechars(idlist,count,2)#">
</cfoutput>
<!---better to run a q of q here but blows up for some reason - too tired--->
	<cfquery name="TCEA2" datasource="hb_eschoolnews">
	SELECT *
	from tblESNConfSessions
	where id in (#newlist#)
	</cfquery>
	<cfoutput>
	<cfsavecontent variable="results">
	Correspondent #form.correspondent# has chosen to review the following TCEA sessions:<br><br>
	<table class="text" bgcolor="ffffcc" border="1" bordercolor="e2e2e2">
	<tr class="header"><td width="300">Title</td><td width="50">Date</td><td width="30">Start</td><td width="30">End</td></tr>
	<cfloop query="tcea2">
	<tr><td>#tcea2.eventtitle#</td><td>#tcea2.eventdate#</td><td>#tcea2.eventstart#</td><td>#tcea2.eventend#</td></tr>
	</cfloop>	
	</table>
	</cfsavecontent>
</cfoutput>
<cfmail type="HTML" to="[removed]" from="[removed]" subject="Conference Correspondent Sign-Up">
#results#
</cfmail>
eMail sent.
	<cfabort>
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<style type="text/css">
.text {font-family: arielnarrow,ariel,verdana; font-size: x-small;}
.header {font-family: arielnarrow,ariel,verdana; font-size: small; font-weight: bold;}
</style>
<link rel="stylesheet" href="esn.css">

<!---Check for login--->

<cfif not isDefined("session.username")>

	<img src="images/esn_logo367.gif" width="367" height="30" alt="" border="0" align="bottom"><br>
	<br>
	<br>
	
	Only authorized persons may submit a Conference Session Review. <br>
	<br>
	Please <a href="/log-in/">Signin</a> or <a href="/registration/">register</a>
	</body>
	</html>
	<cfabort>

</cfif>
<cfquery name="getTCEA" datasource="hb_eschoolnews">
SELECT *
from tblESNConfSessions
WHERE ConfID = '1'
</cfquery>

<cfoutput>#session.username#</cfoutput>, here is the list of TCEA sessions. Check the box for each session you wish to be a correspondent for.<br><br>
<table class="text" bgcolor="ffffcc" border="1" bordercolor="e2e2e2">
<cfform action="conftest1.cfm" method="POST">
<cfoutput><input type="hidden" name="correspondent" value="#session.username#"></cfoutput>
<cfoutput query="gettcea" group="eventstart">

<tr class="header"><td >Select</td><td width="300">Title</td><td width="50">Date</td><td width="30">Start</td><td width="30">End</td></tr>
<cfoutput>
<tr><td><cfinput type="radio" id="choices" name="item#randrange(1,800)#" value="#gettcea.id#"></td>
<td>#gettcea.eventtitle#</td><td>#gettcea.eventdate#</td><td>#gettcea.eventstart#</td><td>#gettcea.eventend#</td></tr>
</cfoutput>
<tr><td bgcolor="##ccff33" colspan="100">&nbsp;</td></tr>
</cfoutput>

</table>
<input type="submit" name="submit" value="Submit">
</cfform>

</body>
</html>
