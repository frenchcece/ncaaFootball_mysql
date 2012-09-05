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
	<cfquery datasource="#application.dsn#" name="qrygetWeekNumber">
		SELECT MAX(WeekNumber) + 1 as maxWeekNumber
		FROM FootballGames
	</cfquery>
	<cfif qrygetWeekNumber.maxWeekNumber GT 0>
		<cfset variables.weekNumber = qrygetWeekNumber.maxWeekNumber>
	</cfif>

<!---<cfdump var="#variables.xmlFeed#">--->
	<!---<cfdump var="#variables.xmlFeed.pinnacle_line_feed.events.xmlChildren#">--->
	<cfset variables.gamesArray = variables.xmlFeed.bestlinesports_line_feed.xmlChildren>
	<cfdump var="#variables.gamesArray#">
	<!--- if the xml string is valid, grab the rate and insert it to the database --->
	<cfif IsXmlDoc(variables.xmlFeed) AND NOT ArrayIsEmpty(variables.gamesArray)>
		<cfloop from="1" to="#arrayLen(variables.gamesArray)#" index="i">
			<cfif(variables.gamesArray[i].sportType.xmlText EQ "Football" AND variables.gamesArray[i].league.xmlText EQ "NCAA Football")>
				
				<cfoutput>#dateFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#<br>
				#variables.gamesArray[i].participant[1].participant_name.xmlText#<br>
				#variables.gamesArray[i].participant[1].rotnum.xmlText#<br>
				#variables.gamesArray[i].participant[1].visiting_home_draw.xmlText#<br>
				#variables.gamesArray[i].participant[2].participant_name.xmlText#<br>
				#variables.gamesArray[i].participant[2].rotnum.xmlText#<br>
				#variables.gamesArray[i].participant[2].visiting_home_draw.xmlText#<br>
				#variables.gamesArray[i].participant[2].participant_name.xmlText#<br>
				<cfif StructKeyExists(variables.gamesArray[i],"period")>#variables.gamesArray[i].period.spread.spread_visiting.xmltext#<cfelse>0</cfif><br>
				<cfif StructKeyExists(variables.gamesArray[i],"period")>#variables.gamesArray[i].period.spread.spread_home.xmltext#<cfelse>0</cfif><br>
				</cfoutput>				
				
				<cfif StructKeyExists(variables.gamesArray[i],"period")>
					<cfif variables.gamesArray[i].participant[1].visiting_home_draw.xmlText EQ "Visiting">
						<cfset variables.team1spread = variables.gamesArray[i].period.spread.spread_visiting.xmltext>
					<cfelse>
						<cfset variables.team1spread = variables.gamesArray[i].period.spread.spread_home.xmltext>
					</cfif>
					<cfif variables.gamesArray[i].participant[2].visiting_home_draw.xmlText EQ "Visiting">
						<cfset variables.team2spread = variables.gamesArray[i].period.spread.spread_visiting.xmltext>
					<cfelse>
						<cfset variables.team2spread = variables.gamesArray[i].period.spread.spread_home.xmltext>
					</cfif>
				<cfelse>
					<cfset variables.team1spread = 0>
					<cfset variables.team2spread = 0>
				</cfif>
				
				<cfquery datasource="#application.dsn#" name="qryInsertUpdateGamesData">
					IF EXISTS (SELECT * 
								FROM footballgames 
								WHERE [team1Number] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[1].rotnum.xmlText#">
						 			AND [team2Number] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[2].rotnum.xmlText#">)
					BEGIN
						UPDATE [ncaa_football].[dbo].[FootballGames]
						   SET [gameDate] = '#dateFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#'
						      ,[team1Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[1].participant_name.xmlText#">
						      ,[team1Draw] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[1].visiting_home_draw.xmlText#">
						      ,[team1Spread] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
						      ,[team2Name] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[2].participant_name.xmlText#">
						      ,[team2Draw] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[2].visiting_home_draw.xmlText#">
						      ,[team2Spread] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">
						      ,[dateUpdated] = getDate()
						 WHERE [team1Number] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[1].rotnum.xmlText#">
						 	AND [team2Number] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[2].rotnum.xmlText#">		
					END
					ELSE
					BEGIN
						INSERT INTO [FootballGames]
					           ([gameDate]
							   ,[dateCreated]
					           ,[WeekNumber]
					           ,[team1Name]
					           ,[team1Number]
					           ,[team1Draw]
					           ,[team1Spread]
					           ,[team2Name]
					           ,[team2Number]
					           ,[team2Draw]
					           ,[team2Spread])
					     VALUES
					           ('#dateFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"mm/dd/yyyy")# #timeFormat(dateAdd('h',-4,variables.gamesArray[i].event_datetimeGMT.xmlText),"hh:mm tt")#'
					           ,getDate()
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.weekNumber#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[1].participant_name.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[1].rotnum.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[1].visiting_home_draw.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team1spread#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[2].participant_name.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.gamesArray[i].participant[2].rotnum.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.gamesArray[i].participant[2].visiting_home_draw.xmlText#">
					           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.team2spread#">)
					END
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
