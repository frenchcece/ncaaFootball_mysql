<cfoutput>
   	<cfif variables.activeWeek NEQ -1>
	<div class="row">
   		<div class="span8">
	    	<table class="table table-striped table-hover">
	    	<thead>
	    		<tr>
					<th colspan="3">All Games For  For <cfif variables.qryGetWeekInfoByWeekNumber.weekType EQ "regular">Week #variables.qryGetWeekInfoByWeekNumber.weekName#<cfelse>#variables.qryGetWeekInfoByWeekNumber.weekName# Season</cfif></th>
					<th colspan="6">From #dateFormat(variables.qryGetWeekInfoByWeekNumber.startDate,"mm-dd-yyyy")# to #dateFormat(variables.qryGetWeekInfoByWeekNumber.endDate,"mm-dd-yyyy")#</th>
				</tr>
			</thead>
	    	<thead>
	    		<tr>
					<th>Game Date</th>
					<th>Visiting</th>
					<th>Score</th>
					<th>Result</th>
					<th></th>
					<th>Score</th>
					<th>Home</th>
					<th>Spread</th>
					<th>Result</th>
				</tr>
			</thead>		
			<tbody>
				<cfif variables.qryGetGamesOfTheWeek.recordCount>
				<cfloop query="variables.qryGetGamesOfTheWeek">
					<tr>
						<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
						<td>
							<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team1Name#</strong>"><i class="icon-info-sign"></i></a>
							#variables.qryGetGamesOfTheWeek.team1Name#
						</td>
						<td>#variables.qryGetGamesOfTheWeek.team1FinalScore#</td>
						<td>
						<cfswitch expression="#trim(variables.qryGetGamesOfTheWeek.team1WinLoss)#">
							<cfcase value="W"><span class="label label-success">win</span></cfcase>
							<cfcase value="L"><span class="label label-important">loss</span></cfcase>
							<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
							<cfcase value="P"><span class="label label-info">pending</span></cfcase>
						</cfswitch>
						</td>
						<td>@</td>
						<td>#variables.qryGetGamesOfTheWeek.team2FinalScore#</td>
						<td>
							<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team2Name#</strong>"><i class="icon-info-sign"></i></a>
							#variables.qryGetGamesOfTheWeek.team2Name#
						</td>
						<td><cfif variables.qryGetGamesOfTheWeek.team2Spread GT 0>+</cfif>#numberFormat(variables.qryGetGamesOfTheWeek.team2Spread,"999.9")#</td>
						<td>
						<cfswitch expression="#trim(variables.qryGetGamesOfTheWeek.team2WinLoss)#">
							<cfcase value="W"><span class="label label-success">win</span></cfcase>
							<cfcase value="L"><span class="label label-important">loss</span></cfcase>
							<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
							<cfcase value="P"><span class="label label-info">pending</span></cfcase>
						</cfswitch>
						</td>
					</tr>
				</cfloop>
				<cfelse>
					<tr><td colspan="9">No games found.</td></tr>
				</cfif>
			</tbody>
			</table>	
		</div>
	</div>
	<cfelse>
		<div class="well" style="text-align:center;"><h4>Displaying all the games results for the entire year would most likely crash my server.</h4><h1>NO CAN DO!!</h1></div>
	</cfif>
</cfoutput>