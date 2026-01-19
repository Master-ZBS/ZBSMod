SampleJimbos = {}

ZBSMod_config = SMODS.current_mod.config or {}

-- ZBS joker pool
SMODS.ObjectType({
	key = "ZBSaddition",
	default = "j_reserved_parking",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})

-- Tequila joker pool
SMODS.ObjectType({
	key = "Tequila",
	default = "j_zbsbob",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})

-- Office consumeable pool
SMODS.ObjectType({
	key = "OfficeSuppliesPool",
	default = "c_zbs_nega",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})

-- SlotMachine joker pool
SMODS.ObjectType({
	key = "Gambling",
	default = "zbsbob",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		-- insert base game food jokers
	end,
})

-- what the font is going on
SMODS.Font({
	key = 'OldEnglish',
	path = 'OldEnglishFive.ttf',
	render_scale = 200,		 -- Base size in pixels (default: 200)
	TEXT_HEIGHT_SCALE = 0.83,   -- Line spacing (default: 0.83)
	TEXT_OFFSET = {x = 0, y = 0}, -- Alignment tweak (default: {0,0})
	FONTSCALE = 0.1,			-- Scale multiplier (default: 0.1)
	squish = 1,				 -- Horizontal stretch (default: 1)
	DESCSCALE = 1			   -- Description scale (default: 1)
})


local creditspage = {
		"Master ZBS",
		"(mod author, 99% of the work)",
		"",
		"Yahimod",
		"Borrowed most of code from",
		"",
		"The Tequila People",
		"Being great people",
		"{S:0.1,C:inactive}(most of the time)",
		"",
		"Ali (TheOneGoofAli / TOGA)",
		"Code contributions",
		"",
		"Too Richie Rich Schizo",
		"Playtesting",
	}

SMODS.current_mod.extra_tabs = function() --Credits tab
	local scale = 0.5
	return {
		label = "Credits",
		tab_definition_function = function()
		return {
			n = G.UIT.ROOT,
			config = {
			align = "cm",
			padding = 0.05,
			colour = G.C.CLEAR,
			},
			nodes = {
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "By Master ZBS",
					shadow = false,
					scale = scale*2,
					colour = G.C.PURPLE
					}
				}
				}
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Borrowed a lot of code from",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				},
				}
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm"
				},
				nodes = {
					{
					n = G.UIT.T,
					config = {
						text = "Yahimod",
						shadow = false,
						scale = scale,
						colour = G.C.MONEY
					}
					},
				}
				},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Small code contributions by",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				}
				},
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Ali (TheOneGoofAli / TOGA)",
					shadow = false,
					scale = scale,
					colour = G.C.GREEN
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Music from",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Kevin Macleod and Cryptid",
					shadow = false,
					scale = scale*0.75,
					colour = G.C.RED
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Special thanks:",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "Too Richie Rich Schizo and the funny man for playtesting",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.BLUE
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "and",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "YOU",
					shadow = false,
					scale = scale*2,
					colour = G.C.BLUE
					}
				}
				} 
			},
			{
				n = G.UIT.R,
				config = {
				padding = 0,
				align = "cm"
				},
				nodes = {
				{
					n = G.UIT.T,
					config = {
					text = "for checking this mod out",
					shadow = false,
					scale = scale*0.66,
					colour = G.C.INACTIVE
					}
				}
				} 
			},
			}
		}
		end
	}
end

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
		{n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
			{n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
				{ n = G.UIT.T, config = { text = "Print extra debug stuff that might clog up the output", scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = ZBSMod_config, ref_value = 'printdebugstuffthatmightclogtheoutput' },
			}},
		}},
	}}
end

local tick_timer = 0

-- Runs every frame, even in menu
function SMODS.Update(dt)
	tick_timer = tick_timer + dt
	
	if tick_timer >= 1 then
		tick_timer = tick_timer - 1
		
		-- Example logic: always update these flags
		player_in_game = (G.STATE == 5 or G.STATE == 999 or G.STATE == 7 or G.STATE == 3 or G.STATE == 1 or G.STATE == 2 or G.STATE == 19 or G.STATE == 8)
		if player_in_game and not next(SMODS.find_mod("Yahimod")) then
			update_exotic_theme(G.jokers)
		end
	end
