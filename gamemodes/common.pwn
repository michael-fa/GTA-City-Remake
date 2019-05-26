// 2019 © GTA-CITY REMAKE by lp_ aka Michael F.
//     
//      File:           /gamemodes/common.pwn
//      Description:    Alles globale und so, krams, vars usw. Außerdem neben gtacity.pwn zweit wichtigste Datei.

#define MAX_LOGIN_TRIES      3
#define MAX_PASSWORD_LEN     128
#define STARTMONEY           5000
#define STARTMONEYBANK		 10000





//Debug kram - kann eigentlich so gelassen werden.		//	Don't ever parse strings / big arrays with this in between a while/for loop.. 
#if defined GM_DEBUG									//  .. Took ? (almost) : (more than) 500ms foreach call(); 
	#define DebugPrint(%0); printf("[DEBUG] "%0);
#else
	stock fake_nop(){return true;}
	#define DebugPrint(%0); fake_nop();
#endif


//Gamemode
	//CONFIG
enum eGMCFG {
	staatskasse, //staatskasse
	license_price_0 //fahrschein(auto) preis
} new CFG[eGMCFG];

	//SA-MP Server Uptime (approximately)
new gUpTimeVal = 0;
stock GetUptime(){return (gettime()-gUpTimeVal);}
new bool:bOOC = false;



//Ziviskins M/W
new ZiviSkins_M[] = {1,2,3,4,5,6,7,14,15,18,19,20,21,22,23,24,25,26,28,29,30,137,142,156,162,170,179,188};
new ZiviSkins_W[] = {9,12,13,40,41,55,56,90,91,93,191,192,193};

//Fahrschule
new Float:FsCp[][3] = {
 	{1431.9427,-1636.4459,13.3828},
 	{1453.4729,-1594.5880,13.3828},
 	{1527.2834,-1626.7042,13.3828},
 	{1453.4729,-1594.5880,13.3828},
 	{1431.9427,-1636.4459,13.3828},
 	{1453.4729,-1594.5880,13.3828},
 	{1527.2834,-1626.7042,13.3828},
 	{-1.0, -1.0, -1.0} //Exit code
};

//Dialoge
enum {
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_SEX,
	DIALOG_UWU, //User werben User
	DIALOG_JOBS,
	DIALOG_ALTER,
	DIALOG_CBIZ_SHOP,
	DIALOG_CBIZ_FASTFOOD,
	DIALOG_CBIZ_PRICE
}


//Virtuelle Welten
enum {
	VW_ZERO,
	VW_SKINCHANGE,
	VW_STADTHALLE,
	VW_SHOP = 2000,
	VW_AMMUNATION = 2050,
	VW_BURGERSHOT = 2100,
	VW_CLUCKNBELL = 2150
}


//menus
new Menu:shmenu;














