SMODS.Atlas{
	key = 'zbs_depression',
	path = 'zbs_placeholder_joker.png',
	px = 568,
	py = 760,
}

SMODS.Sound({key = "depressionuse", path = "bentrigger.ogg",})

SMODS.Consumable {
	set = "Tarot",
	key = "zbs_nega",
	config = {
		max_highlighted = 1,
		extra = 'e_negative',
		plural = ""
	},
	loc_vars = function(self, info_queue, card)
		-- Handle creating a tooltip with seal args.
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		-- Description vars
		return {vars = {(card.ability or self.config).max_highlighted, (card.ability or self.config).plural}}
	end,
	loc_txt = {
		name = 'Depression',
		text = {
			"Select {C:attention}#1#{} playing card#2# and",
			"{C:attention}1 Joker{}, apply {C:dark_edition}Negative{}",
			"to selected playing card#2#",
			"and destroy the {C:attention}Joker{}",
			"{C:inactive,s:0.8}get it? like you're removing the jokes?{}"
		}
	},
	cost = 4,
	atlas = "zbs_depression",
	pos = {x=0, y=0},
	pools = {["ZBSaddition"] = true},
	
	update = function(self, card, dt)
		if card.ability.max_highlighted == 1 then
			card.ability.plural = ""
		else
			card.ability.plural = "s"
		end
	end,
	
	can_use = function(self, card)
		if #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0 and #jokerHighlighted() == 1 then
			return true
		end
	end,
	
	use = function(self, card, area, copier)
		jokerHighlighted()[1]:start_dissolve()
		G.GAME.zbs = G.GAME.zbs or {}
		G.GAME.zbs.used_depression = true
		print(G.GAME.zbs.used_depression)
		for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
			G.E_MANAGER:add_event(Event({func = function()
				play_sound('zbs_depressionuse')
				card:juice_up(0.3, 0.5)
				return true end }))
			
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
				G.hand.highlighted[i]:set_edition({ negative = true })
				return true end }))
			
			delay(0.5)
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
	end
}

SMODS.Atlas{
	key = 'zbs_floppy_consumable',
	path = 'zbs_floppy_disk_consumable_atlas.png',
	px = 62,
	py = 62,
}

SMODS.Sound({key = "floppyuse", path = "floppyuse.ogg",})

local floppies = {
	{ key = "zbs_floppy_black", color = "Black", inclusive = false },
	{ key = "zbs_floppy_red", color = "Red", inclusive = false },
	{ key = "zbs_floppy_blue", color = "Blue", inclusive = false },
	{ key = "zbs_floppy_green", color = "Green", inclusive = false },
	{ key = "zbs_floppy_lesbian", color = "Lesbian", inclusive = true },
	{ key = "zbs_floppy_gay", color = "Vincian (gay)", inclusive = true },
	{ key = "zbs_floppy_bisexual", color = "Bisexual", inclusive = true },
	{ key = "zbs_floppy_trans", color = "Trans", inclusive = true },
}

