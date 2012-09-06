<cfif NOT isDefined("session.isLoggedIn") OR session.isLoggedIn EQ false>
	<form class="navbar-form pull-right" action="index.cfm?debug=true" method="post" name="loginForm">
		<input class="span2" type="text" placeholder="User" name="User" id="User">
		<input class="span2" type="password" placeholder="Password" name="Password" id="Password">
		<input type="hidden" name="loginFormSubmitted" value="true">
		
		<button type="submit" class="btn btn-small">Sign in</button>
	</form>
<cfelse>
	<span class="span4 offset2" style="text-align:right;">
		<h4>Welcome, <cfoutput>#session.user.userFullName#</cfoutput></h4>
	</span>
	<span style="text-align:right;">
	<cfif structKeyExists(session,"isLoggedIn") AND session.isLoggedIn EQ "true">&nbsp;&nbsp;&nbsp;<a class="btn btn-small" href="index.cfm?logout=true">Logout</a></li></cfif>
	</span>	
</cfif>