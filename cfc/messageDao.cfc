<cfcomponent output="false">

	<cffunction name="insertMessageMain" access="public" returntype="Numeric">
		<cfargument name="userID" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		
		<cfquery datasource="#application.dsn#" name="qryInsertMessageMain">
			INSERT INTO messageBoard
			(
				`active`,
				`msgDate`,
				`msgTitle`,
				`userID`
			)
			VALUES
			(
				1,
				'#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
			);
			
			SELECT @@identity AS msgID;
		</cfquery>

		<cfreturn qryInsertMessageMain.msgID>
	</cffunction>

	<cffunction name="insertMessageDetail" access="public" returntype="void">
		<cfargument name="userID" type="numeric" required="true">
		<cfargument name="msgID" type="numeric" required="true">
		<cfargument name="content" type="string" required="true">
		
		<cfquery datasource="#application.dsn#" name="qryInsertMessageMain">
			INSERT INTO messageBoardDetail
			(
				`active`,
				`msgDetailContent`,
				`msgDetailDate`,
				`msgID`,
				`userID`
			)
			VALUES
			(
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content#">,
				'#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.msgID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
			);
		</cfquery>
		
		<!--- send notification email to everybody in the league --->
		<cfinvoke method="sendNotificationEmail">
			<cfinvokeargument name="msgID" value="#arguments.msgID#">
		</cfinvoke>

		<cfreturn>
	</cffunction>

	<cffunction name="getAllMessages" access="public" returntype="query">

		<cfquery datasource="#application.dsn#" name="qryGetAllMessages">
			SELECT 
			    mb.msgID,
			    mb.msgDate,
			    mb.msgTitle,
			    mb.userID,
			    u.userFullName,
			    count(mbd.msgDetailID) - 1 AS numberOfReplies,
			    max(mbd.msgDetailDate) AS maxDetailDate
			FROM
			    messageBoard AS mb
			        INNER JOIN
			    Users AS u ON u.userID = mb.userID
			        INNER JOIN
			    messageBoardDetail AS mbd ON mb.msgID = mbd.msgID
			WHERE
			    mb.active = 1
			GROUP BY
			    mb.msgID,
			    mb.msgDate,
			    mb.msgTitle,
			    mb.userID,
			    u.userFullName
			ORDER BY max(mbd.msgDetailDate) DESC, mb.msgDate DESC;
		</cfquery>

		<cfreturn qryGetAllMessages>
	</cffunction>

	<cffunction name="getMessageDetail" access="public" returntype="query">
		<cfargument name="msgID" type="numeric" required="true">

		<cfquery datasource="#application.dsn#" name="qryGetMessageDetail">
			SELECT 
			    mbd.msgDetailID,
			    mbd.msgID,
			    mbd.msgDetailDate,
			    mbd.msgDetailContent,
			    mbd.userID,
			    u.userFullName,
			    mb.msgTitle,
			    mb.msgDate
			FROM
			    messageBoardDetail AS mbd
			        INNER JOIN
			    Users AS u ON u.userID = mbd.userID
			        INNER JOIN
			    messageBoard AS mb ON mb.msgID = mbd.msgID
			WHERE
			    mbd.active = 1 
			    AND mbd.msgID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.msgID#">
			ORDER BY mbd.msgDetailDate;	
		</cfquery>

		<cfreturn qryGetMessageDetail>
	</cffunction>

	<cffunction name="sendNotificationEmail" access="public" returntype="void">
		<cfargument name="msgID" type="numeric" required="true">
		
		<!--- get the message detail info --->
		<cfset variables.qryMsgDetail = getMessageDetail(arguments.msgID)>
		<!--- get the last entry for this message --->
		<cfquery dbtype="query" name="variables.qryLastMsgDetail">
			SELECT TOP 1 * FROM variables.qryMsgDetail ORDER BY msgDetailID DESC;
		</cfquery>
	
		<!--- get the list of players email address --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="selectLeaguePlayers" returnvariable="variables.qryLeaguePlayers"></cfinvoke>

		<!--- build the email variables --->
		<cfset variables.emailTo = valuelist(variables.qryLeaguePlayers.userEmail)>
		<!--- <cfset variables.emailTo = "frenchcece@yahoo.com,frenchcece@gmail.com"> --->
		<cfset variables.emailSubject = "College Footbal Pick Game - New Message Posted">
		<!--- build the email content --->
		<cfsavecontent variable = "variables.emailContent">
		<cfoutput>
		<p>
		<strong>New <cfif variables.qryMsgDetail.currentRow EQ 1>Post<cfelse>Reply</cfif> By:<br>
		#variables.qryLastMsgDetail.userFullName# On #dateFormat(variables.qryLastMsgDetail.msgDetailDate,"yyyy-mm-dd")# #timeFormat(variables.qryLastMsgDetail.msgDetailDate,"hh:mm tt")#<br><br>
		#Replace(variables.qryLastMsgDetail.msgDetailContent,chr(13)&chr(10),"<br>","ALL")#
		</strong>
		</p>
		<p><hr width="100%" style="color: ##000; background-color: ##000; height: 2px;"></p>
		<p>
			<div><strong>This comment has been added to this discussion:<br> #variables.qryMsgDetail.msgTitle#</strong></div>
			<cfloop query="variables.qryMsgDetail">
				
				<div>
					<p><cfif variables.qryMsgDetail.currentRow EQ 1>Post<cfelse><i class="icon-share-alt"></i> Reply </cfif> By #variables.qryMsgDetail.userFullName# On #dateFormat(variables.qryMsgDetail.msgDetailDate,"yyyy-mm-dd")# #timeFormat(variables.qryMsgDetail.msgDetailDate,"hh:mm tt")#</p>
					<p class="alert alert-info">#Replace(variables.qryMsgDetail.msgDetailContent,chr(13)&chr(10),"<br>","ALL")#</p>
				</div>
			</cfloop>		
		</p>
		</cfoutput>	
		</cfsavecontent>
		<cfset variables.emailMsg = variables.emailContent & "<p>Log on to <a href='http://www.dupuyworld.com/ncaaFootball/index.cfm'>www.dupuyworld.com/ncaaFootball/index.cfm</a> to reply to this message</p>">
			
		<!--- send notification email --->
		<cfinvoke component="#application.appmap#.cfc.footballDao" method="sendEmail" returnvariable="variables.void">
			<cfinvokeargument name="emailTo" value="#variables.emailTo#">
			<cfinvokeargument name="emailSubject" value="#variables.emailSubject#">
			<cfinvokeargument name="emailMsg" value="#variables.emailMsg#">
		</cfinvoke>		
		
		
	
		<cfreturn>
	</cffunction>

	<cffunction name="countAllNewMessages" access="public" returntype="Struct">

		<cfset variables.rightNow = dateFormat(now(),"yyyy-mm-dd") & " " & timeFormat(now(),"HH:mm:ss")>
		<cfset variables.comparedDate = DateAdd('d',-application.settings.newMessagePostTimeFlag,variables.rightNow)>
		<cfset variables.comparedDate = dateFormat(variables.comparedDate,"yyyy-mm-dd") & " " & timeFormat(variables.comparedDate,"HH:mm:ss")>
		
		<cfset variables.structRtn = StructNew()>
		<cfset variables.structRtn.newDateCount = 0>
		<cfset variables.structRtn.msgID = "">
								
		<cfquery datasource="#application.dsn#" name="qryCountAllNewMessages">
			SELECT 
				mbd.msgID,
				max(mbd.msgDetailDate) AS msgDetailDate
			FROM
			    messageBoardDetail AS mbd
			WHERE
			    mbd.active = 1
			GROUP BY
			    mbd.msgID
			ORDER BY max(mbd.msgDetailDate) DESC;
		</cfquery>
				
		<cfquery dbtype="query" name="qryCountNewMessages">
			SELECT COUNT(*) AS newDateCount
			FROM qryCountAllNewMessages
			WHERE msgDetailDate >= '#variables.comparedDate#'
		</cfquery>
		<cfif qryCountNewMessages.recordCount>
			<cfset variables.newDateCount = qryCountNewMessages.newDateCount>
			<cfset variables.structRtn.newDateCount = qryCountNewMessages.newDateCount>
			<cfset variables.structRtn.msgID = qryCountAllNewMessages.msgID>
		</cfif>

		<cfreturn variables.structRtn>
	</cffunction>
</cfcomponent>