<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<!--- get the overall rankings for the league --->
<cfinvoke component="#application.appmap#.cfc.footballDao" method="getFinalRankingByYear" returnvariable="variables.rankingsByYear"></cfinvoke>

<cfquery dbtype="query" name="variables.seasons">
	SELECT
		DISTINCT season
	FROM
		variables.rankingsByYear
	ORDER BY
		1
</cfquery>

<cfinclude template="#application.appmap#/view/rankings/rankings.cfm">

<cfinclude template="footer.cfm">
