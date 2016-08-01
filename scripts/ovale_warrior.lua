local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

-- THE REST OF THIS FILE IS AUTOMATICALLY GENERATED.
-- ANY CHANGES MADE BELOW THIS POINT WILL BE LOST.

do
	local name = "simulationcraft_warrior_arms_t18m"
	local desc = "[7.0] SimulationCraft: Warrior_Arms_T18M"
	local code = [[
# Based on SimulationCraft profile "Warrior_Arms_T18M".
#	class=warrior
#	spec=arms
#	talents=0011022

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=arms)
AddCheckBox(opt_potion_strength ItemName(draenic_strength_potion) default specialization=arms)

AddFunction ArmsUsePotionStrength
{
	if CheckBoxOn(opt_potion_strength) and target.Classification(worldboss) Item(draenic_strength_potion usable=1)
}

AddFunction ArmsGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range)
	{
		if target.InRange(charge) Spell(charge)
		if target.InRange(charge) Spell(heroic_leap)
		if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

### actions.default

AddFunction ArmsDefaultMainActions
{
	#rend,if=remains<gcd
	if target.DebuffRemaining(rend_debuff) < GCD() Spell(rend)
	#hamstring,if=talent.deadly_calm.enabled&buff.battle_cry.up
	if Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) Spell(hamstring)
	#colossus_smash,if=debuff.colossus_smash.down
	if target.DebuffExpires(colossus_smash_debuff) Spell(colossus_smash)
	#overpower
	Spell(overpower)
	#run_action_list,name=single,if=target.health.pct>=20
	if target.HealthPercent() >= 20 ArmsSingleMainActions()
	#run_action_list,name=execute,if=target.health.pct<20
	if target.HealthPercent() < 20 ArmsExecuteMainActions()
}

AddFunction ArmsDefaultShortCdActions
{
	#charge
	if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(charge)
	#auto_attack
	ArmsGetInMeleeRange()
	#avatar,sync=colossus_smash
	if target.DebuffExpires(colossus_smash_debuff) and Spell(colossus_smash) Spell(avatar)
	#avatar,if=debuff.colossus_smash.remains>=5|(debuff.colossus_smash.up&cooldown.colossus_smash.remains=0)
	if target.DebuffRemaining(colossus_smash_debuff) >= 5 or target.DebuffPresent(colossus_smash_debuff) and not SpellCooldown(colossus_smash) > 0 Spell(avatar)
	#heroic_leap,if=buff.shattered_defenses.down
	if BuffExpires(shattered_defenses_buff) and CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(heroic_leap)

	unless target.DebuffRemaining(rend_debuff) < GCD() and Spell(rend) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) and Spell(hamstring) or target.DebuffExpires(colossus_smash_debuff) and Spell(colossus_smash)
	{
		#warbreaker,if=debuff.colossus_smash.down
		if target.DebuffExpires(colossus_smash_debuff) Spell(warbreaker)
		#ravager
		Spell(ravager)

		unless Spell(overpower)
		{
			#run_action_list,name=single,if=target.health.pct>=20
			if target.HealthPercent() >= 20 ArmsSingleShortCdActions()

			unless target.HealthPercent() >= 20 and ArmsSingleShortCdPostConditions()
			{
				#run_action_list,name=execute,if=target.health.pct<20
				if target.HealthPercent() < 20 ArmsExecuteShortCdActions()
			}
		}
	}
}

AddFunction ArmsDefaultCdActions
{
	#potion,name=draenic_strength,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<25
	if target.HealthPercent() < 20 and BuffPresent(battle_cry_buff) or target.TimeToDie() < 25 ArmsUsePotionStrength()
	#battle_cry,sync=colossus_smash
	if target.DebuffExpires(colossus_smash_debuff) and Spell(colossus_smash) Spell(battle_cry)
	#battle_cry,if=debuff.colossus_smash.remains>=5|(debuff.colossus_smash.up&cooldown.colossus_smash.remains=0)
	if target.DebuffRemaining(colossus_smash_debuff) >= 5 or target.DebuffPresent(colossus_smash_debuff) and not SpellCooldown(colossus_smash) > 0 Spell(battle_cry)
	#blood_fury,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(blood_fury_ap)
	#berserking,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(berserking)
	#arcane_torrent,if=rage<rage.max-40
	if Rage() < MaxRage() - 40 Spell(arcane_torrent_rage)
}

### actions.execute

