if GetObjectName(myHero) ~= "Annie" then return end

-- Annie script (IOW Supported)--
-- Change log is on thread, current version is 1.7 --

PrintChat(string.format("<font color='#ff9d00'>DatAnnie:</font> <font color='#ff0000'>Loaded.</font>"))
PrintChat(string.format("<font color='#ff9d00'>Version:</font> <font color='#ff0000'>1.7</font>"))
PrintChat(string.format("<font color='#ff9d00'>Made By:</font> <font color='#ff0000'>Rakli.</font>"))

-- Menu --
 
AnnieMenu = Menu("DatAnnie", "DatAnnie")
AnnieMenu:SubMenu("RegularCombo", "Combo Everyone")
AnnieMenu.RegularCombo:Boolean("Q", "Use Q", true)
AnnieMenu.RegularCombo:Boolean("W", "Use W", true)
AnnieMenu.RegularCombo:Boolean("E", "Use E", true)
AnnieMenu.RegularCombo:Boolean("R", "Use R", true)
AnnieMenu.RegularCombo:Boolean("stunR", "Use Stun-R", false)
AnnieMenu.RegularCombo:Boolean("MultiR", "Use R on 2+", false)

AnnieMenu:SubMenu("Combo", "Combo LowHP Focus")
AnnieMenu.Combo:Boolean("Q", "Use Q", false)
AnnieMenu.Combo:Boolean("W", "Use W", false)
AnnieMenu.Combo:Boolean("E", "Use E", false)
AnnieMenu.Combo:Boolean("R", "Use R", false)
AnnieMenu.Combo:Boolean("stunR", "Use Stun-R", false)
AnnieMenu.Combo:Boolean("MultiR", "Use R on 2+", false)

AnnieMenu:SubMenu("Harass", "Harass")
AnnieMenu.Harass:Boolean("Q", "Use Q", true)
AnnieMenu.Harass:Boolean("W", "Use W", true)

AnnieMenu:SubMenu("AutoIgnite", "Auto Ignite")
AnnieMenu.AutoIgnite:Boolean("UseIgnite", "Use Ignite", true)

AnnieMenu:SubMenu("KillableEnemy", "Draw if enemy killable")
AnnieMenu.KillableEnemy:Boolean("DrawQWR", "Draw if killable Q+W+R", true)
AnnieMenu.KillableEnemy:Boolean("DrawQW", "Draw if killable Q+W", false)
AnnieMenu.KillableEnemy:Boolean("DrawQ", "Draw if killable Q", false)

AnnieMenu:SubMenu("SmartKS", "Smart Killsteal")
AnnieMenu.SmartKS:Boolean("SmartKSQ", "SmartKS with Q", true)
AnnieMenu.SmartKS:Boolean("SmartKSW", "SmartKS with W", true)
AnnieMenu.SmartKS:Boolean("SmartKSR", "SmartKS with R", false)
AnnieMenu.SmartKS:Boolean("SmartKSQW", "SmartKS with Q+W", true)

AnnieMenu:SubMenu("Autolevel", "Auto Level")
AnnieMenu.Autolevel:Boolean("Autolvl", "Auto level", false)

AnnieMenu:SubMenu("Lasthit", "LastHit")
AnnieMenu.Lasthit:Boolean("Q", "LastHit with Q", true)
AnnieMenu.Lasthit:Boolean("NoStunQ", "LastHit Q if No Stun Ready", false)

AnnieMenu:SubMenu("Drawings", "Drawings")
AnnieMenu.Drawings:Boolean("Q", "Draw Q Range", true)

AnnieMenu:SubMenu("LaneClears", "Lane Clear")
AnnieMenu.LaneClears:Boolean("Q", "Use Q", true)
AnnieMenu.LaneClears:Boolean("W", "Use W", true)
AnnieMenu.LaneClears:Slider("minioncount", "Use W if nearby Minions is", 3, 1, 10, 1)
AnnieMenu.LaneClears:Boolean("E", "Use E", true)

AnnieMenu:SubMenu("JungleClears", "Jungle Clear")
AnnieMenu.JungleClears:Boolean("Q", "Use Q", true)
AnnieMenu.JungleClears:Boolean("W", "Use W", true)
AnnieMenu.JungleClears:Boolean("E", "Use E", true)
AnnieMenu.JungleClears:Key("keyv", "JungleClear Key", string.byte("V"))

OnLoop(function(myHero)

local myHero = GetMyHero()

Combo()
LastHit()
AutoLevel()
Range()
HpChecks()
KillAbleDrawings()
KillableDraws()
Harass()
SmartKS()
Drawings()
LaneClearing()
JungleClearing()
                                								
end)

