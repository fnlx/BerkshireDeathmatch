--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

local Countdown = {
	"Files/1.png",
	"Files/2.png",
	"Files/3.png",
	"Files/4.png",
	state = false
}

addEvent("Countdown.create",true)
addEventHandler("Countdown.create",root,function(type)
	if(type == "show")then
		if(Countdown.state == false)then
			Countdown.state = true;
			addEventHandler("onClientRender",root,renderCountdown);
		end
	else
		if(Countdown.state == true)then
			Countdown.state = false;
			removeEventHandler("onClientRender",root,renderCountdown);
		end
	end
end)

function renderCountdown()
	if(localPlayer:getData("Countdown") >= 1)then
		dxDrawImage(488*(x/1440), 10*(y/900), 463*(x/1440), 200*(y/900), "Files/"..localPlayer:getData("Countdown")..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end