AddFunction ArmsExecuteMainActions
{
	#mortal_strike,if=buff.shattered_defenses.up&buff.focused_rage.stack=3
	if BuffPresent(shattered_defenses_buff) and BuffStacks(focused_rage_buff) == 3 Spell(mortal_strike)
	#execute,if=debuff.colossus_smash.up&(buff.shattered_defenses.up|rage>100|talent.deadly_calm.enabled&buff.battle_cry.up)
	if target.DebuffPresent(colossus_smash_debuff) and { BuffPresent(shattered_defenses_buff) or Rage() > 100 or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } Spell(execute_arms)
	#mortal_strike,if=talent.in_for_the_kill.enabled&buff.shattered_defenses.down
	if Talent(in_for_the_kill_talent) and BuffExpires(shattered_defenses_buff) Spell(mortal_strike)
	#colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
	if BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) Spell(colossus_smash)
	#mortal_strike
	Spell(mortal_strike)
	#execute,if=debuff.colossus_smash.up|rage>=100
	if target.DebuffPresent(colossus_smash_debuff) or Rage() >= 100 Spell(execute_arms)
	#focused_rage,if=talent.deadly_calm.enabled&buff.battle_cry.up
	if Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) Spell(focused_rage)
	#rend,if=remains<=duration*0.3
	if target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0.3 Spell(rend)
}

AddFunction ArmsExecuteShortCdActions
{
	unless BuffPresent(shattered_defenses_buff) and BuffStacks(focused_rage_buff) == 3 and Spell(mortal_strike) or target.DebuffPresent(colossus_smash_debuff) and { BuffPresent(shattered_defenses_buff) or Rage() > 100 or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } and Spell(execute_arms) or Talent(in_for_the_kill_talent) and BuffExpires(shattered_defenses_buff) and Spell(mortal_strike) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash)
	{
		#warbreaker,if=buff.shattered_defenses.down
		if BuffExpires(shattered_defenses_buff) Spell(warbreaker)

		unless Spell(mortal_strike) or { target.DebuffPresent(colossus_smash_debuff) or Rage() >= 100 } and Spell(execute_arms) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) and Spell(focused_rage) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0.3 and Spell(rend)
		{
			#heroic_charge
			#shockwave
			Spell(shockwave)
			#storm_bolt
			Spell(storm_bolt)
		}
	}
}

### actions.precombat

AddFunction ArmsPrecombatCdActions
{
	#flask,type=greater_draenic_strength_flask
	#food,type=sleeper_sushi
	#snapshot_stats
	#potion,name=draenic_strength
	ArmsUsePotionStrength()
}

### actions.single

AddFunction ArmsSingleMainActions
{
	#mortal_strike
	Spell(mortal_strike)
	#colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
	if BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) Spell(colossus_smash)
	#focused_rage,if=buff.focused_rage.stack<3|talent.deadly_calm.enabled&buff.battle_cry.up
	if BuffStacks(focused_rage_buff) < 3 or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) Spell(focused_rage)
	#whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&!talent.focused_rage.enabled|talent.deadly_calm.enabled&buff.battle_cry.up|buff.cleave.up
	if Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) or BuffPresent(cleave_buff) Spell(whirlwind)
	#slam,if=!talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<40)&!talent.focused_rage.enabled|talent.deadly_calm.enabled&buff.battle_cry.up
	if not Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 40 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) Spell(slam)
	#rend,if=remains<=duration*0.3
	if target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0.3 Spell(rend)
	#heroic_charge
	#whirlwind,if=talent.fervor_of_battle.enabled&(!talent.focused_rage.enabled|rage>100|buff.focused_rage.stack=3)
	if Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } Spell(whirlwind)
	#slam,if=!talent.fervor_of_battle.enabled&(!talent.focused_rage.enabled|rage>100|buff.focused_rage.stack=3)
	if not Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } Spell(slam)
	#execute
	Spell(execute_arms)
}

AddFunction ArmsSingleShortCdActions
{
	unless Spell(mortal_strike) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash)
	{
		#warbreaker,if=buff.shattered_defenses.down
		if BuffExpires(shattered_defenses_buff) Spell(warbreaker)

		unless { BuffStacks(focused_rage_buff) < 3 or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } and Spell(focused_rage) or { Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) or BuffPresent(cleave_buff) } and Spell(whirlwind) or { not Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 40 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } and Spell(slam) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0.3 and Spell(rend) or Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } and Spell(whirlwind) or not Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } and Spell(slam) or Spell(execute_arms)
		{
			#shockwave
			Spell(shockwave)
			#storm_bolt
			Spell(storm_bolt)
		}
	}
}

AddFunction ArmsSingleShortCdPostConditions
{
	Spell(mortal_strike) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash) or { BuffStacks(focused_rage_buff) < 3 or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } and Spell(focused_rage) or { Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) or BuffPresent(cleave_buff) } and Spell(whirlwind) or { not Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 40 } and not Talent(focused_rage_talent) or Talent(deadly_calm_talent) and BuffPresent(battle_cry_buff) } and Spell(slam) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0.3 and Spell(rend) or Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } and Spell(whirlwind) or not Talent(fervor_of_battle_talent) and { not Talent(focused_rage_talent) or Rage() > 100 or BuffStacks(focused_rage_buff) == 3 } and Spell(slam) or Spell(execute_arms)
}

