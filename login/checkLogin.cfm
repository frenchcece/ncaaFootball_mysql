<cfif Isdefined("form.loginFormSubmitted") AND form.loginFormSubmitted EQ "true">
	
	<cfif IsDefined("form.User") AND form.User GT "">
		<cfset session.user.userName = trim(form.User)>
	</cfif>
	<cfif IsDefined("form.Password") AND form.Password GT "">
		<cfset session.user.userPassword = trim(form.Password)>
	</cfif>

	<cfinvoke component="#application.appmap#.cfc.login" method="validateLogin" returnvariable="qryUserInfo">
		<cfinvokeargument name="username" value="#session.user.userName#">
		<cfinvokeargument name="password" value="#session.user.userPassword#">
	</cfinvoke>
	
	<cfif qryUserInfo.recordCount>
		<cfset session.isLoggedIn = true>

      	<cfset session.user.userID = qryUserInfo.userID>
      	<cfset session.user.userFullName = qryUserInfo.userFullName>
      	<cfset session.user.userEmail = qryUserInfo.userEmail>
      	<cfset session.user.isAdmin = qryUserInfo.isAdmin>
	
		<!--- insert user log --->
		<cfinvoke component="#application.appmap#.cfc.login" method="insertUserLog" returnvariable="void">
			<cfinvokeargument name="userID" value="#session.user.userID#">
		</cfinvoke>
		
	<cfelse>
		<cfset session.isLoggedIn = "">
		<cfset variables.loginFailure = true>
	</cfif>
</cfif>

