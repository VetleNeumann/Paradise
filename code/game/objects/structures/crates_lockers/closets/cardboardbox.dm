/obj/structure/closet/cardboard
	name = "large cardboard box"
	desc = "Just a box..."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "cardboard"
	icon_opened = "cardboard_open"
	icon_closed = "cardboard"
	health = 10
	burn_state = FLAMMABLE
	burntime = 20
	sound = 'sound/effects/rustle2.ogg'
	material_drop = /obj/item/stack/sheet/cardboard
	cutting_sound = 'sound/items/poster_ripped.ogg'
	var/move_delay = 0
	var/egged = 0

/obj/structure/closet/cardboard/relaymove(mob/user, direction)
	if(opened || move_delay || user.stat || user.stunned || user.weakened || user.paralysis || !isturf(loc) || !has_gravity(loc))
		return
	move_delay = 1
	if(step(src, direction))
		spawn(config.walk_speed)
			move_delay = 0
	else
		move_delay = 0

/obj/structure/closet/cardboard/open()
	if(opened || !can_open())
		return 0
	if(!egged)
		var/mob/living/Snake = null
		for(var/mob/living/L in src.contents)
			Snake = L
			break
		if(Snake)
			var/list/alerted = viewers(7,src)
			if(alerted)
				for(var/mob/living/L in alerted)
					if(!L.stat)
						L.do_alert_animation(L)
						egged = 1
				alerted << sound('sound/machines/chime.ogg')
	..()

/mob/living/proc/do_alert_animation(atom/A)
	var/image/I
	I = image('icons/obj/boxes.dmi', A, "cardboard_special", A.layer+1)
	var/list/viewing = list()
	for(var/mob/M in viewers(A))
		if(M.client)
			viewing |= M.client
	flick_overlay(I,viewing,8)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)


/obj/structure/closet/cardboard/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(src.opened)
		if(istype(W, /obj/item/weapon/weldingtool))
			return
		if(istype(W, /obj/item/weapon/wirecutters))
			var/obj/item/weapon/wirecutters/WC = W
			new /obj/item/stack/sheet/cardboard(src.loc)
			for(var/mob/M in viewers(src))
				M.show_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WC].</span>", 3, "You hear cutting.", 2)
			qdel(src)
			return
		if(istype(W, /obj/item/weapon/storage/fancy/crayons))
			var/list/contents = W.contents
			var/crayoncount = 0
			for(var/C in contents)
				if(istype(C, /obj/item/toy/crayon))
					crayoncount += 1
				continue
			if(crayoncount == 6)
				var/decalselection = input("Please select a decal") as null|anything in list("Atmospherics", "Bartender", "Barber", "Blueshield",	"Brig Physician", "Captain",
					"Cargo", "Chief Engineer",	"Chaplain",	"Chef", "Chemist", "Civilian", "Clown", "CMO", "Coroner", "Detective", "Engineering", "Genetics", "HOP",
					"HOS", "Hydroponics", "Internal Affairs Agent", "Janitor",	"Magistrate", "Mechanic", "Medical", "Mime", "Mining", "NT Representative", "Paramedic", "Pod Pilot",
					"Prisoner",	"Research Director", "Security", "Syndicate", "Therapist", "Virology", "Warden", "Xenobiology")
				if(!decalselection)
					return
				if(user.incapacitated())
					return
				if(W == user.get_active_hand() && Adjacent(usr))
					contents = W.contents
					crayoncount = 0
					for(var/C in contents)
						if(istype(C, /obj/item/toy/crayon))
							crayoncount += 1
				 		continue
					if(crayoncount == 6)
						decalselection = replacetext(decalselection, " ", "_")
						decalselection = lowertext(decalselection)
						icon_opened = ("cardboard_open_"+decalselection)
						icon_closed = ("cardboard_"+decalselection)
						update_icon() // a proc declared in the closets parent file used to update opened/closed sprites on normal closets
						qdel(W)
