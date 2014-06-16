--[[Mad's Activator]]--
-- Credits:
-- lopht for Leaguebot
-- Sida for utils.lua
-- Akira for Activator idea and base (mostly rewritten)
-- Lua for IgniteTarget.lua
-- unknown developer for RedElixir.lua (Potions)

require 'utils'
require 'winapi'
require 'SKeys'
local send = require 'SendInputScheduled'
local uiconfig = require 'uiconfig'

local version = '1.0'
local target
local brktarget
local dfgtarget
local igntarget

local wUsedAt = 0
local vUsedAt = 0
local mUsedAt = 0
local timer = os.clock()
local bluePill = nil

ADItems, ad = uiconfig.add_menu('AD Aggressive Items')
ad.keytoggle('botRK', 'Blade of the Ruined King', true)
ad.keytoggle('Hydra', 'Ravenous Hydra', true)
ad.keytoggle('Tiamat', 'Tiamat', true)

APItems, ap = uiconfig.add_menu('AP Aggressive Items')
ap.keytoggle('DFG', 'Deathfire Grasp', true)

Spells, sspells = uiconfig.add_menu('Summoner Spells')
if (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Ignite.Name then
	sspells.keytoggle('ign', 'Auto Ignite', true)
	IgniteOptions, ignopt = uiconfig.add_menu('Ignite Options')
	ignopt.checkbutton('BurnGA', 'Ignite Guardian Angel', true)
	ignopt.checkbutton('BurnEgg', 'Ignite Anivia even Eggnivia passive', false)
	ignopt.checkbutton('BurnAatrox', 'Ignite Aatrox even Rebirth passive', false)
	ignopt.checkbutton('BurnZac', 'Ignite Zac even Rebirth passive', false)
	if myHero.SummonerD == SummonerSpells.Ignite.Name then ignKey = 'D'
	else ignKey = 'F'
	end
end
elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Exhaust.Name then
	sspells.keytoggle('exh', 'Auto Exhaust', true)
elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Heal.Name then
	sspells.keytoggle('heal', 'Auto Heal', true)
elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Clarity.Name then
	sspells.keytoggle('cla', 'Auto Clarity', true)
elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Barrier.Name then
	sspells.keytoggle('brr', 'Auto Barrier', true)
elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Clairvoyance.Name then
	sspells.keytoggle('clv', 'Auto Clairvoyance', true)
	elseif (myHero.SummonerD or myHero.SummonerF) == SummonerSpells.Cleanse.Name then
	sspells.keytoggle('cls', 'Auto Cleanse', true)
else
	print('Script is broken or outdated.')
end
Potions, pots = uiconfig.add_menu('Potions', 200)
pots.checkbutton('AutoPotions', 'Master Switch: Potions', true)
pots.checkbutton('Health_Potion_ONOFF', 'Health Potions', true)
pots.checkbutton('Mana_Potion_ONOFF', 'Mana Potions', true)
pots.checkbutton('Crystalline_Flask_ONOFF', 'Crystalline Flask', true)
pots.checkbutton('Elixir_of_Fortitude_ONOFF', 'Elixir of Fortitude', true)
pots.checkbutton('Biscuit_ONOFF', 'Biscuit', true)
pots.slider('Health_Potion_Value', 'Health Potion Value', 0, 100, 75, nil, true)
pots.slider('Mana_Potion_Value', 'Mana Potion Value', 0, 100, 75, nil, true)
pots.slider('Crystalline_Flask_Value', 'Crystalline Flask Value', 0, 100, 75, nil, true)
pots.slider('Elixir_of_Fortitude_Value', 'Elixir of Fortitude Value', 0, 100, 30, nil, true)
pots.slider('Biscuit_Value', 'Biscuit Value', 0, 100, 60, nil, true)
pots.permashow('AutoPotions')
local SummonerSpells =
	{
		Ignite = {Key = nil, Name = "SummonerDot"},
		Exhaust = {Key = nil, Name = "SummonerExhaust"},
		Heal = {Key = nil, Name = "SummonerHeal"},
		Clarity = {Key = nil, Name = "SummonerMana"},
		Barrier = {Key = nil, Name = "SummonerBarrier"},
		Clairvoyance = {Key = nil, Name = "SummonerClairvoyance"},
		Cleanse = {Key = nil, Name = "SummonerBoost"}
	}

function eventLoop()
	if myHero.dead == 0 then
		if ad.botRK then botRK() end
		if ad.Tiamat then Tiamat() end
		if ad.Hydra then Hydra() end
		if ap.DFG then DFG() end
		if Spells.ign then ign() end
		if Potions.AutoPotions then potions() end
	end
end

function botRK()
	brk = getInventorySlot(3153)
		if brk ~= nil and myHero["SpellTime"..brk] >= 1 then
			brktarget = GetWeakEnemy('PHYS', 450)
			if ad.botRK and brktarget ~= nil and (myHero.maxHealth-myHero.health) <= (brktarget.maxHealth*15/100) then CastSpellTarget(tostring(brk),brktarget) end
		end
end

function Tiamat()
	tia = GetInventorySlot(3077)
	if tia ~= nil and myHero["SpellTime"..tia] >= 1 then
		if ad.Tiamat and GetWeakEnemy('PHYS', 400) ~= nil then CastSpellTarget(tostring(tia),myHero) end
	end
end

function Hydra()
	hyd = GetInventorySlot(3074)
	if hyd ~= nil and myHero["SpellTime"..tia] >= 1 then
		if ad.Hydra and GetWeakEnemy('PHYS', 400) ~= nil then CastSpellTarget(tostring(hyd),myHero) end
	end
end

function DFG()
	dfg = GetInventorySlot(3074)
	if dfg ~= nil and myHero["SpellTime"..dfg] >= 1 then
		dfgtarget = GetWeakEnemy('PHYS', 750)
		if ap.DFG and dfgtarget ~= nil then CastSpellTarget(tostring(dfg),dfgtarget) end
	end
end

function ign()
	if myHero.dead == 0 then
		igntarget = GetWeakEnemy('TRUE',600)
		if igntarget ~= nil then
			IgniteTarget(igntarget, ignKey, , ignopt.BurnGA, ignopt.BurnEgg, ignopt.BurnAatrox, ignopt.BurnZac)
		end
	end
end

function potions()
	if bluePill == nil then
		if myHero.health < myHero.maxHealth * (CfgPotions.Health_Potion_Value / 100) and GetClock() > wUsedAt + 15000 then
			usePotion()
			useBiscuit()
			wUsedAt = GetTick()
		elseif myHero.health < myHero.maxHealth * (CfgPotions.Crystalline_Flask_Value / 100) and GetClock() > vUsedAt + 10000 then 
			useFlask()
			vUsedAt = GetTick()
		elseif myHero.health < myHero.maxHealth * (CfgPotions.Biscuit_Value / 100) then
			useBiscuit()
		elseif myHero.health < myHero.maxHealth * (CfgPotions.Elixir_of_Fortitude_Value / 100) then
			useElixir()
		end
		if myHero.mana < myHero.maxMana * (CfgPotions.Mana_Potion_Value / 100) and GetClock() > mUsedAt + 15000 then
			useManaPot()
			mUsedAt = GetTick()
		end
	end
	if (os.clock() < timer + 5000) then
		bluePill = nil 
	end
end
function OnCreateObj(object)
	if (GetDistance(myHero, object)) < 100 then
		if string.find(object.charName,"FountainHeal") then
			timer=os.clock()
			bluePill = object
		end
	end
end
function usePotion()
	GetInventorySlot(2003)
	UseItemOnTarget(2003,myHero)
end
function useBiscuit()
	GetInventorySlot(2009)
	UseItemOnTarget(2009,myHero)
end
function useFlask()
	GetInventorySlot(2041)
	UseItemOnTarget(2041,myHero)
end
function useBiscuit()
	GetInventorySlot(2009)
	UseItemOnTarget(2009,myHero)
end
function useElixir()
	GetInventorySlot(2037)
	UseItemOnTarget(2037,myHero)
end
function useManaPot()
	GetInventorySlot(2004)
	UseItemOnTarget(2004,myHero)
end
function GetTick()
	return GetClock()
end
SetTimerCallback("eventLoop")