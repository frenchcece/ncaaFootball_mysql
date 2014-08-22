<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>

<cfparam name="variables.userID" default="-1">
<cfif IsDefined("url.userID") AND url.userID GT "">
	<cfset variables.userID = url.userID>
</cfif>

<cfinvoke component="#application.appmap#.cfc.adminDao" method="getUserLogs" returnvariable="variables.qryGetUserLogs"></cfinvoke>

<cfquery dbtype="query" name="variables.qryGetUserLogsLast7Days">
	SELECT
		*
	FROM
		variables.qryGetUserLogs
	WHERE
		loginDate >= '#DateFormat(DateAdd("d",-7,now()),"yyyy-mm-dd")#'
</cfquery>

<cfquery dbtype="query" name="variables.qryGetLogUsers">
	SELECT
		DISTINCT userID, userFullName
	FROM
		variables.qryGetUserLogs
	ORDER BY
		userFullName ASC				
</cfquery>


<!--- get the list of league's players --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryGetLeaguePlayers"></cfinvoke>


<body>
		<cfinclude template="admin/userLogs.cfm">
		
		<cfinclude template="footer.cfm">
</body>
