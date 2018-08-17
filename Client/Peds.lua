--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

local Peds = {
	{100,1306.900390625,-1384,13.800000190735,270,"Team Deathmatch","TeamDeathmatch.join"},
	{299,1306.900390625,-1381,13.800000190735,270,"Deagle Arena","DeagleArena.join"},
	{181,1306.900390625,-1378,13.800000190735,270,"Shop"}
}

function loadPeds()
	for _,v in pairs(Peds)do
		local ped = createPed(v[1],v[2],v[3],v[4],v[5]);
		ped:setFrozen(true);
		ped:setData("Name",v[6]);
		if(v[7])then ped:setData("Event",v[7])end
		
		addEventHandler("onClientPedDamage",ped,function() cancelEvent()end)
	end
end
loadPeds();

addEventHandler("onClientRender",root,function()
	for _,v in pairs(getElementsByType("ped"))do
		if(v:getDimension() == localPlayer:getDimension() and v:getInterior() == localPlayer:getInterior())then
			local px,py,pz = getPedBonePosition(v,8);
			local lx,ly,lz = getPedBonePosition(localPlayer,8);
				
			if(getDistanceBetweenPoints3D(px,py,pz,lx,ly,lz) <= 15 and isLineOfSightClear(px,py,pz,lx,ly,lz,true,false,false,true,false))then
				if(v:getData("Name"))then
					local worldx,worldy = getScreenFromWorldPosition(px,py,pz+0.5,1000,true);
					
					if(getDistanceBetweenPoints3D(px,py,pz,lx,ly,lz) > 1)then
						scale = 0.6 - (getDistanceBetweenPoints3D(px,py,pz,lx,ly,lz)/70);
					else
						scale = 0.6;
					end
					
					if(worldx and worldy)then
						if(isWindow())then
							dxDrawText(v:getData("Name"),worldx,worldy,worldx,worldy,tocolor(0,0,0),scale,"bankgothic","center","center");
							dxDrawText(v:getData("Name"),worldx-2,worldy-2,worldx,worldy,tocolor(0,255,0),scale,"bankgothic","center","center");
							dxDrawText("Zum Interagieren anklicken.",worldx,worldy+30,worldx,worldy,tocolor(0,0,0),scale*0.6,"bankgothic","center","center");
							dxDrawText("Zum Interagieren anklicken.",worldx-2,worldy+29,worldx,worldy,tocolor(0,255,0),scale*0.6,"bankgothic","center","center");
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onClientClick",root,function(button,state,absx,absy,wx,wy,wz,element)
	if(element and element:getType() == "ped" and state == "down")then
		local x,y,z = getElementPosition(localPlayer);
		if(getDistanceBetweenPoints3D(x,y,z,wx,wy,wz) <= 3)then
			if(element:getData("Event"))then
				triggerServerEvent(element:getData("Event"),localPlayer);
			end
		end
	end
end)