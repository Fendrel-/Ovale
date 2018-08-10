local __exports = LibStub:NewLibrary("ovale/scripts/ovale_hunter_spells", 80000)
if not __exports then return end
local __Scripts = LibStub:GetLibrary("ovale/Scripts")
local OvaleScripts = __Scripts.OvaleScripts
__exports.register = function()
    local name = "ovale_hunter_spells"
    local desc = "[8.0] Ovale: Hunter spells"
    local code = [[
# Hunter spells and functions.

Define(a_murder_of_crows 131894)
	SpellInfo(a_murder_of_crows cd=60 focus=20)
Define(a_murder_of_crows_debuff 131894)
	SpellInfo(a_murder_of_crows_debuff duration=15)
Define(aimed_shot 19434)
	SpellInfo(aimed_shot focus=30 cd=12 charges=2 cd_haste=ranged unusable=1)
	SpellRequire(aimed_shot unusable 0=focus,30)
	SpellRequire(aimed_shot focus_percent 0=buff,lock_and_load_buff talent=lock_and_load_talent)
	SpellAddBuff(aimed_shot lock_and_load_buff=-1 talent=lock_and_load_talent)
	SpellAddBuff(aimed_shot precise_shots_buff=1)
	SpellAddBuff(aimed_shot double_tap_buff=-1)
	SpellAddBuff(aimed_shot trick_shots_buff=-1)
	SpellAddBuff(aimed_shot master_marksman_buff=1 talent=master_marksman_talent)
	SpellAddBuff(aimed_shot lethal_shots_buff=-1 talent=lethal_shots_talent)
Define(arcane_shot 185358)
	SpellInfo(arcane_shot focus=15)
	SpellAddBuff(arcane_shot precise_shots_buff=-1)
	SpellAddBuff(arcane_shot master_marksman_buff=-1 talent=master_marksman_talent)
Define(aspect_of_the_cheetah 186257)
	SpellInfo(aspect_of_the_cheetah cd=180)
	SpellInfo(aspect_of_the_cheetah cd=144 talent=born_to_be_wild_talent)
	SpellAddBuff(aspect_of_the_cheetah aspect_of_the_cheetah_buff=1)
Define(aspect_of_the_cheetah_buff 186257)
	SpellInfo(aspect_of_the_cheetah_buff duration=12)
Define(aspect_of_the_eagle 186289)
	SpellInfo(aspect_of_the_eagle cd=90 gcd=0 offgcd=1)
	SpellAddBuff(aspect_of_the_eagle aspect_of_the_eagle_buff=1)
Define(aspect_of_the_eagle_buff 186289)
	SpellInfo(aspect_of_the_eagle_buff duration=15)
Define(aspect_of_the_turtle 186265)
	SpellInfo(aspect_of_the_turtle cd=180)
	SpellInfo(aspect_of_the_turtle cd=144 talent=born_to_be_wild_talent)
	SpellAddBuff(aspect_of_the_turtle aspect_of_the_turtle_buff=1)
Define(aspect_of_the_turtle_buff 186265)
	SpellInfo(aspect_of_the_turtle_buff duration=8)
Define(aspect_of_the_wild 193530)
	SpellInfo(aspect_of_the_wild cd=120)
Define(aspect_of_the_wild_buff 193530)
	SpellInfo(aspect_of_the_wild_buff duration=20)
Define(barbed_shot 217200)
	SpellInfo(barbed_shot cd=12 cd_haste=ranged charges=2)
	SpellAddBuff(barbed_shot barbed_shot_buff=1)
	SpellAddBuff(barbed_shot thrill_of_the_hunt_buff=1)
	SpellAddPetBuff(barbed_shot pet_frenzy_buff=1)
	SpellAddTargetDebuff(barbed_shot barbed_shot_debuff=1)
Define(barbed_shot_debuff 217200)
	SpellInfo(barbed_shot_debuff duration=8 tick=2)
Define(barbed_shot_buff 246152)
	SpellInfo(barbed_shot_buff duration=8)
Define(barrage 120360)
	SpellInfo(barrage cd=20)
	SpellInfo(barrage focus=30 specialization=marksman)
	SpellInfo(barrage focus=60 specialization=beast_mastery)
Define(beast_cleave_buff 268877)
	SpellInfo(beast_cleave_buff duration=4)
Define(bestial_wrath 19574)
	SpellInfo(bestial_wrath cd=90)
	SpellAddBuff(bestial_wrath bestial_wrath_buff=1)
Define(bestial_wrath_buff 19574)
	SpellInfo(bestial_wrath_buff duration=15)
Define(binding_shot 109248)
	SpellInfo(binding_shot cd=45)
Define(bursting_shot 186387)
	SpellInfo(bursting_shot cd=30 focus=10)
Define(butchery 212436)
	SpellInfo(butchery focus=30 cd=9 cd_haste=ranged charges=3)
	SpellAddTargetDebuff(butchery internal_bleeding_debuff=1 if_target_debuff=shrapnel_bomb_debuff)
Define(camouflage 199483)
	SpellInfo(camouflage cd=60)
Define(carve 187708)
	SpellInfo(carve focus=40 cd=6 cd_haste=melee)
	SpellInfo(carve replace=butchery talent=butchery_talent)
	SpellAddTargetDebuff(carve internal_bleeding_debuff=1 if_target_debuff=shrapnel_bomb_debuff)
Define(chakrams 259391)
	SpellInfo(chakrams focus=30 cd=20)
Define(chimaera_shot 53209)
	SpellInfo(chimaera_shot focus=-10 cd=15 cd_haste=ranged)
Define(cobra_shot 193455)
	SpellInfo(cobra_shot focus=35)
Define(concussive_shot 5116)
	SpellInfo(concussive_shot cd=5)
	SpellAddTargetDebuff(concussive_shot concussive_shot_debuff=1)
Define(concussive_shot_debuff 5116)
	SpellInfo(concussive_shot_debuff duration=6)
Define(coordinated_assault 266779)
	SpellInfo(coordinated_assault cd=120)
	SpellAddBuff(coordinated_assault coordinated_assault_buff=1)
	SpellAddPetBuff(coordinated_assault pet_coordinated_assault_buff=1)
Define(coordinated_assault_buff 266779)
	SpellInfo(coordinated_assault_buff duration=20)
Define(counter_shot 147362)
	SpellInfo(counter_shot cd=24)
Define(dire_beast 120679)
	SpellInfo(dire_beast cd=20 cd_haste=ranged)
	SpellAddPetBuff(dire_beast dire_beast_buff=1)
Define(dire_beast_buff 281036)
	SpellInfo(dire_beast_buff duration=8)
	# TODO: Regenerates 3 focus every 2 seconds, double for dire_stable_talent
Define(disengage 781)
	SpellInfo(disengage cd=20)
	SpellAddBuff(disengage posthaste_buff=1)
Define(double_tap 260402)
	SpellInfo(double_tap cd=60)
	SpellAddBuff(double_tap double_tap_buff=1)
Define(double_tap_buff 260402)
	SpellInfo(double_tap_buff duration=15)
Define(exhilaration 109304)
	SpellInfo(exhilaration cd=120)
Define(explosive_shot 212431)
	SpellInfo(explosive_shot cd=30 focus=20)
Define(explosive_shot_detonate 212679)
Define(feign_death 5384)
	SpellInfo(feign_death cd=30)
Define(flanking_strike 269751)
	SpellInfo(flanking_strike cd=40 focus=-30)
Define(flare 1543)
	SpellInfo(flare cd=20)
Define(freezing_trap 187650)
	SpellInfo(freezing_trap cd=30)
Define(harpoon 190925)
	SpellInfo(harpoon cd=20)
Define(hunters_mark 257284)
	SpellAddTargetDebuff(hunters_mark hunters_mark_debuff=1)
Define(hunters_mark_debuff 257284)
Define(internal_bleeding_debuff 270343)
    SpellInfo(internal_bleeding_debuff duration=8 max_stacks=3)
Define(intimidation 19577)
	SpellInfo(intimidation cd=60)
Define(kill_command 34026)
	SpellInfo(kill_command cd=7.5 cd_haste=ranged focus=30)
	# Unsure of right syntax for following line.  
	# cobra_shot resets kill_command upon impact with the target when bestial_wrath_buff is up
	# SpellRequire(kill_command cd_percent 0=spell,cobra_shot if_buff=bestial_wrath_buff)
Define(kill_command_sv 259489)
	SpellInfo(kill_command_sv cd=6 cd_haste=ranged focus=-15)
	SpellInfo(kill_command_sv charges=2 talent=alpha_predator_talent)
	SpellAddBuff(kill_command_sv tip_of_the_spear_buff=1 talent=tip_of_the_spear_talent)
	SpellRequire(kill_command_sv cd_percent 0=target_debuff,pheromone_bomb_debuff)
Define(lethal_shots_buff 260395)
	SpellInfo(lethal_shots_buff duration=15)
Define(lock_and_load_buff 194594)
	SpellInfo(lock_and_load_buff duration=15)
Define(master_marksman_buff 269576)
    SpellInfo(master_marksman_buff duration=12)
Define(mend_pet 982)
	SpellInfo(mend_pet cd=10)
Define(misdirection 34477)
	SpellInfo(misdirection cd=30)
Define(mongoose_bite 259387)
	SpellInfo(mongoose_bite cd=12)
	SpellAddTargetDebuff(mongoose_bite internal_bleeding_debuff=1 if_target_debuff=shrapnel_bomb_debuff)
Define(mongoose_fury_buff 259388)
	SpellInfo(mongoose_fury_buff duration=14)
Define(multishot_bm 2643)
	SpellInfo(multishot_bm focus=40)
	SpellAddBuff(multishot_bm beast_cleave_buff=1)
	SpellAddPetBuff(multishot_bm pet_beast_cleave_buff=1)
Define(multishot_mm 257620)
	SpellInfo(multishot_mm focus=15 specialization=beast_mastery)
	SpellAddBuff(multishot_mm precise_shots_buff=-1)
	SpellAddBuff(multishot_mm trick_shots_buff=1)
	SpellAddBuff(multishot_mm master_marksman_buff=-1 talent=master_marksman_talent)
Define(muzzle 187707)
	SpellInfo(muzzle cd=15 interrupt=1)
Define(pheromone_bomb 270323)
	SpellInfo(pheromone_bomb cd=18 cd_haste=ranged)
	SpellInfo(pheromone_bomb charges=2 talent=guerrilla_tactics_talent)
Define(pheromone_bomb_debuff 270332)
    SpellInfo(pheromone_bomb_debuff duration=6)
Define(piercing_shot 198670)
	SpellInfo(piercing_shot cd=30 focus=35)
Define(posthaste_buff 118922)
	SpellInfo(posthaste_buff duration=4)
Define(precise_shots_buff 260242)
	SpellInfo(precise_shots_buff duration=15 max_stacks=2)
Define(rapid_fire 257044)
	SpellInfo(rapid_fire channel=3 haste=ranged cd=20)
	SpellInfo(rapid_fire channel=4 talent=streamline_talent)
	SpellAddBuff(rapid_fire precise_shots_buff=1)
	SpellAddBuff(rapid_fire trick_shots_buff=-1)
	SpellAddBuff(rapid_fire lethal_shots_buff=-1 talent=lethal_shots_talent)
Define(raptor_strike 186270)
	SpellInfo(raptor_strike focus=25)
	SpellInfo(raptor_strike replace=mongoose_bite talent=mongoose_bite_talent)
	SpellAddBuff(raptor_strike tip_of_the_spear_buff=0 talent=tip_of_the_spear_talent)
	SpellAddTargetDebuff(raptor_strike internal_bleeding_debuff=1 if_target_debuff=shrapnel_bomb_debuff)
Define(revive_pet 982)
	SpellInfo(revive_pet focus=35)
Define(serpent_sting_mm 271788)
	SpellInfo(serpent_sting_mm focus=10)
	SpellAddTargetDebuff(serpent_sting_mm serpent_sting_mm_debuff=1)
Define(serpent_sting_mm_debuff 271788)
	SpellInfo(serpent_sting_mm_debuff duration=12 tick=3 haste=ranged)
Define(serpent_sting_sv 259491)
	SpellInfo(serpent_sting_sv focus=20)
	SpellRequire(serpent_sting_sv focus_percent 0=buff,vipers_venom_buff)
	SpellAddTargetDebuff(serpent_sting_sv serpent_sting_sv_debuff=1)
Define(serpent_sting_sv_debuff 259491)
	SpellInfo(serpent_sting_sv_debuff duration=12 tick=3 haste=ranged)
Define(shrapnel_bomb 270335)
	SpellInfo(shrapnel_bomb cd=18 cd_haste=ranged)
	SpellInfo(shrapnel_bomb charges=2 talent=guerrilla_tactics_talent)
Define(shrapnel_bomb_debuff 270339)
	SpellInfo(shrapnel_bomb_debuff duration=6)
Define(spitting_cobra 194407)
	SpellInfo(spitting_cobra cd=90)
	SpellAddBuff(spitting_cobra spitting_cobra_buff)
Define(spitting_cobra_buff 194407)
	SpellInfo(spitting_cobra_buff duration=20)
Define(stampede 201430)
	SpellInfo(stampede cd=180)
Define(steady_focus_buff 193534)
	SpellInfo(steady_focus_buff duration=12 max_stacks=2)
Define(steady_shot 56641)
	SpellInfo(steady_shot focus=-10)
	SpellAddBuff(steady_shot steady_focus_buff=1 talent=steady_focus_talent)
Define(steel_trap 162488)
	SpellInfo(steel_trap cd=60)
Define(tar_trap 187698)
	SpellInfo(tar_trap cd=30)
Define(thrill_of_the_hunt_buff 257946)
	SpellInfo(thrill_of_the_hunt_buff duration=8 max_stacks=3)
Define(tip_of_the_spear_buff 260286)
    SpellInfo(tip_of_the_spear_buff duration=10 max_stacks=3)
Define(trick_shots_buff 257622)
	SpellInfo(trick_shots_buff duration=20)
Define(trueshot 193526)
	SpellInfo(trueshot cd=180)
	SpellAddBuff(trueshot trueshot_buff=1)
Define(trueshot_buff 193526)
	SpellInfo(trueshot_buff duration=15)
Define(vipers_venom_buff 268552)
    SpellInfo(vipers_venom_buff duration=8)
Define(volatile_bomb 271045)
	SpellInfo(volatile_bomb cd=18 cd_haste=ranged)
	SpellInfo(volatile_bomb charges=2 talent=guerrilla_tactics_talent)
Define(volatile_bomb_debuff 271049)
    SpellInfo(volatile_bomb_debuff duration=6)
    SpellAddTargetDebuff(volatile_bomb_debuff serpent_sting_sv_debuff=1 if_target_debuff=serpent_sting_sv_debuff)
Define(wildfire_bomb 259495)
	SpellInfo(wildfire_bomb cd=18 cd_haste=ranged)
	SpellInfo(wildfire_bomb charges=2 talent=guerrilla_tactics_talent)
Define(wildfire_bomb_debuff 269747)
	SpellInfo(wildfire_bomb_debuff duration=6)
Define(wing_clip 195645)
	SpellInfo(wing_clip focus=30)
	SpellAddTargetDebuff(wing_clip wing_clip_debuff=1)
Define(wing_clip_debuff 195645)
	SpellInfo(wing_clip_debuff duration=15)


#Pet Spells
Define(heart_of_the_phoenix 55709)
	SpellInfo(heart_of_the_phoenix cd=480)
Define(heart_of_the_phoenix_debuff 55711)
	SpellInfo(heart_of_the_phoenix_debuff duration=480)
Define(pet_beast_cleave_buff 118455)
	SpellInfo(pet_beast_cleave_buff duration=4)
Define(pet_coordinated_assault_buff 266779)
	SpellInfo(pet_coordinated_assault_buff duration=20)
Define(pet_frenzy_buff 272790)
	SpellInfo(pet_frenzy_buff duration=8 max_stacks=3)

#Items
Define(frizzos_fingertrap_item 137043)
Define(the_mantle_of_command_item 144326)
Define(qapla_eredun_war_order_item 137227)
Define(call_of_the_wild_item 137101)
Define(parsels_tongue_item 151805)
Define(parsels_tongue_item_buff 248085)

# Talents
Define(a_murder_of_crows_talent 12)
Define(mm_a_murder_of_crows_talent 3)
Define(alpha_predator_talent 3)
Define(animal_companion_talent 2)
Define(aspect_of_the_beast_talent 19)
Define(barrage_talent 17)
Define(binding_shot_talent 15)
Define(birds_of_prey_talent 19)
Define(bloodseeker_talent 10)
Define(born_to_be_wild_talent 13)
Define(butchery_talent 6)
Define(calling_the_shots_talent 19)
Define(camouflage_talent 9)
Define(careful_aim_talent 4)
Define(chakrams_talent 21)
Define(chimaera_shot_talent 6)
Define(dire_beast_talent 3)
Define(double_tap_talent 18)
Define(explosive_shot_talent 6)
Define(flanking_strike_talent 18)
Define(guerrilla_tactics_talent 4)
Define(hunters_mark_talent 12)
Define(hydras_bite_talent 5)
Define(killer_cobra_talent 20)
Define(killer_instinct_talent 1)
Define(lethal_shots_talent 16)
Define(lock_and_load_talent 20)
Define(master_marksman_talent 1)
Define(mongoose_bite_talent 17)
Define(natural_mending_talent 8)
Define(one_with_the_pack_talent 5)
Define(piercing_shot_talent 21)
Define(posthaste_talent 14)
Define(scent_of_blood_talent 4)
Define(serpent_sting_talent 2)
Define(spitting_cobra_talent 21)
Define(stampede_talent 18)
Define(steady_focus_talent 10)
Define(steel_trap_talent 11)
Define(stomp_talent 16)
Define(streamline_talent 11)
Define(terms_of_engagement_talent 2)
Define(thrill_of_the_hunt_talent 11)
Define(tip_of_the_spear_talent 16)
Define(trailblazer_talent 7)
Define(venomous_bite_talent 10)
Define(vipers_venom_talent 1)
Define(volley_talent 5)
Define(wildfire_infusion_talent 20)

# Item set
Define(t20_2p_critical_aimed_damage_buff 242242) # TODO

# Non-default tags for OvaleSimulationCraft.
SpellInfo(dire_beast tag=main)
SpellInfo(dire_frenzy tag=main)
SpellInfo(barrage tag=shortcd)

]]
    OvaleScripts:RegisterScript("HUNTER", nil, name, desc, code, "include")
end
