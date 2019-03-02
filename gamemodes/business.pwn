//biz.pwn - Alle geschäfte / clubs / whatnot
//COPYRIGHT 2019 © MICHAEL FA. for "rpg-city-remake"	
//MySQL benötigt!


#define MAX_BIZ 200 // Maximale Geschäfte
#define MAX_BIZ_NAME 32 //Beschreibung max. Länge

enum BizType {
	BIZ_SHOP, //Supermarkt / 24/7
	BIZ_AMMUNATION
}


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
	iVW
}
new Business[MAX_BIZ][eBusiness];



stock LoadBusinesses()
{
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
						CreateDynamicPickup(19592, 1, Business[i][p_x], Business[i][p_y], Business[i][p_z]); //basket
						if(Business[i][owner] == 0)
						{
							//Kein Owner
							format(str, sizeof(str), "Supermarkt\nPreis: %d", Business[i][price]);
							CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
						}
						else 
						{
							new tmp_owner[MAX_PLAYER_NAME];
							mysql_format(dbhandle, str, sizeof(str), "SELECT name FROM accounts WHERE id='%d'", Business[i][owner]);
							mysql_query(dbhandle, str);
							cache_get_value_name(0, "name", tmp_owner);
							format(str, sizeof(str), "Supermarkt\n%s\nBesitzer: %s", Business[i][custom_name], tmp_owner);
							CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0,0);
						}

						//Create shop system related stuff, dasnt matter what values of Business change
						CreateActor_(ACT_SUPERM_CASHIER, 180, -29.1886,-186.8786,1003.5469,359.0892, true, 100.0, Business[i][iVW], Business[i][int]);
						format(str, sizeof(str), ""HTML_WHITE"Wilkommen bei "HTML_GREEN"%s"HTML_WHITE"\nDrücke ["HTML_YELLOW"F"HTML_WHITE"] hinter der Kasse", Business[i][custom_name]);
						CreateDynamic3DTextLabel(str, WHITE, -29.1886,-186.8786,1003.6469, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[i][iVW], Business[i][int]);
						CreateDynamicPickup(19198 , 1,-29.0915,-185.1253,1003.5469, Business[i][iVW], Business[i][int]);
						
					}
					case BIZ_AMMUNATION:
					{
						
					}
				}

				//What buidlings have in general..
				CreateDynamic3DTextLabel("Drücke ENTER zum Verlassen", WHITE, Business[i][int_x], Business[i][int_y], Business[i][int_z], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[i][iVW], Business[i][int]);
				CreateDynamicPickup(1318, 1, Business[i][int_x], Business[i][int_y], Business[i][int_z], Business[i][iVW], Business[i][int]); //white down arrow
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









stock IsPlayerNearShop(playerid)
{
	for(new i=0; i<MAX_BUSINESS; i++)
	{
		if(!Business[i][is_valid])continue;
		if(Business[i][biztype] != BizType:BIZ_SHOP)continue;
		if(!IsPlayerInRangeOfPoint(playerid, 2.5, -29.0915,-185.1253,1003.5469))continue;
		return true;
	}
	return false;
}

stock IsPlayerBusinessOwner(playerid, business)
{
	if(Business[business][owner] == pInfo[playerid][db_id])return true;
	else false;
}

stock GetNearestBusiness(playerid)
{
	for(new i=0; i<MAX_BUSINESS; i++)
	{
		if(!Business[i][is_valid])continue;
		if(IsPlayerInRangeOfPoint(playerid, 2.5, Business[i][int_x], Business[i][int_y], Business[i][int_z])))
			return i;
		else return -1;
	}
}