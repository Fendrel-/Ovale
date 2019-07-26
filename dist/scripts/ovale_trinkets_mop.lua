local __exports = LibStub:NewLibrary("ovale/scripts/ovale_trinkets_mop", 80201)
if not __exports then return end
__exports.registerMopTrinkets = function(OvaleScripts)
    local name = "ovale_trinkets_mop"
    local desc = "[6.0.3] Ovale: Trinkets (Mists of Pandaria)"
    local code = [[
# Trinkets from Mists of Pandaria.

###
### Agility
###

Define(agile_buff 126554)
	SpellInfo(agile_buff buff_cd=55 duration=20 stat=agility)
Define(blessing_of_the_celestials_agility_buff 128984)
	SpellInfo(blessing_of_the_celestials_agility_buff buff_cd=55 duration=15 stat=agility)
Define(call_of_conquest_buff 126690)
	SpellInfo(call_of_conquest_buff buff_cd=60 duration=20 stat=agility)
Define(dextrous_buff 146308)
	SpellInfo(dextrous_buff buff_cd=115 duration=20 stat=agility)
Define(ferocity_buff 148896)
	SpellInfo(ferocity_buff buff_cd=85 duration=15 stat=agility)
Define(juju_madeness_buff 138938)
	SpellInfo(juju_madeness_buff buff_cd=55 duration=10 stat=agility)
Define(restless_agility_buff 146310)
	SpellInfo(restless_agility_buff buff_cd=60 duration=10 stat=agility)
Define(superluminal_buff 138699)
	SpellInfo(superluminal_buff buff_cd=115 duration=20 stat=agility)
Define(surge_of_conquest_buff 126707)
	SpellInfo(surge_of_conquest_buff buff_cd=55 duration=20 stat=agility)
Define(vicious_buff 148903)
	SpellInfo(vicious_buff buff_cd=65 duration=10 stat=agility)

Define(assurance_of_consequence 112947)
	ItemInfo(assurance_of_consequence buff=dextrous_buff)
ItemList(bad_juju bad_juju_heroic bad_juju_heroic_thunderforged bad_juju_normal bad_juju_raid_finder bad_juju_thunderforged)
Define(bad_juju_heroic 96409)
	ItemInfo(bad_juju_heroic buff=juju_madness_buff)
Define(bad_juju_heroic_thunderforged 96781)
	ItemInfo(bad_juju_heroic_thunderforged buff=juju_madness_buff)
Define(bad_juju_normal 94523)
	ItemInfo(bad_juju_normal buff=juju_madness_buff)
Define(bad_juju_raid_finder 95665)
	ItemInfo(bad_juju_raid_finder buff=juju_madness_buff)
Define(bad_juju_thunderforged 96037)
	ItemInfo(bad_juju_thunderforged buff=juju_madness_buff)
Define(blades_of_renataki_buff 138756)
	SpellInfo(blades_of_renataki_buff buff_cd=50 max_stacks=10)
ItemList(bottle_of_infinite_stars bottle_of_infinite_stars_heroic bottle_of_infinite_stars_normal bottle_of_infinite_stars_raid_finder)
Define(bottle_of_infinite_stars_heroic 86132)
	ItemInfo(bottle_of_infinite_stars_heroic buff=agile_buff)
Define(bottle_of_infinite_stars_normal 87057)
	ItemInfo(bottle_of_infinite_stars_normal buff=agile_buff)
Define(bottle_of_infinite_stars_raid_finder 86791)
	ItemInfo(bottle_of_infinite_stars_raid_finder buff=agile_buff)
ItemList(grievous_gladiators_badge_of_conquest grievous_gladiators_badge_of_conquest_alliance grievous_gladiators_badge_of_conquest_horde)
Define(grievous_gladiators_badge_of_conquest_alliance 103145)
	ItemInfo(grievous_gladiators_badge_of_conquest_alliance buff=call_of_conquest_buff)
Define(grievous_gladiators_badge_of_conquest_horde 102856)
	ItemInfo(grievous_gladiators_badge_of_conquest_horde buff=call_of_conquest_buff)
ItemList(grievous_gladiators_insignia_of_conquest grievous_gladiators_insignia_of_conquest_alliance grievous_gladiators_insignia_of_conquest_horde)
Define(grievous_gladiators_insignia_of_conquest_alliance 103150)
	ItemInfo(grievous_gladiators_insignia_of_conquest_alliance buff=surge_of_conquest_buff)
Define(grievous_gladiators_insignia_of_conquest_horde 102840)
	ItemInfo(grievous_gladiators_insignia_of_conquest_horde buff=surge_of_conquest_buff)
Define(haromms_talisman 112754)
	ItemInfo(haromms_talisman buff=vicious_buff)
ItemList(prideful_gladiators_badge_of_conquest prideful_gladiators_badge_of_conquest_alliance prideful_gladiators_badge_of_conquest_horde)
Define(prideful_gladiators_badge_of_conquest_alliance 102659)
	ItemInfo(prideful_gladiators_badge_of_conquest_alliance buff=call_of_conquest_buff)
Define(prideful_gladiators_badge_of_conquest_horde 103342)
	ItemInfo(prideful_gladiators_badge_of_conquest_horde buff=call_of_conquest_buff)
ItemList(prideful_gladiators_insignia_of_conquest prideful_gladiators_insignia_of_conquest_alliance prideful_gladiators_insignia_of_conquest_horde)
Define(prideful_gladiators_insignia_of_conquest_alliance 102643)
	ItemInfo(prideful_gladiators_insignia_of_conquest_alliance buff=surge_of_conquest_buff)
Define(prideful_gladiators_insignia_of_conquest_horde 103347)
	ItemInfo(prideful_gladiators_insignia_of_conquest_horde buff=surge_of_conquest_buff)
Define(relic_of_xuen_agility 79328)
	ItemInfo(relic_of_xuen buff=blessing_of_the_celestials_agility_buff)
ItemList(renatakis_soul_charm renatakis_soul_charm_heroic renatakis_soul_charm_heroic_thunderforged renatakis_soul_charm_normal renatakis_soul_charm_raid_finder renatakis_soul_charm_thunderforged)
Define(renatakis_soul_charm_heroic 96369)
	ItemInfo(renatakis_soul_charm_heroic buff=blades_of_renataki_buff)
Define(renatakis_soul_charm_heroic_thunderforged 96741)
	ItemInfo(renatakis_soul_charm_heroic_thunderforged buff=blades_of_renataki_buff)
Define(renatakis_soul_charm_normal 94512)
	ItemInfo(renatakis_soul_charm_normal buff=blades_of_renataki_buff)
Define(renatakis_soul_charm_raid_finder 95625)
	ItemInfo(renatakis_soul_charm_raid_finder buff=blades_of_renataki_buff)
Define(renatakis_soul_charm_thunderforged 95997)
	ItemInfo(renatakis_soul_charm_thunderforged buff=blades_of_renataki_buff)
Define(sigil_of_rampage 112825)
	ItemInfo(sigil_of_rampage buff=ferocity_buff)
Define(ticking_ebon_detonator 112879)
	ItemInfo(ticking_ebon_detonator buff=restless_agility_buff)
ItemList(tyrannical_gladiators_badge_of_conquest tyrannical_gladiators_badge_of_conquest_alliance tyrannical_gladiators_badge_of_conquest_horde)
Define(tyrannical_gladiators_badge_of_conquest_alliance 99772)
	ItemInfo(tyrannical_gladiators_badge_of_conquest_alliance buff=call_of_conquest_buff)
Define(tyrannical_gladiators_badge_of_conquest_horde 100043)
	ItemInfo(tyrannical_gladiators_badge_of_conquest_horde buff=call_of_conquest_buff)
ItemList(tyrannical_gladiators_insignia_of_conquest tyrannical_gladiators_insignia_of_conquest_alliance tyrannical_gladiators_insignia_of_conquest_horde)
Define(tyrannical_gladiators_insignia_of_conquest_alliance 99777)
	ItemInfo(tyrannical_gladiators_insignia_of_conquest_alliance buff=surge_of_conquest_buff)
Define(tyrannical_gladiators_insignia_of_conquest_horde 100026)
	ItemInfo(tyrannical_gladiators_insignia_of_conquest_horde buff=surge_of_conquest_buff)
Define(vicious_talisman_of_the_shado_pan_assault 94511)
	ItemInfo(vicious_talisman_of_the_shado_pan_assault buff=superluminal_buff)

###
### Critical Strike
###

Define(cruelty_buff 146285)
	SpellInfo(cruelty_buff buff_cd=65 duration=10 max_stacks=20 stat=critical_strike)
Define(perfect_aim_buff 138963)
	SpellInfo(perfect_aim_buff buff_cd=110 duration=10 stat=critical_strike)
	SpellInfo(perfect_aim_buff buff_cd=165 specialization=balance)

Define(skeers_bloodsoaked_talisman 112913)
	ItemInfo(skeers_bloodsoaked_talisman buff=cruelty_buff)
ItemList(unerring_vision_of_lei_shen unerring_vision_of_lei_shen_heroic unerring_vision_of_lei_shen_heroic_thunderforged unerring_vision_of_lei_shen_normal unerring_vision_of_lei_shen_raid_finder unerring_vision_of_lei_shen_thunderforged)
Define(unerring_vision_of_lei_shen_heroic 96558)
	ItemInfo(unerring_vision_of_lei_shen_heroic buff=perfect_aim_buff)
Define(unerring_vision_of_lei_shen_heroic_thunderforged 96930)
	ItemInfo(unerring_vision_of_lei_shen_heroic_thunderforged buff=perfect_aim_buff)
Define(unerring_vision_of_lei_shen_normal 94524)
	ItemInfo(unerring_vision_of_lei_shen_normal buff=perfect_aim_buff)
Define(unerring_vision_of_lei_shen_raid_finder 95814)
	ItemInfo(unerring_vision_of_lei_shen_raid_finder buff=perfect_aim_buff)
Define(unerring_vision_of_lei_shen_thunderforged 96186)
	ItemInfo(unerring_vision_of_lei_shen_thunderforged buff=perfect_aim_buff)

###
### Intellect
###

Define(blessing_of_the_celestials_intellect_buff 128985)
	SpellInfo(blessing_of_the_celestials_intellect_buff buff_cd=55 duration=15 stat=intellect)
Define(breath_of_many_minds_buff 138898)
	SpellInfo(breath_of_many_minds_buff buff_cd=55 duration=10 stat=intellect)
Define(call_of_dominance_buff 126683)
	SpellInfo(call_of_dominance_buff buff_cd=60 duration=20 stat=intellect)
Define(expanded_mind_buff 146046)
	SpellInfo(expanded_mind_buff buff_cd=115 duration=20 stat=intellect)
Define(extravagant_visions_buff 148897)
	SpellInfo(extravagant_visions_buff buff_cd=85 duration=15 stat=intellect)
Define(inner_brilliance_buff 126577)
	SpellInfo(inner_brilliance_buff buff_cd=55 duration=20 stat=intellect)
Define(mastermind_buff 139133)
	SpellInfo(mastermind_buff buff_cd=55 duration=10 stat=intellect)
Define(static_charge_buff 136082)
	SpellInfo(static_charge_buff buff_cd=60 duration=15 stat=intellect)
Define(surge_of_dominance_buff 126705)
	SpellInfo(surge_of_dominance_buff buff_cd=55 duration=20 stat=intellect)
Define(toxic_power_buff 148906)
	SpellInfo(148906 buff_cd=65 duration=10 stat=intellect)
Define(wrath_of_the_darkspear_buff 146184)
	SpellInfo(wrath_of_the_darkspear_buff buff_cd=65 duration=10 max_stacks=10 stat=intellect)
Define(wushoolays_lightning_buff 138786)
	SpellInfo(wushoolays_lightning_buff buff_cd=50 duration=10 max_stacks=10 stat=intellect)

Define(black_blood_of_yshaarj 112938)
	ItemInfo(black_blood_of_yshaarj buff=wrath_of_the_darkspear_buff)
ItemList(breath_of_the_hydra breath_of_the_hydra_heroic breath_of_the_hydra_heroic_thunderforged breath_of_the_hydra_normal breath_of_the_hydra_raid_finder breath_of_the_hydra_thunderforged)
Define(breath_of_the_hydra_heroic 96455)
	ItemInfo(breath_of_the_hydra_heroic buff=breath_of_many_minds_buff)
Define(breath_of_the_hydra_heroic_thunderforged 96827)
	ItemInfo(breath_of_the_hydra_heroic_thunderforged buff=breath_of_many_minds_buff)
Define(breath_of_the_hydra_normal 94521)
	ItemInfo(breath_of_the_hydra_normal buff=breath_of_many_minds_buff)
Define(breath_of_the_hydra_raid_finder 95711)
	ItemInfo(breath_of_the_hydra_raid_finder buff=breath_of_many_minds_buff)
Define(breath_of_the_hydra_thunderforged 96083)
	ItemInfo(breath_of_the_hydra_thunderforged buff=breath_of_many_minds_buff)
ItemList(cha_yes_essence_of_brilliance cha_yes_essence_of_brilliance_heroic cha_yes_essence_of_brilliance_heroic_thunderforged cha_yes_essence_of_brilliance_normal cha_yes_essence_of_brilliance_raid_finder cha_yes_essence_of_brilliance_thunderforged)
Define(cha_yes_essence_of_brilliance_heroic 96516)
	ItemInfo(cha_yes_essence_of_brilliance_heroic buff=mastermind_buff)
Define(cha_yes_essence_of_brilliance_heroic_thunderforged 96888)
	ItemInfo(cha_yes_essence_of_brilliance_heroic_thunderforged buff=mastermind_buff)
Define(cha_yes_essence_of_brilliance_normal 94531)
	ItemInfo(cha_yes_essence_of_brilliance_normal buff=mastermind_buff)
Define(cha_yes_essence_of_brilliance_raid_finder 95772)
	ItemInfo(cha_yes_essence_of_brilliance_raid_finder buff=mastermind_buff)
Define(cha_yes_essence_of_brilliance_thunderforged 96144)
	ItemInfo(cha_yes_essence_of_brilliance_thunderforged buff=mastermind_buff)
Define(frenzied_crystal_of_rage 112815)
	ItemInfo(frenzied_crystal_of_rage buff=extravagant_visions_buff)
ItemList(grievous_gladiators_badge_of_dominance grievous_gladiators_badge_of_dominance_alliance grievous_gladiators_badge_of_dominance_horde)
Define(grievous_gladiators_badge_of_dominance_alliance 103308)
	ItemInfo(grievous_gladiators_badge_of_dominance_alliance buff=call_of_dominance_buff)
Define(grievous_gladiators_badge_of_dominance_horde 102830)
	ItemInfo(grievous_gladiators_badge_of_dominance_horde buff=call_of_dominance_buff)
ItemList(grievous_gladiators_insignia_of_dominance grievous_gladiators_insignia_of_dominance_alliance grievous_gladiators_insignia_of_dominance_horde)
Define(grievous_gladiators_insignia_of_dominance_alliance 103309)
	ItemInfo(grievous_gladiators_insignia_of_dominance_alliance buff=surge_of_dominance_buff)
Define(grievous_gladiators_insignia_of_dominance_horde 102963)
	ItemInfo(grievous_gladiators_insignia_of_dominance_horde buff=surge_of_dominance_buff)
Define(kardris_toxic_totem 112768)
	ItemInfo(kardris_toxic_totem buff=toxic_power_buff)
ItemList(light_of_the_cosmos light_of_the_cosmos_heroic light_of_the_cosmos_normal light_of_the_cosmos_raid_finder)
Define(light_of_the_cosmos_heroic 87065)
	ItemInfo(light_of_the_cosmos_heroic buff=inner_brilliance_buff)
Define(light_of_the_cosmos_normal 86133)
	ItemInfo(light_of_the_cosmos_normal buff=inner_brilliance_buff)
Define(light_of_the_cosmos_raid_finder 86792)
	ItemInfo(light_of_the_cosmos_raid_finder buff=inner_brilliance_buff)
ItemList(prideful_gladiators_badge_of_dominance prideful_gladiators_badge_of_dominance_alliance prideful_gladiators_badge_of_dominance_horde)
Define(prideful_gladiators_badge_of_dominance_alliance 102633)
	ItemInfo(prideful_gladiators_badge_of_dominance_alliance buff=call_of_dominance_buff)
Define(prideful_gladiators_badge_of_dominance_horde 103505)
	ItemInfo(prideful_gladiators_badge_of_dominance_horde buff=call_of_dominance_buff)
ItemList(prideful_gladiators_insignia_of_dominance prideful_gladiators_insignia_of_dominance_alliance prideful_gladiators_insignia_of_dominance_horde)
Define(prideful_gladiators_insignia_of_dominance_alliance 102766)
	ItemInfo(prideful_gladiators_insignia_of_dominance_alliance buff=surge_of_dominance_buff)
Define(prideful_gladiators_insignia_of_dominance_horde 103506)
	ItemInfo(prideful_gladiators_insignia_of_dominance_horde buff=surge_of_dominance_buff)
Define(purified_bindings_of_immerseus 112426)
	ItemInfo(purified_bindings_of_immerseus buff=expanded_mind_buff)
Define(relic_of_yulon 79331)
	ItemInfo(relic_of_yulon buff=blessing_of_the_celestials_intellect_buff)
Define(shock_charger_medallion 93259)
	ItemInfo(shock_charger_medallion buff=static_charge_buff)
Define(static_casters_medallion_horde 93254)
	ItemInfo(static_casters_medallion_horde buff=static_charge_buff)
ItemList(tyrannical_gladiators_badge_of_dominance tyrannical_gladiators_badge_of_dominance_alliance tyrannical_gladiators_badge_of_dominance_horde)
Define(tyrannical_gladiators_badge_of_dominance_alliance 99937)
	ItemInfo(tyrannical_gladiators_badge_of_dominance_alliance buff=call_of_dominance_buff)
Define(tyrannical_gladiators_badge_of_dominance_horde 100016)
	ItemInfo(tyrannical_gladiators_badge_of_dominance_horde buff=call_of_dominance_buff)
ItemList(tyrannical_gladiators_insignia_of_dominance tyrannical_gladiators_insignia_of_dominance_alliance tyrannical_gladiators_insignia_of_dominance_horde)
Define(tyrannical_gladiators_insignia_of_dominance_alliance 99938)
	ItemInfo(tyrannical_gladiators_insignia_of_dominance_alliance buff=surge_of_dominance_buff)
Define(tyrannical_gladiators_insignia_of_dominance_horde 100152)
	ItemInfo(tyrannical_gladiators_insignia_of_dominance_horde buff=surge_of_dominance_buff)
ItemList(wushoolays_final_choice wushoolays_final_choice_heroic wushoolays_final_choice_heroic_thunderforged wushoolays_final_choice_normal wushoolays_final_choice_raid_finder wushoolays_final_choice_thunderforged)
Define(wushoolays_final_choice_heroic 96413)
	ItemInfo(wushoolays_final_choice_heroic buff=wushoolays_lightning_buff)
Define(wushoolays_final_choice_heroic_thunderforged 96785)
	ItemInfo(wushoolays_final_choice_heroic_thunderforged buff=wushoolays_lightning_buff)
Define(wushoolays_final_choice_normal 94513)
	ItemInfo(wushoolays_final_choice_normal 94513 buff=wushoolays_lightning_buff)
Define(wushoolays_final_choice_raid_finder 95669)
	ItemInfo(wushoolays_final_choice_raid_finder buff=wushoolays_lightning_buff)
Define(wushoolays_final_choice_thunderforged 96041)
	ItemInfo(wushoolays_final_choice_thunderforged buff=wushoolays_lightning_buff)

###
### Strength
###

Define(blessing_of_the_celestials_strength_buff 128986)
	SpellInfo(blessing_of_the_celestials_strength_buff buff_cd=55 duration=15 stat=strength)
Define(call_of_victory_buff 126679)
	SpellInfo(call_of_victory_buff buff_cd=60 duration=20 stat=strength)
Define(determination_buff 146250)
	SpellInfo(determination_buff buff_cd=115 duration=20 stat=strength)
Define(feathers_of_fury_buff 138759)
	SpellInfo(feathers_of_fury_buff buff_cd=50 duration=10 max_stacks=10 stat=strength)
Define(outrage_buff 146245)
	SpellInfo(outrage_buff buff_cd=55 duration=10 stat=strength)
Define(rampage_buff 138870)
	SpellInfo(rampage_buff buff_cd=17 duration=10 max_stacks=5 stat=strength)
Define(surge_of_strength_buff 138702)
	SpellInfo(surge_of_strength_buff buff_cd=85 duration=15 stat=strength)
Define(surge_of_victory_buff 126700)
	SpellInfo(surge_of_victory_buff buff_cd=55 duration=20 stat=strength)
Define(tenacious_buff 148899)
	SpellInfo(tenacious_buff buff_cd=85 duration=15 stat=strength)
Define(unwavering_might_buff 126582)
	SpellInfo(unwavering_might_buff buff_cd=55 duration=20 stat=strength)

Define(brutal_talisman_of_the_shado_pan_assault 94508)
	ItemInfo(brutal_talisman_of_the_shado_pan_assault buff=surge_of_strength_buff)
Define(evil_eye_of_galakras 112703)
	ItemInfo(evil_eye_of_galakras buff=outrage_buff)
ItemList(fabled_feather_of_ji_kun fabled_feather_of_ji_kun_heroic fabled_feather_of_ji_kun_heroic_thunderforged fabled_feather_of_ji_kun_normal fabled_feather_of_ji_kun_raid_finder fabled_feather_of_ji_kun_thunderforged)
Define(fabled_feather_of_ji_kun_heroic 96470)
	ItemInfo(fabled_feather_of_ji_kun_heroic buff=feathers_of_fury_buff)
Define(fabled_feather_of_ji_kun_heroic_thunderforged 96842)
	ItemInfo(fabled_feather_of_ji_kun_heroic_thunderforged buff=feathers_of_fury_buff)
Define(fabled_feather_of_ji_kun_normal 94515)
	ItemInfo(fabled_feather_of_ji_kun_normal buff=feathers_of_fury_buff)
Define(fabled_feather_of_ji_kun_raid_finder 95726)
	ItemInfo(fabled_feather_of_ji_kun_raid_finder buff=feathers_of_fury_buff)
Define(fabled_feather_of_ji_kun_thunderforged 96098)
	ItemInfo(fabled_feather_of_ji_kun_thunderforged buff=feathers_of_fury_buff)
Define(fusion_fire_core 112503)
	ItemInfo(fusion_fire_core buff=tenacious_buff)
ItemList(grievous_gladiators_badge_of_victory grievous_gladiators_badge_of_victory_alliance grievous_gladiators_badge_of_victory_horde)
Define(grievous_gladiators_badge_of_victory_alliance 103314)
	ItemInfo(grievous_gladiators_badge_of_victory_alliance buff=call_of_victory_buff)
Define(grievous_gladiators_badge_of_victory_horde 102833)
	ItemInfo(grievous_gladiators_badge_of_victory_horde buff=call_of_victory_buff)
ItemList(grievous_gladiators_insignia_of_victory grievous_gladiators_insignia_of_victory_alliance grievous_gladiators_insignia_of_victory_horde)
Define(grievous_gladiators_insignia_of_victory_alliance 103319)
	ItemInfo(grievous_gladiators_insignia_of_victory_alliance buff=surge_of_victory_buff)
Define(grievous_gladiators_insignia_of_victory_horde 102896)
	ItemInfo(grievous_gladiators_insignia_of_victory_horde buff=surge_of_victory_buff)
ItemList(lei_shens_final_orders lei_shens_final_orders_heroic lei_shens_final_orders_normal lei_shens_final_orders_raid_finder)
Define(lei_shens_final_orders_heroic 87072)
	ItemInfo(lei_shens_final_orders_heroic buff=unwavering_might_buff)
Define(lei_shens_final_orders_normal 86144)
	ItemInfo(lei_shens_final_orders_normal buff=unwavering_might_buff)
Define(lei_shens_final_orders_raid_finder 86802)
	ItemInfo(lei_shens_final_orders_raid_finder buff=unwavering_might_buff)
ItemList(prideful_gladiators_badge_of_victory prideful_gladiators_badge_of_victory_alliance prideful_gladiators_badge_of_victory_horde)
Define(prideful_gladiators_badge_of_victory_alliance 102636)
	ItemInfo(prideful_gladiators_badge_of_victory_alliance buff=call_of_victory_buff)
Define(prideful_gladiators_badge_of_victory_horde 103511)
	ItemInfo(prideful_gladiators_badge_of_victory_horde buff=call_of_victory_buff)
ItemList(prideful_gladiators_insignia_of_victory prideful_gladiators_insignia_of_victory_alliance prideful_gladiators_insignia_of_victory_horde)
Define(prideful_gladiators_insignia_of_victory_alliance 102699)
	ItemInfo(prideful_gladiators_insignia_of_victory_alliance buff=surge_of_victory_buff)
Define(prideful_gladiators_insignia_of_victory_horde 103516)
	ItemInfo(prideful_gladiators_insignia_of_victory_horde buff=surge_of_victory_buff)
ItemList(primordius_talisman_of_rage primordius_talisman_of_rage_heroic primordius_talisman_of_rage_heroic_thunderforged primordius_talisman_of_rage_normal primordius_talisman_of_rage_raid_finder primordius_talisman_of_rage_thunderforged)
Define(primordius_talisman_of_rage_heroic 96501)
	ItemInfo(primordius_talisman_of_rage_heroic buff=rampage_buff)
Define(primordius_talisman_of_rage_heroic_thunderforged 96873)
	ItemInfo(primordius_talisman_of_rage_heroic_thunderforged buff=rampage_buff)
Define(primordius_talisman_of_rage_normal 94519)
	ItemInfo(primordius_talisman_of_rage_normal buff=rampage_buff)
Define(primordius_talisman_of_rage_raid_finder 95757)
	ItemInfo(primordius_talisman_of_rage_raid_finder buff=rampage_buff)
Define(primordius_talisman_of_rage_thunderforged 96129)
	ItemInfo(primordius_talisman_of_rage_thunderforged buff=rampage_buff)
Define(relic_of_xuen_strength 128989)
	ItemInfo(relic_of_xuen_strength buff=blessing_of_the_celestials_strength_buff)
Define(thoks_tail_tip 112850)
	ItemInfo(thoks_tail_tip buff=determination_buff)
ItemList(tyrannical_gladiators_badge_of_victory tyrannical_gladiators_badge_of_victory_alliance tyrannical_gladiators_badge_of_victory_horde)
Define(tyrannical_gladiators_badge_of_victory_alliance 99943)
	ItemInfo(tyrannical_gladiators_badge_of_victory_alliance buff=call_of_victory_buff)
Define(tyrannical_gladiators_badge_of_victory_horde 100019)
	ItemInfo(tyrannical_gladiators_badge_of_victory_horde buff=call_of_victory_buff)
ItemList(tyrannical_gladiators_insignia_of_victory tyrannical_gladiators_insignia_of_victory_alliance tyrannical_gladiators_insignia_of_victory_horde)
Define(tyrannical_gladiators_insignia_of_victory_alliance 99948)
	ItemInfo(tyrannical_gladiators_insignia_of_victory_alliance buff=surge_of_victory_buff)
Define(tyrannical_gladiators_insignia_of_victory_horde 100085)
	ItemInfo(tyrannical_gladiators_insignia_of_victory_horde buff=surge_of_victory_buff)
]]
    OvaleScripts:RegisterScript(nil, nil, name, desc, code, "include")
end
