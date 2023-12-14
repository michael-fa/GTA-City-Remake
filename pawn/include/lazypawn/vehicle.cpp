#if defined LP_INC_VEH
  #endinput
#endif
#define LP_INC_VEH
#include <a_samp>
#include "lazypawn\utils.cpp"

native IsValidVehicle(vehicleid);







//Car Names
new CarName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Article Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Dirt Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
 	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Petrol Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
 	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "2. Gebrauchtwagen", "1. Gebrauchtwagen", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "Utility Trailer"
};









//returns the ModelName from the ID given as arg
stock GetVehicleModelIDFromName(vname[])
{
    for(new _x; _x != 211; _x++) if(strfind(CarName[_x], vname, true) != -1) return _x + 400;
    return INVALID_VEHICLE_ID;
}

//returns the Player using Seat 0 in Car (..ID as given arg)
stock GetVehicleDriver(vid)
{
	if(!IsValidVehicle(vid))return false;
	foreachplayer()
	{
		if(!PlayerOnline(i) || !IsPlayerInAnyVehicle(i) || GetPlayerVehicleID(i)!=vid)continue;
		return i;
	}
	return INVALID_PLAYER_ID;
}

//returns 1(TRUE) if vehicleid has model of a bike, or 0(FALSE) if it has the model of a car/air-vehicle/boat
stock IsABike(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new result = 0;
	switch(GetVehicleModel(vehicleid))
	{
		case 509, 481, 510: result = GetVehicleModel(vehicleid);
		default: result = 0;
	}
	return result;
}

stock IsAMotorBike(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new result = 0;
	switch(GetVehicleModel(vehicleid))
	{
		case 461, 462, 463, 468, 471, 448, 521, 522, 523, 581, 586: result = GetVehicleModel(vehicleid);
		default: result = 0;
	}
	return result;
}

//returns 1(TRUE) if vehicleid has model of a helicopter/airplane, or 0(FALSE) if it has the model of a car/bike/boat
stock IsAPlane(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new const cars[20] = {417,425,447,460,469,476,487,488,497,511,512,513,519,520,548,553,563,577,592,593};
	for(new i; i<sizeof(cars); i++) {
        if(GetVehicleModel(vehicleid) == cars[i])return true;
	}
	return false;
}

//returns 1(TRUE) if vehicleid has model of a boat, or 0(FALSE) if it has the model of a car/bike/helicopter/plane
stock IsABoat(carid)
{
	if(!IsValidVehicle(carid))return false;
	new modelid = GetVehicleModel(carid);
	if(modelid == 430 || modelid == 446 || modelid == 452 || modelid == 453 || modelid == 454 || modelid == 472 || modelid == 473 || modelid == 484 || modelid == 493 || modelid == 595)
	{
		return 1;
	}
	return 0;
}

//returns 1(TRUE) if vehicleid has any seat used by a player or 0(FALSE) if all seats are empty
/*stock IsVehicleOccupied(vehicleid)
{
   foreachplayer()
   {
		if(!IsPlayerConnected(i))continue;
		if(IsPlayerInVehicle(i,vehicleid)) return 1;
   }
   return 0;
}*/

//puts the relative position of a vehicle out. Example: you want to put a pickup infront of the driver's door, no matter how its rotated.
stock GetVehicleRelativePos(vehicleid, &Float:_x, &Float:_y, &Float:_z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;  
    GetVehiclePos(vehicleid, _x, _y, _z);
    _x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + _x;
    _y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + _y;
    _z = zoff + _z;
}

//returns the closest vehicle's ID, invalid_vehicle_id if no car in range of arm-lenght, coordinates taken from playerid passed as argument
stock GetClosestVehicleFromPlayer(playerid)
{
	new basic_floats;
	foreachvehicle()
	{
		if(!IsValidVehicle(i))continue;
		GetVehiclePos(i, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid,3.0, x, y, z))continue;
		return i;
	}
	return INVALID_VEHICLE_ID;
}

