if GetObjectName(myHero) ~= "Lux" then return end

DatLux = Menu("DatLux", "DatLux")
DatLux:SubMenu("Combo", "Combo")
DatLux.Combo:Boolean("Q", "Use Q", true)
DatLux.Combo:Boolean("W", "Auto W", false)
DatLux.Combo:Boolean("AllyW", "Auto W On Ally", false)
DatLux.Combo:Boolean("E", "Use E", true)
DatLux.Combo:Boolean("R", "Use R", true)
DatLux.Combo:Boolean("RKills", "Use R if kill only", false)
DatLux.Combo:Slider("WMana", "W if Mana is higher than", 30, 1, 100, 1)

DatLux:SubMenu("Harass", "Harass")
DatLux.Harass:Boolean("Q", "Use Q", true)
DatLux.Harass:Boolean("E", "Use E", true)

DatLux:SubMenu("Misc", "Misc")
DatLux.Misc:Boolean("AutoLevels", "Auto Level Spells", false)
DatLux.Misc:List("AutoLevel", "Choose Level Order", 1, {"E-Q-W", "Q-E-W"})
DatLux.Misc:Boolean("UseIgnite", "Use Ignite", true)
DatLux.Misc:Boolean("Interrupt", "Interrupt GapClosers with Q", true)
DatLux.Misc:Boolean("UseZhonyas", "Use Zhonyas", true)
DatLux.Misc:Slider("UseZhonya", "Use Zhonyas at % HP", 30, 1, 100, 1)

DatLux:SubMenu("LaneClear", "Lane Clear")
DatLux.LaneClear:Boolean("Q", "Use Q", true)
DatLux.LaneClear:Boolean("E", "Use E", true)
DatLux.LaneClear:Slider("minioncount2", "Use E if nearby Minions is", 3, 1, 10, 1)
DatLux.LaneClear:Slider("ManaCount", "If Mana is higher than", 30, 1, 100, 1)

DatLux:SubMenu("JungleClear", "Jungle Clear")
DatLux.JungleClear:Boolean("Q", "Use Q", true)
DatLux.JungleClear:Boolean("W", "Use W", false)
DatLux.JungleClear:Boolean("E", "Use E", true)
DatLux.JungleClear:Slider("mobcount2", "Use E if nearby Mobs is", 1, 1, 5, 1)
DatLux.JungleClear:Slider("ManaCount", "If Mana is higher than", 30, 1, 100, 1)
DatLux.JungleClear:Key("keyv", "JungleClear Key", string.byte("V"))

DatLux:SubMenu("JungleSteal", "Steal Dragon / Baron")
DatLux.JungleSteal:Boolean("Q", "Use Q to Steal", false)
DatLux.JungleSteal:Boolean("R", "Use R to Steal", true)

DatLux:SubMenu("Killsteal", "Killsteal")
DatLux.Killsteal:Boolean("Q", "Killsteal with Q", true)
DatLux.Killsteal:Boolean("E", "Killsteal with E", true)
DatLux.Killsteal:Boolean("R", "Killsteal with R", true)
DatLux.Killsteal:Boolean("QE", "Killsteal with Q+E", false)

DatLux:SubMenu("Drawings", "Drawings")
DatLux.Drawings:Boolean("Q", "Draw Q Range", true)
DatLux.Drawings:Boolean("W", "Draw W Range", false)
DatLux.Drawings:Boolean("E", "Draw E Range", false)
DatLux.Drawings:Boolean("R", "Draw R Range", false)
DatLux.Drawings:Slider("DrawFPS", "Quality - Higher is more FPS", 255, 1, 255, 1)

OnLoop(function(myHero)

local myHero = GetMyHero()

Range()
MyDamages()
TargetPrediction()
Combo()
CastW()
Harass()
Misc()
Autolevel()
LaneClear()
JungleClear()
JungleSteal()
KillSteal()
Drawings()

end)

function Range()

	rangeQ = GetCastRange(myHero,_Q)
	rangeW = GetCastRange(myHero,_W)
	rangeE = GetCastRange(myHero,_E)
	rangeR = GetCastRange(myHero,_R)

end	

function MyDamages()

	myDamage = 10 + 50*GetCastLevel(myHero,_Q) + 0.7*GetBonusAP(myHero)
	mySecondDamage = 15 + 45*GetCastLevel(myHero,_E) + 0.6*GetBonusAP(myHero)
	myThirdDamage = 200 + 100*GetCastLevel(myHero,_R) + 0.75*GetBonusAP(myHero)
	
end

