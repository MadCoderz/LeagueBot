-- Mad's cassiOPeia preview 1 --
-- USED LIBS -- 
local uiconfig = require 'uiconfig'
require "hunter_libs"
require "coneCalc"
require "spell_damage"
local yayo = require "yayo"
-- YAYO STUFF --
yayo.RegisterBeforeAttackCallback(BeforeAttack)
yayo.RegisterOnAttackCallback(OnAttack)
yayo.RegisterAfterAttackCallback(AfterAttack)
-- CASSIOPEIA CONFIG --
CassiopeiaConfig, cfg = uiconfig.add_menu("Mad's Cassiopeia Config")
cfg.keydown('ForceUlt', 'Force Smart Ult', string.byte("A"))
cfg.slider('Ult2Win','Enemies to Smart Ult',0,5,3)
local AARange = getAARange()
local Cassiopeia = {Skills = {Q = {range = 850, delay = 6, radius = 75, speed = 20}, W = {range = 850, radius = 125, speed = 20}, E = {range = 700}, R = {radius = 825, theta = 80}}}
TargetSelector(DAMAGE_MAGIC, LESS_CAST, true)

function CastSpellVector(spell, vector)
	CastSpellXYZ(spell, vector.x, vector.y, vector.z)
end

function IsPoisoned(target)
    for i = 1, objManager:GetMaxObjects(), 1 do
        obj = objManager:GetObject(i)
        if obj~=nil and string.find(obj.charName,"oison") and GetDistance(obj, target) < 100 then
			return true
        end
    end
end

function Q(target)
	if VTarget(target, Cassiopeia.Skills.Q.range, true) then
		local pos = getAOE(target, Cassiopeia.Skills.Q.radius, Cassiopeia.Skills.Q.delay, Cassiopeia.Skills.Q.speed)
		CastSpellVector("Q", pos)
	end
end

function W(target)
	if VTarget(target, Cassiopeia.Skills.W.range, true) then
		local pos = getAOE(target, Cassiopeia.Skills.W.radius, 0, Cassiopeia.Skills.W.speed)
		CastSpellVector("W", pos)
	end
end

function E(target)
	if VTarget(target, Cassiopeia.Skills.E.range, true) and IsPoisoned(target) or VTarget(target, Cassiopeia.Skills.E.range, true) and getDmg("E",target,myHero) >= target.health then
		CastSpellTarget("E", target)
	end
end

function AutoR()
	conePred = GetCone(Cassiopeia.Skills.R.radius, Cassiopeia.Skills.R.theta)
	if conePred ~= nil then
		CastSpellVector("R", conePred)
	end
end

function Combo(target)
	if target ~= nil then
		if yayo.Config.AutoCarry then
			E(target)
			if not IsPoisoned(target) and getDmg("E",target,myHero) < target.health then
				W(target)
			end
			if not IsPoisoned(target) and getDmg("E",target,myHero) < target.health then
				Q(target)
			end
		end
	end
end

function OnTick()
	local target = getTSTarget(Cassiopeia.Skills.E.range)
	local target2 = getTSTarget(Cassiopeia.Skills.Q.range)
	if target == nil and target2 ~= nil then
		target = target2
	end
	Combo(target)
	if CassiopeiaConfig.Ult2Win ~= 0 and CountEnemyHeroInRange(Cassiopeia.Skills.R.radius) >= CassiopeiaConfig.Ult2Win then
		AutoR()
	end
	if CassiopeiaConfig.ForceUlt then AutoR() end
end

SetTimerCallback('OnTick')