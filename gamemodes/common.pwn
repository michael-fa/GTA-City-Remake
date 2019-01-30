#define MAX_LOGIN_TRIES      3
#define MAX_PASSWORD_LEN     128


//IMPORTANT for it to work we need to actually include common after buildinfo!
#if defined GM_DEBUG
	#define DebugPrint(%0); printf(%0);
#else
	stock fake_nop(){return true;}
	#define DebugPrint(%0); fake_nop();
#endif


new ZiviSkins[2][2] = {
	{0,0}, //Männlich
	{6,3}  //Weiblich
};

enum {
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_SEX
}