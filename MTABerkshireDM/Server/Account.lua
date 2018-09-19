--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

handler = dbConnect("mysql","dbname=berkshiredm;host=localhost","root","");
local Datas = {"Kills","Tode"}

function checkAccount(player)
	fadeCamera(player,true);
	setCameraMatrix(player,1323.9797363281,-1399.5152587891,30.124000549316,1323.5296630859,-1398.7646484375,29.640254974365);
	local result = dbPoll(dbQuery(handler,"SELECT * FROM accounts WHERE Serial = '"..player:getSerial().."'"),-1);
	if(#result >= 1)then
		setPlayerDatas(player);
	else
		outputChatBox("[INFO]: Anscheinend hast du noch keinen Account bei uns. Tippe /newAccount [Passwort], um dir einen zu erstellen.",player,200,200,0);
		outputChatBox("Sollte sich deine Serial geändert haben und du möchtest dich in einen bereits bestehenden Account einloggen, nutze bitte /oldAccount [Name], [Passwort].",player,200,200,0);
	end
end

addCommandHandler("oldAccount",function(player,cmd,name,password)
	if(name and password)then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM accounts WHERE Name = '"..name.."' AND Password = '"..md5(password).."'"),-1);
		if(#result >= 1)then
			dbExec(handler,"UPDATE accounts SET Serial = '"..player:getSerial().."' WHERE Name = '"..name.."'");
			infobox(player,"Die Serial deines Accounts wurde aktualisiert. Ab sofort wird du automatisch eingeloggt.");
			setPlayerDatas(player);
		else outputChatBox("Es existiert kein Account mit dieser Name/Passwort Kombination!",player,125,0,0)end
	else outputChatBox("Syntax: /oldAccount [Name], [Passwort]",player,125,0,0)end
end)

addCommandHandler("newAccount",function(player,cmd,password)
	if(password)then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM accounts WHERE Name = '"..player:getName().."'"),-1);
		if(#result == 0)then
			dbExec(handler,"INSERT INTO accounts (Name,Password,Serial) VALUES ('"..player:getName().."','"..md5(password).."','"..player:getSerial().."')");
			infobox(player,"Dein Account wurde angelegt. Ab sofort wirst du automatisch eingeloggt.");
			setPlayerDatas(player);
		else outputChatBox("Dein Name ist bereits vergeben, bitte wähle einen anderen (/nick)!",player,125,0,0)end
	else outputChatBox("Syntax: /newAccount [Passwort]",player,125,0,0)end
end)

function setPlayerDatas(player)
	outputChatBox("Willkommen, "..player:getName().."! Wir wünschen dir viel Spaß.",player,200,200,0);
	spawn(player);
	
	for _,v in pairs(Datas)do
		player:setData(v,getDatabaseData("accounts","Name",player:getName(),v));
	end
end

addEventHandler("onPlayerJoin",root,function()
	checkAccount(source);
end)

for _,v in pairs(getElementsByType("player"))do
	checkAccount(v);
end