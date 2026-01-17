
-- you can have shared helper functions
function shakecard(self) --visually shake a card
	G.E_MANAGER:add_event(Event({
		func = function()
			self:juice_up(0.5, 0.5)
			return true
		end
	}))
end

function return_JokerValues() -- not used, just here to demonstrate how you could return values from a joker
	if context.joker_main and context.cardarea == G.jokers then
		return {
			chips = card.ability.extra.chips,	   -- these are the 3 possible scoring effects any joker can return.
			mult = card.ability.extra.mult,		 -- adds mult (+)
			x_mult = card.ability.extra.x_mult,	 -- multiplies existing mult (*)
			card = self,							-- under which card to show the message
			colour = G.C.CHIPS,					 -- colour of the message, Balatro has some predefined colours, (Balatro/globals.lua)
			message = localize('k_upgrade_ex'),	 -- this is the message that will be shown under the card when it triggers.
			extra = { focus = self, message = localize('k_upgrade_ex') }, -- another way to show messages, not sure what's the difference.
		}
	end
end

-- test
SMODS.Atlas{
	key = 'zbstest',
	path = 'j_sample_baroness.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbstest',
	loc_txt= {
		name = 'Test',
		text = { "Gains{C:blue} +#3#{} Chips and{C:red} +#4#{} Mult",
					"every round",
					"{C:inactive}(Currently {C:blue}+#1# {C:inactive}Chips and {C:red}+#2# {C:inactive}Mult)",}
	},
	atlas = 'zbstest',
	rarity = 2,
	cost = 6,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,

	pos = {x=0, y= 0},
	config = { extra = {chips = 0, mult = 0, additionalchips = 3, additionalmult = 1}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.chips, center.ability.extra.mult, center.ability.extra.additionalchips, center.ability.extra.additionalmult }  }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				--message = "+".. card.ability.extra.chips.. " Chips & +".. card.ability.extra.mult.. " Mult",
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult
			}
		end
		if context.setting_blind then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.additionalchips
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.additionalmult
			return {
				--message = "Upgrade!",
				message = localize('k_upgrade_ex'),
			}
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- quinn
SMODS.Atlas{
	key = 'zbsquinn',
	path = 'new_zbs_quinnatlas.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "deafen", path = "deafen.ogg",})
SMODS.Sound({key = "undeafen", path = "undeafen.ogg",})
SMODS.Sound({key = "discordleave", path = "discordleave.ogg",})

SMODS.Joker{
	key = 'zbsquinn',
	loc_txt= {
		name = 'QuinnOfGilead',
		text = { "Gives{C:red} +#1#{} Mult but",
					"randomly goes deafened",
					"{C:red}#5#{}{C:green}#6#{}",}
	},
	atlas = 'zbsquinn',
	rarity = 2,
	cost = 8,
	pools = {["QuinnOfGilead"] = true, ["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {mult = 10}, chance = 8, timetillundeafen = 0, deafentext = "", undeafentext = "Undeafened", leavechance = 10},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, G.GAME.probabilities.normal, center.ability.chance, center.ability.timetillundeafen, center.ability.deafentext, center.ability.undeafentext, center.ability.leavechance }  }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.timetillundeafen <= 0 then
				return {
					mult = card.ability.extra.mult
				}
			else
				return {
					message = "You are currently muted!",
					sound = "cancel"
				}
			end
		end
		if context.setting_blind then
			if pseudorandom('quinn') < (G.GAME.probabilities.normal / card.ability.leavechance) and card.ability.timetillundeafen > 0 then
				card:start_dissolve()
				return {
					message = "goodbye",
					sound = "zbs_discordleave"
				}
			end
			if pseudorandom('quinn') < (G.GAME.probabilities.normal / card.ability.chance) and card.ability.timetillundeafen <= -1 then
				card.ability.timetillundeafen = math.ceil(pseudorandom('quinn') * 4)
				card.ability.deafentext = "Deafened until ".. card.ability.timetillundeafen.. " rounds later"
				card.ability.undeafentext = ""
				card.children.center:set_sprite_pos({x = 1, y = 0})
				return {
					message = "Deafened",
					sound = "zbs_deafen"
				}
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			if card.ability.timetillundeafen > 0 then
				card.ability.timetillundeafen = card.ability.timetillundeafen - 1
				card.ability.deafentext = "Deafened until ".. card.ability.timetillundeafen.. " rounds later"
				if card.ability.timetillundeafen <= 0 then
					card.ability.undeafentext = "Undeafened"
					card.ability.deafentext = ""
					card.children.center:set_sprite_pos({x = 0, y = 0})
					return {
						message = "Undeafened!",
						sound = "zbs_undeafen"
					}
				end
			else
				card.ability.timetillundeafen = card.ability.timetillundeafen - 1
			end
		end
		if card.ability.timetillundeafen > 0 then
			card.children.center:set_sprite_pos({x = 1, y = 0})
		else
			card.children.center:set_sprite_pos({x = 0, y = 0})
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- jool
SMODS.Atlas{
	key = 'zbsjool',
	path = 'new_zbs_jool.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "quinnchan", path = "quinnchan.ogg",})
SMODS.Sound({key = "joolfuckingdies", path = "joolfuckingdies.ogg",})

SMODS.Joker{
	key = 'zbsjool',
	loc_txt= {
		name = 'Jool',
		text = { "Gives{C:red} +#1#{} Mult for each",
					"{C:attention}QuinnOfGilead{} in",
					"Joker tray",
					"{C:inactive}(Currently{C:red} +#2#{C:inactive} Mult)",}
	},
	atlas = 'zbsjool',
	rarity = 2,
	cost = 4,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {mult = 4, multtotal = 0}},

	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsquinn
		return { vars = { center.ability.extra.mult, center.ability.extra.multtotal }  }
	end,

	calculate = function(self, card, context)
		quinncount = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.QuinnOfGilead and G.jokers.cards[i].ability.timetillundeafen <= 0 then
				quinncount = quinncount + 1
			end
		end
		card.ability.extra.multtotal = quinncount * card.ability.extra.mult
		if context.joker_main then
			if card.ability.extra.multtotal > 0 then
				return {
					--message = "+".. card.ability.extra.multtotal.. " Mult",
					mult = card.ability.extra.multtotal,
					message = "QUINN CHAN",
					sound = "zbs_quinnchan"
				}
			else
				return {
					message = "@QuinnOfGilead QUINN CHAN WHERE ARE YOU",
					sound = "zbs_quinnchan"
				}
			end
		end
		if context.selling_self then
			play_sound("zbs_joolfuckingdies")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- awakenx
SMODS.Atlas{
	key = 'zbsawakenx',
	path = 'zbs_awakenx.png',
	px = 568,
	py = 760,
}

SMODS.Sound({key = "benchips", path = "benchips.ogg",})
SMODS.Sound({key = "benmult", path = "benmult.ogg",})
SMODS.Sound({key = "benLIMBUSCOMPANY", path = "benLIMBUSCOMPANY.ogg",})
SMODS.Sound({key = "benfuckingdies", path = "benfuckingdies.ogg",})

SMODS.Joker{
	key = 'zbsawakenx',
	loc_txt= {
		name = 'Classic AwakenX',
		text = { "Amount of jokers * {C:green}#3# in #4#{}",
					"to give {C:blue}+#1#{} Chips",
					"when a {C:attention}9{} is played and",
					"{C:red} #2#{} Mult when an {C:attention}7{}",
					"is played",
					"{C:inactive}(Currently {C:green}#5# in #4# {C:inactive}chance)"}
	},
	atlas = 'zbsawakenx',
	rarity = 1,
	cost = 6,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {chips = 20, mult = -20}, chance = 10, jokerchance = 1},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.chips, center.ability.extra.mult, G.GAME.probabilities.normal, center.ability.chance, center.ability.jokerchance }  }
	end,

	calculate = function(self, card, context)
		card.ability.jokerchance = #G.jokers.cards * G.GAME.probabilities.normal
		if context.cardarea == G.play and context.individual and context.other_card then
			if context.other_card:get_id() == 9 then
				if pseudorandom('limbuscompany') < (G.GAME.probabilities.normal * #G.jokers.cards / card.ability.chance) then
					return {
						message = "+".. card.ability.extra.chips.. " Chips",
						chip_mod = card.ability.extra.chips,
						sound = "zbs_benchips"
					}
				end
			end
			if context.other_card:get_id() == 7 then
				if pseudorandom('limbuscompany') < (G.GAME.probabilities.normal * #G.jokers.cards / card.ability.chance) then
					return {
						message = card.ability.extra.mult.. " Mult",
						mult_mod = card.ability.extra.mult,
						sound = "zbs_benmult"
					}
				end
			end
		end
		if context.setting_blind then
			return {
				message = "LIMBUS COMPANY!",
				sound = "zbs_benLIMBUSCOMPANY"
			}
		end
		if context.selling_self then
			play_sound("zbs_benfuckingdies")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- yike9151
SMODS.Atlas{
	key = 'zbsyike9151',
	path = 'new_zbs_coopietroopie.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsyike9151',
	loc_txt= {
		name = 'Yike9151',
		text = { "Each {C:attention}9{}, {C:attention}Ace{}, {C:attention}5{}, and {C:attention}Ace{}",
		"each give {C:red}+#1#{} mult",
		"{C:inactive}(yes {C:attention}Aces{C:inactive} are done twice)"}
	},
	atlas = 'zbsyike9151',
	rarity = 1,
	cost = 3,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {mult = 2, multace = 4}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.multace }  }
	end,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card then
			if context.other_card:get_id() == 9 or context.other_card:get_id() == 5 then
				return {
					mult = card.ability.extra.mult
				}
			end
			if context.other_card:get_id() == 14 then
				return {
					mult = card.ability.extra.multace
				}
			end
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- bob
SMODS.Atlas{
	key = 'zbsbob',
	path = 'zbs_bob.png',
	px = 568,
	py = 760,
}

SMODS.Sound({key = "meow", path = "meow.ogg",})
SMODS.Sound({key = "chomp", path = "chomp-1.ogg",})

SMODS.Joker{
	key = 'zbsbob',
	loc_txt= {
		name = 'Bob',
		text = { "Jake's pussy#1#",}
	},
	atlas = 'zbsbob',
	rarity = 1,
	cost = 2,
	pools = {["Cat"] = true, ["ZBSaddition"] = true, ["JakesPussy"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = {dontsellmepls = "", chance = 10},

	loc_vars = function(self, info_queue, center)
		return { vars = {center.ability.dontsellmepls}, G.GAME.probabilities.normal, center.ability.chance  }
	end,

	calculate = function(self, card, context)
		card.sell_cost = 2000
		card.ability.dontsellmepls = ". Please don't sell me :3"
		if context.selling_self then
			G.STATE = G.STATES.GAME_OVER
			G.STATE_COMPLETE = false
			return {
				message = "fuck you",
				sound = "zbs_meow"
			}
		end
		if context.joker_main then
			for i = 1, #G.hand.cards do
				local _selected_card = G.hand.cards[i]
				if pseudorandom("pussy") < (G.GAME.probabilities.normal / card.ability.chance) then
					_selected_card:start_dissolve()
					play_sound("zbs_chomp")
					card:juice_up(50,50)
				end
			end
			for i = 1, #G.hand.cards do
				local _selected_card = G.hand.cards[i]
				if pseudorandom("pussy") < (G.GAME.probabilities.normal / card.ability.chance) then
					_selected_card:start_dissolve()
					play_sound("zbs_chomp")
					card:juice_up(50,50)
				end
			end
		end
		if context.cardarea == G.play and context.individual and context.other_card or context.joker_main or context.before then
			return {
				message = "meow",
				sound = "zbs_meow"
			}
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- shmeck
SMODS.Atlas{
	key = 'zbsshmeck',
	path = 'new_zbs_shmeck.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "jakefuckingdies", path = "jakefuckingdies.ogg",})
SMODS.Sound({key = "jakefuckingdies2", path = "jakefuckingdies2.ogg",})

SMODS.Joker{
	key = 'zbsshmeck',
	loc_txt= {
		name = 'Shmeck',
		text = { "{C:green}#2# in #3#{} chance to gain {C:red}#1#{} Mult",
					"{C:green}Guaranteed{} if you have {s:10}Bob"}
	},
	atlas = 'zbsshmeck',
	rarity = 1,
	cost = 4,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {mult = 1000}, chance = 100, bobfound = false},

	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsbob
		return { vars = { center.ability.extra.mult, G.GAME.probabilities.normal, center.ability.chance, center.ability.bobfound }  }
	end,

	calculate = function(self, card, context)
		card.ability.bobfound = false
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.JakesPussy then
				card.ability.bobfound = true
			end
		end
		if context.joker_main then
			if pseudorandom('pussy') < (G.GAME.probabilities.normal / card.ability.chance) or card.ability.bobfound == true then
				return {
					mult = card.ability.extra.mult,
				}
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			if card.ability.bobfound == true and pseudorandom('pussy') < (G.GAME.probabilities.normal * 5 / card.ability.chance) then
				card:start_dissolve()
				return {
					message = "oh fuck NAAAA",
					sound = "zbs_jakefuckingdies"
				}
			end
		end
		if context.selling_self then
			play_sound("zbs_jakefuckingdies2")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- orangeprint
SMODS.Atlas{
	key = 'zbsorangeprint',
	path = 'zbs_orangeprint.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "getpissedonbozo", path = "piss.ogg",})

SMODS.Joker{
	key = 'zbsorangeprint',
	loc_txt= {
		name = '#2#',
		text = { "Copies ability of",
					"{C:attention}Joker{} to the left",}
	},
	atlas = 'zbsorangeprint',
	rarity = 3,
	cost = 10,
	pools = {["ZBSaddition"] = true},
	
	config = { extra = { active = "Inactive" , bptarget = 0 }, name = "Orangeprint", pissedon = false, timepiss = 0 },
	
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.active, center.ability.name, center.ability.pissedon, center.ability.timepiss }  }
	end,
	
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	
	update = function(self, card, front)
		local temp = pseudorandom("pissed") * 100
		--print(card.ability.timepiss)
		--print(front)
		if card.ability.timepiss ~= nil then
			card.ability.timepiss = card.ability.timepiss + front
		else
			card.ability.timepiss = 0
		end
		if card.ability.pissedon == nil then
			card.ability.pissedon = false
		end
		if card.ability.timepiss >= 1 then
			card.ability.timepiss = card.ability.timepiss - 1
			if card.ability.pissedon == false then
				print(temp)
				if temp <= 5 then
					card.ability.pissedon = true
					card.ability.name = "Pissprint"
					card.children.center:set_sprite_pos({x = 1, y = 0})
					card:juice_up(0.5, 0.5)
					play_sound("zbs_getpissedonbozo")
				end
			end
		end
		local _myid = getJokerID(card)
		if G.jokers and G.jokers.cards[_myid - 1] then card.ability.extra.bptarget = G.jokers.cards[_myid - 1] end
		
		if G.STAGE == G.STAGES.RUN then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					other_joker = G.jokers.cards[i - 1]
				end
			end
			if other_joker and other_joker ~= card and other_joker.config.center.rarity == 2 then
				card.ability.extra.active = "Compatible!"
			else
				card.ability.extra.active = "INCOMPATIBLE"
			end
		end
	end,
	
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			if context.other_card == G.jokers.cards[getJokerID(card) - 1] then
				return {
					repetitions = 1,
					card = card,
				}
			else
				return nil, true 
			end
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- m i a u
SMODS.Atlas{
	key = 'zbsmiau',
	path = 'miau-cat.png',
	px = 498,
	py = 406,
}

SMODS.Sound({key = "miau", path = "m-i-a-u.ogg",})

SMODS.Joker{
	key = 'zbsmiau',
	loc_txt= {
		name = 'miau',
		text = { "{s:5}M I A U",}
	},
	atlas = 'zbsmiau',
	rarity = 1,
	display_size = { w = 71, h = 58 },
	cost = 2,
	pools = {["Cat"] = true, ["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	config = {},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {}  }
	end,
	
	calculate = function(self, card, context)
		if context.selling_self then
			return {
				message = "fuck you",
				sound = "zbs_miau"
			}
		end
		if context.cardarea == G.play and context.individual and context.other_card or context.joker_main or context.before then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				--delay = 0.15 * amount,  -- delay increases for each card
				func = function()
					displayimage("zbs_zbsmiau",0,0,0.1)
					--show_image_on_screen("zbs_zbsmiau",0,0,1)
					return true
				end
			}))
			return {
				message = "miau",
				sound = "zbs_miau",
				--func = function()
					
				--end
			}
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- 7joker
SMODS.Atlas{
	key = 'zbs7joker',
	path = 'zbs_slot_machine.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "slotmachineding", path = "slotmachine_ding.ogg",})
SMODS.Sound({key = "slotmachine", path = "slotmachine.ogg",})

SMODS.Joker{
	key = 'zbs7joker',
	loc_txt= {
		name = 'Rigging the slots',
		text = { "Each scoring {C:attention}7{} adds {C:money}$#1#{} to",
				"this Joker, and is given",
				"at the end of the round",
				"{C:inactive}(Currently {C:money}$#4#{C:inactive})",
				"If played hand contains",
				"3 {C:attention}7{}s gain {C:red}+#2#{} mult",}
	},
	atlas = 'zbs7joker',
	rarity = 4,
	cost = 40,
	pools = {["ZBSaddition"] = true, ["Gambling"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	soul_pos = {x=1, y= 0},
	config = { extra = {money = 5, mult = 15}, amountof7s = 0, totalcashout = 0,},
	
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.money, center.ability.extra.mult, center.ability.amountof7s, center.ability.totalcashout }  }
	end,
	
	calculate = function(self, card, context)
		card.ability.totalcashout = card.ability.amountof7s * card.ability.extra.money
		if context.cardarea == G.play and context.individual and context.other_card then
			if context.other_card:get_id() == 7 then
				card.ability.amountof7s = card.ability.amountof7s + 1
				card.ability.totalcashout = card.ability.amountof7s * card.ability.extra.money
				--card:juice_up(0.5,0.5)
				return {
					message = "+$".. card.ability.extra.money,
					sound = "zbs_slotmachineding",
				}
			end
		end
		if context.joker_main then
			local amountofunique7s = 0
			for i = 1, #G.play.cards do
				local _selected_card = G.play.cards[i]
				if _selected_card:get_id() == 7 then
					amountofunique7s = amountofunique7s + 1
				end
			end
			if amountofunique7s >= 3 then
				return {
					message = "+".. card.ability.extra.mult.. " Mult",
					mult_mod = card.ability.extra.mult,
					sound = "zbs_slotmachine",
				}
			end
		end
	end,
	calc_dollar_bonus = function(self,card)
		if card.ability.totalcashout > 0 then
			local payout = card.ability.totalcashout or 0
			card.ability.totalcashout = 0
			card.ability.amountof7s = 0
			return payout
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- awakenx
SMODS.Atlas{
	key = 'newzbsawakenx',
	path = 'new_zbs_awakenx.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "bentrigger", path = "bentrigger.ogg",})

SMODS.Joker{
	key = 'newzbsawakenx',
	loc_txt= {
		name = 'AwakenX',
		text = { "When a boss blind is selected and you",
				"have at least 3 Jokers, destroy the",
				"Joker to the left then give the Joker to",
				"the right {C:dark_edition}Negative{} and gain {C:red}+#1#{} mult",
				"times the rarity of the destroyed Joker",
				"{C:inactive}(Currently {C:red}+#2#{C:inactive} mult)",
				"If a {C:legendary}Legendary {C:inactive}(or higher){} Joker is",
				"destroyed, gain {C:money}$#3#{}",}
	},
	atlas = 'newzbsawakenx',
	rarity = 4,
	cost = 15,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	soul_pos = {x=1, y= 0},
	config = { extra = {mult = 6, multtotal = 0, legendarymoneygain = 40}},

	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		return { vars = { center.ability.extra.mult, center.ability.extra.multtotal, center.ability.extra.legendarymoneygain }  }
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if G.GAME.blind:get_type() == 'Boss' then
				local _myid = getJokerID(card)
				if #G.jokers.cards >= 3 then
					if G.jokers and G.jokers.cards[_myid - 1] and G.jokers.cards[_myid + 1] then
						if G.jokers.cards[_myid - 1].config.center.rarity >= 4 then
							ease_dollars(card.ability.extra.legendarymoneygain)
						end
						card.ability.extra.multtotal = card.ability.extra.multtotal + card.ability.extra.mult * G.jokers.cards[_myid - 1].config.center.rarity
						G.jokers.cards[_myid - 1]:start_dissolve()
						G.jokers.cards[_myid + 1]:set_edition("e_negative",true,true)
						card:juice_up(0.5,0.5)
						G.jokers.cards[_myid + 1]:juice_up(5,5)
						if math.ceil(pseudorandom("limbuscompany") * 100) <= 1 then
							play_sound("zbs_chomp")
						else
							play_sound("zbs_bentrigger")
						end
					end
				end
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			return {
				message = "LIMBUS COMPANY!",
				sound = "zbs_benLIMBUSCOMPANY"
			}
		end
		if context.joker_main and card.ability.extra.multtotal > 0 then
			print(G.GAME.chips)
			return {
				mult = card.ability.extra.multtotal,
			}
		end
		if context.selling_self then
			play_sound("zbs_benfuckingdies")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- exponential
SMODS.Atlas{
	key = 'zbsexponential',
	path = 'zbs_exponent.png',
	px = 1283,
	py = 718,
}

SMODS.Sound({key = "emult", path = "ExponentialMult.ogg",})

SMODS.Joker{
	key = 'zbsexponential',
	loc_txt= {
		name = 'zbsexponential',
		text = { "{X:dark_edition,C:white}^#1#{} base Mult",
				"{C:inactive,S:0.5}It's only base Mult",
				"{C:inactive,S:0.5}due to limitations",
				"{C:inactive,S:0.5}You can't retrigger",
				"{C:inactive,S:0.5}this either",}
	},
	atlas = 'zbsexponential',
	rarity = 4,
	display_size = { w = 141, h = 80 },
	cost = 20,
	pools = {["ZBSaddition"] = true, ["Exotic"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = {x=0, y= 0},
	config = { extra = {emult = 3, triggered = false}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.emult, center.ability.extra.triggered }  }
	end,
	
	calculate = function(self, card, context)
		update_player_in_shop(context)
		if context.post_joker then card.ability.extra.triggered = false end
			
		if context.individual and context.cardarea == G.play and card.ability.extra.triggered == false then
			card.ability.extra.triggered = true
			print(G.GAME.blind:get_type())
			if G.GAME.current_round.current_hand.mult == "?" then
				return {
					color = G.C.RED,
					message = "I can't do this wit a question mark, forgive me",
					sound = "zbs_bwomp",
				}
			else
				return {
					color = G.C.RED,
					message = "^".. card.ability.extra.emult,
					Xmult_mod = (G.GAME.current_round.current_hand.mult ^ card.ability.extra.emult) / G.GAME.current_round.current_hand.mult,
					sound = "zbs_emult",
				}
			end
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- positionally offset joker
SMODS.Atlas{
	key = 'zbspositionallyoffsetjoker',
	path = 'zbs_positionally_offset_joker.png',
	px = 71,
	py = 238,
}

SMODS.Joker{
	key = 'zbspositionallyoffsetjoker',
	loc_txt= {
		name = 'Positionally Offset Joker',
		text = { "{X:mult,C:white} X#2# {} Mult If played",
				"hand is a #1#"}
	},
	atlas = 'zbspositionallyoffsetjoker',
	rarity = 3,
	display_size = { w = 71, h = 238 },
	cost = 10,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {poker_hand = "High Card", x_mult = 4}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.poker_hand, center.ability.extra.x_mult }  }
	end,

	calculate = function(self,card,context)
		if context.joker_main and context.cardarea == G.jokers then
			if context.scoring_name == card.ability.extra.poker_hand then
				return {
					message = "X".. card.ability.extra.x_mult,
					colour = G.C.RED,
					x_mult = card.ability.extra.x_mult
				}
			end
		end
	end,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.poker_hand, card.ability.extra.x_mult }, key = self.key }
	end		
}

-- two little guys
SMODS.Atlas{
	key = 'zbstwolittleguys',
	path = 'zbs_two_little_guys.png',
	px = 27,
	py = 17,
}

SMODS.Sound({key = "jermanoise", path = "jermanoise.ogg",})

SMODS.Joker{
	key = 'zbstwolittleguys',
	loc_txt= {
		name = 'Two Little Guys',
		text = { "These guys gain {C:red}+#1#{} Mult if played",
					"hand contains a {C:attention}Pair{}",
					"{C:inactive}(Currently {C:red}+#2#{}{C:inactive} Mult){}",}
	},
	atlas = 'zbstwolittleguys',
	rarity = 1,
	display_size = { w = 27, h = 17 },
	cost = 4,
	pools = { ["ZBSaddition"] = true },
	
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {multamt = 2, multtotal = 0}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.multamt, center.ability.extra.multtotal }  }
	end,
	
	calculate = function(self, card, context)
		local _myid = getJokerID(card)
		if context.before and next(context.poker_hands['Pair']) then
			card.ability.extra.multtotal = card.ability.extra.multtotal + card.ability.extra.multamt
			return {
				message = "Hewwo!",
				sound = "zbs_jermanoise",
			}
		end
		if context.joker_main and card.ability.extra.multtotal > 0 then
			return {
				mult = card.ability.extra.multtotal,
				message = "Hewwo!",
				sound = "zbs_jermanoise",
			}
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- two small gentlemen
SMODS.Atlas{
	key = 'zbstwosmallgentlemen',
	path = 'zbs_two_small_gentlemen.png',
	px = 27,
	py = 25,
}

SMODS.Joker{
	key = 'zbstwosmallgentlemen',
	loc_txt= {
		name = '{f:zbs_OldEnglish}Two Small Gentlemen',
		text = { "{f:zbs_OldEnglish}These gentlemen gain {f:zbs_OldEnglish,C:red}+#1#{f:zbs_OldEnglish} Mult",
				"{f:zbs_OldEnglish}if't be true did play",
				"{f:zbs_OldEnglish}handeth enwheels a {f:zbs_OldEnglish,C:attention}Pair{}",
					"{f:zbs_OldEnglish,C:inactive}(Currently {f:zbs_OldEnglish,C:red}+#2#{f:zbs_OldEnglish,C:inactive} Mult){}",}
	},
	atlas = 'zbstwosmallgentlemen',
	rarity = 1,
	display_size = { w = 27, h = 25 },
	cost = 4,
	pools = { ["ZBSaddition"] = true },
	
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {multamt = 2, multtotal = 0}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.multamt, center.ability.extra.multtotal }  }
	end,
	
	calculate = function(self, card, context)
		local _myid = getJokerID(card)
		if context.before and next(context.poker_hands['Pair']) then
			card.ability.extra.multtotal = card.ability.extra.multtotal + card.ability.extra.multamt
			return {
				message = "Greetings.",
				sound = "zbs_jermanoise",
			}
		end
		if context.joker_main and card.ability.extra.multtotal > 0 then
			return {
				mult = card.ability.extra.multtotal,
				message = "Greetings.",
				sound = "zbs_jermanoise",
			}
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- one big guy
SMODS.Atlas{
	key = 'zbsonebigguy',
	path = 'zbs_one_big_guy.png',
	px = 60,
	py = 68,
}

SMODS.Sound({key = "lowjermanoise", path = "lowjermanoise.ogg",})

SMODS.Joker{
	key = 'zbsonebigguy',
	loc_txt= {
		name = 'One Big Guy',
		text = { "This guy gain {C:red}X#1#{} Mult if played",
					"hand contains a {C:attention}Full House{}",
					"{C:inactive}(Currently {C:red}X#2#{}{C:inactive} Mult){}",}
	},
	atlas = 'zbsonebigguy',
	rarity = 1,
	display_size = { w = 60, h = 68 },
	cost = 4,
	pools = { ["ZBSaddition"] = true },
	
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {multamt = 0.1, multtotal = 1}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.multamt, center.ability.extra.multtotal }  }
	end,
	
	calculate = function(self, card, context)
		local _myid = getJokerID(card)
		if context.before and next(context.poker_hands['Full House']) then
			card.ability.extra.multtotal = card.ability.extra.multtotal + card.ability.extra.multamt
			return {
				message = "Hello.",
				sound = "zbs_lowjermanoise",
			}
		end
		if context.joker_main and card.ability.extra.multtotal > 1 then
			return {
				x_mult = card.ability.extra.multtotal,
				message = "Hello.",
				sound = "zbs_lowjermanoise",
			}
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- 90degreerotatedjoker
SMODS.Atlas{
	key = 'zbs90degreerotatedjoker',
	path = 'zbs_90degreerotatedjoker.png',
	px = 95,
	py = 71,
}

SMODS.Joker{
	key = 'zbs90degreerotatedjoker',
	loc_txt = {
		name = "90° Clockwise Rotated Joker",
		text = {
			"After scoring a hand, all cards",
			"in played hand have their suits rotated clockwise",
			"{C:inactive}({C:clubs}Clubs{C:inactive} -> {C:diamonds}Diamonds{C:inactive} -> {C:hearts}Hearts{C:inactive} -> {C:spades}Spades{C:inactive} -> {C:clubs}Clubs{C:inactive})"
		}
	},
	atlas = "zbs90degreerotatedjoker",
	rarity = 2,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pools = {["ZBSaddition"] = true},
	display_size = { w = 95, h = 71 },
	pos = { x = 0, y = 0 },
	cost = 6,

	calculate = function(self, card, context)
		--if context.before then
		if context.joker_main and context.scoring_hand then
			--local cardstorotate = G.play.cards
			local cardstorotate = context.scoring_hand
			local rotation = {
				Clubs = "Diamonds",
				Diamonds = "Hearts",
				Hearts = "Spades",
				Spades = "Clubs"
			}
			
			-- Rotate only the cards in the played hand
			local amount = 0
			for i, c in ipairs(cardstorotate) do
				if c and c.base and c.base.suit and rotation[c.base.suit] then
					amount = amount + 1
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.15,  -- delay increases for each card
						func = function()
							c:flip()
							play_sound('tarot1')
							return true
						end
					}))
				end
			end
			delay(0.2 + 0.15 * (5 - amount))
			for i, c in ipairs(cardstorotate) do
				if c and c.base and c.base.suit and rotation[c.base.suit] then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.1,  -- delay increases for each card
						func = function()
							print(c.base.suit)
							print(rotation[c.base.suit])
							SMODS.change_base(c, rotation[c.base.suit])
							c:juice_up(0.5,0.5)
							-- your suit rotation logic here
							return true
						end
					}))
				end
			end
			delay(0.2 + 0.1 * (5 - amount))
			for i, c in ipairs(cardstorotate) do
				if c and c.base and c.base.suit and rotation[c.base.suit] then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.15,  -- delay increases for each card
						func = function()
							c:flip()
							play_sound('tarot2')
							return true
						end
					}))
				end
			end
			delay(0.2 + 0.15 * (5 - amount))
			
			return {
				message = "Suit rotated!",
				color = G.C.SUITS.Spades
			}
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- floppy
SMODS.Atlas{
	key = 'zbs_floppy_joker',
	path = 'zbs_floppy_disk_joker_atlas.png',
	px = 62,
	py = 62,
}

