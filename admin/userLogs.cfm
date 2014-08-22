<cfoutput>
	<div class="alert alert-success">
		<h3>User Logs</h3>
	</div>	

    	<div class="row">
    		<div class="span5">
				<div class="alert alert-info">
					<strong>User Logs For The Last 7 Days</strong>
				</div>
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
		    			<th>logID</th>
						<th>userID</th>
						<th>User</th>
						<th nowrap="nowrap">log Date</th>
					</tr>
				</thead>		
				<tbody>
				<cfloop query="variables.qryGetUserLogsLast7Days">
					<tr>
						<td>#variables.qryGetUserLogsLast7Days.logID#</td>
						<td>#variables.qryGetUserLogsLast7Days.userID#</td>
						<td>#variables.qryGetUserLogsLast7Days.userFullName#</td>
						<td>#dateFormat(variables.qryGetUserLogsLast7Days.loginDate,"ddd, mm/dd/yyyy")# #timeFormat(variables.qryGetUserLogsLast7Days.loginDate,"hh:mm:ss tt")#</td>
					</tr>	
				</cfloop>
				</tbody>
				</table>	
			</div>
			
					
    		<div class="span5 offset2">
				<div class="alert alert-info">
					<strong>Logs By User</strong>
				</div>
				
				<div class="accordion" id="accordion1">
				<cfloop query="variables.qryGetLogUsers">

					<cfquery dbtype="query" name="qryGetLogsByUser">
						SELECT
							logID, userID, userFullName, loginDate
						FROM
							variables.qryGetUserLogs
						WHERE
							userID = #variables.qryGetLogUsers.userID#
						ORDER BY
							logID DESC	
					</cfquery>
		
					<div class="accordion-group">
					<div class="accordion-heading">
						<div class="row-fluid"><!---  style="background-color: rgb(217, 237, 247);" --->
							<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion1" href="##collapse#variables.qryGetLogUsers.userID#">
							<div class="span6">
								#variables.qryGetLogUsers.userFullName#
							</div>
							</a>
						</div>
					</div>

					<div id="collapse#variables.qryGetLogUsers.userID#" class="accordion-body collapse">
						<div class="accordion-inner">
					    	<table class="table table-striped table-hover">
					    	<thead>
					    		<tr>
					    			<th>logID</th>
									<th>userID</th>
									<th>User</th>
									<th nowrap="nowrap">log Date</th>
								</tr>
							</thead>		
							<tbody>
								<cfif variables.qryGetLogsByUser.recordCount AND variables.qryGetLogsByUser.logID GT 0>
								<cfloop query="variables.qryGetLogsByUser">
									<tr>
										<td>#variables.qryGetLogsByUser.logID#</td>
										<td>#variables.qryGetLogsByUser.userID#</td>
										<td>#variables.qryGetLogsByUser.userFullName#</td>
										<td>#dateFormat(variables.qryGetLogsByUser.loginDate,"ddd, mm/dd/yyyy")# #timeFormat(variables.qryGetLogsByUser.loginDate,"hh:mm:ss tt")#</td>
									</tr>	
								</cfloop>
								<cfelse>
									<tr align="center">
										<td colspan="4">No Record Found</td>
									</tr>
								</cfif>
							</tbody>
							</table>								
						</div>	
					</div>
					</div>
				</cfloop>
				</div>	
				<div style="font-size:12px;">Click on a player name to view more details</div>
			</div>
		</div>		
	
</cfoutput>
	
	<!--- ---------------------------------------------------------------- --->
	
   	<!--- <div class="row">
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
	</div> --->
