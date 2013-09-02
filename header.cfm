<!DOCTYPE html> 
<html lang="en">
<cfoutput>

 	<head>
		<meta charset="utf-8" />
		
		<title>NCAA Football</title>
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<meta name="description" content="" />
		<meta name="author" content="" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
		<meta http-equiv="EXPIRES" content="0" />
		<meta name="ROBOTS" content="NONE" />
		<meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0;" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		
    	<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap.min.css"  type="text/css"/>
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/blitzer/jquery-ui.css" />
		<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap-responsive.min.css"  type="text/css" rel="stylesheet"/>
		<link rel="stylesheet" href="#application.appmap#/css/main.css"  type="text/css"/><!--- this css is used to overwrite some of bootstrap css attributes --->

	    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	    <!--[if lt IE 9]>
	      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	    <![endif]-->

		<script type="text/javascript" src="#application.appmap#/js/main.js"></script>
 	</head>
</cfoutput>
	<cfinvoke component="#application.appmap#.cfc.messageDao" method="countAllNewMessages" returnvariable="variables.countAllMessagesStr"></cfinvoke>
	<cfoutput>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
		  <a class="brand" style="color:##fff;">NCAA Football</a>
          <div class="nav-collapse collapse">
			<cfif session.isLoggedIn EQ true>
				<ul class="nav">
				<li><a href="index.cfm">Home</a></li>
				<li><a href="myGames.cfm">Games</a></li>
				<li><a href="mySeason.cfm">Season</a></li>
				<li><a href="myStandings.cfm">Standings</a></li>
                <li><a href="rules.cfm">Rules</a></li>
				<li><a href="messageBoard.cfm<cfif variables.countAllMessagesStr.newDateCount GT 0>?msgID=#variables.countAllMessagesStr.msgID#</cfif>">Board<cfif variables.countAllMessagesStr.newDateCount GT 0> <span class="badge badge-important"><cfoutput>#variables.countAllMessagesStr.newDateCount#</cfoutput></span></cfif></a></li>
				<li class="dropdown">
					<a href="##" class="dropdown-toggle" data-toggle="dropdown">More <b class="caret"></b></a>
					<ul class="dropdown-menu">
                        <li><a href="index.cfm?seasonYear=2012">Season 2012</a></li>
                        <li><a href="index.cfm?seasonYear=2013">Season 2013</a></li>
						<li class="divider"></li>
						<cfif session.user.isAdmin>
						<li><a href="admin.cfm">Admin</a></li>
						</cfif>
					</ul>
				</li>	
            </ul>
			<cfelse>
			<span class="span3">&nbsp;</span>
			</cfif>
					
			<cfinclude template="#application.appmap#/login/login.cfm">           

          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	</cfoutput>


<body>
    <div class="container" id="mainContainer">
	<cfinclude template="#application.appmap#/modal/forgotPasswordModal.cfm">
	
		
	<cfif session.currentSeasonYear NEQ application.seasonYear>
		<div class="container" id="mainContainer">
			<div class="alert alert-error">
				<strong>Attention!</strong> You have selected the season <strong><cfoutput>#session.currentSeasonYear#</cfoutput></strong>
			</div>
		</div>
	</cfif>
	
<!--- <cfdump var="#url#">	
<cfdump var="#session#">	 --->
<cfif (session.isLoggedIn NEQ true OR session.cfid EQ "")  AND url.logout NEQ true>
	<div class="container" id="mainContainer">
		<div class="alert alert-error">
			<strong>Error!</strong> Your session has timed out.  Please log back in.
		</div>
	</div>
	<cfinclude template="footer.cfm">
	<cfabort>
</cfif>	

