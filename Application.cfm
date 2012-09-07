<cfapplication 	
	name="ncaaFootball" 
	sessionmanagement="true" 
	sessiontimeout="#createTimeSpan(0,1,0,0)#" 
	clientmanagement="false" />
	
	
<!--- application vars --->
<cfset application.appmap = "/ncaaFootball" />
<cfset application.dsn = "ncaafootball">
<cfset application.rssFeed.gamesOdds = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Football&sportsubtype=NCAA"><!--- http://livelines.betonline.com/sys/LineXML/LiveLineObjXml.asp?sport=Football ---><!--- http://www.collegefootballpoll.com/wp_archives_083012.html --->
<cfset application.rssFeed.gamesScores = "http://sports.espn.go.com/ncf/bottomline/scores"><!--- http://www.repole.com/sun4cast/stats/cfb2012lines.xml --->
<cfset application.settings.minimumPicksPerWeek = 5>


<cfparam name="url.debug" default="false">
<cfparam name="url.logout" default="">

<cfparam name="session.isLoggedIn" default="false">
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
	<cfset structClear(session.user)>
	<cfset session.isLoggedIn = false>
</cfif>

<cfparam name="session.today" default="#now()#">
<cfparam name="session.currentWeekNumber" default="0">

<!--- get the current weeknumber --->
<cfif session.currentWeekNumber EQ 0>
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
		<cfinvokeargument name="gameDate" value="#session.today#">
	</cfinvoke>
	<cfset session.currentWeekNumber = variables.qryGetCurrentWeek.weekNumber>
</cfif>	