SMODS.Sound({key = "floppyread", path = "floppyread.ogg", pitch = 1, random_pitch = false })
SMODS.Sound({key = "floppyfinish", path = "floppyfinish.ogg", pitch = 1, random_pitch = false })

SMODS.Joker{
	key = 'zbs_floppy_joker',
	loc_txt= {
		name = '#4# Floppy Disk',
		text = { "Loading {C:Attention}#2#{} ({C:Attention}#3#{})...",
		"Currently at {C:Attention}#1#%{}",}
	},
	atlas = 'zbs_floppy_joker',
	rarity = 2,
	cost = 0,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	display_size = { w = 62, h = 62 },
	--edition_compat = false,

	pos = {x=0, y= 0},
	config = { percentage = 0, jokertocopy = "hello :D", jokertocopykey = "j_zbs_zbsexponential", color = "Black", colorindex = 1, inclusive = false },

	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS[center.ability.jokertocopykey]
		return { vars = { center.ability.percentage, center.ability.jokertocopy, center.ability.jokertocopykey, center.ability.color, center.ability.colorindex, center.ability.inclusive }  }
	end,

	calculate = function(self, card, context)
		card.children.center:set_sprite_pos({x = card.ability.percentage / 25, y = card.ability.colorindex - 1})
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.percentage = card.ability.percentage + 25
			card.children.center:set_sprite_pos({x = card.children.center.sprite_pos.x + 1, y = card.ability.colorindex - 1})
			print(card.ability.colorindex)
			if card.ability.percentage >= 100 then
			card:juice_up(0.5,0.5)
				delay(1)
				local clone = SMODS.add_card({ key = card.ability.jokertocopykey })
				clone:set_edition(card.edition)
				if card.ability.inclusive == true then
					clone:set_edition({polychrome = true})
				end
				card:start_dissolve()
				play_sound("zbs_floppyfinish")
				return {
					message = "Finished loading!"
				}
			else
				play_sound("zbs_floppyread")
				return {
					message = card.ability.percentage.. "%"
				}
			end
		end
	end,
	in_pool = function() return false end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- oops all error
--[[SMODS.Atlas{
	key = 'zbsprobabilityfuckup',
	path = 'zbs_90degreerotatedjoker.png',
	px = 95,
	py = 71,
}

SMODS.Joker{
	key = 'zbsprobabilityfuckup',
	loc_txt= {
		name = 'OOPS ALL {f:zbs_OldEnglish}error',
		text = { "#2#"}
	},
	atlas = 'zbsprobabilityfuckup',
	rarity = 3,
	--display_size = { w = 71, h = 238 },
	cost = 8,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	config = { extra = {hello = "hello"}},
	
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.hello, G.GAME.probabilities.normal }  }
	end,
	
	calculate = function(self,card,context)
	if context.mod_probability then
		return {
			numerator = context.numerator * 2
		}
	end
	end,
}]]--

