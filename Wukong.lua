if GetObjectName(myHero) ~= "Wukong" then return end

WukongMenu = Menu("DatMonkey", "DatMonkey")
WukongMenu:SubMenu("Combo", "Combo")
WukongMenu.Combo:Boolean("Q", "Use Q", true)
WukongMenu.Combo:Boolean("W", "Use W", true)
WukongMenu.Combo:Boolean("E", "Use E", true)
WukongMenu.Combo:Boolean("tiamat", "Use Tiamat", true)
WukongMenu.Combo:Boolean("hydra", "Use Hydra", true)

WukongMenu:SubMenu("Ropts", "Use ult if hits")
WukongMenu.Ropts:Boolean("rOne", "1 Target+", true)
WukongMenu.Ropts:Boolean("rTwo", "2 Targets+", false)
WukongMenu.Ropts:Boolean("rThree", "3 Targets+", false)
WukongMenu.Ropts:Boolean("rFour", "4 Targets+", false)
WukongMenu.Ropts:Boolean("rFive", "5 Targets+", false)

WukongMenu:SubMenu("Harass", "Harass")
WukongMenu.Harass:Boolean("Q", "Use Q", true)
WukongMenu.Harass:Boolean("W", "Use W", true)
WukongMenu.Harass:Boolean("E", "Use E", true)

WukongMenu:SubMenu("AutoIgnite", "Auto Ignite")
WukongMenu.AutoIgnite:Boolean("UseIgnite", "Use Ignite", true)

WukongMenu:SubMenu("Killsteal", "Killsteal")
WukongMenu.Killsteal:Boolean("QE", "Killsteal with Q+E", true)
WukongMenu.Killsteal:Boolean("KsE", "Killsteal with E", true)

WukongMenu:SubMenu("Drawings", "Drawings")
WukongMenu.Drawings:Boolean("R", "Draw R Range", true)
WukongMenu.Drawings:Boolean("E", "Draw E Range", false)

PrintChat("DatMonkey v1.0 Loaded")
PrintChat("By Rakli")

OnLoop(function(myHero)
	local myHero = GetMyHero()

Checks()
Range()
Combo()
UltOpts()
Drawings()
KS()
Ignites()
Harass()

end)
	
function Checks()
	qup = CanUseSpell(myHero, _Q) == READY
	wup = CanUseSpell(myHero, _W) == READY
	eup = CanUseSpell(myHero, _E) == READY
	rup = CanUseSpell(myHero, _R) == READY and GetCastName(myHero, _R) == "MonkeyKingSpinToWin"
	qdown = CanUseSpell(myHero,_Q) ~= READY
end

function Range()
	qRange = 290
	eRange = GetCastRange(myHero, _E) - 5
	rRange = 315
end	

function CountEnemyHeroInRange(unit,range)
	unit = unit or myHero
    local enemyInRange = 0
    for i,enemy in pairs(GoS:GetEnemyHeroes()) do
        if GoS:GetDistance(unit, enemy) <= rRange then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end 

function Ignites()
	for i,ignemey in pairs(GoS:GetEnemyHeroes()) do
	local Ignited = 20*GetLevel(myHero)+50 > GetCurrentHP(ignemey)+GetDmgShield(ignemey)+GetHPRegen(ignemey)*2.5		
		if Ignite and WukongMenu.AutoIgnite.UseIgnite:Value() then
            if CanUseSpell(myHero, Ignite) and Ignited and GoS:ValidTarget(ignemey, GetCastRange(myHero,Ignite)) then
                CastTargetSpell(ignemey, Ignite)
            end
        end  
    end
end

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "MonkeyKing_Base_R_Cas_Glow.troy" then
		usingult2 = true
	end	

	if GetObjectBaseName(Object) == "MonkeyKing_Base_R_Cas.troy" then
		usingult3 = true	
	end
end)	

OnDeleteObj(function(Object)
	if GetObjectBaseName(Object) == "MonkeyKing_Base_R_Cas_Glow.troy" then
		usingult2 = false
	end	

	if GetObjectBaseName(Object) == "MonkeyKing_Base_R_Cas.troy" then
		usingult3 = false	
	end
end)

function Combo()

local target = GoS:GetTarget(800, DAMAGE_PHYSICAL)

	if IOW:Mode() == "Combo" and IsTargetable(target) and GotBuff(myHero, "MonkeyKingSpinToWin") < 1 or usingult2 or usingult3 then
		if WukongMenu.Combo.Q:Value() and GoS:ValidTarget(target, qRange + 200) and GoS:GetDistance(target) <= qRange and qup then
			CastSpell(_Q)
		end

		if WukongMenu.Combo.W:Value() and GoS:ValidTarget(target, eRange + 150) and GoS:GetDistance(target) < 700 and GetCurrentHP(myHero) / GetMaxHP(myHero) < 0.5 then
			if wup then
				CastSpell(_W)
			end
		end

		if WukongMenu.Combo.E:Value() and eup and GoS:ValidTarget(target, eRange + 150) and GoS:GetDistance(target) < eRange + 50 then
			CastTargetSpell(target, _E)
		end

		if WukongMenu.Combo.tiamat:Value() and GetItemSlot(myHero, 3077) > 0 then
			if GoS:ValidTarget (target, 550) and GoS:GetDistance(target) < 400 and qdown and GotBuff(myHero, "MonkeyKingDoubleAttack") < 1 then
				CastTargetSpell(myHero, GetItemSlot(myHero, 3077))
			end
		end	

		if WukongMenu.Combo.hydra:Value() and GetItemSlot(myHero, 3074) > 0 then
			if GoS:ValidTarget (target, 550) and GoS:GetDistance(target) < 385 and qdown and GotBuff(myHero, "MonkeyKingDoubleAttack") < 1 then
				CastTargetSpell(myHero, GetItemSlot(myHero, 3074))
			end
		end
	end
