--[[Activator by Akira--]]

require 'Utils'

local send = require 'SendInputScheduled'
local uiconfig = require 'uiconfig'

local version = '1.0'
local target

ADItems, ad = uiconfig.add_menu('AD Aggressive Items')
ad.keytoggle('botRK', 'Blade of the Ruined King', true)
ad.keytoggle('Hydra', 'Hydra', true)
ad.keytoggle('Tiamat', 'Tiamat', true)

APItems, ap = uiconfig.add_menu('AP Aggressive Items')
ap.keytoggle('DFG', 'Deathfire Grasp', true)

Spells, pot = uiconfig.add_menu('Pots')
pot.keytoggle('HP', 'Health Pot', true)
pot.slider('MinHP%', 'MaxHP%', 20, 30) 
pot.keytoggle('MANA', 'Mana Pot', true)

Pots, pot = uiconfig.add_menu('Pots')
pot.keytoggle('HP', 'Health Pot', true)
pot.slider('HPeh', 'HP%', 20, 30, 40) 
pot.keytoggle('MANA', 'Mana Pot', true)
pot.slider('MPeh', 'MP%', 20, 30, 40) 

local Summoners =
        {
                Ignite = {Key = nil, Name = "SummonerDot"},
                Exhaust = {Key = nil, Name = "SummonerExhaust"},
                Heal = {Key = nil, Name = "SummonerHeal"},
                Clarity = {Key = nil, Name = "SummonerMana"},
                Barrier = {Key = nil, Name = "SummonerBarrier"},
                Clairvoyance = {Key = nil, Name = "SummonerClairvoyance"},
                Cleanse = {Key = nil, Name = "SummonerBoost"}
        }


function main()
if Pots.HP then HPPot() end
if Pots.MANA then MPPot() end
end

function botRK()
if myHero.dead == 0 then
 brk = getInventorySlot(3153)
 if brk ~= nil and myHero["SpellTime"..brk] >= 1 then
 brkenemy = GetWeakEnemy('PHYS', 450)
 if ad.botRK and brkenemy ~= nil and (myHero.maxHealth-myHero.health) <= (brkenemy.maxHealth*15/100) then CastSpellTarget(tostring(brk),brkenemy) end
 end
end

function Tiamat()
if myHero.dead == 0 then
 tia = GetInventorySlot(3077)
 if tia ~= nil and myHero["SpellTime"..tia] >= 1 then
 if ad.Tiamat and GetWeakEnemy('PHYS', 400) ~= nil then CastSpellTarget(tostring(tia),myHero) end
   end
end
end

function Hydra()
if myHero.dead == 0 then
 hyd = GetInventorySlot(3074)
 if hyd ~= nil and myHero["SpellTime"..tia] >= 1 then
 if ad.Hydra and GetWeakEnemy('PHYS', 400) ~= nil then CastSpellTarget(tostring(hyd),myHero) end
   end
end
end

function DFG()
if myHero.dead == 0 then
 dfg = GetInventorySlot(3074)
 if dfg ~= nil and myHero["SpellTime"..dfg] >= 1 then
 dfgenemy = GetWeakEnemy('PHYS', 750)
 if ap.DFG and dfgenemy ~= nil then CastSpellTarget(tostring(dfg),dfgenemy) end
   end
end
end

function HPPot()
		if myHero.health < ((myHero.maxHealth*pot.HPeh)/100) then
			GetInventorySlot(2003)
			UseItemOnTarget(2003, myHero)
		end
end

function MPPot()
		if myHero.mana < ((myHero.maxMana*pot.MPeh)/100) then
			GetInventorySlot(2004)
			UseItemOnTarget(2004, myHero)
		end
end

function QSS()

if (IsBuffed(myHero,'LOC_Stun') or 
				IsBuffed(myHero,'LOC_Suppress') or 
				IsBuffed(myHero,'LOC_Taunt') or 
				IsBuffed(myHero,'LuxLightBinding') or 
				IsBuffed(myHero,'DarkBinding_tar') or 
				IsBuffed(myHero,'RunePrison') or 
				IsBuffed(myHero,'Zyra_E_sequence_root') or 
				IsBuffed(myHero,'monkey_king_ult_unit_tar_02') or 
				IsBuffed(myHero,'xenZiou_ChainAttack_03') or 
				IsBuffed(myHero,'tempkarma_spiritbindroot_tar')) then
                                GetInventorySlot(3140)
			                    UseItemOnTarget(3140, myHero)
                         end

end

function Cleanse()

if (IsBuffed(myHero,'LOC_Stun') or 
				IsBuffed(myHero,'LOC_Suppress') or 
				IsBuffed(myHero,'LOC_Taunt') or 
				IsBuffed(myHero,'LuxLightBinding') or 
				IsBuffed(myHero,'DarkBinding_tar') or 
				IsBuffed(myHero,'RunePrison') or 
				IsBuffed(myHero,'Zyra_E_sequence_root') or 
				IsBuffed(myHero,'monkey_king_ult_unit_tar_02') or 
				IsBuffed(myHero,'xenZiou_ChainAttack_03') or 
				IsBuffed(myHero,'tempkarma_spiritbindroot_tar')) then

               CastSummonerCleanse(targetCleanse) 
                         end

end

SetTimerCallback("main")