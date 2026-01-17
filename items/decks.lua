SMODS.Atlas{
	key = 'zbsdeck',
	path = 'zbs_deck_atlas.png',
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = 'zbsdeckplaceholder',
	path = 'new_zbs_shmeck.png',
	px = 71,
	py = 95,
}

SMODS.Back({
	key = "zbsslotmachine",
	loc_txt = {
		name = "Casino",
		text={
		"Start with a",
		"{C:green,T:j_zbs_zbs7joker}Rigging The Slots",
		"but no {C:attention}7{}s",
		},
	},
	
	config = { hands = 0, discards = 0, consumeables = 'c_opentolan'},
	pos = { x = 0, y = 0 },
	order = 0,
	atlas = "zbsdeckplaceholder",
	unlocked = true,
	discovered = true,

	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
					local card = SMODS.add_card({ key = 'j_zbs_zbs7joker' })
					--card:set_edition({ eternal = true })
					
					for k, v in ipairs(G.deck.cards) do
						if v:get_id() == 7 then
							SMODS.destroy_cards(v)
						end
					end
					
					return true
				  end
			end,
		}))
	end,

	check_for_unlock = function(self, args)
		if args.type == "win_deck" then
			unlock_card(self)
		else
			unlock_card(self)
		end
	end,
})

SMODS.Back({
	key = "zbsmidas",
	loc_txt = {
		name = "Midas's Home",
		text={
			"Start with a {C:green,T:j_zbs_zbsmidasconscript}Midas Conscript{},",
			"a {C:green,T:j_midas_mask}Midas Mask{}, 2 copies of",
			"{C:attention,T:c_devil}The Devil{}, and 2 copies of {C:attention,T:c_talisman}Talisman{}",
			"Lose {C:money}$15{} at the end of each round",
		},
	},
	
	config = { hands = 0, discards = 0, moneyloss = 5},
	pos = { x = 0, y = 0 },
	order = 1,
	atlas = "zbsdeck",
	unlocked = true,
	discovered = true,
	
	loc_vars = function(self, info_queue, center)
		--info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsaspid
		return { vars = {  }  }
	end,
	
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
					local card = SMODS.add_card({ key = 'j_zbs_zbsmidasconscript' })
					SMODS.add_card({ key = 'j_midas_mask' })
					
					SMODS.add_card({ key = 'c_devil' })
					SMODS.add_card({ key = 'c_devil' })
					SMODS.add_card({ key = 'c_talisman' })
					SMODS.add_card({ key = 'c_talisman' })
					--card:set_edition({ eternal = true })
					
					return true
				  end
			end,
		}))
	end,
	
	calculate = function(self, card, context)
		-- This fires ONCE at end of round
		if context.end_of_round and context.main_eval and not context.blueprint then
			for i, t in pairs(context) do
				print(i,t)
			end
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					ease_dollars(-15)
					--play_sound("coin2")
					return true
				end
			}))
			
			return {
				message = "-$5",
                --dollars = -5,
				colour = G.C.MONEY
			}
		end
		if context.individual and context.cardarea == G.hand and context.other_card then
		print(context.individual,context.cardarea,context.cardarea == G.hand,context.other_card,context.end_of_round)
			local c = context.other_card
			
			if SMODS.has_enhancement(c, 'm_gold') then
				return {
					dollars = 3,
					card = c,
					colour = G.C.MONEY
					--message = "$" .. card.ability.extra.dollars
				}
			end
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == "win_deck" then
			unlock_card(self)
		else
			unlock_card(self)
		end
	end,
})

SMODS.Back({
	key = "zbsemo",
	loc_txt = {
		name = "Room full of Emos",
		text={
		"Start with #1# {C:attention,T:c_zbs_nega}Depressions",
		},
		unlock = {
			"Use a {C:attention}Depression{}",
			"at least once"
		}
	},
	
	config = { hands = 0, discards = 0, handsize = 1000, amount = 2},
	pos = { x = 0, y = 0 },
	order = 2,
	atlas = "zbsdeckplaceholder",
	unlocked = false,
	discovered = true,
	loc_vars = function(self, info_queue, center)
		return { vars = { self.config.amount}  }
	end,
	
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
					for i = 1, self.config.amount do
						--SMODS.add_card({ key = 'c_zbs_nega' })
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.05,  -- delay increases for each card
							func = function()
								--c:flip()
								--play_sound('tarot1')
								SMODS.add_card({ key = 'c_zbs_nega' })
								--SMODS.add_card({ key = 'j_zbs_zbsbob' })
								--play_sound("yahimod_mariopaintmeow")
								--card_eval_status_text(card,'extra',nil,nil,nil,{message = "$"..card.ability.extra.moneygiven})
								return true
							end
						}))
						--delay(1)
					end
					--SMODS.add_card({ key = 'c_zbs_nega' })
					
					return true
				  end
			end,
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == "win" or args.type == "loss" then
			if G.GAME.zbs and G.GAME.zbs.used_depression then
				unlock_card(self)
			end
		else
			if G.GAME.zbs and G.GAME.zbs.used_depression then
				unlock_card(self)
			end
		end
	end,
})

SMODS.Back({
	key = "debug",
	loc_txt = {
		name = "debug",
		text={
		"{C:green}debug",
		},
	},
	
	config = { hands = 0, discards = 0, consumeables = 'c_opentolan'},
	pos = { x = 0, y = 0 },
	order = 3,
	atlas = "zbsdeckplaceholder",
	unlocked = true,
	discovered = true,
	
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
					SMODS.add_card({ key = 'j_zbs_zbsexponential' })
					--delay(30)
					SMODS.add_card({ key = 'c_zbs_floppy_black' })
					SMODS.add_card({ key = 'c_zbs_floppy_red' })
					SMODS.add_card({ key = 'c_zbs_floppy_blue' })
					SMODS.add_card({ key = 'c_zbs_floppy_green' })
					if next(SMODS.find_mod("Yahimod")) then
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
						SMODS.add_card({ key = 'c_yahimod_opentolan' })
					end
					SMODS.add_card({ key = 'c_zbs_zipfile' })
					SMODS.add_card({ key = 'c_zbs_zipfile' })
					SMODS.add_card({ key = 'c_zbs_zipfile' })
					SMODS.add_card({ key = 'c_zbs_zipfile' })
					
					return true
				  end
			end,
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == "win_deck" then
			unlock_card(self)
		else
			unlock_card(self)
		end
	end,
})