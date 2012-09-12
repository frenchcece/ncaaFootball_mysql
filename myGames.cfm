<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>


<body>
    <div class="container" id="mainContainer">

	<cfinclude template="#application.appmap#/view/games/games.cfm">

	<cfinclude template="footer.cfm">

    </div> <!-- /container -->
</body>

	    