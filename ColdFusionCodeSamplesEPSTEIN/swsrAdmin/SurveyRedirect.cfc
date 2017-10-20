<!--- SURVEY REDIRECT --->

<cfcomponent displayname = "SurveyRedirect" hint="This is the main handler for Survey Direct actions">
	<cfset variables.dsn = "www">
	
	<cffunction name = "CreateData"
	access = "remote"
	description = "Handles inserts of new rows into the SurveyRedirect table"
	hint = "Handles inserts of new rows into the SurveyRedirect table" >
		<cfargument	name="SWVer" required = "yes">
		<cfargument	name="SWSP" required = "yes">
		<cfargument	name="SWLang" required = "yes">
		<cfargument	name="DestURL" required = "yes">
		<cfquery name="qCrudOps" datasource= "#dsn#">
			INSERT INTO SurveyRedirect(SWVer, SWServicePack, Lang, DestURL)
			VALUES (<cfqueryparam cfsqltype="cf_sql_int" value="#arguments.SWVer#">, <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.SWSP#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SWLang#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DestURL#">)
		</cfquery>	
		<cfreturn "OK">
	</cffunction>
	
	<cffunction name = "DeleteData"
	access="remote" returntype="Any"
	description = "Deletes a row in the SurveyRedirect table"
	hint = "Deletes a row in the SurveyRedirect table">
		<cfargument	name="ID" required = "yes">
		<cfquery name="qCrudOps" datasource= "#dsn#">
			DELETE FROM SurveyRedirect
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.ID#">
		</cfquery>
		<cfreturn "OK">
	</cffunction>
	
	<cffunction name = "GetURL"
	access = "remote"
	description = "Retrieves the destination URL"
	hint = "Retrieves the destination URL">
		<cfargument	name="SWVer" required = "yes" default="0">
		<cfargument	name="SWSP" required = "yes" default="0">
		<cfargument	name="SWLang" required = "yes" default="0">
		<cfset var defaultURL = "">
		<cfset var finalDest = "">
		<cftry>
			<cfquery name="qGetDefault" datasource= "#dsn#">
				SELECT ID, DestURL
				FROM SurveyRedirect t1
				WHERE Lang = 'Default'
			</cfquery>
			<cfif qGetDefault.recordcount eq 1>
				<cfset defaultURL = qGetDefault.DestURL>
			<cfelse>
				<cfthrow message = "Error in default URL - missing or ambiguous">
			</cfif>
			<cfquery name="qGetURL" datasource= "#dsn#">
				SELECT DISTINCT SWVer, SWServicePack, Lang, DestURL
				FROM SurveyRedirect t1
				WHERE t1.SWVer = <cfqueryparam cfsqltype="cf_sql_int" maxlength="10" value="#arguments.SWVer#">
				AND t1.SWServicePack = <cfqueryparam cfsqltype="cf_sql_int" maxlength="10" value="#arguments.SWSP#">
				AND t1.Lang = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="10" value="#arguments.SWLang#">
			</cfquery>
			<cfif qGetURL.recordcount eq 0 or qGetURL.DestURL is "">
				<cfset finalDest = defaultURL>
			<cfelse>
				<cfset finalDest = qGetURL.DestURL>
			</cfif>
			<cfreturn finalDest >
			<cfcatch type="Any">
				<cfdump var = "#cfcatch#">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name = "ReadDataAll" access="remote" returntype="Any"
	description = "Handles data reads of SurveyRedirect table"
	hint = "Handles data reads of SurveyRedirect table">
		<cfquery name="qReadData" datasource= "#dsn#">
			SELECT ID, SWVer, SWServicePack, Lang, DestURL
			FROM SurveyRedirect
			ORDER BY ID ASC
		</cfquery>
		<cfreturn qReadData>
	</cffunction>

	<cffunction name = "UpdateData" access="remote" returntype="Any"
	description = "Handles updates of rows in the SurveyRedirect table"
	hint = "Handles updates of rows in the SurveyRedirect table" >
			<cfargument	name="ID" required = "yes">
			<cfargument	name="SWVer" required = "yes">
			<cfargument	name="SWSP" required = "yes">
			<cfargument	name="SWLang" required = "yes">
			<cfargument	name="DestURL" required = "yes">
			<cfquery name="qCrudOps" datasource= "#dsn#">
				UPDATE SurveyRedirect
				SET SWVer = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.SWVer#">
				, SWServicePack =  <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.SWSP#">
				, Lang = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SWLang#">
				, DestURL =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DestURL#">
				WHERE ID = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.ID#">
			</cfquery>
			<cfreturn "OK">
	</cffunction>
	
	<cffunction name = "UpdateDefault" access="remote" returntype="Any"
	description = "Handles updates of the default URL in the SurveyRedirect table"
	hint = "Handles updates of the default URL in the SurveyRedirect table">
			<cfargument	name="DestURL" required = "yes">
			<cfargument	name="ID" required = "yes">
			<cfquery name="qCrudOps" datasource= "#dsn#">
				UPDATE SurveyRedirect
				SET DestURL = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.DestURL#">
				WHERE ID = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.ID#">
			</cfquery>
			<cfreturn "OK">
	</cffunction>
	
	<cffunction name = "Validation" access = "remote" returntype="Any"
	description = "Validates the incoming parameters"
	hint = "Validates the incoming parameters">
		<cfargument	name="SWVer" required = "yes" default="">
		<cfargument	name="SWSP" required = "yes" default="">
		<cfargument	name="SWLang" required = "yes" default="">
		<cfargument	name="DestURL" required = "no" default="">
		<cfargument	name="CheckType" required = "no" default="r">
		<cfset var strCheckStatus = "">
		<cfset var strSwverStatus = "">
		<cfset var strSwspStatus = "">
		<cfset var strSwLangStatus = "">
		<cfset var strFinalStatus = "">
		<cfset var strFinalDest = "">
		
		<!--- make sure we have valid arguments ALLOW BLANK FOR USE OF DEFAULT
		<cfif (arguments.CheckType is "c") and (arguments.DestURL is "")>
			<cfset strCheckStatus = "Destination URL is missing!">
		</cfif> --->
	
		<!--- test version --->
		<cfif IsNumeric(arguments.SWVer)>
			<cfif Len(arguments.SWVer) eq 4>
				<cfif (arguments.SWVer lt 2010) or (arguments.SWVer gt 2013)>
					<cfset strSwverStatus = strSwverStatus & " Version year is invalid\n">
				</cfif>
			<cfelse>
				<cfset strSwverStatus = strSwverStatus & " Version format is invalid\n">
			</cfif>
		<cfelse>
			<cfset strSwverStatus = strSwverStatus & " Version is not a number\n">
		</cfif>
		<!--- test sp --->
		<cfif not isNumeric(arguments.SWSP) or (arguments.SWSP lt 0) or (arguments.SWSP gt 5)>
			<cfset strSwspStatus = strSwspStatus & " Service Pack is invalid\n">
		</cfif>
		<!--- test lang --->
		<cfif not len(arguments.SWLang) eq 2>
			<cfset strSwLangStatus = strSwLangStatus & " Language is invalid\n">
		</cfif>
		<!--- build error report --->
		<cfif len(strCheckStatus)>
			<cfset strFinalStatus = strCheckStatus>
		</cfif>
		<cfif len(strSwverStatus)>
			<cfset strFinalStatus =  strFinalStatus & strSwverStatus>
		</cfif>
		<cfif len(strSwspStatus)>
			<cfset strFinalStatus = strFinalStatus & strSwspStatus>
		</cfif>
		<cfif len(strSwLangStatus)>
			<cfset strFinalStatus = strFinalStatus & strSwLangStatus>
		</cfif>
		<!--- if OK, say so --->
		
		<cfif strFinalStatus eq "">
			<cfset strFinalStatus = "OK">
		</cfif>
		
		<cfreturn strFinalStatus>
		
	</cffunction>
	
</cfcomponent>