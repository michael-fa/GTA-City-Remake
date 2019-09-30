// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/hunger_bar.pwn
//      Description:    Funktionen für HungerBar
//		
//		Todo:  
//			- Spieler kann sich trainieren, wie lange er hungern kann. (wie weit er in den Minus bereich kann, bis er dann stirbt)

enum E_HungerBar {
	bool:init,
	bool:_render,
	PlayerBar:bar,
	Float:fCurrentValue
}	new A_HungerBar[MAX_PLAYERS][E_HungerBar];

stock RenderHungerBar(playerid, bool:ren)
{	
	A_HungerBar[playerid][_render]=ren;
	if(A_HungerBar[playerid][_render])
		ShowPlayerProgressBar(playerid, A_HungerBar[playerid][bar]);
	else HidePlayerProgressBar(playerid, A_HungerBar[playerid][bar]);
	return true;
}

// lp_: Funk um val zu verändern
stock UpdateHunger(playerid, Float:val)
{
	if(val < 0) //Starving mode | egal ob render 0|1 - er stirbt hier langsam beim je nach dem wie viel er Minus abkann.
	{
		//TODO: Check for certain skill-level  - takes longer to kill the player.
		SetPlayerHealth(playerid, GetPlayerHealthEx(playerid)-5);
		return false;
	}

	if(A_HungerBar[playerid][init])
	{
		__updateHunger_FIX__(playerid, val);
		SetPlayerProgressBarValue(playerid, A_HungerBar[playerid][bar], val);
		UpdatePlayerProgressBar(playerid, A_HungerBar[playerid][bar]);
		return true;
	}
	else return false;
}

// lp_: wir merken- hungerBar ist nach der init. erstmal "hidden".
stock InitHungerBar(playerid, Float:val) 
{
	A_HungerBar[playerid][init] = true;
	A_HungerBar[playerid][bar] = CreatePlayerProgressBar(playerid, 548.0000000, 47.000000, 59.0, 5.0, GREEN, 100.0);
	SetPlayerProgressBarValue(playerid, A_HungerBar[playerid][bar], val);
	HidePlayerProgressBar(playerid, A_HungerBar[playerid][bar]);
	return 1;
}