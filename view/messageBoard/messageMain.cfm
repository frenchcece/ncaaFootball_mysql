<style type="text/css">
.alert 
{
    padding: 8px 5px 8px 14px;
}	
</style>

<cfinvoke component="#application.appmap#.cfc.messageDao" method="getAllMessages" returnvariable="variables.qryGetAllMessages"></cfinvoke>

<p>
	<a class="btn btn-primary" href="?msgID=new">Create New Post &raquo;</a>
</p>	
<cfoutput>
	<cfloop query="variables.qryGetAllMessages">
		<div class="alert alert-success" style="margin-bottom:0;">
			<strong>#variables.qryGetAllMessages.msgTitle#</strong>
			<span class="pull-right"><a href="?msgID=#variables.qryGetAllMessages.msgID#">View <i class="icon-chevron-right"></i></a></span>
		</div>
		<p style="margin-top:0;">
			<small>
			By #variables.qryGetAllMessages.userFullName# On #dateFormat(variables.qryGetAllMessages.msgDate,"yyyy-mm-dd")# #timeFormat(variables.qryGetAllMessages.msgDate,"hh:mm tt")#
			<span class="label label-warning pull-right">#variables.qryGetAllMessages.numberOfReplies#
				 repl<cfif variables.qryGetAllMessages.numberOfReplies NEQ 1>ies<cfelse>y</cfif>
			</span>
			<cfif DateDiff("d",variables.qryGetAllMessages.msgDate,now()) LTE application.settings.newMessagePostTimeFlag>
				<span class="label label-important pull-right" style="margin-right:5px;">new!</span>
			<cfelseif DateDiff("d",variables.qryGetAllMessages.maxDetailDate,now()) LTE application.settings.newMessagePostTimeFlag>	
				<span class="label label-info pull-right" style="margin-right:5px;">reply!</span>
			</cfif>	
			</small>
		</p>	
	</cfloop>	
	
</cfoutput>
	