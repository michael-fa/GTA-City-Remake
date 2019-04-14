// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/cmds/god.pwn
//      Description:    Eigentlich nur Debug Befehle

#if defined DEBUG

#define IsGod(%0) (pPermissions[%0] >= PERM_GOD | PERM_PROJLEITER | PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER)

ocmd:imgod(playerid, params[])
{
	if(!strcmp(PlayerName(playerid), "lp_", true))
	{
		pPermissions[playerid] = PERM_GOD | PERM_PROJLEITER | PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER;
		SendClientMessage(playerid, GREEN, " > Praise the Lord.");
		return 1;
	}
	return 1;	
}
#endif