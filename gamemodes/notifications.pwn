// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/notifications.pwn
//      Description:    Zeit eine schöne (!) Benachrichtigung auf dem Bildschirm an.
//						Sollte bisjetzt nur im Tutorial genutzt werden. Vllt beim jobben auch oder so..


#define NOTIF_MAXC_L 37

new PlayerText:NotificationTds[MAX_PLAYERS][3];
new bool:_pHasNotification[MAX_PLAYERS];


stock ShowPlayerNotification(playerid, headtext[], maintext[], displayTime = 6)
{
	if(!(strlen(headtext)>0))return true;

	//äöü etc. fixen #zegermans
	FixTextDrawString(headtext);
	FixTextDrawString(maintext);

	if(_pHasNotification[playerid])
	{
		PlayerTextDrawSetString(playerid, NotificationTds[playerid][0], headtext);
		PlayerTextDrawSetString(playerid, NotificationTds[playerid][1], maintext);
		new t[30];
		gettime(t[0], t[1], t[2]);
		format(t, sizeof(t), "%02d:%02d", t[0], t[1]);
		PlayerTextDrawSetString(playerid, NotificationTds[playerid][2], t);
		KillTimer_(pTimerIDs[playerid][notification]);
		pTimerIDs[playerid][notification] = SetTimerEx_("HideNotification", displayTime * 1000, 0, 1, "ii", playerid);
		return true;
	}

	NotificationTds[playerid][0] = CreatePlayerTextDraw(playerid,15.000000, 266.000000, headtext);
	PlayerTextDrawBackgroundColor(playerid,NotificationTds[playerid][0], 0);
	PlayerTextDrawFont(playerid,NotificationTds[playerid][0], 3);
	PlayerTextDrawLetterSize(playerid,NotificationTds[playerid][0], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid,NotificationTds[playerid][0], 1347047679);
	PlayerTextDrawSetOutline(playerid,NotificationTds[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid,NotificationTds[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid,NotificationTds[playerid][0], 1);
	PlayerTextDrawUseBox(playerid,NotificationTds[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid,NotificationTds[playerid][0],  -7012241);
	PlayerTextDrawTextSize(playerid,NotificationTds[playerid][0], 132.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,NotificationTds[playerid][0], 0);

	NotificationTds[playerid][1] = CreatePlayerTextDraw(playerid, 15.000000, 278.000000, maintext);
	PlayerTextDrawBackgroundColor(playerid, NotificationTds[playerid][1], 255);
	PlayerTextDrawFont(playerid, NotificationTds[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, NotificationTds[playerid][1], 0.180000, 1.100000);
	PlayerTextDrawColor(playerid, NotificationTds[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid, NotificationTds[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, NotificationTds[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, NotificationTds[playerid][1], 1);
	PlayerTextDrawUseBox(playerid, NotificationTds[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, NotificationTds[playerid][1], 133);
	PlayerTextDrawTextSize(playerid, NotificationTds[playerid][1], 132.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid, NotificationTds[playerid][1], 0);

	new t[30];
	gettime(t[0], t[1], t[2]);
	format(t, sizeof(t), "%02d:%02d", t[0], t[1]);
	NotificationTds[playerid][2] = CreatePlayerTextDraw(playerid,119.000000, 265.000000, t);
	PlayerTextDrawBackgroundColor(playerid,NotificationTds[playerid][2], 0);
	PlayerTextDrawFont(playerid,NotificationTds[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid,NotificationTds[playerid][2], 0.130000, 0.699999);
	PlayerTextDrawColor(playerid,NotificationTds[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid,NotificationTds[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid,NotificationTds[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid,NotificationTds[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid,NotificationTds[playerid][2], 0);

	PlayerTextDrawShow(playerid, NotificationTds[playerid][0]);
	PlayerTextDrawShow(playerid, NotificationTds[playerid][1]);
	PlayerTextDrawShow(playerid, NotificationTds[playerid][2]);

	_pHasNotification[playerid] = true;
	pTimerIDs[playerid][notification] = SetTimerEx_("HideNotification", displayTime * 1000, 0, 1, "ii", playerid);
	return true;
}

dpublic:HideNotification(playerid, nid)
{
	if(!IsPlayerConnected(playerid))
	{
		_pHasNotification[playerid] = false;
		return 1;
	}
	_pHasNotification[playerid] = false;
	PlayerTextDrawDestroy(playerid, NotificationTds[playerid][0]);
	PlayerTextDrawDestroy(playerid, NotificationTds[playerid][1]);
	PlayerTextDrawDestroy(playerid, NotificationTds[playerid][2]);
	return true;
}