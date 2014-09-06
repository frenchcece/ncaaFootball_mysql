
<cfoutput>
   	<cfif variables.activeWeek NEQ -1>
	<div class="alert alert-success">
	<strong>All Games For <cfif variables.qryGetWeekInfoByWeekNumber.weekType EQ "regular">Week #variables.qryGetWeekInfoByWeekNumber.weekName#<cfelse>#variables.qryGetWeekInfoByWeekNumber.weekName# Season</cfif> [From #dateFormat(variables.qryGetWeekInfoByWeekNumber.startDate,"mm-dd-yyyy")# to #dateFormat(variables.qryGetWeekInfoByWeekNumber.endDate,"mm-dd-yyyy")#]</strong>
	</div>
	
	<div style="font-size:12px;">Click on a game to view which players picked it</div>

	<div class="row">
   		<div class="span8">
			<div class="accordion" id="accordion2">
	    	<!--- <table class="table table-striped table-hover">
	    	<thead>
	    		<tr>
					<th>Game Date</th>
					<th>Visiting</th>
					<th>Result</th>
					<th>Score</th>
					<th></th>
					<th>Score</th>
					<th>Result</th>
					<th>Home</th>
					<th>Spread</th>
				</tr>
			</thead>		
			<tbody></tbody>
			</table> --->	
				<cfquery dbtype="query" name="variables.qryGetAllGamesOfTheWeek">
					SELECT DISTINCT
						gameID
					  , gameDate
					  , datecreated
					  , dateupdated
					  , WeekNumber
					  , team1Name
					  , logoID1
					  , teamNickname1
					  , team1Rank
					  , team1PrevRank
					  , teamID1
					  , team1Draw
					  , team1Spread
					  , team2Name
					  , logoID2
					  , teamNickname2
					  , team2Rank
					  , team2PrevRank
					  , teamID2
					  , team2Draw
					  , team2Spread
					  , team1FinalScore
					  , team2FinalScore
					  , team1WinLoss
					  , team2WinLoss
					  , spreadLock
					  , fs.weekType
					  , fs.weekName					
					FROM
						variables.qryGetGamesOfTheWeekWithUsersPicks
					ORDER BY
						gameID;				
				</cfquery>
				
				<cfif variables.qryGetAllGamesOfTheWeek.recordCount>
				<cfloop query="variables.qryGetAllGamesOfTheWeek">
					<div class="accordion-group">
						<div class="accordion-heading">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion2" href="##collapse#variables.qryGetAllGamesOfTheWeek.gameID#">
							<table class="table" style="margin:0;">
								<tr>	
									<td width="25px;" style="border-top:0px;">#dateFormat(variables.qryGetAllGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
									<td width="150px;" style="border-top:0px;" nowrap>
										<!--- <a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetAllGamesOfTheWeek.teamID1#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID1)#'></div><strong>#variables.qryGetAllGamesOfTheWeek.team1Name# #variables.qryGetAllGamesOfTheWeek.teamNickname1#</strong>"><i class="icon-info-sign"></i></a> --->
										<a style="float:left; margin-right:3px;" id="teamStats" rel="clickover" data-content="#footballDaoObj.getTeamStatsHtmlTable(variables.qryGetAllGamesOfTheWeek.teamID1)#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID1)#'></div><strong>#variables.qryGetAllGamesOfTheWeek.team1Name# #variables.qryGetAllGamesOfTheWeek.teamNickname1#</strong><button style='float:right; margin-left:10px;' class='btn btn-danger btn-mini' data-dismiss='clickover' ><i class='icon-remove icon-white'></i></button>"><i class="icon-info-sign"></i></a>
										<div class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID1)#"></div>
										#variables.qryGetAllGamesOfTheWeek.team1Name# <cfif variables.qryGetAllGamesOfTheWeek.team1Rank GT 0>(#variables.qryGetAllGamesOfTheWeek.team1Rank#)</cfif>
									</td>
									<td width="30px;" style="border-top:0px;">
									<cfswitch expression="#trim(variables.qryGetAllGamesOfTheWeek.team1WinLoss)#">
										<cfcase value="W"><span class="label label-success">win</span></cfcase>
										<cfcase value="L"><span class="label label-important">loss</span></cfcase>
										<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
										<cfcase value="P"><span class="label label-info">pending</span></cfcase>
									</cfswitch>
									</td>
									<td width="20px;" style="border-top:0px;">#variables.qryGetAllGamesOfTheWeek.team1FinalScore#</td>
									<td width="5px;" style="border-top:0px;">@</td>
									<td width="20px;" style="border-top:0px;">#variables.qryGetAllGamesOfTheWeek.team2FinalScore#</td>
									<td width="30px;" style="border-top:0px;">
									<cfswitch expression="#trim(variables.qryGetAllGamesOfTheWeek.team2WinLoss)#">
										<cfcase value="W"><span class="label label-success">win</span></cfcase>
										<cfcase value="L"><span class="label label-important">loss</span></cfcase>
										<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
										<cfcase value="P"><span class="label label-info">pending</span></cfcase>
									</cfswitch>
									</td>
									<td width="150px;" style="border-top:0px;" nowrap>
								  		<!--- <a style="float:left; margin-right:3px;" id="teamStats" rel="popover" teamid="#variables.qryGetAllGamesOfTheWeek.teamID2#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID2)#'></div><strong>#variables.qryGetAllGamesOfTheWeek.team2Name# #variables.qryGetAllGamesOfTheWeek.teamNickname2#</strong>"><i class="icon-info-sign"></i></a> --->
										<a style="float:left; margin-right:3px;" id="teamStats" rel="clickover" data-content="#footballDaoObj.getTeamStatsHtmlTable(variables.qryGetAllGamesOfTheWeek.teamID2)#" data-original-title="<div class='logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID2)#'></div><strong>#variables.qryGetAllGamesOfTheWeek.team2Name# #variables.qryGetAllGamesOfTheWeek.teamNickname2#</strong><button style='float:right; margin-left:10px;' class='btn btn-danger btn-mini' data-dismiss='clickover' ><i class='icon-remove icon-white'></i></button>"><i class="icon-info-sign"></i></a>
										<div class="logo logo-small logo-ncaa-small teamId-#trim(variables.qryGetAllGamesOfTheWeek.logoID2)#"></div>
										#variables.qryGetAllGamesOfTheWeek.team2Name# <cfif variables.qryGetAllGamesOfTheWeek.team2Rank GT 0>(#variables.qryGetAllGamesOfTheWeek.team2Rank#)</cfif>
									</td>
									<td width="35px;" style="border-top:0px;" nowrap><cfif variables.qryGetAllGamesOfTheWeek.team2Spread GT 0>+</cfif>#numberFormat(variables.qryGetAllGamesOfTheWeek.team2Spread,"999.9")#</td>
								</tr> 		
							</table>
							</a>
						</div>		
			
								
						<cfquery dbtype="query" name="variables.qryGetUserPicksByGame">
							SELECT
								gameID,
								gameDate,
								userFullName,
								userID,
								userPickedTeamName,
								winLoss						
							FROM
								variables.qryGetGamesOfTheWeekWithUsersPicks
							WHERE
								gameID = #variables.qryGetAllGamesOfTheWeek.gameID#		
							ORDER BY
								userFullName;	
						</cfquery>
						<div id="collapse#variables.qryGetAllGamesOfTheWeek.gameID#" class="accordion-body collapse">
							<div class="accordion-inner">
						    	<table class="table table-striped table-hover">
							    	<thead>
							    		<tr>
											<th>User</th>
											<th>Picked Team</th>
											<th>Result</th>
										</tr>
									</thead>		
									<tbody>
									<cfif variables.qryGetUserPicksByGame.userFullName GT "">
										<cfloop query="variables.qryGetUserPicksByGame">
											<cfif variables.qryGetUserPicksByGame.gameDate GT "" AND DateDiff('n',now(),variables.qryGetUserPicksByGame.gameDate) GT 0 AND variables.qryGetUserPicksByGame.userID NEQ session.user.userID>	<!--- if the game has not started yet and the loggedIn userID is not the userID in the looped query, then do not show the table row --->
												<tr class="error"><td colspan="3" style="text-align: center;"><i class="icon-warning-sign"></i>This Player is Hidden Until Game Time</td></tr>
											<cfelse>
												<tr>
													<td>#variables.qryGetUserPicksByGame.userFullName#</td>
													<td>#variables.qryGetUserPicksByGame.userPickedTeamName#</td>
													<td>
														<cfswitch expression="#trim(variables.qryGetUserPicksByGame.winLoss)#">
															<cfcase value="W"><span class="label label-success">win</span></cfcase>
															<cfcase value="L"><span class="label label-important">loss</span></cfcase>
															<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
															<cfcase value="P"><span class="label label-info">pending</span></cfcase>
															<cfdefaultcase><span class="label label-info">pending</span></cfdefaultcase>
														</cfswitch>
													</td>
												</tr>
											</cfif>	
										</cfloop>
									<cfelse>
										<tr><td colspan="3" align="center">No Player Has Picked This Game</tr>
									</cfif>
								</table>				
							</div>	
						</div>
					</div>	

				</cfloop>
				<cfelse>
					No games found.
				</cfif>
			</div>
		</div>
	</div>
	<cfelse>
		<div class="well" style="text-align:center;"><h4>Displaying all the games results for the entire year would most likely crash my server.</h4><h1>NO CAN DO!!</h1></div>
	</cfif>
</cfoutput>