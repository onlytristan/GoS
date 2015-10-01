if GetObjectName(myHero) ~= "Amumu" then return end

AmumuMenu = Menu("DatAmumu", "DatAmumu")
AmumuMenu:SubMenu("Combo", "Combo")
AmumuMenu.Combo:Boolean("Q", "Use Q", true)
AmumuMenu.Combo:Boolean("W", "Use W", true)
AmumuMenu.Combo:Boolean("E", "Use E", true)
AmumuMenu.Combo:Boolean("R", "Use R", true)

AmumuMenu:SubMenu("UltTargets", "Ult if hits")
AmumuMenu.UltTargets:Boolean("Rtwo", "2 Target", false)
AmumuMenu.UltTargets:Boolean("Rthree", "3 Targets", false)
AmumuMenu.UltTargets:Boolean("Rfour", "4 Targets", false)
AmumuMenu.UltTargets:Boolean("Rfive", "5 Targets", false)

AmumuMenu:SubMenu("Harass", "Harass")
AmumuMenu.Harass:Boolean("Q", "Use Q", true)
AmumuMenu.Harass:Boolean("W", "Use W", true)
AmumuMenu.Harass:Boolean("E", "Use E", true)

AmumuMenu:SubMenu("Misc", "Misc")
AmumuMenu.Misc:Boolean("UseIgnite", "Use Ignite", true)
AmumuMenu.Misc:Boolean("UseChilling", "Use Chilling Smite", true)
AmumuMenu.Misc:Boolean("UseSmite", "AutoSmite Baron/Dragon", false)
AmumuMenu.Misc:Boolean("Interrupt", "Interrupt Spells with Q", true)
AmumuMenu.Misc:Boolean("InterruptR", "Interrupt Spells with R", false)
AmumuMenu.Misc:Boolean("UseZhonyas", "Use Zhonyas", true)
AmumuMenu.Misc:Slider("UseZhonya", "Use Zhonyas at % HP", 30, 1, 100, 1)

AmumuMenu:SubMenu("LaneClear", "Lane Clear")
AmumuMenu.LaneClear:Boolean("Q", "Use Q", true)
AmumuMenu.LaneClear:Boolean("W", "Use W", true)
AmumuMenu.LaneClear:Boolean("E", "Use E", true)
AmumuMenu.LaneClear:Slider("minioncount", "Use W if nearby Minions is", 3, 1, 10, 1)
AmumuMenu.LaneClear:Slider("minioncount2", "Use E if nearby Minions is", 3, 1, 5, 1)

AmumuMenu:SubMenu("JungleClear", "Jungle Clear")
AmumuMenu.JungleClear:Boolean("Q", "Use Q", true)
AmumuMenu.JungleClear:Boolean("W", "Use W", true)
AmumuMenu.JungleClear:Boolean("E", "Use E", true)
AmumuMenu.JungleClear:Slider("mobcount", "Use W if nearby Mobs is", 1, 1, 10, 1)
AmumuMenu.JungleClear:Slider("mobcount2", "Use E if nearby Mobs is", 1, 1, 5, 1)
AmumuMenu.JungleClear:Key("keyv", "JungleClear Key", string.byte("V"))

AmumuMenu:SubMenu("JungleSteal", "Steal Dragon / Baron")
AmumuMenu.JungleSteal:Boolean("Q", "Use Q to Steal", true)
AmumuMenu.JungleSteal:Boolean("QSmite", "Use Q + Smite to Steal", false)

AmumuMenu:SubMenu("Killsteal", "Killsteal")
AmumuMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
AmumuMenu.Killsteal:Boolean("E", "Killsteal with E", true)
AmumuMenu.Killsteal:Boolean("R", "Killsteal with R", false)
AmumuMenu.Killsteal:Boolean("QE", "Killsteal with Q+E", false)
AmumuMenu.Killsteal:Boolean("QER", "Killsteal with Q+E+R", false)

