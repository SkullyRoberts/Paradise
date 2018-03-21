
#define NORTH_EDGING	"north"
#define SOUTH_EDGING	"south"
#define EAST_EDGING		"east"
#define WEST_EDGING		"west"

var/global/list/lrockTurfEdgeCache = list(
	NORTH_EDGING = image('icons/turf/lavamining.dmi', "rock_side_n", layer = 6),
	SOUTH_EDGING =  image('icons/turf/lavamining.dmi', "rock_side_s"),
	EAST_EDGING = image('icons/turf/lavamining.dmi', "rock_side_e", layer = 6),
	WEST_EDGING = image('icons/turf/lavamining.dmi', "rock_side_w", layer = 6))


/turf/simulated/lmineral //wall piece
	name = "Rocky Ash"
	icon = 'icons/turf/lavamining.dmi'
	icon_state = "rock_nochance"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = TCMB
	var/mineralType = null
	var/mineralAmt = 3
	var/mineralName = null
	var/spread = 0 //will the seam spread?
	var/spreadChance = 0 //the percentual chance of an ore spreading to the neighbouring tiles
	var/last_act = 0
	var/scan_state = null //Holder for the image we display when we're pinged by a mining scanner
	var/hidden = 1

	//start xenoarch vars
	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find
	//end xenaorch vars

/turf/simulated/lmineral/ex_act(severity, target)
	..()
	switch(severity)
		if(3.0)
			if(prob(75))
				src.gets_drilled(null, 1)
		if(2.0)
			if(prob(90))
				src.gets_drilled(null, 1)
		if(1.0)
			src.gets_drilled(null, 1)
	return

/turf/simulated/lmineral/New()
	..()
	mineral_turfs += src

	if(mineralType && mineralAmt && spread && spreadChance)
		for(var/dir in cardinal)
			if(prob(spreadChance))
				var/turf/T = get_step(src, dir)
				if(istype(T, /turf/simulated/mineral/random))
					LSpread(T)

	HideRock()

/turf/simulated/lmineral/proc/HideRock()
	if(hidden)
		name = "rock"
		icon_state = "rockyash"
	return

/turf/simulated/lmineral/proc/LSpread(var/turf/T)
	new src.type(T)

/hook/startup/proc/add_lmineral_edges()
	var/watch = start_watch()
	log_startup_progress("Reticulating splines...")
	for(var/turf/simulated/lmineral/M in mineral_turfs)
		M.add_edges()
	log_startup_progress(" Splines reticulated in [stop_watch(watch)]s.")
	return 1

/turf/simulated/lmineral/proc/add_edges()
	var/turf/T
	if((istype(get_step(src, NORTH), /turf/simulated/floor)) || (istype(get_step(src, NORTH), /turf/space)))
		T = get_step(src, NORTH)
		if(T)
			T.overlays += lrockTurfEdgeCache[SOUTH_EDGING]
	if((istype(get_step(src, SOUTH), /turf/simulated/floor)) || (istype(get_step(src, SOUTH), /turf/space)))
		T = get_step(src, SOUTH)
		if(T)
			T.overlays += lrockTurfEdgeCache[NORTH_EDGING]
	if((istype(get_step(src, EAST), /turf/simulated/floor)) || (istype(get_step(src, EAST), /turf/space)))
		T = get_step(src, EAST)
		if(T)
			T.overlays += lrockTurfEdgeCache[WEST_EDGING]
	if((istype(get_step(src, WEST), /turf/simulated/floor)) || (istype(get_step(src, WEST), /turf/space)))
		T = get_step(src, WEST)
		if(T)
			T.overlays += lrockTurfEdgeCache[EAST_EDGING]

/turf/simulated/lmineral/random
	name = "mineral deposit"
	icon_state = "rockyash"
	var/mineralSpawnChanceList = list(
		"Uranium" = 5, "Diamond" = 1, "Gold" = 10,
		"Silver" = 12, "Plasma" = 20, "Iron" = 40,
		"Gibtonite" = 4, "Cave" = 2, "BScrystal" = 1,
		"Titanium" = 11)
	var/mineralChance = 13

