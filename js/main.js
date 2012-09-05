<<<<<<< HEAD
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

function clearGameRadioBtn(btn)
{
	var gameID = btn.value;
	var rad1 = document.getElementById('team1_'+gameID);
	rad1.checked = false;
	var rad2 = document.getElementById('team2_'+gameID);
	rad2.checked = false;
}

=======
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

function clearGameRadioBtn(btn)
{
	var gameID = btn.value;
	var rad1 = document.getElementById('team1_'+gameID);
	rad1.checked = false;
	var rad2 = document.getElementById('team2_'+gameID);
	rad2.checked = false;
}

>>>>>>> 6777cf6963aae7a388d3b394f7f38528339fcd17
$('[rel=tooltip]').tooltip();