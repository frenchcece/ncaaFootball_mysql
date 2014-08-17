<cfapplication 	
	name="ncaaFootball" 
	sessionmanagement="true" 
	sessiontimeout="#createTimeSpan(0,1,0,0)#" 
	clientmanagement="false" />
	
	
<!--- application vars --->
<cfset application.emailFrom = "frenchcece@gmail.com">	<!--- it doesn't matter.  gmail on railo seems to bypass this cfmail attribute --->
<cfset application.appmap = "/ncaaFootball" />
<cfset application.dsn = "ncaafootball">
<cfset application.rssFeed.gamesOdds = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=NCAA"><!--- http://livelines.betonline.com/sys/LineXML/LiveLineObjXml.asp?sport=Football ---><!--- http://www.collegefootballpoll.com/wp_archives_083012.html --->
<cfset application.rssFeed.gamesScores = "http://sports.espn.go.com/ncf/bottomline/scores"><!--- http://www.repole.com/sun4cast/stats/cfb2012lines.xml --->
<cfset application.settings.minimumPicksPerWeek = 5>
<cfset application.settings.minimumPercentForBowls = 75>
<cfset application.settings.newMessagePostTimeFlag = 2>	<!--- 2 days for the "new" flag on the message board --->

<cfinvoke component="#application.appmap#.cfc.footballDao" method="validateSeasonYear" returnvariable="variables.seasonYear">
	<cfinvokeargument name="seasonYear" value="#year(now())#">
</cfinvoke>
<cfset application.seasonYear =  variables.seasonYear/>


<cfparam name="url.debug" default="false">
<cfparam name="url.logout" default="">

<cfparam name="session.isLoggedIn" default="">
<cfif NOT isDefined("session.user")>
	<cfset session.user = structNew()>
	<cfset session.user.userID = 0>
	<cfset session.user.userName = "">
	<cfset session.user.userPassword = "">
	<cfset session.user.userFullName = "">
  	<cfset session.user.userEmail = "">
  	<cfset session.user.isAdmin = 0>
</cfif>


<cfif url.logout EQ "true">
	<cfset structClear(session)>
	<cfset session.isLoggedIn = false>
</cfif>

<cfparam name="session.today" default="#now()#">
<cfparam name="session.currentWeekNumber" default="0">
<cfparam name="session.currentWeekName" default="0">
<cfparam name="session.currentSeasonYear" default="#application.seasonYear#">
<cfif IsDefined("url.seasonYear") AND url.seasonYear GT "">
	<cfset session.currentSeasonYear = url.seasonYear>
	<cfset session.today = dateFormat(now(),"mm/dd") & "/" & url.seasonYear>
</cfif>

<!--- get the current weeknumber --->
<cfif session.currentWeekNumber EQ 0>
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
		<cfinvokeargument name="gameDate" value="#now()#">
	</cfinvoke>
	<cfset session.currentWeekNumber = variables.qryGetCurrentWeek.weekNumber>
	<cfset session.currentWeekName = variables.qryGetCurrentWeek.weekName>
</cfif>	
