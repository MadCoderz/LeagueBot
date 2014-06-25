local yayo = require 'yayo'
local VayneQRange = 300
local VayneERange = 550

function Init()
	yayo.RegisterBeforeAttackCallback(BeforeAttack)
	yayo.RegisterOnAttackCallback(OnAttack)
	yayo.RegisterAfterAttackCallback(AfterAttack)
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
		if target.health <= (edmg * 2) and targetdist <= 550 and WillHitWall(target, 470) == 1 then
			CastSpellTarget('E', target)
		elseif target.health <= edmg and targetdist <= 550 and WillHitWall(target, 470) == 0 then
			CastSpellTarget('E', target)
		end
	end
end

function OnTick()
	target = yayo.GetTarget()
	DrawCircleObject(myHero, yayo.MyRange(target), Color.Yellow)
	if ValidTarget(target) then
		Killsteal(target)
		Condemn(target)
	end
end
SetTimerCallback('OnTick')