### Arms icons.

AddCheckBox(opt_warrior_arms_aoe L(AOE) default specialization=arms)

AddIcon checkbox=!opt_warrior_arms_aoe enemies=1 help=shortcd specialization=arms
{
	ArmsDefaultShortCdActions()
}

AddIcon checkbox=opt_warrior_arms_aoe help=shortcd specialization=arms
{
	ArmsDefaultShortCdActions()
}

AddIcon enemies=1 help=main specialization=arms
{
	ArmsDefaultMainActions()
}

AddIcon checkbox=opt_warrior_arms_aoe help=aoe specialization=arms
{
	ArmsDefaultMainActions()
}

AddIcon checkbox=!opt_warrior_arms_aoe enemies=1 help=cd specialization=arms
{
	if not InCombat() ArmsPrecombatCdActions()
	ArmsDefaultCdActions()
}

AddIcon checkbox=opt_warrior_arms_aoe help=cd specialization=arms
{
	if not InCombat() ArmsPrecombatCdActions()
	ArmsDefaultCdActions()
}

### Required symbols
# arcane_torrent_rage
# avatar
# battle_cry
# battle_cry_buff
# berserking
# blood_fury_ap
# charge
# cleave_buff
# colossus_smash
# colossus_smash_debuff
# deadly_calm_talent
# draenic_strength_potion
# execute_arms
# fervor_of_battle_talent
# focused_rage
# focused_rage_buff
# focused_rage_talent
# hamstring
# heroic_leap
# in_for_the_kill_talent
# mortal_strike
# overpower
# precise_strikes_buff
# pummel
# ravager
# rend
# rend_debuff
# shattered_defenses_buff
# shockwave
# slam
# storm_bolt
# warbreaker
# whirlwind
]]
	OvaleScripts:RegisterScript("WARRIOR", "arms", name, desc, code, "script")
end

