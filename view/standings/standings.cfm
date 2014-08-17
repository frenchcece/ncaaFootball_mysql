	<cfoutput>
		<div class="alert alert-success">
			<h3>#session.currentSeasonYear# League Standings</h3>
		</div>	
	
    	<div class="row">
    		<div class="span5">
				<div class="alert alert-info">
					<strong>Overall League Standings</strong>
				</div>
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
			    		<th></th>
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
							<td>#variables.standingsOverall.currentRow#</td>
							<td class="span2" nowrap="nowrap">#variables.standingsOverall.userFullName#</td>
							<td>#variables.standingsOverall.win#</td>
							<td>#variables.standingsOverall.loss#</td>
							<td>#variables.standingsOverall.tie#</td>
							<td>#variables.standingsOverall.pending#</td>
							<td><span class="label label-warning">#variables.standingsOverall.winPct# %</span></td>
						</tr>	
					</cfloop>
				</tbody>
				</table>	
			</div>
			
					
    		<div class="span5 offset2">
				<div class="alert alert-info">
				<strong>Results By Week</strong>
				</div>
				
				<div class="accordion" id="accordion1">
				<cfloop query="variables.standingsOverall">

					<!--- get the results for the user group by week --->
					<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandingsGroupByWeekNumber" returnvariable="variables.standingsGroupByWeekNumber">
						<cfinvokeargument name="userID" value="#variables.standingsOverall.userID#">
					</cfinvoke>
					
					<!--- get the results for this week for this user --->
					<cfquery dbtype="query" name="qryResultForThisUserWeek">
						SELECT 
							*
						FROM 
							variables.standingsGroupByWeekNumber
						WHERE
							userID = #variables.standingsOverall.userID#
							AND weekNumber = #session.currentWeekNumber#
							
					</cfquery>
		
					<div class="accordion-group">
					<div class="accordion-heading">
						<div class="row-fluid"><!---  style="background-color: rgb(217, 237, 247);" --->
							<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion1" href="##collapse#variables.standingsOverall.userID#">
							<div class="span6">
								#variables.standingsOverall.userFullName#
							</div>
							<div class="span6" style="text-align:right;">
								This Week:&nbsp;
								<cfif qryResultForThisUserWeek.winPct GT "">
									<span class="label label-warning">#numberFormat(qryResultForThisUserWeek.winPct,"99.99")# %</span>
								<cfelse>
									<span class="label label-info">pending</span>
								</cfif>
							</div>
							</a>
						</div>
					</div>

					<div id="collapse#variables.standingsOverall.userID#" class="accordion-body collapse">
						<div class="accordion-inner">
					    	<table class="table table-striped table-hover">
					    	<!--- <thead>
					    		<tr>
									<th colspan="9"> 
										<select id="program" name="program" class="span4" onchange="window.location.href='?userid=' + this.value;">
							                <cfloop query="variables.standingsOverall">
												<option value="#variables.standingsOverall.userID#"<cfif variables.standingsOverall.userID EQ variables.currentUserID> selected="true"</cfif>>#variables.standingsOverall.userFullName#</option>
											</cfloop>
										</select>
									</th>
								</tr>
							</thead> --->
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
										<td><a href="mySeason.cfm?week=#variables.standingsGroupByWeekNumber.weekNumber#&userid=#variables.standingsGroupByWeekNumber.userID#">#variables.standingsGroupByWeekNumber.weekName#</a></td>
										<td>#variables.standingsGroupByWeekNumber.win#</td>
										<td>#variables.standingsGroupByWeekNumber.loss#</td>
										<td>#variables.standingsGroupByWeekNumber.tie#</td>
										<td>#variables.standingsGroupByWeekNumber.pending#</td>
										<td>
										<cfif variables.standingsGroupByWeekNumber.winPct GT "">
											<span class="label label-warning">#numberFormat(variables.standingsGroupByWeekNumber.winPct,"99.99")# %</span>
										<cfelse>
											<span class="label label-info">pending</span>
										</cfif>	
										</td>
									</tr>	
								</cfloop>
							</tbody>
							</table>								
						</div>	
					</div>
				</cfloop>
				</div>	
				<div style="font-size:10px;">Click on a player name to view more details</div>
			</div>
		</div>	
</cfoutput>