<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>


<cfparam name="variables.currentUserID" default="#session.user.userID#">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.currentUserID = url.userID>
</cfif>


<cfparam name="variables.activeWeek" default="#session.currentWeekNumber#">
<cfif IsDefined("url.week") AND url.week GT "">
	<cfif url.week EQ "all">
		<cfset variables.activeWeek = -1>
	<cfelse>
		<cfset variables.activeWeek = url.week>
	</cfif>	
</cfif>

<cfquery name="qryGetWeekNumberList" datasource="#application.dsn#">
	SELECT DISTINCT
		weekNumber
	  , startDate
	  , endDate
	  , weekType
	FROM
		FootballSeason
	ORDER BY
		weekNumber	
</cfquery>
<cfset variables.weekNumberList = valueList(qryGetWeekNumberList.weekNumber)>

<body>
	<cfoutput>
	<!--- get user information --->
	<cfinvoke component="#application.appmap#.cfc.login" method="getUserInfo" returnvariable="variables.qryGetUserInfo">
		<cfinvokeargument name="userID" value="#variables.currentUserID#">
	</cfinvoke>	
	
	<!--- get all the games of the current week --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getGamesOfTheWeek" returnvariable="variables.qryGetGamesOfTheWeek">
		<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
	</cfinvoke>
	<!--- get the user's picks for that week --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicksOfTheWeek">
		<cfinvokeargument name="userID" value="#variables.currentUserID#">
		<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
	</cfinvoke>
		
    <div class="container" id="mainContainer">
	<h3 class="offset1">My Season<cfif variables.currentUserID NEQ session.user.userID> - #variables.qryGetUserInfo.userFullName#</cfif></h3>
	
    <div class="pagination pagination-centered">
		<ul>
			<li class="disabled"><a href="##">Week</a></li>
	    	<cfloop list="#variables.weekNumberList#" index="i">
		    <li<cfif variables.activeWeek EQ i> class="active"</cfif>><a href="?week=#i#&userid=#variables.currentUserID#">#i#</a></li>
			</cfloop>
			<li class="disabled"><a href="?week=all&userid=#variables.currentUserID#">Overall</a></li>
	    </ul>
    </div>
	
    	<div class="row">
    		<div class="span8 offset2">
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
						<th colspan="9">My Picks<cfif variables.activeWeek NEQ -1> For Week #variables.activeWeek#</cfif></th>
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
						<th>My Pick</th>
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
						<tr>
							<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
							<td>#variables.qryGetGamesOfTheWeek.team1Name#</td>
							<td>#variables.qryGetGamesOfTheWeek.team1FinalScore#</td>
							<td>@</td>
							<td>#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
							<td>#variables.qryGetGamesOfTheWeek.team2Name#</td>
							<td><cfif variables.qryGetGamesOfTheWeek.team2Spread GT 0>+</cfif>#numberFormat(variables.qryGetGamesOfTheWeek.team2Spread,"999.9")#</td>
							<td><cfif qryCheckCurrentUserPick.teamID  EQ variables.qryGetGamesOfTheWeek.teamID1>#variables.qryGetGamesOfTheWeek.team1Name#<cfelse>#variables.qryGetGamesOfTheWeek.team2Name#</cfif></td>
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
					</cfloop>

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
		
    	<cfif variables.activeWeek NEQ -1>
		<div class="row">
    		<div class="span8 offset2">
		    	<table class="table table-striped table-hover">
		    	<thead>
		    		<tr>
						<th colspan="9">All Games For Week #variables.activeWeek#</th>
					</tr>
				</thead>
		    	<thead>
		    		<tr>
						<th>Game Date</th>
						<th>Visiting</th>
						<th>Score</th>
						<th>Result</th>
						<th></th>
						<th>Score</th>
						<th>Home</th>
						<th>Spread</th>
						<th>Result</th>
					</tr>
				</thead>		
				<tbody>
					<cfif variables.qryGetGamesOfTheWeek.recordCount>
					<cfloop query="variables.qryGetGamesOfTheWeek">
						<tr>
							<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
							<td>#variables.qryGetGamesOfTheWeek.team1Name#</td>
							<td>#variables.qryGetGamesOfTheWeek.team1FinalScore#</td>
							<td>
							<cfswitch expression="#trim(variables.qryGetGamesOfTheWeek.team1WinLoss)#">
								<cfcase value="W"><span class="label label-success">win</span></cfcase>
								<cfcase value="L"><span class="label label-important">loss</span></cfcase>
								<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
								<cfcase value="P"><span class="label label-info">pending</span></cfcase>
							</cfswitch>
							</td>
							<td>@</td>
							<td>#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
							<td>#variables.qryGetGamesOfTheWeek.team2Name#</td>
							<td><cfif variables.qryGetGamesOfTheWeek.team2Spread GT 0>+</cfif>#numberFormat(variables.qryGetGamesOfTheWeek.team2Spread,"999.9")#</td>
							<td>
							<cfswitch expression="#trim(variables.qryGetGamesOfTheWeek.team2WinLoss)#">
								<cfcase value="W"><span class="label label-success">win</span></cfcase>
								<cfcase value="L"><span class="label label-important">loss</span></cfcase>
								<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
								<cfcase value="P"><span class="label label-info">pending</span></cfcase>
							</cfswitch>
							</td>
						</tr>
					</cfloop>
					<cfelse>
						<tr><td colspan="9">No games found.</td></tr>
					</cfif>
				</tbody>
				</table>	
			</div>
		</div>
		</cfif>
	</cfoutput>
		
	<cfinclude template="footer.cfm">
    </div> <!-- /container -->

  </body>
    