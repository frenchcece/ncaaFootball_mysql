
<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<cfparam name="variables.currentUserID" default="#session.user.userID#">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.currentUserID = url.userID>
</cfif>

<cfinclude template="#application.appmap#/login/checkLogin.cfm">	

<cfinclude template="header.cfm">


<!--- get the overall results for the league --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsOverall">
	<cfinvokeargument name="userID" value="-1">
	<cfinvokeargument name="weekNumber" value="-1">
</cfinvoke>		

<!--- get the results for the user group by week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandingsGroupByWeekNumber" returnvariable="variables.standingsGroupByWeekNumber">
	<cfinvokeargument name="userID" value="#variables.currentUserID#">
</cfinvoke>
<body>
	<cfoutput>
	
    <div class="container" id="mainContainer">
    

    	<div class="row">
    		<div class="span5 offset1">
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
						<th colspan="9">Overall League Standings</th>
					</tr>
				</thead>
		    	<thead>
		    		<tr>
						<th>Name</th>
						<th>Win</th>
						<th>Loss</th>
						<th>Tie</th>
						<th>Pending</th>
						<th nowrap="nowrap">Win %</th>
					</tr>
				</thead>		
				<tbody>
					<cfloop query="variables.standingsOverall">
						<tr<cfif variables.standingsOverall.userID EQ session.user.userID> class="error"</cfif>>
							<td class="span2" nowrap="nowrap">#variables.standingsOverall.userFullName#</td>
							<td>#variables.standingsOverall.win#</td>
							<td>#variables.standingsOverall.loss#</td>
							<td>#variables.standingsOverall.tie#</td>
							<td>#variables.standingsOverall.pending#</td>
							<td><span class="label label-warning">#variables.standingsOverall.winPct#</span></td>
						</tr>	
					</cfloop>
				</tbody>
				</table>	
			</div>
			
    		<div class="span5 offset1">
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
						<th colspan="9">Results by Week for 
							<select id="program" name="program" class="span4" onchange="window.location.href='?userid=' + this.value;">
				                <cfloop query="variables.standingsOverall">
									<option value="#variables.standingsOverall.userID#"<cfif variables.standingsOverall.userID EQ variables.currentUserID> selected="true"</cfif>>#variables.standingsOverall.userFullName#</option>
								</cfloop>
							</select>
						</th>
					</tr>
				</thead>
		    	<thead>
		    		<tr>
		    			<th>Week</th>
						<th>Win</th>
						<th>Loss</th>
						<th>Tie</th>
						<th>Pending</th>
						<th nowrap="nowrap">Win %</th>
					</tr>
				</thead>		
				<tbody>
					<cfloop query="variables.standingsGroupByWeekNumber">
						<tr>
							<td><a href="mySeason.cfm?week=#variables.standingsGroupByWeekNumber.weekNumber#&userid=#variables.standingsGroupByWeekNumber.userID#">#variables.standingsGroupByWeekNumber.weekNumber#</a></td>
							<td>#variables.standingsGroupByWeekNumber.win#</td>
							<td>#variables.standingsGroupByWeekNumber.loss#</td>
							<td>#variables.standingsGroupByWeekNumber.tie#</td>
							<td>#variables.standingsGroupByWeekNumber.pending#</td>
							<td><span class="label label-warning">#variables.standingsGroupByWeekNumber.winPct#</span></td>
						</tr>	
					</cfloop>
				</tbody>
				</table>	
			</div>
		</div>	



	  <cfinclude template="footer.cfm">
	
    </div> <!-- /container -->
	</cfoutput>

  </body>
	    