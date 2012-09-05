<cfparam name="session.xmlfeed" default="">
<cfsetting showdebugoutput="true" />

<cftry>
	<cfif session.xmlfeed EQ "">
	Getting new xml feed<br><br>
		<cfhttp url="#application.rssFeed.gamesOdds#" method="GET" result="dataFeed">
		<cfset session.xmlFeed = xmlParse(dataFeed.fileContent)>
	</cfif>
	<cfset variables.xmlFeed = session.xmlfeed>

	<!--- get the weeknumber --->
	<cfset variables.weekNumber = 1>

	<!--- log the date into database --->
	<cfquery name="qryInsertLogDate" datasource="#application.dsn#">
		INSERT INTO
		ncaa_football.RssFeedLog
			(logDate, rssFeedName)
		VALUES
			(#now()#,'GamesOdds')	
	</cfquery>

	<!---<cfdump var="#variables.xmlFeed.pinnacle_line_feed.events.xmlChildren#">--->
	<cfset variables.gamesArray = variables.xmlFeed.pinnacle_line_feed.events.xmlChildren>
	<!--- if the xml string is valid, grab the rate and insert it to the database --->
	<cfif IsXmlDoc(variables.xmlFeed) AND NOT ArrayIsEmpty(variables.gamesArray)>
		<cfloop from="1" to="#arrayLen(variables.gamesArray)#" index="i">
		
				
				<!--- get the weeknumber --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeekNumber">
					<cfinvokeargument name="gameDate" value="#dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText)#">
				</cfinvoke>
				<cfset variables.weekNumber = variables.qryGetCurrentWeekNumber.weekNumber>
				
				<cfoutput>
				week #variables.weekNumber#<br>
				#dateFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#<br>
				#variables.gamesArray[i].gamenumber.xmlText#<br>
				#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#<br>
				#variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText#<br>
				#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#<br>
				#variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText#<br>
				#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#<br>
				<cfif StructKeyExists(variables.gamesArray[i].periods,"period")>#variables.gamesArray[i].periods.period.spread.spread_visiting.xmltext#<cfelse>0</cfif><br>
				<cfif StructKeyExists(variables.gamesArray[i].periods,"period")>#variables.gamesArray[i].periods.period.spread.spread_home.xmltext#<cfelse>0</cfif><br>
				</cfoutput>				
				
				<cfif StructKeyExists(variables.gamesArray[i].periods,"period")>
					<cfif variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText EQ "Visiting">
						<cfset variables.team1spread = variables.gamesArray[i].periods.period.spread.spread_visiting.xmltext>
					<cfelse>
						<cfset variables.team1spread = variables.gamesArray[i].periods.period.spread.spread_home.xmltext>
					</cfif>
					<cfif variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText EQ "Visiting">
						<cfset variables.team2spread = variables.gamesArray[i].periods.period.spread.spread_visiting.xmltext>
					<cfelse>
						<cfset variables.team2spread = variables.gamesArray[i].periods.period.spread.spread_home.xmltext>
					</cfif>
				<cfelse>
					<cfset variables.team1spread = 0>
					<cfset variables.team2spread = 0>
				</cfif>
				
				<!--- first, check to see if there is a team match in footballteams --->
				<!--- check team1name --->
				<cfquery datasource="#application.dsn#" name="qryCheckPinnacleFootBallTeam1">
					SELECT teamID
								  FROM FootballTeams
								  WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
				</cfquery>
				<cfif qryCheckPinnacleFootBallTeam1.recordCount EQ 0>
					<cfquery datasource="#application.dsn#" name="qryCheckEspnFootBallTeam1">
						SELECT teamID
								  FROM FootballTeams
								  WHERE espnTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
					</cfquery>
					<cfif qryCheckEspnFootBallTeam1.recordcount EQ 0>
						<cfquery datasource="#application.dsn#" name="qryInsertMisMatchedFootBallTeam1">
							INSERT INTO mismatchedPinnacleFootballTeams
						           (teamName)
						     VALUES
						           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">);
						</cfquery>
					<cfelse>
						<cfquery datasource="#application.dsn#" name="qryUpdateFootBallTeam1">	
							UPDATE FootballTeams
							SET pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
							WHERE espnTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">;
						</cfquery>
					</cfif>
				</cfif>	
				<!--- check team2name --->
				<cfquery datasource="#application.dsn#" name="qryCheckPinnacleFootBallTeam2">
					SELECT teamID
								  FROM FootballTeams
								  WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
				</cfquery>
				<cfif qryCheckPinnacleFootBallTeam2.recordCount EQ 0>
					<cfquery datasource="#application.dsn#" name="qryCheckEspnFootBallTeam2">
						SELECT teamID
								  FROM FootballTeams
								  WHERE espnTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
					</cfquery>
					<cfif qryCheckEspnFootBallTeam2.recordcount EQ 0>
						<cfquery datasource="#application.dsn#" name="qryInsertMisMatchedFootBallTeam2">
							INSERT INTO mismatchedPinnacleFootballTeams
						           (teamName)
						     VALUES
						           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">);
						</cfquery>
					<cfelse>
						<cfquery datasource="#application.dsn#" name="qryUpdateFootBallTeam2">	
							UPDATE FootballTeams
							SET pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
							WHERE espnTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">;
						</cfquery>
					</cfif>
				</cfif>	
				
				
				
				<!--- insert or update the games odds --->
				<cfquery datasource="#application.dsn#" name="qryCheckInsertOrUpdateGamesData">
					SELECT * 
					FROM FootballGames 
					WHERE team1Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
			 			AND team2Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
				</cfquery>
				<cfif qryCheckInsertOrUpdateGamesData.recordCount>
					<cfquery datasource="#application.dsn#" name="qryUpdateGamesData">
						UPDATE FootballGames
						   SET gameDate = '#dateFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"yyyy-mm-dd")# #timeFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"HH:mm:ss")#'
						      ,team1Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
						      ,team1Draw = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText)#">
						      ,team1Spread = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
						      ,team2Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
						      ,team2Draw = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText)#">
						      ,team2Spread = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">
						      ,dateUpdated = '#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#'
							  ,teamID1 = (SELECT teamID FROM FootballTeams WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">  LIMIT 0,1)
							  ,teamID2 = (SELECT teamID FROM FootballTeams WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">  LIMIT 0,1)
						 WHERE team1Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
						 		AND team2Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">;		

					</cfquery>
				<cfelse>
					<cfquery datasource="#application.dsn#" name="qryInsertGamesData">
						INSERT INTO FootballGames
					           (gameDate
							   ,dateCreated
					           ,WeekNumber
					           ,team1Name
					           ,team1Draw
					           ,team1Spread
					           ,team2Name
					           ,team2Draw
					           ,team2Spread
							   ,teamID1
							   ,teamID2)
					     VALUES
					           ('#dateFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"yyyy-mm-dd")# #timeFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"HH:mm:ss")#'
					           ,'#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#'
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.weekNumber#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText)#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText)#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">
							   ,(SELECT teamID FROM FootballTeams WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText)#">  LIMIT 0,1)
							   ,(SELECT teamID FROM FootballTeams WHERE pinnacleTeamName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText)#">  LIMIT 0,1));
					</cfquery>
				</cfif>	

		</cfloop>
		
			
	</cfif>
	
	<cfcatch type="any">
		ERROR WITH THE GAMES ODDS RSS FEED!!<br><br><br>
		<cfrethrow>
		<cfabort>
	</cfcatch>
</cftry>

<br><br>completed!
