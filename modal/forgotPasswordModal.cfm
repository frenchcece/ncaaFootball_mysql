<cfparam name="variables.returnStr" default="">
<cfif IsDefined("Form.email") AND Form.email GT "">
	<cfinvoke component="#application.appmap#.cfc.login" method="forgotPassword" returnvariable="variables.returnStr">
		<cfinvokeargument name="email" value="#form.email#">
	</cfinvoke>

	<script language="javascript">
		alert("<cfoutput>#variables.returnStr#</cfoutput>");
	</script>	
</cfif>


<div class="modal hide" id="forgotPasswordModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">x</button>
        <h3>Forgot Password</h3>
    </div>
    <div class="modal-body" style="text-align:center;">
        <div class="row-fluid">
        	<form method="post" action='' name="forgot_password">
            	<p>Hey this stuff happens, enter your email and we'll send it to you!</p>
                <input type="email" 
					class="span12" 
					name="email" id="email" 
					placeholder="The Email Address You Registered For This Website" 
					required data-validator-validemail-message="Not a valid email address">
                <p><button type="submit" class="btn btn-primary">Submit</button></p>
            </form>
        </div>
    </div>
</div>
