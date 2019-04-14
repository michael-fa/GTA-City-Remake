// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/cmds/headadmin.pwn
//      Description:    Befehle für leitende Administratoren


#define IsHeadAdmin(%0) (pPermissions[%0] >= PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER)

ocmd:makeadmin(playerid, params[])
{
	if(!IsHeadAdmin(playerid))return noaccess;
	new pid, _rank;
	if(sscanf(params, "ui", pid, _rank))return SendClientMessage(playerid, WHITE, "Verwendung: /makeadmin [Spieler] [Rang Nummer]");
	if(_rank<0 || _rank > 4)return SendClientMessage(playerid, GREY, "* Falsche Rang Nummer, versuche 0-4.");
	if((_rank>=_:pInfo[playerid][rank]) && !IsGod(playerid))return SendClientMessage(playerid, GREY, "* Du kannst nur Ränge unter dir verteilen.");
	if(!PlayerOnline(pid))return SendClientMessage(playerid, GREY, "* Der angegebene Spieler ist nicht online.");
	pInfo[pid][rank] = IntRank(_rank);
	pPermissions[pid] = RankToPerm(playerid);
	new str[128];
	format(str, sizeof str, "%s %s hat deinen Rang zu %s geändert.", PlayerRank(playerid), PlayerName(playerid), PlayerRank(pid));
	SendClientMessage(pid, YELLOW, str);
	format(str, sizeof str, "Du hast den Rang von %s zu %s geändert.", PlayerName(pid), PlayerRank(pid));
	SendClientMessage(playerid, GREEN, str);
	return 1;
}

ocmd:cbiz(playerid, params[])
{
	if(!IsHeadAdmin(playerid))return noaccess;
	new _btype;
	if(sscanf(params, "i", _btype))return SendClientMessage(playerid, WHITE, "Verwendung: /cbiz [Typ des Geschäftes, 0 = BIZ_SHOP, 1 = BIZ_AMMUNATION]");
	if(GetPlayerInterior(playerid) != 0)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich nicht in einem Interior setzen!");
	if(GetPlayerVirtualWorld(playerid) != 0)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich NUR in der VW 0 erstellen.");
	if(pInBuilding[playerid]!=-1)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich nicht innerhalb Gebäude erstellen.");

	new Float:vec[4];
	GetPlayerPos(playerid, vec[0], vec[1], vec[2]);
	GetPlayerFacingAngle(playerid, vec[3]);
	CreateBusiness(1337, BIZ_SHOP, 0, vec);

	/*DeletePVar(playerid, "CBIZ_TYPE");
	DeletePVar(playerid, "CBIZ_PRICE");
	DeletePVar(playerid, "CBIZ_INTERIOR");
	switch(_btype)
	{
		case 0:{
			//Shop
			//ShowPlayerDialog(playerid, DIALOG_CBIZ, )
		}
	}*/
	return true;
}

ocmd:dbiz(playerid, params[])
{
	if(!IsHeadAdmin(playerid))return noaccess;
	if(GetPlayerInterior(playerid) != 0)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich nicht in einem Interior löschen!");
	if(GetPlayerVirtualWorld(playerid) != 0)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich NUR in der VW 0 löschen.");
	if(pInBuilding[playerid]!=-1)return SendClientMessage(playerid, GREY, "* Geschäfte lassen sich nicht innerhalb Gebäude löschen.");
	if(GetNearestBusiness(playerid)==-1)return SendClientMessage(playerid, GREY, "* Es ist kein Geschäft in der Nähe.");
	DeleteBusiness(GetNearestBusiness(playerid));
	return true;
}