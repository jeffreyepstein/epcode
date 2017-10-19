<!---Template: cert_submit.cfm
Application: Certification Application application.
Purpose: Handles all submits for all modular forms.
Created: Sept. 2004 by Jeff Epstein; includes legacy code created by ATX(?) for the earlier version of the Certification Application application.
--->
<cfoutput>
<cfif NOT IsDefined("SESSION.cert_login.username")>
	Your session has timed out. Please <a href = "cert_login.cfm">click here</a> to log in again.
	<cfabort>
</cfif>
<!---Initialize error session var--->
<cfset SESSION.errorlist = "">
<!--- Must create this default structure or we pull an error --->
<cfparam name="session.certification_nfo" default="">
<cfif NOT IsStruct(session.certification_nfo)>
            <cfset session.certification_nfo = StructNew()>
</cfif>
		<cfset StructClear(session.certification_nfo)>
		<!---Regular form processing--->
	<cfif IsDefined("FORM.ID")>
		<!---An ID is passed with each form to identify the section. We use a CFSWITCH to branch to the code for that section. In addition to form validation, some cases (excepting simple ones that do not need error-checking) use a structure to hold form variables, which are then error-checked. A separate error-handling routine is included at the end to alert the user to problems and return to the form. Otherwise, a SQL query updates the table.- JE--->

		<cfswitch expression="#FORM.ID#">
<!---*** DESIGNATION *** --->	
			<cfcase value="Designation">
			<!---No error-checking required--->
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert 
						SET designation = '#FORM.designation#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>
			</cfcase>
<!---*** APPLICANT INFORMATION  *** --->	
			<cfcase value="appinfo_all">
			<!---No error-checking required--->
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert 
						SET 
						name = '#FORM.name#',
						org = '#FORM.org#',
						address = '#FORM.address#',
						city = '#FORM.city#',
						state = '#FORM.state#',
						zip = '#FORM.zip#',
						phone = '#FORM.phone#',
						fax = '#FORM.fax#',
						email = '#FORM.email#',
						membernumber = '#FORM.membernumber#',
						chapter = '#FORM.chapter#',
						region = '#FORM.region#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>	
			</cfcase>
	
<!---*** MINIMUM REQUIREMENTS (Eligibility) 0- 1 *** --->	

			
			<cfcase value="minreq0-1">
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert 
						SET Eligibility = '#FORM.eligibility#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>
			</cfcase>
<!---*** MINIMUM REQUIREMENTS (Eligibility) 2 *** --->	

			
			<cfcase value="minreq2">
			<cfif FORM.req IS "No">
					<cfinclude template ="cert_noexec.cfm">
					<cfabort>
			<cfelseif FORM.req IS "Yes">
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert 
						SET Eligibility = '#FORM.eligibility#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery> 
				</cfif> 
			</cfcase>
			
