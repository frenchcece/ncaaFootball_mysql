<!---<cfset str = "Got it and it looks great! Cant believe you programmed all of it. Good luck thanks again Tim On Mon, Aug 18, 2014 at 9:44 AM, *New Post By: Cedric Dupuy" />
<cfset msgContent = getContentFromBody(str, '2014-08-18') />
<cfdump var="#msgContent#">
<cfabort>--->

<cfsetting requesttimeout="500" >

<cfset start = gettickCount() />
<cfset loginCFC = CreateObject("component","#application.appmap#.cfc.login") />
<cfset msgCFC = CreateObject("component","#application.appmap#.cfc.messageDao") />
<cfset imapCFC = CreateObject("component","#application.appmap#.cfc.iMap") />
<cfset imapInit = imapCFC.Init("frenchcece","c230374d","imap.gmail.com",993,15,1) />
<!--- determine which message ids to get --->
<cfset msgs = imapCFC.list("Inbox") />		<!--- ,"66" ---><!--- you can filter by the messageNumber by using list("Inbox", messageNumber) --->

<cfquery dbtype="query" name="getfootballEmails">
	SELECT 
		[answered], [cc], [date], [deleted], [draft], [flagged], [from], [id], 
		[messagenumber], [recent], [replyto], [seen], [size], [subject], [to], 
		[user]
	FROM 
		[msgs]
	WHERE 
		[subject] LIKE '%Re: College Footbal Pick Game - New Message Posted'
	ORDER BY 
		[messagenumber] DESC;
</cfquery>	
<!--- <cfdump var="#msgs#" />
<cfdump var="#getfootballEmails#"><cfabort> --->




<cfloop query="getfootballEmails">
	<cfset msgDetail = imapCFC.view("Inbox",getFootballEmails.messageNumber,true) />
	<!--- <cfdump var="#msgDetail#"> --->
		
	<cfset msgContent = getContentFromBody(msgDetail.body, msgDetail.date) />
	<cfset msgFrom = getEmailAddressFromMsg(msgDetail.from) />
	<cfset userid = loginCFC.getUserIdFromEmail(msgFrom) />
	<cfset msgID = getMsgID(msgDetail.body) />

<!--- 72,73,74,75,78,79 = 109
	66,67,68,69,70,71 = 108
	61 = 107 --->
	<!--- <cfif ListFind("72,73,74,75,78,79", getFootballEmails.messageNumber)>
		<cfset msgID = 109 />
	<cfelseif ListFind("66,67,68,69,70,71", getFootballEmails.messageNumber)>
		<cfset msgID = 108 />
	<cfelseif ListFind("61", getFootballEmails.messageNumber)>
		<cfset msgID = 107 />
	</cfif> --->
	------------------------<br>
	<cfoutput>
	#msgContent#<br>
	#msgFrom#<br>
	#userid#<br>
	#msgID#<br>
	</cfoutput>
		
	<cfif msgID GT 0>
		<cfset qryGetMessageDetail = msgCFC.getMessageDetail(msgID) />
		<cfquery dbtype="query" name="checkIfContentExists">
			SELECT *
			FROM qryGetMessageDetail
			WHERE left(ltrim(rtrim(msgDetailContent)),30) = '#left(trim(msgContent),30)#'
			AND userID = #userid#
		</cfquery>		

		<cfif NOT checkIfContentExists.recordCount>
			insert msg<br>
			<cfset msgCFC.insertMessageDetail(userid, msgID, msgContent, msgDetail.date, false) />
			delete<br>
			<cfset imapCFC.delete("Inbox",getFootballEmails.messageNumber,true) />
		<cfelse>
			duplicate<br>	
		</cfif>	
	</cfif>
	------------------------<br>
</cfloop>

<cfset end = gettickCount() />
<cfoutput>#evaluate((end-start)/1000)# ms </cfoutput>


<!--- --------------------------------------------------------------------------------------------- --->
<!--- --------------------------------PRIVATE FUNCTIONS-------------------------------------------- --->
<!--- --------------------------------------------------------------------------------------------- --->

<cffunction name="getContentFromBody" access="private" returntype="string" output="false">
	<cfargument name="body" required="true" type="string">
	<cfargument name="date" required="true" type="date">
	
	<cfset dateFormatted1 = DateFormat(arguments.date, "ddd, mmm dd, yyyy") />	<!--- ex: Mon, Aug 27, 2014 --->
	<cfset dateFormatted2 = DateFormat(arguments.date, "mmm dd, yyyy") />	<!--- ex: Aug 27, 2014 --->
	<cfset dateFormatted3 = DateFormat(arguments.date, "yyyy-mm-dd") />		<!--- ex: 2014-08-27 --->

	<cfset content = trim(arguments.body) />
	
	<cfif findNoCase("On #dateFormatted1#",content) GT 0>1
		<cfset content = left(content,findNoCase("#dateFormatted1#",content)-1) />
	<cfelseif findNoCase("On #dateFormatted2#",content) GT 0>2
		<cfset content = left(content,findNoCase("#dateFormatted2#",content)-1) />
	<cfelseif findNoCase("On #dateFormatted3#",content) GT 0>3
		<cfset content = left(content,findNoCase("#dateFormatted3#",content)-1) />
	</cfif>

	<cfif right(content, 3) EQ "On ">
		<cfset content = left(content, len(content)-3) />
	</cfif>

	<cfif findNoCase("Sent From",content) GT 0>
		<cfset content = left(content,findNoCase("Sent From",content)-1) />
	</cfif>
	
	<cfif findNoCase("From my Samsung",content) GT 0>
		<cfset content = left(content,findNoCase("From my Samsung",content)-1) />
	</cfif>
	
	
	
	<!--- a little html cleanup... --->
	<cfset content = REReplaceNoCase(content, "<[^[:space:]][^>]*>", "", "ALL") />
	<cfset content = REReplaceNoCase(content, "&lt;[^[:space:]][^>]*&gt;", "", "ALL") />
	<cfset content = Replace(content,">","", "all") />
	<cfset content = Replace(content,"<","", "all") />
	<cfset content = Replace(content,"&lt;","", "all") />
	<cfset content = Replace(content,"&gt;","", "all") />
	
	<cfreturn trim(content) />
</cffunction>

<cffunction name="getEmailAddressFromMsg" access="private" returntype="string" output="false" >
	<cfargument name="str" type="string" required="true">
	
	<cfset emailAddress = reMatchNoCase("[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,32}", arguments.str) />

	<cfreturn emailAddress[1] /> 
</cffunction>

<cffunction name="getMsgID" access="private" returntype="Numeric" output="false">
	<cfargument name="body" type="string" required="true">
	
	<cfset msgID = -1>
	<cfset index = FindNoCase("[msgid:",arguments.body) />
	<cfif index>
		<cfset newlist = mid(arguments.body,index+7,len(arguments.body)-index-7)>
		<cfset msgID = listGetAt(newList,1,"]") />
	</cfif>

	<cfreturn msgID />
</cffunction>

