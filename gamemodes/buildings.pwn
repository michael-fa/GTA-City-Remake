//Gebäude

enum BuildingType {
	BUILDING_NORMAL,
	BUILDING_FASTFOOD,
	BUILDING_FRAK,
	BUILDING_BANK
}

enum eBuildings { //IN = wenn ich betrete  - OUT = wenn ich es wieder verlasse
	buildingidout,
	intout,
	intin,
	vworldout,
	vworldin,
	Float:enterx,
	Float:entery,
	Float:enterz,
	Float:enterr,
	Float:exitx,
	Float:exity,
	Float:exitz,
	Float:exitr,
	pickupmodelout,
	pickupmodelin,
	mapicon,
	mapiconid,
	mapicon_color,
	labelout[64],
	labelin[64],
	BuildingType:btype,
	extraval //sollte btype == BUILDING_FRAK sein muss hier eine FraktionsID sein, da eine frak ja zugriff braucht.
}

new Buildings[][eBuildings] = {
	//Stadthalle LS
	{-1, 0, 3, 0, VW_STADTHALLE, 1481.0129,-1770.0699,18.7958,359.0029,/**/386.0921,173.9337,1008.3828,84.1310, /**/1318, 1318, 38, 0xC, WHITE, ""#HTML_ORANGE"Stadthalle"#HTML_WHITE"\nBetreten mit ENTER.", "Drücke ENTER zum Verlassen.", BUILDING_NORMAL, -1}
};

stock LoadBuildings(){
	for(new i=0; i<sizeof(Buildings); i++)
	{
		CreateDynamicPickup(Buildings[i][pickupmodelout], 1, Buildings[i][enterx], Buildings[i][entery], Buildings[i][enterz], Buildings[i][vworldout]);
		CreateDynamicPickup(Buildings[i][pickupmodelin], 1, Buildings[i][exitx], Buildings[i][exity], Buildings[i][exitz], Buildings[i][vworldin]);
		CreateDynamic3DTextLabel(Buildings[i][labelout], WHITE, Buildings[i][enterx], Buildings[i][entery], Buildings[i][enterz], 15.0);
		CreateDynamic3DTextLabel(Buildings[i][labelin], WHITE, Buildings[i][exitx], Buildings[i][exity], Buildings[i][exitz], 15.0);
	}
}