<!---*** TECH PROF 0 ****---->				
			<cfcase value="techprof0">
						<cfinclude template="cert_techprof_0_struc.cfm">
						
						<cfquery name="Narrative" datasource="IPMA">
							SELECT ID, narrativename
							FROM tbCert_Narrative
							WHERE UserID = '#SESSION.cert_login.username#'
						</cfquery>
						
						
						
						<!-- Now we are placing our Form Values into the Session -->
						
						<cfif IsDefined("FORM.descOnesub")>
							<cfinclude template="cert_tp0-1.cfm">
						</cfif>
						<cfif IsDefined("FORM.cktwo")>
							<cfinclude template="cert_tp0-2.cfm">
						</cfif>
						<cfif IsDefined("FORM.ckthree")>
							<cfinclude template="cert_tp0-3.cfm">
						</cfif>
						<cfif IsDefined("FORM.ckfour")>
							<cfinclude template="cert_tp0-4.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckfive")>
							<cfinclude template="cert_tp0-5.cfm">					
						</cfif>
						<cfif IsDefined("FORM.cksix")>
							<cfinclude template="cert_tp0-6.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckseven")>
							<cfinclude template="cert_tp0-7.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckeight")>
							<cfinclude template="cert_tp0-8.cfm">	
						</cfif>
						<cfif IsDefined("FORM.cknine")>
							<cfinclude template="cert_tp0-9.cfm">	
						</cfif>
						<cfif IsDefined("FORM.ckten")>
							<cfinclude template="cert_tp0-10.cfm">	
						</cfif>
						<cfif IsDefined("FORM.Ref1_SA")>
							<cfinclude template="cert_ref1.cfm">	
						</cfif>
						<cfif IsDefined("FORM.Ref2_SA")>
							<cfinclude template="cert_ref2.cfm">	
						</cfif>
						
						<cfif errors NEQ "">
							<cfinclude template="cert_tp0_errors.cfm">	
						</cfif>
						
						<!---INSERT NEW--->
						<!---Loop through all 10 specialites--->		
						<cfloop list="one,two,three,four,five,six,seven,eight,nine,ten" index="anItem">
							<!---Set up vars to be used in the insert query--->		
							<cfset testobject = "FORM.#anItem#">
							<!---If the number var (used for MJ) does not exist it was not chosen, so cfif will drop through and loop to next--->
							<cfif IsDefined("#testobject#")>
								<!---On one, set the sub--->
								<cfif IsDefined("FORM.descOnesub")>
									<cfset LaborSubspecialty = "#FORM.descOnesub#">
								<cfelse>
									<cfset LaborSubspecialty = "">
								</cfif>
									<cfset specialtyvar = "FORM.desc" & "#anItem#">
									<cfset specialty = "#Evaluate(specialtyvar)#">
									<cfset mj = "#Evaluate("FORM" & "." & "#anItem#")#">

								<cfquery name="nid" dbtype="Query">
									SELECT Narrative.ID
									FROM Narrative
									WHERE Narrative.Narrativename LIKE 'Narrative#anItem#'
								</cfquery>
								<cfif nid.recordcount IS 0>
									<cfquery name="nid" datasource="IPMA">
										SELECT ID, Narrativename
										FROM tbCert_Narrative
										WHERE Narrativename LIKE 'Narrative#anItem#'
									</cfquery>
									<!--- STOP. ERROR 159: Narrative recordcount was 0. Please report this error to the <a href="mailto:jepstein@ipma-hr.org">web manager</a>. 
									<cfabort>--->
								<cfelseif nid.id IS "">
									STOP. ERROR 162: Narrative ID is blank.  Please report this error to the <a href="mailto:jepstein@ipma-hr.org">web manager</a>.
									<cfabort>
								</cfif>
														
									<cfquery name="putit" datasource="IPMA">
									INSERT INTO tbCert_TP_Profile (UserID, Specialty, 
									 <cfif (IsDefined("LaborSubspecialty")) AND (specialty IS "Employee/Labor Relations")>
										LaborSubspecialty,</cfif> MJ, NID)
																VALUES ( 	'#SESSION.cert_login.username#', '#specialty#', <cfif (IsDefined("LaborSubspecialty")) AND (specialty IS "Employee/Labor Relations")>'#LaborSubspecialty#',</cfif>'#mj#', '#nid.id#') 
									</cfquery>				
									<cfif FORM.Ref1_SA IS "#specialty#">		
										<cfquery name = "addref" datasource="IPMA">
											 UPDATE tbCert_TP_Profile 
											 SET Ref1_SA = '#FORM.Ref1_SA#',
											 Ref1_Name =  '#FORM.Ref1_Name#',
											 Ref1_Relationship =  '#FORM.Ref1_Relationship#',
											 Ref1_Contact =  '#FORM.Ref1_Contact#'
											 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
										  </cfquery>
									</cfif> 
									<cfif FORM.Ref2_SA IS "#specialty#">
									 <cfquery name = "addref" datasource="IPMA">
										 UPDATE tbCert_TP_Profile 
										 SET Ref2_SA = '#FORM.Ref2_SA#',
										 Ref2_Name =  '#FORM.Ref2_Name#',
										 Ref2_Relationship =  '#FORM.Ref2_Relationship#',
										 Ref2_Contact =  '#FORM.Ref2_Contact#'
										 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
									  </cfquery>
									</cfif>								</cfif>
						</cfloop>					
			</cfcase>
			
<!---*** TECH PROF 1---->	
			<cfcase value="techprof1">
						<cfset errors = "">
						<!---Narrative check part 1--->
						<cfquery name="Narrative" datasource="IPMA">
							SELECT ID, narrativename
							FROM tbCert_Narrative
							WHERE UserID = '#SESSION.cert_login.username#'
						</cfquery>
						<cfif Narrative.RecordCount IS 0>
						  <cfset errors ="No narrative completed.">
						  <cfif errors NEQ "">
							<cfinclude template="cert_tp1_errors.cfm">	
						  </cfif>
						</cfif>
						  
						  
				<!---No error-checking required. All choices are the same radio button group, so no loop required. The 3 labor subspecialties are designated including the word sub	to distinguish them from the others--->
				<cfif (IsDefined("FORM.specialty")) AND (FORM.specialty CONTAINS "sub")>		

							<cfif FORM.specialty IS "subone">
								<cfset laborsubspecialty = "Labor/Employee Mgmt. Partnership">
							<cfelseif FORM.specialty IS "subtwo">
								<cfset laborsubspecialty = "Labor/Contract Negotiation/Admin.">
							<cfelseif FORM.specialty IS "subthree">
								<cfset laborsubspecialty = "Dispute Resolution">
							<cfelse>
						Error 219. Please report this error to the <a href="mailto:jepstein@ipma-hr.org">web manager</a>.
							</cfif>
				  	<cfset specialty = "Employee/Labor Relations">
			<cfelse>		
					<cfset specialty = FORM.specialty>
			</cfif>
						