//returns the closest vehicle's ID, invalid_vehicle_id if no car in range of arm-lenght, coordinates given as args
stock GetClosestVehicleFromPoint(Float:_X, Float:_Y, Float:_Z)
{
	foreachvehicle()
	{
		if(!IsValidVehicle(vehicleid))continue;
		if(!IsValidVehicle(i))continue;
		if(!IsPlayerInRangeOfPoint(playerid,3.0,_X,_Y,_Z))continue;
		return i;
	}
	return INVALID_VEHICLE_ID;
}

//returns the next free seatID in a vehicle (vehicle id given as arg), RETURNS -1 IF NO SEAT EMPTY
//IMPORTANT: I don't know how many people can be in a train, plane, bus etc. so 8 is maximum. Edit yourself or wait till I update it someday, when I finally find out more about maximums.
stock GetFreeVehicleSeat(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new bool:Seat[9];
	foreachplayer()
	{
		if(!IsPlayerConnected(i))continue;
		if(IsPlayerInVehicle(i,vehicleid))
		{
			for(new s=0; s<9; s++)
			{
				Seat[s]=false;
				if(GetPlayerVehicleSeat(i)==s)
				{
					Seat[s]=true;
				}
			}
		}
	}
	if(Seat[0] == false) return 0;
	else if(Seat[1] == false) return 1;
	else if(Seat[2] == false) return 2;
	else if(Seat[3] == false) return 3;
	else if(Seat[4] == false) return 4;
	else if(Seat[5] == false) return 5;
	else if(Seat[6] == false) return 6;
	else if(Seat[7] == false) return 7;
	else if(Seat[8] == false) return 8;
	else return -1;
}

//Toggles the engine. Returns true(1) if car is there and engine toggled, false(0) if vehicle doesn't exists.
stock ToggleVehicleEngine(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new tmp[7];
	GetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
	if(tmp[0]==1)tmp[0]=0;
	else tmp[0]=1;
	SetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
	return tmp[0];
}



//Toggles all doors closed / open. true if car is spawned and success on toggle, false if vehicle is wrong
stock ToggleVehicleDoors(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new tmp[7];
	GetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
	tmp[3]=!tmp[3];
	return SetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
}

//Sends a message in car, basically to all players sitting inside the vehicle, ID given as arg
stock SendMessageInCar(vehicleid, color, string[])
{
	foreachplayer()
	{
		if(GetPlayerVehicleID(i)==vehicleid)continue;
		SendClientMessage(i,color,string);
		PlayerPlaySound(i,1057,0.0,0.0,0.0);
	}
}

//gets the damage-status of the front and rear bumper from a vehicle.
stock GetVehicleBumperStatus(vehicleid, &front_bumper, &rear_bumper){
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	front_bumper = (panels >> 20) & 0xF;
	rear_bumper = (panels >> 24) & 0xF;
}

//sets the damage status of the vehicles front and rear bumpers
stock SetVehiclePanels(vehicleid, flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper){
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	panels = (flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24));
	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
}

//=========================================================================
//On OnVehicleSpawn SetVehicleZAngle doesn't work, so this fixes it.
//It calls a timer to set the z angle a lil it later.

forward ZCarFix(vehicleid, Float:angle);
public ZCarFix(vehicleid, Float:angle)
{
	return SetVehicleZAngle(vehicleid, Float:angle);
}

stock SetVehicleZAngle_(vehicleid, Float:z_angle)
{if(!IsValidVehicle(vehicleid))return false; return SetTimerEx("ZCarFix", 700, false, "if", vehicleid, z_angle);}
//=========================================================================

//returns the speed of vehicle in mph/kmh style
stock GetVehicleSpeed(vehicleid)
{
	new basic_floats, Float:rtn;
	GetVehicleVelocity(vehicleid, x, y, z);
 	rtn = floatsqroot(x*x + y*y + z*z);
	return floatround(rtn * 100 * 1.61);
}