-- Spells Range --

function Range()

    rangeQ = GetCastRange(myHero,_Q)
    rangeW = GetCastRange(myHero,_W)
    rangeR = GetCastRange(myHero,_R)
end

-- Check MaxHP and CurrentHP --

function HpChecks()

    CurrentHP = GetCurrentHP(myHero)
    MaxHp = GetMaxHP(myHero)
end 								

-- Draw if enemy is killable With Q W Ult--

function KillAbleDrawings()

	if CanUseSpell(myHero, _R) ~= READY then return end

	local QDamage = 45 + 35*GetCastLevel(myHero,_Q) + 0.8*GetBonusAP(myHero) 
	local WDamage = 35 + 45*GetCastLevel(myHero,_W) + 0.85*GetBonusAP(myHero)
	local RDamage = 50 + 125*GetCastLevel(myHero,_R) + 0.80*GetBonusAP(myHero)   

	local Ludens = 0

	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
	end	

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		info = ""
		if not AnnieMenu.KillableEnemy.DrawQW:Value() and not AnnieMenu.KillableEnemy.DrawQ:Value() and CanUseSpell(myHero, _R) == READY and IsObjectAlive(enemy) and IsVisible(enemy) and GoS:GetDistance(enemy) <= 2100 then
			if GoS:CalcDamage(myHero, enemy, 0, QDamage + WDamage + RDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then		
				info = info..GetObjectName(enemy)
					info = info.." is killable with Q+W+R"
			end
		end
	end		
	DrawText(info,75,650,55,0xffff0000)
end	

-- Draw if enemy is killable With Q W or just Q --

function KillableDraws()

	local QDamage = 45 + 35*GetCastLevel(myHero,_Q) + 0.8*GetBonusAP(myHero) 
	local WDamage = 35 + 45*GetCastLevel(myHero,_W) + 0.85*GetBonusAP(myHero)
	local RDamage = 50 + 125*GetCastLevel(myHero,_R) + 0.80*GetBonusAP(myHero)   

	local Ludens = 0

	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
	end	

	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		info1 = ""
		if not AnnieMenu.KillableEnemy.DrawQWR:Value() and not AnnieMenu.KillableEnemy.DrawQ:Value() and GoS:GetDistance(enemy) <= 2100 and IsObjectAlive(enemy) and IsVisible(enemy) and GoS:CalcDamage(myHero, enemy, 0, QDamage + WDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then 
			info1 = info1..GetObjectName(enemy) 
				info1 = info1.." is killable with Q+W"
		end

		info2 = ""
		if not AnnieMenu.KillableEnemy.DrawQWR:Value() and not AnnieMenu.KillableEnemy.DrawQW:Value() and GoS:GetDistance(enemy) <= 1000 and IsObjectAlive(enemy) and IsVisible(enemy) and GoS:CalcDamage(myHero, enemy, 0, QDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then 
			info2 = info2..GetObjectName(enemy) 
				info2 = info2.." is killable with Q"
		end
	end
	DrawText(info1,75,650,55,0xffff0000)
	DrawText(info2,75,650,55,0xffff0000)			
end

-- Counts enemies around for Multi targets on R -- 

function CountEnemyHeroInRange(object,range)
	object = object or myHero
  	local enemyInRange = 0
  		for i, enemy in pairs(GoS:GetEnemyHeroes()) do
    		if (enemy~=nil and GetTeam(myHero)~=GetTeam(enemy) and IsDead(enemy)==false) and GoS:GetDistance(object, enemy)<= rangeR - 50 then
    			enemyInRange = enemyInRange + 1
    		end
  		end
  	return enemyInRange
end    

-- Too large combo function T_T --

function Combo()

	local target = GetCurrentTarget()
	local predW = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,250,625,50,false,true)
	local predR = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,250,1000,50,false,true)     

	-- Combo and Stun-R (LOW HP FOCUS + NO TANK FOCUS)--

	if not AnnieMenu.RegularCombo.Q:Value() and not AnnieMenu.RegularCombo.W:Value() and not AnnieMenu.RegularCombo.E:Value() and not AnnieMenu.RegularCombo.R:Value() and not AnnieMenu.RegularCombo.stunR:Value() and not AnnieMenu.RegularCombo.MultiR:Value() then
		if target == nil or GetOrigin(target) == nil or IsDead(target) or not IsVisible(target) or GetTeam(target) == GetTeam(myHero) then return false end
			if GetMagicResist(target) < 50 and GetCurrentHP(target)/GetMaxHP(target) < 0.2 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end

            elseif GetMagicResist(target) < 50 and GetCurrentHP(target)/GetMaxHP(target) < 0.4 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end            
            elseif GetMagicResist(target) < 50 and GetCurrentHP(target)/GetMaxHP(target) < 0.6 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 50 and GetCurrentHP(target)/GetMaxHP(target) < 0.8 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 50 and GetCurrentHP(target)/GetMaxHP(target) <= 1.0 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 70 and GetCurrentHP(target)/GetMaxHP(target) < 0.2 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 70 and GetCurrentHP(target)/GetMaxHP(target) < 0.4 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 70 and GetCurrentHP(target)/GetMaxHP(target) < 0.6 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 70 and GetCurrentHP(target)/GetMaxHP(target) < 0.8 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 70 and GetCurrentHP(target)/GetMaxHP(target) <= 1.0 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end            elseif GetMagicResist(target) < 100 and GetCurrentHP(target)/GetMaxHP(target) < 0.2 then

            elseif GetMagicResist(target) < 100 and GetCurrentHP(target)/GetMaxHP(target) < 0.4 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 100 and GetCurrentHP(target)/GetMaxHP(target) < 0.6 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 100 and GetCurrentHP(target)/GetMaxHP(target) < 0.8 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 100 and GetCurrentHP(target)/GetMaxHP(target) <= 1.0 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 125 and GetCurrentHP(target)/GetMaxHP(target) < 0.2 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 125 and GetCurrentHP(target)/GetMaxHP(target) < 0.4 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end            
            elseif GetMagicResist(target) < 125 and GetCurrentHP(target)/GetMaxHP(target) < 0.6 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 125 and GetCurrentHP(target)/GetMaxHP(target) < 0.8 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetMagicResist(target) < 125 and GetCurrentHP(target)/GetMaxHP(target) <= 1.0 then	
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetCurrentHP(target)/GetMaxHP(target) < 0.2 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetCurrentHP(target)/GetMaxHP(target) < 0.4 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetCurrentHP(target)/GetMaxHP(target) < 0.6 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetCurrentHP(target)/GetMaxHP(target) < 0.8 then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            elseif GetCurrentHP(target)/GetMaxHP(target) <= 1.0 then
                 if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.Combo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.Combo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.Combo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.Combo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.Combo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end            
                end
            end
    end

			-- Regular Combo (No LowHP Focus)--
	
			if not AnnieMenu.Combo.Q:Value() and not AnnieMenu.Combo.W:Value() and not AnnieMenu.Combo.E:Value() and not AnnieMenu.Combo.R:Value() and not AnnieMenu.Combo.stunR:Value() and not AnnieMenu.Combo.MultiR:Value() then
                if IOW:Mode() == "Combo" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
                        if AnnieMenu.RegularCombo.Q:Value() and GoS:ValidTarget (target, rangeQ) then
                                if CanUseSpell(myHero,_Q) == READY then
                                        CastTargetSpell(target,_Q)
                                end
                        end
 
                       
                        if AnnieMenu.RegularCombo.W:Value() and GoS:ValidTarget (target, 700) and predW.HitChance == 1 then
                                if CanUseSpell(myHero,_W) == READY then
                                        CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
                                end
                        end
 
                        if AnnieMenu.RegularCombo.E:Value() and GoS:ValidTarget (target, 600) then
                                if (CurrentHP/MaxHp)<0.8 and
                                        CanUseSpell(myHero,_E) == READY then
                                                CastSpell(_E)
                                end
                        end
               
                        if AnnieMenu.RegularCombo.stunR:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                    if GotBuff(myHero,"pyromania_particle") == 1 then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                    end    
                                end    
                               
                       
 
                        elseif AnnieMenu.RegularCombo.R:Value() and GoS:ValidTarget (target, 1000) and predR.HitChance == 1 then
                                if CanUseSpell(myHero,_R) == READY then
                                        CastSkillShot(_R,predR.PredPos.x, predR.PredPos.y, predR.PredPos.z)
                                end
                        end        
                end
            end    

end

-- Harass --

function Harass()

	local target = GetCurrentTarget()
	local predW = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1400,250,rangeW,50,false,true)

	if IOW:Mode() == "Harass" and IsObjectAlive(target) and IsTargetable(target) and not IsImmune(target, myHero) then
               
    	if AnnieMenu.Harass.Q:Value() and GoS:ValidTarget (target, rangeQ) then
        	if CanUseSpell(myHero,_Q) == READY then
            	CastTargetSpell(target,_Q)
        	end    
    	end
                       
		if AnnieMenu.Harass.W:Value() and GoS:ValidTarget (target, rangeW) and predW.HitChance == 1 then
    		if CanUseSpell(myHero,_W) == READY then
        		CastSkillShot(_W,predW.PredPos.x, predW.PredPos.y, predW.PredPos.z)
    		end    
		end    
	end
