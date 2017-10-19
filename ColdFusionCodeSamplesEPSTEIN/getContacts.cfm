<cfquery name = "qGetContacts" datasource="Partners">
	select
		p1.vchCompany AS PartnerCompany],
		c.vchFName + ' ' + c.vchLName AS ContactName,
		c.vchCompany AS ContactCompany,
		c.vchPhone AS ContactPhone,
		c.vchEmail AS ContactEmail, 
		(select ContactType from lk_ContactTypes where TypeID = c.ContactTypeID) AS ContactType,
		UPPER(p1.Partner_Status) AS PartnerType
	from
		p_contact c
	inner join
		p_partner p1 on p1.partnerid = c.partnerid
	where
		c.ContactTypeID IN ('1','2','3','4')
	and
		p1.Partner_Status IN ('ra','sp','gp','cc')
	order by
		p1.vchCompany, c.vchCompany, c.vchFName, c.vchLName, [Contact Type]
</cfquery>

<cfif qGetContacts gt 0>

	<cfcontent type="application/msexcel">
	
	<cfheader name="Content-Disposition" value="filename=PartnerContacts.xls">
	
	<!--- Format data using cfoutput and a table. 
	        Excel converts the table to a spreadsheet.
	        The cfoutput tags around the table tags force output of the HTML when
	        using cfsetting enablecfoutputonly="Yes" --->
	   <cfsetting enableCFoutputOnly = "Yes">
		<cfoutput>
		    <table cols="5">
		        <cfloop query = "qGetContacts">
		            <tr>	
		                <td>#PartnerCompany#</td>
						<td>#ContactType#</td>
		                <td>#ContactName#</td>
		                <td>#ContactPhone#</td>
						<td>#ContactEmail#</td>
		          	</tr>	
		        </cfloop>
		    </table>
		</cfoutput>


</cfif>