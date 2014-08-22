<cfcomponent output="false">
	
	<cffunction name="getUserLogs" returntype="query">
		
		<cfquery name="qryGetUserLog" datasource="#application.dsn#">
			SELECT 
			    u.userFullName, u.userID, ul.logID, ul.loginDate
			FROM
			    Users AS u
			    LEFT OUTER JOIN UserLogs AS ul  
					ON ul.userID = u.userID 
					AND ul.loginDate BETWEEN '#dateFormat(dateAdd("yyyy",-1,now()),"yyyy-mm-dd")#' AND '#dateFormat(dateAdd("d",1,now()),"yyyy-mm-dd")#'
			WHERE
			    u.isActive = 1 
			ORDER BY 
				ul.logID DESC;			
		</cfquery>
	
		<cfreturn qryGetUserLog>
	</cffunction>

</cfcomponent>