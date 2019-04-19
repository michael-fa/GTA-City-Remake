//biz.pwn - Alle geschäfte / clubs / whatnot
//COPYRIGHT 2019 © MICHAEL FA. for "rpg-city-remake"	
//MySQL benötigt!


//To do
// Functions of fastfood and shop
//Add more singleplayer shops


#define MAX_BIZ 200 // Maximale Geschäfte
#define MAX_BIZ_NAME 32 //Beschreibung max. Länge


enum BizType {
	BIZ_SHOP, //Supermarkt / 24/7
	BIZ_FASTFOOD
}

enum bizTypet {
	shop_int,
	Float:shop_x,
	Float:shop_y,
	Float:shop_z,
	Float:shop_r,
	shop_name[128]
} 



new ShopTypes[][bizTypet] = {
	{17, -25.9657,-187.1451,1003.5469,354.1385, "Singleplayer 24/7 #1"}
};

new FastfoodTypes[][bizTypet] = {
	{10, 363.5319,-74.4832,1001.5078,318.2088, "Burger Shot"},
	{9, 364.7784,-11.3707,1001.8516,12.8726, "Cluckin' Bell"},
	{5, 372.2979,-133.3119,1001.4922,359.7931, "Well Stacked Pizza"},
	{17, 377.0637,-193.0274,1000.6401,360.0000, "Rusty Browns Donuts"}
};





enum eBusiness
{
	bool:is_valid,
	db_id,
	BizType:biztype,
	owner, //mysql
	kasse,
	price,
	custom_name[MAX_BIZ_NAME],
	Float:p_x,
	Float:p_y,
	Float:p_z,
	Float:p_r,
	Float:int_x,
	Float:int_y,
	Float:int_z,
	Float:int_r,
	int,
	iVW,
	STREAMER_TAG_3D_TEXT_LABEL: _labels[3], //enter, exit, front desk or whatever.
	STREAMER_TAG_ACTOR: _actors[4], //let them have 4 actors max
	STREAMER_TAG_PICKUP: _pickups[3] //enter, exit, front desk or whatever.
}
new Business[MAX_BIZ][eBusiness];



