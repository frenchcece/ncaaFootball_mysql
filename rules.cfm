<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<cfinclude template="#application.appmap#/login/checkLogin.cfm">

		

<body>

	<cfinclude template="header.cfm">
    <div class="container" id="mainContainer">
    	<h3>Rules</h3>
		under construction...
    
    </div>
	
	<cfinclude template="footer.cfm">

</body>    