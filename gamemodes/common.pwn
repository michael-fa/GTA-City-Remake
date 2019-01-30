#define MAX_LOGIN_TRIES      3
#define MAX_PASSWORD_LEN     128





//IMPORTANT for it to work we need to actually include common after buildinfo!
#if defined GM_DEBUG
	#define DebugPrint(%0); printf(%0);
#else
	stock fake_nop(){return true;}
	#define DebugPrint(%0); fake_nop();
#endif

new ZiviSkins_M[] = {1,2,3,4,5,6,7,14,15,18,19,20,21,22,23,24,25,26,28,29,30,137,142,156,162,170,179,188};
new ZiviSkins_W[] = {9,12,13,40,41,55,56,90,91,93,191,192,193};

enum {
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_SEX
}