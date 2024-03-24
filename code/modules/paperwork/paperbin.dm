/obj/item/paper_stack/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	pressure_resistance = 8
	default_paper = /obj/item/paper
	default_paper_amount = 20
	var/letterhead_type

/obj/item/paper_stack/paper_bin/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	if(src.amount() != 0)
		default_paper_amount = 0
		update_icon()
	..()

/obj/item/paper_stack/paper_bin/Destroy()
	QDEL_LIST_CONTENTS(papers)
	return ..()

/obj/item/paper_stack/paper_bin/burn()
	default_paper_amount = 0
	extinguish()
	update_icon()

/obj/item/paper_stack/paper_bin/update_icon_state()
	if(src.amount() < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"

// /obj/item/paper_bin/carbon
// 	name = "carbonless paper bin"
// 	icon_state = "paper_bin2"

// /obj/item/paper_bin/carbon/attack_hand(mob/user as mob)
// 	if(amount >= 1)
// 		amount--
// 		if(amount==0)
// 			update_icon()

// 		var/obj/item/paper/carbon/P
// 		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
// 			P = papers[papers.len]
// 			papers.Remove(P)
// 		else
// 			P = new /obj/item/paper/carbon
// 		P.loc = user.loc
// 		user.put_in_hands(P)
// 		to_chat(user, "<span class='notice'>You take [P] out of [src].</span>")
// 	else
// 		to_chat(user, "<span class='notice'>[src] is empty!</span>")

// 	add_fingerprint(user)
// 	return


/obj/item/paper_stack/paper_bin/nanotrasen
	name = "nanotrasen paper bin"
	letterhead_type = /obj/item/paper/nanotrasen

// /obj/item/paper_bin/syndicate
// 	name = "syndicate paper bin"
// 	letterhead_type = /obj/item/paper/syndicate