do
	local name = "simulationcraft_warrior_fury_1h_t18m"
	local desc = "[7.0] SimulationCraft: Warrior_Fury_1h_T18M"
	local code = [[
# Based on SimulationCraft profile "Warrior_Fury_1h_T18M".
#	class=warrior
#	spec=fury
#	talents=2313133

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=fury)
AddCheckBox(opt_potion_strength ItemName(draenic_strength_potion) default specialization=fury)
AddCheckBox(opt_legendary_ring_strength ItemName(legendary_ring_strength) default specialization=fury)

AddFunction FurySingleMindedFuryUsePotionStrength
{
	if CheckBoxOn(opt_potion_strength) and target.Classification(worldboss) Item(draenic_strength_potion usable=1)
}

AddFunction FurySingleMindedFuryGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range)
	{
		if target.InRange(charge) Spell(charge)
		if target.InRange(charge) Spell(heroic_leap)
		if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

### actions.default

AddFunction FurySingleMindedFuryDefaultMainActions
{
	#call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
	if Enemies() == 2 or Enemies() == 3 FurySingleMindedFuryTwoTargetsMainActions()
	#call_action_list,name=aoe,if=spell_targets.whirlwind>3
	if Enemies() > 3 FurySingleMindedFuryAoeMainActions()
	#call_action_list,name=single_target
	FurySingleMindedFurySingleTargetMainActions()
}

AddFunction FurySingleMindedFuryDefaultShortCdActions
{
	#auto_attack
	FurySingleMindedFuryGetInMeleeRange()
	#charge
	if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(charge)
	#run_action_list,name=movement,if=movement.distance>5
	if 0 > 5 FurySingleMindedFuryMovementShortCdActions()
	#heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
	if { 0 > 25 and 600 > 45 or not False(raid_event_movement_exists) } and CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(heroic_leap)
	#avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remains+10))
	if BuffPresent(battle_cry_buff) or target.TimeToDie() < SpellCooldown(battle_cry) + 10 Spell(avatar)
	#call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
	if Enemies() == 2 or Enemies() == 3 FurySingleMindedFuryTwoTargetsShortCdActions()

	unless { Enemies() == 2 or Enemies() == 3 } and FurySingleMindedFuryTwoTargetsShortCdPostConditions()
	{
		#call_action_list,name=aoe,if=spell_targets.whirlwind>3
		if Enemies() > 3 FurySingleMindedFuryAoeShortCdActions()

		unless Enemies() > 3 and FurySingleMindedFuryAoeShortCdPostConditions()
		{
			#call_action_list,name=single_target
			FurySingleMindedFurySingleTargetShortCdActions()
		}
	}
}

AddFunction FurySingleMindedFuryDefaultCdActions
{
	#use_item,name=thorasus_the_stone_heart_of_draenor,if=(spell_targets.whirlwind>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.battle_cry.up|target.time_to_die<25)
	if { Enemies() > 1 or not False(raid_event_adds_exists) } and { Talent(bladestorm_talent) and not SpellCooldown(bladestorm) > 0 or BuffPresent(battle_cry_buff) or target.TimeToDie() < 25 } and CheckBoxOn(opt_legendary_ring_strength) Item(legendary_ring_strength usable=1)
	#potion,name=draenic_strength,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<=30
	if target.HealthPercent() < 20 and BuffPresent(battle_cry_buff) or target.TimeToDie() <= 30 FurySingleMindedFuryUsePotionStrength()
	#battle_cry,if=(artifact.odyns_fury.enabled&cooldown.odyns_fury.remains=0&(cooldown.bloodthirst.remains=0|(buff.enrage.remains>cooldown.bloodthirst.remains)))|!artifact.odyns_fury.enabled
	if BuffPresent(odyns_fury_buff) and not SpellCooldown(odyns_fury) > 0 and { not SpellCooldown(bloodthirst) > 0 or EnrageRemaining() > SpellCooldown(bloodthirst) } or not BuffPresent(odyns_fury_buff) Spell(battle_cry)
	#bloodbath,if=buff.dragon_roar.up|(!talent.dragon_roar.enabled&(buff.battle_cry.up|cooldown.battle_cry.remains>10))
	if BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and { BuffPresent(battle_cry_buff) or SpellCooldown(battle_cry) > 10 } Spell(bloodbath)
	#blood_fury,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(blood_fury_ap)
	#berserking,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(berserking)
	#arcane_torrent,if=rage<rage.max-40
	if Rage() < MaxRage() - 40 Spell(arcane_torrent_rage)
}

### actions.aoe

AddFunction FurySingleMindedFuryAoeMainActions
{
	#bloodthirst,if=buff.enrage.down|rage<50
	if not IsEnraged() or Rage() < 50 Spell(bloodthirst)
	#whirlwind,if=buff.enrage.up
	if IsEnraged() Spell(whirlwind)
	#rampage,if=buff.meat_cleaver.up
	if BuffPresent(meat_cleaver_buff) Spell(rampage)
	#bloodthirst
	Spell(bloodthirst)
	#whirlwind
	Spell(whirlwind)
}

AddFunction FurySingleMindedFuryAoeShortCdActions
{
	unless { not IsEnraged() or Rage() < 50 } and Spell(bloodthirst)
	{
		#call_action_list,name=bladestorm
		FurySingleMindedFuryBladestormShortCdActions()

		unless IsEnraged() and Spell(whirlwind)
		{
			#dragon_roar
			Spell(dragon_roar)
		}
	}
}

AddFunction FurySingleMindedFuryAoeShortCdPostConditions
{
	{ not IsEnraged() or Rage() < 50 } and Spell(bloodthirst) or IsEnraged() and Spell(whirlwind) or BuffPresent(meat_cleaver_buff) and Spell(rampage) or Spell(bloodthirst) or Spell(whirlwind)
}

### actions.bladestorm

AddFunction FurySingleMindedFuryBladestormShortCdActions
{
	#bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
	if EnrageRemaining() > 2 and { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } Spell(bladestorm)
}

### actions.movement

AddFunction FurySingleMindedFuryMovementShortCdActions
{
	#heroic_leap
	if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(heroic_leap)
}

### actions.precombat

AddFunction FurySingleMindedFuryPrecombatCdActions
{
	#flask,type=greater_draenic_strength_flask
	#food,type=pickled_eel
	#snapshot_stats
	#potion,name=draenic_strength
	FurySingleMindedFuryUsePotionStrength()
}

### actions.single_target

AddFunction FurySingleMindedFurySingleTargetMainActions
{
	#rampage,if=rage>95|buff.massacre.react
	if Rage() > 95 or BuffPresent(massacre_buff) Spell(rampage)
	#whirlwind,if=!talent.inner_rage.enabled&buff.wrecking_ball.react
	if not Talent(inner_rage_talent) and BuffPresent(wrecking_ball_buff) Spell(whirlwind)
	#raging_blow,if=buff.enrage.up
	if IsEnraged() Spell(raging_blow)
	#whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
	if BuffPresent(wrecking_ball_buff) and IsEnraged() Spell(whirlwind)
	#execute,if=buff.enrage.up|buff.battle_cry.up|buff.stone_heart.react
	if IsEnraged() or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) Spell(execute)
	#bloodthirst
	Spell(bloodthirst)
	#raging_blow
	Spell(raging_blow)
	#rampage,if=(target.health.pct>20&(cooldown.battle_cry.remains>3|buff.battle_cry.up|rage>90))
	if target.HealthPercent() > 20 and { SpellCooldown(battle_cry) > 3 or BuffPresent(battle_cry_buff) or Rage() > 90 } Spell(rampage)
	#execute,if=rage>50|buff.battle_cry.up|buff.stone_heart.react|target.time_to_die<20
	if Rage() > 50 or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) or target.TimeToDie() < 20 Spell(execute)
	#furious_slash
	Spell(furious_slash)
}

