<cfcomponent output="false" >

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
	
	<cffunction name="deleteUserPicksByWeekNumber" returntype="void">
		<cfargument name="userID" type="numeric" required="true" >
		<cfargument name="weekNumber" type="numeric" required="true" >
		<cfargument name="picksLocked" type="string" default="-1" >
		

		<cfquery name="qryDeleteUserPicks" datasource="#application.dsn#">
			DELETE FROM UserPicks
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
			AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">
			<cfif arguments.picksLocked NEQ -1>
			AND userPickID NOT IN (#arguments.picksLocked#)
			</cfif>				
		</cfquery>

		<!--- unlock the games if no other user has them picked --->
		<cfquery name="qryUnlockGameIDs" datasource="#application.dsn#">
			UPDATE FootballGames
			SET spreadLock = 0
			WHERE gameID NOT IN 
				(SELECT 
					gameID 
				FROM UserPicks 
				WHERE gameID IN (#arguments.picksLocked#) 
					AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">)
			AND weekNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.weekNumber#">;
		</cfquery>
			
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
				<cfif qryGetUserCurrentRecord.winLoss EQ "W"><cfset variables.resultStct.recordW = qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "L"><cfset variables.resultStct.recordL = qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "T"><cfset variables.resultStct.recordT = qryGetUserCurrentRecord.record></cfif>
				<cfif qryGetUserCurrentRecord.winLoss EQ "P"><cfset variables.resultStct.recordP = qryGetUserCurrentRecord.record></cfif>
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
				,win char(1)
				,loss char(1)
				,tie char(1)
				,pending char(1)
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
				,win char(1)
				,loss char(1)
				,tie char(1)
				,pending char(1)
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


</cfcomponent>