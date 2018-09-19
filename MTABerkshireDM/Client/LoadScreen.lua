--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

local LoadScreen = {text = nil,
	["Fakten"] = {
		"Nach Berkshire County Reloaded und Berkshire Apocalypse, ist Berkshire Deathmatch bereits der dritte Gamemode der Berkshire Reihe.",
		"Xendom sein Glied ist ungewöhnlich groß, wodurch es ihm möglich ist, tödliche Cockschellen zu verteilen.",
		"Das Grundgerüst des Berkshire Deathmatch Gamemode ist in gerade einmal zwei Stunden entstanden.",
		"Xendom wurde oftmals beleidigt, da seine Gegner keine Chance gegen seine Mp5 Kenntnisse hatten, wodurch sie traurig wurden."
	}
}

function LoadScreen.create()
	setWindowDatas("set",_,true);
	fadeCamera(false);
	local rnd = math.random(1,#LoadScreen["Fakten"]);
	LoadScreen.text = LoadScreen["Fakten"][rnd];
	addEventHandler("onClientRender",root,LoadScreen.render);
	setTimer(function()
		setWindowDatas("reset");
		fadeCamera(true);
		removeEventHandler("onClientRender",root,LoadScreen.render);
	end,4000,1)
end
addEvent("LoadScreen.create",true)
addEventHandler("LoadScreen.create",root,LoadScreen.create)

function LoadScreen.render()
    dxDrawImage(488*(x/1440), 10*(y/900), 463*(x/1440), 200*(y/900), "Files/Logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("Wusstest du schon?", 557*(x/1440), 220*(y/900), 884*(x/1440), 284*(y/900), tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, false, false, false)
    dxDrawText(LoadScreen.text, 488*(x/1440), 294*(y/900), 951*(x/1440), 372*(y/900), tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, true, false, false, false)
end