<!---Note: TP 1 has no loop, so no nid query. The nid comes directly out of the narrative master query. je--->
						<cfquery name="putit" datasource="IPMA">
										INSERT INTO tbCert_TP_Profile (UserID, Specialty <cfif (IsDefined("LaborSubspecialty")) AND ((specialty IS "Employee/Labor Relations"))>, LaborSubspecialty</cfif>, NID)
VALUES ( '#SESSION.cert_login.username#', '#specialty#' <cfif (IsDefined("LaborSubspecialty")) AND ((specialty IS "Employee/Labor Relations"))>, '#LaborSubspecialty#'</cfif>, '#narrative.id#') 
						</cfquery>							
						
									<cfquery name = "addref" datasource="IPMA">
										 UPDATE tbCert_TP_Profile 
										 SET Ref1_SA = '#specialty#',
										 Ref1_Name =  '#FORM.Ref1_Name#',
										 Ref1_Relationship =  '#FORM.Ref1_Relationship#',
										 Ref1_Contact =  '#FORM.Ref1_Contact#'
										 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
									  </cfquery>
								
								
									 <cfquery name = "addref" datasource="IPMA">
										 UPDATE tbCert_TP_Profile 
										 SET Ref2_SA = '#specialty#',
										 Ref2_Name =  '#FORM.Ref2_Name#',
										 Ref2_Relationship =  '#FORM.Ref2_Relationship#',
										 Ref2_Contact =  '#FORM.Ref2_Contact#'
										 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
									  </cfquery>
								
			</cfcase>
			
<!---*** TECH PROF 2---->			
			<cfcase value="techprof2">	
				<cfinclude template="cert_techprof_2_struc.cfm">
						<cfquery name="Narrative" datasource="IPMA">
							SELECT ID, Narrativename
							FROM tbCert_Narrative
							WHERE UserID = '#SESSION.cert_login.username#'
						</cfquery>
						
						
						<!-- Now we are placing our Form Values into the Session -->
						
						<cfif IsDefined("FORM.descOnesub")>
							<cfinclude template="cert_tp2-1.cfm">
						</cfif>
						<cfif IsDefined("FORM.cktwo")>
							<cfinclude template="cert_tp2-2.cfm">
						</cfif>
						<cfif IsDefined("FORM.ckthree")>
							<cfinclude template="cert_tp2-3.cfm">
						</cfif>
						<cfif IsDefined("FORM.ckfour")>
							<cfinclude template="cert_tp2-4.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckfive")>
							<cfinclude template="cert_tp2-5.cfm">					
						</cfif>
						<cfif IsDefined("FORM.cksix")>
							<cfinclude template="cert_tp2-6.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckseven")>
							<cfinclude template="cert_tp2-7.cfm">		
						</cfif>
						<cfif IsDefined("FORM.ckeight")>
							<cfinclude template="cert_tp2-8.cfm">	
						</cfif>
						<cfif IsDefined("FORM.cknine")>
							<cfinclude template="cert_tp2-9.cfm">	
						</cfif>
						<cfif IsDefined("FORM.ckten")>
							<cfinclude template="cert_tp2-10.cfm">	
						</cfif>
						<cfif IsDefined("FORM.Ref1_SA")>
							<cfinclude template="cert_ref1.cfm">	
						</cfif>
						<cfif IsDefined("FORM.Ref2_SA")>
							<cfinclude template="cert_ref2.cfm">	
						</cfif>
						
						<cfif errors NEQ "">
							<cfinclude template="cert_tp2_errors.cfm">	
						</cfif>
						
						<!---INSERT NEW--->
										
						<cfloop list="one,two,three,four,five,six,seven,eight,nine,ten" index="anItem"><!---set up vars--->
				
						<cfif anItem IS "one">
								<cfif IsDefined("FORM.descOnesub")>
									<cfset FORM.ckone = "Employee/Labor Relations">
									<cfset LaborSubspecialty = "#FORM.descOnesub#">
									<cfset specialty = "Employee/Labor Relations">
								<cfelse>
									<cfset specialty = "NA">
								</cfif>
						    <cfelse>	
								<cfset LaborSubspecialty = "">
								<cfset testobject = "FORM.ck#anItem#">
								<cfif IsDefined("#testobject#")>
										<cfset specialtyvar = "FORM.desc" & "#anItem#">
										<cfset specialty = "#Evaluate(specialtyvar)#">
										
								<cfelse>
										<cfset specialty = "NA">
								</cfif>
							</cfif>
							
							<cfif specialty IS NOT "NA">
								
								<cfquery name="nid" dbtype="Query">
									SELECT id
									FROM Narrative
									WHERE Narrativename LIKE 'narrative#anItem#'
								</cfquery>
								<cfif nid.recordcount IS 0>
									STOP. ERROR 336. Please report this error to the <a href="mailto:jepstein@ipma-hr.org">web manager</a>.
									<cfabort>
								<cfelseif nid.id IS "">
									STOP. ERROR 339. Please report this error to the <a href="mailto:jepstein@ipma-hr.org">web manager</a>.
									<cfabort>
								</cfif>
								
								
								<!---Queries--->
								<cfquery name="putit" datasource="IPMA">
								INSERT INTO tbCert_TP_Profile (UserID, Specialty 
								 <cfif (IsDefined("LaborSubspecialty")) AND ((specialty IS "Employee/Labor Relations"))>, LaborSubspecialty</cfif>, NID)
								VALUES ( '#SESSION.cert_login.username#', '#specialty#' <cfif (IsDefined("LaborSubspecialty")) AND ((specialty IS "Employee/Labor Relations"))>, '#LaborSubspecialty#'</cfif>, '#nid.id#') 
								</cfquery>					
								<cfif FORM.Ref1_SA IS "#specialty#">		
									<cfquery name = "addref" datasource="IPMA">
										 UPDATE tbCert_TP_Profile 
										 SET Ref1_SA = '#FORM.Ref1_SA#',
										 Ref1_Name =  '#FORM.Ref1_Name#',
										 Ref1_Relationship =  '#FORM.Ref1_Relationship#',
										 Ref1_Contact =  '#FORM.Ref1_Contact#'
										 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
									  </cfquery>
								</cfif> 
								<cfif FORM.Ref2_SA IS "#specialty#">
									 <cfquery name = "addref" datasource="IPMA">
										 UPDATE tbCert_TP_Profile 
										 SET Ref2_SA = '#FORM.Ref2_SA#',
										 Ref2_Name =  '#FORM.Ref2_Name#',
										 Ref2_Relationship =  '#FORM.Ref2_Relationship#',
										 Ref2_Contact =  '#FORM.Ref2_Contact#'
										 WHERE UserID ='#SESSION.cert_login.username#' AND Specialty = '#specialty#'
									  </cfquery>
								</cfif>
							</cfif>															
					</cfloop>
								<!---Error check--->
								 <cfif errors NEQ "">
									<cfinclude template = "cert_tp2_errors.cfm">
								 </cfif>		
			</cfcase>
