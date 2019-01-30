#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_DATA "gtacity" 


new MySQL:dbhandle;
new mysql_tries = 0;



stock ConnectWithMySQL()
{
	printf("[MYSQL] Datenbankverbindung wird hergestellt..");
	dbhandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);
	while(mysql_errno(dbhandle)!=0)
	{
		printf("[MYSQL] Verbindung fehlgeschlagen, %d Versuche übrig.", (mysql_tries-3));
		ConnectWithMySQL();
		if(mysql_tries>3)return SendRconCommand("exit");
		mysql_tries++;
	}
	printf("[MYSQL] Verbindung zur Datenbank hergestellt! Handle: %d", _:dbhandle);
	return true;
}

stock DisconnectMySQL()
{
	printf("[MYSQL] Verbindung wurde geschlossen!");
	mysql_close(dbhandle);
}





dpublic:OnRegisterCheck(playerid)
{
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