AddFunction FurySingleMindedFurySingleTargetShortCdActions
{
	#odyns_fury,if=buff.battle_cry.up|target.time_to_die<cooldown.battle_cry.remains
	if BuffPresent(battle_cry_buff) or target.TimeToDie() < SpellCooldown(battle_cry) Spell(odyns_fury)
	#berserker_rage,if=talent.outburst.enabled&cooldown.dragon_roar.remains=0&buff.enrage.down
	if Talent(outburst_talent) and not SpellCooldown(dragon_roar) > 0 and not IsEnraged() Spell(berserker_rage)

	unless { Rage() > 95 or BuffPresent(massacre_buff) } and Spell(rampage) or not Talent(inner_rage_talent) and BuffPresent(wrecking_ball_buff) and Spell(whirlwind) or IsEnraged() and Spell(raging_blow) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or { IsEnraged() or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) } and Spell(execute) or Spell(bloodthirst) or Spell(raging_blow)
	{
		#dragon_roar,if=!talent.bloodbath.enabled&(cooldown.battle_cry.remains<1|cooldown.battle_cry.remains>10)|talent.bloodbath.enabled&cooldown.bloodbath.remains=0
		if not Talent(bloodbath_talent) and { SpellCooldown(battle_cry) < 1 or SpellCooldown(battle_cry) > 10 } or Talent(bloodbath_talent) and not SpellCooldown(bloodbath) > 0 Spell(dragon_roar)
	}
}

### actions.two_targets

AddFunction FurySingleMindedFuryTwoTargetsMainActions
{
	#whirlwind,if=buff.meat_cleaver.down
	if BuffExpires(meat_cleaver_buff) Spell(whirlwind)
	#rampage,if=buff.enrage.down|(rage=100&buff.juggernaut.down)|buff.massacre.up
	if not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) Spell(rampage)
	#bloodthirst,if=buff.enrage.down
	if not IsEnraged() Spell(bloodthirst)
	#raging_blow,if=talent.inner_rage.enabled&spell_targets.whirlwind=2
	if Talent(inner_rage_talent) and Enemies() == 2 Spell(raging_blow)
	#whirlwind,if=spell_targets.whirlwind>2
	if Enemies() > 2 Spell(whirlwind)
	#bloodthirst
	Spell(bloodthirst)
	#whirlwind
	Spell(whirlwind)
}

AddFunction FurySingleMindedFuryTwoTargetsShortCdActions
{
	unless BuffExpires(meat_cleaver_buff) and Spell(whirlwind)
	{
		#call_action_list,name=bladestorm
		FurySingleMindedFuryBladestormShortCdActions()

		unless { not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) } and Spell(rampage) or not IsEnraged() and Spell(bloodthirst) or Talent(inner_rage_talent) and Enemies() == 2 and Spell(raging_blow) or Enemies() > 2 and Spell(whirlwind)
		{
			#dragon_roar
			Spell(dragon_roar)
		}
	}
}

AddFunction FurySingleMindedFuryTwoTargetsShortCdPostConditions
{
	BuffExpires(meat_cleaver_buff) and Spell(whirlwind) or { not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) } and Spell(rampage) or not IsEnraged() and Spell(bloodthirst) or Talent(inner_rage_talent) and Enemies() == 2 and Spell(raging_blow) or Enemies() > 2 and Spell(whirlwind) or Spell(bloodthirst) or Spell(whirlwind)
}

### Fury icons.