AmumuMenu:SubMenu("Drawings", "Drawings")
AmumuMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AmumuMenu.Drawings:Boolean("W", "Draw W Range", true)
AmumuMenu.Drawings:Boolean("E", "Draw E Range", false)
AmumuMenu.Drawings:Boolean("R", "Draw R Range", true)

PrintChat(string.format("<font color='#ff9d00'>DatAmumu:</font> <font color='#ff0000'>Loaded.</font>"))
PrintChat(string.format("<font color='#ff9d00'>Version:</font> <font color='#ff0000'>1.0.4</font>"))
PrintChat(string.format("<font color='#ff9d00'>Made By:</font> <font color='#ff0000'>Rakli.</font>"))

OnLoop(function(myHero)

local myHero = GetMyHero()

Range()
MyDamages()
TargetPrediction()
CastW()
HarassW()
Combo()
UltTargets()		         			
Harass()
SmiteSteal()
Misc()
ChillingSmited()
AutoZhonyas()
LaneClear()
JungleClear()
JungleSteal()
KillSteal()
Drawings()

end)

function Range()

	rangeQ = GetCastRange(myHero,_Q)
	rangeW = 300
	rangeE = GetCastRange(myHero,_E)
	rangeR = GetCastRange(myHero,_R)
	rangeSmite = 500

end	

function MyDamages()

	myDamage = 30 + 50*GetCastLevel(myHero,_Q) + 0.7*GetBonusAP(myHero)
	mySecondDamage = 50 + 25*GetCastLevel(myHero,_E) + 0.5*GetBonusAP(myHero)
	myThirdDamage = 50 + 100*GetCastLevel(myHero,_R) + 0.8*GetBonusAP(myHero)
	
end	

function TargetPrediction()

	target = GetCurrentTarget()
	QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2000,250,1100,80,true,true)

end	

CHANELLING_SPELLS = {
		["Caitlyn"]                     = {_R},
		["Katarina"]                    = {_R},
		["MasterYi"]                    = {_W},
		["FiddleSticks"]                = {_W, _R},
		["Galio"]                       = {_R},
		["Lucian"]                      = {_R},
		["MissFortune"]                 = {_R},
		["VelKoz"]                      = {_R},
		["Nunu"]                        = {_R},
		["Shen"]                        = {_R},
		["Karthus"]                     = {_R},
		["Pantheon"]                    = {_R},
		["Xerath"]                      = {_Q, _R},
		["TahmKench"]                   = {_R},
		["TwistedFate"]                 = {_R}
}

local callback = nil
 
OnProcessSpell(function(unit, spell)    
	if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
	local unitChanellingSpells = CHANELLING_SPELLS[GetObjectName(unit)]
	if unitChanellingSpells then
		for _, spellSlot in pairs(unitChanellingSpells) do
			if spell.name == GetCastName(unit, spellSlot) then 
				callback(unit, CHANELLING_SPELLS) 
			end
		end
	end
end)
 
function addInterrupterCallback( callback0 )
	callback = callback0
end

addInterrupterCallback(function(unit, spellType)
	local unit = GetCurrentTarget()
	local predQ = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),2000,250,1100,80,true,true)
	if spellType == CHANELLING_SPELLS and AmumuMenu.Misc.Interrupt:Value() then
		if CanUseSpell(myHero,_Q) == READY and predQ.HitChance == 1 then
			CastSkillShot(_Q,predQ.PredPos.x,predQ.PredPos.y,predQ.PredPos.z)
		end
	end    	
	if spellType == CHANELLING_SPELLS and AmumuMenu.Misc.InterruptR:Value() and CanUseSpell(myHero,_Q) ~= READY then  
		if CanUseSpell(myHero,_R) == READY and GoS:IsInDistance(unit, rangeR-10) then
			CastSpell(_R)
		end     	
	end
end)

