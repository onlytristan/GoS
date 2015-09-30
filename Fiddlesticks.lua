if GetObjectName(myHero) ~= "Fiddlesticks" then return end

-- Fiddlesticks Script --
-- Current version is 1.0, type suggestions in thread --

-- Script info --

local info = "DatFiddle v1.0 by Rakli"
local thread = "Type suggestions in my topic :)"
local bugs = "If you find any bugs, make sure to report them on topic"
textTable = {info,thread,bugs}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])

-- Menu --

FiddleMenu = Menu("DatFiddle", "DatFiddle")
FiddleMenu:SubMenu("Combo", "Combo")
FiddleMenu.Combo:Boolean("Q", "Use Q", true)
FiddleMenu.Combo:Boolean("W", "Use W", true)
FiddleMenu.Combo:Boolean("E", "Use E", true)
FiddleMenu.Combo:Boolean("R", "Use R", true)
FiddleMenu.Combo:Boolean("FewR", "Use R on 2+", false)

FiddleMenu:SubMenu("Harass", "Harass")
FiddleMenu.Harass:Boolean("Q", "Use Q", true)
FiddleMenu.Harass:Boolean("W", "Use W", true)
FiddleMenu.Harass:Boolean("E", "Use E", true)

FiddleMenu:SubMenu("Misc", "Misc")
FiddleMenu.Misc:Boolean("UseIgnite", "Use Auto Ignite", true)
FiddleMenu.Misc:Boolean("UseChilling", "Auto Chilling Smite", true)

FiddleMenu:SubMenu("LaneClear", "Lane Clear")
FiddleMenu.LaneClear:Boolean("W", "Use W", true)
FiddleMenu.LaneClear:Boolean("E", "Use E", true)

FiddleMenu:SubMenu("JungleClear", "Jungle Clear")
FiddleMenu.JungleClear:Boolean("W", "Use W", true)
FiddleMenu.JungleClear:Boolean("E", "Use E", true)
FiddleMenu.JungleClear:Key("Junglekey", "Jungle Clear", string.byte("V"))

FiddleMenu:SubMenu("Zhonya", "Use Zhonya's Hourglass")
FiddleMenu.Zhonya:Boolean("ZhonyaOne", "Zhonya at 50% HP", false)
FiddleMenu.Zhonya:Boolean("ZhonyaTwo", "Zhonya at 40% HP", false)
FiddleMenu.Zhonya:Boolean("ZhonyaThree", "Zhonya at 30% HP", true)
FiddleMenu.Zhonya:Boolean("ZhonyaFour", "Zhonya at 20% HP", false)

FiddleMenu:SubMenu("Killsteal", "Killsteal")
FiddleMenu.Killsteal:Boolean("E", "Killsteal with E", true)

FiddleMenu:SubMenu("Drawings", "Drawings")
FiddleMenu.Drawings:Boolean("Q", "Draw Q/W Range", true)
FiddleMenu.Drawings:Boolean("E", "Draw E Range", true)

OnLoop(function(myHero)	
FiddleROnMultiple()
AutoIgnited()
ChillingSmited()

	-- Combo --

	if IOW:Mode() == "Combo" then
		local target = GetCurrentTarget()
		local EnemyPos = GetOrigin(target)	 

				-- W Orb Delay --

				if CanUseSpell(myHero, _W) == ONCOOLDOWN then IOW:DisableOrbwalking() GoS:DelayAction(function()
					if GotBuff (myHero,"fearmonger_marker") ~= 1 then GoS:DelayAction(function() IOW:EnableOrbwalking() end,200)
					end
				end,800)
				end

				-- Combo Spells --

				if CanUseSpell(myHero, _R) == READY and GoS:ValidTarget(target, 1500) and FiddleMenu.Combo.R:Value() then
					CastSkillShot(_R,EnemyPos.x,EnemyPos.y,EnemyPos.z)					
				end		

				if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 575) and FiddleMenu.Combo.Q:Value() then
					CastTargetSpell(target,_Q)
				end
					
				if CanUseSpell(myHero, _W) ~= ONCOOLDOWN and GoS:ValidTarget(target, GetCastRange(myHero,_W)) and FiddleMenu.Combo.W:Value() and GoS:GetDistance(myHero, target) < 500 then
					if CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY then
						CastTargetSpell(target, _W)
					end	
				end
					 
				if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(target, 750) and FiddleMenu.Combo.E:Value() then
					CastTargetSpell(target, _E)
				end

				-- Zhonya at customizable health percentages --

				if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (target, 600) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.20 and FiddleMenu.Zhonya.ZhonyaOne:Value() and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY and GotBuff(myHero, "Crowstorm") > 0 then
        			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
				end	

				if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (target, 600) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.30 and FiddleMenu.Zhonya.ZhonyaTwo:Value() and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY and GotBuff(myHero, "Crowstorm") > 0 then
        			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
				end	

				if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (target, 600) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.40 and FiddleMenu.Zhonya.ZhonyaThree:Value() and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY and GotBuff(myHero, "Crowstorm") > 0 then
        			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
				end	

				if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (target, 600) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.50 and FiddleMenu.Zhonya.ZhonyaFour:Value() and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY and GotBuff(myHero, "Crowstorm") > 0 then
        			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
				end											
	end			

