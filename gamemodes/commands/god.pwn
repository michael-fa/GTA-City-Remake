// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/commands/headadmin.pwn
//      Description:    Eigentlich nur Debug Befehle

#if defined DEBUG
ocmd:mmg(playerid, params[])

	
	if(!strcmp(PlayerName(playerid), "lp_", true))
	{
		pPermissions[playerid] = PERM_GOD;
		SendClientMessage(playerid, GREEN, " > Praise the Lord.");
		return 1;
	}
	return 1;
	
}#endif