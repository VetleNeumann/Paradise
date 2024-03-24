/obj/item/paper_stack
	name = "paper stack"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/max_amount = null
	var/list/papers = list()
	var/default_paper = null // for paperbins to spawn paper on the fly, instead of storing 50 unique paper items
	var/default_paper_amount = 0

/obj/item/paper_stack/proc/amount()
	return length(papers) + default_paper_amount

/obj/item/paper_stack/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return
	if(!ishuman(M))
		return

	if(over_object == M)
		if(!remove_item_from_storage(M))
			M.unEquip(src)
		M.put_in_hands(src)

	else if(is_screen_atom(over_object))
		switch(over_object.name)
			if("r_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_r_hand(src)
			if("l_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_l_hand(src)
	add_fingerprint(M)

/obj/item/paper_stack/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.bodyparts_by_name["r_hand"]
		if(H.hand)
			temp = H.bodyparts_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(H, "<span class='notice'>You try to move your [temp.name], but cannot!")
			return
	if(src.amount() >= 1)
		var/obj/item/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			P = new default_paper
			default_paper_amount--

		if(src.amount()==0)
			update_icon()

		// else
		// 	if(letterhead_type && alert("Choose a style", null,"Letterhead","Blank")=="Letterhead")
		// 		P = new letterhead_type
		// 	else
		// 		P = new /obj/item/paper

		P.loc = user.loc
		user.put_in_hands(P)
		P.add_fingerprint(user)
		P.pixel_x = rand(-9, 9) // Random position
		P.pixel_y = rand(-8, 8)
		to_chat(user, "<span class='notice'>You take [P] out of [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return

/obj/item/paper_stack/attackby(obj/item/paper/i as obj, mob/user as mob, params)
	if(istype(i))
		user.drop_item()
		i.loc = src
		to_chat(user, "<span class='notice'>You put [i] in [src].</span>")
		papers.Add(i)

		if(src.amount()==1)
			update_icon()
	else
		return ..()

/obj/item/paper_stack/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		var/paper_amount = src.amount()
		if(paper_amount)
			. += "<span class='notice'>There " + (paper_amount > 1 ? "are [paper_amount] papers" : "is one paper") + " in the bin.</span>"
		else
			. += "<span class='notice'>There are no papers in the bin.</span>"
