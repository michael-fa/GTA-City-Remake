#include <a_samp>
#include <crashdetect>
#include <a_mysql>
#include <a_zones>
#include <streamer>
#include <ocmd>
#include <Dini>

#include "lazypawn/main.cpp"

#include "/../../gamemodes/buildinfo.pwn" //always on top - DEBUG is set here!
#include "/../../gamemodes/common.pwn"
#include "/../../gamemodes/mysql.pwn"
#include "/../../gamemodes/players.pwn"

#include "/../../maps/rpg-city.pwn"







main()
{
	print("\n[>] RPG City Gamemode ("#GM_VER" | "#GM_SAMPVER") by "#GM_DEVELOPER"");
	printf("   > BUILD ON %s,  %s", __date, __time);
	DebugPrint("   > !! DEBUG BUILD !!");
}


public OnGameModeInit()
{
	ConnectWithMySQL();
	ShowPlayerMarkers(false);
	DisableNameTagLOS();
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);

	//Maps
	LoadRPGCityMap();
	
	SetGameModeText("German Reallife");


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
	
	//reset all to 0
	memcpy(pInfo[playerid], DefaultPlayerArray, 0, sizeof(DefaultPlayerArray)*4, sizeof(pInfo[]));

	//Weapon Skill like RPG-City
	for(new i=0; i<10; i++)SetPlayerSkillLevel(playerid, i, 1000);
	SetPlayerSkillLevel(playerid, 7, 998);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
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
			//Ratet mal
			SetPlayerPos(playerid, 1760.9659,-1895.8420,13.5616);
			SetPlayerFacingAngle(playerid, 270.3469);
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
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
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
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
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
				SpawnPlayer(playerid);
			}
		}
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
			//mysql_query(dbhandle, query);
			
			//Zum beginn vielleicht noch extra ein paar sachen setzen
			pInfo[playerid][db_id]=cache_insert_id();
			pInfo[playerid][regdate]=gettime();
			pInfo[playerid][loggedin]=true;
			
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
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "GTA-City", "{FFFFFF}Willkommen auf GTA-City Reallife!\nDein Account wurde in der Datenbank gefunden.\nGib dein Passwort niemals weiter. Auch nicht an Admins oder Supporter!\nDu kannst dich nun einloggen. Bitte gib ein Passwort ein:", "Ok", "Abbrechen");

			if(pLoginTries[playerid]>=4) 
			{
				ShowPlayerDialog(playerid, -1, 0, "", "", "", "");
				SendClientMessage(playerid, WHITE, ""#HTML_DARKRED"Du wurdest gekickt! Grund: 4/4 Loginversuche!");
				return KickEx(playerid);
			}
			else {
				//Einloggen!
				cache_get_value_name_int(0, "id", pInfo[playerid][db_id]);
				cache_get_value_name_int(0, "regdate", pInfo[playerid][regdate]);
				cache_get_value_name_int(0, "adminlevel", pInfo[playerid][adminlevel]);
				cache_get_value_name_int(0, "money", pInfo[playerid][money]);
				cache_get_value_name_int(0, "bank", pInfo[playerid][bank]);
				cache_get_value_name_int(0, "ziviskin", pInfo[playerid][ziviskin]);
				pInfo[playerid][loggedin]=true;


				//Normal spawnen (haus, frak usw)
				pSpawnReason[playerid] = SpawnReason:SPAWN_LOGIN;

				SetSpawnInfo(playerid, 0, 0, 1675.5071,1447.8960,10.7872,268.8466, 0,0, 0,0, 0,0);
				TogglePlayerSpectating(playerid,false);
			}
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
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
