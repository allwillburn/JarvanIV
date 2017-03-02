local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Jarvan IV" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Jarvan IV/master/Jarvan IV.lua', SCRIPT_PATH .. 'Jarvan IV.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Jarvan IV/master/Jarvan IV.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local Jarvan IVMenu = Menu("Jarvan IV", "Jarvan IV")

Jarvan IVMenu:SubMenu("Combo", "Combo")

Jarvan IVMenu.Combo:Boolean("Q", "Use Q in combo", true)
Jarvan IVMenu.Combo:Boolean("W", "Use W in combo", true)
Jarvan IVMenu.Combo:Boolean("E", "Use E in combo", true)
Jarvan IVMenu.Combo:Boolean("R", "Use R in combo", true)
Jarvan IVMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
Jarvan IVMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
Jarvan IVMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
Jarvan IVMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
Jarvan IVMenu.Combo:Boolean("RHydra", "Use RHydra", true)
Jarvan IVMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
Jarvan IVMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
Jarvan IVMenu.Combo:Boolean("Randuins", "Use Randuins", true)


Jarvan IVMenu:SubMenu("AutoMode", "AutoMode")
Jarvan IVMenu.AutoMode:Boolean("Level", "Auto level spells", false)
Jarvan IVMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
Jarvan IVMenu.AutoMode:Boolean("Q", "Auto Q", false)
Jarvan IVMenu.AutoMode:Boolean("W", "Auto W", false)
Jarvan IVMenu.AutoMode:Boolean("E", "Auto E", false)
Jarvan IVMenu.AutoMode:Boolean("R", "Auto R", false)

Jarvan IVMenu:SubMenu("LaneClear", "LaneClear")
Jarvan IVMenu.LaneClear:Boolean("Q", "Use Q", true)
Jarvan IVMenu.LaneClear:Boolean("W", "Use W", true)
Jarvan IVMenu.LaneClear:Boolean("E", "Use E", true)
Jarvan IVMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
Jarvan IVMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

Jarvan IVMenu:SubMenu("Harass", "Harass")
Jarvan IVMenu.Harass:Boolean("Q", "Use Q", true)
Jarvan IVMenu.Harass:Boolean("W", "Use W", true)

Jarvan IVMenu:SubMenu("KillSteal", "KillSteal")
Jarvan IVMenu.KillSteal:Boolean("Q", "KS w Q", true)
Jarvan IVMenu.KillSteal:Boolean("E", "KS w E", true)

Jarvan IVMenu:SubMenu("AutoIgnite", "AutoIgnite")
Jarvan IVMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

Jarvan IVMenu:SubMenu("Drawings", "Drawings")
Jarvan IVMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

Jarvan IVMenu:SubMenu("SkinChanger", "SkinChanger")
Jarvan IVMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
Jarvan IVMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if Jarvan IVMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if Jarvan IVMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 770) then
				if target ~= nil then 
                                      CastSkillShot(_Q, target)
                                end
            end

            if Jarvan IVMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if Jarvan IVMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if Jarvan IVMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if Jarvan IVMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if Jarvan IVMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if Jarvan IVMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 830) then
			 CastTargetSpell(target, _E)
	    end

            if Jarvan IVMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 770) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end

            if Jarvan IVMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if Jarvan IVMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if Jarvan IVMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if Jarvan IVMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastSpell(_W)
	    end
	    
	    
            if Jarvan IVMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 650) and (EnemiesAround(myHeroPos(), 650) >= Jarvan IVMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 770) and Jarvan IVMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 830) and Jarvan IVMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if Jarvan IVMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 770) then
	        	CastSkillShot(_Q, target)
                end

                if Jarvan IVMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastSpell(_W)
	        end

                if Jarvan IVMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastTargetSpell(target, _E)
	        end

                if Jarvan IVMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if Jarvan IVMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if Jarvan IVMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 770) then
		      CastSkillShot(_Q, target)
          end
        end 
        if Jarvan IVMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastSpell(_W)
          end
        end
        if Jarvan IVMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 830) then
		     CastTargetSpell(target, _E)
	  end
        end
        if Jarvan IVMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 650) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if Jarvan IVMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if Jarvan IVMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 770, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Jarvan IVempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if Jarvan IVMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Jarvan IV</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