function CastW()

	local RangedEnemies = 0

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do

		if (enemy~=nil and GetTeam(myHero)~=GetTeam(enemy) and IsDead(enemy)==false) and GoS:GetDistance(enemy) <= rangeW then
			RangedEnemies = RangedEnemies + 1
		end		

		if IOW:Mode() == "Combo" then

			if GoS:ValidTarget(enemy, rangeW + 25) and GoS:IsInDistance(enemy,rangeW+25) and CanUseSpell(myHero, _W) == READY and AmumuMenu.Combo.W:Value() and GotBuff(myHero,"AuraofDespair") ~= 1 then
				CastSpell(_W)
			end	

			if CanUseSpell(myHero, _W) == READY and AmumuMenu.Combo.W:Value() and GotBuff(myHero,"AuraofDespair") == 1 and RangedEnemies <= 0 and GoS:EnemiesAround(GetOrigin(myHero), rangeW+10) <= 0 then
				CastSpell(_W)
			end
		end
	end	   	
end

function HarassW()

	local RangedEnemies = 0

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do

		if (enemy~=nil and GetTeam(myHero)~=GetTeam(enemy) and IsDead(enemy)==false) and GoS:GetDistance(enemy) <= rangeW then
			RangedEnemies = RangedEnemies + 1
		end	

		if IOW:Mode() == "Harass" then		

			if GoS:ValidTarget(enemy, rangeW + 25) and GoS:IsInDistance(enemy,rangeW+25) and CanUseSpell(myHero, _W) == READY and AmumuMenu.Harass.W:Value() and GotBuff(myHero,"AuraofDespair") ~= 1 then
				CastSpell(_W)
			end	

			if CanUseSpell(myHero, _W) == READY and AmumuMenu.Harass.W:Value() and GotBuff(myHero,"AuraofDespair") == 1 and RangedEnemies <= 0 and GoS:EnemiesAround(GetOrigin(myHero), rangeW+10) <= 0 then
				CastSpell(_W)
			end
		end
	end
end		      		

function Combo()

	if IOW:Mode() == "Combo" and IsTargetable(target) and not IsDead(target) and IsObjectAlive(target) and not IsImmune(target, myHero) then
		if AmumuMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ + 100) and QPred.HitChance == 1 then
			if CanUseSpell(myHero,_Q) == READY then
				CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end
		end
														
		if AmumuMenu.Combo.E:Value() and GoS:ValidTarget (target, rangeE + 25) and GoS:IsInDistance(target, rangeE-35) then
			if CanUseSpell(myHero,_E) == READY then
				CastSpell(_E)
			end
		end             
	end        
end

function UltTargets()  

	if IOW:Mode() == "Combo" and IsTargetable(target) and not IsDead(target) and IsObjectAlive(target) then
		if AmumuMenu.Combo.R:Value() and GoS:ValidTarget (target, rangeR) then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(target) < rangeR - 25 then
				CastSpell(_R)
			end    	    	
		elseif AmumuMenu.UltTargets.Rtwo:Value() and GoS:ValidTarget (target, rangeR) and GoS:EnemiesAround(GetOrigin(myHero), rangeR-25) >= 2 then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(target) < rangeR - 25 then
				CastSpell(_R)
			end    
		elseif AmumuMenu.UltTargets.Rthree:Value() and GoS:ValidTarget (target, rangeR) and GoS:EnemiesAround(GetOrigin(myHero), rangeR-25) >= 3 then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(target) < rangeR - 25 then
				CastSpell(_R)
			end
		elseif AmumuMenu.UltTargets.Rfour:Value() and GoS:ValidTarget (target, rangeR) and GoS:EnemiesAround(GetOrigin(myHero), rangeR-25) >= 4 then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(target) < rangeR - 25 then
				CastSpell(_R)
			end                               
		elseif AmumuMenu.UltTargets.Rfive:Value() and GoS:ValidTarget (target, rangeR) and GoS:EnemiesAround(GetOrigin(myHero), rangeR-25) >= 5 then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(target) < rangeR - 25 then
				CastSpell(_R)
			end  
		end
	end    
end 

