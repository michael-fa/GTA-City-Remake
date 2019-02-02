#if defined LP_INC_PLAYER
  #endinput
#endif
#define LP_INC_PLAYER
#include <a_samp>
#include "utils.cpp"

//DEFINES
#define KickEx(%0) SetTimerEx("KickTimer", 400, false, "i", %0)






//===============================
//Forwards
forward Float:GetPlayerHealthEx(playerid);
forward Float:GetPlayerArmourEx(playerid);

#define GetPlayerSerial gpci
native gpci(playerid, serial[], len);





//===============================
//Functions

//Example: format(string, sizeof(string), "%s sucks..", PlayerName(playerid));
stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

//Example: if(!PlayerOnline(playerid))return SendClientMessage(playerid, GREY, "Player is offline!");
stock PlayerOnline(playerid)
{
	if(playerid==INVALID_PLAYER_ID && !IsPlayerConnected(playerid))return false;
	else return true;
}

//returns the speed in mph/kmh style (if in car or not doesn't matter)
stock GetPlayerSpeed(playerid)
{
	new basic_floats, Float:rtn;
	if(IsPlayerInAnyVehicle(playerid))
	{
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
 	}
 	else
 	{
		GetPlayerVelocity(playerid, x, y, z);
 	}
 	rtn = floatsqroot(x*x + y*y + z*z);
	return floatround(rtn * 100 * 1.61);
}

//stops sounds playing for a player, or audio streams
stock StopPlayerSound(playerid)
{
	StopAudioStreamForPlayer(playerid);
	return PlayerPlaySound(playerid,1186,0.0,0.0,0.0);
}

//"clears" the chat by spamming 35 EMPTY messages to player
stock ClearPlayerChat(playerid)
{
	for(new i=0; i<35; i++)
	{
		SendClientMessage(playerid,WHITE," ");
	}
}

//"clears" the chat for all players by spamming 35 EMPTY messages
stock ClearPlayerChatForAll()
{
	for(new i=0; i<35; i++)
	{
		SendClientMessageToAll(WHITE, "");
	}
}

//returns TRUE if player is in water, and FALSE if not.
stock IsPlayerInWater(playerid){
        new anim = GetPlayerAnimationIndex(playerid);
        if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
        return 0;
}

//pass a players name as argument, and it'll return the player's id back to you ;)
stock GetPlayerIDFromName(name[])
{
	for(new i=0; i<GetMaxPlayers(); i++)
	{
		if(strcmp(PlayerName(i),name,true))continue;
		return i;
	}
	return INVALID_PLAYER_ID;
}

//if you only got a name, wanna find a player with same name return the id
stock ReturnPlayerID(const text[])
{
	new ret = INVALID_PLAYER_ID;
	foreachplayer()
	{
		if(!IsPlayerConnected(i))continue;
		if(strcmp(PlayerName(i), text, true))continue;
		ret = i;
	}
	return ret;
}

//pass a players name or ID in STRING-FORMAT and it'll give you the correct NAME or ID, depending on what you've passed.
dpublic:ReturnUser(text[])
{
    new pos = 0;
    while (text[pos] < 0x21)
    {
        if (text[pos] == 0) return INVALID_PLAYER_ID; 
        pos++;
    }
    new userid = INVALID_PLAYER_ID;
    if (IsNumeric(text[pos]))
    {
        userid = strval(text[pos]);
        if (userid >=0 && userid < MAX_PLAYERS)
        {
            if(!IsPlayerConnected(userid))
            {
                userid = INVALID_PLAYER_ID;
            }
            else
            {
                return userid;
            }
        }
    }
    new len = strlen(text[pos]);
    new tmp_count = 0;
    new name[MAX_PLAYER_NAME];
    for (new tmp_i_ = 0; tmp_i_ < MAX_PLAYERS; tmp_i_++)
    {
        if (IsPlayerConnected(tmp_i_))
        {
            GetPlayerName(tmp_i_, name, sizeof (name));
            if (strcmp(name, text[pos], true, len) == 0)
            {
                if (len == strlen(name))
                {
                    return tmp_i_;
                }
                else
                {
                    tmp_count++;
                    userid = tmp_i_;
                }
            }
        }
    }
    if (tmp_count != 1) userid = INVALID_PLAYER_ID;
    return userid;
}


//================================
//if you stream custom objects, teleport a player to a mapped area, it'll maybe loads not on time, so this freezes a player a bit, giving it more time to load.
stock TimedFreeze(playerid, time)
{
	TogglePlayerControllable(playerid,false);
	SetTimerEx("_TimedFreeze", time, false,"i", playerid);
	return 1;
}

