/datum/unit_test/paperbin/Run()
	return

/datum/unit_test/paperbin/inserting/Run()
	// setup
	var/loc = pick(block(run_loc_bottom_left, run_loc_top_right))
	var/mob/player = new /mob/living/carbon/human(loc)
	var/obj/item/paper_bin = new /obj/item/paper_stack/paper_bin(loc)

	// inserting
	var/obj/item/paper/some_paper = new /obj/item/paper(loc)
	some_paper.info = "test"
	some_paper.attack_hand(player)
	paper_bin.attackby(some_paper, player, "icon-x=16;icon-y=16")

	if(some_paper.loc != paper_bin)
		Fail("Couldn't put paper in paper_bin.")
	if(some_paper.info != "test")
		Fail("Didn't get same paper out, as last put in.")


/datum/unit_test/paperbin/empty/Run()
	// setup
	var/loc = pick(block(run_loc_bottom_left, run_loc_top_right))
	var/mob/player = new /mob/living/carbon/human(loc)
	var/obj/item/paper_stack/paper_bin = new /obj/item/paper_stack/paper_bin(loc)

	paper_bin.default_paper_amount = 1 // to make testing easier, only 1 paper in bin

	// withdrawing last paper should empty bin
	paper_bin.attack_hand(player)
	if (!istype(player.r_hand, /obj/item/paper))
		Fail("Couldn't retrieve paper while 1 left.")
	if (paper_bin.icon_state != "paper_bin0")
		Fail("paper_bin didn't update icon to show it's empty.")

	player.swap_hand()
	paper_bin.attack_hand(player)
	if (istype(player.l_hand, /obj/item/paper))
		Fail("Got paper, while paper bin should be empty.")

	// re-adding paper to empty bin should update icon again
	player.swap_hand()
	paper_bin.attackby(player.r_hand, player, "icon-x=16;icon-y=16")
	if (paper_bin.icon_state != "paper_bin1")
		Fail("paper_bin didn't update icon to show it's no longer empty.")