function Harass()

	if IOW:Mode() == "Harass" and IsTargetable(target) and not IsDead(target) and IsObjectAlive(target) and not IsImmune(target, myHero) then
		if AmumuMenu.Harass.Q:Value() and GoS:ValidTarget (target, rangeQ + 100) and QPred.HitChance == 1 then
			if CanUseSpell(myHero,_Q) == READY then
				CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end
		end 			
														
		if AmumuMenu.Harass.E:Value() and GoS:ValidTarget (target, rangeE - 25) then
			if CanUseSpell(myHero,_E) == READY then
				CastSpell(_E)
			end
		end             
	end        
end		           

function SmiteSteal()

	SmiteDamage = 0

	if GetLevel(myHero) == 1 then
		SmiteDamage = SmiteDamage + 390
	end
	if GetLevel(myHero) == 2 then
		SmiteDamage = SmiteDamage + 410
	end
	if GetLevel(myHero) == 3 then
		SmiteDamage = SmiteDamage + 430
	end
	if GetLevel(myHero) == 4 then
		SmiteDamage = SmiteDamage + 450
	end
	if GetLevel(myHero) == 5 then
		SmiteDamage = SmiteDamage + 480
	end
	if GetLevel(myHero) == 6 then
		SmiteDamage = SmiteDamage + 510
	end
	if GetLevel(myHero) == 7 then
		SmiteDamage = SmiteDamage + 540
	end
	if GetLevel(myHero) == 8 then
		SmiteDamage = SmiteDamage + 570
	end
	if GetLevel(myHero) == 9 then
		SmiteDamage = SmiteDamage + 600
	end
	if GetLevel(myHero) == 10 then
		SmiteDamage = SmiteDamage + 640
	end
	if GetLevel(myHero) == 11 then
		SmiteDamage = SmiteDamage + 680
	end
	if GetLevel(myHero) == 12 then
		SmiteDamage = SmiteDamage + 720
	end
	if GetLevel(myHero) == 13 then
		SmiteDamage = SmiteDamage + 760
	end
	if GetLevel(myHero) == 14 then
		SmiteDamage = SmiteDamage + 800
	end
	if GetLevel(myHero) == 15 then
		SmiteDamage = SmiteDamage + 850
	end
	if GetLevel(myHero) == 16 then
		SmiteDamage = SmiteDamage + 900
	end																
	if GetLevel(myHero) == 17 then
		SmiteDamage = SmiteDamage + 950
	end
	if GetLevel(myHero) == 18 then
		SmiteDamage = SmiteDamage + 1000
	end
end

function Misc()

	for i, enemy in pairs (GoS:GetEnemyHeroes()) do
		local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5
		if Ignite and AmumuMenu.Misc.UseIgnite:Value() then
			if CanUseSpell(myHero,Ignite) and Ignited and GoS:ValidTarget(enemy, GetCastRange(myHero,Ignite)) and not IsImmune(enemy, myHero) then
				CastTargetSpell(enemy, Ignite)
			end
		end
	end	  		  

	for i, mobs in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

		if GoS:ValidTarget(mobs, rangeSmite+100) and GoS:GetDistance(mobs) < rangeSmite+25 and Smite then 
			if CanUseSpell(myHero, Smite) == READY and SmiteDamage > GetCurrentHP(mobs) and GetObjectName(mobs) == "SRU_Baron" and AmumuMenu.Misc.UseSmite:Value() then
				CastTargetSpell(mobs, Smite)
			elseif CanUseSpell(myHero, _Q) == READY and SmiteDamage > GetCurrentHP(mobs) and GetObjectName(mobs) == "SRU_Dragon" and AmumuMenu.Misc.UseSmite:Value() then
				CastTargetSpell(mobs, Smite)
			end
		end
	end
end