for i, f in ipairs(floppies) do
	local description = {
				"Select {C:attention}#1#{} joker",
				"to copy"
			}
	if f.inclusive then
		table.insert(description, 3, "Applies {C:dark_edition}Polychrome{} to")
		table.insert(description, 4, "cloned joker")
	else
		table.insert(description, 3, "Transfers {C:dark_edition}Editions{} to")
		table.insert(description, 4, "cloned joker")
		table.insert(description, 5, "e.g. {C:dark_edition}Negative{} floppy copying")
		table.insert(description, 6, "{C:Attention}Zany Joker{} = {C:dark_edition}Negative{} {C:Attention}Zany Joker{}")
	end
	--[[SMODS.Consumable{
		key = f.key,
		pools = { ["OfficeSupplies"] = true },
		loc_txt = { name = f.color.." Floppy", text = {"Copy a joker"} },
		cost = 4,
		-- store color or other info for your logic if needed
		config = { color = f.color }
	}]]--
	SMODS.Consumable {
		set = "OfficeSuppliesConsumbableType",
		key = f.key,
		config = {
			max_highlighted = 1,
			is_used = false,
			color = string.lower(f.color),
			color_index = i
		},
		loc_vars = function(self, info_queue, card)
			-- Handle creating a tooltip with seal args.
			if f.inclusive then
				info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
			end
			-- Description vars
			return {vars = {(card.ability or self.config).max_highlighted, self.config.is_used, self.config.color}}
		end,
		loc_txt = {
			name = f.color.. ' Floppy Disk',
			text = description
		},
		cost = 4,
		atlas = "zbs_floppy_consumable",
		display_size = { w = 62, h = 62 },
		pos = {x=0, y=i - 1},
		pools = {["ZBSaddition"] = true, ["OfficeSuppliesPool"] = not f.inclusive},
		
		can_use = function(self, card)
			if #jokerHighlighted() == 1 then
				--card.children.center:set_sprite_pos({x = 1, y = 0})
				return true
			else
				--card.children.center:set_sprite_pos({x = 0, y = 0})
			end
		end,
		
		on_unhighlight = function(self, card, context)
			card.children.center:set_sprite_pos({x = 0, y = i - 1})
		end,
		
		update = function(self, card, dt)
			if (#jokerHighlighted() == 1 and card.highlighted == true) or card.ability.is_used == true then
				card.children.center:set_sprite_pos({x = 1, y = i - 1})
			else
				card.children.center:set_sprite_pos({x = 0, y = i - 1})
			end
			if not (card.edition and card.edition.zbs_subtle_poly) then
				if f.inclusive then
					--card:set_edition({ zbs_subtle_poly = true })
				end
			end
		end,
		
		calculate = function(self, card, context)
			if context.buying_card and context.card == card then
				if f.inclusive then
					--card:set_edition({ zbs_subtle_poly = true })
				end
			end
		end,
		
		use = function(self, card, area, copier)
			card.ability.is_used = true
			for i2 = 1, math.min(#jokerHighlighted(), card.ability.max_highlighted) do
				G.E_MANAGER:add_event(Event({func = function()
					play_sound('zbs_floppyuse')
					card:juice_up(0.3, 0.5)
					card.children.center:set_sprite_pos({x = 1, y = i - 1})
					print(i)
					return true end }))
				
				G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
					--G.hand.highlighted[1]:set_edition({ negative = true })
					print("creating new card")
					local newcard = SMODS.add_card({ key = 'j_zbs_floppy_joker', area = G.jokers })
					print(newcard)
					print(jokerHighlighted())
					print(jokerHighlighted()[1].config.center.key)
					newcard.ability.jokertocopy = jokerHighlighted()[1]
					newcard.ability.jokertocopykey = jokerHighlighted()[1].config.center.key
					newcard.ability.color = f.color
					newcard.ability.colorindex = i
					newcard.ability.inclusive = f.inclusive
					print(i)
					print(newcard.ability.colorindex)
					newcard.children.center:set_sprite_pos({x = 0, y = i - 1})
					--newcard:set_edition({ negative = false })
					newcard:set_edition(card.edition)
					print(G.jokers.cards[#G.jokers.cards])
					return true end }))
				
				delay(0.5)
			end
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
		end
	}
end

--[[SMODS.Consumable {
	set = "Tarot",
	key = "zbs_floppy",
	config = {
		max_highlighted = 1,
		is_used = false,
	},
	loc_vars = function(self, info_queue, card)
		-- Handle creating a tooltip with seal args.
		--info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		-- Description vars
		return {vars = {(card.ability or self.config).max_highlighted, self.config.is_used}}
	end,
	loc_txt = {
		name = 'Floppy Disk',
		text = {
			"Select {C:attention}#1#{} joker",
			"to copy"
		}
	},
	cost = 4,
	atlas = "zbs_floppy",
	display_size = { w = 62, h = 62 },
	pos = {x=0, y=0},
	pools = {["ZBSaddition"] = true, ["OfficeSupplies"] = true},
	
	can_use = function(self, card)
		if #jokerHighlighted() == 1 then
			--card.children.center:set_sprite_pos({x = 1, y = 0})
			return true
		else
			--card.children.center:set_sprite_pos({x = 0, y = 0})
		end
	end,
	
	on_unhighlight = function(self, card, context)
		card.children.center:set_sprite_pos({x = 0, y = 0})
	end,
	
	update = function(self, card, dt)
		if (#jokerHighlighted() == 1 and card.highlighted) or card.ability.is_used then
			card.children.center:set_sprite_pos({x = 1, y = 0})
		elseif not card.highlighted and card._was_highlighted then
			card.children.center:set_sprite_pos({x = 0, y = 0})
		end
	end,
	
	use = function(self, card, area, copier)
		card.ability.is_used = true
		for i = 1, math.min(#jokerHighlighted(), card.ability.max_highlighted) do
			G.E_MANAGER:add_event(Event({func = function()
				play_sound('zbs_floppyuse')
				card:juice_up(0.3, 0.5)
				card.children.center:set_sprite_pos({x = 1, y = 0})
				return true end }))
			
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
				--G.hand.highlighted[1]:set_edition({ negative = true })
				print("creating new card")
				local newcard = SMODS.add_card({ key = 'j_zbs_floppy_joker', area = G.jokers })
				print(newcard)
				print(jokerHighlighted())
				print(jokerHighlighted()[1].config.center.key)
				newcard.ability.jokertocopy = jokerHighlighted()[1]
				newcard.ability.jokertocopykey = jokerHighlighted()[1].config.center.key
				--newcard:set_edition({ negative = false })
				newcard:set_edition(card.edition)
				print(G.jokers.cards[#G.jokers.cards])
				return true end }))
			
			delay(0.5)
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
	end
}]]--

SMODS.Atlas{
	key = 'zbs_filezip',
	path = 'zbs_filezip.png',
	px = 62,
	py = 62,
}

SMODS.Sound({key = "crushzip", path = "crushzip.ogg",})
SMODS.Sound({key = "CRUSH", path = "CRUSH.ogg",})

SMODS.Consumable {
	set = "OfficeSuppliesConsumbableType",
	key = "zbs_zipfile",
	config = {
		max_highlighted = 1,
		extra = 'e_zbscompressed',
	},
	loc_vars = function(self, info_queue, card)
		-- Handle creating a tooltip with seal args.
		info_queue[#info_queue+1] = G.P_CENTERS.e_zbs_zbscompressed
		-- Description vars
		return {vars = {(card.ability or self.config).max_highlighted}}
	end,
	loc_txt = {
		name = 'Zip File',
		text = {
			"Select {C:attention}#1#{} card to",
			"become {C:dark_edition}Compressed{}"
		}
	},
	cost = 4,
	atlas = "zbs_filezip",
	display_size = { w = 62, h = 62 },
	pos = {x=0, y=0},
	pools = {["ZBSaddition"] = true, ["OfficeSuppliesPool"] = true},
	
	can_use = function(self, card)
		if #jokerHighlighted() == 1 then
			--card.children.center:set_sprite_pos({x = 1, y = 0})
			return true
		else
			--card.children.center:set_sprite_pos({x = 0, y = 0})
		end
	end,
	
	use = function(self, card, area, copier)
		for i = 1, math.min(#jokerHighlighted(), card.ability.max_highlighted) do
			G.E_MANAGER:add_event(Event({func = function()
				play_sound('zbs_CRUSH')
				card:juice_up(0.3, 0.5)
				return true end }))
			
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
				jokerHighlighted()[1]:set_edition({ zbs_zbscompressed = true })
				return true end }))
			
			delay(0.5)
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
	end
}