AddCheckBox(opt_warrior_fury_aoe L(AOE) default specialization=fury)

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=shortcd specialization=fury
{
	FurySingleMindedFuryDefaultShortCdActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=shortcd specialization=fury
{
	FurySingleMindedFuryDefaultShortCdActions()
}

AddIcon enemies=1 help=main specialization=fury
{
	FurySingleMindedFuryDefaultMainActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=aoe specialization=fury
{
	FurySingleMindedFuryDefaultMainActions()
}

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=cd specialization=fury
{
	if not InCombat() FurySingleMindedFuryPrecombatCdActions()
	FurySingleMindedFuryDefaultCdActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=cd specialization=fury
{
	if not InCombat() FurySingleMindedFuryPrecombatCdActions()
	FurySingleMindedFuryDefaultCdActions()
}

### Required symbols
# arcane_torrent_rage
# avatar
# battle_cry
# battle_cry_buff
# berserker_rage
# berserking
# bladestorm
# bladestorm_talent
# blood_fury_ap
# bloodbath
# bloodbath_talent
# bloodthirst
# charge
# draenic_strength_potion
# dragon_roar
# dragon_roar_buff
# dragon_roar_talent
# execute
# furious_slash
# heroic_leap
# inner_rage_talent
# juggernaut_buff
# legendary_ring_strength
# massacre_buff
# meat_cleaver_buff
# odyns_fury
# outburst_talent
# pummel
# raging_blow
# rampage
# stone_heart_buff
# whirlwind
# wrecking_ball_buff
]]
	OvaleScripts:RegisterScript("WARRIOR", "fury", name, desc, code, "script")
end

do
	local name = "simulationcraft_warrior_fury_2h_t18m"
	local desc = "[7.0] SimulationCraft: Warrior_Fury_2h_T18M"
	local code = [[
# Based on SimulationCraft profile "Warrior_Fury_2h_T18M".
#	class=warrior
#	spec=fury
#	talents=2313133

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=fury)
AddCheckBox(opt_potion_strength ItemName(draenic_strength_potion) default specialization=fury)
AddCheckBox(opt_legendary_ring_strength ItemName(legendary_ring_strength) default specialization=fury)

AddFunction FuryTitansGripUsePotionStrength
{
	if CheckBoxOn(opt_potion_strength) and target.Classification(worldboss) Item(draenic_strength_potion usable=1)
}

AddFunction FuryTitansGripGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range)
	{
		if target.InRange(charge) Spell(charge)
		if target.InRange(charge) Spell(heroic_leap)
		if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

### actions.default

AddFunction FuryTitansGripDefaultMainActions
{
	#call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
	if Enemies() == 2 or Enemies() == 3 FuryTitansGripTwoTargetsMainActions()
	#call_action_list,name=aoe,if=spell_targets.whirlwind>3
	if Enemies() > 3 FuryTitansGripAoeMainActions()
	#call_action_list,name=single_target
	FuryTitansGripSingleTargetMainActions()
}

AddFunction FuryTitansGripDefaultShortCdActions
{
	#auto_attack
	FuryTitansGripGetInMeleeRange()
	#charge
	if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(charge)
	#run_action_list,name=movement,if=movement.distance>5
	if 0 > 5 FuryTitansGripMovementShortCdActions()
	#heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
	if { 0 > 25 and 600 > 45 or not False(raid_event_movement_exists) } and CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(heroic_leap)
	#avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remains+10))
	if BuffPresent(battle_cry_buff) or target.TimeToDie() < SpellCooldown(battle_cry) + 10 Spell(avatar)
	#call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
	if Enemies() == 2 or Enemies() == 3 FuryTitansGripTwoTargetsShortCdActions()

	unless { Enemies() == 2 or Enemies() == 3 } and FuryTitansGripTwoTargetsShortCdPostConditions()
	{
		#call_action_list,name=aoe,if=spell_targets.whirlwind>3
		if Enemies() > 3 FuryTitansGripAoeShortCdActions()

		unless Enemies() > 3 and FuryTitansGripAoeShortCdPostConditions()
		{
			#call_action_list,name=single_target
			FuryTitansGripSingleTargetShortCdActions()
		}
	}
}

AddFunction FuryTitansGripDefaultCdActions
{
	#use_item,name=thorasus_the_stone_heart_of_draenor,if=(spell_targets.whirlwind>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.battle_cry.up|target.time_to_die<25)
	if { Enemies() > 1 or not False(raid_event_adds_exists) } and { Talent(bladestorm_talent) and not SpellCooldown(bladestorm) > 0 or BuffPresent(battle_cry_buff) or target.TimeToDie() < 25 } and CheckBoxOn(opt_legendary_ring_strength) Item(legendary_ring_strength usable=1)
	#potion,name=draenic_strength,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<=30
	if target.HealthPercent() < 20 and BuffPresent(battle_cry_buff) or target.TimeToDie() <= 30 FuryTitansGripUsePotionStrength()
	#battle_cry,if=(artifact.odyns_fury.enabled&cooldown.odyns_fury.remains=0&(cooldown.bloodthirst.remains=0|(buff.enrage.remains>cooldown.bloodthirst.remains)))|!artifact.odyns_fury.enabled
	if BuffPresent(odyns_fury_buff) and not SpellCooldown(odyns_fury) > 0 and { not SpellCooldown(bloodthirst) > 0 or EnrageRemaining() > SpellCooldown(bloodthirst) } or not BuffPresent(odyns_fury_buff) Spell(battle_cry)
	#bloodbath,if=buff.dragon_roar.up|(!talent.dragon_roar.enabled&(buff.battle_cry.up|cooldown.battle_cry.remains>10))
	if BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and { BuffPresent(battle_cry_buff) or SpellCooldown(battle_cry) > 10 } Spell(bloodbath)
	#blood_fury,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(blood_fury_ap)
	#berserking,if=buff.battle_cry.up
	if BuffPresent(battle_cry_buff) Spell(berserking)
	#arcane_torrent,if=rage<rage.max-40
	if Rage() < MaxRage() - 40 Spell(arcane_torrent_rage)
}

### actions.aoe

AddFunction FuryTitansGripAoeMainActions
{
	#bloodthirst,if=buff.enrage.down|rage<50
	if not IsEnraged() or Rage() < 50 Spell(bloodthirst)
	#whirlwind,if=buff.enrage.up
	if IsEnraged() Spell(whirlwind)
	#rampage,if=buff.meat_cleaver.up
	if BuffPresent(meat_cleaver_buff) Spell(rampage)
	#bloodthirst
	Spell(bloodthirst)
	#whirlwind
	Spell(whirlwind)
}

AddFunction FuryTitansGripAoeShortCdActions
{
	unless { not IsEnraged() or Rage() < 50 } and Spell(bloodthirst)
	{
		#call_action_list,name=bladestorm
		FuryTitansGripBladestormShortCdActions()

		unless IsEnraged() and Spell(whirlwind)
		{
			#dragon_roar
			Spell(dragon_roar)
		}
	}
}

AddFunction FuryTitansGripAoeShortCdPostConditions
{
	{ not IsEnraged() or Rage() < 50 } and Spell(bloodthirst) or IsEnraged() and Spell(whirlwind) or BuffPresent(meat_cleaver_buff) and Spell(rampage) or Spell(bloodthirst) or Spell(whirlwind)
}

### actions.bladestorm

AddFunction FuryTitansGripBladestormShortCdActions
{
	#bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
	if EnrageRemaining() > 2 and { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } Spell(bladestorm)
}

### actions.movement

AddFunction FuryTitansGripMovementShortCdActions
{
	#heroic_leap
	if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(heroic_leap)
}

### actions.precombat

AddFunction FuryTitansGripPrecombatCdActions
{
	#flask,type=greater_draenic_strength_flask
	#food,type=pickled_eel
	#snapshot_stats
	#potion,name=draenic_strength
	FuryTitansGripUsePotionStrength()
}

### actions.single_target

AddFunction FuryTitansGripSingleTargetMainActions
{
	#rampage,if=rage>95|buff.massacre.react
	if Rage() > 95 or BuffPresent(massacre_buff) Spell(rampage)
	#whirlwind,if=!talent.inner_rage.enabled&buff.wrecking_ball.react
	if not Talent(inner_rage_talent) and BuffPresent(wrecking_ball_buff) Spell(whirlwind)
	#raging_blow,if=buff.enrage.up
	if IsEnraged() Spell(raging_blow)
	#whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
	if BuffPresent(wrecking_ball_buff) and IsEnraged() Spell(whirlwind)
	#execute,if=buff.enrage.up|buff.battle_cry.up|buff.stone_heart.react
	if IsEnraged() or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) Spell(execute)
	#bloodthirst
	Spell(bloodthirst)
	#raging_blow
	Spell(raging_blow)
	#rampage,if=(target.health.pct>20&(cooldown.battle_cry.remains>3|buff.battle_cry.up|rage>90))
	if target.HealthPercent() > 20 and { SpellCooldown(battle_cry) > 3 or BuffPresent(battle_cry_buff) or Rage() > 90 } Spell(rampage)
	#execute,if=rage>50|buff.battle_cry.up|buff.stone_heart.react|target.time_to_die<20
	if Rage() > 50 or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) or target.TimeToDie() < 20 Spell(execute)
	#furious_slash
	Spell(furious_slash)
}

