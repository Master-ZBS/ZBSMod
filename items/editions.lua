SMODS.Sound({key = "compressioneffect", path = "compressioneffect.ogg",})

SMODS.Shader({ key = 'compressed', path = 'compressed.fs' })

SMODS.Edition{
	key = "zbscompressed",
	order = 2,
	weight = 13,
	in_shop = true,
	extra_cost = 3,
	
	config = {
		joker_slots = 0.5
	},
	sound = {
		sound = "zbs_compressioneffect",
		per = 1,
		vol = 0.3,
	},
	
	loc_txt = {
		name = "Compression",
		label = "Compression",
		text = {
			"{C:blue}+0.5{} Joker slots"
		}
	},
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = { self.config.joker_slots }
		}
	end,
	
	shader = "compressed",
	
	on_apply = function(self, card)
		--if card.area == G.jokers then
			--G.jokers.config.card_limit = G.jokers.config.card_limit + 0.5 --self.config.joker_slots
			recalc_joker_slots()
		--end
	end,
	
	on_remove = function(self, card)
		--if card.area == G.jokers then
			--G.jokers.config.card_limit = G.jokers.config.card_limit - 0.5 --self.config.joker_slots
			recalc_joker_slots()
		--end
	end,
	calculate = function(self, card, context)
		if context.joker_removed then
			recalc_joker_slots()
		end
	end
}

local miscitems = {
    compressed_shader,
    compressed,
    }

return {
    name = "Misc.",
    items = miscitems,
}