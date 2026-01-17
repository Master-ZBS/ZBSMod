return {
	descriptions = {
		Joker = {
		},
		--ZBS_Extra_Info_Queues = {
		Other = {
            zbsmod_zany = {
                            name = "Zany Joker",
                            text = {
                                "{C:mult}+12{} Mult if played",
								"hand contains",
								"a {C:attention}Three of a Kind"
                            },
                        },
            zbsmod_artcredit = {
                            name = "Art by",
                            text = {
                                "{C:attention}#1#{}"
                            },
                        },
            zbsmod_catcredit = {
                            name = "Cat",
                            text = {
                                "{C:green}#1#{}'s cat!"
                            },
                        },
		}
	},
	misc = {

			-- do note that when using messages such as: 
			-- message = localize{type='variable',key='a_xmult',vars={current_xmult}},
			-- that the key 'a_xmult' will use provided values from vars={} in that order to replace #1#, #2# etc... in the localization file.


		dictionary = {
			a_chips="+#1#",
			a_chips_minus="-#1#",
			a_hands="+#1# Hands",
			a_handsize="+#1# Hand Size",
			a_handsize_minus="-#1# Hand Size",
			a_mult="+#1# Mult",
			a_mult_minus="-#1# Mult",
			a_remaining="#1# Remaining",
			a_sold_tally="#1#/#2# Sold",
			a_xmult="X#1# Mult",
			a_xmult_minus="-X#1# Mult",
			--zbs_tequila_pack = ":3",
			zbs_tequila_pack = "The FitnessGram™ Pacer Test is a multistage :3",
			zbs_office_pack = "Office Drawer",
		}
	}
}