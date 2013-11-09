<!--- check if today is the first day of the college football schedule week --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getWeekInfoByWeekNumber" returnvariable="variables.qryGetWeekInfo">
	<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#" />
</cfinvoke>

<!--- today is the first day! --->
<cfif DateDiff('h', variables.qryGetWeekInfo.startDate, now()) GT 0 AND DateDiff('h', variables.qryGetWeekInfo.startDate, now()) LT 24>

 
	<!--- log the date into database --->
	<cfquery name="qryInsertLogDate" datasource="#application.dsn#">
		INSERT INTO
		ncaa_football.RssFeedLog
			(logDate, rssFeedName)
		VALUES
			(#now()#,'MailNotification')	
	</cfquery>
	
	<!--- get all the games of the current week --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getGamesOfTheWeek" returnvariable="variables.qryGetGamesOfTheWeek">
		<cfinvokeargument name="weekNumber" value="#session.currentWeekNumber#">
	</cfinvoke>
	
	<!--- get the list of players email address --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryLeaguePlayers">
	</cfinvoke>
	
	
	<!--- build the email content --->
	<cfsavecontent  
    	variable = "variables.emailContent"> 
	<cfoutput>
	<div class="row">
	 	<div class="span8">
		   	<table>
		   	<thead>
		   		<tr>
					<th colspan="7">All Games For Week #variables.qryGetWeekInfo.weekName#</th>
				</tr>
			</thead>
		   	<thead>
		   		<tr>
					<th>Game Date</th>
					<th>Visiting</th>
					<th>Score</th>
					<th></th>
					<th>Score</th>
					<th>Home</th>
					<th>Spread</th>
				</tr>
			</thead>		
			<tbody>
	
			<cfif variables.qryGetGamesOfTheWeek.recordCount>
			<cfloop query="variables.qryGetGamesOfTheWeek">
				<tr>
					<td>#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")#</td>
					<td>#variables.qryGetGamesOfTheWeek.team1Name#</td>
					<td>
					<cfswitch expression="#trim(variables.qryGetGamesOfTheWeek.team1WinLoss)#">
						<cfcase value="W"><span class="label label-success">win</span></cfcase>
						<cfcase value="L"><span class="label label-important">loss</span></cfcase>
						<cfcase value="T"><span class="label label-inverse">tie</span></cfcase>
						<cfcase value="P"><span class="label label-info">pending</span></cfcase>
					</cfswitch>
					</td>
					<td>@</td>
					<td>#variables.qryGetGamesOfTheWeek.team2Name#</td>
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
				<tr><td colspan="7">No games found.</td></tr>
			</cfif>
		</tbody>
		</table>	
		</div>
	</div>
	</cfoutput>	
	</cfsavecontent>	
	
	<!--- build the email variables --->
	<cfset variables.emailTo = valuelist(variables.qryLeaguePlayers.userEmail)>
	<!--- <cfset variables.emailTo = "frenchcece@yahoo.com,frenchcece@gmail.com"> --->
	<cfset variables.emailSubject = "College Footbal Pick Game Week " & variables.qryGetWeekInfo.weekName & " starts today">
	<cfset variables.emailMsg = "<p>Make your picks!</p><p>Log on to <a href='http://www.dupuyworld.com/ncaaFootball/index.cfm'>www.dupuyworld.com/ncaaFootball/index.cfm</a>.</p><p>The lines for this week are subject to change:<br>" & variables.emailContent & "</p><br><p>Good luck!</p>">
		
	<!--- send notification email --->
	<cfinvoke component="#application.appmap#.cfc.footballDao" method="sendEmail" returnvariable="variables.void">
		<cfinvokeargument name="emailTo" value="#variables.emailTo#">
		<cfinvokeargument name="emailSubject" value="#variables.emailSubject#">
		<cfinvokeargument name="emailMsg" value="#variables.emailMsg#">
	</cfinvoke>

</cfif>
<cfabort>

	