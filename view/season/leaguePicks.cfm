<cfoutput>
<div class="alert alert-success">
	<strong>Picks<cfif variables.activeWeek NEQ -1> For <cfif variables.qryGetWeekInfoByWeekNumber.weekType EQ "regular">Week #variables.qryGetWeekInfoByWeekNumber.weekName#<cfelse>#variables.qryGetWeekInfoByWeekNumber.weekName# Season</cfif></cfif> [From #dateFormat(variables.qryGetWeekInfoByWeekNumber.startDate,"mm-dd-yyyy")# to #dateFormat(variables.qryGetWeekInfoByWeekNumber.endDate,"mm-dd-yyyy")#]</strong>
</div>

<div style="font-size:12px;">Click on a player name to view more details</div>

<div class="accordion" id="accordion1">
	<cfloop query="variables.qryGetLeaguePlayers">
		
		<!--- get the user's picks for that week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicks">
			<cfinvokeargument name="userID" value="#variables.qryGetLeaguePlayers.userID#">
			<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
		</cfinvoke>

		<!--- get the overall results for the week --->
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
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="calculateWinPct" returnvariable="variables.calculatedWinPct">
			<cfinvokeargument name="winLossQuery" value="#qryGetUserPickWeekOverallRecord#">
		</cfinvoke>				

		<div class="accordion-group">
			<div class="accordion-heading">
				<div class="row-fluid" style="background-color: rgb(217, 237, 247);">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion1" href="##collapse#variables.qryGetLeaguePlayers.userID#">
					<div class="span6">
						#variables.qryGetLeaguePlayers.userFullName# 
					</div>
					<div class="span6" style="text-align:right; padding:5px 5px;">
						<cfloop query="qryGetUserPickWeekOverallRecord">
							<cfswitch expression="#trim(qryGetUserPickWeekOverallRecord.winLoss)#">
								<cfcase value="W"><span class="label label-success">#qryGetUserPickWeekOverallRecord.record# win</span></cfcase>
								<cfcase value="L"><span class="label label-important">#qryGetUserPickWeekOverallRecord.record# loss</span></cfcase>
								<cfcase value="T"><span class="label label-inverse">#qryGetUserPickWeekOverallRecord.record# tie</span></cfcase>
								<cfcase value="P"><span class="label label-info">#qryGetUserPickWeekOverallRecord.record# pending</span></cfcase>
							</cfswitch>	
						</cfloop>
						<span class="label label-warning">#numberFormat(variables.calculatedWinPct,"99.99")# %</span>
					</div>
					</a>
				</div>
			</div>		
			<div id="collapse#variables.qryGetLeaguePlayers.userID#" class="accordion-body collapse">
				<div class="accordion-inner">
			    	<div class="row">
			    		<div class="span8">
					    	<table class="table table-striped table-hover">
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
													<td nowrap="nowrap">
														<a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID1)#'></div><strong>#variables.qryGetGamesOfTheWeek.team1Name# #variables.qryGetGamesOfTheWeek.teamNickname1#</strong>"><i class="icon-info-sign"></i></a>
														<div class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID1)#"></div>
														<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1> class="badge badge-success"</cfif>>
															#variables.qryGetGamesOfTheWeek.team1Name# <cfif variables.qryGetGamesOfTheWeek.team1Rank GT 0>(#variables.qryGetGamesOfTheWeek.team1Rank#)</cfif>
														</span>
													</td>
													<td>#variables.qryGetGamesOfTheWeek.team1FinalScore#</td>
													<td>@</td>
													<td>#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
													<td nowrap="nowrap">
														<a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID2)#'></div><strong>#variables.qryGetGamesOfTheWeek.team2Name# #variables.qryGetGamesOfTheWeek.teamNickname2#</strong>"><i class="icon-info-sign"></i></a>
														<div class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID2)#"></div>
														<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2> class="badge badge-success"</cfif>>
															#variables.qryGetGamesOfTheWeek.team2Name# <cfif variables.qryGetGamesOfTheWeek.team2Rank GT 0>(#variables.qryGetGamesOfTheWeek.team2Rank#)</cfif>
														</span>
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
			
							    	<!--- <thead>
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
											<span class="label label-warning">#variables.calculatedWinPct# %</span>
											</th>
										</tr>
									</thead> --->
									<cfelse>
										<tr><td colspan="9">No picks found.</td></tr>
									</cfif>
								</tbody>
							</table>	
						</div>
					</div>	
				</div>
			</div>
		</div>
	</cfloop>
</div>
</cfoutput>