end

--local zbsintroreplacement =
SMODS.Atlas{
	key = 'zbsintroreplacement',
	path = 'zbs_placeholder_intro.png',
	--px = 71,
	--py = 95,
	px = 2,
	py = 14,
}

local old_card_init = Card.init

function Card:init(X, Y, W, H, card_type, center, params)
	old_card_init(self, X, Y, W, H, card_type, center, params)

	-- We are in the title screen
	print(G.STATE)
	if G.STATE == 13 then
		-- Intro card has no center or ability
		print(self)
		--if not self.ability and not self.area then
			print("now checking center")
			-- Is using the joker atlas
			if self.children and self.children.center then
				local sprite = self.children.center
				if sprite.atlas and sprite.atlas.name and sprite.atlas.name == "Joker" then
				if ZBSMod_config and ZBSMod_config.printdebugstuffthatmightclogtheoutput and ZBSMod_config.printdebugstuffthatmightclogtheoutput == true then
				print("printing sprite")
				print(sprite)
				for i, v in pairs(sprite) do
					print(i,type(v),v)
				end
				print("printing other interesting stuff i wanna print")
				print("scale:", sprite.scale)
				for i, v in pairs(sprite.scale) do
					print(i,type(v),v)
				end
				print("alignment:", sprite.alignment)
				for i, v in pairs(sprite.alignment) do
					print(i,type(v),v)
				end
				print("offset:", sprite.offset)
				for i, v in pairs(sprite.offset) do
					print(i,type(v),v)
				end
				print("sprite_pos:", sprite.sprite_pos)
				for i, v in pairs(sprite.sprite_pos) do
					print(i,type(v),v)
				end
				print("sprite_pos_copy:", sprite.sprite_pos_copy)
				for i, v in pairs(sprite.sprite_pos_copy) do
					print(i,type(v),v)
				end
				print("FRAME:", sprite.FRAME)
				for i, v in pairs(sprite.FRAME) do
					print(i,type(v),v)
				end
				print("hover_offset:", sprite.hover_offset)
				for i, v in pairs(sprite.hover_offset) do
					print(i,type(v),v)
				end
				print("config:", sprite.config)
				for i, v in pairs(sprite.config) do
					print(i,type(v),v)
				end
				print("printing atlas")
				print(sprite.atlas)
				for i, v in pairs(sprite.atlas) do
					print(i,type(v),v)
				end
				--sprite.scale = {x = 71^2, y = 95^2}
				
				--sprite.atlas = zbsintroreplacement
				--sprite.atlas = G.ASSET_ATLAS["zbsintroreplacement"]
				print("printing my atlas")
				--print(zbsintroreplacement)
				--for i, v in pairs(zbsintroreplacement) do
				--	print(i,type(v),v)
				--end
				print("printing G.ASSET_ATLAS")
				print(G.ASSET_ATLAS)
				for i, v in pairs(G.ASSET_ATLAS) do
					print(i,type(v),v)
				end
				print("printing my atlas but it's G.ASSET_ATLAS")
				print(G.ASSET_ATLAS["zbs_zbsintroreplacement"])
				for i, v in pairs(G.ASSET_ATLAS["zbs_zbsintroreplacement"]) do
					print(i,type(v),v)
				end
				
				end
				print("alright, time to replace the atlas, here goes nothing!")
				sprite.atlas = G.ASSET_ATLAS["zbs_zbsintroreplacement"]
					sprite:set_sprite_pos({
						x = -0.5,
						y = -0.5
					})
				--sprite.atlas.px = 1
				--sprite.sprite_pos = {x = 1, y = 0}
				--sprite.scale = {x = 71^2, y = 95^2}
				
				end
			end
		end
	--end
end


assert(SMODS.load_file("globals.lua"))()

-- Load item files
local item_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "items")
for _, file in ipairs(item_src) do
	print("[ZBSMOD] Loading item file " .. file)
	assert(SMODS.load_file("items/" .. file))()
end

--Load lib files
local lib_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "libs")
for _, file in ipairs(lib_src) do
	print("[ZBSMOD] Loading lib file " .. file)
	assert(SMODS.load_file("libs/" .. file))()
end