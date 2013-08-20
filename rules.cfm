<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<cfinclude template="#application.appmap#/login/checkLogin.cfm">

		

<body>

	<cfinclude template="header.cfm">
    <div class="container" id="mainContainer">
    	<h3>Rules</h3>
		<P STYLE="margin-top: 0.08in"><BR><BR>
		</P>
		<OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Number
			of Games To Be Picked</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You must pick at least 5 games against the spread each week.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You can pick more than 5 games in a week.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If you pick fewer than 5 games, the games you don't pick will count as a loss.  For example, if you pick only 3 games one week, you will automatically receive 2 losses that week.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If you forget to make your picks one week, you will receive 5 losses.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Weeks are considered to start on Tuesday and end on the following Monday.  In other words, the Florida St. - Pittsburgh game on Labor Day is part of the first week's games, not the second week's games.</FONT></FONT></P>
			</OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Number of Bowl Games To Be Picked</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You must pick at least 75% of the bowl games.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If you pick fewer than 75% of the bowl games, the games you don't
				pick will count as a loss.  For example, if there are 20 bowl games, and you pick only 12 of the bowl games, you will automatically receive 3 losses.</FONT></FONT></P>
			</OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>When To Make Your Picks</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Picks may be made as early as this website posts the lines.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The pick for a particular game must be made before the game starts.</FONT></FONT></P>
			</OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>The Lines</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The lines for the games are taken from PinnacleSports.com.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The lines are subject to change at any time up until game time.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>However, once a player picks a game, the point spread will be locked and
				will no longer change.  This prevents two people from picking the same game, but having different point spreads on the same game.</FONT></FONT></P>
			</OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>The Winner</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The winner is the person who has the best winning percentage at the end of the season.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>There is no tie-breaker, because a tie just isn't going to happen.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>There is no prize, other than the admiration/jealousy of your fellow participants.</FONT></FONT></P>
			</OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Sources of Information</U></FONT></FONT></P>
			<OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You may consult with whatever sources of information you wish.</FONT></FONT></P>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Some good sources of information are:</FONT></FONT></P>
				<OL>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Pre-season magazines</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>"Expert" picks on ESPN, SI.com, CBSSportsline, etc.</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><A NAME="_GoBack"></A><FONT FACE="Times New Roman, serif"><FONT SIZE=3>College GameDay</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>CollegeFootballNews.com</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>PhilSteele.com</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Covers.com</FONT></FONT></P>
					<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Sagarin Rankings</FONT></FONT></P>
				</OL>
				<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>But, if you sign up for a tout service, such as the Power Sweep Newsletter or one of those "Call 1-800-Win-Big and we'll give you our super-mega lock of the year" phone numbers, you're taking this thing way too seriously and you're a weenie.</FONT></FONT></P>
			</OL>
		</OL>
    
    </div>
	
	<cfinclude template="footer.cfm">

</body>    