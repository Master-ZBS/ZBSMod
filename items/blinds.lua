SMODS.Atlas {
	key = "zbsblindatlas",
	path = "zbs_blindsatlas.png",
	px = 34,
	py = 34,
	frames = 1,
	atlas_table = 'ANIMATION_ATLAS'
}

function forceGameover()
	G.STATE = G.STATES.GAME_OVER
	G.STATE_COMPLETE = false
end

SMODS.Blind {
	name = "boss_timmie",
	key = "boss_timmie",
	atlas = "zbsblindatlas",
	pos = { y = 0 },
	dollars = 5,
	mult = 1.75,
	boss = { min = 1 },
	loc_txt = {
		name = "TiMMie179",
		text = {
			"Can't draw queens.",
			"Only I get the huzz!",
		}
	},
	boss_colour = HEX('0E1330'),
	
	drawn_to_hand = function(self)
		for i = 1, #G.hand.cards do
			local _discardthisone = false
			if G.hand.cards[i].base.value == "Queen" then _discardthisone = true end
			if _discardthisone == true then
				local _selected_card = G.hand.cards[i]
				G.hand:add_to_highlighted(_selected_card, true)
			end
		end
		G.FUNCS.discard_cards_from_highlighted(nil, true)
	end,
}

SMODS.Atlas {
	key = "zbsexterminate",
	path = "zbs_exterminationblind.png",
	px = 136,
	py = 136,
	frames = 1,
	atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
	name = "boss_extermination",
	key = "boss_extermination",
	atlas = "zbsexterminate",
	mult = 2,
	pos = { y = 0 },
	dollars = 5,
	loc_txt = {
		name = 'EXTERMINATION',
		text = {
			'Debuffs all',
			'Tequila Jokers',
		}
	},
	boss = {  min = 1 },
	boss_colour = HEX('8D867E'),
	
	recalc_debuff = function(self, card)
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.Tequila then
				G.jokers.cards[i]:set_debuff(true)
			end
		end
	end,
	
	disable = function(self)
		for i = 1, #G.jokers.cards do
			G.jokers.cards[i]:set_debuff(false)
		end
	end,
	
	set_blind = function(self)
		--create_center_button()
		--print("button created")
	end,
	
	defeat = function(self)
		for i = 1, #G.jokers.cards do
			G.jokers.cards[i]:set_debuff(false)
		end
	end,
}

SMODS.Blind {
	name = "boss_calculator",
	key = "boss_calculator",
	atlas = "zbsblindatlas",
	pos = { y = 1 },
	dollars = 5,
	mult = 2,
	boss = { min = 1 },
	loc_txt = {
		name = {"What is diddy blud doing on the calculator"},
		text = {
			"Random rank debuffed",
			"each hand",
			"{C:inactive}(Currently {C:attention}#1#{C:inactive})",
		}
	},
	boss_colour = HEX('A7BF43'),
	config = {rank = 2, canredorank = true},
	
	--[[loc_vars = function(self, info_queue, center)
		print(self, info_queue, center)
				for i,v in pairs(self) do
				print(i, type(v), v)
				end
		return { vars = {center.effect.rank or 5, center.effect.rankstring or ":33", center.effect.canredorank or false}}
	end,]]
	
	loc_vars = function(self, info_queue, center)
		if checkdebugprintsetting then
			print("loc_vars", self, info_queue, center)
			for i,v in pairs(self) do
				print(i, type(v), v)
			end
			for i,v in pairs(self.loc_txt) do
				print(i, type(v), v)
			end
			for i,v in pairs(self.loc_txt.text_parsed) do
				print(i, type(v), v)
			end
			for i,v in pairs(self.loc_txt.text_parsed[3]) do
				print(i, type(v), v)
			end
			for i,v in pairs(self.loc_txt.text_parsed[3][3]) do
				print(i, type(v), v)
			end
			for i,v in pairs(self.loc_txt.text_parsed[3][3].strings) do
				print(i, type(v), v)
			end
		end
		self.loc_txt.text_parsed[3][2].strings[1] = "Ace"
		return { vars = {self.config.rank or 5, self.config.canredorank or true}}
	end,
	
	on_hand_start = function(self)
		--[[local ranks = getRanksInDeck()
		if #ranks > 0 then
			self.config.rank = pseudorandom_element(ranks, pseudoseed("calculator"))
		end]]
	end,
	
	calculate = function(self, blind, context)
		if not blind.disabled then
			if context.before then
				blind.effect.canredorank = true
				print(blind)
				for i,v in pairs(blind) do
				print(i, type(v), v)
				end
			end
			if context.hand_drawn then
				if blind.effect.canredorank then
					blind.effect.canredorank = false
					local ranks = getRanksInDeck()
					print(":3", blind.effect.rank)
					if #ranks > 0 then
						blind.effect.rank = pseudorandom_element(ranks, pseudoseed("calculator"))
					end
					print(":33", blind.effect.rank)
					G.GAME.blind.loc_debuff_lines[3] = "(Currently ".. rankNumToName[blind.effect.rank].. ")"
			for i, v in ipairs(G.playing_cards) do
				print(blind)
				G.playing_cards[i]:set_debuff(self:debuff_card(v, blind, true))
			end
				end
			end
		end
	end,
	
	--[[recalc_debuff = function(self, card)
		for i = 1, #G.deck.cards do
			if G.deck.cards[i] and G.deck.cards[i]:get_id() then
				print(self.rank, card:get_id())
				if self.rank and card:get_id() == self.rank then
					G.deck.cards[i]:set_debuff(true)
				end
			end
		end
	end,]]
	
	debuff_card = function(self, card, blind, from_my_own, b, c)
		if checkdebugprintsetting then
		print(a,b,c)
		print(blind)
		end
		if blind and from_my_own then
		if checkdebugprintsetting then
			print(self, card, blind)
			print(blind.effect.rank, card:get_id())
			end
			if blind.effect.rank and card:get_id() == blind.effect.rank then
				return true
			else
				--return false
			end
		end
	end,
	
	defeat = function(self)
		G.GAME.blind.loc_debuff_lines[1] = "being able to change"
		G.GAME.blind.loc_debuff_lines[2] = "blind text mid-blind"
		G.GAME.blind.loc_debuff_lines[3] = "took forever, appreciate it please"
			G.FUNCS.overlay_menu{
					definition = create_UIBox_custom_video1zbs("calculate_this_throw_dumbass","Hell yeah, calculate this throw"),
					config = {no_esc = true}
				}
	end,
}