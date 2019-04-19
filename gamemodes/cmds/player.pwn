// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/cmds/supporter.pwn
//      Description:    Alle normalen Spielbefehle und Befehle für Spieler halt.



ocmd:o(playerid, params[])
{
	new txt[210];
	if(sscanf(params, "s", txt))return SendClientMessage(playerid, WHITE, "Verwendung: /o (Nachricht)");
	if(isnull(txt))return SendClientMessage(playerid, WHITE, "Verwendung: /o (Nachricht)");
	if(!IsSupporter(playerid) && ! bOOC)
		SendClientMessage(playerid, GREY, "* OOC ist momentan abgeschaltet.");
	else
	{
		new str[260];
		switch(pInfo[playerid][rank])
		{
			case 0:format(str,sizeof(str), "( [{00FF1E}OOC{FFFFFF}]: {FFFFFF}%s %s: {FFFFFF}%s )", PlayerRank(playerid), PlayerName(playerid), txt);
			case 1:format(str,sizeof(str), "( [{00FF1E}OOC{FFFFFF}]: {FFBE00}%s %s: {FFFFFF}%s )", PlayerRank(playerid), PlayerName(playerid), txt);
			case 2:format(str,sizeof(str), "( [{00FF1E}OOC{FFFFFF}]: {FF0000}%s %s: {FFFFFF}%s )", PlayerRank(playerid), PlayerName(playerid), txt);
			case 3:format(str,sizeof(str), "( [{00FF1E}OOC{FFFFFF}]: {A50000}%s %s: {FFFFFF}%s )", PlayerRank(playerid), PlayerName(playerid), txt);
			case 4:format(str,sizeof(str), "( [{00FF1E}OOC{FFFFFF}]: {00AFFF}%s %s: {FFFFFF}%s )", PlayerRank(playerid), PlayerName(playerid), txt);
		}
		SendClientMessageToAll(WHITE, str);
	}
	return 1;	
}