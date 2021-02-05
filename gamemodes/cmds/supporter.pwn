// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/cmds/supporter.pwn
//      Description:    Befehle für min. Supporter

#define IsSupporter(%0) (pPermissions[%0] >= PERM_SUPPORTER) || IsPlayerAdmin(playerid)

ocmd:ooc(playerid, params[])
{
	if(!IsSupporter(playerid))return noaccess;
	if(bOOC)bOOC = false;
	else bOOC = true;
	new str[128];
	format(str,sizeof(str), "Der öffentliche /o - Chat wurde {00FF1E}%s{FFFFFF}.", bOOC ? ("{00FF1E}angeschaltet{FFFFFF}") : ("{FF002D}abgeschaltet{FFFFFF}"));
	SendClientMessageToAll(WHITE, str);
	return 1;
}