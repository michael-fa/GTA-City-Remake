// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/utils.pwn
//      Description:    Scheiß den nirgenswo anders zuorden KANN | WILL.



#define noaccess SendClientMessage(playerid, GREY, "* Du hast keinen Zugriff auf diesen Befehl.")


#if !defined isnull
    #define isnull(%1) \
                ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

//(C) lp_ just a part of scripts intern stuff
dpublic:InMenuFix(menu, playerid)
{
    SetPVarInt(playerid, "MenuCloseFix", 0);
    TogglePlayerControllable(playerid, true);
    HideMenuForPlayer(Menu:menu, playerid);
    return true;
}




//(C) lp_ just a part of scripts intern menu stuff too small to make file
stock HideMenuEx(menu, playerid) { SetTimerEx_("InMenuFix", 400, 0, 1, "ii", menu, playerid); }
stock MenuFixActive(playerid)
{
    if(GetPVarInt(playerid, "MenuCloseFix") == 1)
        return true;
    else return false;
}




stock RankToPerm(playerid)
{
    switch(pInfo[playerid][rank])
    {
        case PLAYER:return 0; //@players.pwn
        case SUPPORTER:return PERM_SUPPORTER;  //@players.pwn
        case ADMIN:return PERM_ADMIN | PERM_SUPPORTER;  //@players.pwn
        case HEAD_ADMIN:return PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER;  //@players.pwn
        case PROJEKTLEITER:return PERM_PROJLEITER | PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER;  //@players.pwn
    }
    return PERM_PLAYER;  //@players.pwn
}

stock Rank:IntRank(int)
{
    switch(int)
    {
        case 0:return PLAYER;
        case 1:return SUPPORTER;
        case 2:return ADMIN;
        case 3:return HEAD_ADMIN;
        case 4:return PROJEKTLEITER;
    }
    return PLAYER;
}

stock PlayerRank(playerid) {
    new tmp[32];
    tmp = ("Spieler");
    switch(pInfo[playerid][rank])
    {
        case PLAYER:tmp=("Spieler");
        case SUPPORTER:tmp=("Supporter");
        case ADMIN:tmp=("Admin");
        case HEAD_ADMIN:tmp=("Head Admin");
        case PROJEKTLEITER: tmp=("Projektleiter");
    }
    return tmp;
}


