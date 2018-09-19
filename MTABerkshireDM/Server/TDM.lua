--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

TeamDeathmatch = {
	timer = {},
	["Maps"] = {
		"LSPD_Interior",
		"Andromeda_Interior",
		"Mafia_Ranch",
	},
	["Teams"] = {
		[1] = {0,100},
		[2] = {0,104},
	}
}
local map = nil;
local activeGame = false;

function TeamDeathmatch.createMap()
	clearChatBox();
	TeamDeathmatch["Teams"][1][1] = 0;
	TeamDeathmatch["Teams"][2][1] = 0;
	if(isTimer(mapTimer))then killTimer(mapTimer)end
	if(isTimer(createMapTimer))then killTimer(createMapTimer)end
	if(isTimer(createMapTimer2))then killTimer(createMapTimer2)end
	if(isElement(TeamDeathmatch.radar))then destroyElement(TeamDeathmatch.radar)end
	if(isElement(TeamDeathmatch.colshape))then destroyElement(TeamDeathmatch.colshape)end

	local rnd = math.random(1,#TeamDeathmatch["Maps"]);
	map = TeamDeathmatch["Maps"][rnd];
	
	for _,v in pairs(getElementsByType("player"))do
		if(v:getData("Lobby") == "TeamDeathmatch")then
			v:setData("Gespawnt",false);
			sortPlayer(v);
			TeamDeathmatch.spawnPlayer(v);
			v:triggerEvent("Countdown.create",v,"show");
			outputChatBox("Arena '"..map.."' geladen.",v,255,255,255);
			v:triggerEvent("disableCollisions",v);
		end
	end
	
	createMapTimer = setTimer(function()
		for _,v in pairs(getElementsByType("player"))do
			if(v:getData("Lobby") == "TeamDeathmatch")then
				playSoundFrontEnd(v,43);
				v:setData("Countdown",v:getData("Countdown")+1);
				if(v:getData("Countdown") >= 4)then
					v:setFrozen(false);
					createMapTimer2 = setTimer(function(v)
						if(isElement(v))then
							v:triggerEvent("Countdown.create",v,"unshow");
						end
					end,1000,1,v)
				end
			end
		end
	end,1000,4)
	
	mapTimer = setTimer(function()
		TeamDeathmatch.createMap();
	end,300000,1)
	
	if(Settings["MapGrenzen"][map])then
		local x1,y1 = tonumber(Settings["MapGrenzen"][map][1]),tonumber(Settings["MapGrenzen"][map][2]);
		local x2,y2 = tonumber(Settings["MapGrenzen"][map][3]),tonumber(Settings["MapGrenzen"][map][4]);
		local xs,ys = math.abs(x1-x2),math.abs(y1-y2);
		
		TeamDeathmatch.radar = createRadarArea(x1,y1,xs,ys,200,0,0,100,root);
		TeamDeathmatch.colshape = createColCuboid(x1,y1,-50,xs,ys,7500);
		
		addEventHandler("onColShapeHit",TeamDeathmatch.colshape,function(player)
			killTimer(TeamDeathmatch.timer[player]);
			infobox(player,"Du hast das Gebiet wieder betreten.");
		end)
		
		addEventHandler("onColShapeLeave",TeamDeathmatch.colshape,function(player)
			if(player:getData("Lobby") == "TeamDeathmatch")then
				infobox(player,"Du hast 5 Sekunden Zeit, das Gebiet wieder zu betreten!");
				TeamDeathmatch.timer[player] = setTimer(function(player)
					player:kill();
				end,5000,1,player)
			end
		end)
	end
end

function sortPlayer(player)
	if(TeamDeathmatch["Teams"][1][1] == TeamDeathmatch["Teams"][2][1])then
		local rnd = math.random(1,2);
		if(rnd == 1)then
			player:setData("Team",1);
			TeamDeathmatch["Teams"][1][1] = TeamDeathmatch["Teams"][1][1] + 1;
		else
			player:setData("Team",2);
			TeamDeathmatch["Teams"][2][1] = TeamDeathmatch["Teams"][2][1] + 1;
		end
	elseif(TeamDeathmatch["Teams"][1][1] < TeamDeathmatch["Teams"][2][1])then
		player:setData("Team",1);
		TeamDeathmatch["Teams"][1][1] = TeamDeathmatch["Teams"][1][1] + 1;
	elseif(TeamDeathmatch["Teams"][2][1] < TeamDeathmatch["Teams"][1][1])then
		player:setData("Team",2);
		TeamDeathmatch["Teams"][2][1] = TeamDeathmatch["Teams"][2][1] + 1;
	end
	player:setData("Countdown",0);
	player:triggerEvent("Countdown.create",player,"unshow");
end

function TeamDeathmatch.checkPlayer()
	local counter = 0;
	
	for _,v in pairs(getElementsByType("player"))do
		if(v:getData("Lobby") == "TeamDeathmatch")then
			if(v:getData("Gespawnt") == true)then
				counter = counter + 1;
			end
		end
	end
	
	if(counter < 2)then TeamDeathmatch.createMap()end
end

function TeamDeathmatch.spawnPlayer(player)
	local tbl = Settings["MapSpawns"][map][player:getData("Team")];
	local interior = tbl[1];
	local x,y,z,rotation = tbl[2],tbl[3],tbl[4],tbl[5]
	
	player:spawn(x,y,z,rotation,_,interior,0);
	player:setData("Gespawnt",true);
	player:setHealth(100);
	player:setArmor(100);
	setTimer(function() player:setFrozen(true) end,100,1)
	player:setModel(TeamDeathmatch["Teams"][player:getData("Team")][2]);
	
	takeAllWeapons(player);
	giveWeapon(player,24,9999,true);
	giveWeapon(player,29,9999,true);
	giveWeapon(player,31,9999,true);
	giveWeapon(player,33,9999,true);
end

addEvent("TeamDeathmatch.join",true)
addEventHandler("TeamDeathmatch.join",root,function()
	if(client:getData("Lobby") == "Eingangshalle")then
		client:setData("Lobby","TeamDeathmatch");
		client:triggerEvent("LoadScreen.create",client);
		setTimer(function(client)
			if(isElement(client))then
				client:setData("Gespawnt",false);
				sortPlayer(client);
				TeamDeathmatch.spectate(client);
				TeamDeathmatch.checkPlayer();
				infobox(client,"Mit dem Befehl /leave kannst du die Lobby wieder verlassen.");
			end
		end,3500,1,client)
	end
end)

function TeamDeathmatch.spectate(player)
	for _,v in pairs(getElementsByType("player"))do
		if(v:getData("Team") == player:getData("Team"))then
			if(v:getData("Gespawnt") == true)then
				setCameraTarget(player,v);
				player:setData("CameraTarget",v:getName());
			end
		end
	end
end