function TargetPrediction()

	target = GetCurrentTarget()
	QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,250,1175,70,true,true)
	WPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1400,250,1075,80,true,true)	
	EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1300,250,1100,275,false,true)
	RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,1000,3340,190,false,true)

end

GAPCLOSER_SPELLS = {
    ["Aatrox"]                      = {_Q},
    ["Akali"]                       = {_R},
    ["Alistar"]                     = {_W},
    ["Amumu"]                       = {_Q},
    ["Corki"]                       = {_W},
    ["Diana"]                       = {_R},
    ["FiddleSticks"]                = {_R},
    ["Fiora"]                       = {_Q},
    ["Fizz"]                        = {_Q},
    ["Gnar"]                        = {_E},
    ["Gragas"]                      = {_E},
    ["Graves"]                      = {_E},
    ["Hecarim"]                     = {_R},
    ["Irelia"]                      = {_Q},
    ["Jax"]                         = {_Q},
    ["KhaZix"]                      = {_E},
    ["Lissandra"]                   = {_E},
    ["LeeSin"]                      = {_W},
    ["Leona"]                       = {_E},
    ["Lucian"]                      = {_E},
    ["Malphite"]                    = {_R},
    ["MonkeyKing"]                  = {_E},
    ["Nautilus"]                    = {_Q},
    ["Nocturne"]                    = {_R},
    ["Olaf"]                        = {_R},
    ["Pantheon"]                    = {_W, _R},
    ["Poppy"]                       = {_E},
    ["RekSai"]                      = {_E},
    ["Renekton"]                    = {_E},
    ["Riven"]                       = {_Q, _E},
    ["Rengar"]                      = {_R},
    ["Sejuani"]                     = {_Q},
    ["Sion"]                        = {_R},
    ["Shen"]                        = {_E},
    ["Shyvana"]                     = {_R},
    ["Talon"]                       = {_E},
    ["Thresh"]                      = {_Q},
    ["Tristana"]                    = {_W},
    ["Tryndamere"]                  = {_E},
    ["Udyr"]                        = {_E},
    ["Volibear"]                    = {_Q},
    ["Vi"]                          = {_Q},
    ["XinZhao"]                     = {_E},
    ["Yasuo"]                       = {_E},
    ["Zac"]                         = {_E},
    ["Ziggs"]                       = {_W},
}

local callback = nil
 
OnProcessSpell(function(unit, spell)    
	if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
	local unitChanellingSpells = GAPCLOSER_SPELLS[GetObjectName(unit)]
	if unitChanellingSpells then
		for _, spellSlot in pairs(unitChanellingSpells) do
			if spell.name == GetCastName(unit, spellSlot) then 
				callback(unit, GAPCLOSER_SPELLS) 
			end
		end
	end
end)
 
function addInterrupterCallback( callback0 )
	callback = callback0
end

addInterrupterCallback(function(unit, spellType)
	local unit = GetCurrentTarget()	
	local PredQ = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1200,250,1175,70,true,true)
	if spellType == GAPCLOSER_SPELLS and DatLux.Misc.Interrupt:Value() then
		if CanUseSpell(myHero,_Q) == READY and QPred.HitChance == 1 then
			CastSkillShot(_Q,PredQ.PredPos.x,PredQ.PredPos.y,PredQ.PredPos.z)
		end
	end    	
end)