dpublic:_TimedFreeze(playerid)return TogglePlayerControllable(playerid,true);
//================================




//================================
//get's the distance as a FLOAT type between two players
dpublic:Float:GetDistanceBetweenPlayers(playerid, targetplayerid)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetplayerid)) {
        return -1.00;
    }
    GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerPos(targetplayerid,x2,y2,z2);
    return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
//================================


//kicks the player, letting messages before it now appear (a fix for the priority problem!)
dpublic:KickTimer(playerid)return Kick(playerid);

//================================
//returns the health as float, easier implementing in format etc..
dpublic:Float:GetPlayerHealthEx(playerid)
{
	new Float:ffloat;
	GetPlayerHealth(playerid, ffloat);
	return ffloat;
}



//================================
//returns the armour as float, easier implementing in format etc..
dpublic:Float:GetPlayerArmourEx(playerid)
{
	new Float:ffloat;
	GetPlayerArmour(playerid, ffloat);
	return ffloat;
}




//================================
//returs TRUE if two players are in given range, or FALSE if not.
stock IsPlayerNearPlayer(playerid, target, Float:range=20.0)
{
	new basic_floats;
	GetPlayerPos(target, x, y, z);
	if(!IsPlayerInRangeOfPoint(playerid, range, x, y, z))return false;
	return true;
}

//Removes a weapon, doesn't matter if he holds it or not, just removes it from his slots.
stock RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12];
	new plyAmmo[12];
	for(new slot=0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);
		ResetPlayerWeapons(playerid);
		if(wep != weaponid)
		{
			GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
		}
	}
	return true;
}

//returns TRUE if a player skydives, and FALSE if not.
stock IsPlayerSkydiving(playerid)
{
	return (GetPlayerWeapon(playerid) == 46 && GetPlayerAnimationIndex(playerid) == 1134);
}

//returns TRUE if player is falling, false if not
stock IsPlayerFalling(playerid)           //true if player is falling with a closed parachute
{
    new index = GetPlayerAnimationIndex(playerid);
    if(index >= 958 && index <= 979 || index == 1130 || index == 1195 || index == 1132) return 1;
    return 0;
}

//Fixes the bug where the first applied animation won't be accomplished
stock PreloadAnimLib(playerid, animlib[])return ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);

//returns TRUE if player is in water, swimming or FALSE if not
stock IsPlayerSwimming(playerid)
{
	if(GetPlayerAnimationIndex(playerid))
	{
		new data[2][32];
		GetAnimationName(GetPlayerAnimationIndex(playerid),data[0],32,data[1],32);
		if(strcmp(data[0], "SWIM", true) == 0)return true;
	}
	return false;
}

//returns TRUE if player is jumping, FALSE if not
stock IsPlayerJumping(playerid)
{
	new
	    index = GetPlayerAnimationIndex(playerid),
	    keys,
	    ud,
	    lr
	;

	GetPlayerKeys(playerid, keys, ud, lr);

	return (keys & KEY_JUMP) && (1196 <= index <= 1198);
}

//returns TRUE if player is printing, FALSE if not
stock IsPlayerSprinting(playerid)
{
	new
	    index = GetPlayerAnimationIndex(playerid),
	    keys,
	    ud,
	    lr
	;

	GetPlayerKeys(playerid, keys, ud, lr);
	
	return (keys & KEY_SPRINT) && ((1222 <= index <= 1236) || index == 1196);
}

stock GetXYInFrontOfPlayer(playerid,&Float:x,&Float:y,Float:dis)
{
    new Float:pos[3];
    GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
    GetPlayerFacingAngle(playerid,pos[2]);
    GetXYInFrontOfPoint(pos[0],pos[1],x,y,pos[2],dis);
}

stock GetXYBehindPlayer(playerid,&Float:x,&Float:y,Float:dis)
{
    new Float:pos[3];
    GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
    GetPlayerFacingAngle(playerid,pos[2]);
    GetXYBehindPoint(pos[0],pos[1],x,y,pos[2],dis);
}

stock GetXYInFrontOfPoint(Float:x,Float:y,&Float:x2,&Float:y2,Float:angle,Float:distance)
{
    x2 = x + (distance * floatsin(-angle,degrees));
    y2 = y + (distance * floatcos(-angle,degrees));
}

stock GetXYBehindPoint(Float:x,Float:y,&Float:x2,&Float:y2,Float:angle,Float:distance)
{
    x2 = x - (distance * floatsin(-angle,degrees));
    y2 = y - (distance * floatcos(-angle,degrees));
}
