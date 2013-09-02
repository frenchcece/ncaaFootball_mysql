<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>


<cfparam name="variables.currentUserID" default="#session.user.userID#">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.currentUserID = url.userID>
</cfif>


<cfparam name="variables.activeWeek" default="#session.currentWeekNumber#">
<cfif IsDefined("url.week") AND url.week GT "">
	<cfif url.week EQ "all">
		<cfset variables.activeWeek = -1>
	<cfelse>
		<cfset variables.activeWeek = url.week>
	</cfif>	
</cfif>

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
	<!--- get user information --->
	<cfinvoke component="#application.appmap#.cfc.login" method="getUserInfo" returnvariable="variables.qryGetUserInfo">
		<cfinvokeargument name="userID" value="#variables.currentUserID#">
	</cfinvoke>	
	<!--- get weekNumber info --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getWeekInfoByWeekNumber" returnvariable="variables.qryGetWeekInfoByWeekNumber">
		<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
	</cfinvoke>
	<!--- get all the games of the current week --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getGamesOfTheWeek" returnvariable="variables.qryGetGamesOfTheWeek">
		<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
	</cfinvoke>
	<!--- get the user's picks for that week --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicksOfTheWeek">
		<cfinvokeargument name="userID" value="#variables.currentUserID#">
		<cfinvokeargument name="weekNumber" value="#variables.activeWeek#">
	</cfinvoke>
	<!--- get the list of league's players --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryGetLeaguePlayers">
	</cfinvoke>
		
		
		<h3 class="offset1">My Season<cfif variables.currentUserID NEQ session.user.userID> - #variables.qryGetUserInfo.userFullName#</cfif></h3>
		
	    <div class="pagination pagination-centered">
			<ul>
				<li class="disabled"><a href="##">Week</a></li>
		    	<cfloop query="qryGetWeekNumberList">
			    <li<cfif variables.activeWeek EQ qryGetWeekNumberList.weekNumber> class="active"</cfif>><a href="?week=#qryGetWeekNumberList.weekNumber#&userid=#variables.currentUserID#">#qryGetWeekNumberList.weekName#</a></li>
				</cfloop>
				<li class="disabled"><a href="?week=all&userid=#variables.currentUserID#">Overall</a></li>
		    </ul>
	    </div>

		<div class="tabbable offset2 span8"> <!-- Only required for left/right tabs -->
	    	<ul class="nav nav-tabs" id="myTabs">    
				<li class="active"><a href="##tab1" data-toggle="tab"><cfif variables.currentUserID NEQ session.user.userID> - #variables.qryGetUserInfo.userFullName#<cfelse>My</cfif> Picks</a></li>
				<li><a href="##tab2" data-toggle="tab">League Picks</a></li>
				<li><a href="##tab3" data-toggle="tab">All Games</a></li>
			</ul>
		
			<div class="tab-content">
				<div class="tab-pane active " id="tab1">
					<cfinclude template="#application.appmap#/view/season/myPicks.cfm">
				</div>
				<div class="tab-pane " id="tab2">
					<cfinclude template="#application.appmap#/view/season/leaguePicks.cfm">
				</div>
				<div class="tab-pane " id="tab3">
					<cfinclude template="#application.appmap#/view/season/allGames.cfm">
				</div>
			</div>
		</div>
	
	</cfoutput>
		
	<cfinclude template="footer.cfm">

    