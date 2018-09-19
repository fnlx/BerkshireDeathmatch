--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

x,y = guiGetScreenSize();
GUIEditor = {window = {}, button = {}, edit = {}, gridlist = {}, label = {}}

weaponDamages = {}
weaponDamages[24] = 46
weaponDamages[29] = 8
weaponDamages[31] = 8
weaponDamages[33] = 23

bindKey("b","down",function()
	if(not(localPlayer:getData("ElementClicked")) == true)then
		showCursor(not(isCursorShowing()));
	end
end)

addEventHandler("onClientPlayerDamage",root,function(attacker,weapon,part,loss)
	if(localPlayer:getData("Spawnschutz") == true)then
		cancelEvent();
	end
	
	if(attacker)then
		if(localPlayer:getData("Team") == attacker:getData("Team"))then
			cancelEvent();
		end
	end
	
	if(attacker == localPlayer)then
		if(attacker and wepaon and bodypart and loss)then
			if(weaponDamages[weapon])then
				triggerServerEvent("damageCalcServer",localPlayer,attacker,wepaon,bodypart,loss,source);
			end
		end
	end
end)

function isWindow()
	if(isElement(GUIEditor.window[1]) or localPlayer:getData("ElementClicked") == true)then
		return false
	else
		return true
	end
end

function setWindowDatas(type,labelid,cursor)
	if(type == "set")then
		localPlayer:setData("ElementClicked",true);
		showChat(false);
		if(not(cursor))then showCursor(true)end
		if(labelid)then
			for i = 1,labelid do
			
			end
		end
	else
		localPlayer:setData("ElementClicked",false);
		showChat(true);
	end
end

function disableCollisions()
	for _,v in pairs(getElementsByType("player"))do
		v:setCollisionsEnabled(true);
		if(localPlayer:getData("Lobby") == "TeamDeathmatch")then
			if(v:getData("Lobby") == "TeamDeathmatch")then
				if(v:getData("Team") ~= v:getData("Team"))then
					v:setCollisionsEnabled(false);
				end
			end
		end
	end
end
addEvent("disableCollisions",true)
addEventHandler("disableCollisions",root,disableCollisions)