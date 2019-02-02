#include <a_samp>
#include <crashdetect>
#include <a_mysql>
#include <a_zones>
#include <streamer>
#include <ocmd>
#include <Dini>
#include <fixes2>

//Lazypawn collection by lp_
#include "lazypawn/main.cpp"

//Gamemode related
#include "/../../gamemodes/buildinfo.pwn" //always on top - DEBUG is set here!
#include "/../../gamemodes/common.pwn"
#include "/../../gamemodes/players.pwn" //before mysql - there's some mysql related code
#include "/../../gamemodes/mysql.pwn"
#include "/../../gamemodes/bikerental.pwn"
#include "/../../gamemodes/buildings.pwn"

//Maps
#include "/../../maps/rpg-city.pwn"

//Textdraw
#include "/../../gamemodes/textdraws/servertd.pwn"


main()
{
	print("\n[>] RPG City Gamemode ("#GM_VER" | "#GM_SAMPVER") by "#GM_DEVELOPER"");
	printf("   > BUILD ON %s,  %s", __date, __time);
	DebugPrint("   > !! DEBUG BUILD !!");
}


public OnGameModeInit()
{
	SetGameModeText("German Reallife");
	ConnectWithMySQL();
	ShowPlayerMarkers(false);
	DisableNameTagLOS();
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);

	//Maps
	LoadRPGCityMap();

	//Stuff
	LoadBikeRentals();

	//Buildings
	LoadBuildings();



	//==========================================================
	//Menüs (soweit das einzige was wir jemals nutzen aus nostalgischen Gründen)
	shmenu=CreateMenu("Stadthalle", 3, 232.000000, 175.000000, 150.0, 150.0);
	AddMenuItem(shmenu, 0, "Arbeitsamt");
	AddMenuItem(shmenu, 0, "Personalausweis");
	AddMenuItem(shmenu, 0, "Organistation erstellen");
	//AddMenuItem(stadthallenmenu, 0, "Sonderlizenzen erwerben");





	//==========================================================
	//              3DTEXTLABELS
	
	CreateDynamic3DTextLabel("Drücke ENTER", WHITE, 361.8299,173.5298,1008.3828, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VW_STADTHALLE, 3); //Stadthalle Tresen
	//CreateDynamic3DTextLabel(""#HTML_RED"Fahrschule\n"#HTML_WHITE"Drücke ENTER um die Prüfung zu starten!\n"#HTML_GOLDENYELLOW"Kosten:"#HTML_GREEN" 25.000$", WHITE,1169.8717,1353.3077,10.9219,20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);  //Fahrschule
	





	//==========================================================
	//              PICKUPS
	
	CreateDynamicPickup(1239, 0, 361.8299,173.5298,1008.3828, VW_STADTHALLE, 3); //Stadthalle Tresen
	//CreateDynamicPickup(1581, 0, 1169.8717,1353.3077,10.9219, 0, 0); //fahrschule




	//==========================================================
	//				Textdraws
	TD_ServerTD_Load(); //URL unter Radar; GTA-City Logo neben Wepicon;

	return 1;
}

