<cfoutput>
	<cfloop query="variables.qryGetLeaguePlayers">
		<!--- get the user's picks for that week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicks">
			<cfinvokeargument name="userID" value="#variables.qryGetLeaguePlayers.userID#">
			<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
		</cfinvoke>

	    	<div class="row">
	    		<div class="span8">
			    	<table class="table table-striped table-hover">
			    	<thead>
			    		<tr class="info">
							<th colspan="8">#variables.qryGetLeaguePlayers.userFullName# Picks<cfif variables.activeWeek NEQ -1> For <cfif variables.qryGetWeekInfoByWeekNumber.weekType EQ "regular">Week #variables.qryGetWeekInfoByWeekNumber.weekName#<cfelse>#variables.qryGetWeekInfoByWeekNumber.weekName# Season</cfif></cfif></th>
						</tr>
					</thead>
			    	<thead>
			    		<tr>
							<th>Game Date</th>
							<th>Visiting</th>
							<th>Score</th>
							<th></th>
							<th>Score</th>
							<th>Home</th>
							<th>Spread</th>
							<th>Result</th>
						</tr>
					</thead>		
					<tbody>
						<cfif variables.qryGetUserPicks.recordCount>
							<cfloop query="variables.qryGetGamesOfTheWeek">
								<cfif variables.qryGetGamesOfTheWeek.gameID GT "">
								<cfquery dbtype="query" name="qryCheckCurrentUserPick">
									SELECT
										  userPickID
										 ,teamID
										 ,winLoss
									FROM
										variables.qryGetUserPicks
									WHERE
										gameID = #variables.qryGetGamesOfTheWeek.gameID#
								</cfquery>
								</cfif>
								<cfif qryCheckCurrentUserPick.recordCount>
									<cfif qryGetGamesOfTheWeek.gameDate GT "" AND DateDiff('n',now(),qryGetGamesOfTheWeek.gameDate) GT 0 AND variables.qryGetLeaguePlayers.userID NEQ session.user.userID>	<!--- if the game has not started yet and the loggedIn userID is not the userID in the looped query, then do not show the table row --->
										<tr class="error"><td colspan="8" style="text-align: center;"><i class="icon-warning-sign"></i>This Pick is Hidden Until Game Time</td></tr>
									<cfelse>
										<tr>
											<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
											<td>
												<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team1Name#</strong>"><i class="icon-info-sign"></i></a>
												<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1> class="badge badge-success"</cfif>>#variables.qryGetGamesOfTheWeek.team1Name#</span>
											</td>
											<td>#variables.qryGetGamesOfTheWeek.team1FinalScore#</td>
											<td>@</td>
											<td>#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
											<td>
												<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team2Name#</strong>"><i class="icon-info-sign"></i></a>
												<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2> class="badge badge-success"</cfif>>#variables.qryGetGamesOfTheWeek.team2Name#</span>
											</td>
											<td><cfif variables.qryGetGamesOfTheWeek.team2Spread GT 0>+</cfif>#numberFormat(variables.qryGetGamesOfTheWeek.team2Spread,"999.9")#</td>
											<td>
											<cfswitch expression="#trim(qryCheckCurrentUserPick.winLoss)#">
												<cfcase value="W"><span class="label label-success">win</span></cfcase>
												<cfcase value="L"><span class="label label-important">loss</span></cfcase>
												<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
												<cfcase value="P"><span class="label label-info">pending</span></cfcase>
											</cfswitch>
											</td>
										</tr>
									</cfif>
								</cfif>
							</cfloop>
							
							<!--- display the forfeit games if the user has not picked at least 5 games --->
							<cfquery dbtype="query" name="qryCheckUserForfeitPick">
								SELECT
									  userPickID
									 ,teamID
									 ,winLoss
									 ,weekNumber
								FROM
									variables.qryGetUserPicks
								WHERE
									gameID = -999
							</cfquery>
							<cfif qryCheckUserForfeitPick.recordCount>
								<cfloop query="qryCheckUserForfeitPick">
									<tr class="error"><td colspan="8" style="text-align: center;"><i class="icon-minus-sign"></i> FORFEIT GAME.  You have not picked enough games for week #qryCheckUserForfeitPick.weekNumber#.  This counts as a LOSS. <i class="icon-minus-sign"></i></td></tr>
								</cfloop>
							
							</cfif>
	
							<!--- display the overall results for the week --->
							<cfquery dbtype="query" name="qryGetUserPickWeekOverallRecord">
								 SELECT
									COUNT(*) AS record
								  , winloss
								 FROM
									variables.qryGetUserPicks
								 GROUP BY
									winloss
								 ORDER BY
									winloss DESC
							</cfquery>
					    	<thead>
					    		<tr>
									<th>Score</th>
									<th colspan="8" style="text-align:right; padding-right:10px;">
									<cfloop query="qryGetUserPickWeekOverallRecord">
										<cfswitch expression="#trim(qryGetUserPickWeekOverallRecord.winLoss)#">
											<cfcase value="W"><span class="label label-success">#qryGetUserPickWeekOverallRecord.record# win</span></cfcase>
											<cfcase value="L"><span class="label label-important">#qryGetUserPickWeekOverallRecord.record# loss</span></cfcase>
											<cfcase value="T"><span class="label label-inverse">#qryGetUserPickWeekOverallRecord.record# tie</span></cfcase>
											<cfcase value="P"><span class="label label-info">#qryGetUserPickWeekOverallRecord.record# pending</span></cfcase>
										</cfswitch>	
									</cfloop>
									<cfinvoke component="#application.appmap#.cfc.footballDao" method="calculateWinPct" returnvariable="variables.calculatedWinPct">
										<cfinvokeargument name="winLossQuery" value="#qryGetUserPickWeekOverallRecord#">
									</cfinvoke>				
									<span class="label label-warning">#variables.calculatedWinPct# %</span>
									</th>
								</tr>
							</thead>
							<cfelse>
								<tr><td colspan="9">No picks found.</td></tr>
							</cfif>
						</tbody>
					</table>	
				</div>
			</div>	
	</cfloop>			
</cfoutput>