<cfif NOT isDefined("session.isLoggedIn") OR session.isLoggedIn NEQ true>
	<span class="span3 inline" style="text-align:right;padding-top:15px;">	<!---  offset1 --->
		<a data-toggle="modal" href="#forgotPasswordModal">Forgot Password?</a>
	</span>
	<form class="navbar-form pull-right" action="index.cfm?debug=true" method="post" name="loginForm">
		<input class="span2" type="text" placeholder="User" name="User" id="User">
		<input class="span2" type="password" placeholder="Password" name="Password" id="Password">
		<input type="hidden" name="loginFormSubmitted" value="true">
		
		<button type="submit" class="btn btn-small">Sign in</button>
	</form>
<cfelse>
	<span class="span3 inline" style="text-align:right;">	<!---  offset1 --->
		<h5>Welcome, <cfoutput>#session.user.userFullName#</cfoutput></h5>
	</span>
	<span class="inline" style="text-align:right;">
		<cfif structKeyExists(session,"isLoggedIn") AND session.isLoggedIn EQ "true">
			&nbsp;&nbsp;&nbsp;<a class="btn btn-small" href="index.cfm?logout=true">Logout</a></li>
		</cfif>
	</span>	
</cfif>