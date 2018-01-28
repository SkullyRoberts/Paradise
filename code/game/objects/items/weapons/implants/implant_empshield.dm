/obj/item/weapon/implant/empshield
	name = "empshield implant"
	desc = "Weakens the effect of EMPs on your internal structues."
	origin_tech = "materials=5;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/mindshield/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen EMP Shielding Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device are significantly protected against electromagnetic pulses..<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanoworms that form a tesla cage around important internal electromics.<BR>
				<b>Special Features:</b> Will significantly decrease the damage done by EMPs.<BR>
				<b>Integrity:</b> Implant will last so until the nanoworms degrade.."}
	return dat


/obj/item/weapon/implant/empshield/implant(mob/target)
	if(..())
		to_chat(target, "<span class='notice'>Your feel millions of tiny metal worms burrowing through your body. This is one of the worst feelings you can imagine. Why are you doing this again?</span>")
	return 0

/obj/item/weapon/implant/empshield/removed(mob/target, var/silent = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			to_chat(target, "<span class='boldnotice'>You feel millions of tiny short shocks throughout your body as your nanoworms short out.</span>")
		return 1
	return 0


/obj/item/weapon/implanter/empshield
	name = "implanter (empshield)"

/obj/item/weapon/implanter/empshield/New()
	imp = new /obj/item/weapon/implant/empshield(src)
	..()
	update_icon()


/obj/item/weapon/implantcase/empshield
	name = "implant case - 'empshield'"
	desc = "A glass case containing a empshield implant."

/obj/item/weapon/implantcase/empshield/New()
	imp = new /obj/item/weapon/implant/empshield(src)
	..()