--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

setGameType("Berkshire Deathmatch v.0.01");
setFPSLimit(65);

for i = 1,50 do outputChatBox(" ",root)end

addEventHandler("onPlayerWasted",root,function()
	setTimer(function(source)
		if(source:getData("Lobby") == "DeagleArena")then
			DeagleArena.spawnPlayer(source);
		elseif(source:getData("Lobby") == "TeamDeathmatch")then
			source:setData("Gespawnt",false);
			TeamDeathmatch.spectate(source);
			TeamDeathmatch.checkPlayer();
			
			for _,v in pairs(getElementsByType("player"))do
				if(v:getData("Lobby") == "TeamDeathmatch")then
					if(v:getData("CameraTarget") == source:getName())then
						TeamDeathmatch.spectate(v);
					end
				end
			end
		end
	end,500,1,source)
end)

function setSpawnschutz(player)
	player:setData("Spawnschutz",true);
	player:setAlpha(150);
	
	setTimer(function(player)
		if(isElement(player))then
			player:setData("Spawnschutz",false);
			player:setAlpha(255);
		end
	end,4000,1,player)
end

addCommandHandler("leave",function(player)
	if(player:getData("Lobby") ~= "Eingangshalle")then
		spawn(player);
	end
	player:triggerEvent("disableCollisions",player);
	player:triggerEvent("Countdown.create",player,"unshow");
end)

function spawn(player)
	setCameraTarget(player);
	player:spawn(1310.0999755859,-1367.0999755859,13.5,180,_,0,0);
	player:setData("Lobby","Eingangshalle");
	player:setData("Gespawnt",false);
end