function Combo()

	if IOW:Mode() == "Combo" and IsTargetable(target) and not IsImmune(target, myHero) and IsObjectAlive(target) and not IsDead(target) then
        if DatLux.Combo.Q:Value() and GoS:ValidTarget (target, 1250) and QPred.HitChance == 1 then
            if CanUseSpell(myHero,_Q) == READY then
                CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
            end
        end
           
        if DatLux.Combo.E:Value() and GoS:ValidTarget (target, rangeE+20) and EPred.HitChance == 1 then
            if CanUseSpell(myHero,_E) == READY then
                CastSkillShot(_E,EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
            end
        end
               
        if DatLux.Combo.R:Value() and GoS:ValidTarget (target, rangeR+20) and RPred.HitChance == 1 then
            if CanUseSpell(myHero,_R) == READY then
                CastSkillShot(_R,RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
            end
        end

		local Ludens = 0

		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
		end	

		for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		local predR = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,1000,3340,190,false,true)	
        	if DatLux.Combo.RKills:Value() and not DatLux.Combo.R:Value() and GoS:ValidTarget (enemy, rangeR+20) and RPred.HitChance == 1 then
            	if CanUseSpell(myHero,_R) == READY and GoS:CalcDamage(myHero, enemy, 0, myThirdDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
                	CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
            	end
        	end
        end	  
    end
end

function CastW()

	if GotBuff(myHero,"recall") ~= 1 and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= DatLux.Combo.WMana:Value() then
    	if DatLux.Combo.W:Value() and GoS:ValidTarget(target,1000) then	
        	if CanUseSpell(myHero, _W) == READY and (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.6 or GotBuff(myHero,"summonerdot") == 1 then
            	CastSkillShot(_W,WPred.PredPos.x, WPred.PredPos.y, WPred.PredPos.z)
        	end
    	end

    	for i,unit in pairs(GoS:GetAllyHeroes()) do
    	local AllyPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1400,250,1075,80,true,true)	
        	if DatLux.Combo.AllyW:Value() then
          		if (GetCurrentHP(unit)/GetMaxHP(unit))<0.6 and GoS:GetDistance(unit) < rangeW+10 and CanUseSpell(myHero,_W) == READY and GetObjectName(myHero) ~= GetObjectName(unit) then
            		if GoS:ValidTarget(target, 1000) then
            			CastSkillShot(_W,AllyPred.PredPos.x, AllyPred.PredPos.y, AllyPred.PredPos.z)
            		end
            	end
        	end
    	end
    end	
end

function Harass()

	if IOW:Mode() == "Harass" and IsTargetable(target) and not IsImmune(target, myHero) and IsObjectAlive(target) and not IsDead(target) then           
        if DatLux.Harass.Q:Value() and GoS:ValidTarget (target, 1250) and QPred.HitChance == 1 then
            if CanUseSpell(myHero,_Q) == READY then
                CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
            end
        end
           
        if DatLux.Harass.E:Value() and GoS:ValidTarget (target, rangeE+20) and EPred.HitChance == 1 then
            if CanUseSpell(myHero,_E) == READY then
                CastSkillShot(_E,EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
            end
        end
	end
end

function Misc()

	for i, enemy in pairs (GoS:GetEnemyHeroes()) do
		local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5
		if Ignite and DatLux.Misc.UseIgnite:Value() then
			if CanUseSpell(myHero,Ignite) and Ignited and GoS:ValidTarget(enemy, GetCastRange(myHero,Ignite)) and not IsImmune(enemy, myHero) then
				CastTargetSpell(enemy, Ignite)
			end
		end

		if DatLux.Misc.UseZhonyas:Value() and GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= DatLux.Misc.UseZhonya:Value() then
			if CanUseSpell(myHero, _R) ~= READY and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _E) ~= READY and GetCurrentHP(enemy)/GetMaxHP(enemy)>=0.20 then
       			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
       		end
       	end			
	end
end	

function Autolevel()

	if not DatLux.Misc.AutoLevels:Value() then return end

	if DatLux.Misc.AutoLevels:Value() then
   		if DatLux.Misc.AutoLevel:Value() == 1 then levelorder = {_Q, _E, _W, _E, _E , _R, _E, _Q, _E , _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
   		elseif DatLux.Misc.AutoLevel:Value() == 2 then levelorder = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
   		end
   	end
   	LevelSpell(levelorder[GetLevel(myHero)])	
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

		if IOW:Mode() == "LaneClear" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= DatLux.LaneClear.ManaCount:Value() then

			local MinionPos = GetOrigin(minion)	

			if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and DatLux.LaneClear.Q:Value() then
				CastSkillShot(_Q,MinionPos.x,MinionPos.y,MinionPos.z)
			end

			if DatLux.LaneClear.E:Value() and GoS:ValidTarget (minion, rangeE-15) and CountEnemyMinionsAround(GetOrigin(myHero),rangeE-15) >= DatLux.LaneClear.minioncount2:Value() then
				if CanUseSpell(myHero,_E) == READY then
					CastSkillShot(_E,MinionPos.x,MinionPos.y,MinionPos.z)
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

		if DatLux.JungleClear.keyv:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= DatLux.JungleClear.ManaCount:Value() then

			local MinionPos = GetOrigin(minion)

			if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and DatLux.JungleClear.Q:Value() then
				CastSkillShot(_Q,MinionPos.x,MinionPos.y,MinionPos.z)
			end

			if CanUseSpell(myHero, _W) == READY and GoS:ValidTarget (minion, rangeQ) and DatLux.JungleClear.W:Value() then
				CastSkillShot(_W,MinionPos.x,MinionPos.y,MinionPos.z)
			end			

			if DatLux.JungleClear.E:Value() and GoS:ValidTarget (minion, rangeE-15) and CountJungleMobsAround(GetOrigin(myHero),rangeE-15) >= DatLux.JungleClear.mobcount2:Value() then
				if CanUseSpell(myHero,_E) == READY then
					CastSkillShot(_E,MinionPos.x,MinionPos.y,MinionPos.z)
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

		if GoS:ValidTarget(minion, rangeQ) and GoS:GetDistance(minion) < rangeQ and not IsImmune(minion, myHero) then 
			if CanUseSpell(myHero, _Q) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Baron" and DatLux.JungleSteal.Q:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
			elseif CanUseSpell(myHero, _Q) == READY and GoS:CalcDamage(myHero, minion, 0, myDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Dragon" and DatLux.JungleSteal.Q:Value() then
				CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
			end
		end

		if GoS:ValidTarget(minion, rangeR) and GoS:GetDistance(minion) < rangeR and not IsImmune(minion, myHero) then		
			if CanUseSpell(myHero, _R) == READY and GoS:CalcDamage(myHero, minion, 0, myThirdDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Dragon" and DatLux.JungleSteal.R:Value() then
				CastSkillShot(_R,BigMobPos.x,BigMobPos.y,BigMobPos.z)
			elseif CanUseSpell(myHero, _R) == READY and GoS:CalcDamage(myHero, minion, 0, myThirdDamage + Ludens) > GetCurrentHP(minion) and GetObjectName(minion) == "SRU_Baron" and DatLux.JungleSteal.R:Value() then
				CastSkillShot(_R,BigMobPos.x,BigMobPos.y,BigMobPos.z)
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

	local predQ = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1200,250,1175,70,true,true)
	local predE = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1300,250,1100,275,false,true)
	local predR = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,1000,3340,190,false,true)

		if DatLux.Killsteal.Q:Value() and GoS:ValidTarget (enemy, rangeQ+25) and predQ.HitChance == 1 and not IsImmune(enemy, myHero) and IsTargetable(enemy) and IsObjectAlive(enemy) and not IsDead(enemy) then
			if CanUseSpell(myHero,_Q) == READY and GoS:CalcDamage(myHero, enemy, 0, myDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_Q,predQ.PredPos.x, predQ.PredPos.y, predQ.PredPos.z)
			end
		end
			                    
		if DatLux.Killsteal.E:Value() and GoS:ValidTarget (enemy, rangeE+25) and predE.HitChance == 1 and not IsImmune(enemy, myHero) and IsTargetable(enemy) and IsObjectAlive(enemy) and not IsDead(enemy) then
			if CanUseSpell(myHero,_E) == READY and GoS:CalcDamage(myHero, enemy, 0, mySecondDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_E,predE.PredPos.x, predE.PredPos.y, predE.PredPos.z)
			end
		end

		if DatLux.Killsteal.R:Value() and GoS:ValidTarget (enemy, rangeR+25) and predR.HitChance == 1 and not IsImmune(enemy, myHero) and IsTargetable(enemy) and IsObjectAlive(enemy) and not IsDead(enemy) then
			if CanUseSpell(myHero,_R) == READY and GoS:CalcDamage(myHero, enemy, 0, myThirdDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
			end
		end

		if DatLux.Killsteal.QE:Value() and GoS:ValidTarget (enemy, rangeQ+15) and predQ.HitChance == 1 and predE.HitChance == 1 and not IsImmune(enemy, myHero) and IsTargetable(enemy) and IsObjectAlive(enemy) and not IsDead(enemy) then
			if CanUseSpell(myHero,_E) == READY and GoS:CalcDamage(myHero, enemy, 0, myDamage + mySecondDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_Q,predQ.PredPos.x, predQ.PredPos.y, predQ.PredPos.z) GoS:DelayAction(function() CastSkillShot(_E,predE.PredPos.x, predE.PredPos.y, predE.PredPos.z) end,500)
			end
		end	
	end
end

function Drawings()

	if DatLux.Drawings.Q:Value() then
											 
		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeQ,3,DatLux.Drawings.DrawFPS:Value(),0xffffffff)   
	end

	if DatLux.Drawings.W:Value() then
											 
		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeW,3,DatLux.Drawings.DrawFPS:Value(),0xff00ffff)   
	end	

	if DatLux.Drawings.E:Value() then

		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeE,3,DatLux.Drawings.DrawFPS:Value(),0xffff0000)
	end

	if DatLux.Drawings.R:Value() then

		DrawCircle(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,rangeR,3,DatLux.Drawings.DrawFPS:Value(),0xff00ff00)
	end
end

PrintChat(string.format("<font color='#ff0000'>DatLux:</font> <font color='#ff9d00'>Loaded.</font>"))
PrintChat(string.format("<font color='#ff0000'>Version:</font> <font color='#ff9d00'>1.0.1</font>"))
PrintChat(string.format("<font color='#ff0000'>Made By:</font> <font color='#ff9d00'>Rakli.</font>"))		             		
