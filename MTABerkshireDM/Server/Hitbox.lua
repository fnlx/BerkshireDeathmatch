--//
--|| Berkshire Deathmatch
--|| (c) Xendom
--\\

weaponDamages = {}
weaponDamages[24] = 46
weaponDamages[29] = 8
weaponDamages[31] = 8
weaponDamages[33] = 23

addEvent("damageCalcServer",true)
addEventHandler("damageCalcServer",root,function(attacker,bodypart,loss,player)
	if(attacker and weapon and bodypart and loss)then
		local basicDMG = weaponDamages[weapon];
		
		if(bodypart == 9)then multiply = 1.5 else multiply = 1.0 end
		damagePlayer(player,basicDMG*multiply,attacker,weapon);
	end
end)

function damagePlayer(player,amount,damager,weapon)
	if(isElement(player))then
		local armor = player:getArmor();
		local health = player:getHealth();
		
		if(armor > 0)then
			if(armor >= amount)then
				player:setArmor(player,armor - amount);
			else
				player:setArmor(player,0);
				amount = math.abs(armor - amount);
				player:setHealth(player,health - amount);
				
				if(player:getHealth() - amount <= 0)then
					killPed(player,damager,weapon,3,false);
				end
			end
		else
			if(player:getHealth(player) - amount <= 0)then
				killPed(player,damager,weapon,3,false);
			end
			player:setHealth(player,health - amount);
		end
	end
end