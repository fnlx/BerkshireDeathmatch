--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

local InfoboxText = nil;
local InfoboxState = false;

function infobox(text)
	tickCount = getTickCount();
	InfoboxText = text;
	if(InfoboxState == false)then
		InfoboxState = true;
		addEventHandler("onClientRender",root,InfoboxRender);
		InfoboxTimer = setTimer(function()
			InfoboxState = false;
			removeEventHandler("onClientRender",root,InfoboxRender);
		end,6000,1)
	end
end
addEvent("infobox",true)
addEventHandler("infobox",root,infobox)

function InfoboxRender()
    dxDrawRectangle(0*(x/1440), 860*(y/900), 1440*(x/1440), 40*(y/900), tocolor(0, 0, 0, 200), false)
    dxDrawText(InfoboxText, 0*(x/1440), 860*(y/900), 1440*(x/1440), 900*(y/900), tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, true, false, false, false)
end