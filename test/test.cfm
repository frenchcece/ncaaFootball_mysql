<cfinvoke component="#application.appmap#.cfc.footballDao" method="checkUserPicks" returnvariable="variables.inactiveGameMsg" >
	<cfinvokeargument name="gameID" value="196">
</cfinvoke>	

<cfdump var="#variables.inactiveGameMsg#">