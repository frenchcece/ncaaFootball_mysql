
<cfoutput>
	<div class="alert alert-success">
		<strong>Picks<cfif variables.activeWeek NEQ -1> For <cfif variables.qryGetWeekInfoByWeekNumber.weekType EQ "regular">Week #variables.qryGetWeekInfoByWeekNumber.weekName#<cfelse>#variables.qryGetWeekInfoByWeekNumber.weekName# Season</cfif></cfif> [From #dateFormat(variables.qryGetWeekInfoByWeekNumber.startDate,"mm-dd-yyyy")# to #dateFormat(variables.qryGetWeekInfoByWeekNumber.endDate,"mm-dd-yyyy")#]</strong>
	</div>
	
   	<div class="row">
   		<div class="span8">
	    	<table class="table table-striped table-hover table-condensed">
	    	<thead>
	    		<tr>
					<th>Game Date</th>
					<th>Visiting</th>
					<th>Score</th>
					<th>Home</th>
					<th>Spread</th>
					<th>Result</th>
				</tr>
			</thead>		
			<tbody>
				<cfif variables.qryGetUserPicksOfTheWeek.recordCount>
					<cfloop query="variables.qryGetGamesOfTheWeek">
						<cfif variables.qryGetGamesOfTheWeek.gameID GT "">
						<cfquery dbtype="query" name="qryCheckCurrentUserPick">
							SELECT
								  userPickID
								 ,teamID
								 ,winLoss
							FROM
								variables.qryGetUserPicksOfTheWeek
							WHERE
								gameID = #variables.qryGetGamesOfTheWeek.gameID#
						</cfquery>
						</cfif>
						<cfif qryCheckCurrentUserPick.recordCount>
							<cfif qryGetGamesOfTheWeek.gameDate GT "" AND DateDiff('n',now(),qryGetGamesOfTheWeek.gameDate) GT 0 AND variables.currentUserID NEQ session.user.userID>	<!--- if the game has not started yet and the loggedIn userID is not the userID in the looped query, then do not show the table row --->
								<tr class="error"><td colspan="8" style="text-align: center;"><i class="icon-warning-sign"></i>This Pick is Hidden Until Game Time</td></tr>
							<cfelse>
								<tr>
									<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
									<td>
										<!--- <a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID1)#'></div><strong>#variables.qryGetGamesOfTheWeek.team1Name# #variables.qryGetGamesOfTheWeek.teamNickname1#</strong>"><i class="icon-info-sign"></i></a> --->
										<a style="float:left; margin-right:3px;" id="teamStats" rel="clickover" data-content="#footballDaoObj.getTeamStatsHtmlTable(variables.qryGetGamesOfTheWeek.teamID1)#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID1)#'></div><strong>#variables.qryGetGamesOfTheWeek.team1Name# #variables.qryGetGamesOfTheWeek.teamNickname1#</strong><button style='float:right; margin-left:10px;' class='btn btn-danger btn-mini' data-dismiss='clickover' ><i class='icon-remove icon-white'></i></button>"><i class="icon-info-sign"></i></a>
										<span class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID1)#"></span>
										<span style="display: inline-block;"<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1> class="badge badge-success"</cfif>>
											 #variables.qryGetGamesOfTheWeek.team1Name#<cfif variables.qryGetGamesOfTheWeek.team1Rank GT 0> (#variables.qryGetGamesOfTheWeek.team1Rank#)</cfif></span>
									</td>
									<td nowrap="nowrap">#variables.qryGetGamesOfTheWeek.team1FinalScore#&nbsp;-&nbsp;#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
									<td>
										<!--- <a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID2)#'></div><strong>#variables.qryGetGamesOfTheWeek.team2Name# #variables.qryGetGamesOfTheWeek.teamNickname2#</strong>"><i class="icon-info-sign"></i></a> --->
										<a style="float:left; margin-right:3px;" id="teamStats" rel="clickover" data-content="#footballDaoObj.getTeamStatsHtmlTable(variables.qryGetGamesOfTheWeek.teamID2)#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID2)#'></div><strong>#variables.qryGetGamesOfTheWeek.team2Name# #variables.qryGetGamesOfTheWeek.teamNickname2#</strong><button style='float:right; margin-left:10px;' class='btn btn-danger btn-mini' data-dismiss='clickover' ><i class='icon-remove icon-white'></i></button>"><i class="icon-info-sign"></i></a>
										<span class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetGamesOfTheWeek.logoID2)#"></span>
										<span style="display: inline-block;"<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2> class="badge badge-success"</cfif>>
											#variables.qryGetGamesOfTheWeek.team2Name#<cfif variables.qryGetGamesOfTheWeek.team2Rank GT 0> (#variables.qryGetGamesOfTheWeek.team2Rank#)</cfif></span>
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
							variables.qryGetUserPicksOfTheWeek
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
							variables.qryGetUserPicksOfTheWeek
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
							<span class="label label-warning">#numberFormat(variables.calculatedWinPct,"99.99")# %</span>
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
</cfoutput>