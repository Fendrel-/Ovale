local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

-- THE REST OF THIS FILE IS AUTOMATICALLY GENERATED.
-- ANY CHANGES MADE BELOW THIS POINT WILL BE LOST.

do
	local name = "simulationcraft_hunter_bm_t18m"
	local desc = "[6.2] SimulationCraft: Hunter_BM_T18M"
	local code = [[
# Based on SimulationCraft profile "Hunter_BM_T18M".
#	class=hunter
#	spec=beast_mastery
#	talents=0001333

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=beast_mastery)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=beast_mastery)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=beast_mastery)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=beast_mastery)

AddFunction BeastMasteryUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction BeastMasteryUseItemActions
{
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction BeastMasteryInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction BeastMasterySummonPet
{
	if pet.IsDead()
	{
		if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
		Spell(revive_pet)
	}
	if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
}

### actions.default

AddFunction BeastMasteryDefaultMainActions
{
	#multishot,if=spell_targets.multi_shot>1&pet.cat.buff.beast_cleave.remains<0.5
	if Enemies() > 1 and pet.BuffRemaining(pet_beast_cleave_buff) < 0.5 Spell(multishot)
	#barrage,if=spell_targets.barrage>1
	if Enemies() > 1 Spell(barrage)
	#multishot,if=spell_targets.multi_shot>5
	if Enemies() > 5 Spell(multishot)
	#kill_command
	if pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() Spell(kill_command)
	#kill_shot,if=focus.time_to_max>gcd
	if TimeToMaxFocus() > GCD() Spell(kill_shot)
	#focusing_shot,if=focus<50
	if Focus() < 50 Spell(focusing_shot)
	#cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<7&(14+cast_regen)<focus.deficit
	if BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 7 and 14 + FocusCastingRegen(cobra_shot) < FocusDeficit() Spell(cobra_shot)
	#cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<4&focus<50
	if Talent(steady_focus_talent) and BuffRemaining(steady_focus_buff) < 4 and Focus() < 50 Spell(cobra_shot)
	#glaive_toss
	Spell(glaive_toss)
	#barrage
	Spell(barrage)
	#powershot,if=focus.time_to_max>cast_time
	if TimeToMaxFocus() > CastTime(powershot) Spell(powershot)
	#cobra_shot,if=spell_targets.multi_shot>5
	if Enemies() > 5 Spell(cobra_shot)
	#arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 or BuffPresent(bestial_wrath_buff) Spell(arcane_shot)
	#arcane_shot,if=focus>=75
	if Focus() >= 75 Spell(arcane_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction BeastMasteryDefaultShortCdActions
{
	#dire_beast
	Spell(dire_beast)
	#focus_fire,if=buff.focus_fire.down&((cooldown.bestial_wrath.remains<1&buff.bestial_wrath.down)|(talent.stampede.enabled&buff.stampede.remains)|pet.cat.buff.frenzy.remains<1)
	if BuffExpires(focus_fire_buff) and { SpellCooldown(bestial_wrath) < 1 and BuffExpires(bestial_wrath_buff) or Talent(stampede_talent) and TimeSincePreviousSpell(stampede) < 40 or pet.BuffRemaining(pet_frenzy_buff) < 1 } Spell(focus_fire)
	#bestial_wrath,if=focus>30&!buff.bestial_wrath.up
	if Focus() > 30 and not BuffPresent(bestial_wrath_buff) Spell(bestial_wrath)

	unless Enemies() > 1 and pet.BuffRemaining(pet_beast_cleave_buff) < 0.5 and Spell(multishot)
	{
		#focus_fire,min_frenzy=5
		if pet.BuffStacks(pet_frenzy_buff) >= 5 Spell(focus_fire)

		unless Enemies() > 1 and Spell(barrage)
		{
			#explosive_trap,if=spell_targets.explosive_trap_tick>5
			if Enemies() > 5 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)

			unless Enemies() > 5 and Spell(multishot) or pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command)
			{
				#a_murder_of_crows
				Spell(a_murder_of_crows)

				unless TimeToMaxFocus() > GCD() and Spell(kill_shot) or Focus() < 50 and Spell(focusing_shot) or BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 7 and 14 + FocusCastingRegen(cobra_shot) < FocusDeficit() and Spell(cobra_shot)
				{
					#explosive_trap,if=spell_targets.explosive_trap_tick>1
					if Enemies() > 1 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
				}
			}
		}
	}
}

AddFunction BeastMasteryDefaultCdActions
{
	#auto_shot
	#counter_shot
	BeastMasteryInterruptActions()
	#use_item,name=maalus_the_blood_drinker
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#use_item,slot=trinket1
	BeastMasteryUseItemActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#potion,name=draenic_agility,if=!talent.stampede.enabled&((buff.bestial_wrath.up&(legendary_ring.up|!legendary_ring.has_cooldown)&target.health.pct<=20)|target.time_to_die<=20)
	if not Talent(stampede_talent) and { BuffPresent(bestial_wrath_buff) and { BuffPresent(legendary_ring_agility_buff) or not ItemCooldown(legendary_ring_agility) > 0 } and target.HealthPercent() <= 20 or target.TimeToDie() <= 20 } BeastMasteryUsePotionAgility()
	#potion,name=draenic_agility,if=talent.stampede.enabled&((buff.stampede.remains&(legendary_ring.up|!legendary_ring.has_cooldown)&(buff.bloodlust.up|buff.focus_fire.up))|target.time_to_die<=40)
	if Talent(stampede_talent) and { TimeSincePreviousSpell(stampede) < 40 and { BuffPresent(legendary_ring_agility_buff) or not ItemCooldown(legendary_ring_agility) > 0 } and { BuffPresent(burst_haste_buff any=1) or BuffPresent(focus_fire_buff) } or target.TimeToDie() <= 40 } BeastMasteryUsePotionAgility()
	#stampede,if=((buff.bloodlust.up|buff.focus_fire.up)&(legendary_ring.up|!legendary_ring.has_cooldown))|target.time_to_die<=25
	if { BuffPresent(burst_haste_buff any=1) or BuffPresent(focus_fire_buff) } and { BuffPresent(legendary_ring_agility_buff) or not ItemCooldown(legendary_ring_agility) > 0 } or target.TimeToDie() <= 25 Spell(stampede)
}

### actions.precombat

AddFunction BeastMasteryPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=spell_targets.multi_shot<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=spell_targets.multi_shot>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#focusing_shot
	Spell(focusing_shot)
}