<!---***EDUCATION SUMMARY (applies to versions 0 and 1 only) ***--->	
			<cfcase value="ed_0-1">
			<!---BEGIN ERROR CHECKING--->
				<!-- Now we are going to do our Error Checking first off by creating a value of nothing for the variable we are calling Errors -->
				<cfparam name="errors" type="string" default="">
				<!-- As we check for Errors if we find one we place it in our List to display to our user making it easy for the end-user to correct as they can see the error -->
				<!--- Must create this default structure or we pull an error --->
				<cfparam name="SESSION.certification_nfo" default="">
				<cfif NOT IsStruct(SESSION.certification_nfo)>
				            <cfset SESSION.certification_nfo = StructNew()>
				</cfif>
				<cfparam name="SESSION.certification_nfo.College1" default="">
				<cfparam name="SESSION.certification_nfo.Degree1" default="">
				<cfparam name="SESSION.certification_nfo.Date1" default="">
				<cfparam name="SESSION.certification_nfo.College2" default="">
				<cfparam name="SESSION.certification_nfo.Degree2" default="">
				<cfparam name="SESSION.certification_nfo.Date2" default="">
				<cfparam name="SESSION.certification_nfo.HrPaFocus" default="">
				<cfparam name="SESSION.certification_nfo.InOpFocus" default="">
				<cfparam name="SESSION.certification_nfo.EdCert" default="">
				
				<!-- Now we clear the Session of any Values to allow us to place our new form Values passed from our form page -->
				<cfset StructClear(session.certification_nfo)>
		
				<!-- Now we are placing our Form Values into the Session -->
				<cfset session.certification_nfo.College1= FORM.College1>
				<cfset session.certification_nfo.Degree1= FORM.Degree1>
				<cfset session.certification_nfo.Date1= FORM.Date1>
				<cfset session.certification_nfo.College2= FORM.College2>
				<cfset session.certification_nfo.Degree2= FORM.Degree2>
				<cfset session.certification_nfo.Date2= FORM.Date2>
				<cfset session.certification_nfo.HrPaFocus= FORM.HrPaFocus>
				<cfset session.certification_nfo.InOpFocus= FORM.InOpFocus>
				<cfset session.certification_nfo.EdCert= FORM.EdCert>

				 <!---Start Error checking for the first College, Degree, and Date fields--->
				<cfif form.College1 NEQ "">
					<cfif form.Degree1 EQ ""><cfset errors = errors & "<li>The first College/University field is completed, enter the Degree field</li>">
					</cfif>
					<cfif form.Date1 EQ ""><cfset errors = errors & "<li>The first College/University field is completed, enter the Date that you graduated</li>">
					</cfif>
				</cfif>
				<cfif form.Degree1 NEQ "">
					<cfif form.College1 EQ ""><cfset errors = errors & "<li>The first Degree field is completed, enter the College/University field</li>"></cfif>
					<cfif form.Date1 EQ ""><cfset errors = errors & "<li>The first Degree field is completed,  enter the Date that you graduated</li>"></cfif>
					</cfif>
					<cfif form.Date1 NEQ "">
					<cfif form.Degree1 EQ ""><cfset errors = errors & "<li>The first Date field is completed, enter the Degree field</li>"></cfif>
					<cfif form.College1 EQ ""><cfset errors = errors & "<li>The first Date field is completed, enter the College/University field</li>"></cfif>
				</cfif>
				
				<cfif form.College2 NEQ "">
					<cfif form.Degree2 EQ ""><cfset errors = errors & "<li>The second College/University field is completed, enter the Degree field</li>"></cfif>
					<cfif form.Date2 EQ ""><cfset errors = errors & "<li>The second College/University field is completed, enter the Date that you graduated</li>"></cfif>
					</cfif>
					<cfif form.Degree2 NEQ "">
					<cfif form.College2 EQ ""><cfset errors = errors & "<li>The second Degree field is completed, enter the College/University field</li>"></cfif>
					<cfif form.Date2 EQ ""><cfset errors = errors & "<li>The second Degree field is completed,  enter the Date that you graduated</li>"></cfif>
				</cfif>
				<cfif form.Date2 NEQ "">
					<cfif form.Degree2 EQ ""><cfset errors = errors & "<li>The second Date field is completed, enter the Degree field</li>"></cfif>
					<cfif form.College2 EQ ""><cfset errors = errors & "<li>The second Date field is completed, enter the College/University field</li>">
					</cfif> 
				</cfif>
				
					<cfquery name="action" datasource="IPMA" debug="yes">
						UPDATE tbCert 
						SET 
						
						<cfif IsDefined("FORM.College1")>College1 = '#FORM.College1#',
						Degree1 = '#FORM.Degree1#',
						Date1 = '#FORM.Date1#'</cfif>
						<cfif IsDefined("FORM.College2")>, College2 = '#FORM.College2#',
						Degree2 = '#FORM.Degree2#',
						Date2 = '#FORM.Date2#'</cfif>
						<cfif IsDefined("FORM.HrPAFocus")>, HrPAFocus  = '#FORM.HrPAFocus#'</cfif>
						<cfif IsDefined("FORM.InOpFocus")>, InOpFocus = '#FORM.InOpFocus#'</cfif>
						<cfif IsDefined("FORM.EdCert")>, EdCert = '#FORM.EdCert#'	</cfif>		
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>	
					
			</cfcase>
	
			