public OnGameModeExit()
{
	DisconnectMySQL();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid))return true;
	if(!pInfo[playerid][loggedin])
	{
		ClearPlayerChat(playerid);
		TogglePlayerSpectating(playerid, true); //Remove spawn button
		//InLogin[playerid]=true;
		InterpolateCameraPos(playerid,1420.7859,-1626.6654,69.2661,1420.7859,-1626.6654,69.2661,1000, CAMERA_MOVE);
		InterpolateCameraLookAt(playerid,1486.6022,-1725.1429,13.5469,1486.6022,-1725.1429,13.5469,1000, CAMERA_MOVE);
		
		new query[128];
		mysql_format(dbhandle, query, sizeof(query), "SELECT id FROM accounts WHERE name = '%e'", PlayerName(playerid));
		mysql_pquery(dbhandle, query, "OnRegisterCheck", "d", playerid); //@ gamemodes/gtacity/mysql.pwn	
	}
	else
	{
		//Soweit nichts dazu kommt, direkt spawnen, weg hier!
	}
	
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid))return true;
	
	//Goosebumps activated
	PlayerPlaySound(playerid,1185,0.0,0.0,0.0);
	TextDrawShowForPlayer(playerid, ServerTD[0]);
	TextDrawShowForPlayer(playerid, ServerTD[1]);
	TextDrawShowForPlayer(playerid, ServerTD[2]);

	//reset all to 0
	memcpy(pInfo[playerid], DefaultPlayerArray, 0, sizeof(DefaultPlayerArray)*4, sizeof(pInfo[]));
	DebugPrint("loading buildings..");
	new _idx;
	for(new i=0; i<sizeof(Buildings); i++)
	{
		if(Buildings[i][mapicon]==-1)continue; //Nicht jedes Gebäude hat ein Mapicon.
		DebugPrint("Load building %d", i);
		Buildings[i][mapiconid] = _idx; //Um das Icon später noch mal wieder zu verwenden
		SetPlayerMapIcon(playerid, _idx, Buildings[i][enterx], Buildings[i][entery], Buildings[i][enterz], Buildings[i][mapicon], mapicon_color, MAPICON_LOCAL);
		_idx++;
	}

	//Weapon Skill like RPG-City
	for(new i=0; i<10; i++)SetPlayerSkillLevel(playerid, i, 1000);
	SetPlayerSkillLevel(playerid, 7, 998);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	//Save User to MySQL
	SaveUserData(playerid);

	//Reset Map Icons der Buildings[]...
	for(new i=0; i<sizeof(Buildings); i++)
	{
		if(Buildings[i][mapiconid]==0xC)continue; //Nicht jedes Gebäude hat ein Mapicon.
		RemovePlayerMapIcon(playerid, Buildings[i][mapiconid]);
	}

	//Hat er noch ein Fahrrad gemietet?
	if(IsValidVehicle(pRentalBike[playerid]))
		DestroyVehicle(pRentalBike[playerid]);



	//Stop all timers
	for(new i=0; i<sizeof(DefaultPTimerArray); i++)
		KillTimer_(pTimerIDs[playerid][ePTimers:i]);
	memcpy(pTimerIDs[playerid], DefaultPTimerArray, 0, 1, sizeof(pTimerIDs[]));


	ResetPlayerVars(playerid);

	return 1;
}