AddFunction BeastMasteryPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=sleeper_sushi
	#summon_pet
	BeastMasterySummonPet()
}

AddFunction BeastMasteryPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(focusing_shot)
}

AddFunction BeastMasteryPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		BeastMasteryUsePotionAgility()
	}
}

AddFunction BeastMasteryPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(focusing_shot)
}

### BeastMastery icons.

AddCheckBox(opt_hunter_beast_mastery_aoe L(AOE) default specialization=beast_mastery)

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=shortcd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatShortCdActions()
	unless not InCombat() and BeastMasteryPrecombatShortCdPostConditions()
	{
		BeastMasteryDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=shortcd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatShortCdActions()
	unless not InCombat() and BeastMasteryPrecombatShortCdPostConditions()
	{
		BeastMasteryDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatMainActions()
	BeastMasteryDefaultMainActions()
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=aoe specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatMainActions()
	BeastMasteryDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=cd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatCdActions()
	unless not InCombat() and BeastMasteryPrecombatCdPostConditions()
	{
		BeastMasteryDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=cd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatCdActions()
	unless not InCombat() and BeastMasteryPrecombatCdPostConditions()
	{
		BeastMasteryDefaultCdActions()
	}
}

### Required symbols
# a_murder_of_crows
# arcane_shot
# arcane_torrent_focus
# barrage
# berserking
# bestial_wrath
# bestial_wrath_buff
# blood_fury_ap
# cobra_shot
# counter_shot
# dire_beast
# draenic_agility_potion
# exotic_munitions_buff
# explosive_trap
# focus_fire
# focus_fire_buff
# focusing_shot
# glaive_toss
# glyph_of_explosive_trap
# incendiary_ammo
# kill_command
# kill_shot
# legendary_ring_agility
# legendary_ring_agility_buff
# multishot
# pet_beast_cleave_buff
# pet_frenzy_buff
# poisoned_ammo
# powershot
# pre_steady_focus_buff
# quaking_palm
# revive_pet
# stampede
# stampede_talent
# steady_focus_buff
# steady_focus_talent
# thrill_of_the_hunt_buff
# trap_launcher
# war_stomp
]]
	OvaleScripts:RegisterScript("HUNTER", "beast_mastery", name, desc, code, "script")