<!---*** EMPLOYMENT *** --->
					<cfcase value="employment">
			<!---BEGIN ERROR CHECKING--->
				<!-- Now we are going to do our Error Checking first off by creating a value of nothing for the variable we are calling Errors -->
				<cfparam name="errors" type="string" default="">
				<!-- As we check for Errors if we find one we place it in our List to display to our user making it easy for the end-user to correct as they can see the error -->
				<!--- Must create this default structure or we pull an error --->
				<cfparam name="SESSION.certification_nfo" default="">
				<cfif NOT IsStruct(SESSION.certification_nfo)>
				            <cfset SESSION.certification_nfo = StructNew()>
				</cfif>
					<cfparam name="session.certification_nfo.Employer1" default="">
					<cfparam name="session.certification_nfo.Job1" default="">
					<cfparam name="session.certification_nfo.Date1a" default="">
					<cfparam name="session.certification_nfo.Date1b" default="">
					<cfparam name="session.certification_nfo.Employer2" default="">
					<cfparam name="session.certification_nfo.Job2" default="">
					<cfparam name="session.certification_nfo.Date2a" default="">
					<cfparam name="session.certification_nfo.Date2b" default="">
					<cfparam name="session.certification_nfo.Employer3" default="">
					<cfparam name="session.certification_nfo.Job3" default="">
					<cfparam name="session.certification_nfo.Date3a" default="">
					<cfparam name="session.certification_nfo.Date3b" default="">			
			
					<!-- Now we clear the Session of any Values to allow us to place our new form Values passed from our form page -->
					<cfset StructClear(session.certification_nfo)>
					
					<!-- Now we are placing our Form Values into the Session -->
					<cfset session.certification_nfo.Employer1= form.Employer1>
					<cfset session.certification_nfo.Job1= form.Job1>
					<cfset session.certification_nfo.Date1a= form.Date1a>
					<cfset session.certification_nfo.Date1b= form.Date1b>
					<cfset session.certification_nfo.Employer2= form.Employer2>
					<cfset session.certification_nfo.Job2= form.Job2>
					<cfset session.certification_nfo.Date2a= form.Date2a>
					<cfset session.certification_nfo.Date2b= form.Date2b>
					<cfset session.certification_nfo.Employer3= form.Employer3>
					<cfset session.certification_nfo.Job3= form.Job3>
					<cfset session.certification_nfo.Date3a= form.Date3a>
					<cfset session.certification_nfo.Date3b= form.Date3b>
			
					<!---Start Error checking for the first Employer, Title, and Date Fields--->
					<cfif form.Employer1 NEQ "">
						<cfif form.Job1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Employer field is completed, enter the Job Title field</li>"></cfif>
						<cfif form.Date1a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Employer field is completed, enter the first Date field</li>"></cfif>
						<cfif form.Date1b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Employer field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Job1 NEQ "">
						<cfif form.Employer1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Job Title field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Date1a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Job Title field is filled in enter the first Date field</li>"></cfif>
						<cfif form.Date1b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Job Title field is filled in enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date1a NEQ "">
						<cfif form.Employer1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date1b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date1b NEQ "">
						<cfif form.Employer1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job1 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date1b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The first Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					
					<cfif form.Employer2 NEQ "">
						<cfif form.Job2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Employer field is completed, enter the Job Title field</li>"></cfif>
						<cfif form.Date2a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Employer field is completed, enter the first Date field</li>"></cfif>
						<cfif form.Date2b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Employer field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Job2 NEQ "">
						<cfif form.Employer2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Title field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Date2a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Title field is completed, enter the first Date field</li>"></cfif>
						<cfif form.Date2b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Title field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date2a NEQ "">
						<cfif form.Employer2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date2b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date2b NEQ "">
						<cfif form.Employer2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job2 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date2b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The second Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					
					<cfif form.Employer3 NEQ "">
						<cfif form.Job3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Employer field is completed, enter the Job Title field</li>"></cfif>
						<cfif form.Date3a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Employer field is completed, enter the first Date field</li>"></cfif>
						<cfif form.Date3b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Employer field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Job3 NEQ "">
						<cfif form.Employer3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Job Title field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Date3a EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Job Title field is completed, enter the first Date field</li>"></cfif>
						<cfif form.Date3b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Job Title field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date3a NEQ "">
						<cfif form.Employer3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date3b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif form.Date3b NEQ "">
						<cfif form.Employer3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the Employer field</li>"></cfif>
						<cfif form.Job3 EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the first Job Title field</li>"></cfif>
						<cfif form.Date3b EQ ""><cfset errors = errors & "<li><b>EMPLOYMENT HISTORY</b> - The third Date field is completed, enter the second Date field</li>"></cfif>
					</cfif>
					<cfif errors NEQ "">
					<cfset errors = errors & "<br> End of errors in Employment History">
					<cfoutput>
					<cfset SESSION.errorlist = "#ERRORS#">
					</cfoutput>
					<SCRIPT LANGUAGE="JavaScript">
					<!-- Beginning of JavaScript-->
				   parent.main.location="cert_employment_all.cfm"
					</SCRIPT>
					<cfabort>
				</cfif>
					<!---End ERROR CHECKING--->
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert 
						SET Employer1 = '#FORM.Employer1#',
						Job1 = '#FORM.Job1#',
						Date1a = '#FORM.Date1a#',
						Date1b = '#FORM.Date1b#'
					<cfif IsDefined("FORM.Employer2")>
						, Employer2 = '#FORM.Employer2#'
						, Job2 = '#FORM.Job2#'
						, Date2a = '#FORM.Date2a#'
						, Date2b = '#FORM.Date2b#'
					</cfif>
					<cfif IsDefined("FORM.Employer3")>
						, Employer3 = '#FORM.Employer3#'
						, Job3 = '#FORM.Job3#'
						, Date3a = '#FORM.Date3a#'
						, Date3b = '#FORM.Date3b#'
					</cfif>			
						WHERE UserID ='#SESSION.cert_login.username#'
					</cfquery>
			</cfcase>
