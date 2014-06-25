local yayo = require 'yayo'
local VayneQRange = 300
local VayneERange = 550

function Init()
	yayo.RegisterBeforeAttackCallback(BeforeAttack)
	yayo.RegisterOnAttackCallback(OnAttack)
	yayo.RegisterAfterAttackCallback(AfterAttack)
end

function Gapclose(target)
	local targetdist = GetDistance(myHero, target)
	if CanCastSpell('Q') and not yayo.InRange(target) and targetdist <= (yayo.MyRange(target) + VayneQRange) then
		CastSpellXYZ('Q', target.x, 0, target.z)
	end
end

function Condemn(target)
	local targetdist = GetDistance(myHero, target)
	if CanCastSpell('E') and WillHitWall(target, 470) == 1 and targetdist <= 550 then
		CastSpellTarget('E', target)
	end
end

function Killsteal(target)
	if CanCastSpell('E') then
		local edmg = (myHero.addDamage/2) + 45 + (myHero.SpellLevelE - 1) * 35
		if target.health <= edmg then
			CastSpellTarget('E', target)
		end
	end
end

function AfterAttack()
	if ValidTarget(target) and yayo.InRange(target) and yayo.Config.AutoCarry then
		CastSpellXYZ('Q', mousePos.x, 0, mousePos.z)
	end
end

function OnTick()
	target = yayo.GetTarget()
	DrawCircleObject(myHero, yayo.MyRange(target), Color.Yellow)
	if ValidTarget(target) then
		Killsteal(target)
		Condemn(target)
		if yayo.Config.AutoCarry then
			Gapclose(target)
		end
	end
end
SetTimerCallback('OnTick')