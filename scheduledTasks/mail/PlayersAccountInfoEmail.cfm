<!--- get the list of active players email address --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryLeaguePlayers" />
<cfset test = 0>
<cfloop query="variables.qryLeaguePlayers">
	<cfif variables.qryLeaguePlayers.sendAccountInfoEmail and test eq 0>
		<cfset test =1>
		<cfset variables.emailTo = variables.qryLeaguePlayers.userEmail>
		<!--- testing only --->
		<cfset variables.emailTo = "frenchcece@gmail.com">	
	
		<cfset variables.emailSubject = "College Footbal Pick Game - Your Account">
		<!--- build the email content --->
		<cfsavecontent variable = "variables.emailContent">
		<cfoutput>
		<p>
		Hi #variables.qryLeaguePlayers.userFullName#,<br>
		A new season of College Football is about to start which means a new season of our pickup game is right around the corner!
		</p>
		<p>Please save this email.  Below is your account information:<br><br>
		<strong>
			Username: #variables.qryLeaguePlayers.userName#<br>
			Password: #variables.qryLeaguePlayers.userPassword#<br>
		</strong>
		</p>
		<p><hr width="100%" style="color: ##000; background-color: ##000; height: 2px;"></p>
		<p>
			Log on to <a href='http://www.dupuyworld.com/ncaaFootball/index.cfm'>www.dupuyworld.com/ncaaFootball/index.cfm</a>
			The game rules are a good source of information if you have never played before <a href='http://ncaafootball.localhost/ncaaFootball/rules.cfm'>[Rules]</a> 
		</p>
		<p>
			If you have any questions, you can contact me at frenchcece@gmail.com.<br>
			The season starts on August 28th.  Good luck to all!
			Cedric
		</p>
		</cfoutput>	
		</cfsavecontent>
		<cfset variables.emailMsg = variables.emailContent>
			
		<!--- send notification email --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="sendEmail" returnvariable="variables.void">
			<cfinvokeargument name="emailTo" value="#variables.emailTo#">
			<cfinvokeargument name="emailSubject" value="#variables.emailSubject#">
			<cfinvokeargument name="emailMsg" value="#variables.emailMsg#">
		</cfinvoke>	
		
		<cfoutput>Email sent to #variables.emailTo# @ #now()#<br></cfoutput>
	</cfif>
</cfloop>				