new Text:ServerTD[3];

stock TD_ServerTD_Load() {
	ServerTD[0] = TextDrawCreate(82.000000, 427.000000, "www.gta-city.de");
	TextDrawAlignment(ServerTD[0], 2);
	TextDrawBackgroundColor(ServerTD[0], 255);
	TextDrawFont(ServerTD[0], 2);
	TextDrawLetterSize(ServerTD[0], 0.269999, 1.300000);
	TextDrawColor(ServerTD[0], -1);
	TextDrawSetOutline(ServerTD[0], 1);
	TextDrawSetProportional(ServerTD[0], 1);
	TextDrawSetSelectable(ServerTD[0], 0);

//	{ 
	ServerTD[1] = TextDrawCreate(579.000000, 7.000000, "gta city");
	TextDrawAlignment(ServerTD[1], 2);
	TextDrawBackgroundColor(ServerTD[1], 255);
	TextDrawFont(ServerTD[1], 0);
	TextDrawLetterSize(ServerTD[1], 0.660000, 1.500000);
	TextDrawColor(ServerTD[1], -1);
	TextDrawSetOutline(ServerTD[1], 1);
	TextDrawSetProportional(ServerTD[1], 1);
	TextDrawSetSelectable(ServerTD[1], 0);

	ServerTD[2] = TextDrawCreate(549.000000, 23.000000, "REALLIFE");
	TextDrawBackgroundColor(ServerTD[2], 255);
	TextDrawFont(ServerTD[2], 3);
	TextDrawLetterSize(ServerTD[2], 0.459999, 1.200001);
	TextDrawColor(ServerTD[2], -5635841);
	TextDrawSetOutline(ServerTD[2], 1);
	TextDrawSetProportional(ServerTD[2], 1);
	TextDrawSetSelectable(ServerTD[2], 0);
//	{
}