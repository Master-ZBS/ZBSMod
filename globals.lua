--- GLOBALS

G.C.ZBS = {
	RED = HEX("FF0000"),
	BLACK = HEX("000000"),
	BLUE = HEX("0000FF"),
	GREEN = HEX("00FF00"),
	WHITE = HEX("FFFFFF"),
	TRANSPARENT = HEX("00000000"),
	SUPPLYPRIMARY = HEX("8B6B3E"),
	SUPPLYSECONDARY = HEX("D6C49A"),
	--TequilaPRIMARY = HEX("8F6648"),
	TequilaPRIMARY = HEX("B89172"),
	--TequilaSECONDARY = HEX("C7D0EF"),
	TequilaSECONDARY = HEX("FDF7EB"),
}

-- Hooks

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end
	G.ARGS.LOC_COLOURS.zbs_red = G.C.RED
	G.ARGS.LOC_COLOURS.zbs_black = G.C.BLACK
	G.ARGS.LOC_COLOURS.zbs_blue = G.C.BLUE
	G.ARGS.LOC_COLOURS.zbs_green = G.C.GREEN
	G.ARGS.LOC_COLOURS.zbs_white = G.C.WHITE
	G.ARGS.LOC_COLOURS.zbs_transparent = G.C.TRANSPARENT
	G.ARGS.LOC_COLOURS.zbs_supplyprimary = G.C.SUPPLYPRIMARY
	G.ARGS.LOC_COLOURS.zbs_supplysecondary = G.C.SUPPLYSECONDARY
	G.ARGS.LOC_COLOURS.zbs_tequilaprimary = G.C.TequilaPRIMARY
	G.ARGS.LOC_COLOURS.zbs_tequilasecondary = G.C.TequilaSECONDARY
	return loc_colour_ref(_c, _default)
end

-- globals.lua
player_in_shop = false

-- This function will be called whenever context is available
function update_player_in_shop(context)
	if context and context.starting_shop then
		player_in_shop = true
	end
	if context and context.ending_shop then
		player_in_shop = false
	end
end

-- get id of joker
function getJokerID(card)
	if G.jokers then
		local _selfid = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then _selfid = i end
		end
		return _selfid
	end
end

function jokerExists(key)
	local _check = false
	if G.jokers and G.jokers.cards then
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.name == key then _check = true end
		end
	end
	return _check
end

function jokerWithPoolExists(pool)
	local _check = false
	if G.jokers and G.jokers.cards then
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools[pool] then
				_check = true
			end
		end
	end
	return _check
end

function jokerFromModExists(modcheck)
	local _check = false
	if G.jokers and G.jokers.cards then
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.mod and G.jokers.cards[i].config.center.mod.id and G.jokers.cards[i].config.center.mod.id == modcheck then
				_check = true
			end
		end
	end
	return _check
end

function jokerFromModExistsAndIsRareOrAbove(modcheck)
	local _check = false
	if G.jokers and G.jokers.cards then
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.mod and G.jokers.cards[i].config.center.mod.id and G.jokers.cards[i].config.center.mod.id == modcheck then
				if G.jokers.cards[i].config.center.rarity and G.jokers.cards[i].config.center.rarity >= 3 then
					_check = true
				end
			end
		end
	end
	return _check
end

function jokerHighlighted()
	local highlightedStuff = {}
	if G.jokers then
		for _, c in ipairs(G.jokers.cards) do
			if c.highlighted then
				table.insert(highlightedStuff, c)
			end
		end
	end
	--print("Highlighted count = " .. #highlightedStuff)
	return highlightedStuff
end

local beforebonus = 0

function recalc_joker_slots() -- useless as thing in edition config discovered
	if G.jokers and G.jokers.cards and false then
		G.GAME.zbs = G.GAME.zbs or {}
		G.GAME.zbs.storedbonus = G.GAME.zbs.storedbonus or 0
		local base = G.jokers.config.card_limit
		local bonus = 0
		--beforebonus = G.GAME.zbs.storedbonus
		
		for _, joker in ipairs(G.jokers.cards) do
			if joker.edition
			and joker.edition.key == 'e_zbs_zbscompressed' then
				bonus = bonus + 0.5
			end
		end
		
		G.jokers.config.card_limit = base + bonus - G.GAME.zbs.storedbonus
		--beforebonus = bonus
		G.GAME.zbs.storedbonus = bonus
	end
end

local old_remove = Card.remove
function Card:remove(...)
	local ret = old_remove(self, ...)
	recalc_joker_slots()
	return ret
end

--[[local old_card_draw = Card.draw
function Card:draw(...)
	local ret = old_card_draw(self, ...)
	-- send display size every frame
	local w, h = self.width or 100, self.height or 100
	if w ~= 100 then
		print(w,h)
	end
	if self.shader then
		self.shader:send("display_size", {w, h})
	end
	
	-- then do the usual drawing
	return ret
end]]--

--[[function displayimage(atlas, dx, dy, duration)
	local overlay = Sprite(
		G.ROOM.T.x + G.ROOM.T.w/2,
		G.ROOM.T.y + G.ROOM.T.h/2,
		256, 256,
		G.ASSET_ATLAS[atlas],
		{ x = dx, y = dy }
	)
	overlay:set_alignment({x = 0.5, y = 0.5})
	overlay.z = 100  -- make sure it's on top
	print("Printing children of G")
	for i,t in pairs(G) do
		print(i,t)
	end
	print("Printing children of G.ROOM")
	for i,t in pairs(G.ROOM) do
		print(i,t)
	end
	--print("Printing children of G.UI_ROOT")
	--for i,t in pairs(G.UI_ROOT) do
	--	print(i,t)
	--end
	G.ROOM_ATTACH:add(overlay)
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = duration,
		func = function()
			overlay:remove()
			return true
		end
	}))