<!--- *** MEMBERSHIPS AND AWARDS *** --->
			<cfcase value="member-award">
					<!---No error-checking required--->
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert
						SET Leadership = '#FORM.Leadership#',
						Awards = '#FORM.Awards#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>
			</cfcase>

<!--- *** PROFESSIONAL CERTIFICATIONS *** --->
			<cfcase value="profcert">
			<!---BEGIN ERROR CHECKING--->
				<!-- Now we are going to do our Error Checking first off by creating a value of nothing for the variable we are calling Errors -->
				<cfparam name="errors" type="string" default="">
				<!-- As we check for Errors if we find one we place it in our List to display to our user making it easy for the end-user to correct as they can see the error -->
				<!--- Must create this default structure or we pull an error --->
				<cfparam name="SESSION.certification_nfo" default="">
				<cfif NOT IsStruct(SESSION.certification_nfo)>
				            <cfset SESSION.certification_nfo = StructNew()>
				</cfif>				
					<cfparam name="session.certification_nfo.Cert1" default="">
					<cfparam name="session.certification_nfo.DateAward1" default="">
					<cfparam name="session.certification_nfo.Current1" default="">
					<cfparam name="session.certification_nfo.Cert2" default="">
					<cfparam name="session.certification_nfo.DateAward2" default="">
					<cfparam name="session.certification_nfo.Current2" default="">
					<cfparam name="session.certification_nfo.Cert3" default="">
					<cfparam name="session.certification_nfo.DateAward3" default="">
					<cfparam name="session.certification_nfo.Current3" default="">	
					<!-- Now we clear the Session of any Values to allow us to place our new form Values passed from our form page -->	
					<cfset StructClear(session.certification_nfo)>
			<!-- Now we are placing our Form Values into the Session -->
					<cfset session.certification_nfo.Cert1= form.Cert1>
					<cfset session.certification_nfo.DateAward1= form.DateAward1>
					<cfset session.certification_nfo.Current1= form.Current1>
					<cfset session.certification_nfo.Cert2= form.Cert2>
					<cfset session.certification_nfo.DateAward2= form.DateAward2>
					<cfset session.certification_nfo.Current2= form.Current2>
					<cfset session.certification_nfo.Cert3= form.Cert3>
					<cfset session.certification_nfo.DateAward3= form.DateAward3>
					<cfset session.certification_nfo.Current3= form.Current3>
								
			
					<!---Start Error checking for the Professional Certifications Held section--->
					<cfif form.Cert1 NEQ "">
						<cfif form.DateAward1 EQ ""><cfset errors = errors & "<li> The Certification Date is completed, enter the name of your Award</li>"></cfif></cfif>
						<cfif form.DateAward1 NEQ "">
						<cfif form.Cert1 EQ ""><cfset errors = errors & "<li> The Awarded field is completed, enter the Certification Date of your Award</li>"></cfif>
					</cfif>
					
					<cfif form.Cert2 NEQ "">
						<cfif form.DateAward2 EQ ""><cfset errors = errors & "<li> The Certification Date is completed, enter the name of your Award</li>"></cfif></cfif>
						<cfif form.DateAward2 NEQ "">
						<cfif form.Cert2 EQ ""><cfset errors = errors & "<li> The Awarded field is completed, enter the Certification Date of your Award</li>"></cfif>
					</cfif>

					<cfif form.Cert3 NEQ "">
						<cfif form.DateAward3 EQ ""><cfset errors = errors & "<li> The Certification Date is completed, enter the name of your Award</li>"></cfif></cfif>
						<cfif form.DateAward3 NEQ "">
						<cfif form.Cert3 EQ ""><cfset errors = errors & "<li> The Awarded field is completed, enter the Certification Date of your Award</li>">
						</cfif>
					</cfif>
				<cfif errors NEQ "">
					<cfset errors = errors & "<br> End of errors in Professional Certifications Held">
					<cfoutput>
					<cfset SESSION.errorlist = "#ERRORS#">
					</cfoutput>
					<SCRIPT LANGUAGE="JavaScript">
					<!-- Beginning of JavaScript-->
					 parent.main.location="cert_profcert_all.cfm"
					</SCRIPT>
					<cfabort>
				</cfif>
					<!---End ERROR CHECKING--->			

					<cfquery name="action" datasource="IPMA">
						<cfif IsDefined("FORM.Cert1")>
							UPDATE tbCert
							SET Cert1 = '#FORM.Cert1#',
							DateAward1 = '#FORM.DateAward1#',
							Current1 = '#FORM.Current1#'
						</cfif>
						<cfif IsDefined("FORM.Cert2")>
							, Cert2 = '#FORM.Cert2#'
							, DateAward2 = '#FORM.DateAward2#'
							, Current2 = '#FORM.Current2#'
						</cfif>		
						<cfif IsDefined("FORM.Cert3")>
							, Cert3 = '#FORM.Cert3#'
							, DateAward3 = '#FORM.DateAward3#'
							, Current3 = '#FORM.Current3#'
						</cfif>			
						WHERE UserID = '#SESSION.cert_login.username#'	
					</cfquery>
			</cfcase>
			