/turf/simulated/lmineral/random/New()
	..()
	if(prob(mineralChance))
		var/mName = pickweight(mineralSpawnChanceList) //temp mineral name

		if(mName)
			var/turf/simulated/lmineral/M
			switch(mName)
				if("Uranium")
					M = new/turf/simulated/lmineral/uranium(src)
				if("Iron")
					M = new/turf/simulated/lmineral/iron(src)
				if("Diamond")
					M = new/turf/simulated/lmineral/diamond(src)
				if("Gold")
					M = new/turf/simulated/lmineral/gold(src)
				if("Silver")
					M = new/turf/simulated/lmineral/silver(src)
				if("Plasma")
					M = new/turf/simulated/lmineral/plasma(src)
				if("Cave")
					new/turf/simulated/floor/plating/airless/lavaland/cave(src)
				if("Gibtonite")
					M = new/turf/simulated/lmineral/gibtonite(src)
				if("Bananium")
					M = new/turf/simulated/lmineral/clown(src)
				if("Tranquillite")
					M = new/turf/simulated/lmineral/mime(src)
				if("Titanium")
					M = new/turf/simulated/lmineral/titanium(src)
				if("BScrystal")
					M = new/turf/simulated/lmineral/bscrystal(src)
			if(M)
				M.mineralAmt = rand(1, 5)
				src = M
				M.levelupdate()
	return


/turf/simulated/lmineral/random/high_chance
	icon_state = "rock_highchance"
	mineralChance = 25
	mineralSpawnChanceList = list(
		"Uranium" = 35, "Diamond" = 30, "Gold" = 45,
		"Silver" = 50, "Plasma" = 50, "BScrystal" = 20,
		"Titanium" = 45)


/turf/simulated/lmineral/random/high_chance_clown
	mineralChance = 40
	mineralSpawnChanceList = list(
		"Uranium" = 35, "Diamond" = 2,
		"Gold" = 5, "Silver" = 5, "Plasma" = 25,
		"Iron" = 30, "Bananium" = 15, "Tranquillite" = 15, "BScrystal" = 10)

/turf/simulated/lmineral/random/high_chance/New()
	icon_state = "rock"
	..()

/turf/simulated/lmineral/random/low_chance
	icon_state = "rock_lowchance"
	mineralChance = 6
	mineralSpawnChanceList = list(
		"Uranium" = 2, "Diamond" = 1, "Gold" = 4,
		"Silver" = 6, "Plasma" = 15, "Iron" = 40,
		"Gibtonite" = 2, "BScrystal" = 1, "Titanium" = 4)

/turf/simulated/lmineral/random/low_chance/New()
	icon_state = "rock"
	..()

/turf/simulated/lmineral/iron
	name = "iron deposit"
	icon_state = "rock_Iron"
	mineralType = /obj/item/weapon/ore/iron
	mineralName = "Iron"
	spreadChance = 20
	spread = 1
	hidden = 0

/turf/simulated/lmineral/uranium
	name = "uranium deposit"
	mineralType = /obj/item/weapon/ore/uranium
	mineralName = "Uranium"
	spreadChance = 5
	spread = 1
	hidden = 1
	scan_state = "rock_Uranium"

/turf/simulated/lmineral/diamond
	name = "diamond deposit"
	mineralType = /obj/item/weapon/ore/diamond
	mineralName = "Diamond"
	spreadChance = 0
	spread = 1
	hidden = 1
	scan_state = "rock_Diamond"

/turf/simulated/lmineral/gold
	name = "gold deposit"
	mineralType = /obj/item/weapon/ore/gold
	mineralName = "Gold"
	spreadChance = 5
	spread = 1
	hidden = 1
	scan_state = "rock_Gold"

/turf/simulated/lmineral/silver
	name = "silver deposit"
	mineralType = /obj/item/weapon/ore/silver
	mineralName = "Silver"
	spreadChance = 5
	spread = 1
	hidden = 1
	scan_state = "rock_Silver"

/turf/simulated/lmineral/titanium
	name = "titanium deposit"
	mineralType = /obj/item/weapon/ore/titanium
	spreadChance = 5
	spread = 1
	hidden = 1
	scan_state = "rock_Titanium"

/turf/simulated/lmineral/plasma
	name = "plasma deposit"
	icon_state = "rock_Plasma"
	mineralType = /obj/item/weapon/ore/plasma
	mineralName = "Plasma"
	spreadChance = 8
	spread = 1
	hidden = 1
	scan_state = "rock_Plasma"

/turf/simulated/lmineral/clown
	name = "bananium deposit"
	icon_state = "rock_Clown"
	mineralType = /obj/item/weapon/ore/bananium
	mineralName = "Bananium"
	mineralAmt = 3
	spreadChance = 0
	spread = 0
	hidden = 0

/turf/simulated/lmineral/mime
	name = "tranquillite deposit"
	icon_state = "rock_Mime"
	mineralType = /obj/item/weapon/ore/tranquillite
	mineralAmt = 3
	spreadChance = 0
	spread = 0
	hidden = 0

