//biz.pwn - Alle geschäfte / clubs / whatnot
//COPYRIGHT 2019 © MICHAEL FA. for "rpg-city-remake"	
//Use with MYSQL


#define MAX_BIZ 200 // Maximale Geschäfte

enum BizType {
	BIZ_SHOP //Supermarkt / 24/7
}


enum eBiz
{
	bool:is_valid,
	db_id,
	BizType:biztype,
	owner, //mysql
	kasse
}
new Biz[MAX_BIZ][eBiz];