--primal aspid
SMODS.Atlas{
	key = 'zbsaspid',
	path = 'zbs_primalaspid.png',
	px = 71,
	py = 95,
}

SMODS.Sound({key = "multnegativehit", path = "multnegativehit1.ogg",})

SMODS.Joker{
	key = 'zbsaspid',
	loc_txt= {
		name = 'Primal Aspid',
		text = { "{C:red}#1#{} Mult",
				"This card is destroyed",
				"{C:inactive}(regardless of eternality)",
				"at the end of the",
				"round and gives {C:money}+$#2#"}
	},
	atlas = 'zbsaspid',
	rarity = 1,
	cost = 0,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {mult = -5, dollars = 10}},

	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.dollars }  }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = card.ability.extra.mult.. " Mult",
				mult_mod = card.ability.extra.mult,
				sound = "zbs_multnegativehit"
			}
		end
		if context.end_of_round and context.cardarea == G.jokers then
			--card:start_dissolve()
		end
	end,
	calc_dollar_bonus = function(self,card)
		card:start_dissolve()
		return card.ability.extra.dollars
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- the funny man
SMODS.Atlas{
	key = 'zbsfunnyman',
	path = 'zbs_funnyman.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsfunnyman',
	loc_txt= {
		name = 'the funny man',
		text = { "Each scored {C:attention}4{} creates",
				"a {C:green}Primal Aspid{}"}
	},
	atlas = 'zbsfunnyman',
	rarity = 3,
	cost = 10,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {}},

	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsaspid
		return { vars = {  }  }
	end,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card then
			if context.other_card:get_id() == 4 then
				--G.E_MANAGER:add_event(Event{
				--	func = function()
						--delay(1)
						local aspidcard = SMODS.add_card({ key = 'j_zbs_zbsaspid' })
						--aspidcard:set_edition({ negative = true })
						--aspidcard:set_edition({ eternal = true })
						aspidcard.ability.eternal = true
						print(":3")
				--		return true
				--	end
				--})
				--return {
				--	message = "Created Primal Aspid!"
				--}
			end
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

