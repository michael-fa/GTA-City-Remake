//ID-Halter für Cars
new FahrschulCar[6];


//Extra
new bool:carLocked[MAX_VEHICLES]; //we re-sync that state in OnVehicleStreamIn, just to make sure (also static vehs don't change params at gm init)





//============================
//Functions


//Taken from lazypawn @ vehicles.pwn for custom use
stock ToggleVehicleDoors_(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new tmp[7];
	GetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
	tmp[3]=!tmp[3];
	return SetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], carLocked[vehicleid], tmp[4], tmp[5], tmp[6]);
}

//Engine ON (no toggle)
stock VehicleEngineOn(vehicleid)
{
	if(!IsValidVehicle(vehicleid))return false;
	new tmp[7];
	GetVehicleParamsEx(vehicleid, tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6]);
	return SetVehicleParamsEx(vehicleid, 1, tmp[1], tmp[2], carLocked[vehicleid], tmp[4], tmp[5], tmp[6]);
}