/turf/simulated/lmineral/bscrystal
	name = "bluespace crystal deposit"
	icon_state = "rock_BScrystal"
	mineralType = /obj/item/weapon/ore/bluespace_crystal
	mineralName = "Bluespace crystal"
	mineralAmt = 1
	spreadChance = 0
	spread = 0
	hidden = 1
	scan_state = "rock_BScrystal"

////////////////////////////////Gibtonite
/turf/simulated/lmineral/gibtonite
	name = "gibtonite deposit"
	icon_state = "rock_Gibtonite"
	mineralAmt = 1
	mineralName = "Gibtonite"
	spreadChance = 0
	spread = 0
	hidden = 1
	scan_state = "rock_Gibtonite"
	var/det_time = 8 //Countdown till explosion, but also rewards the player for how close you were to detonation when you defuse it
	var/stage = 0 //How far into the lifecycle of gibtonite we are, 0 is untouched, 1 is active and attempting to detonate, 2 is benign and ready for extraction
	var/activated_ckey = null //These are to track who triggered the gibtonite deposit for logging purposes
	var/activated_name = null

/turf/simulated/lmineral/gibtonite/New()
	det_time = rand(8,10) //So you don't know exactly when the hot potato will explode
	..()

/turf/simulated/lmineral/gibtonite/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/mining_scanner) || istype(I, /obj/item/device/t_scanner/adv_mining_scanner) && stage == 1)
		user.visible_message("<span class='notice'>You use [I] to locate where to cut off the chain reaction and attempt to stop it...</span>")
		defuse()
	..()

/turf/simulated/lmineral/gibtonite/proc/explosive_reaction(var/mob/user = null, triggered_by_explosion = 0)
	if(stage == 0)
		icon_state = "rock_Gibtonite_active"
		name = "gibtonite deposit"
		desc = "An active gibtonite reserve. Run!"
		stage = 1
		visible_message("<span class='danger'>There was gibtonite inside! It's going to explode!</span>")
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)

		var/notify_admins = 0
		if(z != 5)
			notify_admins = 1
			if(!triggered_by_explosion)
				message_admins("[key_name_admin(user)] has triggered a gibtonite deposit reaction at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
			else
				message_admins("An explosion has triggered a gibtonite deposit reaction at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")

		if(!triggered_by_explosion)
			log_game("[key_name(user)] has triggered a gibtonite deposit reaction at [A.name] ([A.x], [A.y], [A.z]).")
		else
			log_game("An explosion has triggered a gibtonite deposit reaction at [A.name]([bombturf.x],[bombturf.y],[bombturf.z])")

		countdown(notify_admins)

/turf/simulated/lmineral/gibtonite/proc/countdown(notify_admins = 0)
	spawn(0)
		while(stage == 1 && det_time > 0 && mineralAmt >= 1)
			det_time--
			sleep(5)
		if(stage == 1 && det_time <= 0 && mineralAmt >= 1)
			var/turf/bombturf = get_turf(src)
			mineralAmt = 0
			explosion(bombturf,1,3,5, adminlog = notify_admins)
		if(stage == 0 || stage == 2)
			return

/turf/simulated/lmineral/gibtonite/proc/defuse()
	if(stage == 1)
		icon_state = "rock_Gibtonite_inactive"
		desc = "An inactive gibtonite reserve. The ore can be extracted."
		stage = 2
		if(det_time < 0)
			det_time = 0
		visible_message("<span class='notice'>The chain reaction was stopped! The gibtonite had [src.det_time] reactions left till the explosion!</span>")

/turf/simulated/lmineral/gibtonite/gets_drilled(var/mob/user, triggered_by_explosion = 0)
	if(stage == 0 && mineralAmt >= 1) //Gibtonite deposit is activated
		playsound(src,'sound/effects/hit_on_shattered_glass.ogg',50,1)
		explosive_reaction(user, triggered_by_explosion)
		return
	if(stage == 1 && mineralAmt >= 1) //Gibtonite deposit goes kaboom
		var/turf/bombturf = get_turf(src)
		mineralAmt = 0
		explosion(bombturf,1,2,5, adminlog = 0)
	if(stage == 2) //Gibtonite deposit is now benign and extractable. Depending on how close you were to it blowing up before defusing, you get better quality ore.
		var/obj/item/weapon/twohanded/required/gibtonite/G = new /obj/item/weapon/twohanded/required/gibtonite/(src)
		if(det_time <= 0)
			G.quality = 3
			G.icon_state = "Gibtonite ore 3"
		if(det_time >= 1 && det_time <= 2)
			G.quality = 2
			G.icon_state = "Gibtonite ore 2"
	var/turf/simulated/floor/plating/airless/asteroid/gibtonite_remains/G = ChangeTurf(/turf/simulated/floor/plating/airless/asteroid/gibtonite_remains)
	G.fullUpdateMineralOverlays()

/turf/simulated/floor/plating/airless/lavaland/gibtonite_remains
	var/ldet_time = 0
	var/lstage = 0

////////////////////////////////End Gibtonite

/turf/simulated/lmineral/attackby(var/obj/item/weapon/pickaxe/P as obj, mob/user as mob, params)

	if(!user.IsAdvancedToolUser())
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(istype(P, /obj/item/weapon/pickaxe))
		var/turf/T = user.loc
		if(!( istype(T, /turf) ))
			return

		if(last_act+P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time
		to_chat(user, "<span class='notice'>You start picking...</span>")
		P.playDigSound()

		if(do_after(user, P.digspeed, target = src))
			if(istype(src, /turf/simulated/lmineral)) //sanity check against turf being deleted during digspeed delay
				to_chat(user, "<span class='notice'>You finish cutting into the rock.</span>")
				P.update_icon()
				gets_drilled(user)
				feedback_add_details("pick_used_mining","[P.name]")
	else
		return attack_hand(user)
	return

/turf/simulated/lmineral/proc/gets_drilled()
	if(mineralType && (src.mineralAmt > 0) && (src.mineralAmt < 11))
		var/i
		for(i=0;i<mineralAmt;i++)
			new mineralType(src)
		feedback_add_details("ore_mined","[mineralType]|[mineralAmt]")
	var/turf/simulated/floor/plating/airless/lavaland/N = ChangeTurf(/turf/simulated/floor/plating/airless/lavaland)
	playsound(src, 'sound/effects/break_stone.ogg', 50, 1) //beautiful destruction
	N.fullUpdateMineralOverlays()

	if(rand(1,750) == 1)
		visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
		new /obj/structure/closet/crate/secure/loot(src)

	return

/turf/simulated/lmineral/attack_animal(mob/living/simple_animal/user as mob)
	if(user.environment_smash >= 2)
		gets_drilled()
	..()

/turf/simulated/lmineral/attack_alien(var/mob/living/carbon/alien/M)
	to_chat(M, "<span class='notice'>You start digging into the rock...</span>")
	playsound(src, 'sound/effects/break_stone.ogg', 50, 1)
	if(do_after(M, 40, target = src))
		to_chat(M, "<span class='notice'>You tunnel into the rock.</span>")
		gets_drilled()

/turf/simulated/lmineral/Bumped(AM as mob|obj)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
			attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
			attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/pickaxe))
			attackby(R.module_active,R)

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/drill))
			M.selected.action(src)


