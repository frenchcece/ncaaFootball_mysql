	<cfinvoke component="#application.appmap#.cfc.footballDao" method="getTeamStatsHtmlTable" returnvariable="variables.stat">
		<cfinvokeargument name="teamid" value="#52#">
	</cfinvoke>
	
<cfoutput>
#variables.stat#
</cfoutput>


	<cfabort>



<cfoutput>
    	<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap.min.css"  type="text/css"/>
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/blitzer/jquery-ui.css" />
		<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap-responsive.min.css"  type="text/css" rel="stylesheet"/>
		<link rel="stylesheet" href="#application.appmap#/css/main.css"  type="text/css"/><!--- this css is used to overwrite some of bootstrap css attributes --->

<cfinclude template="#application.appmap#/modal/forgotPasswordModal.cfm">

<a data-toggle="modal" href="##forgotPasswordModal">Forgot Password?</a>



    <!-- Le javascript  -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jquery-ui.min.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap-tooltip.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap-popover.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/jqBootstrapValidation.js"></script>
<script>
  $(function () { $("input,select,textarea").not("[type=submit]").jqBootstrapValidation(); } );
</script>	
</cfoutput>	
<!--- <cfinvoke component="#application.appmap#.cfc.footballDao" method="checkUserPicks" returnvariable="variables.inactiveGameMsg" >
	<cfinvokeargument name="gameID" value="196">
</cfinvoke>	

<cfdump var="#variables.inactiveGameMsg#"> --->