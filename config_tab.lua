-- Please don't sue me cartomancer devs

local ZBSMod = SMODS.current_mod

local create_column_tabs,
	  create_inline_slider,
	  create_toggle_option,
	  create_keybind,
	  create_text_line,
	  create_input_option,
	  create_inline_options,
	  create_option_cycle_custom

local slider_callbacks = {}

local create_UIBox_generic_options_custom = function (args)
	args = args or {}
	
	return {n=G.UIT.ROOT, config = {align = "cl", minw = G.ROOM.T.w*0.6, padding = 0.0, r = 0.1, 
									colour = args.bg_colour or {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}},
			nodes = {
			  {n=G.UIT.C, config={align = "cl", padding = 0, minw = args.minw or 5, minh = args.minh or 3},
				nodes = args.contents
			  },
		}
	}
end

local function is_chosen(tab)
  return ZBSMod.LAST_OPEN_TAB == tab
end

local function choose_tab(tab)
	ZBSMod.LAST_OPEN_TAB = tab
	if ZBSMod._recording_keybind and not (tab == "keybinds") then
		--ZBSMod.log "Switched settings tab, stopping recording keybind"
		ZBSMod._recording_keybind = nil
	end
end

local tab_config = {r = 0.1, align = "t", padding = 0.0, colour = G.C.CLEAR, minw = 8.5, minh = 6.6}

