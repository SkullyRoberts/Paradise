datum/species/simian
	name = "Simian"
	name_plural = "Simians"
	blurb = "Simians were developed accidentally by human experimentation in the late 2100s.\
	The species was thought to have been wiped out in the homo-simian wars, but small enclaves\
	survived in underground communities on Mars.<br/>\
	In apology for the genocide of their race, SolGov has declared Simians to have equal rights\
	as humans under the law, an extraordinarily unpopular move!"

	icobase = 'icons/mob/human_races/simian.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = "Chimpanzee"
	species_traits = list(LIPS, CAN_BE_FAT)
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	lesser_form = /datum/species/monkey/simian
	no_equip = list(slot_wear_suit)
	death_message = "lets out a faint chimper as it collapses and stops moving..."

	scream_verb = "screeches"
	male_scream_sound = 'sound/goonstation/voice/monkey_scream.ogg'
	female_scream_sound = 'sound/goonstation/voice/monkey_scream.ogg'

	tail = "chimptail"
	bodyflags = HAS_TAIL
	dietflags = DIET_OMNI
	reagent_tag = PROCESS_ORG
	//Has standard darksight of 2.

	unarmed_type = /datum/unarmed_attack/bite

	brute_mod = 1.5
	burn_mod = 1.5
	tox_mod = .6