-- Harass--

	if IOW:Mode() == "Harass" then
		local target = GetCurrentTarget()

				if CanUseSpell(myHero, _Q) == READY and FiddleMenu.Harass.Q:Value() and GoS:ValidTarget(target, 575) then
					CastTargetSpell(target, _Q)
				end
					
				if CanUseSpell(myHero, _W) ~= ONCOOLDOWN and FiddleMenu.Harass.W:Value() and GoS:ValidTarget(target, GetCastRange(myHero,_W)) then
					if CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY then
						CastTargetSpell(target, _W)					
					end	
				end
					  
				if CanUseSpell(myHero, _E) and FiddleMenu.Harass.E:Value() and GoS:ValidTarget(target, 750) then
					CastTargetSpell(target, _E)
				end
	end

-- Lane Clear --

if IOW:Mode() == "LaneClear" then
	for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
		if GoS:ValidTarget(minion, GetCastRange(myHero,_W)) then
			MinionPos = GetOrigin(minion)
				if CanUseSpell(myHero, _W) == READY and FiddleMenu.LaneClear.W:Value() then
					CastTargetSpell(minion,_W)
				end

				if CanUseSpell(myHero, _E) == READY and FiddleMenu.LaneClear.E:Value() then
					CastTargetSpell(minion,_E)
				end
		end
	end
end					

-- Jungle Clear --

if FiddleMenu.JungleClear.Junglekey:Value() then
	for i,junglemobs in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
		if GoS:ValidTarget(junglemobs, GetCastRange(myHero,_E)) then
				if CanUseSpell(myHero, _W) == READY and FiddleMenu.JungleClear.W:Value() then
					CastTargetSpell(junglemobs,_W)
				end

				if CanUseSpell(myHero, _E) == READY and FiddleMenu.JungleClear.E:Value() then
					CastTargetSpell(junglemobs, _E)
				end	
		end
	end
end		

-- Killsteal --

for i,enemy in pairs(GoS:GetEnemyHeroes()) do	
    local Ludens = 0

		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
		end	
					
		if CanUseSpell(myHero, _E) and GoS:ValidTarget(enemy,750) and FiddleMenu.Killsteal.E:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_E) + 45 + 0.45*GetBonusAP(myHero) + Ludens) then
			CastTargetSpell(enemy, _E)
		end
end

-- Use R on more than one enemy -- 

local PosEnemy = GetOrigin(enemy)

	if IOW:Mode() == "Combo" then	

		if CanUseSpell(myHero, _R) == READY and (FiddleROnMultiple(enemy,GetCastRange(myHero,_R)))>=2 and GoS:ValidTarget(enemy,1500) and FiddleMenu.Combo.FewR:Value() then
			CastSkillShot(_R,PosEnemy.x,PosEnemy.y,PosEnemy.z)
		end	
	end	

-- Drawings --

	if FiddleMenu.Drawings.Q:Value() then
		DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xff00ff00)
	end

	if FiddleMenu.Drawings.E:Value() then 
		DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_E),3,100,0xff00ff000)
	end
end)

-- Auto Ignite function --

function AutoIgnited()   

local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(target)+GetDmgShield(target)+GetHPRegen(target)*2.5
	if Ignite and FiddleMenu.Misc.UseIgnite:Value() then
        if CanUseSpell(myHero,Ignite) and Ignited and GoS:ValidTarget(enemy, GetCastRange(myHero,Ignite)) then
            CastTargetSpell(enemy, Ignite)
        end
    end
end        

-- Auto ChillingSmite function --

function ChillingSmited()

	ChillingSmite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("s5_summonersmiteplayerganker") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("s5_summonersmiteplayerganker") and SUMMONER_2 or nil))
	
	local Smited = 20+8*GetLevel(myHero) > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)
	for i, enemy in pairs(GoS:GetEnemyHeroes()) do
        if ChillingSmite and FiddleMenu.Misc.UseChilling:Value() then
            if CanUseSpell(myHero, ChillingSmite) == READY and Smited and GoS:ValidTarget(enemy, 500) then
                CastTargetSpell(enemy, ChillingSmite)
            end
        end
    end
end         

-- Multi R function --

function FiddleROnMultiple(object,range)
	object = object or myHero
	range = range or GetCastRange(myHero, _R)
	local enemyInRange = 0
		for i, enemy in pairs(GoS:GetEnemyHeroes()) do
    		if (enemy~=nil and GetTeam(myHero)~=GetTeam(enemy) and IsDead(enemy)==false) and GoS:GetDistance(object, enemy) <= GetCastRange(myHero,_R) then
    			enemyInRange = enemyInRange + 1
    		end
  		end
  	return enemyInRange
end