function ChillingSmited()

	ChillingSmite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("s5_summonersmiteplayerganker") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("s5_summonersmiteplayerganker") and SUMMONER_2 or nil))
		
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
      	if ChillingSmite and AmumuMenu.Misc.UseChilling:Value() and not IsImmune(enemy, myHero) then
            if CanUseSpell(myHero, ChillingSmite) == READY and 20+8*GetLevel(myHero) > GetCurrentHP(enemy)+GetDmgShield(enemy) and GoS:ValidTarget(enemy, 500) then
                CastTargetSpell(enemy, ChillingSmite)
            end
        end
    end
end                

function AutoZhonyas()

	for i, enemy in pairs(GoS:GetEnemyHeroes()) do
		if AmumuMenu.Misc.UseZhonyas:Value() and GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= AmumuMenu.Misc.UseZhonya:Value() then
			if CanUseSpell(myHero, _R) ~= READY then
       			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
       		end
       	end		
	end
end	   

function CountEnemyMinionsAround(pos, range)
	local MinionsAround = 0
		if pos == nil then return 0 end
		for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do 
				if minion and GoS:ValidTarget(minion) and GoS:GetDistanceSqr(pos,GetOrigin(minion)) < range*range then
					MinionsAround = MinionsAround + 1
				end
			end
	return MinionsAround
end

function LaneClear()

	for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do

		if IOW:Mode() == "LaneClear" then

			local MinionPos = GetOrigin(minion)	

			if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and AmumuMenu.LaneClear.Q:Value() then
				CastSkillShot(_Q,MinionPos.x,MinionPos.y,MinionPos.z)
			end

			if GoS:ValidTarget(minion, rangeW + 25) and GoS:IsInDistance(minion,rangeW+25) and CanUseSpell(myHero, _W) == READY and AmumuMenu.LaneClear.W:Value() and GotBuff(myHero,"AuraofDespair") ~= 1 and CountEnemyMinionsAround(GetOrigin(myHero),rangeW+25) >= AmumuMenu.LaneClear.minioncount:Value() then
				CastSpell(_W)
			end	

			if CanUseSpell(myHero, _W) == READY and AmumuMenu.LaneClear.W:Value() and GotBuff(myHero,"AuraofDespair") == 1 and CountEnemyMinionsAround(GetOrigin(myHero),rangeW+25) <= 0 and ManualTurnOffCurrently then
				CastSpell(_W)
			end

			if AmumuMenu.LaneClear.E:Value() and GoS:ValidTarget (minion, rangeE + 25) and CountEnemyMinionsAround(GetOrigin(myHero),rangeW+25) >= AmumuMenu.LaneClear.minioncount2:Value() then
				if CanUseSpell(myHero,_E) == READY then
					CastSpell(_E)
				end
			end  		
		end
	end
end

function CountJungleMobsAround(pos, range)
	local JungleMobsAround = 0
	if pos == nil then return 0 end
		for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do 
			if minion and GoS:ValidTarget(minion) and GoS:GetDistanceSqr(pos,GetOrigin(minion)) < range*range then
				JungleMobsAround = JungleMobsAround + 1
			end
		end
	return JungleMobsAround
end

function JungleClear()

	for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

		if AmumuMenu.JungleClear.keyv:Value() then

			local MinionPos = GetOrigin(minion)

			if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and AmumuMenu.JungleClear.Q:Value() then
				CastSkillShot(_Q,MinionPos.x,MinionPos.y,MinionPos.z)
			end

			if GoS:ValidTarget(minion, rangeW + 25) and GoS:IsInDistance(minion,rangeW+25) and CanUseSpell(myHero, _W) == READY and AmumuMenu.JungleClear.W:Value() and GotBuff(myHero,"AuraofDespair") ~= 1 and CountJungleMobsAround(GetOrigin(myHero),rangeW+25) >= AmumuMenu.JungleClear.mobcount:Value()then
				CastSpell(_W)
			end	

			if CanUseSpell(myHero, _W) == READY and AmumuMenu.JungleClear.W:Value() and GotBuff(myHero,"AuraofDespair") == 1 and CountJungleMobsAround(GetOrigin(myHero),rangeW+25) <= 0 and ManualTurnOffCurrently then
				CastSpell(_W)
			end

			if AmumuMenu.JungleClear.E:Value() and GoS:ValidTarget (minion, rangeE + 25) and CountJungleMobsAround(GetOrigin(myHero),rangeW+25) >= AmumuMenu.JungleClear.mobcount2:Value() then
				if CanUseSpell(myHero,_E) == READY then
					CastSpell(_E)
				end
			end 
		end
	end	
