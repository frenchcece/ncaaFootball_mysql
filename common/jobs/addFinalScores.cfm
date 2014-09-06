<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="#application.appmap#/header.cfm">

<cfparam name="local.weekNumber" default="">
<cfif IsDefined("Form.weekNumber") AND Form.weekNumber GT "">
	<cfset local.weekNumber = trim(Form.weekNumber)>
</cfif>
<cfparam name="local.gameID" default="">
<cfif IsDefined("Form.gameID") AND Form.gameID GT "">
	<cfset local.gameID = trim(Form.gameID)>
</cfif>
<cfparam name="local.team1score" default="">
<cfif IsDefined("Form.team1score") AND Form.team1score GT "">
	<cfset local.team1score = trim(Form.team1score)>
</cfif>
<cfparam name="local.team2score" default="">
<cfif IsDefined("Form.team2score") AND Form.team2score GT "">
	<cfset local.team2score = trim(Form.team2score)>
</cfif>
<!--- <cfparam name="" default="">
<cfif IsDefined("") AND  GT "">
	<cfset local. = trim(Form.)>
</cfif> --->

<cfquery name="qryGetWeekNumberList" datasource="#application.dsn#">
	SELECT DISTINCT
		weekNumber
	  , weekName	
	  , startDate
	  , endDate
	  , weekType
	FROM
		FootballSeason
	WHERE season = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.currentSeasonYear#">	
	ORDER BY
		weekNumber	
</cfquery>

<cfoutput>
<p>
<form name="weekForm" method="post" action="">
	<div>
		<label>Week Number: </label>
		<select name="weekNUmber">
			 <cfloop query="qryGetWeekNumberList">
				<option value="#qryGetWeekNumberList.weekNumber#"<cfif local.weekNumber EQ qryGetWeekNumberList.weekNumber> selected="true"</cfif>>Week #qryGetWeekNumberList.weekName#</option>
			</cfloop>	
		</select>
	</div>
	<div>
	<input type="submit" id="weekSubmit" value="Submit">
	</div>
</form>
</p>	

<cfif local.weekNumber GT "">
	<cfset qryGetGamesOfTheWeek = footballDaoObj.getGamesOfTheWeek(local.weekNumber)>
	<cfif qryGetGamesOfTheWeek.recordCount>
	<p>
	<form name="gameForm" method="post" action="">
		<div>
		<select name="gameID">
			<cfloop query="qryGetGamesOfTheWeek">
				<option value="#qryGetGamesOfTheWeek.gameID#"<cfif local.gameID EQ qryGetGamesOfTheWeek.gameID> selected="true"</cfif>>#qryGetGamesOfTheWeek.team1Name# vs #qryGetGamesOfTheWeek.team2Name#</option>
			</cfloop>
		</select>
		</div>
		<div>
		<label>Team 1 score:</label><input type="text" name="team1score" value="#local.team1score#">
		</div>
		<div>
		<label>Team 2 score:</label><input type="text" name="team2score" value="#local.team2score#">
		</div>
		<div>
		<input type="submit" id="gameSubmit" value="Submit">
		</div>
	</form>
	</p>
	<cfelse>
	<p>No games this week</p>
	</cfif>
</cfif>
</cfoutput>