stock LoadBusinesses()
{
	if(GetUptime()>180)return true; //Nur zur sicherheit, eigentlich sollte das EINMAL aufgerufen werden.
	new str[256];
	mysql_format(dbhandle, str, sizeof(str), "SELECT * from biz");
	mysql_query(dbhandle, str);
	new count;
	cache_get_row_count(count);
	if(count > 199)return printf(" FEHLER: Businesses OVERLOAD! Reached max business count %d", MAX_BIZ);
	if(count > 0)
	{
		for(new i=0; i<MAX_BIZ; i++)
		{
			if(Business[i][is_valid])continue; //Dont overwrite used businesses
			mysql_format(dbhandle, str, sizeof(str), "SELECT * FROM biz WHERE id = '%d'", i);
			mysql_query(dbhandle, str, true);
			cache_get_row_count(count);
			if(count>0)
			{
				cache_get_value_name_int(0, "id", Business[i][db_id]);
				cache_get_value_name_int(0, "type", _:Business[i][biztype]);
				cache_get_value_name_int(0, "owner", Business[i][owner]);
				cache_get_value_name_int(0, "kasse", Business[i][kasse]);
				cache_get_value_name_int(0, "price", Business[i][price]);
				cache_get_value_name(0, "custom_name", Business[i][custom_name]);
				cache_get_value_name_float(0, "p_x", Business[i][p_x]);
				cache_get_value_name_float(0, "p_y", Business[i][p_y]);
				cache_get_value_name_float(0, "p_z", Business[i][p_z]);
				cache_get_value_name_float(0, "int_x", Business[i][int_x]);
				cache_get_value_name_float(0, "int_y", Business[i][int_y]);
				cache_get_value_name_float(0, "int_z", Business[i][int_z]);
				cache_get_value_name_int(0, "interior", Business[i][int]);
				Business[i][is_valid] = true;
				Business[i][iVW] = VW_SHOP + i;

				switch(Business[i][biztype])
				{
					case BIZ_SHOP:
					{
						Business[i][_pickups][0] = CreateDynamicPickup(19592, 1, Business[i][p_x], Business[i][p_y], Business[i][p_z]); //basket
						if(Business[i][owner] == 0)
						{
							//Kein Owner
							format(str, sizeof(str), "{FFD200}Supermarkt{FFFFFF}\nPreis: %s\n\nDrücke ENTER", AddCommas(Business[i][price]));
							Business[i][_labels][0]=CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
						}
						else 
						{
							new tmp_owner[MAX_PLAYER_NAME];
							mysql_format(dbhandle, str, sizeof(str), "SELECT name FROM accounts WHERE id='%d'", Business[i][owner]);
							mysql_query(dbhandle, str);
							cache_get_value_name(0, "name", tmp_owner);
							format(str, sizeof(str), "{FFD200}Supermarkt{FFFFFF}\n{D2D2D2}%s{FFFFFF}\nBesitzer: %s\n\nDrücke ENTER", Business[i][custom_name], tmp_owner);
							Business[i][_labels][0] = CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0,0);
						}

						//Create shop system related stuff, doesnt matter what values of Business change
						Business[i][_actors][0] = CreateDynamicActor(180, -29.1886,-186.8786,1003.5469,359.0892, true, 100.0, Business[i][iVW], Business[i][int]);
						if(isnull(Business[i][custom_name]))format(str, sizeof(str), ""HTML_WHITE"Wilkommen !\nDrücke ["HTML_YELLOW"F"HTML_WHITE"] hinter der Kasse");
						else format(str, sizeof(str), ""HTML_WHITE"Wilkommen bei "HTML_GREEN"%s"HTML_WHITE"\nDrücke ["HTML_YELLOW"F"HTML_WHITE"] hinter der Kasse", Business[i][custom_name]);
						Business[i][_labels][2] = CreateDynamic3DTextLabel(str, WHITE, -29.1886,-186.8786,1004.6460, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[i][iVW], Business[i][int]);
						Business[i][_pickups][2] = CreateDynamicPickup(19198 , 1,-29.0915,-185.1253,1003.5469, Business[i][iVW], Business[i][int]);
						
					}
					case BIZ_FASTFOOD:
					{
						Business[i][_pickups][0] = CreateDynamicPickup(1559, 1, Business[i][p_x], Business[i][p_y], Business[i][p_z]+0.3); //corona
						if(Business[i][owner] == 0)
						{
							//Kein Owner
							format(str, sizeof(str), "{FFD200}Fastfood Restaurant{FFFFFF}\nPreis: %s\n\nDrücke ENTER", AddCommas(Business[i][price]));
							Business[i][_labels][0]=CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
						}
						else 
						{
							new tmp_owner[MAX_PLAYER_NAME];
							mysql_format(dbhandle, str, sizeof(str), "SELECT name FROM accounts WHERE id='%d'", Business[i][owner]);
							mysql_query(dbhandle, str);
							cache_get_value_name(0, "name", tmp_owner);
							format(str, sizeof(str), "{FFD200}Fastfood Restaurant{FFFFFF}\n{D2D2D2}%s{FFFFFF}\nBesitzer: %s\n\nDrücke ENTER", Business[i][custom_name], tmp_owner);
							Business[i][_labels][0] = CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0,0);
						}

						switch(Business[i][int])
						{
							case 10 : //BURGER SHOT
							{
								Business[i][_actors][0] = CreateDynamicActor(205, 376.7507,-65.8491,1001.5078,182.8056, true, 100.0, Business[i][iVW], Business[i][int]);
							}
							case 9 : //Clucknbell
							{
								Business[i][_actors][0] = CreateDynamicActor(167, 370.4950,-4.4926,1001.8589,184.8685, true, 100.0, Business[i][iVW], Business[i][int]);
							}
							case 5 : //Wellstacked
							{
								Business[i][_actors][0] = CreateDynamicActor(155, 374.1844,-117.2784,1001.4995,177.6487, true, 100.0, Business[i][iVW], Business[i][int]);
							}
							case 17 : //Rustybrownsdonuts
							{
								Business[i][_actors][0] = CreateDynamicActor(189, 380.7832,-189.0640,1000.6328,179.8759, true, 100.0, Business[i][iVW], Business[i][int]);
							}
						}
						
					}
				}

				//What buidlings have in general..
				Business[i][_labels][1] = CreateDynamic3DTextLabel("Drücke ENTER zum Verlassen", WHITE, Business[i][int_x], Business[i][int_y], Business[i][int_z], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[i][iVW], Business[i][int]);
				Business[i][_pickups][1] = CreateDynamicPickup(1559, 1, Business[i][int_x], Business[i][int_y], Business[i][int_z], Business[i][iVW], Business[i][int]); //white down arrow;
			}
		}
	}
	return true;
}

	
stock SaveBusinesses()
{
	new str[256];
	for(new i=0; i<MAX_BIZ; i++)
	{
		if(!Business[i][is_valid])continue;
		mysql_format(dbhandle, str, sizeof(str), "UPDATE biz SET \
			owner = '%d', \
			type = '%d', \
			kasse = '%d', \
			price = '%d', \
			custom_name = '%e', \
			interior = '%d' \
			WHERE id = '%d'",
			Business[i][owner],
			_:Business[i][biztype],
			Business[i][kasse],
			Business[i][price],
			Business[i][custom_name],
			Business[i][int],
			Business[i][db_id]);
		mysql_query(dbhandle, str);
	}
	return true;
}