ZBSMod.config_tab = function()
	ZBSMod.INTERNAL_in_config = true
	--ZBSMod.log "Opened ZBSMod config"
	local vertical_tabs = {}
	
	choose_tab "regular_config"
	
	
	table.insert(vertical_tabs, {
		--label = localize('carto_settings_deck_view'),
		label = "regular config",
		chosen = is_chosen("regular_config"),
		tab_definition_function = function (...)
			
			--[[ZBSMod.deck_view_stack_x_color = ZBSMod.deck_view_stack_x_color or G.C.RED --or ZBSMod.hex_to_color(ZBSMod.SETTINGS.deck_view_stack_x_color)
			
			local update_color = function ()
				ZBSMod.SETTINGS.deck_view_stack_x_color = ZBSMod.color_to_hex(ZBSMod.deck_view_stack_x_color)
			end
			slider_callbacks['slider_red'] = update_color
			slider_callbacks['slider_green'] = update_color
			slider_callbacks['slider_blue'] = update_color]]
			
			choose_tab "regular_config"
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
	})
	
	table.insert(vertical_tabs, {
		--label = localize('carto_settings_compact_deck'),
		label = "card visuals",
		chosen = is_chosen("card_visuals"),
		tab_definition_function = function (...)
			
			--[[ZBSMod.deck_view_stack_x_color = ZBSMod.deck_view_stack_x_color or G.C.RED --or ZBSMod.hex_to_color(ZBSMod.SETTINGS.deck_view_stack_x_color)
			
			local update_color = function ()
				ZBSMod.SETTINGS.deck_view_stack_x_color = ZBSMod.color_to_hex(ZBSMod.deck_view_stack_x_color)
			end
			slider_callbacks['slider_red'] = update_color
			slider_callbacks['slider_green'] = update_color
			slider_callbacks['slider_blue'] = update_color]]
			
			choose_tab "card_visuals"
			return {n = G.UIT.ROOT, config = {r = 0.1, align = "tm", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0.1, align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "ph_handy_premade_presets",
									scale = 0.4,
									colour = G.C.WHITE,
									align = "cm",
								},
							},
						},
					},
					{ n = G.UIT.R, config = { padding = 0, align = "cm" }, nodes = {
						{
							n = G.UIT.T,
							config = {
							text = "These will require a game restart",
							shadow = false,
							scale = 0.15,
							colour = G.C.INACTIVE
							}
						}
						} 
					},
					--[[{n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
						{n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
							{ n = G.UIT.T, config = { text = "Use Poopy-Peter's design for Bob", scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
						}},
						{n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
							create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = ZBSMod_config, ref_value = 'robloxbob' },
						}},
					}},]]
					create_toggle_option {
						ref_value = 'robloxbob',
						text = "Use Poopy-Peter's design for Bob",
					},
				}}
		end
	})

	--[[table.insert(vertical_tabs, {
		label = localize('carto_settings_jokers'),
		chosen = is_chosen("jokers"),
		tab_definition_function = Cartomancer.jokers_visibility_menu
	})

	table.insert(vertical_tabs, {
		label = localize('carto_settings_flames'),
		chosen = is_chosen("flames"),
		tab_definition_function = function (...)
			local minw = 2
			local minh = 1
			local w = minw * 1.25
			local h = minh * 2.5

			Cartomancer._INTERNAL_gasoline = 5
			local scale = 0.4
			choose_tab "flames"
			return {n = G.UIT.ROOT, config = tab_config, nodes = {
				create_toggle_option {
					ref_value = 'flames_relative_intensity',
					localization = 'carto_flames_relative_intensity',
				},
				create_inline_slider({ref_value = 'flames_volume', localization = 'carto_flames_volume',}),

				{n = G.UIT.R, config = {align = "cl", padding = 0.2, colour = darken(G.C.L_BLACK, 0.1), r = 0.1}, nodes = {
					{n = G.UIT.C, config = {align = "cl", padding = 0}, nodes = {
						create_inline_slider({ref_value = 'flames_intensity_min', localization = 'carto_flames_intensity_min', max_value = Cartomancer._INTERNAL_max_flames_intensity, decimal_places = 1}),
						create_inline_slider({ref_value = 'flames_intensity_max', localization = 'carto_flames_intensity_max', max_value = Cartomancer._INTERNAL_max_flames_intensity, decimal_places = 1}),
						create_toggle_option {
							ref_value = 'flames_intensity_vanilla',
							localization = 'carto_flames_intensity_vanilla',
						},
					}},
					{n = G.UIT.C, config = {align = "cm", padding = 0}, nodes = {
						{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
							{n=G.UIT.C, config={align = "cr", minw = minw, minh =minh, r = 0.1,colour = G.C.UI_CHIPS, id = 'hand_chip_area_cart', emboss = 0.05}, nodes={
								{n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_chips_cart', object = Moveable(0,0,0,0), w = 0, h = 0, _w = w, _h = h}},
								{n=G.UIT.O, config={id = ':3_chips',object = DynaText({string = {{ref_table = {[":3"] = localize("carto_flames_chips") }, ref_value = ":3"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2})}},
								{n=G.UIT.B, config={w=0.1,h=0.1}},
							}},
							{n=G.UIT.C, config={align = "cm"}, nodes={
								{n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = scale * 2, colour = G.C.UI_MULT, shadow = true}},
							}},
							{n=G.UIT.C, config={align = "cl", minw = minw, minh=minh, r = 0.1,colour = G.C.UI_MULT, id = 'hand_mult_area_cart', emboss = 0.05}, nodes={
								{n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_mult_cart', object = Moveable(0,0,0,0), w = 0, h = 0, _w = w, _h = h}},
								{n=G.UIT.B, config={w=0.1,h=0.1}},
								{n=G.UIT.O, config={id = ':3_mult',object = DynaText({string = {{ref_table = {[":3"] = localize("carto_flames_mult") }, ref_value = ":3"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2})}},
							}}
						}},
						create_inline_slider({align = 'cm', ref_table = Cartomancer, ref_value = '_INTERNAL_gasoline', localization = 'carto_flames_gasoline', max_value = Cartomancer._INTERNAL_max_flames_intensity, decimal_places = 1}),
					}}
				}},
			}}
		end
	})


	table.insert(vertical_tabs, {
		label = localize('carto_settings_other'),
		chosen = is_chosen("other"),
		tab_definition_function = function (...)
			choose_tab "other"
			return {n = G.UIT.ROOT, config = tab_config, nodes = {
				create_toggle_option {
					ref_value = 'blinds_info',
					localization = 'carto_blinds_info_setting',
				},
				create_toggle_option {
					ref_value = 'dynamic_hand_align',
					localization = 'carto_dynamic_hand_align',
				},
				create_toggle_option {
					ref_value = 'improved_hand_sorting',
					localization = 'carto_improved_hand_sorting',
					callback = function () G.FUNCS.change_play_discard_position {to_key = G.SETTINGS.play_button_pos} end
				},
				create_toggle_option {
					ref_value = 'hide_tags',
					localization = 'carto_hide_tags',
					callback = function () Cartomancer.update_tags_visibility() end
				},
				create_toggle_option {
					ref_value = 'hide_consumables',
					localization = 'carto_hide_consumables',
				},
			}}
		end
	})

	table.insert(vertical_tabs, {
		label = localize('carto_settings_keybinds'),
		chosen = is_chosen("keybinds"),
		tab_definition_function = function (...)
			choose_tab "keybinds"
			return {n = G.UIT.ROOT, config = tab_config, nodes = {
				create_keybind {
					name = 'hide_joker',
					localization = 'carto_kb_hide_joker',
				},
				create_keybind {
					name = 'toggle_tags',
					localization = 'carto_kb_toggle_tags',
				},
				create_keybind {
					name = 'toggle_consumables',
					localization = 'carto_kb_toggle_consumables',
				},
				create_keybind {
					name = 'toggle_jokers',
					localization = 'carto_kb_toggle_jokers',
				},
				create_keybind {
					name = 'toggle_jokers_buttons',
					localization = 'carto_kb_toggle_jokers_buttons',
				},
			}}
		end
	})]]

	return create_UIBox_generic_options_custom({
		bg_colour = G.C.CLEAR,-- G.C.BLUE,
		contents = {
			{
				n = G.UIT.R,
				config = { padding = 0, align = "tl", minw = 9, colour = G.C.CLEAR },
				nodes = {
					create_column_tabs({
						tab_alignment = 'tl',
						tab_w = 11.5,
						tab_h = 4.3,-- this seems to not do shit?
						text_scale = 0.4,
						snap_to_nav = true,
						colour =  G.C.CLEAR,-- G.C.RED,
						tabs = vertical_tabs
					})
				}
			},
		}
	})
end

create_inline_slider = function (args)
	local args = args or {}

	if type(args.callback) == "function" then
		slider_callbacks[args.ref_value] = args.callback
	end

	local slider = create_slider({w = 3, h = 0.3, padding = -0.05,
								  ref_table = args.ref_table or Cartomancer.SETTINGS, ref_value = args.ref_value, min = args.min_value or 0, max = args.max_value or 100,
								  decimal_places = args.decimal_places})

	if args.localization then
		return {n=G.UIT.R, config={align = args.align or "cl", minh = 0.9, padding = 0.036}, nodes={
			{n=G.UIT.C, config={align = "cl", padding = 0}, nodes={
				{n=G.UIT.T, config={text = localize(args.localization),colour = G.C.UI.TEXT_LIGHT, scale = 0.36}},
			}},
			(slider)
		}}
	end

	return (slider)
end

create_option_cycle_custom = function (ref_value, localization, change_function, options)
	local options_loc = localize(options)

	local cycle = create_option_cycle({w = 2.75, label = localization and localize(localization),scale = 0.7, options = options_loc,
									   opt_callback = change_function, current_option = tonumber(Cartomancer.SETTINGS[ref_value])})

	cycle.config.padding = 0

	return
	{n = G.UIT.R, config = {align = "cl", padding = 0.05}, w = 0.4, colour = G.C.CHIPS, nodes = { 
		cycle
	}}
end

create_toggle_option = function (args)
	return {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
		{n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
			{ n = G.UIT.T, config = { text = args.text, scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
		}},
		{n = G.UIT.C, config = { align = "cr", padding = 0.05 }, nodes = {
			create_toggle{ col = true, label = "", scale = 0.70, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = args.ref_value, callback = args.callback },
		}},
	  }}
end

create_keybind = function (args)
	assert(args.name, "Missing `name` in create_keybind " .. Cartomancer.dump(args))

	local ref_table = {
		name = args.name,
		label = {
			text = Cartomancer.table_join_keys(Cartomancer.SETTINGS.keybinds[args.name], "+")
		},
	}

	local id = 'kb_'..args.name

	return 
	{n = G.UIT.R, config = {align = "cr", padding = 0.05}, nodes = {
		{n = G.UIT.C, config = { align = "cl", padding = 0 }, nodes = {
			{ n = G.UIT.T, config = { text = localize(args.localization), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
		}},
		{n = G.UIT.C, config = { align = "cr", padding = 0.05 }, nodes = {
			UIBox_button({id = id, ref_table = ref_table, colour = G.C.GREY, button = 'cartomancer_settings_change_keybind', label = {}, dynamic_label = ref_table.label,
													minh = 0.32, minw = 3, col = true, scale = 0.3,
			})
		}},
	}}
end

create_input_option = function (args)
	args = args or {}
	args.ref_table = args.ref_table or Cartomancer.SETTINGS

	return { n = G.UIT.R, config = {align = "cl", minw = 4, minh = 0.5, colour = G.C.CLEAR, padding = 0.05}, nodes = {
			args.localization and { n = G.UIT.T, config = {text = localize(args.localization), scale = .36, minw = 4, minh = 0.5, colour = G.C.WHITE} } or nil,
			create_text_input({ id = 'Input:'..args.ref_value, w = 2, max_length = args.max_length or 3, prompt_text = tostring(args.ref_table[args.ref_value]), ref_table = args.ref_table, ref_value = args.ref_value})
	}}
end

create_text_line = function(args)
	return { n = G.UIT.R, config = {align = "cl", minw = 4, minh = 0.5, padding = 0.05, colour = G.C.CLEAR}, nodes = {
			{ n = G.UIT.T, config = {text = localize(args.loc), scale = .36, minw = 4, minh = 0.5, colour = G.C.WHITE} },
	}}
end

create_column_tabs = function (args)
	args = args or {}
	args.colour = args.colour or G.C.CLEAR
	args.tab_alignment = args.tab_alignment or 'cl'
	args.opt_callback = args.opt_callback or nil
	args.scale = args.scale or 1
	args.tab_w = args.tab_w or 0
	args.tab_h = args.tab_h or 0
	args.text_scale = (args.text_scale or 0.5)
  
	local tab_buttons = {}
  
	for k, v in ipairs(args.tabs) do
	  if v.chosen then args.current = {k = k, v = v} end
	  local id = 'tab_but_'..(v.label or '')
	  tab_buttons[#tab_buttons+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
		UIBox_button({id = id, ref_table = v, button = 'cartomancer_settings_change_tab', label = {v.label},
												  minh = 0.8*args.scale, minw = 2.5*args.scale, col = true, choice = true, scale = args.text_scale,
												  chosen = v.chosen and 'vert', func = v.func, focus_args = {type = 'none'}})
	  }}
	end

	-- Tabs + Contents
	return {n=G.UIT.R, config={padding = 0.2, align = "cl", colour = args.colour,},

		nodes={
		  -- Tabs
		  {n=G.UIT.C, config={align = "cl", padding = 0.2, colour = G.C.CLEAR}, nodes=tab_buttons},
		  
		  -- Tab contents
		  {n=G.UIT.C, config={align = args.tab_alignment, padding = args.padding or 0.1, no_fill = true, minh = args.tab_h, minw = args.tab_w}, nodes={
			  {n=G.UIT.O, config={id = 'cartomancer_settings_tab_contents',
								  old_chosen = tab_buttons[1].nodes[1].nodes[1],
								  object = UIBox{definition = args.current.v.tab_definition_function(args.current.v.tab_definition_function_args),
												config = {offset = {x=0,y=0}}}}
			  }
		  }},
		}
	}
end