<cfif local.gameID GT "" AND local.team1score GT "" AND local.team2score GT "">
	<!--- get the game info --->
	<cfquery name="qryGetGameInfo" datasource="#application.dsn#">
		SELECT 
			* 
		FROM 
			ncaa_football.FootballGames 
		WHERE 
			gameID = #local.gameID#;
	</cfquery>

		<!--- insert all the final scores into GamesFinalScores, just in case we need the historical data --->
		<cfquery name="qryCheckGamesFinalScores" datasource="#application.dsn#">
			SELECT * 
			FROM GamesFinalScores 
			WHERE team1Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team1Name#">
 			AND team2Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team2Name#">
			AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.seasonYear#">
		</cfquery>
		<cfif qryCheckGamesFinalScores.recordCount EQ 0>
			<cfquery name="qryInsertGamesFinalScores" datasource="#application.dsn#">
					INSERT INTO GamesFinalScores
			           (team1Name
			           ,team1Score
			           ,team2Name
			           ,team2Score
					   ,scoreDate
					   ,season)
				     VALUES
				           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team1Name#">
				           ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.team1score#">
				           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team2Name#">
				           ,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.team2score#">
						   ,<cfqueryparam cfsqltype="cf_sql_date"  value="#now()#">
						   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#application.seasonYear#">);
			</cfquery>
		<cfelse>
			<cfquery name="qryInsertGamesFinalScores" datasource="#application.dsn#">
				UPDATE GamesFinalScores
				SET team1Score = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.team1score#">
		           ,team2Score = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.team2score#">
				WHERE team1Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team1Name#">
	 			AND team2Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetGameInfo.team2Name#">
				AND season = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.seasonYear#">
			</cfquery>
		</cfif>
		
		<!--- update the scores for each team in table footballgames --->
		<cfquery name="qryCheckFinalScores" datasource="#application.dsn#">
			SELECT * FROM FootballGames WHERE team1FinalScore IS NULL OR team2FinalScore IS NULL AND gameDate > '#application.seasonYear#-08-01'
		</cfquery><cfdump var="#qryCheckFinalScores#">
		<cfif qryCheckFinalScores.recordCount>
		<cfquery name="qryUpdateFinalScores" datasource="#application.dsn#">
			UPDATE FootballGames fg, FootballTeams ft1, FootballTeams ft2
			SET fg.team1FinalScore = CASE WHEN teamID1 = ft1.teamID THEN #local.team1score# ELSE #local.team2score# END 
			, fg.team2FinalScore = CASE WHEN teamID2 = ft2.teamID THEN #local.team2score# ELSE #local.team1score# END
			WHERE (ft1.pinnacleteamname = fg.team1name OR ft1.pinnacleteamname = fg.team2name)
			AND (ft2.pinnacleteamname = fg.team2name OR ft2.pinnacleteamname = fg.team1name)
			AND ft1.espnteamname = '#qryGetGameInfo.team2Name#'
			AND ft2.espnteamname = '#qryGetGameInfo.team2Name#';
		</cfquery>
		<!--- now update whether the teams have won or lost their game --->
		<cfquery name="qryUpdateFinalScores" datasource="#application.dsn#">
				UPDATE FootballGames fg, FootballTeams ft1, FootballTeams ft2
					SET fg.team1WinLoss = CASE WHEN team1FinalScore + team1Spread > team2FinalScore THEN 'W' WHEN team1FinalScore + team1Spread = team2FinalScore THEN 'T' ELSE 'L' END
					  , fg.team2WinLoss = CASE WHEN team2FinalScore + team2Spread > team1FinalScore THEN 'W' WHEN team2FinalScore + team2Spread = team1FinalScore THEN 'T' ELSE 'L' END
				WHERE (ft1.pinnacleteamname = fg.team1name OR ft1.pinnacleteamname = fg.team2name)
				AND	(ft2.pinnacleteamname = fg.team2name OR ft2.pinnacleteamname = fg.team1name)
				AND ft1.espnteamname = '#qryGetGameInfo.team1Name#'
				AND ft2.espnteamname = '#qryGetGameInfo.team2Name#'; 
		</cfquery>
		</cfif>
		<!--- update the users picks win or loss --->
		<cfquery name="qryUpdateUsersPicks" datasource="#application.dsn#">
			UPDATE 	UserPicks up, FootballGames fg, FootballTeams ft1, FootballTeams ft2
			SET		up.winLoss = CASE  WHEN up.teamID = fg.teamID1 THEN fg.team1WinLoss
			      					WHEN up.teamID = fg.teamID2 THEN fg.team2WinLoss END
			WHERE fg.gameID = up.gameID AND (up.teamID = fg.teamID1 OR up.teamID = fg.teamID2)
			AND (ft1.pinnacleteamname = fg.team1name OR ft1.pinnacleteamname = fg.team2name)
			AND (ft2.pinnacleteamname = fg.team2name OR ft2.pinnacleteamname = fg.team1name)
			AND ft1.espnteamname = '#qryGetGameInfo.team1Name#'
			AND ft2.espnteamname = '#qryGetGameInfo.team2Name#';
		</cfquery>

<p>DONE!</p>
</cfif>