public OnPlayerSpawn(playerid)
{
	switch(pSpawnReason[playerid])
	{
		case SPAWN_LOGIN:
		{
			//Nach dem Login
		}
		case SPAWN_REGISTER:
		{
			//SF Bahnhof (wir rpg halt..)
			SetPlayerPos(playerid, 1760.9659,-1895.8420,13.5616);
			SetPlayerFacingAngle(playerid, 270.3469);

			//Wer hat dich geworben?
			new str[256];
			format(str, sizeof(str), "Hallo %s!\nAuf GTA-City können Spieler bei einer gewissen Anzahl an angeworbender Spieler coole Dinge freischalten.\nWurdest du von jemandem geworden, und weißt seinen Spielnamen?\n\nDann tippe ihn unten ein!", PlayerName(playerid));
			ShowPlayerDialog(playerid, DIALOG_UWU, DIALOG_STYLE_INPUT, "User werben User", str, "Okay!", "Schließen");
		}
		case SPAWN_SKINCHANGE_ZIVI:
		{
			ShowPlayerDialog(playerid, DIALOG_SEX, DIALOG_STYLE_MSGBOX, "Geschlecht wählen", "Auf GTA-City kannst du in eine Weibliche oder in eine Männliche Rolle schlüpfen.\nBitte gib an, welches du für deinen Charakter möchtest.", "Weiblich" ,"Männlich");
			//Er kann sich nen neuen ZiviSkin aussuchen!
			SetPlayerCameraPos(playerid, 442.8635,-1753.2231,10.0265);
			SetPlayerCameraLookAt(playerid,437.9092,-1749.2146,9.0265);
			SendClientMessage(playerid,-1,"{FFFFFF}Du kannst den Skin mit der {FF3C00}Shift{FFFFFF} Taste wechseln.");
			SendClientMessage(playerid,-1,"{FFFFFF}Mit der {FF3C00}Enter{FFFFFF} Taste wählst du den Skin aus.");
			TogglePlayerControllable(playerid, false);
		}
		default: KickEx(playerid, "Du spawnst mit falscher Intention!");
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) // Player entered a vehicle as a driver
	{
		//Fahrräder haben bei uns keine Motoren! Keine!
		if(IsABike(GetPlayerVehicleID(playerid)))
			ToggleVehicleEngine(GetPlayerVehicleID(playerid));
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(pDisableCheckPointOnEnter[playerid])
		DisablePlayerCheckpoint(playerid),PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	//Wir gehen hier wild davon aus dass nur ein einziges Menü vom Spieler genutzt werden kann - Stadthalle.
	TogglePlayerControllable(playerid, true);
	switch(row)
	{
		case 0: //Perso
		{
			if(pInfo[playerid][perso]==1)
				SendClientMessage(playerid, GREY, "* Du besitzt schon einen Personalausweis."), ShowMenuForPlayer(shmenu, playerid), spv(playerid, "MenuCloseFix", 1);
			else
			{
				pInfo[playerid][perso]=1;
				SendClientMessage(playerid, CYAN, "* Du hast dir einen Personalausweis besorgt.");
				//ShowNotificationToPlayer(playerid, "Stadthalle", "Du hast dir einen Personalausweis besorgt.", 6); Maybe featured later!
				HideMenuEx(_:shmenu, playerid);
			}
		}
	}
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	HideMenuEx(_:shmenu, playerid);
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

	//Near bike rental
	if(NearestBikeRental(playerid)!=INVALID_BIKE_RENTAL && RELEASED(KEY_SECONDARY_ATTACK))
	{
		if(pInfo[playerid][level]>4)return SendClientMessage(playerid, GREY, "Nur Spieler unter Level 4 können sich Fahrräder mieten.");
		if(pRentalBike[playerid]!=INVALID_VEHICLE_ID || IsValidVehicle(pRentalBike[playerid]))
		{
			//Bringen wir dem Spieler ruhig mal das fahrrad, somit können sie das Fahrrad tatsächlich immer nutzen wenn sie es brauchen
			//later sogar gut wenn man mehrere points hat kann man immer den lokalsten anfinden wenn man es nicht findet
			new basic_floats, Float:ang;
			GetPlayerPos(playerid, x,y,z);
			GetXYInFrontOfPlayer(playerid, x,y,4.0);
			GetPlayerFacingAngle(playerid, ang);
			SetVehicleZAngle_(pRentalBike[playerid], ang); 
			SetVehiclePos(pRentalBike[playerid], x,y,z);
			SetPlayerCheckpoint(playerid, x,y,z, 1.0);
			pDisableCheckPointOnEnter[playerid] = true;
			SendClientMessage(playerid, GREY, "Du hast schon ein Fahrrad gemietet. Es wurde zu dir gebracht.");
			return true;
		}

		if(GetPlayerMoney(playerid)<BikeRental[NearestBikeRental(playerid)][price])return SendClientMessage(playerid, GREY, "Du hast nicht genügend Geld dabei.");
		GivePlayerMoney(playerid, -BikeRental[NearestBikeRental(playerid)][price]);
		pRentalBike[playerid]=CreateVehicle(481, 1776.5442,-1890.0557,13.3868,281.1611, -1, -1, 900); //15 Minuten
		PutPlayerInVehicle(playerid, pRentalBike[playerid], 0);
		ToggleVehicleEngine(GetPlayerVehicleID(playerid));//Dann kann er direkt los fahren (müsste erst absteigen um statechange event zu triggern)
		pTimerIDs[playerid][bikerental]=SetTimerEx_("BikeRentalEnd", 900*1000, 0, 1, "i", playerid);
		SendClientMessage(playerid, YELLOW, "* Du hast dir ein BMX für 15 Minuten gemietet.");
	}
	

	switch(pInSkinChange[playerid])
	{
		//After registration
		case 1:
		{
			if(RELEASED(KEY_JUMP))
			{
				//Forward
				if(pInfo[playerid][sex]==0)
				{
					pSkinSelIndex[playerid]++;
					if(pSkinSelIndex[playerid]==strlen(ZiviSkins_M)-1)
						pSkinSelIndex[playerid]=0;
					SetPlayerSkin(playerid, ZiviSkins_M[pSkinSelIndex[playerid]]);
				}
				else
				{
					pSkinSelIndex[playerid]++;
					if(pSkinSelIndex[playerid]==strlen(ZiviSkins_W)-1)
						pSkinSelIndex[playerid]=0;
					SetPlayerSkin(playerid, ZiviSkins_W[pSkinSelIndex[playerid]]);
				}
			}

			if(RELEASED(KEY_SPRINT))
			{
				//Backwards
				if(pInfo[playerid][sex]==0)
				{
					pSkinSelIndex[playerid]--;
					if(pSkinSelIndex[playerid]==0)
						pSkinSelIndex[playerid]=strlen(ZiviSkins_M)-1;
					SetPlayerSkin(playerid, ZiviSkins_M[pSkinSelIndex[playerid]]);
				}
				else
				{
					pSkinSelIndex[playerid]--;
					if(pSkinSelIndex[playerid]==0)
						pSkinSelIndex[playerid]=strlen(ZiviSkins_W)-1;
					SetPlayerSkin(playerid, ZiviSkins_W[pSkinSelIndex[playerid]]);
				}
			}

			if(RELEASED(KEY_SECONDARY_ATTACK))
			{
				//Finished
				pSkinSelIndex[playerid] = 0;
				pInSkinChange[playerid] = 0;
				pInfo[playerid][ziviskin] = GetPlayerSkin(playerid);
				TogglePlayerSpectating(playerid, false);
				//Now set him as first spawned after register - so right stuff is happenin to him
				pSpawnReason[playerid] = SpawnReason:SPAWN_REGISTER;
				SetCameraBehindPlayer(playerid);
				SetSpawnInfo(playerid, 0, pInfo[playerid][ziviskin], 1760.9659,-1895.8420,13.5616, 270.3469, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
		}
	}

	//Buildings
	for(new i=0; i<sizeof(Buildings); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.3, Buildings[i][enterx],Buildings[i][entery],Buildings[i][enterz]) && PRESSED(KEY_SECONDARY_ATTACK))
		{
			pInBuilding[playerid]=i;
			SetPlayerPos(playerid, Buildings[i][exitx],Buildings[i][exity],Buildings[i][exitz]);
			SetPlayerFacingAngle(playerid, Buildings[i][exitr]);
			SetPlayerVirtualWorld(playerid, Buildings[i][vworldin]);
			SetPlayerInterior(playerid, Buildings[i][intin]);
			SetCameraBehindPlayer(playerid);
			TimedFreeze(playerid, 400);
			
			switch(_:Buildings[i][btype])
			{
				case BUILDING_FRAK:
				{
					
				}
				case BUILDING_FASTFOOD:
				{
					
				}
				case BUILDING_BANK:
				{
					
				}
			}
			break;
		}
		
		else if(IsPlayerInRangeOfPoint(playerid, 2.3, Buildings[i][exitx],Buildings[i][exity],Buildings[i][exitz]) && PRESSED(KEY_SECONDARY_ATTACK))
		{
			pInBuilding[playerid]=Buildings[i][buildingidout];
			SetPlayerPos(playerid, Buildings[i][enterx],Buildings[i][entery],Buildings[i][enterz]);
			SetPlayerFacingAngle(playerid, Buildings[i][enterr]);
			SetPlayerVirtualWorld(playerid, Buildings[i][vworldout]);
			SetPlayerInterior(playerid, Buildings[i][intout]);
			SetCameraBehindPlayer(playerid);
			TimedFreeze(playerid, 1000);
			break;
		}
	}

	//Stadthalle Tresen 
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 361.8299,173.5298,1008.3828) && !MenuFixActive(playerid) && PRESSED(KEY_SECONDARY_ATTACK))
	{
		TogglePlayerControllable(playerid, false);
		ShowMenuForPlayer(shmenu, playerid), spv(playerid, "MenuCloseFix", 1);
	}

	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
	else PlayerPlaySound(playerid,1084,0.0,0.0,0.0);
	
	switch(dialogid)
	{
		case DIALOG_REGISTER:
		{
			//Inputfeld wurde leer gelassen, oder die eingabe ist zu kurz/lang. (6 - MAX_PASSWORD_LEN zeichen)
			if(!response || !strlen(inputtext) || strlen(inputtext)<6 || strlen(inputtext)>MAX_PASSWORD_LEN)return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "GTA-City Reallife", "{FFFFFF}Willkommen auf GTA-City Reallife!\nEin Account mit diesem Namen wurde nicht gefunden.\nGib ein Passwort ein, um dich mit diesem Namen zu registrieren.\n{E10000}ACHTUNG: Gib dein Passwort nie an andere Spieler weiter! Auch nicht an Admins!", "Ok", "Abbrechen");
			
			new hashed_pass[65], salt[MAX_PASSWORD_LEN], query[400], tmp_ip[22];
			GenerateSalt(salt, strlen(inputtext));
			SHA256_PassHash(inputtext, salt, hashed_pass, 65);
			NetStats_GetIpPort(playerid, tmp_ip, sizeof tmp_ip);
			mysql_format(dbhandle, query, sizeof(query), "INSERT INTO accounts (name, password, salt, last_seen, last_ip) VALUES ('%e', '%e', '%e', '%d', '%e')",
			PlayerName(playerid), hashed_pass, salt, gettime(), tmp_ip);
			mysql_query(dbhandle, query);
			
			





			//Zum beginn vielleicht noch extra ein paar sachen setzen
			pInfo[playerid][db_id]=cache_insert_id();
			pInfo[playerid][loggedin]=true;
			pInfo[playerid][regdate]=gettime();
			pInfo[playerid][adminlevel] = 0;
			pInfo[playerid][sex] = 0;
			pInfo[playerid][ziviskin] = ZiviSkins_M[0];
			pInfo[playerid][money]=STARTMONEY, GivePlayerMoney(playerid, STARTMONEY);
			pInfo[playerid][bank]=STARTMONEYBANK;
			pInfo[playerid][level] = 0;
			pInfo[playerid][respekt] = 0;
			pInfo[playerid][loggedin]=true;
			pInfo[playerid][players_advertised]=0;
			pInfo[playerid][perso] = 0;
			pInfo[playerid][job] = 0;

			//Login track
			StopPlayerSound(playerid);



			
			//Set spawn info - Positionen dort, wo er bei der Skinauswahl stehen soll!!
			SetSpawnInfo(playerid, 0, ZiviSkins_M[0], 437.9092,-1749.2146,9.0265,226.3349, 0,0, 0,0, 0,0);
			pSpawnReason[playerid] = SpawnReason:SPAWN_SKINCHANGE_ZIVI;
			pInSkinChange[playerid] = 1; //After register
			TogglePlayerSpectating(playerid, false); 
		}
		
		
		case DIALOG_LOGIN:
		{
			
			//Inputfeld wurde leer gelassen, oder die eingabe ist zu kurz/lang.
			if(!response || !strlen(inputtext) || strlen(inputtext)<6 || strlen(inputtext)>MAX_PASSWORD_LEN)return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "GTA-City", "{FFFFFF}Willkommen auf GTA-City Reallife!\nDein Account wurde in der Datenbank gefunden.\nGib dein Passwort niemals weiter. Auch nicht an Admins oder Supporter!\nDu kannst dich nun einloggen. Bitte gib ein Passwort ein:", "Ok", "Abbrechen");
			
			//Daten aus Tabelle laden (Wird aber nur für den Salt und das PW genutzt!)
			new query[400];
			mysql_format(dbhandle, query, sizeof(query), "SELECT * FROM accounts WHERE name = '%e'", PlayerName(playerid));
			mysql_query(dbhandle, query);
			
			//Check
			new rows;
			cache_get_row_count(rows);
			if(rows==0)
				return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "GTA-City", "{FFFFFF}Willkommen auf GTA-City Reallife!\nDein Account wurde in der Datenbank gefunden.\nGib dein Passwort niemals weiter. Auch nicht an Admins oder Supporter!\nDu kannst dich nun einloggen. Bitte gib ein Passwort ein:", "Ok", "Abbrechen");


			//Gesaltetes Passwort "generieren"
			new salt[MAX_PASSWORD_LEN], get_hash[65], hashed_pass[65];
			cache_get_value_name(0, "salt", salt);
			cache_get_value_name(0, "password", get_hash);
			SHA256_PassHash(inputtext, salt, hashed_pass, 65);
			//Input == Accountpsw?
			if(strcmp(hashed_pass, get_hash))
			{
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "GTA-City", "{FFFFFF}Willkommen auf GTA-City Reallife!\nDein Account wurde in der Datenbank gefunden.\nGib dein Passwort niemals weiter. Auch nicht an Admins oder Supporter!\nDu kannst dich nun einloggen. Bitte gib ein Passwort ein:", "Ok", "Abbrechen");
				if(pLoginTries[playerid]>=4) 
				{
					ShowPlayerDialog(playerid, -1, 0, "", "", "", "");
					SendClientMessage(playerid, WHITE, ""#HTML_DARKRED"Du wurdest gekickt! Grund: 4/4 Loginversuche!");
					return KickEx(playerid);
				}
				return true;
			}
			
			//Einloggen!
			cache_get_value_name_int(0, "id", pInfo[playerid][db_id]);
			cache_get_value_name_int(0, "regdate", pInfo[playerid][regdate]);
			cache_get_value_name_int(0, "adminlevel", pInfo[playerid][adminlevel]);
			cache_get_value_name_int(0, "money", pInfo[playerid][money]), GivePlayerMoney(playerid, pInfo[playerid][money]);
			cache_get_value_name_int(0, "bank", pInfo[playerid][bank]);
			cache_get_value_name_int(0, "ziviskin", pInfo[playerid][ziviskin]);
			cache_get_value_name_int(0, "level", pInfo[playerid][level]);
			cache_get_value_name_int(0, "respekt", pInfo[playerid][respekt]);
			cache_get_value_name_int(0, "players_advertised", pInfo[playerid][players_advertised]);
			cache_get_value_name_int(0, "perso", pInfo[playerid][perso]);
			cache_get_value_name_int(0, "job", pInfo[playerid][job]);
			pInfo[playerid][loggedin]=true;






			//Normal spawnen (haus, frak usw)
			pSpawnReason[playerid] = SpawnReason:SPAWN_LOGIN;
			StopPlayerSound(playerid);//Login track

			SetSpawnInfo(playerid, 0, pInfo[playerid][ziviskin], 1760.9659,-1895.8420,13.5616, 270.3469, 0,0, 0,0, 0,0);
			TogglePlayerSpectating(playerid,false);
		}

		case DIALOG_SEX:
		{
			switch(response)
			{
				case 0:SetPlayerSkin(playerid, ZiviSkins_M[0]);
				case 1:SetPlayerSkin(playerid, ZiviSkins_W[0]);
			}
			pInfo[playerid][sex] = response;	
		}

		case DIALOG_UWU:
		{
			if(!response)return SendClientMessage(playerid, WHITE, "* Du hast angegeben, dass du von niemandem geworben wurdest.");
			if(!strlen(inputtext))
			{
				new str[390];
				format(str, sizeof(str), "FEHLER: Bitte gebe unten im Textfeld einen Namen an.\nHallo %s!\nAuf GTA-City können Spieler bei einer gewissen Anzahl an angeworbender Spieler coole Dinge freischalten.\nWurdest du von jemandem geworden, und weißt seinen Spielnamen?\n\nDann tippe ihn unten ein!", PlayerName(playerid));
				ShowPlayerDialog(playerid, DIALOG_UWU, DIALOG_STYLE_INPUT, "User werben User", str, "Okay!", "Schließen");
			}
			new query[128], rows;
			mysql_format(dbhandle, query, sizeof(query), "SELECT * FROM accounts WHERE name = '%e'", inputtext);
			mysql_query(dbhandle, query);
			cache_get_row_count(rows);
			if(rows==0){
				new str[390];
				format(str, sizeof(str), "FEHLER: Der Spieler %s hat noch nicht auf diesen Server gespielt.\nHallo %s!\nAuf GTA-City können Spieler bei einer gewissen Anzahl an angeworbender Spieler coole Dinge freischalten.\nWurdest du von jemandem geworden, und weißt seinen Spielnamen?\n\nDann tippe ihn unten ein!", inputtext, PlayerName(playerid));
				ShowPlayerDialog(playerid, DIALOG_UWU, DIALOG_STYLE_INPUT, "User werben User", str, "Okay!", "Schließen");
			}
			else
			{
				//query == str | I re-use it.
				format(query, sizeof(query), "* Du hast angegeben, von "#HTML_YELLOW"%s"#HTML_WHITE" angeworben zu sein.", inputtext);
				SendClientMessage(playerid, WHITE, query);
				new pid = ReturnPlayerID(inputtext);
				if(pid!=INVALID_PLAYER_ID && IsPlayerConnected(pid) && pInfo[playerid][loggedin])
				{
					format(query,sizeof(query), "* Der Spieler "#HTML_YELLOW"%s"#HTML_WHITE" hat angegeben, durch dich angeworben zu worden.", PlayerName(playerid));
					SendClientMessage(pid, WHITE, query);
					pInfo[pid][players_advertised]++;
				}
				else {
					//Is offline, müssen dem so in der db einen neuen setzen
					mysql_format(dbhandle, query, sizeof(query), "UPDATE accounts SET players_advertised = players_advertised +1 WHERE name = '%e'", inputtext);
					mysql_query(dbhandle, query);
				}

			}

		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

