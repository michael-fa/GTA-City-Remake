// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/mysql.pwn
//      Description:    Alles was mit MYSQL zusammen arbeitet.

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_DATA "gtacity" 


new MySQL:dbhandle;
new gmysql_tries = 0;



stock ConnectWithMySQL()
{
	printf(" [MYSQL] Datenbankverbindung wird hergestellt..");
	dbhandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);
	while(mysql_errno(dbhandle)!=0 && gmysql_tries < 3)
	{
		gmysql_tries++;
		printf(" [MYSQL] Verbindung fehlgeschlagen nach %d. Versuch!", gmysql_tries);
		dbhandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);
	}
	if(mysql_errno(dbhandle)==0)printf(" [MYSQL] Verbindung zur Datenbank hergestellt! Handle: %d", _:dbhandle);
	else {
		print(" [MYSQL] Verbindung konnte nicht hergestellt werden!\nSERVER WIRD HERUNTERGEFAHREN!");
		SendRconCommand("exit");
	}
	return true;
}

stock DisconnectMySQL()
{
	printf(" [MYSQL] Verbindung wurde geschlossen!");
	mysql_close(dbhandle);
}


stock LoadGameModeSettings()
{
	new query[256];
	mysql_format(dbhandle, query, sizeof(query), "SELECT * FROM gamemode");
	mysql_query(dbhandle, query);
	cache_get_value_name_int(0, "staatskasse", CFG[staatskasse]);
	cache_get_value_name_int(0, "license_price_0", CFG[license_price_0]);
	return true;
}

stock SaveGameModeSettings()
{
	new query[256];
	mysql_format(dbhandle, query, sizeof(query), "UPDATE gamemode SET \
		staatskasse = '%d', \
		license_price_0 = '%d'", CFG[staatskasse], CFG[license_price_0]);
	mysql_query(dbhandle, query);
	return true;
}



//Its only used in onregistercheck which is present here, so why not keep that also in here
dpublic:LoginRegisterTimeLeft(playerid)
{
	if(!IsPlayerConnected(playerid))return true;
	if(!pInfo[playerid][loggedin])
	{
		SendClientMessage(playerid, GREY, "Du wurdest gekickt, da du zulange zum Einloggen gebraucht hast.");
		KickEx(playerid);
	}

	return true;
}



dpublic:OnRegisterCheck(playerid)
{
	//Nach 60 Sekunden kicken, wenn er nicht eingeloggt ist.
	#if defined DEBUG 

	#else
	pTimerIDs[playerid][getloggedintimer]=SetTimerEx_("LoginRegisterTimeLeft", 60000, 0, 1, "i", playerid);
	#endif

	new rows;
	cache_get_row_count(rows);
	if(rows==0)
	{
		//Register
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "GTA-City Reallife", "{FFFFFF}Willkommen auf GTA-City Reallife!\nEin Account mit diesem Namen wurde nicht gefunden.\nGib ein Passwort ein, um dich mit diesem Namen zu registrieren.\n{E10000}ACHTUNG: Gib dein Passwort nie an andere Spieler weiter! Auch nicht an Admins!", "Ok", "Abbrechen");
	}
	else
	{
		//Login
		
		
		//BAN CHECK
		/*new query[256];
		mysql_format(dbhandle, query, sizeof query, "SELECT * FROM accounts WHERE name = '%e'", PlayerName(playerid));
		mysql_query(dbhandle, query);
		new banned, banstr[256];
		cache_get_value_name_int(0, "banned", banned);
		cache_get_value_name(0, "baninfo", banstr, sizeof(banstr));
		if(banned==1)
		{
			ShowPlayerDialog(playerid, DIALOG_BAN, DIALOG_STYLE_MSGBOX, "Serversperre", banstr, "Schließen", "");
			return KickEx(playerid);
		}*/
		
		
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "GTA-City", "{FFFFFF}Willkommen auf GTA-City Reallife!\nDein Account wurde in der Datenbank gefunden.\nGib dein Passwort niemals weiter. Auch nicht an Admins oder Supporter!\nDu kannst dich nun einloggen. Bitte gib ein Passwort ein:", "Ok", "Abbrechen");
	}
	return true;
}


public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	printf("========================== ERROR ==========================");
	printf("MYSQL ERROR %d : %s (callback %s\nQuery: %s)", errorid, error, callback,  query);
	switch(errorid)
	{
		case 2002:
		{
			new stamp[6];
			gettime(stamp[0], stamp[1], stamp[2]);
			getdate(stamp[3], stamp[4], stamp[5]);
			printf("%0d:%0d:%0d - %0d.%0d.%0d [MYSQL_ERROR] Lost connection to MySQL Server Database!", stamp[0], stamp[1], stamp[2], stamp[5], stamp[4], stamp[3]);
			SendRconCommand("exit");
		}
		case ER_SYNTAX_ERROR:
		{
			new stamp[6];
			gettime(stamp[0], stamp[1], stamp[2]);
			getdate(stamp[3], stamp[4], stamp[5]);
			printf("%0d:%0d:%0d - %0d.%0d.%0d [MYSQL_ERROR] SYNTAX ERROR in query %s under %s", stamp[0], stamp[1], stamp[2], stamp[5], stamp[4], stamp[3], query, callback);
		}
	}
	printf("========================== ERROR ==========================");
	return 1;
}












//============================================================================================================================
//													Verschiedene Dinge



stock SaveUserData(playerid)
{
	if(!pInfo[playerid][loggedin])return false;
	new query[400], tmp_ipport[22];
	NetStats_GetIpPort(playerid, tmp_ipport, 22);
	mysql_format(dbhandle, query, sizeof(query), "UPDATE accounts SET \
	regdate = '%d', \
	last_seen = '%d', \
	last_ip = '%s', \
	sex = '%d', \
	money = '%d', \
	bank = '%d', \
	rank = '%d', \
	ziviskin = '%d', \
	level = '%d', \
	respekt = '%d', \
	players_advertised = '%d', \
	perso = '%d', \
	job = '%d', \
	fahrschein = '%d', \
	hunger = '%f' \
	WHERE id = '%d'", 
	pInfo[playerid][regdate],
	gettime(),
	tmp_ipport,
	pInfo[playerid][sex],
	GetPlayerMoney(playerid),
	pInfo[playerid][bank],
	_:pInfo[playerid][rank],
	pInfo[playerid][ziviskin],
	pInfo[playerid][level],
	pInfo[playerid][respekt],
	pInfo[playerid][players_advertised],
	pInfo[playerid][perso],
	pInfo[playerid][job],
	pInfo[playerid][fahrschein],
	pInfo[playerid][fHunger],
	pInfo[playerid][db_id]);
	mysql_query(dbhandle, query);
	return true;
}