end

function JungleSteal()

	for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

		local BigMobPos = GetOrigin(minion)

		local Ludens = 0

		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
		end	

		if GoS:ValidTarget(minion, rangeQ) and GoS:GetDistance(minion) < rangeQ and Smite and not IsImmune(minion, myHero) then 
			if CanUseSpell(myHero, _Q) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Baron" and AmumuMenu.JungleSteal.Q:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
			elseif CanUseSpell(myHero, _Q) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Dragon" and AmumuMenu.JungleSteal.Q:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
			elseif CanUseSpell(myHero, _Q) == READY and CanUseSpell(myHero,Smite) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + SmiteDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Dragon" and AmumuMenu.JungleSteal.QSmite:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z) GoS:DelayAction(function() CastTargetSpell(minion, Smite) end,630)
			elseif CanUseSpell(myHero, _Q) == READY and CanUseSpell(myHero,Smite) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + SmiteDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Baron" and AmumuMenu.JungleSteal.QSmite:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z) GoS:DelayAction(function() CastTargetSpell(minion, Smite) end,630)
			end											
		end
	end
end

function KillSteal()

	local Ludens = 0

	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
	end	

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		if AmumuMenu.Killsteal.Q:Value() and GoS:ValidTarget (enemy, rangeQ + 100) and QPred.HitChance == 1 and not IsImmune(enemy, myHero) then
			if CanUseSpell(myHero,_Q) == READY and GoS:CalcDamage(myHero, enemy, 0, myDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end                    
		elseif AmumuMenu.Killsteal.E:Value() and GoS:ValidTarget (enemy, rangeE + 25) and GoS:IsInDistance(enemy, rangeE-35) then
			if CanUseSpell(myHero,_E) == READY and GoS:CalcDamage(myHero, enemy, 0, mySecondDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSpell(_E)
			end
		elseif AmumuMenu.Killsteal.R:Value() and GoS:ValidTarget (enemy, rangeR) then
			if CanUseSpell(myHero,_R) == READY and GoS:GetDistance(enemy) < rangeR - 25 and GoS:CalcDamage(myHero, enemy, 0, myThirdDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSpell(_R)
			end
		elseif AmumuMenu.Killsteal.QE:Value() and GoS:ValidTarget (enemy, rangeQ + 100) and QPred.HitChance == 1 then
			if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY and GoS:CalcDamage(myHero, enemy, 0, myDamage + mySecondDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z) GoS:DelayAction(function() CastSpell(_E) end,650)
			end
		elseif AmumuMenu.Killsteal.QER:Value() and GoS:ValidTarget (enemy, rangeR + 100) and GoS:IsInDistance(enemy, rangeR-25) and QPred.HitChance == 1 then
			if CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY and CanUseSpell(myHero,_R) == READY and GoS:CalcDamage(myHero, enemy, 0, myDamage + mySecondDamage + myThirdDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSpell(_R) GoS:DelayAction(function() CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z) end,50) GoS:DelayAction(function() CastSpell(_E) end,500)
			end
		end
	end
end

function Drawings()

	if AmumuMenu.Drawings.Q:Value() then
											 
		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeQ,3,100,0xffffffff)   
	end

	if AmumuMenu.Drawings.W:Value() then
											 
		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeW,3,100,0xff0000ff)   
	end	

	if AmumuMenu.Drawings.E:Value() then

		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeE,3,100,0xff00ff00)
	end

	if AmumuMenu.Drawings.R:Value() then

		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeR,3,100,0xffff0000)
	end
end        				        
