local ver = "0.05"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "JarvanIV" then return end


require("DamageLib")
require("OpenPredict")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/JarvanIV/master/JarvanIV.lua', SCRIPT_PATH .. 'JarvanIV.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/JarvanIV/master/JarvanIV.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local JarvanIVMenu = Menu("JarvanIV", "JarvanIV")

JarvanIVMenu:SubMenu("Combo", "Combo")

JarvanIVMenu.Combo:Boolean("Q", "Use Q in combo", true)
JarvanIVMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
JarvanIVMenu.Combo:Boolean("W", "Use W in combo", true)
JarvanIVMenu.Combo:Boolean("E", "Use E in combo", true)
JarvanIVMenu.Combo:Slider("Epred", "E Hit Chance", 3,0,10,1)
JarvanIVMenu.Combo:Boolean("R", "Use R in combo", true)
JarvanIVMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
JarvanIVMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
JarvanIVMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
JarvanIVMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
JarvanIVMenu.Combo:Boolean("RHydra", "Use RHydra", true)
JarvanIVMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
JarvanIVMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
JarvanIVMenu.Combo:Boolean("Randuins", "Use Randuins", true)
JarvanIVMenu.Combo:Boolean("THydra", "Use THydra", true)


JarvanIVMenu:SubMenu("AutoMode", "AutoMode")
JarvanIVMenu.AutoMode:Boolean("Level", "Auto level spells", false)
JarvanIVMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
JarvanIVMenu.AutoMode:Boolean("Q", "Auto Q", false)
JarvanIVMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
JarvanIVMenu.AutoMode:Boolean("W", "Auto W", false)
JarvanIVMenu.AutoMode:Boolean("E", "Auto E", false)
JarvanIVMenu.AutoMode:Slider("Epred", "E Hit Chance", 3,0,10,1)
JarvanIVMenu.AutoMode:Boolean("R", "Auto R", false)

JarvanIVMenu:SubMenu("LaneClear", "LaneClear")
JarvanIVMenu.LaneClear:Boolean("Q", "Use Q", true)
JarvanIVMenu.LaneClear:Boolean("W", "Use W", true)
JarvanIVMenu.LaneClear:Boolean("E", "Use E", true)
JarvanIVMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
JarvanIVMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

JarvanIVMenu:SubMenu("Harass", "Harass")
JarvanIVMenu.Harass:Boolean("Q", "Use Q", true)
JarvanIVMenu.Harass:Boolean("W", "Use W", true)

JarvanIVMenu:SubMenu("KillSteal", "KillSteal")
JarvanIVMenu.KillSteal:Boolean("Q", "KS w Q", true)
JarvanIVMenu.KillSteal:Boolean("E", "KS w E", true)

JarvanIVMenu:SubMenu("AutoIgnite", "AutoIgnite")
JarvanIVMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

JarvanIVMenu:SubMenu("Drawings", "Drawings")
JarvanIVMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

JarvanIVMenu:SubMenu("SkinChanger", "SkinChanger")
JarvanIVMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
JarvanIVMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
	local THydra = GetItemSlot(myHero, 3748)	
	local JarvanQ = {delay = .6, range = 770, width = 70, speed = math.huge}
	local JarvanE = {delay = .5, range = 700, width = 175, speed = math.huge}

	--AUTO LEVEL UP
	if JarvanIVMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if JarvanIVMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 770) then
				if target ~= nil then 
                                      CastSkillShot(_Q, target)
                                end
            end

            if JarvanIVMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if JarvanIVMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if JarvanIVMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if JarvanIVMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if JarvanIVMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end
				
	   if JarvanIVMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end		
			
	    if JarvanIVMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
                local EPred = GetPrediction(target,JarvanE)
                       if EPred.hitChance > (JarvanIVMenu.Combo.Epred:Value() * 0.1) then
                                 CastSkillShot(_E,EPred.castPos)
                       end
            end
	

            if JarvanIVMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
                local QPred = GetPrediction(target,JarvanQ)
                       if QPred.hitChance > (JarvanIVMenu.Combo.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
            end

            

            if JarvanIVMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if JarvanIVMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if JarvanIVMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if JarvanIVMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastSpell(_W)
	    end
	    
	    
            if JarvanIVMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 650) and (EnemiesAround(myHeroPos(), 650) >= JarvanIVMenu.Combo.RX:Value()) then
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
                
                if IsReady(_Q) and ValidTarget(enemy, 770) and JarvanIVMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 830) and JarvanIVMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if JarvanIVMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 770) then
	        	CastSkillShot(_Q, target)
                end

                if JarvanIVMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastSpell(_W)
	        end

                if JarvanIVMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastTargetSpell(target, _E)
	        end

                if JarvanIVMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if JarvanIVMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if JarvanIVMenu.AutoMode.Q:Value() and Ready(_Q) and ValidTarget(target, 770) then
                local QPred = GetPrediction(target,JarvanQ)
                       if QPred.hitChance > (JarvanIVMenu.AutoMode.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
        end
        if JarvanIVMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastSpell(_W)
          end
        end
        if JarvanIVMenu.AutoMode.E:Value() and Ready(_E) and ValidTarget(target, 700) then
                local EPred = GetPrediction(target,JarvanE)
                       if EPred.hitChance > (JarvanIVMenu.AutoMode.Epred:Value() * 0.1) then
                                 CastSkillShot(_E,EPred.castPos)
                       end
        end
        if JarvanIVMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 650) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if JarvanIVMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if JarvanIVMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 770, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("JarvanIVempowertwo") then 
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
	if JarvanIVMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>JarvanIV</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





