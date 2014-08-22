<cfinclude template="header.cfm">

<cfif NOT url.debug>
	<cfsetting showdebugoutput="false" />
</cfif>

<cfinclude template="#application.appmap#/login/checkLogin.cfm">

<body>

		<div class="alert alert-success" style="">
			<h3>Rules</h3>
		</div>

<OL>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Number
	of Games To Be Picked</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You
		must pick at least 5 games against the spread each week.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You
		can pick more than 5 games in a week.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you pick fewer than 5 games, the games you don't pick will count
		as a loss.  For example, if you pick only 3 games one week, you
		will automatically receive 2 losses that week.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you forget to make your picks one week, you will receive 5 losses.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Weeks
		are considered to start on Tuesday and end on the following Monday.
		 In other words, the Florida St. - Pittsburgh game on Labor Day
		is part of the first week's games, not the second week's games.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=2>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Number
	of Bowl Games To Be Picked</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You
		must pick at least 75% of the bowl games.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you pick fewer than 75% of the bowl games, the games you don't
		pick will count as a loss.  For example, if there are 20 bowl
		games, and you pick only 12 of the bowl games, you will
		automatically receive 3 losses.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=3>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>When
	To Make Your Picks</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Picks
		may be made as early as this website posts the point spreads.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		pick for a particular game must be made before the game starts.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>99%
		of the time, the game times listed on the website are correct. 
		However, every once in a while, an 11:00 am game shows up as an
		11:00 pm game, and vice versa.  Also, sometimes game times are
		changed late in the week, and the website doesn't know to update
		the time.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=4>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Tabs
	At The Top Of The Page</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		"Games" tab at the top of the page is where you make your picks
		for the week.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		"Season" tab at the top of the page is where you can review the
		picks you've made and see what games other players have picked.</FONT></FONT></P>
		<OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>By
			clicking the "My Picks" link on the "Season" tab, you can
			see the games you have picked for the week.</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>By
			clicking the "League Picks" link on the "Season" tab, you
			can see the games other players have picked for the week.</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
			games other players have picked will not be revealed until the
			game has started.  This prevents someone from gaming the system by
			picking the opposite of another player in an attempt to make up
			ground.</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>For
			some funky reason, the other players' picks aren't always
			revealed at the time the game starts.  It's a bug that has yet
			to be worked out.</FONT></FONT></P>
		</OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		"Standings" tab will show you updated standings.  Expect to see
		my name at the top of the standings most of the time.  ;-)</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		"Board" tab is where the message board is.  I (Steve Campbell)
		tend to overuse the message board.  I like to try to get college
		football conversations started.  I encourage you to join in with
		me.</FONT></FONT></P>
		<OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>When
			a new message is posted, the website will send an email to all the
			participants notifying them a new message has been posted.  I
			believe you can opt out of receiving these notices if you wish. 
			Contact Cedric directly to do so.</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>When
			responding to a message, please do so on the message board, rather
			than replying to the email.  This helps keep all the discussions
			in one place.  </FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3><I>More
			importantly, if you respond to an email, rather than post on the
			message board, Cedric doesn't get notification of the response,
			and he gets left out of the conversation</I></FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3>.</FONT></FONT></P>
		</OL>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=5>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>The
	Point Spreads</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		point spreads for the games are taken from PinnacleSports.com.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		point spreads are subject to change at any time up until game time.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>However,
		once a player picks a game, the point spread will be locked and
		will no longer change.  This prevents two people from picking the
		same game, but having different point spreads on the same game.  A
		check mark next to a point spread means someone has picked that
		game, and the point spread has been locked.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=6>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>How
	To Read The Point Spreads</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>On
		the "Games" page, the visiting team is listed on the left, the
		home team is listed on the right, and the point spread is listed on
		the far right.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		point spread indicates whether the home team is the favorite or the
		underdog.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		the point spread is negative, the home team is the favorite, </FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3><I>i.e.</I></FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3>,
		Las Vegas thinks the home team will win by that number of points.</FONT></FONT></P>
		<OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>(Technically,
			that's not quite right.  Las Vegas isn't predicting the
			favorite will win by that number of points, but a full explanation
			of what the point spread really means would take up too much space
			and be boring.)</FONT></FONT></P>
		</OL>
		<LI><P ALIGN=JUSTIFY STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		the point spread is positive, the home team is the underdog, </FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3><I>i.e.</I></FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3>,
		Las Vegas thinks the home team will lose by that number of points.</FONT></FONT></P>
		<LI><P ALIGN=JUSTIFY STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>For
		example, in the first game of the year South Carolina is the home
		team and is a 10.5 point favorite over North Carolina.</FONT></FONT></P>
		<LI><P ALIGN=JUSTIFY STYLE="margin-top: 0.08in"><A NAME="_GoBack"></A>
		<FONT FACE="Times New Roman, serif"><FONT SIZE=3>If Team A is a 5 point favorite over Team B, and Team A beats Team B by exactly 5 points, 
		the game is considered a "push", and the game counts as neither a win nor a loss for you. F
		or the purposes of the pick'em contest, it's as if you never picked that game (however, the game still counts as one of your 
		five picks for the week or as one of your required bowl game picks.)
		</FONT></FONT></P>
	</OL>
</OL>
<P ALIGN=JUSTIFY STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=7>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>How
	To Make Your Picks</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you think the visiting team will cover the point spread, click the
		circle next to the visiting team's name.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you think the home team will cover the point spread, click the
		circle next to the home team's name.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Once
		you have made your picks, click "Submit Pick" to lock in your
		picks for the week.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You
		can change your mind at any time up until game time.  Simply click
		the circle next to the other team if you want to pick the other
		team.  Of, if you don't want to pick that game, click "Clear"
		to the right of the point spread, and your pick will be erased.  If
		you change your pick, be sure to click "Submit Pick".</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>If
		you forget to save your picks, you're stuck with whatever picks
		you've made previously.  They cannot be changed by the
		administrator once the games have started.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><I>ALWAYS
		be sure to click "Submit Pick"</I></FONT></FONT><FONT FACE="Times New Roman, serif"><FONT SIZE=3>.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=8>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>The
	Winner</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>The
		winner is the person who has the best winning percentage at the end
		of the season.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>There
		is no tie-breaker, because a tie just isn't going to happen.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>There
		is no prize, other than the admiration/jealousy of your fellow
		participants.</FONT></FONT></P>
	</OL>
</OL>
<P STYLE="margin-top: 0.08in"><BR><BR>
</P>
<OL START=9>
	<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3><U>Sources
	of Information</U></FONT></FONT></P>
	<OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>You
		may consult whatever sources of information you wish.</FONT></FONT></P>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Some
		good sources of information are:</FONT></FONT></P>
		<OL>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Pre-season
			magazines</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in">"<FONT FACE="Times New Roman, serif"><FONT SIZE=3>Expert"
			picks on ESPN, SI.com, CBSSportsline, etc.</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>College
			GameDay (but not necessarily Lee Corso)</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>CollegeFootballNews.com</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>PhilSteele.com</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Covers.com</FONT></FONT></P>
			<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>Sagarin
			Rankings</FONT></FONT></P>
		</OL>
		<LI><P STYLE="margin-top: 0.08in"><FONT FACE="Times New Roman, serif"><FONT SIZE=3>But,
		if you sign up for a tout service, such as the Power Sweep
		Newsletter or one of those "Call 1-800-Win-Big and we'll give
		you our super-mega lock of the year" phone numbers, you're
		taking this thing way too seriously and you're a weenie.</FONT></FONT></P>
	</OL>
</OL>
    
	
	<cfinclude template="footer.cfm">

</body>    