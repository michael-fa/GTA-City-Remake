//biz.pwn - Alle geschäfte / clubs / whatnot
//COPYRIGHT 2019 © MICHAEL FA. for "rpg-city-remake"	
//Use with MYSQL


#define MAX_BIZ 200 // Maximale Geschäfte

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
	Float:p_x,
	Float:p_y,
	Float:p_z,
	Float:int_x,
	Float:int_y,
	Float:int_z,
	int
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
				cache_get_value_name_float(0, "p_x", Business[i][p_x]);
				cache_get_value_name_float(0, "p_y", Business[i][p_y]);
				cache_get_value_name_float(0, "p_z", Business[i][p_z]);
				cache_get_value_name_float(0, "int_x", Business[i][int_x]);
				cache_get_value_name_float(0, "int_y", Business[i][int_y]);
				cache_get_value_name_float(0, "int_z", Business[i][int_z]);
				cache_get_value_name_int(0, "interior", Business[i][int]);
				Business[i][is_valid] = true;

				switch(Business[i][biztype])
				{
					case BIZ_SHOP:
					{
						CreateDynamicPickup(19592, 1, Business[i][p_x], Business[i][p_y], Business[i][p_z]); //basket
						new tmp_owner[MAX_PLAYER_NAME];
						mysql_format(dbhandle, str, sizeof(str), "SELECT name FROM accounts WHERE id='%d'", Business[i][owner]);
						mysql_query(dbhandle, str);
						cache_get_value_name(0, "name", tmp_owner);
						format(str, sizeof(str), "Supermarkt\nBesitzer: %s", tmp_owner);
						CreateDynamic3DTextLabel(str, WHITE, Business[i][p_x], Business[i][p_y], Business[i][p_z], 10.0);
					}
					case BIZ_AMMUNATION:
					{
						CreateDynamicPickup(1318, 1, Business[i][p_x], Business[i][p_y], Business[i][p_z]); //white down arrow
					}
				}
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
			interior = '%d' \
			WHERE id = '%d'",
			Business[i][owner],
			_:Business[i][biztype],
			Business[i][kasse],
			Business[i][int],
			Business[i][db_id]);
		mysql_query(dbhandle, str);
	}
	return true;
}