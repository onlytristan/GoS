if GetObjectName(myHero) ~= "Morgana" then return end

-- Morgana script --
-- Change log is on my thread, type suggestions and comments in the thread. (Version 1.3) --

-- Menu --
 
MorganaMenu = Menu("DatMorgana", "DatMorgana")
MorganaMenu:SubMenu("Combo", "Combo")
MorganaMenu.Combo:Boolean("Q", "Use Q", true)
MorganaMenu.Combo:Boolean("W", "Use W", false)
MorganaMenu.Combo:Boolean("WQ", "W with Q only", true)
MorganaMenu.Combo:Boolean("E", "Use E on Self", false)
MorganaMenu.Combo:Boolean("Shield", "Use E on Ally", true)
MorganaMenu.Combo:Boolean("R", "Use R", true)
MorganaMenu.Combo:Boolean("TwoR", "Use R on 2+", false)
MorganaMenu.Combo:Boolean("ThreeR", "Use R only 3", false)

MorganaMenu:SubMenu("Harass", "Harass")
MorganaMenu.Harass:Boolean("Q", "Use Q", true)
MorganaMenu.Harass:Boolean("W", "Use W", true)

MorganaMenu:SubMenu("Misc", "Misc")
MorganaMenu.Misc:Boolean("UseIgnite", "Use Ignite", true)
MorganaMenu.Misc:Boolean("InterrupterON", "Q - Interrupt Gapclose Spells", true)

MorganaMenu:SubMenu("LaneClear", "Lane Clear")
MorganaMenu.LaneClear:Boolean("Q", "Use Q", true)
MorganaMenu.LaneClear:Boolean("W", "Use W", true)

MorganaMenu:SubMenu("JungleClear", "Jungle Clear")
MorganaMenu.JungleClear:Boolean("Q", "Use Q", true)
MorganaMenu.JungleClear:Boolean("W", "Use W", true)
MorganaMenu.JungleClear:Key("Junglekey", "Jungle Clear", string.byte("V"))

MorganaMenu:SubMenu("JungleSteal", "Steal Dragon / Baron")
MorganaMenu.JungleSteal:Boolean("Q", "Use Q to Steal", true)

MorganaMenu:SubMenu("Zhonya", "Use Zhonya at % HP:")
MorganaMenu.Zhonya:Boolean("ZhonyaOne", "Zhonya at 50% HP", false)
MorganaMenu.Zhonya:Boolean("ZhonyaTwo", "Zhonya at 40% HP", false)
MorganaMenu.Zhonya:Boolean("ZhonyaThree", "Zhonya at 30% HP", true)
MorganaMenu.Zhonya:Boolean("ZhonyaFour", "Zhonya at 20% HP", false)

MorganaMenu:SubMenu("Killsteal", "Killsteal")
MorganaMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
MorganaMenu.Killsteal:Boolean("R", "Killsteal with R", false)

MorganaMenu:SubMenu("Drawings", "Drawings")
MorganaMenu.Drawings:Boolean("Q", "Draw Q Range", true)
MorganaMenu.Drawings:Boolean("E", "Draw E Range", false)
MorganaMenu.Drawings:Boolean("R", "Draw R Range", false)

PrintChat(string.format("<font color='#ff9d00'>DatMorgana:</font> <font color='#ff0000'>Loaded.</font>"))
PrintChat(string.format("<font color='#ff9d00'>Version:</font> <font color='#ff0000'>1.3</font>"))
PrintChat(string.format("<font color='#ff9d00'>Made By:</font> <font color='#ff0000'>Rakli.</font>"))

OnLoop(function(myHero)
local myHero = GetMyHero()

Range()
Combo()
Harass()
Enemyheroes()
AutoIgnite()
LaneClear()
JungleClear()
BaronDragonSteal()
Drawings()			         			

end)

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
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),unit,GetMoveSpeed(unit),1200,250,1175,75,true,true)
	if spellType == GAPCLOSER_SPELLS and MorganaMenu.Misc.InterrupterON:Value() then
		if CanUseSpell(myHero,_Q) == READY and QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end    	
end)

function CountEnemyHeroInRange(object,range)
	object = object or myHero
	range = range or 480
	local enemyInRange = 0
		for i, enemy in pairs(GoS:GetEnemyHeroes()) do
    		if (enemy~=nil and GetTeam(myHero)~=GetTeam(enemy) and IsDead(enemy)==false) and GoS:GetDistance(object, enemy)<= 480 then
    			enemyInRange = enemyInRange + 1
    		end
  		end
	return enemyInRange
end

