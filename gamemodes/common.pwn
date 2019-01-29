#define MAX_LOGIN_TRIES      3
#define MAX_PASSWORD_LEN     40


new ZiviSkins[2][2] = {
	{0,0}, //Männlich
	{6,3}  //Weiblich
};

enum {
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_SEX
}