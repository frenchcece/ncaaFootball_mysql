
<!--- NOTHING HAS BEEN DONE YET!! --->
<!--- all hte code below is coming from espngametime.cfm as example --->



<!--- check if today is the day after the college football schedule week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
	<cfinvokeargument name="gameDate" value="#now()#">
</cfinvoke>

<cfif IsDefined("url.weekName") AND url.weekName GT "">
	<cfset variables.qryGetCurrentWeek.weekName = url.weekName>
</cfif>

<cfif variables.qryGetCurrentWeek.weekName EQ "Bowl">
	<cfset variables.qryGetCurrentWeek.weekName = 16 />
</cfif>

<cfif IsDefined("url.season") AND url.season GT "">
	<cfset variables.qryGetCurrentWeek.season = url.season>
</cfif>

<cfhttp url="http://scores.espn.go.com/ncf/scoreboard?seasonYear=#variables.qryGetCurrentWeek.season#&seasonType=2&weekNumber=#variables.qryGetCurrentWeek.weekName#">
<cfset ncaaTeams = cfhttp.filecontent>
 
<cfscript>
jsoup = createObject("java", "org.jsoup.Jsoup");
doc = jsoup.parse(ncaaTeams);
content = doc.getElementById("content");

//links = content.select("div.mod-content");
//links = content.getElementsByTag("tr");
table = content.getElementsByClass("tablehead");
rows = table.select("tr");
</cfscript>

<!---<cfdump var="#rows#">--->
<cfset gamedate = "" />
<cfloop index="e" array="#rows#">
<cfoutput>
	<cfset mydate = e.getElementsByClass("stathead").select("td").text() & ", #variables.qryGetCurrentWeek.season#">
    <cfif IsDate(mydate)>
        <cfset gamedate = DateFormat(mydate,"mm/dd/yyyy") />
    </cfif>
   
    <cfset gametime = e.getElementsByTag("td")[1].text() />

    <cfif IsDate(gametime)>
        1: <cfif IsDate(gamedate)>#gameDate#</cfif><br>
	    <cfset gamedatetime = dateFormat(gameDate,"yyyy-mm-dd") & " " & timeFormat(DateAdd("h",-1,gametime),"HH:mm:ss") />
        2: <cfif IsDate(gamedatetime)>#TimeFormat(DateAdd("h",-1,gametime),"hh:mm tt")# (CT)</cfif><br>
        3: <cfif IsArray(e.select("a")) AND arrayLen(e.select("a"))>
            <cfset link1 = e.select("a")[1].attr("href")/>
            <cfset idstr = FindNoCase("/id/", e.select("a")[1].attr("href"))/>
			<cfset espnTeamID1 = ListGetAt(Mid(link1,idStr+4,len(link1)-idStr),1,"/") />
            #espnTeamID1#
            </cfif><br>
        4: <cfif IsArray(e.select("a")) AND arrayLen(e.select("a"))>
            <cfset link2 = e.select("a")[2].attr("href")/>
            <cfset idstr = FindNoCase("/id/", e.select("a")[2].attr("href"))/>
			<cfset espnTeamID2 = ListGetAt(Mid(link2,idStr+4,len(link2)-idStr),1,"/")/>
            #espnTeamID2#
            </cfif><br>
		5:
			<cfquery name="qryGetTeamID1" datasource="#Application.dsn#">
				SELECT teamID, pinnacleTeamName FROM ncaa_football.FootballTeams WHERE espnTeamID = #espnTeamID1#;
			</cfquery>
			<cfquery name="qryGetTeamID2" datasource="#Application.dsn#">
				SELECT teamID, pinnacleTeamName FROM ncaa_football.FootballTeams WHERE espnTeamID = #espnTeamID2#;
			</cfquery>
			<cfquery name="qryGetGameInfo" datasource="#Application.dsn#">
				SELECT 
					gameID, gameDate 
				FROM 
					ncaa_football.FootballGames 
				WHERE 
					weeknumber = #variables.qryGetCurrentWeek.weekNumber#
				AND 
					(
						(
						teamID1 = #qryGetTeamID1.teamID#
						AND teamID2 = #qryGetTeamID2.teamID#
						) 
						OR 
						(
						teamID1 = #qryGetTeamID2.teamID#
						AND teamID2 = #qryGetTeamID1.teamID#
						)
					)
			</cfquery>
			#qryGetGameInfo.gameID#<br>
		6: #qryGetGameInfo.gameDate#<br>
		7: #qryGetTeamID1.pinnacleTeamName# vs #qryGetTeamID2.pinnacleTeamName#<br>
		8: #gamedatetime#<br>
		9: 
		<cfif IsDate(qryGetGameInfo.gameDate) AND IsDate(gamedatetime) AND DateDiff("m",qryGetGameInfo.gameDate,gamedatetime) AND qryGetGameInfo.gameID GT 0>
			<cfquery name="qryUpdateGameDate" datasource="#Application.dsn#">
				UPDATE
					ncaa_football.FootballGames
				SET
					gameDate = '#gamedatetime#'
				WHERE
					gameID = #qryGetGameInfo.gameID#
			</cfquery>
			updated gameID #qryGetGameInfo.gameID# with new game time #gamedatetime# <br>
		</cfif>
        <p>----------</p>
    </cfif>
   
</cfoutput>
</cfloop>


<!---<cfoutput>
<cfloop from="1" to="#arrayLen(rows)#" index="i">
    <cfset link = rows[i].attr("href") /><cfdump var="#link#">
    <cfset idStr = FindNoCase("/id/",link) />
    <cfif idStr GT 0>
    <cfset teamid = ListGetAt(Mid(link,idStr+4,len(link)-idStr),1,"/")/>
    <cfif len(teamid) LTE 4>
    #teamid# #rows[i].text()# #trim(teamid)#<br><br>
    </cfif>
    </cfif>
   
</cfloop>
</cfoutput>--->