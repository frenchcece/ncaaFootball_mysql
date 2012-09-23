<!--- check if today is the day after the college football schedule week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
	<cfinvokeargument name="gameDate" value="#dateAdd('d',-1,session.today)#">
</cfinvoke>
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getWeekInfoByWeekNumber" returnvariable="variables.qryGetWeekInfo">
	<cfinvokeargument name="weekNumber" value="#variables.qryGetCurrentWeek.weekNumber#" />
</cfinvoke>

<cfif IsDefined("url.weekNumber") AND url.weekNumber GT "">
	<cfset variables.qryGetCurrentWeek.weekNumber = url.weekNumber>
</cfif>

<!--- today is the day after! --->
<cfif DateDiff('h', dateAdd('d',1,variables.qryGetWeekInfo.endDate), session.today) GT 0 AND DateDiff('h', dateAdd('d',1,variables.qryGetWeekInfo.endDate), session.today) LT 24>

	<!--- log the date into database --->
	<cfquery name="qryInsertLogDate" datasource="#application.dsn#">
		INSERT INTO
		ncaa_football.RssFeedLog
			(logDate, rssFeedName)
		VALUES
			(#now()#,'ForfeitGames')	
	</cfquery>

	<!--- get the list of league's players --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryGetLeaguePlayers"></cfinvoke>

	<cfloop query="variables.qryGetLeaguePlayers">
		<!--- get the user's picks for that week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicks">
			<cfinvokeargument name="userID" value="#variables.qryGetLeaguePlayers.userID#">
			<cfinvokeargument name="weekNumber" value="#variables.qryGetCurrentWeek.weekNumber#">
		</cfinvoke>
	
		<!--- if the user has not met the minimum required picks, then we need to add some forfeit games to his week --->
		<cfif variables.qryGetUserPicks.recordCount LT application.settings.minimumPicksPerWeek>
			<cfset variables.iteration = application.settings.minimumPicksPerWeek - variables.qryGetUserPicks.recordCount>
			<cfloop from="1" to="#variables.iteration#" index="i">
				<cfquery datasource="#application.dsn#" name="qryInsertForfeitGame">
					INSERT INTO UserPicks
					(
						 gameID
						,teamID
						,userID
						,weekNumber
						,winLoss
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="-999">
			           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="-1">
			           ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.qryGetLeaguePlayers.userID#">
					   ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.qryGetCurrentWeek.weekNumber#">
					   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="L">
					);
				</cfquery>	
				<cfoutput>Insert Forfeit Game no#i# for userID #variables.qryGetLeaguePlayers.userID# and week #variables.qryGetCurrentWeek.weekNumber#<br></cfoutput>
			</cfloop>
		</cfif>
	</cfloop>
</cfif> 