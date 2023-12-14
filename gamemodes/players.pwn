// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/players.pwn
//      Description:    Kram das für Spieler ist, oder von diesen genutzt wird


new DefaultPlayerArray[] = {0, 0, 0, 0, 0, 5000, 10000};
new DefaultPTimerArray[] = {-1};


enum ePlayerData {
	bool:loggedin,
	db_id,
	Rank:rank,
	regdate,
	sex,
	money, //also for anti-cheat purposes
	bank,
	ziviskin,
	level,
	respekt,
	players_advertised,
	perso,
	job,
	fahrschein, //auto
	Float:fHunger,
	bool:pDead
}
new pInfo[MAX_PLAYERS][ePlayerData];



//possible spawn reasons, since I prefer letters instead of boring numbers, who or what needs them anyways
enum SpawnReason {
	SPAWN_LOGIN,
	SPAWN_REGISTER,
	SPAWN_HOSPITAL,
	SPAWN_RESPAWN,
	SPAWN_SKINCHANGE_REGISTER
}



//Player Command Flags
const PERM_PLAYER = 0;
enum (<<= 1)
{
    PERM_SUPPORTER = 1,     // 0b00000000000000000000000000000010
    PERM_ADMIN,   // 0b00000000000000000000000000000100
    PERM_HEAD_ADMIN,
    PERM_PROJLEITER,
    PERM_GOD
};
enum Rank {
	PLAYER,
	SUPPORTER,
	ADMIN,
	HEAD_ADMIN,
	PROJEKTLEITER,
	DEBUG_GOD
}



//Player bound timers
enum ePTimers {
	bikerental,
	getloggedintimer,
	notification,
	getHungry
} new pTimerIDs[MAX_PLAYERS][ePTimers];




//Other vars for players
new SpawnReason:pSpawnReason[MAX_PLAYERS];
new pLoginTries[MAX_PLAYERS];
new pInSkinChange[MAX_PLAYERS]; //1 = Register, 2 = Normal general change, 3 = Fraktion / Gang
new pSkinSelIndex[MAX_PLAYERS];
new pRentalBike[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new pFSCar[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new pInBuilding[MAX_PLAYERS];
new bool:pDisableCheckPointOnEnter[MAX_PLAYERS];
new bool:pInFahrschule[MAX_PLAYERS];
new pPermissions[MAX_PLAYERS];
new plastMapIconID[MAX_PLAYERS];
new p_Hunger_Sec_Counter[MAX_PLAYERS];
new pOnPlayerJMPClDwn[MAX_PLAYERS];
new pBikeSpeedingCooldown[MAX_PLAYERS];




//Kill all timers
stock KillAllTimers(playerid)
{
	for(new i=0; i<sizeof(pTimerIDs[]); i++)
		KillTimer_(pTimerIDs[playerid][ePTimers:i]);
}



//Lassen wir die main pwn sauberer
stock ResetPlayerVars(playerid)
{
	pPermissions[playerid] = PERM_PLAYER;
	pLoginTries[playerid] = 0;
	pInSkinChange[playerid] = 0;
	pSkinSelIndex[playerid] = 0;
	pInBuilding[playerid] = -1;

	//Fürn fall, aktives mietrad löschen
	if(pRentalBike[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(pRentalBike[playerid])) IsRentalBike[pRentalBike[playerid]] =false;
		

	pRentalBike[playerid] = INVALID_VEHICLE_ID;
	pFSCar[playerid] = INVALID_VEHICLE_ID;
	pDisableCheckPointOnEnter[playerid] = false;
	pInFahrschule[playerid] = false;
	plastMapIconID[playerid] = 0;
	p_Hunger_Sec_Counter[playerid] = 0;
	pOnPlayerJMPClDwn[playerid] = 0;
	pBikeSpeedingCooldown[playerid] = 0;
	DisablePlayerCheckpoint_(playerid);

	A_HungerBar[playerid][init] = false;
}

//Check, aus lazypawn herausgenommen
stock PlayerOnline(playerid)
{
	if(playerid==INVALID_PLAYER_ID || !IsPlayerConnected(playerid) || !pInfo[playerid][loggedin])return false;
	else return true;
}

//Current Timer @getHungry

