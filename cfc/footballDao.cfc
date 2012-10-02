<cfcomponent output="false" >

	<cffunction name="getWeekInfoByWeekNumber" returntype="query">
		<cfargument name="weekNumber" type="numeric" required="true">

		<cfquery name="qryGetWeekInfo" datasource="#application.dsn#">
			SELECT 
			    startDate, endDate, weekType
			FROM
			    ncaa_football.FootballSeason
			WHERE
			    weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">;
		</cfquery>

		<cfreturn qryGetWeekInfo>	
	</cffunction>

	<cffunction name="getGamesOfTheWeek" returntype="Query">
		<cfargument name="weekNumber" type="numeric" default="-1">
		
		<cfquery datasource="#application.dsn#" name="qryGetGamesOfTheWeek">
			SELECT
				gameID
			  , gameDate
			  , datecreated
			  , dateupdated
			  , WeekNumber
			  , team1Name
			  , teamID1
			  , team1Draw
			  , team1Spread
			  , team2Name
			  , teamID2
			  , team2Draw
			  , team2Spread
			  , team1FinalScore
			  , team2FinalScore
			  , team1WinLoss
			  , team2WinLoss
			  , spreadLock
			FROM
				FootballGames
			WHERE
				1 = 1	
			<cfif arguments.weekNumber GT 0>
				AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			</cfif>
			ORDER BY
				gameDate ASC
		</cfquery>
		
		<cfreturn qryGetGamesOfTheWeek>
	</cffunction>

	<cffunction name="selectLeaguePlayers" returntype="query">

		<cfquery name="qrySelectLeaguePlayers" datasource="#application.dsn#">
			SELECT
				isActive,
				isAdmin,
				userEmail,
				userFullName,
				userID,
				userName,
				userPassword
			FROM 
				Users
			WHERE
				isActive = 1	
			ORDER BY 
				userFullName;
		</cfquery>

		<cfreturn qrySelectLeaguePlayers>
	</cffunction>

	<cffunction name="selectUserPicksByWeekNumber" returntype="query">
		<cfargument name="userID" type="numeric" required="true" >
		<cfargument name="weekNumber" type="numeric" default="-1" >

		<cfquery name="qrySelectUserPicks" datasource="#application.dsn#">
			SELECT
				userPickID
			  , userID
			  , gameID
			  , teamID
			  , coalesce(winLoss,'P') AS winLoss
			  , weekNumber
			FROM
				UserPicks
			WHERE 
				userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
				<cfif arguments.weekNumber NEQ -1>
				AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
				</cfif>		
		</cfquery>

		<cfreturn qrySelectUserPicks>
	</cffunction>

	<cffunction name="checkUserPicks" returntype="string">
		<cfargument name="gameID" type="numeric" required="true" >
		
		<cfset var local.retStr = "">
		
		<cfquery datasource="#application.dsn#" name="qryCheckGameTime">
			select 
				CONCAT(team1Name,' @ ',team2Name) AS gameDesc, 
				gameDate 
			FROM FootballGames 
			WHERE gameID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.gameID#">;
		</cfquery>

		<cfif qryCheckGameTime.recordCount AND DateDiff('n',now(),qryCheckGameTime.gameDate) LTE 0>
			<cfset local.retStr = "The game " & qryCheckGameTime.gameDesc & " has already started and is no longer elligible. Your pick was not saved.">
		</cfif>
		
		<cfreturn local.retStr>
	</cffunction>
	
	<cffunction name="deleteUserPicksByWeekNumber" returntype="void">
		<cfargument name="userID" type="numeric" required="true" >
		<cfargument name="weekNumber" type="numeric" required="true" >
		<cfargument name="picksLocked" type="string" default="-1" >

		<!--- get the current list of user picks to be used when updating the spreadlock field in table footballgames --->		
		<cfset variables.qryGetCurrentUserPicks = selectUserPicksByWeekNumber(#arguments.userID#,#arguments.weekNumber#)>

		<!--- delete all the user picks --->
		<cfquery name="qryDeleteUserPicks" datasource="#application.dsn#">
			DELETE FROM UserPicks
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
			AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			<cfif arguments.picksLocked NEQ -1>
			AND userPickID NOT IN (#arguments.picksLocked#)
			</cfif>				
		</cfquery>

		<!--- unlock the games spread if no other user has them picked --->
		<cfif variables.qryGetCurrentUserPicks.recordCount>
			<cfquery name="qryUnlockGameIDs" datasource="#application.dsn#">
				UPDATE FootballGames
					SET spreadLock = 0
				WHERE 
					gameID IN (#valueList(variables.qryGetCurrentUserPicks.gameID,",")#)
					AND gameID NOT IN 
					(
					SELECT 
						gameID 
					FROM UserPicks 
					WHERE gameID IN (#valueList(variables.qryGetCurrentUserPicks.gameID,",")#)
						OR userPickID IN (#arguments.picksLocked#) 
					);
			</cfquery>
		</cfif>
			
		<cfreturn>
	</cffunction>
	
	<cffunction name="insertUserPicks" returntype="void">
		<cfargument name="userID" type="numeric" required="true" >
		<cfargument name="gameID" type="numeric" required="true" >
		<cfargument name="teamID" type="numeric" required="true" >
		<cfargument name="weekNumber" type="numeric" required="true" >
		
		<cfquery name="qryInsertUserPicks" datasource="#application.dsn#">
			INSERT INTO UserPicks
	           (userID
	           ,gameID
	           ,teamID
			   ,weekNumber)
	    	 VALUES
	           (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
	           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.gameID#">
	           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.teamID#">
			   ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">)
		</cfquery>

		<!--- lock the game so that the odds are not updated anymore --->
		<cfquery name="qryLockGameID" datasource="#application.dsn#">
			UPDATE FootballGames
				SET spreadLock = 1
			WHERE gameID = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.gameID#">
		</cfquery>

		<cfreturn>
	</cffunction>

	<cffunction name="getCurrentWeekNumber" returntype="query" >
		<cfargument name="gameDate" type="date" required="true" />
	
		<cfquery name="qryGetCurrentWeek" datasource="#application.dsn#">
			SELECT
				weekNumber
			  , startDate
			  , endDate
			  , weekType
			FROM
				FootballSeason
			WHERE
				<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.gameDate#"> BETWEEN startdate AND enddate
		</cfquery>
		
		<!--- if the input date is not in the date range, then pick the next week --->
		<cfif qryGetCurrentWeek.recordCount EQ 0>
			<cfquery name="qryGetCurrentWeek" datasource="#application.dsn#">
				SELECT
					weekNumber
				  , startDate
				  , endDate
				  , weekType
				FROM
				FootballSeason AS fs
				WHERE
				weekNumber = (
							   SELECT MAX(weekNumber) + 1 AS weekNumber
							   FROM
								FootballSeason
							   WHERE
								<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.gameDate#"> > endDate
							 )			 		
			</cfquery>
		</cfif>
				 
		<cfreturn qryGetCurrentWeek>
	</cffunction>

	<cffunction name="getResultsByUser" returntype="Query" >
		<cfargument name="userID" type="numeric" default="-1">
		
		<cfquery name="qryGetResults" datasource="#application.dsn#">
			SELECT
				COUNT(*) AS record
			  , coalesce(winLoss,'P') AS winLoss
			  , userID
			  , weeknumber
			FROM
				UserPicks
			WHERE
				1 = 1
				<cfif arguments.userID NEQ -1>
				AND userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
				</cfif>
			GROUP BY
				winLoss
			  , weeknumber
			  , userID
			ORDER BY
				userID
				, winLoss DESC	
		</cfquery>
		
		<cfreturn qryGetResults>
	</cffunction>
	
	<cffunction name="getProcessedResults" returntype="Struct" >
		<cfargument name="userID" type="numeric" default="-1">
		<cfargument name="weekNumber" type="numeric" default="-1">
		
		<!--- local vars --->
		<cfset var variables.resultStct = structNew()>
		<Cfset variables.resultStct.recordW = 0>
		<Cfset variables.resultStct.recordL = 0>
		<Cfset variables.resultStct.recordT = 0>
		<Cfset variables.resultStct.recordP = 0>
		
		<cfset qryGetResultsByUser = getResultsByUser(arguments.userID)>
		<cfif qryGetResultsByUser.recordCount>
			<!--- get the user's record for the current week --->
			<cfquery dbtype="query" name="qryGetUserCurrentRecord">
				SELECT
					  record
	  				, winLoss
				FROM 
					variables.qryGetResults
				WHERE
					1 = 1
					<cfif arguments.weekNumber NEQ -1>
					AND weeknumber = #arguments.weekNumber#
					</cfif>
				ORDER BY 
					winLoss DESC	
			</cfquery>
 
			<cfloop query="qryGetUserCurrentRecord">
				<cfif qryGetUserCurrentRecord.winLoss EQ "W"><cfset variables.resultStct.recordW = variables.resultStct.recordW  + qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "L"><cfset variables.resultStct.recordL = variables.resultStct.recordL + qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "T"><cfset variables.resultStct.recordT = variables.resultStct.recordT + qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "P"><cfset variables.resultStct.recordP = variables.resultStct.recordP + qryGetUserCurrentRecord.record></cfif>
			</cfloop>
		</cfif>
		
		<cfreturn variables.resultStct>
	</cffunction>
	
	<cffunction name="getStandings" returntype="Query" >
		<cfargument name="userID" type="numeric" default="-1">
		<cfargument name="weekNumber" type="numeric" default="-1">
		
		<cfquery name="qryGetStandings" datasource="#application.dsn#">
			CREATE TEMPORARY TABLE temp1
			(
				record int
				,winLoss char(1)
				,userID int
				,weekNumber int
			);

			CREATE TEMPORARY TABLE temp2
			(
				userID int
				,win int
				,loss int
				,tie int
				,pending int
			);

			INSERT INTO temp1
			SELECT
				COUNT(*) AS record
			  , coalesce(winLoss, 'P') AS winLoss
			  , userID
			  , weeknumber
			FROM
				UserPicks
			WHERE
				1 = 1
				<cfif arguments.userID NEQ -1>
				AND userid = #arguments.userID#
				</cfif>
				<cfif arguments.weekNumber NEQ -1>
				AND weekNumber = #arguments.weekNumber#
				</cfif>
			GROUP BY
				winLoss
			  , weeknumber
			  , userID;
						
						
			INSERT INTO temp2
			SELECT
				userID
			  , CASE WHEN winloss = 'W' THEN SUM(record)
					 ELSE 0
				END AS win
			  , CASE WHEN winloss = 'L' THEN SUM(record)
					 ELSE 0
				END AS loss
			  , CASE WHEN winloss = 'T' THEN SUM(record)
					 ELSE 0
				END AS tie
			  , CASE WHEN winloss = 'P' THEN SUM(record)
					 ELSE 0
				END AS pending
			FROM
				temp1
			GROUP BY
				winloss
			  , userID
			ORDER BY
				userID
			  , winLoss DESC;
				
				
				
			SELECT
				Users.userFullName
			  , t.userID
			  , SUM(win) AS win
			  , SUM(loss) AS loss
			  , SUM(tie) AS tie
			  , SUM(pending) AS pending
			  , SUM(win) + SUM(loss) + SUM(tie) AS totalGames
			  , CONVERT((SUM(win) + CASE WHEN SUM(tie) > 0
														  THEN SUM(tie) / 2.00
														  ELSE 0.00
													 END ) / ( SUM(win) + SUM(loss)
															   + SUM(tie) ) * 100, decimal(18,2))
			AS winPct
			FROM
				temp2 AS t
			LEFT OUTER JOIN Users
			ON	Users.userID = t.userID
			GROUP BY
				Users.userFullName
			  , t.userID
			ORDER BY
				8 DESC
			  , 3 DESC
			  , 7 ASC;
			
			DROP TABLE temp1;
			DROP TABLE temp2;	
		
		</cfquery>
	
		<cfreturn qryGetStandings>
	</cffunction>

	<cffunction name="getStandingsGroupByWeekNumber" returntype="Query" >
		<cfargument name="userID" type="numeric" default="-1">
		
		<cfquery name="qryGetStandingsGroupByWeekNumber" datasource="#application.dsn#">
			CREATE TEMPORARY TABLE temp1
			(
				record int
				,winLoss char(1)
				,userID int
				,weekNumber int
			);

			CREATE TEMPORARY TABLE temp2
			(
				userID int
				,weekNumber int
				,win int
				,loss int
				,tie int
				,pending int
			);

			INSERT INTO temp1
			SELECT
				COUNT(*) AS record
			  , coalesce(winLoss, 'P') AS winLoss
			  , userID
			  , weeknumber
			FROM
				UserPicks
			WHERE
				1 = 1
				<cfif arguments.userID NEQ -1>
				AND userid = #arguments.userID#
				</cfif>
			GROUP BY
				winLoss
			  , weeknumber
			  , userID;
			
			INSERT INTO temp2
			SELECT
				userID
			  , weeknumber
			  , CASE WHEN winloss = 'W' THEN SUM(record)
					 ELSE 0
				END AS win
			  , CASE WHEN winloss = 'L' THEN SUM(record)
					 ELSE 0
				END AS loss
			  , CASE WHEN winloss = 'T' THEN SUM(record)
					 ELSE 0
				END AS tie
			  , CASE WHEN winloss = 'P' THEN SUM(record)
					 ELSE 0
				END AS pending
			FROM
				temp1
			GROUP BY
				winloss
			  , userID
			  , weeknumber
			ORDER BY
				userID
			  , weeknumber
			  , winLoss DESC;
			  
			  
			SELECT
				Users.userFullName
			  , t.userID
			  , t.weekNumber
			  , SUM(win) AS win
			  , SUM(loss) AS loss
			  , SUM(tie) AS tie
			  , SUM(pending) AS pending
			  , SUM(win) + SUM(loss) + SUM(tie) AS totalGames
			  , CONVERT(( SUM(win) + CASE WHEN SUM(tie) > 0
														  THEN SUM(tie) / 2.00
														  ELSE 0.00
													 END ) / ( SUM(win) + SUM(loss)
															   + SUM(tie) ) * 100, decimal(18,2)) AS winPct
			FROM
				temp2 AS t
			LEFT OUTER JOIN Users
			ON	Users.userID = t.userID
			GROUP BY
				Users.userFullName
			  , t.userID
			  , t.weekNumber
			ORDER BY
				weekNumber;
			  
			  
			DROP TABLE temp1;
			DROP TABLE temp2;		
		</cfquery>
	
		<cfreturn qryGetStandingsGroupByWeekNumber>
	</cffunction>
	
	<cffunction name="calculateWinPct" returntype="Numeric">
		<cfargument name="winLossQuery" type="query" required="true">
		
		<cfset var local.win = 0>
		<cfset var local.loss = 0>
		<cfset var local.tie = 0>
		<cfset var local.pending = 0>
		<cfset var local.winPct = 0>
	
		<cfloop query="arguments.winLossQuery">
			<cfswitch expression="#trim(arguments.winLossQuery.winLoss)#">
				<cfcase value="W">
					<cfset local.win = arguments.winLossQuery.record>
				</cfcase>
				<cfcase value="L">
					<cfset local.loss = arguments.winLossQuery.record>
				</cfcase>
				<cfcase value="T">
					<cfset local.tie = arguments.winLossQuery.record>
				</cfcase>
				<cfcase value="P">
					<cfset local.pending = arguments.winLossQuery.record>
				</cfcase>
			</cfswitch>	
		</cfloop>

		<cfset local.winPct = local.win>
		<cfif local.tie GT 0>
			<cfset local.winPct = local.winPct + (local.tie / 2.00)>
		</cfif>
		<cfset local.winPct = local.winPct / (local.win + local.loss + local.tie) * 100>

		<cfreturn numberFormat(local.winPct,"999.99")>
	</cffunction>
	
	<cffunction name="getTeamStats" access="remote" returntype="Query">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfquery datasource="#application.dsn#" name="qryGetTeamStats">
			select 
			    fg.weeknumber,
			    'Away' AS location,
			    ft1.teamID AS teamID,
			    fg.team1name AS teamName,
			    fg.team1spread AS teamSpread,
			    fg.team1winloss AS resultAgainstSpread,
			    CASE
			        WHEN fg.team1finalscore > fg.team2finalscore THEN 'W'
			        WHEN fg.team2finalscore > fg.team1finalscore THEN 'L'
			        WHEN fg.team2finalscore = fg.team1finalscore THEN 'T'
			        ELSE 'P'
			    END AS resultNoSpread,
			    fg.team1finalscore AS teamScore,
			    fg.team2name AS oponent,
			    fg.team2finalscore AS oponentScore
			from
			    FootballGames as fg
			        inner join
			    FootballTeams as ft1 ON fg.teamID1 = ft1.teamID
			where
			    ft1.teamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.teamID#">
			union all select 
			    fg.weeknumber,
			    'Home' AS location,
			    ft2.teamID AS teamID,
			    fg.team2name AS teamName,
			    fg.team2spread AS teamSpread,
			    fg.team2winloss AS resultAgainstSpread,
			    CASE
			        WHEN fg.team1finalscore > fg.team2finalscore THEN 'L'
			        WHEN fg.team2finalscore > fg.team1finalscore THEN 'W'
			        WHEN fg.team2finalscore = fg.team1finalscore THEN 'T'
			        ELSE 'P'
			    END AS resultNoSpread,
			    fg.team2finalscore AS teamScore,
			    fg.team1name AS oponent,
			    fg.team1finalscore AS oponentScore
			from
			    FootballGames as fg
			        inner join
			    FootballTeams as ft2 ON fg.teamID2 = ft2.teamID
			where
			    ft2.teamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.teamID#">
			order by weeknumber;		
		</cfquery>
		
		<cfreturn qryGetTeamStats>
	</cffunction>

	<cffunction name="getTeamStatsJsonFormat" access="remote" returntype="string">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfset variables.qryTeamStats = getTeamStats(arguments.teamID)>
		
		<cfreturn SerializeJSON(variables.qryTeamStats,false)>
	</cffunction>

	<cffunction name="getTeamStatsHtmlTable" access="remote" returntype="String" output="true">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfset variables.qryTeamStats = getTeamStats(arguments.teamID)>
	
		<cfsavecontent variable="local.htmlTable">
			<cfoutput>
			<table class='table table-striped table-hover table-condensed'>
				<thead><tr><th>Week</th><th>Location</th><th>Team</th><th>Score</th><th>Opponent</th><th>Score</th><th>Team<br>Spread</th><th>Against<br>Spread</th><th>No<br>Spread</th></tr></thead>
				<tbody>
				<cfloop query="variables.qryTeamStats">
				<tr>
					<td>#variables.qryTeamStats.weekNumber#</td>
					<td>#variables.qryTeamStats.location#</td>
					<td nowrap="nowrap"><strong>#variables.qryTeamStats.teamName#</strong></td>
					<td>#variables.qryTeamStats.teamScore#</td>
					<td nowrap="nowrap">#variables.qryTeamStats.oponent#</td>
					<td>#variables.qryTeamStats.oponentScore#</td>
					<td>#variables.qryTeamStats.teamSpread#</td>
					<cfswitch expression="#variables.qryTeamStats.resultAgainstSpread#">
						<cfcase value="W"><td><span class='label label-success'>win</span></td></cfcase>
						<cfcase value="L"><td><span class='label label-important'>loss</span></td></cfcase>
						<cfcase value="T"><td><span class='label label-inverse'>tie</span></td></cfcase>
						<cfcase value="P"><td><span class='label label-info'>pending</span></td></cfcase>
					</cfswitch>	
					<cfswitch expression="#variables.qryTeamStats.resultNoSpread#">
						<cfcase value="W"><td><span class='label label-success'>win</span></td></cfcase>
						<cfcase value="L"><td><span class='label label-important'>loss</span></td></cfcase>
						<cfcase value="T"><td><span class='label label-inverse'>tie</span></td></cfcase>
						<cfcase value="P"><td><span class='label label-info'>pending</span></td></cfcase>
					</cfswitch>
				</tr>
				</cfloop>	
			</table>
			</cfoutput>				
		</cfsavecontent>
	
		<cfreturn local.htmlTable>
	</cffunction>



	<cffunction name="sendEmail" access="public" returntype="void">
		<cfargument name="emailTo" type="string" required="true">
		<cfargument name="emailSubject" type="string" required="true">
		<cfargument name="emailMsg" type="string" required="true">
	
		<cfmail 
		from="#application.emailFrom#" 
			to="#arguments.emailTo#" 
				subject="#arguments.emailSubject#"  useTLS="true" type="html">
			#arguments.emailMsg#
		</cfmail>
	
		<cfreturn>
	</cffunction>

</cfcomponent>