end

do
	local name = "simulationcraft_hunter_mm_t18m"
	local desc = "[6.2] SimulationCraft: Hunter_MM_T18M"
	local code = [[
# Based on SimulationCraft profile "Hunter_MM_T18M".
#	class=hunter
#	spec=marksmanship
#	talents=0003323

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=marksmanship)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=marksmanship)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=marksmanship)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=marksmanship)

AddFunction MarksmanshipUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction MarksmanshipUseItemActions
{
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction MarksmanshipInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction MarksmanshipSummonPet
{
	if not Talent(lone_wolf_talent)
	{
		if pet.IsDead()
		{
			if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
			Spell(revive_pet)
		}
		if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
	}
}

### actions.default

AddFunction MarksmanshipDefaultMainActions
{
	#chimaera_shot
	Spell(chimaera_shot)
	#kill_shot
	Spell(kill_shot)
	#call_action_list,name=careful_aim,if=buff.careful_aim.up
	if target.HealthPercent() > 80 or BuffPresent(rapid_fire_buff) MarksmanshipCarefulAimMainActions()
	#glaive_toss
	Spell(glaive_toss)
	#powershot,if=cast_regen<focus.deficit
	if FocusCastingRegen(powershot) < FocusDeficit() Spell(powershot)
	#barrage
	Spell(barrage)
	#steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
	if FocusDeficit() * CastTime(steady_shot) / { 14 + FocusCastingRegen(steady_shot) } > SpellCooldown(rapid_fire) Spell(steady_shot)
	#focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
	if FocusDeficit() * CastTime(focusing_shot_marksmanship) / { 50 + FocusCastingRegen(focusing_shot_marksmanship) } > SpellCooldown(rapid_fire) and Focus() < 100 Spell(focusing_shot_marksmanship)
	#steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit
	if BuffPresent(pre_steady_focus_buff) and 14 + FocusCastingRegen(steady_shot) + FocusCastingRegen(aimed_shot) <= FocusDeficit() Spell(steady_shot)
	#multishot,if=spell_targets.multi_shot>6
	if Enemies() > 6 Spell(multishot)
	#aimed_shot,if=talent.focusing_shot.enabled
	if Talent(focusing_shot_talent) Spell(aimed_shot)
	#aimed_shot,if=focus+cast_regen>=85
	if Focus() + FocusCastingRegen(aimed_shot) >= 85 Spell(aimed_shot)
	#aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() + FocusCastingRegen(aimed_shot) >= 65 Spell(aimed_shot)
	#focusing_shot,if=50+cast_regen-10<focus.deficit
	if 50 + FocusCastingRegen(focusing_shot_marksmanship) - 10 < FocusDeficit() Spell(focusing_shot_marksmanship)
	#steady_shot
	Spell(steady_shot)
}

AddFunction MarksmanshipDefaultShortCdActions
{
	unless Spell(chimaera_shot) or Spell(kill_shot)
	{
		unless { target.HealthPercent() > 80 or BuffPresent(rapid_fire_buff) } and MarksmanshipCarefulAimShortCdPostConditions()
		{
			#explosive_trap,if=spell_targets.explosive_trap_tick>1
			if Enemies() > 1 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
			#a_murder_of_crows
			Spell(a_murder_of_crows)
			#dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
			if FocusCastingRegen(dire_beast) + FocusCastingRegen(aimed_shot) < FocusDeficit() Spell(dire_beast)
		}
	}
}

AddFunction MarksmanshipDefaultCdActions
{
	#auto_shot
	#counter_shot
	MarksmanshipInterruptActions()
	#use_item,name=maalus_the_blood_drinker
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#use_item,slot=trinket1
	MarksmanshipUseItemActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#potion,name=draenic_agility,if=((buff.rapid_fire.up|buff.bloodlust.up)&(cooldown.stampede.remains<1))|target.time_to_die<=25
	if { BuffPresent(rapid_fire_buff) or BuffPresent(burst_haste_buff any=1) } and SpellCooldown(stampede) < 1 or target.TimeToDie() <= 25 MarksmanshipUsePotionAgility()

	unless Spell(chimaera_shot) or Spell(kill_shot)
	{
		#rapid_fire
		Spell(rapid_fire)
		#stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
		if BuffPresent(rapid_fire_buff) or BuffPresent(burst_haste_buff any=1) or target.TimeToDie() <= 25 Spell(stampede)
	}
}

### actions.careful_aim

AddFunction MarksmanshipCarefulAimMainActions
{
	#glaive_toss,if=active_enemies>2
	if Enemies() > 2 Spell(glaive_toss)
	#powershot,if=spell_targets.powershot>1&cast_regen<focus.deficit
	if Enemies() > 1 and FocusCastingRegen(powershot) < FocusDeficit() Spell(powershot)
	#barrage,if=spell_targets.barrage>1
	if Enemies() > 1 Spell(barrage)
	#aimed_shot
	Spell(aimed_shot)
	#focusing_shot,if=50+cast_regen<focus.deficit
	if 50 + FocusCastingRegen(focusing_shot_marksmanship) < FocusDeficit() Spell(focusing_shot_marksmanship)
	#steady_shot
	Spell(steady_shot)
}

AddFunction MarksmanshipCarefulAimShortCdPostConditions
{
	Enemies() > 2 and Spell(glaive_toss) or Enemies() > 1 and FocusCastingRegen(powershot) < FocusDeficit() and Spell(powershot) or Enemies() > 1 and Spell(barrage) or Spell(aimed_shot) or 50 + FocusCastingRegen(focusing_shot_marksmanship) < FocusDeficit() and Spell(focusing_shot_marksmanship) or Spell(steady_shot)
}

### actions.precombat

AddFunction MarksmanshipPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=spell_targets.multi_shot<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=spell_targets.multi_shot>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#focusing_shot
	Spell(focusing_shot_marksmanship)
}

