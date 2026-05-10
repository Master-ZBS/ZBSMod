SMODS.Atlas{
	key = 'zbs_estrogen',
	path = 'zbs_placeholder_tarot.png',
	px = 71,
	py = 95,
}

--SMODS.Sound({key = "depressionuse", path = "bentrigger.ogg",})

SMODS.Consumable {
	set = "Spectral",
	key = "zbs_estrogen",
	config = {
	},
	loc_vars = function(self, info_queue, card)
		-- Handle creating a tooltip with seal args.
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		-- Description vars
		return {vars = {(card.ability or self.config).max_highlighted, (card.ability or self.config).plural}}
	end,
	loc_txt = {
		name = 'Estrogen',
		text = {
			"All Kings and Jacks become Queens",
		}
	},
	cost = 4,
	atlas = "zbs_estrogen",
	pos = {x=0, y=0},
	pools = {["ZBSaddition"] = true},
	
	can_use = function(self, card)
		if #G.deck.cards > 0 then
			return true
		end
	end,
	
	use = function(self, card, area, copier)
		for k, v in ipairs(G.deck.cards) do
			print(v:get_id())
			if v:get_id() == 11 then
				SMODS.modify_rank(v, 1)
			end
			if v:get_id() == 13 then
				SMODS.modify_rank(v, -1)
			end
			print(v:get_id())
		end
	end
}