AddFunction FuryTitansGripSingleTargetShortCdActions
{
	#odyns_fury,if=buff.battle_cry.up|target.time_to_die<cooldown.battle_cry.remains
	if BuffPresent(battle_cry_buff) or target.TimeToDie() < SpellCooldown(battle_cry) Spell(odyns_fury)
	#berserker_rage,if=talent.outburst.enabled&cooldown.dragon_roar.remains=0&buff.enrage.down
	if Talent(outburst_talent) and not SpellCooldown(dragon_roar) > 0 and not IsEnraged() Spell(berserker_rage)

	unless { Rage() > 95 or BuffPresent(massacre_buff) } and Spell(rampage) or not Talent(inner_rage_talent) and BuffPresent(wrecking_ball_buff) and Spell(whirlwind) or IsEnraged() and Spell(raging_blow) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or { IsEnraged() or BuffPresent(battle_cry_buff) or BuffPresent(stone_heart_buff) } and Spell(execute) or Spell(bloodthirst) or Spell(raging_blow)
	{
		#dragon_roar,if=!talent.bloodbath.enabled&(cooldown.battle_cry.remains<1|cooldown.battle_cry.remains>10)|talent.bloodbath.enabled&cooldown.bloodbath.remains=0
		if not Talent(bloodbath_talent) and { SpellCooldown(battle_cry) < 1 or SpellCooldown(battle_cry) > 10 } or Talent(bloodbath_talent) and not SpellCooldown(bloodbath) > 0 Spell(dragon_roar)
	}
}