end

function UltOpts()
	for i, ultenemies in pairs(GoS:GetEnemyHeroes()) do
		if IOW:Mode() == "Combo" and IsTargetable(ultenemies) and GotBuff(myHero, "MonkeyKingSpinToWin") < 1 or usingult2 or usingult3 then

			if WukongMenu.Ropts.rOne:Value() then
				if (CountEnemyHeroInRange(ultenemies,rRange)) >= 1 and GoS:ValidTarget(ultenemies, rRange) and rup and qdown and GotBuff(myHero, "MonkeyKingDoubleAttack") < 1 then
					CastSpell(_R)
				end
			end							

			if WukongMenu.Ropts.rTwo:Value() then
				if (CountEnemyHeroInRange(ultenemies,rRange)) >= 2 and GoS:ValidTarget(ultenemies, rRange) and rup then
					CastSpell(_R)
				end
			end	

			if WukongMenu.Ropts.rThree:Value() then
				if (CountEnemyHeroInRange(ultenemies,rRange)) >= 3 and GoS:ValidTarget(ultenemies, rRange) and rup then
					CastSpell(_R)
				end
			end		

			if WukongMenu.Ropts.rFour:Value() then	
				if (CountEnemyHeroInRange(ultenemies,rRange)) >= 4 and GoS:ValidTarget(ultenemies, rRange) and rup then
					CastSpell(_R)
				end
			end	

			if WukongMenu.Ropts.rFive:Value() then
				if (CountEnemyHeroInRange(ultenemies,rRange)) >= 5 and GoS:ValidTarget(ultenemies, rRange) and rup then
					CastSpell(_R)
				end 
			end
		end
	end
end	

function KS()
	for i, ksenemies in pairs(GoS:GetEnemyHeroes()) do

	local BonusDamage = 0
	if GotBuff(myHero, "sheen")	== 1 and GetItemSlot(myHero,3078) > 0 then
		BonusDamage = BonusDamage + GetBonusDmg(myHero)*2 + (GetBaseDamage(myHero))
	end	

	local BonusDamage2 = 0
	if GotBuff(myHero, "sheen") == 1 and GetItemSlot(myHero, 3057) > 0 then
		BonusDamage2 = BonusDamage2 + GetBonusDmg(myHero)*1 + (GetBaseDamage(myHero))
	end	

	local myDamageQ = GetCastLevel(myHero,_Q)*30+30+GetBonusDmg(myHero)*0.10+GetBaseDamage(myHero) + BonusDamage + BonusDamage2 + GetArmorPenFlat(myHero) + GetArmorPenPercent(myHero)
	local myDamageE = GetCastLevel(myHero,_E)*45+15+GetBonusDmg(myHero)*0.80+GetBaseDamage(myHero) + GetArmorPenFlat(myHero) + GetArmorPenPercent(myHero)

		if IsTargetable(ksenemies) and GotBuff(myHero, "MonkeyKingSpinToWin") < 1 or usingult2 or usingult3 then

			if WukongMenu.Killsteal.QE:Value() and qup and eup and GoS:ValidTarget(ksenemies, eRange + 200) and GoS:CalcDamage(myHero, ksenemies, 0, myDamageQ + myDamageE) > GetCurrentHP(ksenemies) + GetHPRegen(ksenemies) + GetArmor(ksenemies) + GetDmgShield(ksenemies) then
				CastTargetSpell(ksenemies, _E) GoS:DelayAction(function()
				CastSpell(_Q) end, 200)
			elseif WukongMenu.Killsteal.KsE:Value() and eup and GoS:ValidTarget(ksenemies, eRange + 200) and GoS:CalcDamage(myHero, ksenemies, 0, myDamageE) > GetCurrentHP(ksenemies) + GetHPRegen(ksenemies) + GetArmor(ksenemies) + GetDmgShield(ksenemies) then
				CastTargetSpell(ksenemies, _E)				
			end	
		end
	end
end

function Harass()

local target = GetCurrentTarget()

	if IOW:Mode() == "Harass" and IsTargetable(target) and GotBuff(myHero, "MonkeyKingSpinToWin") < 1 or usingult2 or usingult3 then
		if WukongMenu.Harass.Q:Value() and GoS:ValidTarget(target, qRange + 100) and GoS:GetDistance(target) <= qRange and qup then
			CastSpell(_Q)
		end

		if WukongMenu.Harass.W:Value() and GoS:ValidTarget(target, eRange + 50) and GoS:GetDistance(target) < 700 and GetCurrentHP(myHero) / GetMaxHP(myHero) < 0.65 then
			if wup then
				CastSpell(_W)
			end
		end

		if WukongMenu.Harass.E:Value() and eup and GoS:ValidTarget(target, eRange + 100) and GoS:GetDistance(target) < eRange + 100 then
			CastTargetSpell(target, _E)
		end
	end
end

function Drawings()

	if WukongMenu.Drawings.R:Value() then
                       
    	DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,rRange,3,100,0xff00ff000)   
	end

	if WukongMenu.Drawings.E:Value() then

		DrawCircle(GoS:myHeroPos().x,GoS:myHeroPos().y,GoS:myHeroPos().z,eRange,3,100,0xff00ff00)
	end
end	