function Range()

	rangeQ = GetCastRange(myHero,_Q)
	rangeW = GetCastRange(myHero,_W)
	rangeE = GetCastRange(myHero,_E)
	rangeR = GetCastRange(myHero,_R)
end	

function Combo()
	local target = GetCurrentTarget()
	local predQ = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,250,1175,75,true,true)
	local EnemyPos = GetOrigin(target)

	                if IOW:Mode() == "Combo" and IsTargetable(target) and not IsImmune(target, myHero) then
                        if MorganaMenu.Combo.Q:Value() and GoS:ValidTarget (target, 1500) and predQ.HitChance == 1 then
                                if CanUseSpell(myHero,_Q) == READY then
                                    CastSkillShot(_Q,predQ.PredPos.x, predQ.PredPos.y, predQ.PredPos.z)
                                end
                        end
 
                        if MorganaMenu.Combo.W:Value() and GoS:ValidTarget(target,rangeW) then
                        	if CanUseSpell(myHero, _W) == READY then
                        		CastSkillShot(_W,EnemyPos.x,EnemyPos.y,EnemyPos.z)
                        	end	
                       
                        elseif MorganaMenu.Combo.WQ:Value() and GoS:ValidTarget (target, rangeW) then
                        	if GotBuff(target, "DarkBindingMissile") == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                    CastSkillShot(_W,EnemyPos.x,EnemyPos.y,EnemyPos.z)
                                end
                            end
                        end        
 
                        if MorganaMenu.Combo.E:Value() and GoS:ValidTarget (target, 1000) then
                            if (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.6 then
                                if CanUseSpell(myHero,_E) == READY then
                                    CastTargetSpell(myHero,_E)
                                end    
                            end
                        end
               
                        if MorganaMenu.Combo.R:Value() and GoS:ValidTarget (target, rangeR) then
                            if CanUseSpell(myHero,_R) == READY then
                                CastSpell(_R)
                            end    
                        end                 

            			for i,unit in pairs(GoS:GetAllyHeroes()) do
            				if MorganaMenu.Combo.Shield:Value() then
            					if (GetCurrentHP(unit)/GetMaxHP(unit))<0.6 and GoS:GetDistance(unit) < 1000 and CanUseSpell(myHero,_E) == READY then
            						if GoS:ValidTarget(target, 1200) then
            							CastTargetSpell(unit,_E)
            						end
            					end
            				end
           				end  
           			end
end

function Harass()
	local target = GetCurrentTarget()
	local predQ = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,250,1175,75,true,true)
	local EnemyPos = GetOrigin(target)	

		if IOW:Mode() == "Harass" and IsTargetable(target) and not IsImmune(target, myHero) then
               
   			if MorganaMenu.Harass.Q:Value() and GoS:ValidTarget (target, 1500) and predQ.HitChance == 1 then
       			if CanUseSpell(myHero,_Q) == READY then
            		CastSkillShot(_Q,predQ.PredPos.x, predQ.PredPos.y, predQ.PredPos.z)
        		end    
    		end
                       
			if MorganaMenu.Harass.W:Value() and GoS:ValidTarget (target, rangeW) then
				if GotBuff(target, "DarkBindingMissile") == 1 then
    				if CanUseSpell(myHero,_W) == READY then
        				CastSkillShot(_W,EnemyPos.x,EnemyPos.y,EnemyPos.z)
    				end    
				end    
			end 
		end
end

