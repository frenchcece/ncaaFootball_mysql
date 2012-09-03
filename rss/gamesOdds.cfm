<cfparam name="session.xmlfeed" default="">

<cftry>
	<cfif session.xmlfeed EQ "">
	Getting new xml feed<br><br>
		<cfhttp url="#application.rssFeed.gamesOdds#" method="GET" result="dataFeed">
		<cfset session.xmlFeed = xmlParse(dataFeed.fileContent)>
	</cfif>
	<cfset variables.xmlFeed = session.xmlfeed>

	<!--- get the weeknumber --->
	<cfset variables.weekNumber = 1>


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
				<cfquery datasource="#application.dsn#" name="qryCheckFootBallTeams">
					--check team1name
					IF NOT EXISTS (SELECT [teamID]
								  FROM [FootballTeams]
								  WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">)
					BEGIN
						IF NOT EXISTS(SELECT [teamID]
								  FROM [FootballTeams]
								  WHERE [espnTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">)
						BEGIN
							INSERT INTO [mismatchedPinnacleFootballTeams]
						           ([teamName])
						     VALUES
						           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">)
						END
						ELSE
						BEGIN
							UPDATE FootballTeams
							SET [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
							WHERE [espnTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
						END
					END
					
					--check team2name
					IF NOT EXISTS (SELECT [teamID]
								  FROM [FootballTeams]
								  WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">)
					BEGIN
						IF NOT EXISTS(SELECT [teamID]
								  FROM [FootballTeams]
								  WHERE [espnTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">)
						BEGIN
							INSERT INTO [mismatchedPinnacleFootballTeams]
						           ([teamName])
						     VALUES
						           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">)
						END
						ELSE
						BEGIN
							UPDATE FootballTeams
							SET [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">
							WHERE [espnTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">
						END
					END
				</cfquery>
				
				
				
				<!--- insert or update the games odds --->
				<cfquery datasource="#application.dsn#" name="qryInsertUpdateGamesData">
					IF EXISTS (SELECT * 
								FROM footballgames 
								WHERE [team1Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
						 			AND [team2Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">		
								)
					BEGIN
						UPDATE [ncaa_football].[dbo].[FootballGames]
						   SET [gameDate] = '#dateFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#'
						      ,[team1Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
						      ,[team1Draw] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText#">
						      ,[team1Spread] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
						      ,[team2Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">
						      ,[team2Draw] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText#">
						      ,[team2Spread] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">
						      ,[dateUpdated] = getDate()
							  ,teamID1 = (SELECT top 1 [teamID] FROM [FootballTeams] WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">)
							  ,teamID2 = (SELECT top 1 [teamID] FROM [FootballTeams] WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">)
						 WHERE [team1Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
						 		AND [team2Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">		

					END
					ELSE
					BEGIN
						INSERT INTO [FootballGames]
					           ([gameDate]
							   ,[dateCreated]
					           ,[WeekNumber]
					           ,[team1Name]
					           ,[team1Draw]
					           ,[team1Spread]
					           ,[team2Name]
					           ,[team2Draw]
					           ,[team2Spread]
							   ,teamID1
							   ,teamID2)
					     VALUES
					           ('#dateFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-5,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#'
					           ,getDate()
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.weekNumber#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].visiting_home_draw.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].visiting_home_draw.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">
							   ,(SELECT top 1 [teamID] FROM [FootballTeams] WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[1].participant_name.xmlText#">)
							   ,(SELECT top 1 [teamID] FROM [FootballTeams] WHERE [pinnacleTeamName] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participants.xmlChildren[2].participant_name.xmlText#">))
					END
				</cfquery>

		</cfloop>
		
			
	</cfif>
	
	<cfcatch type="any">
		ERROR WITH THE GAMES ODDS RSS FEED!!<br><br><br>
		<cfrethrow>
		<cfabort>
	</cfcatch>
</cftry>

<br><br>completed!
