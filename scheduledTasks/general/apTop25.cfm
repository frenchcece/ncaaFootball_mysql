<!---
download jsoup-1.7.3.jar from http://jsoup.org/download 
added jar file to C:\ColdFusion9\lib
restarted cf service
for railo: https://groups.google.com/forum/#!topic/railo/-LuhDXivLbg
http://stubertbear.wordpress.com/2010/01/25/custom-java-libraries-in-coldfusionrailo/
http://www.cfdan.com/posts/Railo_3__Adding_Java_CFX_Tags.cfm
--->

<!--- check if today is the day after the college football schedule week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
	<cfinvokeargument name="gameDate" value="#dateAdd('d',1,now())#">
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

<cfset espnurl = "http://espn.go.com/college-football/rankings/_/poll/1/year/#variables.qryGetCurrentWeek.season#/week/#variables.qryGetCurrentWeek.weekName#">
<cfdump var="#espnurl#">

<cfhttp url="#espnurl#">
<cfset top25html = cfhttp.filecontent>

<cfscript>
jsoup = createObject("java", "org.jsoup.Jsoup");
doc = jsoup.parse(top25html);
content = doc.getElementById("my-teams-table");

//links = content.select("div.mod-content");
//links = content.getElementsByTag("tr");
rank = content.getElementsByClass("team-rank");
team = content.select("a");
prevrank = content.getElementsByClass("prev-rank");
</cfscript>

<cfquery name="qryCheckWeekRanking" datasource="#application.dsn#">
	SELECT 
		count(*) AS counter
	FROM 
		ncaa_football.ApTop25Ranking
	WHERE
		weekName = '#variables.qryGetCurrentWeek.weekName#'
		AND season = #variables.qryGetCurrentWeek.season#
</cfquery>
<cfdump var="#qryCheckWeekRanking#">

<cfif NOT qryCheckWeekRanking.counter>
<table>
	<tr>
		<td>AP Rank</td>
		<td>id</td>
		<td>Team</td>
		<td>Nickname</td>
		<td>Prev</td>
		<td>Trending</td>
		<td>Logo</td>
	</tr>
	<cfloop from="1" to="#arrayLen(rank)#" index="i">
		<cfset link = team[i].attr("href") />
		<cfset idStr = FindNoCase("/id/",link) />
		<cfset teamid = ListGetAt(Mid(link,idStr+4,len(link)-idStr),1,"/") />
		<cfset fullname = Replace(ListGetAt(Mid(link,idStr+4,len(link)-idStr),2,"/"),"-"," ","all") />
		<cfset nickname = ReReplaceNoCase(Trim(ReplaceNoCase(fullname,Trim(team[i].text()),"","all")),"\b(\w)","\u\1","all") />
		
		<cfquery name="qryInsertRanking" datasource="#application.dsn#">
			INSERT INTO ncaa_football.ApTop25Ranking
			(espnTeamID,
			prevRank,
			rank,
			season,
			weekName)
			VALUES
			(
			#trim(teamid)#,
			<cfif NOT IsNumeric(prevrank[i].text())>0<cfelse>#trim(prevrank[i].text())#</cfif>,
			#trim(rank[i].text())#,
			#variables.qryGetCurrentWeek.season#,
			'#variables.qryGetCurrentWeek.weekName#');
		</cfquery>
		
		<cfoutput>
		<tr>
			<td>#trim(rank[i].text())#</td>
			<td>#trim(teamid)#</td>
			<td>#trim(team[i].text())#</td>
			<td>#trim(nickname)#</td>
			<td>#trim(prevrank[i].text())#</td>
			<td>
				<cfif NOT IsNumeric(prevrank[i].text()) OR NOT IsNumeric(rank[i].text())>
				N/A	
				<cfelse>
				#trim(evaluate(Int(prevrank[i].text())-Int(rank[i].text())))#
				</cfif>
			</td>
			<td>
				<div class="logo logo-small logo-ncaa-small teamId-#trim(teamid)#"></div>
			</td>
		</tr>
		</cfoutput>
	</cfloop>
</table>

</cfif>





<!---	
<cfloop index="e" array="#links#">
<cfoutput>
	<br>
	#e.attr("a")#<br>
<!---#e.attr("src")# --- Title: #e.attr("title")# --- Alt: #e.attr("alt")#<br/>--->
</cfoutput>
</cfloop>--->
<!--- 
<link href="../../css/ncaa_logo.css" type="text/css" rel="stylesheet" />

<cfoutput>
<table>
	<tr>
		<td>AP Rank</td>
		<td>id</td>
		<td>Team</td>
		<td>Nickname</td>
		<td>Prev</td>
		<td>Trending</td>
		<td>Logo</td>
	</tr>
<cfloop from="1" to="#arrayLen(rank)#" index="i">
	<cfset link = team[i].attr("href") />
	<cfset idStr = FindNoCase("/id/",link) />
	<cfset teamid = ListGetAt(Mid(link,idStr+4,len(link)-idStr),1,"/") />
	<cfset fullname = Replace(ListGetAt(Mid(link,idStr+4,len(link)-idStr),2,"/"),"-"," ","all") />
	<cfset nickname = ReReplaceNoCase(Trim(ReplaceNoCase(fullname,Trim(team[i].text()),"","all")),"\b(\w)","\u\1","all") />
	
	<tr>
		<td>#trim(rank[i].text())#</td>
		<td>#trim(teamid)#</td>
		<td>#trim(team[i].text())#</td>
		<td>#trim(nickname)#</td>
		<td>#trim(prevrank[i].text())#</td>
		<td>
			<cfif NOT IsNumeric(prevrank[i].text()) OR NOT IsNumeric(rank[i].text())>
			N/A	
			<cfelse>
			#trim(evaluate(Int(prevrank[i].text())-Int(rank[i].text())))#
			</cfif>
		</td>
		<td>
			<div class="logo logo-small logo-ncaa-small teamId-#trim(teamid)#"></div>
		</td>
	</tr>
</cfloop>
</table>

</cfoutput> --->
