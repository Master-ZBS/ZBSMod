SMODS.Sound({key = "compressioneffect", path = "compressioneffect.ogg",})

SMODS.Shader({ key = 'compressed', path = 'compressed.fs' })

SMODS.Edition{ -- todo: remove all mentions of recalc_joker_slots()
	key = "zbscompressed",
	order = 2,
	weight = 13,
	in_shop = true,
	extra_cost = 3,
	
	config = {
		joker_slots = 0.5,
		card_limit = 0.5
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
        info_queue[#info_queue+1] = {key = 'zbsmod_annoyedrant', set = 'Other', vars = { ":(" }}
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
	end,
	get_weight = function(self)
		G.GAME.zbs = G.GAME.zbs or {}
		G.GAME.zbs.compression_rate = G.GAME.zbs.compression_rate or 1
		return G.GAME.zbs.compression_rate * self.weight
	end
}

SMODS.Shader({
    key = "negacomp",
    path = "negacomp.fs"
})

SMODS.Edition{
	key = "zbsnegacompressed",
	order = 3,
	weight = 2,
	in_shop = true,
	extra_cost = 10,
	
	config = {
		card_limit = 1.5
	},
	sound = {
		sound = "zbs_compressioneffect",
		per = 1,
		vol = 0.3,
	},
	
	loc_txt = {
		name = "Negative Compression",
		label = "Negative Compression",
		text = {
			"{C:blue}+1.5{} Joker slots"
		}
	},
	
	loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = {key = 'zbsmod_annoyedrant', set = 'Other', vars = { ":(" }}
		return {
			vars = {  }
		}
	end,
	
	shader = "negacomp",
	
	get_weight = function(self)
		G.GAME.zbs = G.GAME.zbs or {}
		G.GAME.zbs.compression_rate = G.GAME.zbs.compression_rate or 1
		return G.GAME.zbs.compression_rate * self.weight
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
