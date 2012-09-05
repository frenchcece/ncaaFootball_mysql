<cfsilent>

	<cfif NOT url.debug>
		<cfsetting showdebugoutput="false" />
	</cfif>

	<cfinclude template="#application.appmap#/login/checkLogin.cfm">	


</cfsilent>


		

<body>

	<cfinclude template="header.cfm">
    <div class="container" id="mainContainer">

      <!-- Main hero unit for a primary marketing message or call to action -->
      <div class="alert alert-info">
      	Welcome to the first attempt to get our little game of football picks easier on us!	
	  </div>
	  
	  <div class="hero-unit">
        <h1>College Football Picking Game</h1>
        <p>This site is a beta version of the college football picking game. Let's use it as a starting point to create something more unique.
		I am open to suggestions and ideas.  Guaranteed or your money back!
		</p>
        <p><a class="btn btn-primary btn-large" href="rules.cfm">Learn more &raquo;</a></p>
      </div>

	<cfif IsDefined("variables.loginFailure") AND variables.loginFailure EQ "true">
		<div class="alert alert-error">
	    <h4>Error!</h4>
	    Oh snap!  Login failed.  Try again.
	    </div>
	</cfif>
		
      <cfif session.isLoggedIn>
		
		<!--- get the current week information --->  
  		<cfinvoke component="#application.appmap#.cfc.footballDao" method="getCurrentWeekNumber" returnvariable="variables.qryGetCurrentWeek">
			<cfinvokeargument name="gameDate" value="#session.today#">
		</cfinvoke>
		<!--- get the games of the current week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="getGamesOfTheWeek" returnvariable="variables.qryGetGamesOfTheWeek">
			<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
		</cfinvoke>
		<!--- get the user's picks for that week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicksOfTheWeek">
			<cfinvokeargument name="userID" value="#session.user.userID#">
			<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
		</cfinvoke>
		
		<cfoutput>
		<!-- row of columns -->
	      <div class="row">
	        <div class="span4">
	          <h2>My Games This Week</h2>
	          <p>
	          	The games from #DateFormat(variables.qryGetCurrentWeek.startDate,"mm/dd")# to #DateFormat(DateAdd('d',-1,variables.qryGetCurrentWeek.endDate),"mm/dd")# 
			   	<cfif variables.qryGetGamesOfTheWeek.recordCount>
				are ready!
				<cfelse>
				are not ready yet.
				</cfif>
			   </p>
			  <p>
			  	<cfif variables.qryGetUserPicksOfTheWeek.recordCount LT application.settings.minimumPicksPerWeek>
				I have picked only #variables.qryGetUserPicksOfTheWeek.recordCount# out of the minimum #application.settings.minimumPicksPerWeek# games for this week.
				<cfelse>
				I have picked #variables.qryGetUserPicksOfTheWeek.recordCount# games for this week.
				</cfif>
			  </p>
	          <p><a class="btn btn-primary" href="myGames.cfm">View details &raquo;</a></p>
	        </div>
			
	        <div class="span4">
	          <h2>My Season</h2>
				<!--- get the results of the current week for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getProcessedResults" returnvariable="variables.resultsStructThisWeek">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
				</cfinvoke>
	         	<p>
	          	<span class="span1">This week:</span>
				<span class="label label-success">#variables.resultsStructThisWeek.recordW# win</span> / <span class="label label-important">#variables.resultsStructThisWeek.recordL# loss</span> / <span class="label label-inverse">#variables.resultsStructThisWeek.recordT# tie</span> / <span class="label label-info">#variables.resultsStructThisWeek.recordP# pending</span>
			  	</p>
				<cfif (session.currentWeekNumber-1) GT 0>
				<!--- get the results of the last week for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getProcessedResults" returnvariable="variables.resultsStructLastWeek">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#-1">
				</cfinvoke>
				<p>
				<span class="span1">Last week:</span>
				<span class="label label-success">#variables.resultsStructLastWeek.recordW# win</span> / <span class="label label-important">#variables.resultsStructLastWeek.recordL# loss</span> / <span class="label label-inverse">#variables.resultsStructLastWeek.recordT# tie</span> / <span class="label label-info">#variables.resultsStructLastWeek.recordP# pending</span>
				</p>
				</cfif>
				<p>
				<span class="span1">Overall:</span>
				<!--- get the overall results for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getProcessedResults" returnvariable="variables.resultsStructOverall">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="-1">
				</cfinvoke>
				<span class="label label-success">#variables.resultsStructOverall.recordW# win</span> / <span class="label label-important">#variables.resultsStructOverall.recordL# loss</span> / <span class="label label-inverse">#variables.resultsStructOverall.recordT# tie</span> / <span class="label label-info">#variables.resultsStructOverall.recordP# pending</span>
				</p>
	          	<p><a class="btn btn-primary" href="mySeason.cfm">View details &raquo;</a></p>
	       </div>	
		   					
	        <div class="span4">
	          <h2>My Standings</h2>
				<!--- get the results of the current week for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsThisWeek">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
				</cfinvoke>
	         	<p>
	          	<span class="span1">This week:</span>
				<cfif variables.standingsThisWeek.winPct EQ "">
					<span class="label label-info">pending</span>
				<cfelse>
					<span class="label label-warning">#variables.standingsThisWeek.winPct# %</span>
				</cfif>
			  	</p>
				<cfif (session.currentWeekNumber-1) GT 0>
				<!--- get the results of the last week for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsLastWeek">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#-1">
				</cfinvoke>
				<p>
				<span class="span1">Last week:</span>
				<span class="label label-warning">#variables.standingsLastWeek.winPct# %</span>
				</p>
				</cfif>
				<p>
				<span class="span1">Overall:</span>
				<!--- get the overall results for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsOverall">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="-1">
				</cfinvoke>
				<span class="label label-warning">#variables.standingsOverall.winPct# %</span>
				</p>
	          <p><a class="btn btn-primary" href="myStandings.cfm">View details &raquo;</a></p>
	        </div>
	      </div>
		</cfoutput>	  
	  </cfif>

      <hr>


	  <cfinclude template="footer.cfm">


    </div> <!-- /container -->


  </body>
	
		
		
		