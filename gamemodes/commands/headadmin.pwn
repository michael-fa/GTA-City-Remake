// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/commands/headadmin.pwn
//      Description:    Befehle für leitende Administratoren


ocmd:supcommand(playerid, params[])
{
	if(!(pPermissions[playerid] >= PERM_SUPPORTER))return noaccess;
	return 1;
}

ocmd:makeadmin(playerid, params[])
{
	if(!(pPermissions[playerid] >= PERM_HEAD_ADMIN | PERM_ADMIN | PERM_SUPPORTER))return noaccess;
	new pid, _rank;
	if(sscanf(params, "ui", pid, _rank))return SendClientMessage(playerid, WHITE, "Verwendung: /makeadmin [Spieler] [Rang Nummer]");
	if(_rank<0 || _rank > 4)return SendClientMessage(playerid, GREY, "* Falsche Rang Nummer, versuche 0-4.");
	if(_rank>=_:pInfo[playerid][rank])return SendClientMessage(playerid, GREY, "* Du kannst nur Ränge unter dir verteilen.");
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
