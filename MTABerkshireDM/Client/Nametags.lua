-- Addon für das Berkshire Deathmatch von fnlx

_NTAG = {	}


--// LOCAL VARIABLE // 

local w,h = guiGetScreenSize() 
local _font = "arial"

--//***************//


function _NTAG:DISABLE_DEFAULT(  b_STATE,b_SPEC_PLAYER ) 
	local t_all = getElementsByType("player") 
	if not b_SPEC_PLAYER then 
		for _,player in ipairs( t_all ) do 
			setPlayerNametagShowing ( player,  b_STATE ) 
		end
	else setPlayerNametagShowing ( b_SPEC_PLAYER,  b_STATE ) 
	end
end



function _NTAG._RENDER( ) 
	local t_all = getElementsByType("player") 
	local px,py,pz,lx,ly,lz = getCameraMatrix( ) 
	local x,y,sx,sy,sz,b_width,b_height,tx,ty,tz,health,armor
	local x1, y1, z1 = getPedTargetStart ( localPlayer )
	local x2, y2, z2 = getPedTargetEnd ( localPlayer )
	local b_ped = isPedAiming ( localPlayer )
	local max_dist = 40.00
	local scale_factor = 0.01
	local dim = getElementDimension( localPlayer )
	local int = getElementInterior( localPlayer ) 
	local b_calcwidth,b_calcheight,armor_color,dxNameWidth,dxSize,s_pname,p_dim,p_int,s_color,h_color
	for key, player in ipairs( t_all ) do
		p_dim = getElementDimension( player) 
		p_int = getElementInterior( player ) 
		if p_dim == dim and int == p_int then 
			if player ~= localPlayer then 
				tx, ty, tz = getElementPosition( player )
				dist = math.sqrt( ( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2 )
				if dist < max_dist then
					if isLineOfSightClear( px, py, pz, tx, ty, tz, true, false, false, true, false, true, false,localPlayer ) then
						sx, sy, sz = getPedBonePosition( player, 8 )
						if sx and sy and sz then 
							x,y = getScreenFromWorldPosition( sx, sy, sz + 0.4 )
							b_width = math.abs(w*0.038-(dist*scale_factor))
							b_height = math.abs(h*0.005-(dist*scale_factor))
							health = getElementHealth( player ) 
							armor = getPedArmor( player ) 
							armor_color = calcArmor( armor)
							h_color =  {calcRGBByHP ( player ) }
							if armor > 0 then 
								s_color = tocolor(armor_color ,armor_color,armor_color,255)
							else 
								armor_color =  0
								s_color = tocolor(h_color[1],h_color[2],h_color[3],255)
							end
							s_pname = getPlayerName(player)
							dxSize = math.abs(1.2 -( dist*0.01))
							dxNameWidth = dxGetTextWidth(s_pname,dxSize,_font)
							b_width = dxNameWidth/1.2
							b_calcwidth = (b_width*health/100)
							dxFontHeight = dxGetFontHeight( dxSize,_font)
							if x and y then 
								dxDrawRectangle((x-b_width/2)-1,y-1,b_calcwidth+2,b_height+2,tocolor(armor_color,armor_color,armor_color,220))
								dxDrawRectangle(x-b_width/2,y,b_calcwidth,b_height,tocolor(180,0,0,220))
							
								--// NAME
								dxDrawText(s_pname, (x-dxNameWidth/2)-1,(y-b_height-(dxFontHeight*1.2))-1, x+dxNameWidth/2,y-b_height,tocolor(0,0,0,255),dxSize,_font,"center","center")
								dxDrawText(s_pname, (x-dxNameWidth/2)+1,(y-b_height-(dxFontHeight*1.2))+1, x+dxNameWidth/2,y-b_height,tocolor(0,0,0,255),dxSize,_font,"center","center")
								dxDrawText(s_pname, x-dxNameWidth/2,y-b_height-(dxFontHeight*1.2), x+dxNameWidth/2,y-b_height,s_color,dxSize,_font,"center","center")
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,_NTAG._RENDER)


function calcRGBByHP ( player )

	local hp = getElementHealth ( player )
	if hp <= 0 then
		return 0, 0, 0
	else
		hp = math.abs ( hp - 0.01 )
		return ( 100 - hp ) * 2.55 / 2, ( hp * 2.55 ), 0
	end
end
