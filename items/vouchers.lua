-- these are vouchers or something

SMODS.Atlas{
	key = 'zbsvoucheratlas',
	path = 'zbs_voucher_atlas.png',
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = 'zbsplaceholdervoucher',
	path = 'zbs_placeholder_voucher.png',
	px = 71,
	py = 95,
}

-- increased production

SMODS.Voucher{
	key = 'zbs2xoffice',
	loc_txt= {
		name = 'Increased Supply',
		text = { "{V:1}Office Supplies{} appear",
				"{C:attention}2X{} more frequently",
				"in the shop"}
	},
	atlas = 'zbsplaceholdervoucher',
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	
	pos = {x=0, y= 0},
	config = {extra = {multiplier = 2}, keyofratetobemodified = "OfficeSuppliesConsumbableType"},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {colours = {G.C.ZBS.SUPPLYPRIMARY}, multiplier = center.ability.extra.multiplier, cardkey = center.ability.keyofratetobemodified}  }
	end,
	
	redeem = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				print(G.GAME[card.ability.keyofratetobemodified:lower() .. '_rate'])
				G.GAME[card.ability.keyofratetobemodified:lower() .. '_rate'] = card.ability.extra.multiplier * G.GAME[card.ability.keyofratetobemodified:lower() .. '_rate']
				return true
			end
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

SMODS.Voucher{
	key = 'zbs4xoffice',
	loc_txt= {
		name = 'Broken Charts',
		text = { "{V:1}Office Supplies{} appear",
				"{C:attention}4X{} more frequently",
				"in the shop"}
	},
	atlas = 'zbsplaceholdervoucher',
	pools = {["ZBSaddition"] = true},
    requires = { 'v_zbs_zbs2xoffice' },
	
	unlocked = true,
	discovered = false,
	
	pos = {x=0, y= 0},
	config = {extra = {multiplier = 2}, keyofratetobemodified = "OfficeSuppliesConsumbableType"},
	
	loc_vars = function(self, info_queue, center)
		print(G.GAME[center.ability.keyofratetobemodified:lower() .. '_rate'])
		return { vars = {colours = {G.C.ZBS.SUPPLYPRIMARY}, multiplier = center.ability.extra.multiplier, cardkey = center.ability.keyofratetobemodified}  }
	end,
	
	redeem = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME[card.ability.keyofratetobemodified:lower() .. '_rate'] = card.ability.extra.multiplier * G.GAME[card.ability.keyofratetobemodified:lower() .. '_rate']
				return true
			end
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

SMODS.Voucher{
	key = 'zbs2xcompressed',
	loc_txt= {
		name = 'WinRAR',
		text = { "{C:dark_edition}Compressed{} cards",
				"appear {C:attention}2X{} more often"}
	},
	atlas = 'zbsvoucheratlas',
	pools = {["ZBSaddition"] = true},
	
	unlocked = true,
	discovered = false,
	
	pos = {x=2, y= 0},
	config = {extra = {multiplier = 2}},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {multiplier = center.ability.extra.multiplier}  }
	end,
	
	redeem = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.zbs = G.GAME.zbs or {}
				G.GAME.zbs.compression_rate = G.GAME.zbs.compression_rate or 1
				G.GAME.zbs.compression_rate = card.ability.extra.multiplier * G.GAME.zbs.compression_rate
				return true
			end
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}

SMODS.Voucher{
	key = 'zbs4xcompressed',
	loc_txt= {
		name = '7-Zip',
		text = { "{C:dark_edition}Compressed{} cards",
				"appear {C:attention}4X{} more often"}
	},
	atlas = 'zbsvoucheratlas',
	pools = {["ZBSaddition"] = true},
    requires = { 'v_zbs_zbs2xcompressed' },
	
	unlocked = true,
	discovered = false,
	
	pos = {x=3, y= 0},
	config = {extra = {multiplier = 2}},
	
	loc_vars = function(self, info_queue, center)
		return { vars = {multiplier = center.ability.extra.multiplier}  }
	end,
	
	redeem = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.zbs = G.GAME.zbs or {}
				G.GAME.zbs.compression_rate = G.GAME.zbs.compression_rate or 1
				G.GAME.zbs.compression_rate = card.ability.extra.multiplier * G.GAME.zbs.compression_rate
				return true
			end
		}))
	end,
	
	check_for_unlock = function(self, args)
		if args.type == 'test' then --not a real type, just a joke
			unlock_card(self)
		end
		--unlock_card(self) --unlocks the card if it isnt unlocked
	end,
}