
new DefaultPlayerArray[] = {0, 0, 0, 0, 0, 5000, 10000};
new DefaultPTimerArray[] = {-1};


enum ePlayerData {
	bool:loggedin,
	db_id,
	adminlevel,
	regdate,
	sex,
	money, //also for anti-cheat purposes
	bank,
	ziviskin,
	level,
	respekt,
	players_advertised,
	perso,
	job
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


//Player bound timers
enum ePTimers {
	bikerental,
	getloggedintimer
} new pTimerIDs[MAX_PLAYERS][ePTimers];




//Other vars for players
new SpawnReason:pSpawnReason[MAX_PLAYERS];
new pLoginTries[MAX_PLAYERS];
new pInSkinChange[MAX_PLAYERS]; //1 = Register, 2 = Normal general change, 3 = Fraktion / Gang
new pSkinSelIndex[MAX_PLAYERS];
new pRentalBike[MAX_PLAYERS];
new pInBuilding[MAX_PLAYERS];




//Kill all timers
stock KillAllTimers(playerid)
{
	for(new i=0; i<sizeof(pTimerIDs[]); i++)
		KillTimer_(pTimerIDs[playerid][ePTimers:i]);
}



//Makes main file cleaner
stock ResetPlayerVars(playerid)
{
	pLoginTries[playerid] = 0;
	pInSkinChange[playerid] = 0;
	pSkinSelIndex[playerid] = 0;
	pInBuilding[playerid] = 0;
	pRentalBike[playerid] = INVALID_VEHICLE_ID;
}