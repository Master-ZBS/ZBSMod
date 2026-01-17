--new consumable :D
SMODS.Atlas{
	key = 'zbsundisoveredconsumable',
	path = 'zbs_swalla.png',
	px = 270,
	py = 270,
}

SMODS.ConsumableType{
	key = "OfficeSuppliesConsumbableType",
	primary_colour = G.C.SJ.SUPPLYPRIMARY,
	secondary_colour = G.C.SJ.SUPPLYSECONDARY,
	collection_rows = {4,4},
	
	loc_txt = {
		name = "Office Supply",
		collection = "Office Supplies",
		undiscovered = {
			name = "undicorverved",
			text = {"hey", "so like", "you need to discover me", ":3"}
		}
	},
	
	shop_rate = 5
}

SMODS.UndiscoveredSprite{
	key = "OfficeSuppliesConsumbableType",
	atlas = "zbsundisoveredconsumable",
	pos = {x = 0, y = 0}
}