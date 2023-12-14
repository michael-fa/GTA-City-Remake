#define INVALID_BIKE_RENTAL sizeof(BikeRental) 

//Minuten sind hardcoded in dem sinne dass der Scripter im Gamemode die Minuten angeben muss, um bikeRentalEnd aufzurufen.



enum eBikeRental {
	Float:_x,
	Float:_y,
	Float:_z,
	price
} new BikeRental[][eBikeRental] = {
	{1772.0225,-1895.7983,13.5537, 300}
};

new bool:IsRentalBike[MAX_VEHICLES];
//add bike rental above: {x,y,z, price}



//mainly to be used when gamemode inits
stock LoadBikeRentals()
{
	new str[128];
	for(new i=0; i<sizeof(BikeRental); i++)
	{
		format(str, sizeof(str), ""#HTML_LIME"Fahrradverleih\n"#HTML_WHITE"Spieler unter Level 4 können\nhier für %d$ ein Fahrrad mieten.\n"#HTML_LIME"Enter zum Kaufen", BikeRental[i][price]);
		CreateDynamic3DTextLabel(str, WHITE, BikeRental[i][_x], BikeRental[i][_y], BikeRental[i][_z], 15);
		CreateDynamicPickup(1274, 1, BikeRental[i][_x], BikeRental[i][_y], BikeRental[i][_z]);
	}
}

//get nearest bike rental station
stock NearestBikeRental(playerid)
{
	for(new i=0; i<sizeof(BikeRental); i++)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 2.2, BikeRental[i][_x], BikeRental[i][_y], BikeRental[i][_z]))
			continue;
		else return i;
	}
	return INVALID_BIKE_RENTAL;
}


//call it via timer oder whatever
dpublic:BikeRentalEnd(playerid)
{
	if(!PlayerOnline(playerid))
		DestroyVehicle(pRentalBike[playerid]);

	if(!IsValidVehicle(pRentalBike[playerid]))return 1;

	else {
		SendClientMessage(playerid, YELLOW, "* Deine Mietzeit für das BMX ist abgelaufen.");
		IsRentalBike[pRentalBike[playerid]] = false;
		DestroyVehicle(pRentalBike[playerid]);
		pRentalBike[playerid] = INVALID_VEHICLE_ID;
		pTimerIDs[playerid][bikerental] = -1;
	}
	return 1;
}