AddFunction MarksmanshipPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=pickled_eel
	#summon_pet
	MarksmanshipSummonPet()
}

AddFunction MarksmanshipPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(focusing_shot_marksmanship)
}

AddFunction MarksmanshipPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		MarksmanshipUsePotionAgility()
	}
}

AddFunction MarksmanshipPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(focusing_shot_marksmanship)
}

### Marksmanship icons.

AddCheckBox(opt_hunter_marksmanship_aoe L(AOE) default specialization=marksmanship)

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=shortcd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatShortCdActions()
	unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
	{
		MarksmanshipDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=shortcd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatShortCdActions()
	unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
	{
		MarksmanshipDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatMainActions()
	MarksmanshipDefaultMainActions()
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=aoe specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatMainActions()
	MarksmanshipDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=cd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatCdActions()
	unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
	{
		MarksmanshipDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=cd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatCdActions()
	unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
	{
		MarksmanshipDefaultCdActions()
	}
}

### Required symbols
# a_murder_of_crows
# aimed_shot
# arcane_torrent_focus
# barrage
# berserking
# blood_fury_ap
# chimaera_shot
# counter_shot
# dire_beast
# draenic_agility_potion
# exotic_munitions_buff
# explosive_trap
# focusing_shot_marksmanship
# focusing_shot_talent
# glaive_toss
# glyph_of_explosive_trap
# incendiary_ammo
# kill_shot
# legendary_ring_agility
# lone_wolf_talent
# multishot
# poisoned_ammo
# powershot
# pre_steady_focus_buff
# quaking_palm
# rapid_fire
# rapid_fire_buff
# revive_pet
# stampede
# steady_shot
# thrill_of_the_hunt_buff
# trap_launcher
# war_stomp
]]
	OvaleScripts:RegisterScript("HUNTER", "marksmanship", name, desc, code, "script")