function Enemyheroes()

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do

	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1200,250,1175,75,true,true)
	local dmgQ = (GetCastLevel(myHero,_Q))*55 + 25 + 0.9*GetBonusAP(myHero) 
	local dmgR = (GetCastLevel(myHero,_R))*75 + 75 + 0.7*GetBonusAP(myHero)

	local Ludens = 0

		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
		end	

	if IsTargetable(enemy) and not IsImmune(target, myHero) then
	    
		if CanUseSpell(myHero,_Q) == READY and MorganaMenu.Killsteal.Q:Value() and QPred.HitChance == 1 and GoS:ValidTarget(enemy, 1300) and GoS:CalcDamage(myHero, enemy, 0, dmgQ + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
			CastSkillShot(_Q,QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
		end	
						
		if CanUseSpell(myHero,_R) == READY and MorganaMenu.Killsteal.R:Value() and GoS:ValidTarget(enemy, rangeR) and GoS:CalcDamage(myHero, enemy, 0, dmgR + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
			CastSpell(_R)
		end
	end		  

		if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.50 and MorganaMenu.Zhonya.ZhonyaOne:Value() and GotBuff(enemy, "SoulShackles") > 0 then
        	CastTargetSpell(myHero, GetItemSlot(myHero,3157))
		end

		if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.40 and MorganaMenu.Zhonya.ZhonyaTwo:Value() and GotBuff(enemy, "SoulShackles") > 0 then
			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
		end

		if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.30 and MorganaMenu.Zhonya.ZhonyaThree:Value() and GotBuff(enemy, "SoulShackles") > 0 then
			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
		end

		if GetItemSlot(myHero,3157) > 0 and GoS:ValidTarget (enemy, 900) and GetCurrentHP(myHero)/GetMaxHP(myHero) < 0.20 and MorganaMenu.Zhonya.ZhonyaFour:Value() and GotBuff(enemy, "SoulShackles") > 0 then
			CastTargetSpell(myHero, GetItemSlot(myHero,3157))
		end				  

		if GotBuff(enemy, "SoulShackles") > 0 then
			CastTargetSpell(myHero, _E)
		end

		if IOW:Mode() == "Combo" then	

			if CanUseSpell(myHero, _R) == READY and (CountEnemyHeroInRange(enemy,510))>=2 and GoS:ValidTarget(enemy,510) and MorganaMenu.Combo.TwoR:Value() then
				CastSpell(_R)
			end	

			if CanUseSpell(myHero, _R) == READY and (CountEnemyHeroInRange(enemy,510))>=3 and GoS:ValidTarget(enemy,510) and MorganaMenu.Combo.ThreeR:Value() then
				CastSpell(_R)
			end	
		end	
	end
end

function AutoIgnite()
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5
		if Ignite and MorganaMenu.Misc.UseIgnite:Value() and not IsImmune(enemy, myHero) then
            if CanUseSpell(myHero,Ignite) and Ignited and GoS:ValidTarget(enemy, GetCastRange(myHero,Ignite)) then
                CastTargetSpell(enemy, Ignite)
            end
        end
    end
end          

function LaneClear()

	if IOW:Mode() == "LaneClear" then
		for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
			if GoS:ValidTarget(minion, rangeQ) then
				MinionPos = GetOrigin(minion)
					if CanUseSpell(myHero, _Q) == READY and MorganaMenu.LaneClear.Q:Value() then
						CastSkillShot(_Q,MinionPos.x,MinionPos.y,MinionPos.z)
					end

					if CanUseSpell(myHero, _W) == READY and MorganaMenu.LaneClear.W:Value() then
						CastSkillShot(_W,MinionPos.x,MinionPos.y,MinionPos.z)
					end
			end
		end
	end
end	

function JungleClear()

	if MorganaMenu.JungleClear.Junglekey:Value() then
		for i,junglemobs in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
			if GoS:ValidTarget(junglemobs, rangeQ) then
				JungleMobPos = GetOrigin(junglemobs)
					if CanUseSpell(myHero, _Q) == READY and MorganaMenu.JungleClear.Q:Value() then
						CastSkillShot(_Q,JungleMobPos.x,JungleMobPos.y,JungleMobPos.z)
					end

					if CanUseSpell(myHero, _W) == READY and MorganaMenu.JungleClear.W:Value() then
						CastSkillShot(_W,JungleMobPos.x,JungleMobPos.y,JungleMobPos.z)
					end	
			end
		end
	end
end

function BaronDragonSteal()

	for i,bigmobs in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

		local myDamage = 25 + 55*GetCastLevel(myHero,_Q) + 0.9*GetBonusAP(myHero)
		local BigMobPos = GetOrigin(bigmobs)

		local Ludens = 0

			if GotBuff(myHero, "itemmagicshankcharge") > 99 then
				Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
			end	

			if GoS:ValidTarget(bigmobs, rangeQ) and GoS:GetDistance(bigmobs) < rangeQ then 
				if CanUseSpell(myHero, _Q) == READY and  GoS:CalcDamage(myHero, bigmobs, 0, myDamage + Ludens) > GetCurrentHP(bigmobs) and GetObjectName(bigmobs) == "SRU_Baron" and MorganaMenu.JungleSteal.Q:Value() then
					CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
				elseif CanUseSpell(myHero, _Q) == READY and  GoS:CalcDamage(myHero, bigmobs, 0, myDamage + Ludens) > GetCurrentHP(bigmobs) and GetObjectName(bigmobs) == "SRU_Dragon" and MorganaMenu.JungleSteal.Q:Value() then
					CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
				end
			end
	end
end	

function Drawings()

	if MorganaMenu.Drawings.Q:Value() then
                       
    	DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,rangeQ,3,100,0xff00ff000)   
	end

	if MorganaMenu.Drawings.E:Value() then

		DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,rangeE,3,100,0xff00ff00)
	end

	if MorganaMenu.Drawings.R:Value() then

		DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,rangeR,3,100,0xff00ff00)
	end
end	  							           				   	
