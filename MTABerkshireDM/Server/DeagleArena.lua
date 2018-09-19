--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

DeagleArena = {
	["Spawnpoints"] = {
		{2159.3999023438,1596.6999511719,1000,0,1,0},
		{2169.6999511719,1610.0999755859,1000,0,1,0},
		{2176.1999511719,1577.0999755859,1000,0,1,0},
		{2232.6999511719,1578.3000488281,1000,0,1,0},
		{2222.6999511719,1599,1000,0,1,0},
	}
}

addEvent("DeagleArena.join",true)
addEventHandler("DeagleArena.join",root,function()
	if(client:getData("Lobby") == "Eingangshalle")then
		client:setData("Lobby","DeagleArena");
		client:triggerEvent("LoadScreen.create",client);
		setTimer(function(client)
			DeagleArena.spawnPlayer(client);
			infobox(client,"Mit dem Befehl /leave kannst du die Lobby wieder verlassen.");
		end,3900,1,client)
	end
end)

function DeagleArena.spawnPlayer(player)
	local rnd = math.random(1,#DeagleArena["Spawnpoints"]);
	local tbl = DeagleArena["Spawnpoints"][rnd];
	local x,y,z,rotation = tbl[1],tbl[2],tbl[3],tbl[4];
	local interior,dimension = tbl[5],tbl[6];
	
	player:spawn(x,y,z,rotation,_,interior,dimension);
	giveWeapon(player,24,9999,true);
	setSpawnschutz(player);
	player:setArmor(100);
end