end	  

-- Smart KillSteal--

function SmartKS()

for i,enemy in pairs(GoS:GetEnemyHeroes()) do

	local predWW = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1400,250,rangeW,50,false,true)
	local predRR = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1400,250,1000,50,false,true)
	local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5
	
-- Ludens Echo Bonus DMG --

	local Ludens = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
		end	
		
-- KS Spells--

local QDamage = 45 + 35*GetCastLevel(myHero,_Q) + 0.8*GetBonusAP(myHero) 
local WDamage = 35 + 45*GetCastLevel(myHero,_W) + 0.85*GetBonusAP(myHero)
local RDamage = 50 + 125*GetCastLevel(myHero,_R) + 0.80*GetBonusAP(myHero)   

		if IsObjectAlive(enemy) and IsTargetable(enemy) and not IsImmune(enemy, myHero) then
		    
			if CanUseSpell(myHero,_Q) == READY and AnnieMenu.SmartKS.SmartKSQ:Value() and GoS:ValidTarget(enemy, GetCastRange(myHero,_Q)) and GoS:CalcDamage(myHero, enemy, 0, QDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastTargetSpell(enemy,_Q)	
			elseif CanUseSpell(myHero,_W) == READY and predWW.HitChance == 1 and AnnieMenu.SmartKS.SmartKSW:Value() and GoS:ValidTarget(enemy, 700) and GoS:CalcDamage(myHero, enemy, 0, 35 + 45*GetCastLevel(myHero,_W) + 0.85*GetBonusAP(myHero) + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_W,predWW.PredPos.x,predWW.PredPos.y,predWW.PredPos.z)
			elseif CanUseSpell(myHero,_R) == READY and predRR.HitChance == 1 and AnnieMenu.SmartKS.SmartKSR:Value() and GoS:ValidTarget(enemy, 1000) and GoS:CalcDamage(myHero, enemy, 0, 50 + 125*GetCastLevel(myHero,_R) + 0.80*GetBonusAP(myHero) + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_R,predRR.PredPos.x,predRR.PredPos.y,predRR.PredPos.z)
			end	

			if CanUseSpell(myHero,_W) == READY and CanUseSpell(myHero,_Q) == READY and predWW.HitChance == 1 and AnnieMenu.SmartKS.SmartKSQW:Value() and GoS:ValidTarget(enemy, 700) and GoS:CalcDamage(myHero, enemy, 0, 35 + 45*GetCastLevel(myHero,_W) + 0.85*GetBonusAP(myHero) + Ludens + QDamage + Ludens) > GetCurrentHP(enemy) + GetHPRegen(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) then
				CastSkillShot(_W,predWW.PredPos.x,predWW.PredPos.y,predWW.PredPos.z) GoS:DelayAction(function()
				CastTargetSpell(enemy,_Q) end, 250)
			end
		end	
		-- R on multiple targets -- 

		if IOW:Mode() == "Combo" and GoS:ValidTarget(enemy, 850) then
			if CanUseSpell(myHero, _R) == READY and (CountEnemyHeroInRange(enemy,rangeR - 50))>=2 and GoS:ValidTarget(enemy,850) and AnnieMenu.Combo.MultiR:Value() then
				CastSkillShot(_R,predRR.PredPos.x,predRR.PredPos.y,predRR.PredPos.z)
			end	
		end	

		if IOW:Mode() == "Combo" and GoS:ValidTarget(enemy, 850) then
			if CanUseSpell(myHero, _R) == READY and (CountEnemyHeroInRange(enemy,rangeR - 50))>=2 and GoS:ValidTarget(enemy,850) and AnnieMenu.RegularCombo.MultiR:Value() then
				CastSkillShot(_R,predRR.PredPos.x,predRR.PredPos.y,predRR.PredPos.z)
			end	
		end			

		if Ignite and AnnieMenu.AutoIgnite.UseIgnite:Value() and not IsImmune(enemy, myHero) then
            if CanUseSpell(myHero,Ignite) and Ignited and GoS:ValidTarget(enemy, GetCastRange(myHero,Ignite)) then
                CastTargetSpell(enemy, Ignite)
            end
        end 			
end
end		

-- Auto Last-Hit --

function LastHit()

    local dmg = 45 + 35*GetCastLevel(myHero,_Q) + 0.8*GetBonusAP(myHero)   
                
    -- Ludens Echo Bonus Damage --

    local Ludens = 0

        if GotBuff(myHero, "itemmagicshankcharge") > 99 then
            Ludens = Ludens + 0.1*GetBonusAP(myHero) + 100
        end 
        
	if not KeyIsDown(string.byte(" ")) and not KeyIsDown(string.byte("C")) then

		-- Minions --
	   
        for i,unit in pairs(GoS:GetAllMinions(MINION_ENEMY)) do    
        	if GoS:ValidTarget(unit, GetCastRange(myHero,_Q)) and not IsImmune(unit, myHero) then
            	if GoS:CalcDamage(myHero, unit, 0, dmg + Ludens) > GetCurrentHP(unit) then
                	if CanUseSpell(myHero, _Q) == READY and AnnieMenu.Lasthit.Q:Value() then
                    	CastTargetSpell(unit,_Q)
                	elseif CanUseSpell(myHero, _Q) == READY and not AnnieMenu.Lasthit.Q:Value() and AnnieMenu.Lasthit.NoStunQ:Value() then
                        if GotBuff(myHero,"pyromania_particle") < 1 then
                            CastTargetSpell(unit,_Q)
                        end
                    end            
            	end
        	end
    	end
	end
end

-- AutoLevel --

function AutoLevel()
	 
	if AnnieMenu.Autolevel.Autolvl:Value() then
    	local level = GetLevel(myHero) 

			if level == 1 then
				LevelSpell(_Q)
			elseif level == 2 then
				LevelSpell(_W)
			elseif level == 3 then
				LevelSpell(_E)
			elseif level == 4 then
				LevelSpell(_Q)
			elseif level == 5 then
				LevelSpell(_Q)
			elseif level == 6 then
				LevelSpell(_R)
			elseif level == 7 then
				LevelSpell(_Q)
			elseif level == 8 then
				LevelSpell(_W)
			elseif level == 9 then
				LevelSpell(_Q)
			elseif level == 10 then
				LevelSpell(_W)
			elseif level == 11 then
				LevelSpell(_R)
			elseif level == 12 then
				LevelSpell(_W)
			elseif level == 13 then
				LevelSpell(_W)
   			elseif level == 14 then
				LevelSpell(_E)
			elseif level == 15 then
				LevelSpell(_E)
			elseif level == 16 then
				LevelSpell(_R)
			elseif level == 17 then
				LevelSpell(_E)
			elseif level == 18 then
				LevelSpell(_E)
			end
	end
end

-- Drawings --

function Drawings()

	if AnnieMenu.Drawings.Q:Value() then
                       
    	DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xff00ff00)                    
	end
