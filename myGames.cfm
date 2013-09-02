<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>


	<cfinclude template="#application.appmap#/view/games/games.cfm">

	<cfinclude template="footer.cfm">


	    