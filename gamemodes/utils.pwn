// 2018 GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/utils.pwn
//      Description:    Dump for functions I use throughout developement





//(C) lp_ just a part of scripts intern stuff
dpublic:InMenuFix(menu, playerid)
{
    SetPVarInt(playerid, "MenuCloseFix", 0);
    TogglePlayerControllable(playerid, true);
    HideMenuForPlayer(Menu:menu, playerid);
    return true;
}




//(C) lp_ just a part of scripts intern menu stuff
stock HideMenuEx(menu, playerid) { SetTimerEx_("InMenuFix", 400, 0, 1, "ii", menu, playerid); }
stock MenuFixActive(playerid)
{
    if(GetPVarInt(playerid, "MenuCloseFix") == 1)
        return true;
    else return false;
}




//(C) lp_ just a part of scripts intern DEBUG stuff
#if defined DEBUG
ocmd:pos(playerid, params[])
{
    new basic_floats;
    if(sscanf(params, "fff", x,y,z))return SendClientMessage(playerid, WHITE, "params: x,y,z");
    SetPlayerPos(playerid, x,y,z);
    return true;
}
#endif