end

-- Count Enemy Minions Around me --

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

-- Lane Clear --

function LaneClearing()

    for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do

        if IOW:Mode() == "LaneClear" and not IsDead(minion) and IsObjectAlive(minion) then

            local MinionPos = GetOrigin(minion) 

            if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and AnnieMenu.LaneClears.Q:Value() then
                CastTargetSpell(minion,_Q)
            end

            if GoS:ValidTarget(minion, rangeW) and GoS:IsInDistance(minion,rangeW) and CanUseSpell(myHero, _W) == READY and AnnieMenu.LaneClears.W:Value() and CountEnemyMinionsAround(GetOrigin(myHero),rangeW-100) >= AnnieMenu.LaneClears.minioncount:Value() then
                CastSkillShot(_W,MinionPos.x,MinionPos.y,MinionPos.z)
            end 

            if AnnieMenu.LaneClears.E:Value() and GoS:ValidTarget (minion, rangeW) then
                if CanUseSpell(myHero,_E) == READY then
                    CastSpell(_E)
                end
            end         
        end
    end
end

-- Jungle Clear --

function JungleClearing()

    for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

        if AnnieMenu.JungleClears.keyv:Value() and not IsDead(minion) and IsObjectAlive(minion) then

            local MinionPos = GetOrigin(minion)

            if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget (minion, rangeQ) and AnnieMenu.JungleClears.Q:Value() then
                CastTargetSpell(minion,_Q)
            end

            if GoS:ValidTarget(minion, rangeW) and GoS:IsInDistance(minion,rangeW) and CanUseSpell(myHero, _W) == READY and AnnieMenu.JungleClears.W:Value() then
                CastSkillShot(_W,MinionPos.x,MinionPos.y,MinionPos.z)
            end 

            if AnnieMenu.JungleClears.E:Value() and GoS:ValidTarget (minion, rangeW) then
                if CanUseSpell(myHero,_E) == READY then
                    CastSpell(_E)
                end
            end 
        end
    end 
end		
