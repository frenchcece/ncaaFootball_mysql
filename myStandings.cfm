<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>


<cfparam name="variables.currentUserID" default="#session.user.userID#">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.currentUserID = url.userID>
</cfif>


<!--- get the overall results for the league --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsOverall">
	<cfinvokeargument name="userID" value="-1">
	<cfinvokeargument name="weekNumber" value="-1">
</cfinvoke>		

<!--- get the results for the user group by week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandingsGroupByWeekNumber" returnvariable="variables.standingsGroupByWeekNumber">
	<cfinvokeargument name="userID" value="#variables.currentUserID#">
</cfinvoke>

<cfinclude template="#application.appmap#/view/standings/standings.cfm">

<cfinclude template="footer.cfm">
