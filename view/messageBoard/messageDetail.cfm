<style type="text/css">
	input, textarea 
	{
		width: 100%; !important
	}
	
	.form-horizontal .controls, control-group 
	{
    	margin: 0px 10px;
	}
	.form-horizontal .control-label 
	{
    	text-align: left;
    	margin-left: 10px;
	}
</style>


<cfif IsDefined("Form.formSubmitted") AND Form.formSubmitted EQ "true">
	<cfinvoke component="#application.appmap#.cfc.messageDao" method="insertMessageDetail">
		<cfinvokeargument name="userID" value="#session.user.userID#">
		<cfinvokeargument name="msgID" value="#Form.msgID#">
		<cfinvokeargument name="content" value="#trim(Form.reply)#">
	</cfinvoke>

	<cflocation url="messageBoard.cfm?msgID=#Form.msgID#">
</cfif>


<cfoutput>

	<cfif IsDefined("url.msgID") AND url.msgID GT "">
	
		<cfinvoke component="#application.appmap#.cfc.messageDao" method="getMessageDetail" returnvariable="variables.qryMsgDetail">
			<cfinvokeargument name="msgID" value="#url.msgID#">
		</cfinvoke>
	
		<div class="alert alert-success"><strong>#variables.qryMsgDetail.msgTitle#</strong></div>
		<cfloop query="variables.qryMsgDetail">
			
			<div class="well">
				<p><cfif variables.qryMsgDetail.currentRow EQ 1>Post<cfelse><i class="icon-share-alt"></i> Reply </cfif> By #variables.qryMsgDetail.userFullName# On #dateFormat(variables.qryMsgDetail.msgDetailDate,"yyyy-mm-dd")# #timeFormat(variables.qryMsgDetail.msgDetailDate,"hh:mm tt")#</p>
				<p class="alert alert-info">#Replace(variables.qryMsgDetail.msgDetailContent,chr(13)&chr(10),"<br>","ALL")#</p>
			</div>
		</cfloop>		
		
		<div class="well">		
			<form action="" method="post" name="replyForm" class="form-horizontal" onsubmit="return validateReplyForm(this);">
				<input type="hidden" name="formSubmitted" value="true">
				<input type="hidden" name="msgID" value="#url.msgID#">
				<div class="control-group">
					<label class="control-label" for="message">Reply</label>
					<div class="controls">
						<textarea name="reply" id="reply" rows="15" cols="50" placeholder="Reply"></textarea>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-primary">Reply</button>
						<button type="reset">Reset</button>
					</div>
				</div>
			</form>
		</div>
	<cfelse>
		<div class="well">
			Click on a message to view its content
		</div>
	</cfif>

</cfoutput>