<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<script>
.hero-unit
{
padding: 10px;
}
</script>

      <!-- Main hero unit for a primary marketing message or call to action -->
      <div class="alert alert-success">
      	Welcome to my attempt of making our little game of football picks easier on us (especially Steve)!  This game is completely free and you can only win bragging rights so have fun!
	  </div>
	  
	  <div class="hero-unit">
				<div class="span10" style="margin-bottom:10px;">
					<h1>College Football Picking Game</h1>
				</div>	
				<div class="row">
					<div class="<cfif isBoolean(session.isLoggedIn) AND session.isLoggedIn>span7<cfelse>span10</cfif>">
				        <p>This site has started over a few years ago as a simple idea for our college football picking game. It started out of the desire to create something unique, fun and easy for our players to use.
						I am very open to suggestions and ideas.  If you have ideas for new pages, reports, improvements on the existing pages, 
						please don't hesitate.  Post your ideas/comments on the message board. I won't be offended.  Guaranteed or your money back!
						</p>
				        <p><a class="btn btn-primary btn-large" href="rules.cfm">Learn more &raquo;</a></p>
					</div>
					<cfif isBoolean(session.isLoggedIn) AND session.isLoggedIn>
					<div class="span3" style="padding: 0px; margin:0px;">
						<div class="well" style=" background-color:#468847; color:white;">
							<!--- <div><strong>Season 2012 Results:</strong></div>
							<div>
								<ol>
									<li>Cedric Dupuy - Champion</li>
									<li>Bobby Slotkin</li>
									<li>Steve Campbell</li>
									<li>Rebecca Dupuy</li>
									<li>Lea Ann Slotkin</li>
								</ol>
							</div> --->
							<div><strong>Season 2013 Results:</strong></div>
							<div>
								<ol>
									<li><strong>Todd Shapiro 56.90 % - Champion</strong></li>
									<li>Eric Farney 56.36 %</li>
									<li>Steve Campbell 55.56 %</li>
									<li>Jeff Fecht 55.21 %</li>
									<li>Cedric Dupuy 54.26 %</li>
								</ol>
							</div>
						</div>						
					</div>
					</cfif>
				</div>
      </div>

	<cfif IsDefined("variables.loginFailure") AND variables.loginFailure EQ "true">
		<div class="alert alert-error">
	    <h4>Error!</h4>
	    Oh snap!  Login failed.  Try again.
	    </div>
	</cfif>
		
      <cfif isBoolean(session.isLoggedIn) AND session.isLoggedIn EQ true>
		
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
				<cfif variables.qryGetCurrentWeek.weekType EQ "regular">
				  	<cfif variables.qryGetUserPicksOfTheWeek.recordCount LT application.settings.minimumPicksPerWeek>
					I have picked only #variables.qryGetUserPicksOfTheWeek.recordCount# out of the minimum #application.settings.minimumPicksPerWeek# games for this week.
					<cfelse>
					I have picked #variables.qryGetUserPicksOfTheWeek.recordCount# games for this week.
					</cfif>

				<cfelseif variables.qryGetCurrentWeek.weekType EQ "bowl">
					<cfinvoke component="#application.appmap#.cfc.footballDao" method="calculateMininumNumberBowlsToPick" returnvariable="variables.qryMininumNumberBowlsToPick">
						<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
					</cfinvoke>
					
					<cfif variables.qryMininumNumberBowlsToPick.recordCount>
						<cfif variables.qryGetUserPicksOfTheWeek.recordCount LT variables.qryMininumNumberBowlsToPick.mininumBowlsToPick>
						I have picked only #variables.qryGetUserPicksOfTheWeek.recordCount# out of the minimum #application.settings.minimumPercentForBowls#% of the bowl games.
						<br>I need to pick at least #variables.qryMininumNumberBowlsToPick.mininumBowlsToPick# out of #variables.qryMininumNumberBowlsToPick.totalNumberBowlGames# games.
						<cfelse>
						I have picked #variables.qryGetUserPicksOfTheWeek.recordCount# bowl games.
						<br>The minimum is #variables.qryMininumNumberBowlsToPick.mininumBowlsToPick# out of #variables.qryMininumNumberBowlsToPick.totalNumberBowlGames# games.
						</cfif>	
					<cfelse>
					No bowl games have been found yet.
					</cfif>
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
					<span class="label label-warning">#numberFormat(variables.standingsThisWeek.winPct,"99.99")# %</span>
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
				<cfif variables.standingsLastWeek.winPct EQ "">
					<span class="label label-info">pending</span>
				<cfelse>
					<span class="label label-warning">#numberFormat(variables.standingsLastWeek.winPct,"99.99")# %</span>
				</cfif>
				</p>
				</cfif>
				<p>
				<span class="span1">Overall:</span>
				<!--- get the overall results for the user --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="getStandings" returnvariable="variables.standingsOverall">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="-1">
				</cfinvoke>
				<cfif variables.standingsOverall.winPct EQ "">
					<span class="label label-info">pending</span>
				<cfelse>
					<span class="label label-warning">#numberFormat(variables.standingsOverall.winPct,"99.99")# %</span>
				</cfif>
				</p>
	          <p><a class="btn btn-primary" href="myStandings.cfm">View details &raquo;</a></p>
	        </div>
	      </div>
		</cfoutput>	  
	  </cfif>

      <hr>


	  <cfinclude template="footer.cfm">


	
		
		