/**********************Asteroid**************************/

/turf/simulated/floor/plating/airless/lavaland
	name = "Ash Floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt0"
	icon_plating = "basalt0"
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

/turf/simulated/floor/plating/airless/lavaland/New()
	var/proper_name = name
	..()
	name = proper_name
	if(prob(20))
		icon_state = "basalt[rand(0,12)]"

/turf/simulated/floor/plating/airless/lavaland/ex_act(severity, target)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if(prob(20))
				src.gets_dug()
		if(1.0)
			src.gets_dug()
	return

/turf/simulated/floor/plating/airless/lavaland/attackby(obj/item/weapon/W, mob/user, params)
	//note that this proc does not call ..()
	if(!W || !user)
		return 0

	if((istype(W, /obj/item/weapon/shovel)))
		var/turf/T = get_turf(user)
		if(!istype(T))
			return

		if(dug)
			to_chat(user, "<span class='warning'>This area has already been dug!</span>")
			return

		to_chat(user, "<span class='notice'>You start digging...</span>")
		if(do_after(user, 20 * W.toolspeed, target = src))
			to_chat(user, "<span class='notice'>You dig a hole.</span>")
			gets_dug()
			return

	if((istype(W, /obj/item/weapon/pickaxe)))
		var/obj/item/weapon/pickaxe/P = W
		var/turf/T = get_turf(user)
		if(!istype(T))
			return

		if(dug)
			to_chat(user, "<span class='warning'>This area has already been dug!</span>")
			return

		to_chat(user, "<span class='notice'>You start digging...</span>")

		if(do_after(user, P.digspeed, target = src))
			to_chat(user, "<span class='notice'>You dig a hole.</span>")
			gets_dug()
			return

	if(istype(W,/obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		if(S.collection_mode == 1)
			for(var/obj/item/weapon/ore/O in src.contents)
				O.attackby(W,user)
				return

/turf/simulated/floor/plating/airless/lavaland/gets_drilled()
	if(!dug)
		gets_dug()
	else
		..()

/turf/simulated/floor/plating/airless/lavaland/proc/gets_dug()
	if(dug)
		return
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	dug = 1
	playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1) //FUCK YO RUSTLE I GOT'S THE DIGS SOUND HERE
	icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"
	return

/turf/proc/updatelMineralOverlays()
	src.overlays.Cut()

	if(istype(get_step(src, NORTH), /turf/simulated/lmineral))
		src.overlays += lrockTurfEdgeCache[NORTH_EDGING]
	if(istype(get_step(src, SOUTH), /turf/simulated/lmineral))
		src.overlays += lrockTurfEdgeCache[SOUTH_EDGING]
	if(istype(get_step(src, EAST), /turf/simulated/lmineral))
		src.overlays += lrockTurfEdgeCache[EAST_EDGING]
	if(istype(get_step(src, WEST), /turf/simulated/lmineral))
		src.overlays += lrockTurfEdgeCache[WEST_EDGING]

/turf/simulated/lmineral/updateMineralOverlays()
	return

/turf/simulated/wall/updateMineralOverlays()
	return

/turf/proc/fullUpdatelMineralOverlays()
	for(var/turf/t in range(1,src))
		t.updateMineralOverlays()

/turf/simulated/floor/plating/airless/lavaland/cave
	var/length = 100
	var/mob_spawn_list = list("Goldgrub" = 1, "Goliath" = 5, "Basilisk" = 4, "Hivelord" = 3, "Carp" = 5, "Mega Carp" = 1)
	var/sanity = 1

/turf/simulated/floor/plating/airless/lavaland/cave/New(loc, var/length, var/go_backwards = 1, var/exclude_dir = -1)

	// If length (arg2) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(!length)
		src.length = rand(25, 50)
	else
		src.length = length

	// Get our directiosn
	var/forward_cave_dir = pick(alldirs - exclude_dir)
	// Get the opposite direction of our facing direction
	var/backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

	// Make our tunnels
	make_tunnel(forward_cave_dir)
	if(go_backwards)
		make_tunnel(backward_cave_dir)
	// Kill ourselves by replacing ourselves with a normal floor.
	SpawnFloor(src)
	..()

/turf/simulated/floor/plating/airless/lavaland/cave/proc/make_tunnel(var/dir)

	var/turf/simulated/lmineral/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(IsOdd(dir2angle(dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/simulated/lmineral/edge = get_step(tunnel, angle2dir(dir2angle(dir) + edge_angle))
			if(istype(edge))
				SpawnFloor(edge)

		// Move our tunnel forward
		tunnel = get_step(tunnel, dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				new src.type(tunnel, rand(10, 15), 0, dir)
			else
				SpawnFloor(tunnel)
		else //if(!istype(tunnel, src.parent)) // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			dir = angle2dir(dir2angle(dir) + next_angle)

/turf/simulated/floor/plating/airless/lavaland/cave/proc/SpawnFloor(var/turf/T)
	for(var/turf/S in range(2,T))
		if(istype(S, /turf/space) || istype(S.loc, /area/mine/dangerous/explored))
			sanity = 0
			break
	if(!sanity)
		return

	SpawnMonster(T)
	var/turf/simulated/floor/t = new /turf/simulated/floor/plating/airless/lavaland(T)
	spawn(2)
		t.fullUpdateMineralOverlays()

/turf/simulated/floor/plating/airless/lavaland/cave/proc/SpawnMonster(var/turf/T)
	if(prob(30))
		if(istype(loc, /area/mine/dangerous/explored))
			return
		for(var/atom/A in range(15,T))//Lowers chance of mob clumps
			if(istype(A, /mob/living/simple_animal/hostile/asteroid))
				return
		var/randumb = pickweight(mob_spawn_list)
		switch(randumb)
			if("Goliath")
				new /mob/living/simple_animal/hostile/asteroid/goliath(T)
			if("Goldgrub")
				new /mob/living/simple_animal/hostile/asteroid/goldgrub(T)
			if("Basilisk")
				new /mob/living/simple_animal/hostile/asteroid/basilisk(T)
			if("Hivelord")
				new /mob/living/simple_animal/hostile/asteroid/hivelord(T)
			if("Carp")
				new /mob/living/simple_animal/hostile/retaliate/carp(T)
			if("Mega Carp")
				new /mob/living/simple_animal/hostile/carp/megacarp(T)
	return

#undef NORTH_EDGING
#undef SOUTH_EDGING
#undef EAST_EDGING
#undef WEST_EDGING