
new DefaultPlayerArray[] = {0, 0, 0, 0, 0, 5000, 10000};

enum ePlayerData {
	bool:loggedin,
	db_id,
	adminlevel,
	regdate,
	sex,
	money, //also for anti-cheat purposes
	bank,
	ziviskin
}
new pInfo[MAX_PLAYERS][ePlayerData];

//possible spawn reasons, since I hate to remember numbers
enum SpawnReason {
	SPAWN_LOGIN,
	SPAWN_REGISTER,
	SPAWN_DEATH,
	SPAWN_RESPAWN,
	SPAWN_SKINCHANGE_ZIVI
}





//Other vars for players
new SpawnReason:pSpawnReason[MAX_PLAYERS];
new pLoginTries[MAX_PLAYERS];
new pInSkinChange[MAX_PLAYERS]; //1 = Register, 2 = Normal general change, 3 = Fraktion / Gang
new pSkinSelIndex[MAX_PLAYERS];