stock CreateBusiness(tprice, BizType:biz_type, typeID, const Float:fEnter[4])
{
	new free = -1;
	for(new i = 0; i<MAX_BIZ; i++)
	{	
		if(Business[i][is_valid])continue;
		free = i;
		break;
	}
	if(free==-1)return false;
	Business[free][iVW] = VW_SHOP + free;
	Business[free][owner] = 0;
	Business[free][is_valid] = true;
	Business[free][biztype] = biz_type;
	Business[free][price] = tprice;
	switch(biz_type)
	{
		case 0:
		{
			Business[free][int] = ShopTypes[typeID][shop_int];
			Business[free][int_x] = ShopTypes[typeID][shop_x];
			Business[free][int_y] = ShopTypes[typeID][shop_y];
			Business[free][int_z] = ShopTypes[typeID][shop_z];
			Business[free][int_r] = ShopTypes[typeID][shop_r];
		}
		case 1:
		{
			Business[free][int] = FastfoodTypes[typeID][shop_int];
			Business[free][int_x] = FastfoodTypes[typeID][shop_x];
			Business[free][int_y] = FastfoodTypes[typeID][shop_y];
			Business[free][int_z] = FastfoodTypes[typeID][shop_z];
			Business[free][int_r] = FastfoodTypes[typeID][shop_r];
		}
	}
	Business[free][p_x] = fEnter[0];
	Business[free][p_y] = fEnter[1];
	Business[free][p_z] = fEnter[2];
	Business[free][p_r] = fEnter[3];
	format(Business[free][custom_name], MAX_BIZ_NAME, "\0");




	//MYSQL Data
	new query[256];
	mysql_format(dbhandle, query, sizeof(query), "INSERT INTO biz (type, owner, kasse, price, custom_name, p_x, p_y, p_z, p_r, int_x, int_y, int_z, int_r, interior) \
		VALUES (%d, 0, 0, %d, '\n', %f, %f, %f, %f,  %f, %f, %f, %f, %d)",
		_:biz_type,
		tprice, 
		Business[free][p_x], 
		Business[free][p_y], 
		Business[free][p_z],
		Business[free][p_r],
		Business[free][int_x],
		Business[free][int_y],
		Business[free][int_z], 
		Business[free][int_r],
		Business[free][int]);
	mysql_query(dbhandle, query);
	Business[free][db_id]=cache_insert_id();




	//Other specific stuff
	new str[128];
	switch(biz_type)
	{
		case BIZ_SHOP:
		{
			Business[free][_actors][0] = CreateDynamicActor(180, -29.1886,-186.8786,1003.5469,359.0892, true, 100.0, Business[free][iVW], Business[free][int]);
			format(str, sizeof(str), ""HTML_WHITE"Wilkommen !\nDrücke ["HTML_YELLOW"F"HTML_WHITE"] an der Kasse!");
			//else format(str, sizeof(str), ""HTML_WHITE"Wilkommen bei "HTML_GREEN"%s"HTML_WHITE"\nDrücke ["HTML_YELLOW"F"HTML_WHITE"] hinter der Kasse", Business[free][custom_name]);
			Business[free][_labels][2] = CreateDynamic3DTextLabel(str, WHITE, -29.1886,-186.8786,1004.6460, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[free][iVW], Business[free][int]);
			Business[free][_pickups][2] = CreateDynamicPickup(19198 , 1,-29.0915,-185.1253,1003.5469, Business[free][iVW], Business[free][int]);

			Business[free][_pickups][0] = CreateDynamicPickup(19592, 1, Business[free][p_x], Business[free][p_y], Business[free][p_z]); //enter

			//Enter Exit labels
			format(str, sizeof(str), "{FFD200}Supermarkt{FFFFFF}\nPreis: %s\n\nDrücke ENTER", AddCommas(Business[free][price]));
			Business[free][_labels][0]=CreateDynamic3DTextLabel(str, WHITE, Business[free][p_x], Business[free][p_y], Business[free][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

			//Mapicon
			foreachplayer()
			{
				if(!PlayerOnline(i))continue;
				SetPlayerMapIcon(i, plastMapIconID[i], Business[free][p_x], Business[free][p_y], Business[free][p_z], 38, 0xFFDC00FF, MAPICON_LOCAL);
				plastMapIconID[i]++;
			}
		}
		case BIZ_FASTFOOD:
		{
			switch(Business[free][int])
			{
				case 10 : //BURGER SHOT
				{
					Business[free][_actors][0] = CreateDynamicActor(205, 376.7507,-65.8491,1001.5078,182.8056, true, 100.0, Business[free][iVW], Business[free][int]);
				}
				case 9 : //Clucknbell
				{
					Business[free][_actors][0] = CreateDynamicActor(167, 370.4950,-4.4926,1001.8589,184.8685, true, 100.0, Business[free][iVW], Business[free][int]);
				}
				case 5 : //Wellstacked
				{
					Business[free][_actors][0] = CreateDynamicActor(155, 374.1844,-117.2784,1001.4995,177.6487, true, 100.0, Business[free][iVW], Business[free][int]);
				}
				case 17 : //Rustybrownsdonuts
				{
					Business[free][_actors][0] = CreateDynamicActor(189, 380.7832,-189.0640,1000.6328,179.8759, true, 100.0, Business[free][iVW], Business[free][int]);
				}
			}

			Business[free][_pickups][0] = CreateDynamicPickup(1559, 1, Business[free][p_x], Business[free][p_y], Business[free][p_z]+0.3); //enter

			//Enter Exit labels
			format(str, sizeof(str), "{FFD200}Fastfood Restaurant{FFFFFF}\nPreis: %s\n\nDrücke ENTER", AddCommas(Business[free][price]));
			Business[free][_labels][0]=CreateDynamic3DTextLabel(str, WHITE, Business[free][p_x], Business[free][p_y], Business[free][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

			//Mapicon
			foreachplayer()
			{
				if(!PlayerOnline(i))continue;
				SetPlayerMapIcon(i, plastMapIconID[i], Business[free][p_x], Business[free][p_y], Business[free][p_z], 50, -1, MAPICON_LOCAL);
				plastMapIconID[i]++;
			}
		}
	}
	


	//Enter Exit Pickups
	Business[free][_pickups][1] = CreateDynamicPickup(1318, 1, Business[free][int_x], Business[free][int_y], Business[free][int_z], Business[free][iVW], Business[free][int]); //for exit

	Business[free][_labels][1] = CreateDynamic3DTextLabel("Drücke ENTER zum Verlassen", WHITE, Business[free][int_x], Business[free][int_y], Business[free][int_z], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[free][iVW], Business[free][int]);
	DebugPrint(" CREATED BUSINESS (db = %d): TYPE = %d, PRICE = %d", Business[free][db_id], _:Business[free][biztype], Business[free][price]);
	
	return true;
}

stock DeleteBusiness(b)
{
	if(!Business[b][is_valid])return false;
	DestroyDynamicPickup(Business[b][_pickups][0]);
	DestroyDynamicPickup(Business[b][_pickups][1]);
	DestroyDynamicPickup(Business[b][_pickups][2]);
	DestroyDynamic3DTextLabel(Business[b][_labels][0]);
	DestroyDynamic3DTextLabel(Business[b][_labels][1]);
	DestroyDynamic3DTextLabel(Business[b][_labels][2]);
	DestroyDynamicActor(Business[b][_actors][0]);
	DestroyDynamicActor(Business[b][_actors][1]);
	DestroyDynamicActor(Business[b][_actors][2]);
	DestroyDynamicActor(Business[b][_actors][3]);
	new str[128];
	mysql_format(dbhandle, str, 128, "DELETE FROM biz WHERE id = '%d'", b);
	mysql_query(dbhandle, str);
	Business[b][kasse] = 0;
	Business[b][owner] = 0;
	Business[b][custom_name] = '\0';
	Business[b][is_valid] = false;
	DebugPrint(" Deleted Business %d with database ID %d", Business[b][db_id]);
	Business[b][db_id] = 0;
	return true;
}







stock IsPlayerNearShop(playerid)
{
	for(new i=0; i<MAX_BIZ; i++)
	{
		if(!Business[i][is_valid])continue;
		if(Business[i][biztype] != BizType:BIZ_SHOP)continue;
		if(!IsPlayerInRangeOfPoint(playerid, 1.0, -29.0915,-185.1253,1003.5469))continue;
		return true;
	}
	return false;
}

stock IsPlayerBusinessOwner(playerid, business)
{
	if(!Business[business][is_valid])return false;
	if(Business[business][owner] == pInfo[playerid][db_id])return true;
	else false;
}

stock GetNearestBusiness(playerid)
{
	for(new i=0; i<MAX_BIZ; i++)
	{
		if(!Business[i][is_valid])continue;
		if(IsPlayerInRangeOfPoint(playerid, 1.0, Business[i][p_x], Business[i][p_y], Business[i][p_z]))
			return i;
	}
	return -1;
}



stock LoadBusinessIconsFP(playerid)
{
	for(new i=0; i<MAX_BIZ; i++)
	{
		if(!Business[i][is_valid])continue;
		switch(Business[i][biztype])
		{
			case 0://Shop
			{
				SetPlayerMapIcon(playerid, plastMapIconID[playerid], Business[i][p_x], Business[i][p_y], Business[i][p_z], 38, 0xFFDC00FF, MAPICON_LOCAL);
				plastMapIconID[playerid]++;
			} 
			case 1: //Food
			{
				SetPlayerMapIcon(playerid, plastMapIconID[playerid], Business[i][p_x], Business[i][p_y], Business[i][p_z], 50, 0, MAPICON_LOCAL);
				plastMapIconID[playerid]++;
			} 
		}
	}
}