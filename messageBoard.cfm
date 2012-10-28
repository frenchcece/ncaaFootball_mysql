<cfinclude template="#application.appmap#/login/checkLogin.cfm">	
<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="true" />
</cfif>

<cfparam name="url.msgID" default="">

<body>
    <div class="container" id="mainContainer">
		
	<h3>Message Board</h3>
	
	<div class="container-fluid">
	    <div class="row-fluid">
		    <div class="span5 well">
		    <!--Sidebar content-->
				<cfinclude template="#application.appmap#/view/messageBoard/messageMain.cfm">
		    </div>
		    <div class="span7 well">
		    <!--Body content-->
		    	<cfif url.msgID EQ "new">
					<cfinclude template="#application.appmap#/view/messageBoard/messageNew.cfm">
		    	<cfelse>
					<cfinclude template="#application.appmap#/view/messageBoard/messageDetail.cfm">
				</cfif>	
		    </div>
	    </div>
    </div>


	<cfinclude template="footer.cfm">

    </div> <!-- /container -->
</body>