--low quality meme
SMODS.Atlas{
	key = 'zbslowqualitymeme',
	path = 'zbs_lowqualitymeme.png',
	px = 71,
	py = 96,
}

SMODS.Joker{
	key = 'zbslowqualitymeme',
	loc_txt= {
		name = 'Meme Regurgitation',
		text = { "Retriggers all",
				"{C:dark_edition}compressed{} Jokers",
				"If this joker is {C:dark_edition}compressed{}",
				"then retrigger 2 more times",}
	},
	atlas = 'zbslowqualitymeme',
	rarity = 2,
	cost = 7,
	pools = {["ZBSaddition"] = true},

	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	--display_size = { w = 500, h = 1 },

	pos = {x=0, y= 0},

	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
			if context.other_card.edition then
				print(context.other_card.edition.type)
			end
			if context.other_card.edition and context.other_card.edition.type == "zbs_zbscompressed" then
				if card.edition and card.edition.type == "zbs_zbscompressed" then
					return {
						message = "{f:zbs_OldEnglish}Memeing all over",
						repetitions = 3,
						card = card,
					}
				else
					return {
						message = "Memes",
						repetitions = 1,
						card = card,
					}
				end
			else
				return nil, true end
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- midas conscript
SMODS.Atlas{
	key = 'zbsmidasconscript',
	path = 'zbs_lowqualitymeme.png',
	px = 71,
	py = 96,
}

SMODS.Joker{
	key = 'zbsmidasconscript',
	loc_txt= {
		name = 'Midas Conscript',
		text = { "All {C:attention}Gold Seal Gold Diamond suit",
					"{C:attention}cards{} held in hand give {C:money}$#1#{}",}
	},
	atlas = 'zbsmidasconscript',
	rarity = 3,
	cost = 10,
	pools = { ["ZBSaddition"] = true },
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	
	pos = {x=0.2, y= -0.1},
	config = { extra = {dollars = 10}},
	
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.m_gold
		info_queue[#info_queue+1] = {set = "Other", key = "gold_seal"}
		return { vars = { center.ability.extra.dollars}  }
	end,
	
	calculate = function(self, card, context)
		--[[if context.joker_main then
			local amount = 0
			for i = 1, #G.hand.cards do
				local _card = G.hand.cards[i]
				print(_card.seal,_card.base.suit)
				if _card.seal == "Gold" and _card.base.suit == "Diamonds" and SMODS.has_enhancement(_card, 'm_gold') then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.15 * amount,  -- delay increases for each card
						func = function()
							--c:flip()
							--play_sound('tarot1')
							ease_dollars(card.ability.extra.dollars)
							card_eval_status_text(_card,'extra',nil,nil,nil,{message = "$"..card.ability.extra.dollars})
							card:juice_up(0.5,0.5)
							--card_eval_status_text(card,'extra',nil,nil,nil,{message = "$"..card.ability.extra.moneygiven})
							return true
						end
					}))
					amount = amount + 1
				end
			end
			delay(0.2 + 0.15 * amount)
		end]]--
		
		--new code makes it compatible with mime
		if context.individual and context.cardarea == G.hand and context.other_card and not context.end_of_round then
			local c = context.other_card
			
			if c.seal == "Gold" and c.base.suit == "Diamonds" and SMODS.has_enhancement(c, 'm_gold') then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					--delay = 0.15 * amount,  -- delay increases for each card
					func = function()
						card:juice_up(0.5,0.5)
						return true
					end
				}))
				return {
					dollars = card.ability.extra.dollars,
					card = c,
					func = function()
						--card:juice_up(0.5,0.5)
						return true
					end,
					colour = G.C.MONEY
					--message = "$" .. card.ability.extra.dollars
				}
			end
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- midas hand
SMODS.Atlas{
	key = 'zbsmidashand',
	path = 'zbs_midas_hand.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsmidashand',
	loc_txt = {
		name = "The Hand of Midas",
		text = {
			"All played {C:attention}Gold{} cards",
			"gain a {C:attention}Gold{} seal at",
			"the end of the hand"
		}
	},
	atlas = "zbsmidashand",
	rarity = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pools = {["ZBSaddition"] = true},
	pos = { x = 0, y = 0 },
	cost = 10,
	
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.m_gold
		info_queue[#info_queue+1] = {set = "Other", key = "gold_seal"}
		return {}
	end,
	
	calculate = function(self, card, context)
		--if context.before then
		if context.after and context.scoring_hand then
			local cards = context.scoring_hand
			
			-- Rotate only the cards in the played hand
			local amount = 0
			for i, c in ipairs(cards) do
					print(i,c,c.base)
				if c and c.base then
					print(i,SMODS.has_enhancement(c, 'm_gold'),c.seal)
					if SMODS.has_enhancement(c, 'm_gold') and not c.seal then
						amount = amount + 1
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.15,  -- delay increases for each card
							func = function()
								c:set_seal("Gold",true,true)
								play_sound('gold_seal')
								c:juice_up(0.5,0.5)
								return true
							end
						}))
					end
				end
			end
			if amount > 0 then
				delay(0.2 + 0.15 * amount)
			end
			
			return true
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- no cryptid
SMODS.Atlas{
	key = 'zbsnocryptid',
	path = 'zbs_nocryptid.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsnocryptid',
	loc_txt = {
		name = 'Fuck Cryptid',
		text = {
			"Destroys all {C:attention}Jolly Jokers{}",
			"at the end of the shop",
			"Gain a {C:attention}Zany Joker{}",
			"for each one destroyed"
		}
	},
	atlas = 'zbsnocryptid',
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	pools = {["ZBSaddition"] = true},
	
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
		info_queue[#info_queue+1] = G.P_CENTERS.j_zany
		return {}
	end,
	
	blueprint_compat = false,
	eternal_compat = true,
	soul_pos = {x=1, y= 0},
	perishable_compat = true,
	
	calculate = function(self, card, context)
		if context.ending_shop then
			local destroyed = {}
			
			-- Find all Jolly Jokers
			for _, j in ipairs(G.jokers.cards) do
				if j.config.center.key == 'j_jolly' then
					destroyed[#destroyed+1] = j
				end
			end
			
			if #destroyed == 0 then return end
			
			-- Destroy Jollies
			for i, j in ipairs(destroyed) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						j:start_dissolve()
						return true
					end
				}))
			end
			
			-- Add Zanies
			for i = 1, #destroyed do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						local zany = create_card(
							'Joker',
							G.jokers,
							nil, nil, nil, nil,
							'j_zany'
						)
						zany:add_to_deck()
						G.jokers:emplace(zany)
						return true
					end
				}))
			end
		end
	end
}

