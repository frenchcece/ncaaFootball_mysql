/*
http://ncaafootball.localhost/ncaaFootball/cfc/footballDao.cfc?method=getTeamStatsJsonFormat&teamID=2
*/

function validateGamePickForm(passForm)
{
	/*
	var inputs = document.getElementsByTagName('input');
	
	var checked = false;
	for(var i=0; i < inputs.length; i++)
	{
		if(inputs[i].type == 'radio' && inputs[i].checked == true)
			checked = true;				
	}
	
	if (!checked) {
		alert("You must select at least 1 game.");
		return false;
	}
	*/
	return true;
}

function validateNewPostForm(passForm)
{
	if(passForm.title.value == '')
	{
		alert("You must enter a title.");
		passForm.title.focus();
		return false;
	}

	if(passForm.message.value == '')
	{
		alert("You must enter a message");
		passForm.message.focus();
		return false;
	}

	return true;
}

function validateReplyForm(passForm)
{
	if(passForm.reply.value == '')
	{
		alert("You must enter a message");
		passForm.reply.focus();
		return false;
	}

	return true;
}

function clearGameRadioBtn(btn)
{
	var gameID = btn.value;
	var rad1 = document.getElementById('team1_'+gameID);
	rad1.checked = false;
	var rad2 = document.getElementById('team2_'+gameID);
	rad2.checked = false;
}

