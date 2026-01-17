SampleJimbos = {}

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
			}
			}
		}
		end
	}
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
