
new DefaultPlayerArray[] = {0, 0, 0, 0, 0, 5000, 10000};

enum ePlayerData {
	bool:loggedin,
	db_id,
	adminlevel,
	regdate,
	sex,
	money, //also for anti-cheat purposes
	bank 
}
new pInfo[MAX_PLAYERS][ePlayerData];


enum SpawnReason {
	SPAWN_LOGIN,
	SPAWN_REGISTER,
	SPAWN_DEATH,
	SPAWN_RESPAWN
}





//Other vars for players
new SpawnReason:pSpawnReason[MAX_PLAYERS];
new pLoginTries[MAX_PLAYERS];