end

do
	local name = "simulationcraft_hunter_sv_t18m"
	local desc = "[6.2] SimulationCraft: Hunter_SV_T18M"
	local code = [[
# Based on SimulationCraft profile "Hunter_SV_T18M".
#	class=hunter
#	spec=survival
#	talents=0001333

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=survival)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=survival)
AddCheckBox(opt_legendary_ring_agility ItemName(legendary_ring_agility) default specialization=survival)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=survival)

AddFunction SurvivalUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction SurvivalUseItemActions
{
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction SurvivalInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction SurvivalSummonPet
{
	if not Talent(lone_wolf_talent)
	{
		if pet.IsDead()
		{
			if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
			Spell(revive_pet)
		}
		if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
	}
}

### actions.default

AddFunction SurvivalDefaultMainActions
{
	#call_action_list,name=aoe,if=spell_targets.multi_shot>1
	if Enemies() > 1 SurvivalAoeMainActions()
	#black_arrow,cycle_targets=1,if=remains<gcd*1.5
	if target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 Spell(black_arrow)
	#arcane_shot,if=(trinket.proc.any.react&trinket.proc.any.remains<4)|dot.serpent_sting.remains<=3
	if BuffPresent(trinket_proc_any_buff) and BuffRemaining(trinket_proc_any_buff) < 4 or target.DebuffRemaining(serpent_sting_debuff) <= 3 Spell(arcane_shot)
	#explosive_shot
	Spell(explosive_shot)
	#cobra_shot,if=buff.pre_steady_focus.up
	if BuffPresent(pre_steady_focus_buff) Spell(cobra_shot)
	#arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|target.time_to_die<4.5
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 or target.TimeToDie() < 4.5 Spell(arcane_shot)
	#glaive_toss
	Spell(glaive_toss)
	#powershot
	Spell(powershot)
	#barrage
	Spell(barrage)
	#arcane_shot,if=talent.steady_focus.enabled&!talent.focusing_shot.enabled&focus.deficit<action.cobra_shot.cast_regen*2+28
	if Talent(steady_focus_talent) and not Talent(focusing_shot_talent) and FocusDeficit() < FocusCastingRegen(cobra_shot) * 2 + 28 Spell(arcane_shot)
	#cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<5
	if Talent(steady_focus_talent) and BuffRemaining(steady_focus_buff) < 5 Spell(cobra_shot)
	#focusing_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<=cast_time&focus.deficit>cast_regen
	if Talent(steady_focus_talent) and BuffRemaining(steady_focus_buff) <= CastTime(focusing_shot) and FocusDeficit() > FocusCastingRegen(focusing_shot) Spell(focusing_shot)
	#arcane_shot,if=focus>=70|talent.focusing_shot.enabled|(talent.steady_focus.enabled&focus>=50)
	if Focus() >= 70 or Talent(focusing_shot_talent) or Talent(steady_focus_talent) and Focus() >= 50 Spell(arcane_shot)
	#focusing_shot
	Spell(focusing_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction SurvivalDefaultShortCdActions
{
	#call_action_list,name=aoe,if=spell_targets.multi_shot>1
	if Enemies() > 1 SurvivalAoeShortCdActions()

	unless Enemies() > 1 and SurvivalAoeShortCdPostConditions()
	{
		#a_murder_of_crows
		Spell(a_murder_of_crows)

		unless target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 and Spell(black_arrow) or { BuffPresent(trinket_proc_any_buff) and BuffRemaining(trinket_proc_any_buff) < 4 or target.DebuffRemaining(serpent_sting_debuff) <= 3 } and Spell(arcane_shot) or Spell(explosive_shot) or BuffPresent(pre_steady_focus_buff) and Spell(cobra_shot)
		{
			#dire_beast
			Spell(dire_beast)

			unless { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 or target.TimeToDie() < 4.5 } and Spell(arcane_shot) or Spell(glaive_toss) or Spell(powershot) or Spell(barrage)
			{
				#explosive_trap,if=!trinket.proc.any.react&!trinket.stacking_proc.any.react
				if not BuffPresent(trinket_proc_any_buff) and not BuffPresent(trinket_stacking_proc_any_buff) and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
			}
		}
	}
}

AddFunction SurvivalDefaultCdActions
{
	#auto_shot
	#counter_shot
	SurvivalInterruptActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#use_item,name=maalus_the_blood_drinker
	if CheckBoxOn(opt_legendary_ring_agility) Item(legendary_ring_agility usable=1)
	#use_item,name=beating_heart_of_the_mountain
	SurvivalUseItemActions()
	#use_item,slot=trinket1
	SurvivalUseItemActions()
	#potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
	if SpellCooldown(stampede) < 1 and SpellCooldown(a_murder_of_crows) < 1 and { BuffPresent(trinket_stat_any_buff) or BuffPresent(archmages_greater_incandescence_agi_buff) } or target.TimeToDie() <= 25 SurvivalUsePotionAgility()
	#call_action_list,name=aoe,if=spell_targets.multi_shot>1
	if Enemies() > 1 SurvivalAoeCdActions()

	unless Enemies() > 1 and SurvivalAoeCdPostConditions() or Spell(a_murder_of_crows)
	{
		#stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=45
		if BuffPresent(potion_agility_buff) or ItemCooldown(draenic_agility_potion) > 0 and { BuffPresent(archmages_greater_incandescence_agi_buff) or BuffPresent(trinket_stat_any_buff) } or target.TimeToDie() <= 45 Spell(stampede)
	}
}

### actions.aoe

AddFunction SurvivalAoeMainActions
{
	#explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
	if BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } Spell(explosive_shot)
	#barrage
	Spell(barrage)
	#black_arrow,cycle_targets=1,if=remains<gcd*1.5
	if target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 Spell(black_arrow)
	#explosive_shot,if=spell_targets.multi_shot<5
	if Enemies() < 5 Spell(explosive_shot)
	#multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 Spell(multishot)
	#glaive_toss
	Spell(glaive_toss)
	#powershot
	Spell(powershot)
	#cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
	if BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 Spell(cobra_shot)
	#multishot,if=focus>=70|talent.focusing_shot.enabled
	if Focus() >= 70 or Talent(focusing_shot_talent) Spell(multishot)
	#focusing_shot
	Spell(focusing_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction SurvivalAoeShortCdActions
{
	unless BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot) or Spell(barrage) or target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 and Spell(black_arrow) or Enemies() < 5 and Spell(explosive_shot)
	{
		#explosive_trap,if=dot.explosive_trap.remains<=5
		if target.DebuffRemaining(explosive_trap_debuff) <= 5 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
		#a_murder_of_crows
		Spell(a_murder_of_crows)
		#dire_beast
		Spell(dire_beast)
	}
}

AddFunction SurvivalAoeShortCdPostConditions
{
	BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot) or Spell(barrage) or target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 and Spell(black_arrow) or Enemies() < 5 and Spell(explosive_shot) or { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 } and Spell(multishot) or Spell(glaive_toss) or Spell(powershot) or BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 and Spell(cobra_shot) or { Focus() >= 70 or Talent(focusing_shot_talent) } and Spell(multishot) or Spell(focusing_shot) or Spell(cobra_shot)
}

AddFunction SurvivalAoeCdActions
{
	#stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
	if BuffPresent(potion_agility_buff) or ItemCooldown(draenic_agility_potion) > 0 and { BuffPresent(archmages_greater_incandescence_agi_buff) or BuffPresent(trinket_stat_any_buff) or BuffPresent(archmages_incandescence_agi_buff) } Spell(stampede)
}

AddFunction SurvivalAoeCdPostConditions
{
	BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot) or Spell(barrage) or target.DebuffRemaining(black_arrow_debuff) < GCD() * 1.5 and Spell(black_arrow) or Enemies() < 5 and Spell(explosive_shot) or target.DebuffRemaining(explosive_trap_debuff) <= 5 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) and Spell(explosive_trap) or Spell(a_murder_of_crows) or Spell(dire_beast) or { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 } and Spell(multishot) or Spell(glaive_toss) or Spell(powershot) or BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 and Spell(cobra_shot) or { Focus() >= 70 or Talent(focusing_shot_talent) } and Spell(multishot) or Spell(focusing_shot) or Spell(cobra_shot)
}

