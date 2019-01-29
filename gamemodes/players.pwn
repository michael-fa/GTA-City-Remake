enum ePlayerData {
	bool:logged_in,
	db_id,
	adminlevel,
	regdate,
	sex,
	money, //also for anti-cheat purposes
	bank 
}
new pInfo[MAX_PLAYERS][ePlayerData];



//Other vars for players
