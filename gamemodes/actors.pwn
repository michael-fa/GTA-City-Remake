//Actor stuff
//Copyright Michael FA. aka lp_ 2019
// rpg-city remake SAMP 0.3.{7,..}


enum Actors{			//                          |
	ACT_SUPERM_CASHIER //<-- Actor ID 0 and so on.. v
}

enum eActData{
	Float: fPX,
	Float: fPY,
	Float: fPZ,
	Float: fPR,
	bool: bValid
} new Actor:Actor [Actors][eActData];

stock CreateActor_(Actors:actor, modelid, Float:X, Float:Y, Float:Z, Float:Rotation, invulnerable = true, Float:health = 100.0, worldid = -1, interiorid = -1, playerid = -1)
{
	Actor[actor][bValid] = true;
	Actor[actor][fPX] = X;
	Actor[actor][fPY] = Y;
	Actor[actor][fPZ] = Z;
	Actor[actor][fPR] = Rotation;
	return CreateDynamicActor(modelid, Float:X, Float:Y, Float:Z, Rotation, invulnerable, health, worldid, interiorid, playerid);
}

stock SetActorFacingAngle_(Actors:actorid, Float:ang)
{
	Actor[actorid][fPR] = ang;
	return SetActorFacingAngle(_:actorid, ang);
}

stock SetDynamicActorPos_(Actors:actorid, Float:X, Float:Y, Float:Z)
{
	Actor[actorid][fPX] = X;
	Actor[actorid][fPY] = Y;
	Actor[actorid][fPZ] = Z;
	return SetDynamicActorPos(_:actorid, x,y,z);
}

stock DestroyDynamicActor_(Actors:actorid)
{
	Actor[actorid][bValid] = false;
	return DestroyActor(_:actorid);
}