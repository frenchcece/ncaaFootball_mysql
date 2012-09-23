<cfif IsDefined("Form.formSubmitted") AND Form.formSubmitted EQ "true">
	<cfinvoke component="#application.appmap#.cfc.messageDao" method="insertMessageMain" returnvariable="variables.msgID">
		<cfinvokeargument name="userID" value="#session.user.userID#">
		<cfinvokeargument name="title" value="#trim(Form.title)#">
	</cfinvoke>

	<cfinvoke component="#application.appmap#.cfc.messageDao" method="insertMessageDetail">
		<cfinvokeargument name="userID" value="#session.user.userID#">
		<cfinvokeargument name="msgID" value="#variables.msgID#">
		<cfinvokeargument name="content" value="#trim(Form.message)#">
	</cfinvoke>

	<cflocation url="messageBoard.cfm?msgID=#variables.msgID#">
</cfif>


<div class="alert alert-info">Create a New Post</div>

<form action="" method="post" name="newPostForm" class="form-horizontal" onsubmit="return validateNewPostForm(this);">
	<input type="hidden" name="formSubmitted" value="true">
	<div class="control-group">
		<label class="control-label" for="title">Title</label>
		<div class="controls">
			<input type="text" name="title" id="title" placeholder="title" maxlength="50" class="input-xlarge">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" for="message">Message</label>
		<div class="controls">
			<textarea name="message" id="message" rows="10" cols="20" placeholder="Message" class="input-xlarge"></textarea>
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<button type="submit" class="btn btn-primary">Create Post</button>
			<button type="reset">Reset</button>
		</div>
	</div>
</form>

