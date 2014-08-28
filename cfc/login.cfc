<cfcomponent>

	<cffunction name="validateLogin" returntype="Query" output="false">
		<cfargument name="username" type="string" required="true" >
		<cfargument name="password" type="string" required="true" >
		
		<cfquery name="qryGetUserInfo" datasource="#application.dsn#">
			SELECT 
			   userID
		      ,userName
		      ,userFullName
		      ,userPassword
		      ,userEmail
		      ,isAdmin
		      ,isActive
		  FROM 
		  	Users
		  WHERE 
		  	isActive = 1
		  	AND userName = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
		  	AND userPassword = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" >
		</cfquery>

		<cfreturn qryGetUserInfo>		
	</cffunction>

	<cffunction name="getUserInfo" returntype="Query" output="false">
		<cfargument name="userID" type="string" required="true" >
		
		<cfquery name="qryGetUserInfo" datasource="#application.dsn#">
			SELECT 
			   userID
		      ,userName
		      ,userFullName
		      ,userPassword
		      ,userEmail
		      ,isAdmin
		      ,isActive
		  FROM 
		  	Users
		  WHERE 
		  	userID = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_numeric" >
		</cfquery>

		<cfreturn qryGetUserInfo>		
	</cffunction>

	<cffunction name="forgotPassword" returntype="string" output="false">
		<cfargument name="email" type="string" required="true" >
		
		<cfset returnStr = "">

		<cfquery name="qryGetUserInfo" datasource="#application.dsn#">
			SELECT 
			   userID
		      ,userName
		      ,userFullName
		      ,userPassword
		      ,userEmail
		      ,isAdmin
		      ,isActive
		  FROM 
		  	Users
		  WHERE 
		  	userEmail = <cfqueryparam value="#trim(arguments.email)#" cfsqltype="cf_sql_varchar" >
		</cfquery>
	
		<cfif NOT qryGetUserInfo.recordCount>
			<cfset returnStr = "Your email address has not been found.  Try again or contact the webmaster!">
		<cfelse>
			<cfset variables.emailTo = qryGetUserInfo.userEmail>
			<Cfset variables.emailSubject = "College Footbal Pick Game - Forgot Password">
			<cfsavecontent variable = "variables.emailContent">
			<cfoutput>
			<p>
			<strong>Your Account Information:<br>
			#qryGetUserInfo.userFullName# <br><br>
			</strong>
			</p>
			<p><hr width="100%" style="color: ##000; background-color: ##000; height: 2px;"></p>
			<p>
				Username: #qryGetUserInfo.userName#<br>
				Password: #qryGetUserInfo.userPassword#<br>
			</p>
			</cfoutput>	
			</cfsavecontent>
			<cfset variables.emailMsg = variables.emailContent & "<p>Log on to <a href='http://www.dupuyworld.com/ncaaFootball/index.cfm'>www.dupuyworld.com/ncaaFootball/index.cfm</a></p>">


			<!--- send notification email --->
			<cfinvoke component="#application.appmap#.cfc.footballDao" method="sendEmail" returnvariable="variables.void">
				<cfinvokeargument name="emailTo" value="#variables.emailTo#">
				<cfinvokeargument name="emailSubject" value="#variables.emailSubject#">
				<cfinvokeargument name="emailMsg" value="#variables.emailMsg#">
			</cfinvoke>		
			
			<cfset returnStr = "The email has been sent!">
		</cfif>

		<cfreturn returnStr>		
	</cffunction>
	
	<cffunction name="insertUserLog" returntype="void">
		<cfargument name="userID" type="numeric" required="true">
		
		<cfquery name="qryInsertUserLog" datasource="#application.dsn#">
		INSERT INTO UserLogs
			(
			loginDate,
			userID)
		VALUES
			(
			'#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#',
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.userID#">
			);
		</cfquery>
	
		<cfreturn>
	</cffunction>	

	<cffunction name="getUserIdFromEmail" returntype="numeric" output="false">
		<cfargument name="userEmail" type="string" required="true" >
		
		<cfquery name="qryGetUserId" datasource="#application.dsn#">
			SELECT 
			   userID
			FROM 
		  		Users
			WHERE 
		  		userEmail = <cfqueryparam value="#arguments.userEmail#" cfsqltype="cf_sql_varchar" >
		</cfquery>

		<cfreturn qryGetUserId.userID>		
	</cffunction>
</cfcomponent>