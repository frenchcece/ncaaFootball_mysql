<<<<<<< HEAD
<html lang="en">
<cfoutput>

 	<head>
		<meta charset="utf-8" />
		
		<title>NCAA Football</title>
		
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
		<meta http-equiv="EXPIRES" content="0" />
		<meta name="ROBOTS" content="NONE" />
		
    	<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap.min.css"  type="text/css"/>
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/blitzer/jquery-ui.css" />
		<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap-responsive.min.css"  type="text/css"/>
		<link rel="stylesheet" href="#application.appmap#/css/main.css"  type="text/css"/><!--- this css is used to overwrite some of bootstrap css attributes --->
	    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	    <!--[if lt IE 9]>
	      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	    <![endif]-->

		<script type="text/javascript" src="#application.appmap#/js/main.js"></script>
 	</head>
</cfoutput>


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
          	<cfif session.isLoggedIn>
			<ul class="nav">
              <li><a href="index.cfm">Home</a></li>
              <li><a href="myGames.cfm">Games</a></li>
              <li><a href="mySeason.cfm">Season</a></li>
              <li><a href="myStandings.cfm">Standings</a></li>
            </ul>
			<cfelse>
			<span class="span4">&nbsp;</span>
			</cfif>
					
			<cfinclude template="#application.appmap#/login/login.cfm">           

          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	

<cfif NOT session.isLoggedIn AND url.logout EQ false>
	<div class="container" id="mainContainer">
		<div class="alert alert-error">
			<strong>Error!</strong> Your session has timed out.  Please log back in.
		</div>
	</div>	
	<cfabort>
=======
<html lang="en">
<cfoutput>

 	<head>
		<meta charset="utf-8" />
		
		<title>NCAA Football</title>
		
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="description" content="" />
		<meta name="author" content="" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
		<meta http-equiv="EXPIRES" content="0" />
		<meta name="ROBOTS" content="NONE" />
		

    	<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap.min.css" />
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/blitzer/jquery-ui.css" />
		<link rel="stylesheet" href="#application.appmap#/bootstrap/css/bootstrap-responsive.min.css" />
		<link rel="stylesheet" href="#application.appmap#/css/main.css" /><!--- this css is used to overwrite some of bootstrap css attributes --->
	    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
	    <!--[if lt IE 9]>
	      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	    <![endif]-->

		<script type="text/javascript" src="#application.appmap#/js/main.js"></script>
 	</head>
</cfoutput>


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
          	<cfif session.isLoggedIn>
			<ul class="nav">
              <li><a href="index.cfm">Home</a></li>
              <li><a href="myGames.cfm">Games</a></li>
              <li><a href="mySeason.cfm">Season</a></li>
              <li><a href="myStandings.cfm">Standings</a></li>
            </ul>
			<cfelse>
			<span class="span4">&nbsp;</span>
			</cfif>
					
			<cfinclude template="#application.appmap#/login/login.cfm">           

          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	

<cfif NOT session.isLoggedIn AND url.logout EQ false>
	<div class="container" id="mainContainer">
		<div class="alert alert-error">
			<strong>Error!</strong> Your session has timed out.  Please log back in.
		</div>
	</div>	
	<cfabort>
>>>>>>> 6777cf6963aae7a388d3b394f7f38528339fcd17
</cfif>	