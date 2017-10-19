<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 3.0//EN">
<html>
<head>
<cfset locus = "CGP">
<cfoutput>
<title>Conflict Resolution : #locus# - Search for Common Ground</title>
</cfoutput>
<cftry>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="robots" content="noindex, nofollow">
<cfset sector = "Activities">
<style type="text/css"></style>
<link rel="stylesheet" href="sfcghome.css">
<script language="JavaScript" src="HMenu.js"></script> 
<link rel="stylesheet" href="sfcgMenu.css">


<cfinclude template="body.cfm">

<!--Level 1 table-->

<table align=left border="0" bordercolor=#ff0000 cellpadding=0 cellspacing=0
 width="700" vspace="0">
   <tr> 
  <cfinclude template = "banner.cfm">
  </tr>
  <CF_BrowserHawk>
<cfoutput>
	<cfif #browser.browser# is "Netscape">
	<cfinclude template = "navbarNN.cfm">
	<cfelse>
	<cfinclude template = "navbarIE.cfm">
	</cfif>
</cfoutput>
<tr valign = "top">
		<td colspan="3" class="navbar" bgcolor="#FFFFFF" valign = "top">
	<!--Level 2 table-->
		<table width = "700" border = "0" bordercolor = "blue" valign = "top" cellpadding = "0" cellspacing = "0">
				<tr valign = "top">		
					<td valign = "top">
					    <!--Level 3 table start--->
						<table width="600" border="1" cellspacing="1" cellpadding = "5" bordercolor="#000000" bgcolor="#CCCCCC" valign = "top">
<!--First content row: overview banner-->
					<tr bgcolor="#FFFFFF" valign = "top">
<td width = "600" valign="top" background="/Images/howcolor.jpg" colspan="149">

<span class="where-how">CGP Shopping Cart &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;REVIEW ORDER</span>
</td>
						</td>
					</tr>
					<tr>
						<td bgcolor = "#FFFFFF" colspan="150">
				

<!---Checkout page for shopping cart. Gathers customer info and sends customer to next page.---->

<form action = "confirm.cfm" method = "POST">

<span class = "smalltextbold">This is what you are ordering:</span><p>

<!---pull from cookie and display here--->
<p>
<table width = "600" border = "0" bgcolor = "#99ccff">
<p>

<tr><td width = "600" colspan = "6" ><span class = "smalltextbold">Format:</span>
<cfif IsDefined("format") is "false">
<cfset format = "0">
<cfelseif IsDefined("FORM.format")>
<cfset format = "#FORM.format#">
<cfelse>
<cfset format = "#format#">
</cfif>
<cfif #format# IS "NTSC">
<input type = "radio" name = "format" value = "NTSC" checked>NTSC
<input type = "radio" name = "format" value = "PAL">PAL
<cfelseif #format# IS "PAL">
<input type = "radio" name = "format" value = "NTSC">NTSC
<input type = "radio" name = "format" value = "PAL" checked>PAL
<cfelse>

</cfif>
</td></tr>
<!---The following routine reads the cookie, but defines each item as delimited by the semicolon, which means an entire order. Then we use ListGetAt to pull each item from a list, where the list is defined as the CURRENT INDEX ITEM (order) from the loop. This gives the effect of a list-within-a-list--->
<tr><td><font size = "1" >QUAN</font></td><td><font size = "1" >Catalog No.</font></td><td><font size = "1" >Title</font></td><td><font size = "1" >Episode</font></td><td><font size = "1" >Length</font></td></tr>



<cfloop index = "order" list = "#cookie.cart#"
 delimiters = ";">
<cfoutput>
<tr bgcolor = "##f5f5f5">
<td><input type = "hidden" size = "1" name = "quan" value = "#ListGetAt(order, 1)#">#ListGetAt(order, 1)# </font></td><td><input type = "hidden"  name = "itemid" value = "#ListGetAt(order, 2)#"> <input type = "hidden"  name = "item" value = "#ListGetAt(order, 3)#"> <span class = "smalltext">#ListGetAt(order, 3)# </span></td>
<td> <span class = "smalltext">#ListGetAt(order, 4)#</span></td><td> <span class = "smalltext">#ListGetAt(order, 5)#</span></td><td> <span class = "smalltext">#ListGetAt(order, 6)#</span></td>
</tr>
</cfoutput>
</cfloop>
</table>
<p>
<span class = "smalltextbold">To complete your order, please fill out the following information:</span><p>



<i>Items marked with <font size = "3" color="Red">*</font> are required</i> </center><p>
<table width = "500">

<tr>
<td width="100">
<font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">First Name:</font></td>

<td width="100"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="20" maxlength="25" name="bs_f_name"> </font></td></tr>


<tr><td width="100"><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">Last Name:</font><font size="2"> </font></td> <td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="20" maxlength="25" name="bs_l_name"> </font></td> </tr>



<tr><td width="100"><font size="2" face="Arial, Helvetica, sans-serif">Organization:</font></td><td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="40" maxlength="45" name="bs_org"> </font></td></tr>


<tr><td width="100"><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">Address:</font></td><td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="40" maxlength="45" name="sub_s_address"> </font></td></tr>


<tr><td width="100"><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">City:</font></td><td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="20" maxlength="35" name="sub_s_city"> </font></td></tr>


<tr> <td><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">State: </font></td><td><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="2" maxlength="2" name="sub_s_state"> </font></td></tr>


<tr><td><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">Zip:</font><font size="2"> </font></td><td><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="10" maxlength="10" name="sub_s_zipcode"> </font></td>            </tr>

<tr><td width="100"><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">Area code &amp;<br>phone number: </font></td><td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="12" maxlength="12" name="phone"> </font></td></tr>

<tr><td width="100"><font size = "3" color="Red">*</font><font size="2" face="Arial, Helvetica, sans-serif">E-mail <br> address: </font></td><td width="350"><font size="2" face="Arial, Helvetica, sans-serif"><input type="text" size="30" maxlength="45" name="email"> </font></td></tr>

<tr><td align="center" valign="top" colspan="2" width="100%"><font size="2"
face="Arial, Helvetica, sans-serif">
<input type="submit" value="Submit Information" name="bsubmit"><p>
<input type="reset" value="Reset Form" name="reset"><p>
<input type="submit" value="Cancel Cart" name="bsubmit"><P></font></td></tr>

</table>



			
			
			          <!----End program listing---> 
					  	<!--Privacy policy, webmaster, and copyright; row and cells included--><cfinclude template = "disclaimer.cfm">
			             </td>
					</tr>
						 </table>
				</td>
         <td width="150" bordercolor="#FFFF00" valign="top" bgcolor="#000000"> 
             <!---Begin right margin menu. Note content cell is 10 pixels narrower with a 10 pixel black border to create indentation---> <!---Maps will go here if we ever get maps--->
            <table width="140" height="25" bordercolor="#000000" bgcolor="#000000">
              <tr> 
                <td> 
                  <div align="center"></div>
                </td>
              </tr>
              <tr> 
                <td class="earthome"> 
                 <cfinclude template = "contactinfo.cfm">
                </td>
              </tr>
			  
				<!---  <cfinclude template = "rightbuttons.cfm">--->
                </td>
         
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td>&nbsp; </td>
  </tr>
</table>
<cfcatch type = "Any"><cfinclude template = "catchcode.cfm">
</cfcatch>
</cftry>
</body>
</html>