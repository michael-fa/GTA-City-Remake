#if defined LP_INC_UTIL
  #endinput
#endif
#define LP_INC_UTIL
#include <a_samp>


//DEFINES FOR EASIER USE
#define valstr                   valstrex
#define spv                      SetPVarInt
#define gpv                      GetPVarInt
#define basic_floats             Float:x,Float:y,Float:z
#define hook:                    hook_
#define abs(%1)                  (((%1) < 0) ? (-(%1)) : ((%1))) //positive to negative and other way around


//=================
//KEY DEFINES

//EXAMPLE OnPlayerKeyStangeChange: if(RELEASED(KEY_JUMP))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	
//EXAMPLE OnPlayerKeyStangeChange: if(pressed(KEY_JUMP))
#define PRESSED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	
	
	
	
	
//=================
//FOREACH..
#define foreachplayer() for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) //foreachplayer(){//do stuff}
#define foreachplayerex(%0) for(new %0 = 0, j = GetPlayerPoolSize(); %0 <= j; %0++) //foreachplayer(variable_if_i_is_already_used){//do stuff}
#define foreachvehicle() for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)//foreachvehicle(){//do stuff}
	






//=================
//Other usefull stuff

/*instead off:

forward CALLBACK();
public CALLBACK()
{
	Ban(0);
	return true;
}



you do it like that now:

dpublic:CALLBACK()
{
	Ban(0);
	return true;
}

*/
#define dpublic:%0(%1) forward %0(%1); public %0(%1)








//=================
// HEX COLORS 
#define DRED            0x910000FF
#define RED             0xD90000FF
#define DBLUE           0x0A00FFFF 
#define BLUE           0x00418CFF
#define YELLOW            0xFFF000FF
#define CYAN           0x00FFFFFF
#define PURPLE           0x8200FFFF
#define GREY            0xB4B4B4FF
#define GREEN           0x059C00FF
#define ORANGE          0xFF6400FF
#define COLOR_ACTION    0xC87FDBFF
#define WHITE           0xFFFFFFFF


//=====HTML Colors======//
#define HTML_WHITE     					"{FFFFFF}"
#define HTML_GREEN     					"{66CC00}"
#define HTML_LIGHTBLUE     				"{3399FF}"
#define HTML_LIGHTYELLOW     			"{CCFF00}"
#define HTML_PURPLE      				"{E599FF}"
#define HTML_DARKBLUE                   "{0000FF}"
#define HTML_DARKRED                    "{E10000}"
#define HTML_ORANGE                     "{FF5C00}"
#define HTML_DARKGREY                   "{8C8C8C}"
#define HTML_GREY                       "{BEBEBE}"
#define HTML_BLACK                      "{0F0000}"
#define HTML_RED                        "{FF0000}"
#define HTML_GOLDENYELLOW               "{FFFA00}"
#define HTML_PERFECTGREEN               "{458B00}"
#define HTML_SELECTION                  "{899f60}"
#define HTML_LOGIN                      "{A4C391}"
#define HTML_YELLOW                     "{E1FF33}"
#define HTML_NEWBE                      "{FF00FF}"
#define HTML_DCHAT                      "{FF584D}"
#define HTML_RCHAT                      "{0091FF}"

//==========================================
// Vector Stuff in SA-MP (easier 2D & 3D Pos handling like in C#)  :: by Michael F.
//IS SLOWER THAN NORMAL VARIABLES!

enum Vector{
	Float:vX,
	Float:vY,
	Float:vZ,
	Float:vR,
	Float:vx, //you accidentally wrote lower case instead
	Float:vy, //^
	Float:vz, //^^
	Float:vr  //^^^
}
/*EXAMPLE USAGE:

new PlayerPosition[Vector];

GetPlayerPos(playerid, PlayerPosition[X], PlayerPosition[y], PlayerPosition[Z]);
 Doesn't matter if lower case or upper case!


=============================================*/



//returns true of false wether string only contains numbers or not.
stock IsNumeric(const string[])
{
    for (new tmp_i_ = 0, j = strlen(string); tmp_i_ < j; tmp_i_++)
    {
        if (string[tmp_i_] > '9' || string[tmp_i_] < '0') return 0;
    }
    return 1;
}

//using ÄÜÖ and others in textdraws
stock FixTextDrawString(string[])
{
	new original[50] = {192,193,194,196,198,199,200,201,202,203,204,205,206,207,210,211,212,214,217,218,219,220,223,224,225,226,228,230,231,232,233,234,235,236,237,238,239,242,243,244,246,249,250,251,252,209,241,191,161,176};
	new fixed[50] = {128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,94,124};
	new len = strlen(string);
	for (new i; i < len; i++) {
		for(new j;j < 50;j++) {
			if(string[i] == original[j]) {
				string[i] = fixed[j];
				break;
			}
		}
	}
}

//instant returning an value (integer) as string
stock valstrex(val)
{
	new str[128];
	format(str,sizeof(str),"%d",val);
	return str;
}

//adding commas to int RETURN AS STRING!	
stock AddCommas(money)
{
	new bmess[15];
	format(bmess, 15, "%d", money);
	if(money > 0)
	{
		for(new l=strlen(bmess)-3; l>0; l-=3)
		{
			if(l>0)
			{
				strins(bmess, ".", l);
			}
		}
	}
	else
	{
		for(new _z=strlen(bmess)-3; _z>1; _z-=3)
		{
			if(_z>1)
			{
				strins(bmess, ".", _z);
			}
		}
	}
	return bmess;
}

//get the distance between two points
stock Float:GetZDistance(Float:az, Float:bz)
{
	new Float:result=az-bz;
	return result;
}

//exploding a string by seperating it with given delimeter, return as array
stock explode(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}

//replacing a string with another string
stock str_replace (newstr [], oldstr [], srcstr [], deststr [], bool: ignorecase = false, size = sizeof (deststr))
{
	new
	    newlen = strlen (newstr),
	    oldlen = strlen (oldstr),
	    srclen = strlen (srcstr),
	    idx,
		rep;

	for (new i = 0; i < srclen; ++i)
	{
	    if ((i + oldlen) <= srclen)
	    {
	        if (!strcmp (srcstr [i], oldstr, ignorecase, oldlen))
	        {
				deststr [idx] = '\0';
				strcat (deststr, newstr, size);
				++rep;
				idx += newlen;
				i += oldlen - 1;
			}
			else
			{
		        if (idx < (size - 1))
		            deststr [idx++] = srcstr [i];
				else
					return rep;
		    }
	    }
	    else
	    {
	        if (idx < (size - 1))
	            deststr [idx++] = srcstr [i];
			else
				return rep;
	    }
	}
	deststr [idx] = '\0';
	return rep;
}

//return a random character
stock RandomChar()
{
	return ( random(1000) %2 ==0 ) ? (65 + random(26)) : (97 + random(26));
}

//Generates a SALT
stock GenerateSalt(strDest[], len = 30)
{
	while(len--)
	{
		strDest[len] = random(2) ? (random(26) + (random(2) ? 'a' : 'A')) : (random(10) + '0');
	}
}

stock randomEx(minnum = cellmin, maxnum = cellmax) return random(maxnum - minnum + 1) + minnum;