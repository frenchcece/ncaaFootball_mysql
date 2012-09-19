<cfcomponent output="false">
	
	<cffunction name="getUserLogs" returntype="query">
		<cfargument name="userID" type="numeric" default="-1">
		<cfargument name="startDate" type="date" default="1970-01-01">
		<cfargument name="endDate" type="date" default="1970-01-01">
		
		<cfquery name="qryGetUserLog" datasource="#application.dsn#">
			SELECT 
			    ul.logID, ul.userID, ul.loginDate, u.userFullName
			FROM
			    UserLogs AS ul
			        INNER JOIN
			    Users AS u ON ul.userID = u.userID
			WHERE
			    1 = 1 
			    <cfif arguments.userID NEQ -1>
			    AND u.userID = #arguments.userID#
			    </cfif>
			    <cfif arguments.startDate NEQ "1970-01-01" AND arguments.endDate NEQ "1970-01-01">
			        AND ul.loginDate BETWEEN '#arguments.startDate#' AND '#arguments.endDate#'
			    </cfif>    
			ORDER BY ul.logID DESC;
		</cfquery>
	
		<cfreturn qryGetUserLog>
	</cffunction>

</cfcomponent>