### actions.precombat

AddFunction SurvivalPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=spell_targets.multi_shot<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=spell_targets.multi_shot>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#explosive_shot
	Spell(explosive_shot)
	#focusing_shot
	Spell(focusing_shot)
}

AddFunction SurvivalPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=salty_squid_roll
	#summon_pet
	SurvivalSummonPet()
}

AddFunction SurvivalPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(explosive_shot) or Spell(focusing_shot)
}

AddFunction SurvivalPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		SurvivalUsePotionAgility()
	}
}

AddFunction SurvivalPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or Spell(explosive_shot) or Spell(focusing_shot)
}

### Survival icons.

AddCheckBox(opt_hunter_survival_aoe L(AOE) default specialization=survival)

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=shortcd specialization=survival
{
	if not InCombat() SurvivalPrecombatShortCdActions()
	unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
	{
		SurvivalDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_survival_aoe help=shortcd specialization=survival
{
	if not InCombat() SurvivalPrecombatShortCdActions()
	unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
	{
		SurvivalDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=survival
{
	if not InCombat() SurvivalPrecombatMainActions()
	SurvivalDefaultMainActions()
}

AddIcon checkbox=opt_hunter_survival_aoe help=aoe specialization=survival
{
	if not InCombat() SurvivalPrecombatMainActions()
	SurvivalDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=cd specialization=survival
{
	if not InCombat() SurvivalPrecombatCdActions()
	unless not InCombat() and SurvivalPrecombatCdPostConditions()
	{
		SurvivalDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_survival_aoe help=cd specialization=survival
{
	if not InCombat() SurvivalPrecombatCdActions()
	unless not InCombat() and SurvivalPrecombatCdPostConditions()
	{
		SurvivalDefaultCdActions()
	}
}

### Required symbols
# a_murder_of_crows
# arcane_shot
# arcane_torrent_focus
# archmages_greater_incandescence_agi_buff
# archmages_incandescence_agi_buff
# barrage
# barrage_talent
# berserking
# black_arrow
# black_arrow_debuff
# blood_fury_ap
# cobra_shot
# counter_shot
# dire_beast
# draenic_agility_potion
# exotic_munitions_buff
# explosive_shot
# explosive_trap
# explosive_trap_debuff
# focusing_shot
# focusing_shot_talent
# glaive_toss
# glyph_of_explosive_trap
# incendiary_ammo
# legendary_ring_agility
# lock_and_load_buff
# lone_wolf_talent
# multishot
# poisoned_ammo
# potion_agility_buff
# powershot
# pre_steady_focus_buff
# quaking_palm
# revive_pet
# serpent_sting_debuff
# stampede
# steady_focus_buff
# steady_focus_talent
# thrill_of_the_hunt_buff
# trap_launcher
# war_stomp
]]
	OvaleScripts:RegisterScript("HUNTER", "survival", name, desc, code, "script")
end
