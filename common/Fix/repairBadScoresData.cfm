<cfsetting showdebugoutput="true" requesttimeout="600000">

<cfquery name="qryMainData" datasource="#application.dsn#">
select
up.*,
fg.teamid1, fg.team1winloss, 
fg.teamid2, fg.team2winloss, fg.team1finalscore,fg.team2finalscore
,fs.team1score, fs.team2score, fg.team1Spread, fg.team2Spread
,ft1.espnteamname as espnteam1,ft2.espnteamname as espnteam2,fs.team1name,fs.team2name
,fg.gamedate,fs.scoredate
,case when (fg.team1finalscore != fs.team1score AND fg.team2finalscore != fs.team2score)
then case when (fg.team1finalscore != fs.team2score AND fg.team2finalscore != fs.team1score) then 'DIFFERENT' end end as scorecompare
from
ncaa_football.UserPicks up
inner join ncaa_football.FootballGames fg
on fg.gameid = up.gameid
inner join ncaa_football.FootballTeams as ft1
on fg.teamid1 = ft1.teamid
inner join ncaa_football.FootballTeams as ft2
on fg.teamid2 = ft2.teamid
left outer join ncaa_football.GamesFinalScores fs
on (DATE_FORMAT(fg.gamedate, '%c%d%Y') = DATE_FORMAT(fs.scoredate, '%c%d%Y')
OR DATE_FORMAT(DATE_ADD(fg.gamedate, INTERVAL 1 DAY), '%c%d%Y') = DATE_FORMAT(fs.scoredate, '%c%d%Y')
)
and ((ft1.espnteamname = fs.team1name and ft2.espnteamname = fs.team2name) 
	or (ft1.espnteamname = fs.team2name and ft2.espnteamname = fs.team1name))

where up.weeknumber between 16 and 31
and fs.scoredate is not null
and case when (fg.team1finalscore != fs.team1score AND fg.team2finalscore != fs.team2score)
then case when (fg.team1finalscore != fs.team2score AND fg.team2finalscore != fs.team1score) then 1 end end = 1
</cfquery>
<cfoutput>
<cfloop query="qryMainData">
	#qryMainData.gameid#<br>	
	<cfset updated = false />
	<!--- update the scores in footballGames --->
	<cfif trim(qryMainData.espnteam1) EQ trim(qryMainData.team1name)>
		then team1score is the new team1finalscore<br>
		<cfquery datasource="#application.dsn#" name="qryUpdateteam1finalscore1">
			UPDATE ncaa_football.FootballGames
			SET team1finalscore = #qryMainData.team1score#
			WHERE gameID = #qryMainData.gameid#
		</cfquery>
		<cfset updated = true />
	</cfif>
	<cfif trim(qryMainData.espnteam1) EQ trim(qryMainData.team2name)>
		then team2score is the new team1finalscore<br>
		<cfquery datasource="#application.dsn#" name="qryUpdateteam1finalscore2">
			UPDATE ncaa_football.FootballGames
			SET team1finalscore = #qryMainData.team2score#
			WHERE gameID = #qryMainData.gameid#
		</cfquery>
		<cfset updated = true />
	</cfif>
	<cfif trim(qryMainData.espnteam2) EQ trim(qryMainData.team1name)>
		then team1score is the new team2finalscore<br>
		<cfquery datasource="#application.dsn#" name="qryUpdateteam2finalscore1">
			UPDATE ncaa_football.FootballGames
			SET team2finalscore = #qryMainData.team1score#
			WHERE gameID = #qryMainData.gameid#
		</cfquery>
		<cfset updated = true />
	</cfif>
	<cfif trim(qryMainData.espnteam2) EQ trim(qryMainData.team2name)>
		then team2score is the new team2finalscore<br>
		<cfquery datasource="#application.dsn#" name="qryUpdateteam2finalscore2">
			UPDATE ncaa_football.FootballGames
			SET team2finalscore = #qryMainData.team2score#
			WHERE gameID = #qryMainData.gameid#
		</cfquery>
		<cfset updated = true />
	</cfif>

	<cfif updated>
		<!--- update the win/loss field --->
		<cfquery datasource="#application.dsn#" name="qryUpdateTeamWinLoss">
			UPDATE ncaa_football.FootballGames
			SET  team1WinLoss = CASE WHEN team1FinalScore + team1Spread > team2FinalScore THEN 'W' WHEN team1FinalScore + team1Spread = team2FinalScore THEN 'T' ELSE 'L' END
				,team2WinLoss = CASE WHEN team2FinalScore + team2Spread > team1FinalScore THEN 'W' WHEN team2FinalScore + team2Spread = team1FinalScore THEN 'T' ELSE 'L' END
			WHERE gameID = #qryMainData.gameid#
		</cfquery>
		updated the footballgame score<br>
		
		<!--- update user pick --->
		<cfquery name="qryUpdateUsersPicks" datasource="#application.dsn#">
			UPDATE 	UserPicks up, FootballGames fg
			SET		up.winLoss = CASE WHEN up.teamID = fg.teamID1 THEN fg.team1WinLoss
			      					  WHEN up.teamID = fg.teamID2 THEN fg.team2WinLoss END
			WHERE up.userPickID = #qryMainData.userPickID#
			AND up.gameID = fg.gameID
		</cfquery>
		updated the user pick<br>
	</cfif>	
	--------------------<br>
	<cfflush>
</cfloop>
</cfoutput>