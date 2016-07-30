local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_paladin_spells"
	local desc = "[7.0] Ovale: Paladin spells"
	local code = [[
# Paladin spells and functions.

# Learned spells.
Define(judgments_of_the_wise 105424)
	SpellInfo(judgments_of_the_wise learn=1 level=28 specialization=protection)
Define(sanctity_of_battle 25956)
	SpellInfo(sanctity_of_battle learn=1 level=58)

Define(ardent_defender 31850)
	SpellInfo(ardent_defender cd=180 gcd=0 offgcd=1)
	SpellInfo(ardent_defender addcd=-60 itemset=T14_tank itemcount=2)
	SpellInfo(ardent_defender buff_cdr=cooldown_reduction_tank_buff)
	SpellAddBuff(ardent_defender ardent_defender_buff=1)
Define(ardent_defender_buff 31850)
	SpellInfo(ardent_defender_buff duration=10)
Define(avengers_reprieve_buff 185676)
	SpellInfo(avengers_reprieve_buff duration=10)
Define(avengers_shield 31935)
	SpellInfo(avengers_shield holy=0 cd=15 travel_time=1)
	SpellInfo(avengers_shield holy=-1 if_spell=grand_crusader)
	SpellInfo(avengers_shield cd_haste=melee if_spell=sanctity_of_battle)
	SpellRequire(avengers_shield holy -3=buff,holy_avenger_buff if_spell=grand_crusader if_spell=holy_avenger)
	SpellAddBuff(avengers_shield avengers_reprieve_buff=1 itemset=T18 itemcount=2 specialization=protection)
	SpellAddBuff(avengers_shield grand_crusader_buff=0 if_spell=grand_crusader)
	SpellAddBuff(avengers_shield faith_barricade_buff=1 itemset=T17 itemcount=2 specialization=protection)
Define(avenging_wrath_heal 31842)
	SpellInfo(avenging_wrath_heal cd=180 gcd=0)
	SpellInfo(avenging_wrath_heal addcd=-60 itemset=T16_heal itemcount=4)
Define(avenging_wrath_melee 31884)
	SpellInfo(avenging_wrath_melee cd=120 gcd=0)
	SpellInfo(avenging_wrath_melee addcd=-65 itemset=T14_melee itemcount=4)
	SpellInfo(avenging_wrath_melee buff_cdr=cooldown_reduction_strength_buff)
	SpellAddBuff(avenging_wrath_melee avenging_wrath_melee_buff=1)
Define(avenging_wrath_melee_buff 31884)
	SpellInfo(avenging_wrath_melee_buff duration=20)
	SpellInfo(avenging_wrath_melee_buff addduration=10 if_spell=sanctified_wrath)
Define(bastion_of_glory_buff 114637)
	SpellInfo(bastion_of_glory_buff duration=20 max_stacks=5)
Define(bastion_of_power_buff 144569)
	SpellInfo(bastion_of_power_buff duration=20)
Define(beacon_of_light 53563)
	SpellInfo(beacon_of_light cd=3)
	SpellInfo(beacon_of_light gcd=0 glyph=glyph_of_beacon_of_light offgcd=1)
	SpellAddTargetBuff(beacon_of_light beacon_of_light_buff=1)
Define(beacon_of_light_buff 53563)
Define(blade_of_justice 184575)
	SpellInfo(blade_of_justice holy=-2 cd=10.5)
Define(blade_of_wrath 202270)
	SpellInfo(blade_of_wrath cd=7.5 holy=-2)
	SpellAddBuff(blade_of_wrath blade_of_wrath_buff=1)
Define(blade_of_wrath_buff 202270)
	SpellInfo(blade_of_wrath_buff duration=6)
Define(blazing_contempt_buff 166831)
	SpellInfo(blazing_contempt_buff duration=20)
Define(blessing_of_kings 20217)
	SpellAddBuff(blessing_of_kings blessing_of_kings_buff=1)
Define(blessing_of_kings_buff 20217)
	SpellInfo(blessing_of_kings_buff duration=3600)
Define(blessing_of_might 19740)
	SpellAddBuff(blessing_of_might blessing_of_might_buff=1)
Define(blinding_light 115750)
	SpellInfo(blinding_light cd=120 interrupt=1)
Define(cleanse 4987)
	SpellInfo(cleanse cd=8)
	SpellInfo(cleanse addcd=4 glyph=glyph_of_cleanse)
Define(consecration 26573)
	SpellInfo(consecration cd=9)
	SpellInfo(consecration cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(consecration replace=consecration_glyph_of_consecration unusable=1 glyph=glyph_of_consecration)
	SpellInfo(consecration replace=consecration_glyph_of_the_consecrator unusable=1 glyph=glyph_of_the_consecrator)
Define(consecration_debuff 81298)
	SpellInfo(consecration_debuff duration=9 tick=1)
	SpellInfo(consecration_debuff haste=melee if_spell=sanctity_of_battle)
Define(consecration_glyph_of_consecration 116467)
	SpellInfo(consecration_glyph_of_consecration cd=9)
	SpellInfo(consecration_glyph_of_consecration cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(consecration_glyph_of_consecration unusable=1 glyph=!glyph_of_consecration)
Define(consecration_glyph_of_the_consecrator 159556)
	SpellInfo(consecration_glyph_of_the_consecrator cd=9)
	SpellInfo(consecration_glyph_of_the_consecrator cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(consecration_glyph_of_the_consecrator unusable=1 glyph=!glyph_of_the_consecrator)
Define(crusade 224668)
	SpellInfo(crusade cd=120)
	SpellAddBuff(crusade crusade_buff=1)
Define(crusade_buff 224668)
	SpellInfo(crusade_buff duration=20 max_stacks=15)
Define(crusade_talent 20)
Define(crusader_strike 35395)
	SpellInfo(crusader_strike holy=-1 cd=4.5)
	SpellInfo(crusader_strike cd_haste=melee if_spell=sanctity_of_battle)
	SpellRequire(crusader_strike holy -3=buff,holy_avenger_buff if_spell=holy_avenger)
	SpellInfo(crusader_strike cd=3.5 talent=the_fires_of_justice_talent)
Define(crusaders_fury_buff 165442)
	SpellInfo(crusaders_fury_buff duration=10)
Define(defender_of_the_light_buff 167742)
	SpellInfo(defender_of_the_light_buff duration=8)
Define(divine_crusader_buff 144595)
	SpellInfo(divine_crusader_buff duration=12)
Define(divine_hammer 198034)
	SpellInfo(divine_hammer cd=12 holy=-2)
Define(divine_protection 498)
	SpellInfo(divine_protection cd=60 gcd=0 offgcd=1)
	SpellInfo(divine_protection cd=30 if_spell=unbreakable_spirit)
	SpellInfo(divine_protection buff_cdr=cooldown_reduction_strength_buff specialization=retribution)
	SpellInfo(divine_protection buff_cdr=cooldown_reduction_tank_buff specialization=protection)
	SpellAddBuff(divine_protection divine_protection_buff=1)
Define(divine_protection_buff 498)
	SpellInfo(divine_protection_buff duration=8)
Define(divine_purpose 86172)
Define(divine_purpose_buff 90174)
	SpellInfo(divine_purpose_buff duration=8)
Define(divine_shield 642)
	SpellInfo(divine_shield cd=300 gcd=0 offgcd=1)
	SpellInfo(divine_shield cd=150 if_spell=unbreakable_spirit)
	SpellInfo(divine_shield buff_cdr=cooldown_reduction_strength_buff specialization=retribution)
	SpellInfo(divine_shield buff_cdr=cooldown_reduction_tank_buff specialization=protection)
	SpellAddBuff(divine_shield divine_shield_buff=1)
Define(divine_shield_buff 642)
	SpellInfo(divine_shield_buff duration=8)
Define(divine_storm 53385)
	SpellInfo(divine_storm holy=3)
	SpellRequire(divine_storm holy 0=buff,divine_storm_no_holy_buff)
	SpellRequire(divine_storm holy 2=buff,the_fires_of_justice_buff)
	SpellAddBuff(divine_storm divine_crusader_buff=0)
	SpellAddBuff(divine_storm divine_purpose_buff=0 if_spell=divine_purpose)
	SpellAddBuff(divine_storm final_verdict_buff=0 if_spell=final_verdict)
SpellList(divine_storm_no_holy_buff divine_crusader_buff divine_purpose_buff)
Define(empowered_divine_storm 174718)
Define(empowered_hammer_of_wrath 157496)
Define(empowered_seals 152263)
Define(empowered_seals_talent 19)
Define(enhanced_hand_of_sacrifice 6940)
Define(enhanced_holy_shock 157478)
Define(enhanced_holy_shock_buff 160002)
	SpellInfo(enhanced_holy_shock_buff duration=15)
Define(eternal_flame 114163)
	SpellInfo(eternal_flame cd=1 holy=finisher max_holy=3)
	SpellInfo(eternal_flame gcd=0 offgcd=1)
	SpellRequire(eternal_flame holy 0=buff,word_of_glory_no_holy_buff)
	SpellAddBuff(eternal_flame bastion_of_glory_buff=0 if_spell=shield_of_the_righteous)
	SpellAddBuff(eternal_flame bastion_of_power_buff=0 if_spell=shield_of_the_righteous itemset=T16_tank itemcount=4)
	SpellAddBuff(eternal_flame divine_purpose_buff=0 if_spell=divine_purpose)
	SpellAddBuff(eternal_flame lawful_words_buff=0 itemset=T17 itemcount=4 specialization=holy)
	SpellAddTargetBuff(eternal_flame eternal_flame_buff=1)
Define(eternal_flame_buff 114163)
	SpellInfo(eternal_flame_buff duration=30 haste=spell tick=3)
Define(execution_sentence 213757)
	SpellInfo(execution_sentence cd=20 holy=3)
	SpellRequire(execution_sentence holy 2=buff,the_fires_of_justice_buff)
Define(exorcism 879)
	SpellInfo(exorcism holy=-1 cd=15)
	SpellInfo(exorcism cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(exorcism replace=exorcism_glyphed unusable=1 glyph=glyph_of_mass_exorcism)
	SpellRequire(exorcism holy -3=buff,exorcism_holy_generator_buff)
	SpellAddBuff(exorcism blazing_contempt_buff=0 itemset=T17 itemcount=4 specialization=retribution)
Define(exorcism_glyphed 122032)
	SpellInfo(exorcism_glyphed holy=-1 cd=15)
	SpellInfo(exorcism_glyphed cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(exorcism_glyphed unusable=1 glyph=!glyph_of_mass_exorcism)
	SpellRequire(exorcism_glyphed holy -3=buff,exorcism_holy_generator_buff)
	SpellAddBuff(exorcism_glyphed blazing_contempt_buff=0 itemset=T17 itemcount=4 specialization=retribution)
SpellList(exorcism_holy_generator_buff blazing_contempt_buff holy_avenger_buff)
Define(faith_barricade_buff 165447)
	SpellInfo(faith_barricade_buff duration=5)
Define(final_verdict 157048)
	SpellInfo(final_verdict holy=3)
	SpellRequire(final_verdict holy 0=buff,divine_purpose_buff if_spell=divine_purpose)
	SpellAddBuff(final_verdict divine_purpose_buff=0 if_spell=divine_purpose)
	SpellAddBuff(final_verdict final_verdict_buff=1)
Define(final_verdict_buff 157048)
	SpellInfo(final_verdict_buff duration=30)
Define(fist_of_justice 198054)
Define(final_verdict_talent 21)
Define(flash_of_light 19750)
	SpellAddBuff(flash_of_light selfless_healer_buff=0 if_spell=selfless_healer)
Define(forbearance_debuff 25771)
	SpellInfo(forbearance_debuff duration=60)
	SpellInfo(forbearance_debuff addduration=-30 if_spell=improved_forbearance)
Define(glyph_of_beacon_of_light 63218)
Define(glyph_of_cleanse 171929)
Define(glyph_of_consecration 54928)
Define(glyph_of_divinity 54939)
Define(glyph_of_double_jeopardy 54922)
Define(glyph_of_double_jeopardy_buff 121027)
Define(glyph_of_final_wrath 54935)
Define(glyph_of_focused_shield 54930)
Define(glyph_of_harsh_words 54938)
Define(glyph_of_rebuke 54925)
Define(glyph_of_mass_exorcism 122028)
Define(glyph_of_the_consecrator 159557)
Define(grand_crusader 85043)
Define(grand_crusader_buff 85416)
	SpellInfo(grand_crusader_buff duration=6)
Define(guardian_of_ancient_kings 86659)
	SpellInfo(guardian_of_ancient_kings cd=180 gcd=0 offgcd=1)
	SpellInfo(guardian_of_ancient_kings buff_cdr=cooldown_reduction_tank_buff)
	SpellAddBuff(guardian_of_ancient_kings guardian_of_ancient_kings_buff=1)
Define(guardian_of_ancient_kings_buff 86659)
	SpellInfo(guardian_of_ancient_kings_buff duration=8)
Define(hammer_of_justice 853)
	SpellInfo(hammer_of_justice cd=60 interrupt=1)
Define(hammer_of_the_righteous 53595)
	SpellInfo(hammer_of_the_righteous holy=-1 cd=4.5)
	SpellInfo(hammer_of_the_righteous cd_haste=melee if_spell=sanctity_of_battle)
	SpellRequire(hammer_of_the_righteous holy -3=buff,holy_avenger_buff if_spell=holy_avenger)
Define(hammer_of_wrath 24275)
	SpellInfo(hammer_of_wrath cd=6 target_health_pct=20)
	SpellInfo(hammer_of_wrath holy=-1 specialization=retribution)
	SpellInfo(hammer_of_wrath cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(hammer_of_wrath replace=hammer_of_wrath_empowered unusable=1 if_spell=empowered_hammer_of_wrath)
	SpellRequire(hammer_of_wrath cd 3=buff,avenging_wrath_melee_buff if_spell=sanctified_wrath)
	SpellRequire(hammer_of_wrath holy -3=buff,holy_avenger_buff if_spell=holy_avenger specialization=retribution)
	SpellRequire(hammer_of_wrath target_health_pct 100=buff,hammer_of_wrath_no_target_health_pct_buff specialization=retribution)
	SpellAddBuff(hammer_of_wrath crusaders_fury_buff=0 itemset=T17 itemcount=2 specialization=retribution)
Define(hammer_of_wrath_empowered 158392)
	SpellInfo(hammer_of_wrath_empowered cd=6 target_health_pct=35)
	SpellInfo(hammer_of_wrath_empowered holy=-1 specialization=retribution)
	SpellInfo(hammer_of_wrath_empowered cd_haste=melee if_spell=sanctity_of_battle)
	SpellRequire(hammer_of_wrath_empowered cd 3=buff,avenging_wrath_melee_buff if_spell=sanctified_wrath)
	SpellRequire(hammer_of_wrath_empowered holy -3=buff,holy_avenger_buff if_spell=holy_avenger specialization=retribution)
	SpellRequire(hammer_of_wrath_empowered target_health_pct 100=buff,hammer_of_wrath_no_target_health_pct_buff specialization=retribution)
	SpellAddBuff(hammer_of_wrath_empowered crusaders_fury_buff=0 itemset=T17 itemcount=2 specialization=retribution)
SpellList(hammer_of_wrath_no_target_health_pct_buff avenging_wrath_melee_buff crusaders_fury_buff)
Define(hand_of_freedom 1044)
	SpellInfo(hand_of_freedom cd=25)
	SpellInfo(hand_of_freedom buff_cdr=cooldown_reduction_strength_buff specialization=retribution)
Define(hand_of_protection 1022)
	SpellInfo(hand_of_protection cd=300 gcd=0 offgcd=1)
	SpellInfo(hand_of_protection cd=150 if_spell=unbreakable_spirit)
	SpellInfo(hand_of_protection buff_cdr=cooldown_reduction_strength_buff specialization=retribution)
	SpellInfo(hand_of_protection buff_cdr=cooldown_reduction_tank_buff specialization=protection)
	SpellAddBuff(hand_of_protection hand_of_protection_buff=1)
Define(hand_of_protection_buff 1022)
	SpellInfo(hand_of_protection_buff duration=10)
Define(hand_of_sacrifice 6940)
	SpellInfo(hand_of_sacrifice cd=120 gcd=0 offgcd=1)
	SpellInfo(hand_of_sacrifice addcd=-30 if_spell=enhanced_hand_of_sacrifice)
	SpellAddTargetBuff(hand_of_sacrifice hand_of_sacrifice_buff=1)
Define(hand_of_sacrifice_buff 6940)
	SpellInfo(hand_of_sacrifice_buff duration=10)
Define(harsh_word 136494)
Define(holy_avenger 105809)
	SpellInfo(holy_avenger cd=120 gcd=0)
Define(holy_avenger_buff 105809)
	SpellInfo(holy_avenger_buff duration=18)
Define(holy_light 82326)
Define(holy_prism 114165)
	SpellInfo(holy_prism cd=20)
Define(holy_shock 20473)
	SpellInfo(holy_shock cd=6 holy=-1)
	SpellInfo(holy_shock cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(holy_shock addcd=-1 itemset=T14_heal itemcount=4)
	SpellRequire(holy_shock cd 0=buff,enhanced_holy_shock_buff if_spell=enhanced_holy_shock)
	SpellRequire(holy_shock cd 3=buff,avenging_wrath_melee_buff if_spell=sanctified_wrath)
	SpellRequire(holy_shock holy -3=buff,holy_avenger_buff if_spell=holy_avenger)
Define(holy_wrath 210220)
	SpellInfo(holy_wrath cd=180)
Define(improved_forbearance 157482)
Define(judgment 20271)
	SpellInfo(judgment cd=6)
	SpellInfo(judgment cd_haste=melee if_spell=sanctity_of_battle)
	SpellInfo(judgment holy=-1 if_spell=judgments_of_the_wise)
	SpellInfo(judgment holy=-1 specialization=retribution)
	SpellRequire(judgment cd 3=buff,avenging_wrath_melee_buff if_spell=sanctified_wrath)
	SpellRequire(judgment holy -3=buff,holy_avenger_buff if_spell=holy_avenger)
	SpellAddBuff(judgment selfless_healer_buff=1 if_spell=selfless_healer)
Define(judgment_debuff 197277)
	SpellInfo(judgment_debuff duration=8)
Define(justicars_vengeance 215661)
	SpellInfo(justicars_vengeance holy=5)
	SpellRequire(justicars_vengeance holy 4=buff,the_fires_of_justice_buff)
Define(lawful_words_buff 166780)
	SpellInfo(lawful_words_buff duration=10)
Define(lay_on_hands 633)
	SpellInfo(lay_on_hands cd=600)
	SpellInfo(lay_on_hands cd=720 glyph=glyph_of_divinity)
	SpellInfo(lay_on_hands cd=300 if_spell=unbreakable_spirit)
	SpellInfo(lay_on_hands cd=360 glyph=glyph_of_divinity if_spell=unbreakable_spirit)
	SpellRequire(lay_on_hands unusable 1=target_debuff,forbearance_debuff)
	SpellAddTargetDebuff(lay_on_hands forbearance_debuff=1)
Define(liadrins_righteousness_buff 156989)
	SpellInfo(liadrins_righteousness_buff duration=20)
Define(light_of_dawn 85222)
	SpellInfo(light_of_dawn holy=finisher max_holy=3)
	SpellRequire(light_of_dawn holy 0=buff,light_of_dawn_no_holy_buff)
SpellList(light_of_dawn_no_holy_buff divine_purpose_buff lights_favor_buff)
Define(lights_favor_buff 166781)
	SpellInfo(lights_favor_buff duration=10)
Define(lights_hammer 114158)
	SpellInfo(lights_hammer cd=60)
Define(lights_hammer_talent 17)
Define(maraads_truth_buff 156990)
	SpellInfo(maraads_truth_buff duration=20)
Define(rebuke 96231)
	SpellInfo(rebuke cd=15 gcd=0 interrupt=1 offgcd=1)
	SpellInfo(rebuke addcd=5 glyph=glyph_of_rebuke)
Define(redemption 7328)
Define(righteous_fury 25780)
	SpellAddBuff(righteous_fury righteous_fury_buff=toggle)
Define(righteous_fury_buff 25780)
Define(sacred_shield 20925)
	SpellInfo(sacred_shield cd=6)
	SpellAddBuff(sacred_shield sacred_shield_buff=1)
Define(sacred_shield_buff 20925)
	SpellInfo(sacred_shield duration=30 haste=spell tick=6)
Define(sanctified_wrath 53376)
Define(sanctified_wrath_tank 171648)
Define(sanctified_wrath_talent 14)
Define(selfless_healer 85804)
Define(selfless_healer_buff 114250)
	SpellInfo(selfless_healer_buff duration=15 max_stacks=3)
Define(selfless_healer_talent 7)
Define(seraphim 152262)
	SpellInfo(seraphim cd=30 gcd=0 holy=5)
Define(seraphim_buff 152262)
	SpellInfo(seraphim_buff duration=15)
Define(seraphim_talent 20)
Define(shield_of_the_righteous 53600)
	SpellInfo(shield_of_the_righteous cd=1.5 gcd=0 holy=3 offgcd=1)
	SpellInfo(shield_of_the_righteous cd_haste=melee haste=melee if_spell=sanctity_of_battle)
	SpellRequire(shield_of_the_righteous holy 0=buff,divine_purpose_buff if_spell=divine_purpose)
	SpellAddBuff(shield_of_the_righteous bastion_of_glory_buff=1 shield_of_the_righteous_buff=1)
	SpellAddBuff(shield_of_the_righteous divine_purpose_buff=0 if_spell=divine_purpose)
Define(shield_of_the_righteous_buff 132403)
	SpellInfo(shield_of_the_righteous_buff duration=3)
Define(speed_of_light 85499)
	SpellInfo(speed_of_light cd=45 gcd=0 offgcd=1)
Define(t18_class_trinket 124518)
Define(templars_verdict 85256)
	SpellInfo(templars_verdict holy=3)
	SpellRequire(templars_verdict holy 2=buff,the_fires_of_justice_buff talent=the_fires_of_justice_talent)
	SpellRequire(templars_verdict holy 0=buff,divine_purpose_buff if_spell=divine_purpose)
	SpellAddBuff(templars_verdict divine_purpose_buff=0 if_spell=divine_purpose)
Define(the_fires_of_justice_buff 209785)
	SpellInfo(the_fires_of_justice_buff duration=15)
Define(the_fires_of_justice_talent 4)
Define(unbreakable_spirit 114154)
Define(uthers_insight_buff 156988)
	SpellInfo(uthers_insight_buff duration=21 haste=spell tick=3)
Define(wake_of_ashes 205273)
	SpellInfo(wake_of_ashes cd=30)
Define(whisper_of_the_nathrezim 137020)
Define(whisper_of_the_nathrezim_buff 207633)
Define(wings_of_liberty_buff 185647)
	SpellInfo(wings_of_liberty_buff duration=10 max_stacks=10)
Define(word_of_glory 85673)
	SpellInfo(word_of_glory cd=1 holy=finisher max_holy=3)
	SpellInfo(word_of_glory gcd=0 offgcd=1)
	SpellRequire(word_of_glory holy 0=buff,word_of_glory_no_holy_buff)
	SpellAddBuff(word_of_glory bastion_of_glory_buff=0 if_spell=shield_of_the_righteous)
	SpellAddBuff(word_of_glory bastion_of_power_buff=0 if_spell=shield_of_the_righteous itemset=T16_tank itemcount=4)
	SpellAddBuff(word_of_glory divine_purpose_buff=0 if_spell=divine_purpose)
	SpellAddBuff(word_of_glory lawful_words_buff=0 itemset=T17 itemcount=4 specialization=holy)
Define(word_of_glory_glyph_of_harsh_words 136494)
	SpellInfo(word_of_glory_glyph_of_harsh_words cd=1 holy=finisher max_holy=3)
	SpellInfo(word_of_glory_glyph_of_harsh_words gcd=0 offgcd=1)
	SpellInfo(word_of_glory_glyph_of_harsh_words unusable=1 glyph=!glyph_of_harsh_words)
	SpellRequire(word_of_glory_glyph_of_harsh_words holy 0=buff,word_of_glory_no_holy_buff)
	SpellAddBuff(word_of_glory_glyph_of_harsh_words bastion_of_glory_buff=0 if_spell=shield_of_the_righteous)
	SpellAddBuff(word_of_glory_glyph_of_harsh_words bastion_of_power_buff=0 if_spell=shield_of_the_righteous itemset=T16_tank itemcount=4)
	SpellAddBuff(word_of_glory_glyph_of_harsh_words divine_purpose_buff=0 if_spell=divine_purpose)
	SpellAddBuff(word_of_glory_glyph_of_harsh_words lawful_words_buff=0 itemset=T17 itemcount=4 specialization=holy)
SpellList(word_of_glory_no_holy_buff bastion_of_power_buff divine_purpose_buff lawful_words_buff)
Define(zeal 217020)
	SpellInfo(zeal cd=4.5 holy=-1)

# Non-default tags for OvaleSimulationCraft.
	SpellInfo(consecration tag=shortcd)
	SpellInfo(divine_protection tag=cd)
	SpellInfo(eternal_flame tag=shortcd)
	SpellInfo(harsh_word tag=shortcd)
]]

	OvaleScripts:RegisterScript("PALADIN", nil, name, desc, code, "include")
end
