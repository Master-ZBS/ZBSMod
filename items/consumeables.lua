SMODS.Atlas{
	key = 'zbs_depression',
	path = 'zbs_placeholder_tarot.png',
	px = 71,
	py = 95,
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