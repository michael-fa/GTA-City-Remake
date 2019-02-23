//Copyright 2019 lp_
//Module is ready-to-include (22.02.2019)
//File: gta-city-remake/checkpoints.pwn


forward OnPlayerEnterCheckpoint_(playerid, cpid); //Im script definieren
forward OnPlayerLeaveCheckpoint_(playerid, cpid); //Im script definieren

enum eScriptedCheckpoints {
	Float:cp_x,
	Float:cp_y,
	Float:cp_z,
	cp_id,
	play_sound,
	bool:_delete //after entering it
}

new ScriptedCheckpoint[MAX_PLAYERS][eScriptedCheckpoints]; //needs to be reset on Disconnect/Connect




//Ex Functions
stock SetPlayerCheckpoint_(playerid, Float:x, Float:y, Float:z, Float:size__, cp_idx, bool:del, play_sound_ = 1150)
{
	if(ScriptedCheckpoint[playerid][cp_id] != -1) DisablePlayerCheckpoint(playerid);
	ScriptedCheckpoint[playerid][cp_id] = cp_idx;
	ScriptedCheckpoint[playerid][play_sound] = play_sound_;
	ScriptedCheckpoint[playerid][cp_x] = x;
	ScriptedCheckpoint[playerid][cp_y] = y;
	ScriptedCheckpoint[playerid][cp_z] = z;
	ScriptedCheckpoint[playerid][_delete] = del;
	return SetPlayerCheckpoint(playerid, x, y, z, size__);
}

stock DisablePlayerCheckpoint_(playerid)
{
	ScriptedCheckpoint[playerid][cp_x] = 0x0;
	ScriptedCheckpoint[playerid][cp_y] = 0x0;
	ScriptedCheckpoint[playerid][cp_z] = 0x0;
	ScriptedCheckpoint[playerid][play_sound] = -1;
	ScriptedCheckpoint[playerid][cp_id] = -1;
	ScriptedCheckpoint[playerid][_delete] = false;
	return 	DisablePlayerCheckpoint(playerid);
}





//ORIGINAL samp callbacks - INTERNAL
public OnPlayerEnterCheckpoint(playerid)
{
	new cp_id_ = ScriptedCheckpoint[playerid][cp_id];
	if(ScriptedCheckpoint[playerid][_delete])
	{
		DisablePlayerCheckpoint(playerid);
		if(ScriptedCheckpoint[playerid][play_sound] !=-1) PlayerPlaySound(playerid,ScriptedCheckpoint[playerid][play_sound],0.0,0.0,0.0);
		ScriptedCheckpoint[playerid][cp_x] = 0x0;
		ScriptedCheckpoint[playerid][cp_y] = 0x0;
		ScriptedCheckpoint[playerid][cp_z] = 0x0;
		ScriptedCheckpoint[playerid][cp_id] = -1;
		ScriptedCheckpoint[playerid][play_sound] = -1;
		ScriptedCheckpoint[playerid][_delete] = false;
		return true;
	}
	else return OnPlayerEnterCheckpoint_(playerid, cp_id_);
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return OnPlayerLeaveCheckpoint_(playerid, ScriptedCheckpoint[playerid][cp_id]);
}