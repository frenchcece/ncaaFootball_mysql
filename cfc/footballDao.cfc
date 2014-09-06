<cfcomponent output="false" >

	<cffunction name="validateSeasonYear" returntype="numeric">
		<cfargument name="seasonYear" required="true" type="numeric">
		
		<cfset var returnYear = arguments.seasonYear>
		
		<cfquery name="qryCheckSeasonYear" datasource="#application.dsn#">
			SELECT
				weekNumber
			  , weekName	
			  , startDate
			  , endDate
			  , weekType
			  , season
			FROM
				FootballSeason
			WHERE
				season = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.seasonYear#">;
		</cfquery>
		
		<!--- if nothing is found, then get the year before --->
		<cfif NOT qryCheckSeasonYear.recordCount>
			<cfset returnYear = arguments.seasonYear - 1>
		</cfif>
		
		<cfreturn returnYear>
	</cffunction>

	<cffunction name="getWeekInfoByWeekNumber" returntype="query">
		<cfargument name="weekNumber" type="numeric" required="true">

		<cfquery name="qryGetWeekInfo" datasource="#application.dsn#">
			SELECT 
			    startDate, endDate, weekType, weekNumber, weekName
			FROM
			    FootballSeason
			WHERE
			    weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			    AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">;
		</cfquery>

		<cfreturn qryGetWeekInfo>	
	</cffunction>

	<cffunction name="getGamesOfTheWeek" returntype="Query">
		<cfargument name="weekNumber" type="numeric" default="-1">
		
		<cfquery datasource="#application.dsn#" name="qryGetGamesOfTheWeek">
			SELECT
				fg.gameID
			  , fg.gameDate
			  , fg.datecreated
			  , fg.dateupdated
			  , fg.WeekNumber
			  , fg.team1Name
			  , ft1.espnTeamID AS logoID1
			  , ft1.espnTeamNickName AS teamNickname1
			  , at1.rank AS team1Rank
			  , at1.prevRank AS team1PrevRank
			  , fg.teamID1
			  , fg.team1Draw
			  , fg.team1Spread
			  , fg.team2Name
			  , ft2.espnTeamID AS logoID2
			  , ft2.espnTeamNickName AS teamNickname2
			  , at2.rank AS team2Rank
			  , at2.prevRank AS team2PrevRank
			  , fg.teamID2
			  , fg.team2Draw
			  , fg.team2Spread
			  , fg.team1FinalScore
			  , fg.team2FinalScore
			  , fg.team1WinLoss
			  , fg.team2WinLoss
			  , fg.spreadLock
			  , fs.weekType
			  , fs.weekName
			FROM
				FootballGames AS fg
			INNER JOIN 	
				FootballSeason AS fs
				ON fs.weekNumber = fg.weekNumber
			INNER JOIN
				FootballTeams AS ft1
				ON ft1.teamID = fg.teamID1
			INNER JOIN
				FootballTeams AS ft2
				ON ft2.teamID = fg.teamID2
			LEFT OUTER JOIN
				ApTop25Ranking AS at1
				ON at1.weekName = fs.weekName
				AND at1.season = fs.season
				AND at1.espnTeamID = ft1.espnTeamID	
			LEFT OUTER JOIN
				ApTop25Ranking AS at2
				ON at2.weekName = fs.weekName
				AND at2.season = fs.season
				AND at2.espnTeamID = ft2.espnTeamID	
			WHERE
				fs.season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">	
			<cfif arguments.weekNumber GT 0>
				AND fg.weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			</cfif>
			ORDER BY
				fg.gameDate ASC
		</cfquery>
		
		<cfreturn qryGetGamesOfTheWeek>
	</cffunction>

	<cffunction name="getGamesOfTheWeekWithUsersPicks" returntype="Query">
		<cfargument name="weekNumber" type="numeric" default="-1">
		
		<cfquery datasource="#application.dsn#" name="qryGetGamesOfTheWeekWithUsersPicks">
			SELECT
				fg.gameID
			  , fg.gameDate
			  , fg.datecreated
			  , fg.dateupdated
			  , fg.WeekNumber
			  , fg.team1Name
			  , ft1.espnTeamID AS logoID1
			  , ft1.espnTeamNickName AS teamNickname1
			  , at1.rank AS team1Rank
			  , at1.prevRank AS team1PrevRank
			  , fg.teamID1
			  , fg.team1Draw
			  , fg.team1Spread
			  , fg.team2Name
			  , ft2.espnTeamID AS logoID2
			  , ft2.espnTeamNickName AS teamNickname2
			  , at2.rank AS team2Rank
			  , at2.prevRank AS team2PrevRank
			  , fg.teamID2
			  , fg.team2Draw
			  , fg.team2Spread
			  , fg.team1FinalScore
			  , fg.team2FinalScore
			  , fg.team1WinLoss
			  , fg.team2WinLoss
			  , fg.spreadLock
			  , fs.weekType
			  , fs.weekName
			  , u.userFullName
			  , u.userID
			  , ft3.pinnacleTeamName AS userPickedTeamName
			  , up.winLoss
			FROM
				FootballGames AS fg
			INNER JOIN 	
				FootballSeason AS fs
				ON fs.weekNumber = fg.weekNumber
			INNER JOIN
				FootballTeams AS ft1
				ON ft1.teamID = fg.teamID1
			INNER JOIN
				FootballTeams AS ft2
				ON ft2.teamID = fg.teamID2
			LEFT OUTER JOIN
				ApTop25Ranking AS at1
				ON at1.weekName = fs.weekName
				AND at1.season = fs.season
				AND at1.espnTeamID = ft1.espnTeamID	
			LEFT OUTER JOIN
				ApTop25Ranking AS at2
				ON at2.weekName = fs.weekName
				AND at2.season = fs.season
				AND at2.espnTeamID = ft2.espnTeamID	
			LEFT OUTER JOIN UserPicks AS up
				ON up.gameID = fg.gameID
			LEFT OUTER JOIN Users AS u
				ON u.userID = up.userID
			LEFT OUTER JOIN FootballTeams AS ft3
				ON ft3.teamID = up.teamID
			WHERE
				fs.season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">	
			<cfif arguments.weekNumber GT 0>
				AND fg.weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			</cfif>
			ORDER BY
				fg.gameID ASC
		</cfquery>
		
		<cfreturn qryGetGamesOfTheWeekWithUsersPicks>
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
				userPassword,
				sendAccountInfoEmail
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
				up.userPickID
			  , up.userID
			  , up.gameID
			  , up.teamID
			  , coalesce(up.winLoss,'P') AS winLoss
			  , up.weekNumber
			FROM
				UserPicks AS up
				INNER JOIN FootballSeason AS fs ON up.weekNumber = fs.weekNumber
			WHERE 
				fs.season = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.currentSeasonYear#">
				AND up.userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
				<cfif arguments.weekNumber NEQ -1>
				AND up.weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
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
			  , weekName	
			  , startDate
			  , endDate
			  , weekType
			  , season
			FROM
				FootballSeason
			WHERE
				<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.gameDate#"> BETWEEN startdate AND enddate
				AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">;
		</cfquery>
		
		<!--- if the input date is not in the date range, then pick the next week --->
		<cfif qryGetCurrentWeek.recordCount EQ 0>
			<cfquery name="qryGetCurrentWeek" datasource="#application.dsn#">
				SELECT
					weekNumber
				  , weekName	
				  , startDate
				  , endDate
				  , weekType
				  , season
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
					AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">;
			</cfquery>
		</cfif>

		<!--- if nothing is found then return the first week of the season --->
		<cfif qryGetCurrentWeek.recordCount EQ 0>
			<cfquery name="qryGetCurrentWeek" datasource="#application.dsn#">
				SELECT
					weekNumber
				  , weekName	
				  , startDate
				  , endDate
				  , weekType
				  , season
				FROM
					FootballSeason AS fs
				WHERE
					weekName = '1'
					AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">;
			</cfquery>
		</cfif>
		
		<!--- if nothing is still found, then get the last week entered in table FootballSeason --->
				 
		<cfreturn qryGetCurrentWeek>
	</cffunction>

	<cffunction name="calculateMininumNumberBowlsToPick" returntype="query">
		<cfargument name="weekNumber" type="numeric" required="true">
		
		<cfquery name="qryCalculateMininumNumberBowlsToPick" datasource="#application.dsn#">
			SELECT 
			    count(*) as totalNumberBowlGames,
				round(count(*) * <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.settings.minimumPercentForBowls#"> / 100) as mininumBowlsToPick
			FROM
			    ncaa_football.FootballGames
			WHERE
			    weeknumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#"> 
			    AND team1Spread <> 0 
			    AND team2Spread <> 0
				AND teamID1 > 0
				AND teamID2 > 0;
		</cfquery>
		
		<cfreturn qryCalculateMininumNumberBowlsToPick>
	</cffunction>

	<cffunction name="getResultsByUser" returntype="Query" >
		<cfargument name="userID" type="numeric" default="-1">
		
		<cfquery name="qryGetResults" datasource="#application.dsn#">
			SELECT
				COUNT(*) AS record
			  , coalesce(up.winLoss,'P') AS winLoss
			  , up.userID
			  , up.weeknumber
			FROM
				UserPicks AS up
				INNER JOIN FootballSeason AS fs ON up.weekNumber = fs.weekNumber
			WHERE
				fs.season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">
				<cfif arguments.userID NEQ -1>
				AND up.userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
				</cfif>
			GROUP BY
				up.winLoss
			  , up.weeknumber
			  , up.userID
			ORDER BY
				up.userID
			  	, up.weeknumber
				, up.winLoss DESC	
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
			  , coalesce(up.winLoss, 'P') AS winLoss
			  , up.userID
			  , up.weeknumber
			FROM
				Users AS u
				INNER JOIN UserPicks AS up ON u.userID = up.UserID
				INNER JOIN FootballSeason AS fs ON up.weekNumber = fs.weekNumber
			WHERE
				fs.season = #session.currentSeasonYear#
				<cfif arguments.userID NEQ -1>
				AND up.userid = #arguments.userID#
				</cfif>
				<cfif arguments.weekNumber NEQ -1>
				AND up.weekNumber = #arguments.weekNumber#
				</cfif>
			GROUP BY
				up.winLoss
			  , up.weeknumber
			  , up.userID;
						
						
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
			  , Users.userID
			  , SUM(win) AS win
			  , SUM(loss) AS loss
			  , SUM(tie) AS tie
			  , COALESCE(SUM(pending), 0) AS pending
			  , SUM(win) + SUM(loss) + SUM(tie) AS totalGames
			  , SUM(win) + SUM(loss) + SUM(tie) + SUM(pending) AS totalPickedGames
			  , COALESCE(CONVERT((SUM(win)) / ( SUM(win) + SUM(loss)) * 100, decimal(18,2)), 0) AS winPct
			FROM
				Users
			LEFT OUTER JOIN temp2 AS t
				ON	Users.userID = t.userID
			WHERE
				Users.isActive = 1			
			GROUP BY
				Users.userFullName
			  , Users.userID
			ORDER BY
				9 DESC
			  , 3 DESC
			  , 8 DESC
			  , 1 ASC;

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
			  , coalesce(up.winLoss, 'P') AS winLoss
			  , up.userID
			  , up.weeknumber
			FROM
				Users AS u
				INNER JOIN UserPicks AS up ON u.userID = up.UserID
				INNER JOIN FootballSeason AS fs ON up.weekNumber = fs.weekNumber
			WHERE
				fs.season = #session.currentSeasonYear#
				<cfif arguments.userID NEQ -1>
				AND up.userid = #arguments.userID#
				</cfif>
			GROUP BY
				up.winLoss
			  , up.weeknumber
			  , up.userID;
			
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
			  , Users.userID
			  , t.weekNumber
			  , fs.weekName
			  , SUM(win) AS win
			  , SUM(loss) AS loss
			  , SUM(tie) AS tie
			  , COALESCE(SUM(pending), 0) AS pending
			  , SUM(win) + SUM(loss) + SUM(tie) AS totalGames
			  , SUM(win) + SUM(loss) + SUM(tie) + SUM(pending) AS totalPickedGames
			  , COALESCE(CONVERT(( SUM(win)) / ( SUM(win) + SUM(loss)) * 100, decimal(18,2)), 0) AS winPct
			FROM
				Users
			LEFT OUTER JOIN temp2 AS t
				ON	Users.userID = t.userID
			LEFT OUTER JOIN FootballSeason AS fs
				ON fs.weekNumber = t.weekNumber
				AND fs.season = #session.currentSeasonYear#	
			WHERE
				Users.isActive = 1	
			GROUP BY
				Users.userFullName
			  , Users.userID
			  , t.weekNumber
			ORDER BY
				Users.userID
			  , t.weekNumber;
			  
			  
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
				<!--- <cfcase value="T">
					<cfset local.tie = arguments.winLossQuery.record>
				</cfcase> --->
				<cfcase value="P">
					<cfset local.pending = arguments.winLossQuery.record>
				</cfcase>
			</cfswitch>	
		</cfloop>

		<cfset local.winPct = local.win>
		<!--- <cfif local.tie GT 0>
			<cfset local.winPct = local.winPct + (local.tie / 2.00)>
		</cfif> --->
		<cfif (local.win + local.loss + local.tie) GT 0>
			<cfset local.winPct = local.winPct / (local.win + local.loss + local.tie) * 100>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn numberFormat(local.winPct,"999.99")>
	</cffunction>
	
	<cffunction name="getTeamStats" access="remote" returntype="Query">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfquery datasource="#application.dsn#" name="qryGetTeamStats">
			select 
			    fg.weeknumber,
			    fs.weekName,
			    'Away' AS location,
			    ft1.teamID AS teamID,
			    ft1.espnTeamID AS logoID,
			    ft1.espnTeamNickName AS teamNickname,
			    fg.team1name AS teamName,
			    at1.rank AS teamRank,
			    fg.team1spread AS teamSpread,
			    fg.team1winloss AS resultAgainstSpread,
			    CASE
			        WHEN fg.team1finalscore > fg.team2finalscore THEN 'W'
			        WHEN fg.team2finalscore > fg.team1finalscore THEN 'L'
			        WHEN fg.team2finalscore = fg.team1finalscore THEN 'T'
			    END AS resultNoSpread,
			    fg.team1finalscore AS teamScore,
			    fg.team2name AS oponent,
			    at2.rank AS oponentRank,
			    fg.team2finalscore AS oponentScore
			from
			    FootballGames as fg
			        INNER JOIN
			    FootballTeams as ft1 ON fg.teamID1 = ft1.teamID
			    	INNER JOIN
			    FootballTeams as ft2 ON fg.teamID2 = ft2.teamID
				    INNER JOIN
			    FootballSeason as fs ON fs.weekNumber = fg.weekNumber
					LEFT OUTER JOIN
				ApTop25Ranking AS at1
						ON at1.weekName = fs.weekName
						AND at1.season = fs.season
						AND at1.espnTeamID = ft1.espnTeamID	
			    	LEFT OUTER JOIN
				ApTop25Ranking AS at2
						ON at2.weekName = fs.weekName
						AND at2.season = fs.season
						AND at2.espnTeamID = ft2.espnTeamID	
			where
				fs.season = #session.currentSeasonYear#
			    AND ft1.teamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.teamID#">
			    AND fg.team1finalscore IS NOT NULL AND fg.team2finalscore IS NOT NULL
			union all 
			select 
			    fg.weeknumber,
			    fs.weekName,
			    'Home' AS location,
			    ft2.teamID AS teamID,
			    ft2.espnTeamID AS logoID,
			    ft2.espnTeamNickName AS teamNickname,
			    fg.team2name AS teamName,
			    at2.rank AS teamRank,
			    fg.team2spread AS teamSpread,
			    fg.team2winloss AS resultAgainstSpread,
			    CASE
			        WHEN fg.team1finalscore > fg.team2finalscore THEN 'L'
			        WHEN fg.team2finalscore > fg.team1finalscore THEN 'W'
			        WHEN fg.team2finalscore = fg.team1finalscore THEN 'T'
			    END AS resultNoSpread,
			    fg.team2finalscore AS teamScore,
			    fg.team1name AS oponent,
			    at1.rank AS oponentRank,
			    fg.team1finalscore AS oponentScore
			from
			    FootballGames as fg
			        INNER JOIN
			    FootballTeams as ft1 ON fg.teamID1 = ft1.teamID
			    	INNER JOIN
			    FootballTeams as ft2 ON fg.teamID2 = ft2.teamID
				    INNER JOIN
			    FootballSeason as fs ON fs.weekNumber = fg.weekNumber
					LEFT OUTER JOIN
				ApTop25Ranking AS at1
						ON at1.weekName = fs.weekName
						AND at1.season = fs.season
						AND at1.espnTeamID = ft1.espnTeamID	
			    	LEFT OUTER JOIN
				ApTop25Ranking AS at2
						ON at2.weekName = fs.weekName
						AND at2.season = fs.season
						AND at2.espnTeamID = ft2.espnTeamID	
			where
			    fs.season = #session.currentSeasonYear#	
			    AND ft2.teamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.teamID#">
			    AND fg.team1finalscore IS NOT NULL AND fg.team2finalscore IS NOT NULL
			order by weeknumber;		
		</cfquery>
		
		<cfreturn qryGetTeamStats>
	</cffunction>

	<cffunction name="getTeamStatsJsonFormat" access="remote" returntype="string">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfset variables.qryTeamStats = getTeamStats(arguments.teamID)>
		
		<cfreturn SerializeJSON(variables.qryTeamStats,false)>
	</cffunction>

	<cffunction name="getTeamStatsHtmlTable" access="remote" returntype="string" output="false">
		<cfargument name="teamID" type="numeric" required="true">
		
		<cfset variables.qryTeamStats = getTeamStats(arguments.teamID)>
		<cfif variables.qryTeamStats.recordCount>
			<cfset variables.qryTeamRankings = getTeamApTop25Ranking(variables.qryTeamStats.logoID, session.currentWeekNumber, session.currentSeasonYear)>
		</cfif>
		
		<cfsavecontent variable="local.htmlTable">
			<cfif variables.qryTeamStats.recordCount>
			<cfoutput>
				<ul id='myTab' class='nav nav-tabs'>
					<li class='active'><a href='##week' data-toggle='tab'>Week Results</a></li>
					<li class=''><a href='##ranking' data-toggle='tab'>Rankings</a></li>
	            </ul>
	            <div id='myTabContent' class='tab-content'>
					<div class='tab-pane fade active in' id='week'>
			  			<table class='table table-striped table-hover table-condensed'>
							<thead><tr><th>Week</th><th>Location</th><th>Team</th><th>Score</th><th>Opponent</th><th>Score</th><th>Team<br>Spread</th><th>Against<br>Spread</th><th>No<br>Spread</th></tr></thead>
							<tbody>
							<cfloop query='variables.qryTeamStats'>
							<tr>
								<td>#variables.qryTeamStats.weekName#</td>
								<td>#variables.qryTeamStats.location#</td>
								<td nowrap='nowrap'><strong>#variables.qryTeamStats.teamName#</strong><cfif variables.qryTeamStats.teamRank GT 0> (#variables.qryTeamStats.teamRank#)</cfif></td>
								<td>#variables.qryTeamStats.teamScore#</td>
								<td nowrap='nowrap'>#variables.qryTeamStats.oponent#<cfif variables.qryTeamStats.oponentRank GT 0> (#variables.qryTeamStats.oponentRank#)</cfif></td>
								<td>#variables.qryTeamStats.oponentScore#</td>
								<td><cfif variables.qryTeamStats.teamSpread GT 0>+</cfif>#variables.qryTeamStats.teamSpread#</td>
								<cfswitch expression='#variables.qryTeamStats.resultAgainstSpread#'>
									<cfcase value='W'><td><span class='label label-success'>win</span></td></cfcase>
									<cfcase value='L'><td><span class='label label-important'>loss</span></td></cfcase>
									<cfcase value='T'><td><span class='label label-inverse'>tie</span></td></cfcase>
									<cfcase value='P'><td><span class='label label-info'>pending</span></td></cfcase>
								</cfswitch>	
								<cfswitch expression='#variables.qryTeamStats.resultNoSpread#'>
									<cfcase value='W'><td><span class='label label-success'>win</span></td></cfcase>
									<cfcase value='L'><td><span class='label label-important'>loss</span></td></cfcase>
									<cfcase value='T'><td><span class='label label-inverse'>tie</span></td></cfcase>
									<cfcase value='P'><td><span class='label label-info'>pending</span></td></cfcase>
								</cfswitch>
							</tr>
							</cfloop>
							</tbody>	
						</table>
					</div>
					<div class='tab-pane fade' id='ranking'>
			  			<table class='table table-striped table-hover table-condensed'>
							<thead><tr><th>Week</th><th>Team</th><th>Rank</th><th>Prev Rank</th><th>Trending</th></tr></thead>
							<tbody>
							<cfloop query='variables.qryTeamRankings'>
							<tr>
								<td>#variables.qryTeamRankings.weekName#</td>
								<td nowrap='nowrap'>#variables.qryTeamStats.teamName#</td>
								<td align='center' style='color:red'><strong>#variables.qryTeamRankings.rank#</strong></td>
								<td align='center'>#variables.qryTeamRankings.prevRank#</td>
								<td align='center'>
									<cfif variables.qryTeamRankings.trend GT 0>
										<div class='rising'></div>&nbsp;#variables.qryTeamRankings.trend#
									<cfelseif variables.qryTeamRankings.trend LT 0>	
										<div class='falling'></div>&nbsp;#abs(variables.qryTeamRankings.trend)#
									<cfelseif variables.qryTeamRankings.trend EQ 0>
										<div style='margin-left: 15px;'>---</div>
									</cfif>
								</td>
							</tr>
							</cfloop>
							</tbody>	
						</table>
					</div>
				</div>

			</cfoutput>
			<cfelse>
			No Record Found.			
			</cfif>
		</cfsavecontent>
	
		<cfreturn HTMLEditFormat(local.htmlTable)>
	</cffunction>

	<cffunction name="getTeamApTop25Ranking" access="remote" returntype="query">
		<cfargument name="espnTeamID" type="numeric" required="true">
		<cfargument name="weekNumber" type="string" required="true">
		<cfargument name="season" type="numeric" required="true">
		
		
		<cfquery name="getTeamRanking" datasource="#application.dsn#">
			SELECT
				fs.weekNumber, 
				fs.weekName,
				CASE WHEN ar.rank > 0 THEN ar.rank ELSE 'N/R' END AS rank, 
				CASE WHEN ar.prevRank > 0 THEN ar.prevRank ELSE 'N/R' END AS prevRank, 
				CASE WHEN ar.prevRank > 0 THEN ar.prevRank ELSE 26 END - CASE WHEN ar.rank > 0 THEN ar.rank ELSE 26 END AS trend,
				fs.Season
			FROM	
				ncaa_football.FootballSeason AS fs
				LEFT OUTER JOIN ncaa_football.ApTop25Ranking AS ar
					ON fs.season = ar.season and ar.weekname = fs.weekname and ar.espnteamid = #arguments.espnTeamID#
			WHERE
				1 = 1
				<cfif arguments.weekNumber GT "">
				AND fs.weekNumber <= #arguments.weekNumber#
				</cfif>	
				AND fs.season = #arguments.season#
			ORDER BY
				fs.season,
				fs.weekNumber	
		</cfquery>
		
		<cfreturn getTeamRanking>
	</cffunction>

	<cffunction name="getFinalRankingByYear" returntype="query" output="false">
	
		<cfquery name="qryGetFinalRankingByYear" datasource="#application.dsn#">
			CREATE TEMPORARY TABLE temp1
			(
				record int
				,winLoss char(1)
				,userID int
				,weekNumber int
				,season int
			);

			CREATE TEMPORARY TABLE temp2
			(
				userID int
				,season int
				,win int
				,loss int
				,tie int
				,pending int
			);

			INSERT INTO temp1
			SELECT
				COUNT(*) AS record
			  , coalesce(up.winLoss, 'P') AS winLoss
			  , up.userID
			  , up.weeknumber
			  , fs.season
			FROM
				Users AS u
				INNER JOIN UserPicks AS up ON u.userID = up.UserID
				INNER JOIN FootballSeason AS fs ON up.weekNumber = fs.weekNumber
			WHERE 
				fs.season IN (SELECT season FROM ncaa_football.FootballSeason WHERE weekName = 'Bowl' AND endDate < '#dateFormat(now(),"yyyy-mm-dd")#')
			GROUP BY
				fs.season
			  ,	up.winLoss
			  , up.weeknumber
			  , up.userID;
						
						
			INSERT INTO temp2
			SELECT
				userID
			  , season
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
			    userID
			  , season
			  , winloss
			ORDER BY
				userID
			  , season
			  , winLoss DESC;
				
				
				
			SELECT
				Users.userFullName
			  , t.userID
			  , t.season
			  , SUM(win) AS win
			  , SUM(loss) AS loss
			  , SUM(tie) AS tie
			  , SUM(pending) AS pending
			  , SUM(win) + SUM(loss) + SUM(tie) AS totalGames
			  , SUM(win) + SUM(loss) + SUM(tie) + SUM(pending) AS totalPickedGames
			  , CONVERT((SUM(win)) / ( SUM(win) + SUM(loss)) * 100, decimal(18,2)) AS winPct
			  , Users.isActive
			FROM
				temp2 AS t
			LEFT OUTER JOIN Users
			ON	Users.userID = t.userID
			GROUP BY
				Users.userFullName
			  , t.userID
			  , t.season
			ORDER BY
			    3 ASC
			  , 10 DESC
			  , 4 DESC
			  , 9 DESC;
			
			DROP TABLE temp1;
			DROP TABLE temp2;	
		</cfquery>
		
		<cfreturn qryGetFinalRankingByYear>	
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