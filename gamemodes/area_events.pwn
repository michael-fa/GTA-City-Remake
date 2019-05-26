//area_events.pwn - OnLeave & OnEnter code 
//COPYRIGHT 2019 © MICHAEL FA. for "rpg-city-remake"	


public OnPlayerEnterDynamicArea(playerid, areaid)
{
	//Is near biz circle?
	for(new i=0; i<MAX_BIZ; i++)
	{
		if(!Business[i][is_valid])continue;
		if(Business[i][area] == areaid)
		{
			SendClientMessage(playerid, WHITE, "AREA BETRETEN!");
			UpdateHunger(playerid, 100.0);
			break;
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	SendClientMessage(playerid, WHITE, "AREA verlassen ;(");
	return 1;
}