end]]--

local display_timer = 0
local display_atlas = nil
local display_dx, display_dy

function show_image_on_screen(atlas_key, dx, dy, duration)
	display_atlas = G.ASSET_ATLAS[atlas_key]
	if not display_atlas then
		print("Missing atlas:", atlas_key)
		return
	end
	display_dx = dx or 0
	display_dy = dy or 0
	display_timer = duration or 0.25
end

-- This will be called every frame
SMODS.current_mod.on_update = function(dt)
	if display_timer > 0 then
		display_timer = display_timer - dt
	end
end

SMODS.current_mod.on_draw = function()
	if display_timer > 0 and display_atlas then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(
			display_atlas.texture,
			display_atlas.quads[1],
			love.graphics.getWidth()/2 + display_dx,
			love.graphics.getHeight()/2 + display_dy
		)
	end
end

function displayimage(atlas_key, dx, dy, duration)
	local atlas = G.ASSET_ATLAS[atlas_key]
	if not atlas then
		print("Missing atlas:", atlas_key)
		return
	end

	-- Create the sprite
	local overlay = Sprite(
		--G.ROOM.T.x + G.ROOM.T.w/2,
		--G.ROOM.T.y + G.ROOM.T.h/2,
		0,
		0,
		G.ROOM.T.w, G.ROOM.T.h,
		atlas,
		{ x = dx or 0, y = dy or 0 }
	)
	overlay:set_alignment({x = 0, y = 0})
	overlay.z = 10000

	-- Manually attach to the room (since add_child doesn't exist)
	if not G.ROOM.children then
		G.ROOM.children = {}
	end
	table.insert(G.ROOM.children, overlay)

	-- Remove after duration
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = duration or 0.25,
		func = function()
			-- remove manually from children table
			for i,child in ipairs(G.ROOM.children) do
				if child == overlay then
					table.remove(G.ROOM.children, i)
					break
				end
			end
			return true
		end
	}))
end

function addTequilaBadge(badges)
	badges[#badges+1] = create_badge("Tequila", G.C.ZBS.TequilaPRIMARY, G.C.ZBS.TequilaSECONDARY, 1.2 )
end

function getRanksInDeck()
	local ranks = {}
	local seen = {}
					
	for k, card in ipairs(G.deck.cards) do
		local rank = card:get_id()
		print(rank)
		if not seen[rank] then
			seen[rank] = true
			ranks[#ranks+1] = rank
		end
	end
	print(ranks)
	return ranks
end

rankNumToName = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"Jack",
	"Queen",
	"King",
	"Ace",
	"skibidi, skibidi, hawk tuah hawk",
}

function checkdebugprintsetting()
	return ZBSMod_config and ZBSMod_config.printdebugstuffthatmightclogtheoutput and ZBSMod_config.printdebugstuffthatmightclogtheoutput == true
end

--[[
function create_center_button()
	G.FUNCS.my_center_button = function()
		play_sound("zbs_bwomp")
		print("PRESSED")
	end
	
	local box = UIBox{
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm" -- center middle
			},
			nodes = {
				{
					n = G.UIT.BUTTON,
					config = {
						id = "my_center_button",
						func = "my_center_button",
						label = { "PRESS ME" },
						minw = 4,
						minh = 1.2
					}
				}
			}
		}
	}
	
	-- THIS is what makes it appear
	box.T.x = 0
	box.T.y = 0
	box.debug = true
	
	table.insert(G.ROOM_ATTACH, box)
end
]]--
SMODS.Sound({key = "bwomp", path = "bwomp.ogg",})

SMODS.Sound({
	key = "zbsmusic_zbstime",
	path = "music_balatgro_remix.ogg",
	pitch = 1,
	volume = 2.5,
	select_music_track = function()
		if jokerFromModExistsAndIsRareOrAbove("ZBSmod") --[[and not jokerWithPoolExists("Exotic")]] --[[and not player_in_shop]] then
			return true end
	end,
})

SMODS.Sound({
	key = "music_exotic", 
	path = "music_exotic.ogg",
	pitch = 0.7,
	volume = 0.6,
	select_music_track = function()
		if jokerWithPoolExists("Exotic") --[[and not player_in_shop]] then
			return true and 98 end
	end,
})

SMODS.Sound({
	key = "music_balatroifitwasgood", 
	path = "music_balatroifitwasgood.ogg",
	pitch = 1,
	volume = 2.5,
	select_music_track = function()
		if jokerExists("j_zbs_zbsplayb0i") --[[and not player_in_shop]] then
			return true and 99 end
	end,
})

-- thanks cryptid :3
SMODS.Sound({
	key = "music_meowforward",
	path = "music_meowforward.ogg",
	pitch = 1,
	volume = 1,
	select_music_track = function()
		return (	G.booster_pack
					and not G.booster_pack.REMOVED
					and SMODS.OPENED_BOOSTER
					and SMODS.OPENED_BOOSTER.config.center.kind == "Tequilapack"
		)	and 100
	end,
})

SMODS.Sound({
	key = "music_officeambient",
	path = "music_officeambient.ogg",
	pitch = 1,
	volume = 3,
	select_music_track = function()
		return (	G.booster_pack
					and not G.booster_pack.REMOVED
					and SMODS.OPENED_BOOSTER
					and SMODS.OPENED_BOOSTER.config.center.kind == "OfficeSupplyDrawer"
		)	and 100
	end,
})

SMODS.Sound({
	key = "zbsmusic_mainline",
	path = "music_balatgro_remix.ogg",
	pitch = 1,
	volume = 4,
	select_music_track = function()
		return G.STAGE == G.STAGES.MAIN_MENU
	end,
})