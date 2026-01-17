-- Booster Atlas
SMODS.Atlas{
	key = 'tequilaatlas',
	path = 'zbs_tequila.png',
	px = 80,
	py = 80,
}
SMODS.Atlas{
	key = 'boosteratlas',
	path = 'zbs_booster_atlas.png',
	px = 71,
	py = 95,
}

-- Tequila Pack 1
SMODS.Booster{
	key = 'zbs_booster_tequila',
	group_key = "zbs_tequila_pack",
	atlas = 'tequilaatlas', 
	pos = { x = 0, y = 0 },
	--discovered = true,
	loc_txt= {
		name = 'TEQUILA BOOSTER PACK',
		text = { "Pick {C:attention}#1#{} card out {C:attention}#2#{} jokers",
				"from the Tequila People!", },
		group_name = {":3"},
	},
	
	draw_hand = false,
	config = {
		extra = 3,
		choose = 1, 
	},
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	
	weight = 4,
	cost = 5,
	kind = "Tequilapack",
	
	create_card = function(self, card, i)
		ease_background_colour(HEX("ffac00"))
		return SMODS.create_card({
			set = "Tequila",
			area = G.pack_cards,
			skip_materialize = true,
		})
	end,
	select_card = 'jokers',
	
	in_pool = function() return true end
}

-- Office Supplies Pack 1
SMODS.Booster{
	key = 'zbs_booster_officesupplies1',
	group_key = "zbs_office_pack",
	atlas = 'boosteratlas', 
	pos = { x = 0, y = 0 },
	--discovered = true,
	loc_txt= {
		name = 'Office Drawer',
		text = { "Pick {C:attention}#1#{} card out {C:attention}#2#{} pieces of",
				"stationery from an office drawer", },
		group_name = {"Office Drawer"},
	},
	
	draw_hand = false,
	config = {
		extra = 3,
		choose = 1, 
	},
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	
	weight = 2,
	cost = 5,
	kind = "OfficeSupplyDrawer",
	
	--[[ create_card = function(self, card, i)
		ease_background_colour(HEX("ffac00"))
		local OFFICE_POOL = {}
		for k, v in pairs(G.P_CENTERS) do
			if v.pools and v.pools["OfficeSupplies"] then
				table.insert(OFFICE_POOL, k)
			end
		end
		
		print(OFFICE_POOL)
		print(#OFFICE_POOL)
		for k, v in pairs(OFFICE_POOL) do
			print(k, v)
		end
		
		local key = pseudorandom_element(
			OFFICE_POOL,
			pseudoseed("office_pack")
		)
		return SMODS.create_card({
			forced_key = key,
			area = G.pack_cards,
			skip_materialize = true
		})
	end, ]]--
	
	create_card = function(self, card, i)
		ease_background_colour(HEX("ffac00"))
		return SMODS.create_card({
			set = "OfficeSuppliesPool",
			area = G.pack_cards,
			skip_materialize = true,
		})
	end,
	select_card = 'consumeables',
	
	in_pool = function() return true end

}