-- diet pepsi
SMODS.Atlas{
	key = 'zbsdietpepsi',
	path = 'zbs_pepsi.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsdietpepsi',
	loc_txt= {
		name = 'Diet Pepsi',
		text = {
			"#1# in #2# chance to",
			"create a {C:attention}Double Tag{}",
			"whenever a card is sold",
		}
	},
	atlas = 'zbsdietpepsi',
	rarity = 3,
	cost = 12,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	soul_pos = {x=1, y= 0},
	config = {chance = 3},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {G.GAME.probabilities.normal, center.ability.chance}}
	end,
	
	calculate = function(self, card, context)
		if context.selling_card then
			if pseudorandom('cocacolaespuma') < (G.GAME.probabilities.normal / card.ability.chance) then
				local sold = context.card
				
				--if sold == card then return end
				
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					func = function()
						local _tag = Tag("tag_double") -- thanks cryptid (ignore the joker before this cryptid devs)
						add_tag(_tag)
						_tag:apply_to_run({ type = "new_blind_choice" })
						--play_sound("tag")
						card:juice_up(0.4, 0.4)
						return true
					end
				}))
				
				return {
					message = "Tag!",
						colour = G.C.ORANGE
				}
			end
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- caine
SMODS.Atlas{
	key = 'zbscaine',
	path = 'zbs_swalla.png',
	px = 270,
	py = 270,
}