### actions.two_targets

AddFunction FuryTitansGripTwoTargetsMainActions
{
	#whirlwind,if=buff.meat_cleaver.down
	if BuffExpires(meat_cleaver_buff) Spell(whirlwind)
	#rampage,if=buff.enrage.down|(rage=100&buff.juggernaut.down)|buff.massacre.up
	if not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) Spell(rampage)
	#bloodthirst,if=buff.enrage.down
	if not IsEnraged() Spell(bloodthirst)
	#raging_blow,if=talent.inner_rage.enabled&spell_targets.whirlwind=2
	if Talent(inner_rage_talent) and Enemies() == 2 Spell(raging_blow)
	#whirlwind,if=spell_targets.whirlwind>2
	if Enemies() > 2 Spell(whirlwind)
	#bloodthirst
	Spell(bloodthirst)
	#whirlwind
	Spell(whirlwind)
}

AddFunction FuryTitansGripTwoTargetsShortCdActions
{
	unless BuffExpires(meat_cleaver_buff) and Spell(whirlwind)
	{
		#call_action_list,name=bladestorm
		FuryTitansGripBladestormShortCdActions()

		unless { not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) } and Spell(rampage) or not IsEnraged() and Spell(bloodthirst) or Talent(inner_rage_talent) and Enemies() == 2 and Spell(raging_blow) or Enemies() > 2 and Spell(whirlwind)
		{
			#dragon_roar
			Spell(dragon_roar)
		}
	}
}

AddFunction FuryTitansGripTwoTargetsShortCdPostConditions
{
	BuffExpires(meat_cleaver_buff) and Spell(whirlwind) or { not IsEnraged() or Rage() == 100 and BuffExpires(juggernaut_buff) or BuffPresent(massacre_buff) } and Spell(rampage) or not IsEnraged() and Spell(bloodthirst) or Talent(inner_rage_talent) and Enemies() == 2 and Spell(raging_blow) or Enemies() > 2 and Spell(whirlwind) or Spell(bloodthirst) or Spell(whirlwind)
}

### Fury icons.

AddCheckBox(opt_warrior_fury_aoe L(AOE) default specialization=fury)

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=shortcd specialization=fury
{
	FuryTitansGripDefaultShortCdActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=shortcd specialization=fury
{
	FuryTitansGripDefaultShortCdActions()
}

AddIcon enemies=1 help=main specialization=fury
{
	FuryTitansGripDefaultMainActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=aoe specialization=fury
{
	FuryTitansGripDefaultMainActions()
}

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=cd specialization=fury
{
	if not InCombat() FuryTitansGripPrecombatCdActions()
	FuryTitansGripDefaultCdActions()
}

AddIcon checkbox=opt_warrior_fury_aoe help=cd specialization=fury
{
	if not InCombat() FuryTitansGripPrecombatCdActions()
	FuryTitansGripDefaultCdActions()
}

### Required symbols
# arcane_torrent_rage
# avatar
# battle_cry
# battle_cry_buff
# berserker_rage
# berserking
# bladestorm
# bladestorm_talent
# blood_fury_ap
# bloodbath
# bloodbath_talent
# bloodthirst
# charge
# draenic_strength_potion
# dragon_roar
# dragon_roar_buff
# dragon_roar_talent
# execute
# furious_slash
# heroic_leap
# inner_rage_talent
# juggernaut_buff
# legendary_ring_strength
# massacre_buff
# meat_cleaver_buff
# odyns_fury
# outburst_talent
# pummel
# raging_blow
# rampage
# stone_heart_buff
# whirlwind
# wrecking_ball_buff
]]
	OvaleScripts:RegisterScript("WARRIOR", "fury", name, desc, code, "script")
end
