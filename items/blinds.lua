SMODS.Atlas {
	key = "zbsblindatlas",
	path = "zbs_blindsatlas.png",
	px = 34,
	py = 34,
	frames = 1,
	atlas_table = 'ANIMATION_ATLAS'
}

function forceGameover()
	G.STATE = G.STATES.GAME_OVER
	G.STATE_COMPLETE = false
end

SMODS.Blind {
	name = "boss_timmie",
	key = "boss_timmie",
	atlas = "zbsblindatlas",
	pos = { y = 0 },
	dollars = 5,
	mult = 1.75,
	boss = { min = 1 },
	loc_txt = {
		name = "TiMMie179",
		text = {
			"Can't draw queens.",
			"Only I get the huzz!",
		}
	},
	boss_colour = HEX('0e1330'),

	drawn_to_hand = function(self)
		for i = 1, #G.hand.cards do
			local _discardthisone = false
			if G.hand.cards[i].base.value == "Queen" then _discardthisone = true end
			if _discardthisone == true then
				local _selected_card = G.hand.cards[i]
				G.hand:add_to_highlighted(_selected_card, true)
			end
		end
		G.FUNCS.discard_cards_from_highlighted(nil, true)
	end,
}

SMODS.Atlas {
	key = "zbsexterminate",
	path = "zbs_exterminationblind.png",
	px = 136,
	py = 136,
	frames = 1,
	atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
    name = "boss_extermination",
    key = "boss_extermination",
    atlas = "zbsexterminate",
    mult = 2,
    pos = { y = 0 },
    dollars = 10,
    loc_txt = {
        name = 'EXTERMINATION',
        text = {
            'Debuffs all',
            'Tequila Jokers',
        }
    },
    boss = {  min = 1 },
    boss_colour = HEX('8d867e'),

    recalc_debuff = function(self, card)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.pools and G.jokers.cards[i].config.center.pools.Tequila then
                G.jokers.cards[i]:set_debuff(true)
            end
        end
    end,

    disable = function(self)
       for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
       end
    end,

    defeat = function(self)
       for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
       end
    end,
}