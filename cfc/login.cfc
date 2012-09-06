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
</cfcomponent>