SMODS.Sound({key = "caineadded", path = "swallacaine.ogg",})
SMODS.Sound({key = "cainebitch", path = "i-am-your-bitch.ogg",})

SMODS.Joker{
	key = 'zbscaine',
	--[[loc_txt= {
		name = {'Caine', "Test"},
		text = {{ "The Amazing Digital Circus™",
				"{C:blue}+#1#{} Chips and {C:red}+#2#{} Mult"},{"Test"}}
	},]]--
	loc_txt= {
		label = "hi",
		name = 'Caine',
		text = { "The Amazing Digital Circus™",
				"{C:blue}+#1#{} Chips and {C:red}+#2#{} Mult"}
	},
	atlas = 'zbscaine',
	rarity = 1,
	display_size = { w = 71, h = 71 },
	cost = 2,
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	
	pos = {x=0, y= 0},
	config = {extra = {chips = 20.23, mult = 8.13}, randomnessofframe = 50},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {center.ability.extra.chips, center.ability.extra.mult, center.ability.randomnessofframe}  }
	end,
	
	add_to_deck = function(self, card, from_debuff)
		print("hiii")
		print(self,card,from_debuff)
		if from_debuff ~= true then
			play_sound("zbs_caineadded")
		end
	end,
	
	update = function(self, card, dt)
		--print(card.ability.randomnessofframe)
		if card.ability.randomnessofframe == 50 then
			card.ability.randomnessofframe = math.random(0,9)
			card.ability.randomnessofframe = 0
		end
		local FPS = 30
		local FRAME_COUNT = 10
		
		local lovetim = love.timer.getTime()
		local frame = (math.floor(lovetim * FPS) + card.ability.randomnessofframe) % FRAME_COUNT
		
		if frame < 5 then
			card.children.center:set_sprite_pos({x = frame, y = 0})
		else
			card.children.center:set_sprite_pos({x = frame - 5, y = 1})
		end
		--print(card.ability.timme)
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
				message = "My name is Caine, I am your bitch",
				sound = "zbs_cainebitch",
			}
		end
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- dylly willy

