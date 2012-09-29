<cfoutput>

	<h3>My Games This Week</h3>
	
		<!--- form submitted --->
		<cfif structKeyExists(form,"submitBtn")>
			<cfset variables.weekNumber = Form.weekNumber>
			<cfparam name="variables.pickslocked" default="-1">
			<cfif structKeyExists(Form,"pick_locked") AND Form.pick_locked GT "">
				<cfset variables.pickslocked = form.pick_locked>
			</cfif>

			<cftry>
				<!--- first, delete all the active user's picks for the week (keeping the ones that are locked) --->
				<cfinvoke component="#application.appmap#.cfc.footballDao" method="deleteUserPicksByWeekNumber">
					<cfinvokeargument name="userID" value="#session.user.userID#">
					<cfinvokeargument name="weekNumber" value="#variables.weekNumber#">
					<cfinvokeargument name="picksLocked" value="#variables.pickslocked#">
				</cfinvoke>
					
				<!--- loop through the picks and insert or reinsert the ones that user selected --->
				<cfset variables.warningMsg = "">
				<cfloop list="#form.fieldNames#" index="variables.fieldName">
					<cfif left(variables.fieldName,4) EQ "TEAM">
						<cfset variables.gameID = listGetAt(fieldName,2,"_")>
						<cfset variables.teamID = evaluate("Form." & fieldName)>
						
						<!--- make sure that the game picked by user has not started yet.  If so, warn user --->
						<cfinvoke component="#application.appmap#.cfc.footballDao" method="checkUserPicks" returnvariable="variables.inactiveGameMsg" >
							<cfinvokeargument name="gameID" value="#variables.gameID#">
						</cfinvoke>	
						
						<cfif variables.inactiveGameMsg EQ "">
							<cfinvoke component="#application.appmap#.cfc.footballDao" method="insertUserPicks" >
								<cfinvokeargument name="userID" value="#session.user.userID#">
								<cfinvokeargument name="gameID" value="#variables.gameID#">
								<cfinvokeargument name="teamID" value="#variables.teamID#">
								<cfinvokeargument name="weekNumber" value="#variables.weekNumber#">
							</cfinvoke>
						<cfelse>
							<cfset variables.warningMsg = variables.warningMsg & variables.inactiveGameMsg & '<br>'>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfcatch type="any"><cfrethrow>
					<!--- display error msg to user --->
					<div class="alert alert-error offset1">
			          <strong>Dang!</strong> Your picks for week #variables.weekNumber# have failed.  Please contact the webmaster with the list of picks you selected.  (click 'BACK' to go back to the form).
			        </div>
					<cfabort>
				</cfcatch>
			</cftry>

			<cfif variables.warningMsg EQ "">
				<!--- display success msg to user --->
				<div class="alert alert-success span12">
		          <strong>Success!</strong> Your picks for week #variables.weekNumber# have been saved.
		        </div>
			<cfelse>
				<!--- display warning msg to user --->
				<div class="alert alert-warning span12">
		          <strong>Warning!</strong> #variables.warningMsg#
		        </div>
			</cfif>
		</cfif><!--- end form submit --->
	
		<!--- current weeknumber --->
		<cfset variables.currentWeekNumber = session.currentWeekNumber>
		
		<!--- get all the games of the current week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="getGamesOfTheWeek" returnvariable="variables.qryGetGamesOfTheWeek">
			<cfinvokeargument name="weekNumber" value="#variables.currentWeekNumber#">
		</cfinvoke>
		<!--- get the user's picks for that week --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectUserPicksByWeekNumber" returnvariable="variables.qryGetUserPicksOfTheWeek">
			<cfinvokeargument name="userID" value="#session.user.userID#">
			<cfinvokeargument name="weekNumber" value="#variables.currentWeekNumber#">
		</cfinvoke>
		
		<!--- grab the last game date.  used to display the submit button or not. --->
		<cfquery dbtype="query" name="qryGetLastGameDate">
			SELECT MAX([gameDate]) AS lastGameDate
			FROM variables.qryGetGamesOfTheWeek
		</cfquery>		
	
		<!--- display warning if user has not selected minimum 5 games for this week --->
		<cfquery dbtype="query" name="variables.qryActualUserPicksOfTheWeek">
			SELECT 	*
			FROM	variables.qryGetUserPicksOfTheWeek
			WHERE	gameID != -999;
		</cfquery>
		<cfif variables.qryActualUserPicksOfTheWeek.recordCount LT application.settings.minimumPicksPerWeek>
			<div class="alert span12">
	            <strong>Warning!</strong> You have picked only #variables.qryActualUserPicksOfTheWeek.recordCount# out of the minimum required #application.settings.minimumPicksPerWeek# picks for week #variables.currentWeekNumber#.
            </div>
        <cfelse>
   			<div class="alert alert-info span12">
	            <strong>Good job!</strong>You have picked #variables.qryActualUserPicksOfTheWeek.recordCount# games for this week, which meets the minimum required #application.settings.minimumPicksPerWeek# picks.
            </div>
		</cfif>
		
		<!--- display form --->	
    	<div class="row">
    		<div class="span8 offset1">
  
  					<form class="form-horizontal" name="GamePickform" action="##" method="post" onsubmit="return validateGamePickForm(this);">
						<input type="hidden" name="weekNumber" value="#variables.qryGetGamesOfTheWeek.weekNumber#">
			
						<div class="control-group">		
					    	<table class="table table-striped table-hover">
						    	<thead>
						    		<tr>
										<th colspan="4">Games Of The Week</th>
										<th colspan="4" align="right">
											<cfif DateDiff('n',session.today,qryGetLastGameDate.lastGameDate) GT 0>
												<button type="submit" class="btn btn-primary pull-right span2" name="submitBtn" id="submitBtn">Submit Pick</button>
											</cfif>
										</th>										
									</tr>
								</thead>
						
								<tbody>
									<cfset variables.currentDate = "">
							 		<cfloop query="variables.qryGetGamesOfTheWeek">
										
										<cfif variables.currentDate EQ "" OR variables.currentDate NEQ dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")>
											<tr class="info"><td colspan="8" style="font-weight:bold;">#dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"dddd, yyyy-mm-dd")#</td></tr>
									    	<thead>
									    		<tr>
													<th>Time</th>
													<th>Visiting</th>
													<th style="width:10px;"></th>
													<th></th>
													<th style="width:10px;"></th>
													<th>Home</th>
													<th>Spread</th>
													<th></th>
												</tr>
											</thead>
										</cfif>
										<tr <cfif variables.qryGetGamesOfTheWeek.team2Spread EQ 0 OR variables.qryGetGamesOfTheWeek.teamID1 EQ "" OR variables.qryGetGamesOfTheWeek.teamID2 EQ "">class="error"</cfif>>
											<td>#timeFormat(variables.qryGetGamesOfTheWeek.gameDate,"hh:mm tt")# (CT)</td>
											<cfif variables.qryGetGamesOfTheWeek.team2Spread EQ 0>
												<td>
													<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team1Name#</strong>"><i class="icon-info-sign"></i></a>
													#variables.qryGetGamesOfTheWeek.team1Name#
												</td>
												<td></td>
												<td>@</td>
												<td></td>
												<td>
													<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team2Name#</strong>"><i class="icon-info-sign"></i></a>
													#variables.qryGetGamesOfTheWeek.team2Name#
												</td>
												<td>OFF</td>
												<td></td>
											<cfelse>
												<cfquery dbtype="query" name="qryCheckCurrentUserPick">
													SELECT
														  userPickID
														 ,teamID
														 ,winLoss
													FROM
														variables.qryGetUserPicksOfTheWeek
													WHERE
														gameID = #variables.qryGetGamesOfTheWeek.gameID#
												</cfquery>
											
												<td>
													<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID1#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team1Name#</strong>"><i class="icon-info-sign"></i></a>
													<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1> class="badge badge-success"</cfif>>#variables.qryGetGamesOfTheWeek.team1Name#</span>
												</td>
												<td>
													<cfif variables.qryGetGamesOfTheWeek.team1FinalScore GTE 0>
														<span class="label">#variables.qryGetGamesOfTheWeek.team1FinalScore#</span>
													<cfelseif DateDiff('n',session.today,variables.qryGetGamesOfTheWeek.gameDate) LTE 0>
														<span class="label badge-info">&nbsp;0&nbsp;</span>	
													<cfelseif variables.qryGetGamesOfTheWeek.teamID1 EQ "" OR variables.qryGetGamesOfTheWeek.teamID2 EQ "">
														<span class="label badge-error">ERROR</span>
													<cfelse>
														<label class="radio"><input type="radio" name="team_#variables.qryGetGamesOfTheWeek.gameID#" id="team1_#variables.qryGetGamesOfTheWeek.gameID#" value="#variables.qryGetGamesOfTheWeek.teamID1#"<cfif qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1> checked</cfif>></label>
													</cfif>	
												</td>
												<td>
													<span<cfif qryCheckCurrentUserPick.recordCount> class="badge badge-success"</cfif>>@</span>
												</td>
												<td>
													<cfif variables.qryGetGamesOfTheWeek.team2FinalScore GTE 0>
														<span class="label">#variables.qryGetGamesOfTheWeek.team2FinalScore#</span>
													<cfelseif DateDiff('n',session.today,variables.qryGetGamesOfTheWeek.gameDate) LTE 0>
														<span class="label badge-info">&nbsp;0&nbsp;</span>
													<cfelseif variables.qryGetGamesOfTheWeek.teamID1 EQ "" OR variables.qryGetGamesOfTheWeek.teamID2 EQ "">
														<span class="label badge-error">ERROR</span>
													<cfelse>
														<label class="radio"><input type="radio" name="team_#variables.qryGetGamesOfTheWeek.gameID#" id="team2_#variables.qryGetGamesOfTheWeek.gameID#" value="#variables.qryGetGamesOfTheWeek.teamID2#"<cfif qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2> checked</cfif>></label>
													</cfif>	
												</td>
												<td>
													<a id="teamStats" rel="popover" teamid="#variables.qryGetGamesOfTheWeek.teamID2#" data-original-title="<strong>#variables.qryGetGamesOfTheWeek.team2Name#</strong>"><i class="icon-info-sign"></i></a>
													<span<cfif qryCheckCurrentUserPick.recordCount AND qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2> class="badge badge-success"</cfif>>#variables.qryGetGamesOfTheWeek.team2Name#</span>
												</td>
												<td>
													<cfif variables.qryGetGamesOfTheWeek.team2Spread GT 0>+</cfif>
													#numberFormat(variables.qryGetGamesOfTheWeek.team2Spread,"999.9")#
													<cfif variables.qryGetGamesOfTheWeek.spreadLock EQ 1>
													<i class="icon-ok-circle"></i>
													</cfif>
												</td>
												<td align="right">
													<cfif DateDiff('n',session.today,variables.qryGetGamesOfTheWeek.gameDate) GT 0 AND variables.qryGetGamesOfTheWeek.teamID1 GT "" AND variables.qryGetGamesOfTheWeek.teamID2 GT "">
														<button class="btn btn-small" type="button" name="delete" id="delete" value="#variables.qryGetGamesOfTheWeek.gameID#" onclick="clearGameRadioBtn(this);">Clear</button>
													<cfelseif variables.qryGetGamesOfTheWeek.teamID1 EQ "" OR variables.qryGetGamesOfTheWeek.teamID2 EQ "">
														<cfif variables.qryGetGamesOfTheWeek.teamID1 EQ "">team1 NULL<cfelseif variables.qryGetGamesOfTheWeek.teamID2 EQ "">team2 NULL</cfif><i class="icon-exclamation-sign"></i>
													<cfelse>
														<i class="icon-lock"></i>
														<cfif qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID1 OR qryCheckCurrentUserPick.teamID EQ variables.qryGetGamesOfTheWeek.teamID2>
															<input type="hidden" name="pick_locked" value="#qryCheckCurrentUserPick.userPickID#">
														</cfif>
													</cfif>
													<cfif qryCheckCurrentUserPick.winLoss EQ "W">
														<span class="label label-success">Win</span>
													<cfelseif qryCheckCurrentUserPick.winLoss EQ "L">
														<span class="label label-important">Loss</span>
													<cfelseif qryCheckCurrentUserPick.winLoss EQ "T">
														<span class="label label-inverse">Tie</span>		
													</cfif>	
												</td>
											</cfif>
										</tr>
										
									<cfset variables.currentDate = dateFormat(variables.qryGetGamesOfTheWeek.gameDate,"yyyy-mm-dd")>
									</cfloop>
									
							</tbody>
						</table>
					</div>
					
					<cfif DateDiff('n',session.today,qryGetLastGameDate.lastGameDate) GT 0>
					<div class="control-group">
						<div class="controls">
							<button type="submit" class="btn btn-primary offset4 span2" name="submitBtn" id="submitBtn">Submit Pick</button>
						</div>
					</div>
					</cfif>
				</form>
				
			</div> <!-- /span9 -->
			
			<div class="span3">
				<div class="well">
					<h4>Instructions</h4>
					<p>You must at least pick 5 games each week.  
						<ul>
							<li>Note: The spread is always the home spread</li>
							<li>Click on the radio button <input type="radio"/> next to the team you select.</li>
							<li>You can change your selection at anytime until game time.  You can also remove your selection by clicking 'clear'.</li>
							<li>Your selected games will be marked with this icon <span class="badge badge-success">@</span> with your pick highlighted <span class="badge badge-success">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
							<li>Once a game starts, it will be locked <i class="icon-lock"></i> and you won't be allowed to change your selection.</li>
							<li>The icon <i class="icon-ok-circle"></i> next to a spread means that this spread is currently locked and will not change.</li>
							<li>The game results will be displayed once the game ends</li>
							<li><span class="label label-success">Win</span> or <span class="label label-important">Loss</span> will show the result of your picks.</li>
							<br>
							<li><strong>MAKE SURE TO CLICK 'SUBMIT PICK' AT THE TOP OR BOTTOM TO SAVE ANY CHANGE YOU MAKE TO THIS PAGE</strong></li>
						</ul>
					</p>
				</div>
			</div> <!-- /span3 -->
		</div> <!-- /row -->

</cfoutput>