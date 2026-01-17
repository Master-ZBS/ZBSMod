--- GLOBALS

G.C.SJ = {
	RED = HEX("FF0000"),
	BLACK = HEX("000000"),
	BLUE = HEX("0000FF"),
	GREEN = HEX("00FF00"),
	WHITE = HEX("FFFFFF"),
	TRANSPARENT = HEX("00000000"),
	SUPPLYPRIMARY = HEX("8B6B3E"),
	SUPPLYSECONDARY = HEX("D6C49A"),
}

-- Hooks

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end
	G.ARGS.LOC_COLOURS.sj_red = G.C.SJRED
	G.ARGS.LOC_COLOURS.sj_black = G.C.SJBLACK
	G.ARGS.LOC_COLOURS.sj_blue = G.C.SJBLUE
	G.ARGS.LOC_COLOURS.sj_green = G.C.SJGREEN
	G.ARGS.LOC_COLOURS.sj_white = G.C.SJWHITE
	G.ARGS.LOC_COLOURS.sj_transparent = G.C.SJTRANSPARENT
	G.ARGS.LOC_COLOURS.sj_supplyprimary = G.C.SJSUPPLYPRIMARY
	G.ARGS.LOC_COLOURS.sj_supplysecondary = G.C.SJSUPPLYSECONDARY
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

function jokerExists(abilityname)
	local _check = false
	if G.jokers and G.jokers.cards then
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.name == abilityname then _check = true end
			--if G.jokers.cards[i].ability.name == 'j_yahimod_subwaysurfers' then _check = true end
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

function recalc_joker_slots()
	if G.jokers and G.jokers.cards then
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

SMODS.Sound({key = "bwomp", path = "bwomp.ogg",})

SMODS.Sound({
	key = "music_exotic", 
	path = "music_exotic.ogg",
	pitch = 0.7,
	volume = 0.6,
	select_music_track = function()
		if jokerExists("j_zbs_zbsexponential") --[[and not player_in_shop]] then
			return true end
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
	path = "music_meowforward.ogg",
	pitch = 1,
	volume = 3,
	select_music_track = function()
		return G.STAGE == G.STAGES.MAIN_MENU
	end,
})