-- he would be dylly willy in the code but he insisted on Do Boxy

SMODS.Atlas{
	key = 'zbsdoboxy',
	--path = 'zbs_dyllywilly.png',
	path = 'fatoldfart_cream.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsdoboxy',
	loc_txt= {
		name = 'FatOldFart',
		text = { "{X:mult,C:white}X#1#{} Mult",
					"for every {C:attention}BNA",
					"in your possession",
					"{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult",}
	},
	atlas = 'zbsdoboxy',
	rarity = 2,
	cost = 4,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true, ["DillyWilly"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {xmult = 1, xmulttotal = 1}},

	loc_vars = function(self, info_queue, center)
		--info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsquinn
        info_queue[#info_queue+1] = {key = 'zbsmod_artcredit', set = 'Other', vars = { "FatOldFart and ZBS" }}
		return { vars = { center.ability.extra.xmult, center.ability.extra.xmulttotal }  }
	end,

	calculate = function(self, card, context)
		bnacount = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.BNA then
				bnacount = bnacount + 1
			end
		end
		card.ability.extra.xmulttotal = (bnacount + 1) * card.ability.extra.xmult
		if context.joker_main then
			if card.ability.extra.xmulttotal > 0 then
				return {
					--message = "+".. card.ability.extra.multtotal.. " Mult",
					x_mult = card.ability.extra.xmulttotal,
					--message = "QUINN CHAN",
					--sound = "zbs_quinnchan"
				}
			else
				--return {
				--	message = "@QuinnOfGilead QUINN CHAN WHERE ARE YOU",
				--	sound = "zbs_quinnchan"
				--}
			end
		end
		if context.selling_self then
			play_sound("zbs_joolfuckingdies")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

-- BNA

-- i do not know what "do boxy" or "evi" means, some inside joke between them or something i guess

SMODS.Atlas{
	key = 'zbsevi',
	path = 'zbs_bna.png',
	px = 71,
	py = 95,
}

SMODS.Joker{
	key = 'zbsevi',
	loc_txt= {
		name = 'BNA',
		text = { "{X:chips,C:white}X#1#{} Chips",
					"for every {C:attention}FatOldFart",
					"in your possession",
					"{C:inactive}Currently {X:chips,C:white}X#2#{C:inactive} Chips",}
	},
	atlas = 'zbsevi',
	rarity = 3,
	cost = 8,
	pools = {["ZBSaddition"] = true, ["Tequila"] = true, ["BNA"] = true},
	
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,

	pos = {x=0, y= 0},
	config = { extra = {xchips = 1, xchipstotal = 1}},

	loc_vars = function(self, info_queue, center)
		--info_queue[#info_queue+1] = G.P_CENTERS.j_zbs_zbsquinn
		return { vars = { center.ability.extra.xchips, center.ability.extra.xchipstotal }  }
	end,

	calculate = function(self, card, context)
		dillywillycount = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.DillyWilly then
				dillywillycount = dillywillycount + 1
			end
		end
		card.ability.extra.xchipstotal = (dillywillycount + 1) * card.ability.extra.xchips
		if context.joker_main then
			if card.ability.extra.xchipstotal > 0 then
				return {
					--message = "+".. card.ability.extra.multtotal.. " Mult",
					x_chips = card.ability.extra.xchipstotal,
					--message = "QUINN CHAN",
					--sound = "zbs_quinnchan"
				}
			else
				--return {
				--	message = "@QuinnOfGilead QUINN CHAN WHERE ARE YOU",
				--	sound = "zbs_quinnchan"
				--}
			end
		end
		if context.selling_self then
			play_sound("zbs_joolfuckingdies")
		end
	end,

	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}