<!---*** PUBLISHING *** --->
			<cfcase value="pubs">
			<!---No error-checking required--->
				<cfif (IsDefined("FORM.Articles")) AND (FORM.Articles IS NOT "")>
					<cfquery name="action" datasource="IPMA">
						UPDATE tbCert
						SET Articles = '#FORM.Articles#'
						WHERE UserID = '#SESSION.cert_login.username#'	
					</cfquery>
				</cfif>
			</cfcase>
			
			
<!---*** DECLARATION ***--->
			<cfcase value = "declaration">
					<cfquery name="action" datasource="IPMA" debug="yes">
						UPDATE tbCert 
						SET Signature = '#FORM.Signature#',
						DateEntered = '#FORM.DateEntered#'
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>						
			</cfcase>
			
<!---*** PAYMENT ***
Note: vars go to a db table, NOT a merchant gateway. 
 --->

			<cfcase value = "payment">
		    
			<!---BEGIN ERROR CHECKING--->
				<!-- Now we are going to do our Error Checking first off by creating a value of nothing for the variable we are calling Errors -->
				<cfparam name="errors" type="string" default="">
				<!-- As we check for Errors if we find one we place it in our List to display to our user making it easy for the end-user to correct as they can see the error -->
				<!--- Must create this default structure or we pull an error --->
				<cfparam name="SESSION.certification_nfo" default="">
				<cfif NOT IsStruct(SESSION.certification_nfo)>
				            <cfset SESSION.certification_nfo = StructNew()>
				</cfif>

					<cfif IsDefined("FORM.studyguide")><cfparam name="session.certification_nfo.Studyguide" default=""></cfif>
				<cfparam name="session.certification_nfo.Price1" default="">
				<!---<cfparam name="session.certification_nfo.Payment" default="">
				 <cfparam name="session.certification_nfo.CCNum" default="">
				<cfparam name="session.certification_nfo.ExpDate" default="">
				<cfparam name="session.certification_nfo.CCCardholder" default=""> --->
					<!-- Now we clear the Session of any Values to allow us to place our new form Values passed from our form page -->
					<cfset StructClear(session.certification_nfo)>
					<!-- Now we are placing our Form Values into the Session -->
					<cfif IsDefined("FORM.studyguide")><cfset session.certification_nfo.Price= form.Studyguide></cfif>
					<cfset session.certification_nfo.Price1= form.Price1>
					<!--- <cfset session.certification_nfo.Payment= form.Payment> --->
					<!--- <cfset session.certification_nfo.CCNum= form.CCNum>	
					<cfset session.certification_nfo.ExpDate= form.ExpDate>
					<cfset session.certification_nfo.CCCardholder= form.CCCardholder> --->
					<!---Start Error checking for the Certification Program Payment Information section--->
					<cfif form.Price1 EQ "199">
						<cfif (NOT IsDefined("FORM.MemberNumber")) OR (form.MemberNumber EQ "")><cfset errors = errors & "<li>The Price that you have choosen is for a Member, please enter your IPMA-HR Membership ID Number</li>">
						</cfif>
					</cfif>							
					<!--- <!---Start Error checking for the first Credit Card Information--->
					<cfif form.Payment NEQ "0">
						<cfif form.CCNum EQ "">
						<cfset errors = errors & "<li>You choose the Credit Card option, enter the Credit Card Number</li>">
						</cfif>

					   <cfif form.ExpDate EQ "">
					   		<cfset errors = errors & "<li>You choose the Credit Card option, enter the Expiration Date</li>"></cfif>
					    <cfif form.CCCardholder EQ "">
							<cfset errors = errors & "<li>You choose the Credit Card option, enter the Cardholder's Name</li>"> 
						</cfif>
					</cfif>	 --->
					
					<!--- <cfif (FORM.Payment EQ "0") AND (FORM.CCNum NEQ "")>
						<cfset errors = errors & "<li>You chose the Check option, but you entered a Credit Card number. Please choose one or the other.</li>">  </cfif> --->
					
				
					<cfif errors NEQ "">
						<cfset errors = errors & "<font color='##ffcccc'>Payment</font>">
						<cfoutput>
						<cfset SESSION.errorlist = "">
						<cfset SESSION.errorlist = "#ERRORS#">
						</cfoutput>
						
						<SCRIPT LANGUAGE="JavaScript">
						<!-- Beginning of JavaScript-->
						   parent.main.location="cert_payment1.cfm"
						</SCRIPT>
						<cfabort>
					</cfif>
					
					<cfquery name="action" datasource="IPMA" debug="yes">
						UPDATE tbCert 
						SET 	<cfif IsDefined("FORM.studyguide")>Studyguide = '#FORM.Studyguide#',</cfif>
						Price1 = '#FORM.Price1#',
						<!--- Payment = '#FORM.Payment#', --->
						TotPrice = '#FORM.TotPrice#'
						<!--- CCNum ='#FORM.CCNum#',
						ExpDate = '#FORM.ExpDate#', --->
						<cfif IsDefined("FORM.MemberNumber")>, MemberNumber = '#FORM.MemberNumber#'</cfif>
						<!--- CCCardholder = '#FORM.CCCardholder#' --->
						WHERE UserID = '#SESSION.cert_login.username#'
					</cfquery>	
					 <cfset SESSION.errorlist = "">
				
			
	      	</cfcase><!---End of last cfcase--->							
		</cfswitch><!---End of cfswitch--->
	</cfif>
	<!---Return control to main frame for next action--->
 <SCRIPT LANGUAGE="JavaScript">
	top.frames.location.href='cert_frame.cfm';
 </SCRIPT>
</cfoutput>
<!---THE END--->
