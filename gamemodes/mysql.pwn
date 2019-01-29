#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_DATA "gtacity" 
new MySQL:dbhandle;
new mysql_tries = 0;


stock ConnectWithMySQL()
{
	while(mysql_tries < 4)
	{
		printf("[MYSQL] Datenbankverbindung wird hergestellt..");
		dbhandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);


		if(mysql_errno(dbhandle)!=0)
		{
			if(mysql_tries < 3)
			{
				printf("[MYSQL] Verbindung fehlgeschlagen, %d Versuche übrig.", (mysql_tries-3));
				ConnectWithMySQL();
				mysql_tries++;
			}
			else 
			{
				printf("[MYSQL] Verbidnung fehlgeschalgen! Server Exit!");
				return SendRconCommand("exit");
			}
		}
	}
	printf("[MYSQL] Verbindung zur Datenbank hergestellt! Handle: %d", _:dbhandle);
	return true;
}