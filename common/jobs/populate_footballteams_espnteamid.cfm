<cfhttp url="http://espn.go.com/college-football/teams">
<cfset ncaaTeams = cfhttp.filecontent>
 
<cfscript>
jsoup = createObject("java", "org.jsoup.Jsoup");
doc = jsoup.parse(ncaaTeams);
content = doc.getElementsByClass("container");

//links = content.select("div.mod-content");
//links = content.getElementsByTag("tr");
//rank = content.getElementsByClass("team-rank");
links = content.select("a");
//prevrank = content.getElementsByClass("prev-rank");

</cfscript>
<link href="../../css/ncaa_logo.css" type="text/css" rel="stylesheet" />

<cfoutput>
<cfloop from="1" to="#arrayLen(links)#" index="i">
	<cfset link = links[i].attr("href") />
	<cfset idStr = FindNoCase("/id/",link) />
	<cfif idStr GT 0>
		<cfset teamid = ListGetAt(Mid(link,idStr+4,len(link)-idStr),1,"/")/>
		<cfset fullname = Replace(ListGetAt(Mid(link,idStr+4,len(link)-idStr),2,"/"),"-"," ","all") />
		<cfset nickname = ReReplaceNoCase(Trim(ReplaceNoCase(fullname,Trim(links[i].text()),"","all")),"\b(\w)","\u\1","all") />
	
		<cfif len(teamid) LTE 4>
			<cfquery name="qryGetTeamInfo" datasource="#application.dsn#">
				SELECT * FROM ncaa_football.FootballTeams WHERE espnTeamID = #teamid#;
			</cfquery>
			<cfif qryGetTeamInfo.recordCount EQ 1>
				<!--- EXISTS: #teamid# #links[i].text()# #nickname#<div class="logo logo-small logo-ncaa-small teamId-#trim(teamid)#"></div><br>-----<br>
				<cfquery name="qryUpdateTeamInfo" datasource="#application.dsn#">
					UPDATE ncaa_football.FootballTeams
						SET espnTeamID = #teamid#,
							espnTeamNickName = '#nickname#'
					WHERE teamID = 	#qryGetTeamInfo.teamID#	
				</cfquery> --->
			<cfelseif qryGetTeamInfo.recordCount GT 1>
				DUPLICATE?: #teamid# #links[i].text()# #nickname#<div class="logo logo-small logo-ncaa-small teamId-#trim(teamid)#"></div><br>-----<br>
			<cfelse>
				NEW?: #teamid# #links[i].text()# #nickname#<div class="logo logo-small logo-ncaa-small teamId-#trim(teamid)#"></div><br>-----<br>
				<cfquery name="qryInsertTeamInfo" datasource="#application.dsn#">
					INSERT INTO `ncaa_football`.`FootballTeams`
						(`espnTeamID`,
						`espnTeamName`,
						`espnTeamNickname`,
						`pinnacleTeamName`)
						VALUES
						(#teamid#,
						'#links[i].text()#',
						'#nickname#',
						'#links[i].text()#');
				</cfquery>
			</cfif>
		
		</cfif>
	</cfif>
	
</cfloop>
</cfoutput>
<!---<cfloop index="e" array="#links#">
<cfoutput>
	#e#<br>
<!---#e.attr("src")# --- Title: #e.attr("title")# --- Alt: #e.attr("alt")#<br/>--->
</cfoutput>
</cfloop>--->