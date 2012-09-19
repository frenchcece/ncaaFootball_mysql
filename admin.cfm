<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>

<cfparam name="variables.userID" default="-1">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.userID = url.userID>
</cfif>

<cfinvoke component="#application.appmap#.cfc.adminDao" method="getUserLogs" returnvariable="variables.qryGetUserLogs">
	<cfif variables.userID GT 0><cfinvokeargument name="userID" value="#variables.userID#"></cfif>
	<!--- <cfinvokeargument name="startDate" value="">
	<cfinvokeargument name="endDate" value=""> --->
</cfinvoke>

<!--- get the list of league's players --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryGetLeaguePlayers"></cfinvoke>


<body>
    <div class="container" id="mainContainer">

	<cfoutput>
	<h3>User Logs</h3>
    	<div class="row">
   			<div class="span5 offset1">
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
						<th colspan="9">Logs for 
							<select id="users" name="users" class="span4" onchange="window.location.href='?userid=' + this.value;">
				                <option value="-1">-- select --</option>
				                <cfloop query="variables.qryGetLeaguePlayers">
									<option value="#variables.qryGetLeaguePlayers.userID#"<cfif variables.qryGetLeaguePlayers.userID EQ variables.userID> selected="true"</cfif>>#variables.qryGetLeaguePlayers.userFullName#</option>
								</cfloop>
							</select>
						</th>
					</tr>
				</thead>
		    	<thead>
		    		<tr>
		    			<th>logID</th>
						<th>userID</th>
						<th>User</th>
						<th nowrap="nowrap">log Date</th>
					</tr>
				</thead>		
				<tbody>
					<cfloop query="variables.qryGetUserLogs">
						<tr>
							<td>#variables.qryGetUserLogs.logID#</td>
							<td>#variables.qryGetUserLogs.userID#</td>
							<td>#variables.qryGetUserLogs.userFullName#</td>
							<td>#dateFormat(variables.qryGetUserLogs.loginDate,"ddd, mm/dd/yyyy")# #timeFormat(variables.qryGetUserLogs.loginDate,"hh:mm:ss tt")#</td>
						</tr>	
					</cfloop>
				</tbody>
				</table>	
			</div>
		</div>
	</cfoutput>
	
	<cfinclude template="footer.cfm">
    </div> <!-- /container -->
</body>
