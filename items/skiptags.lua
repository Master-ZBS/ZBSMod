-- Tag Atlas
SMODS.Atlas{
	key = 'zbstagatlas',
	path = 'zbs_tag_atlas.png',
	px = 32,
	py = 32,
}

SMODS.Tag{
	key = 'tag_zany',
	loc_txt= {
		name = 'Zany Tag',
		text = { "Immediately grants you a",
				"{C:attention}Zany Joker{} and upgrades",
				"{C:attention}Three of a Kind{} by",
				"{C:attention}#1# level#2#{}",
				}
		},
	atlas = 'zbstagatlas',
	pos = { x = 0, y = 0 },
	min_ante = 0,
	config = { extra = {amountoflevels = 2}, thepluralthing = "s"},
	
	update = function(self, card, dt)
		--why doesn't this work :(
		if card.config.extra.amountoflevels == 1 then
			card.ability.thepluralthing = ""
		else
			card.ability.thepluralthing = "s"
		end
			print(card.ability.thepluralthing)
	end,
	
	loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {key = 'zbsmod_zany', set = 'Other'}
		--info_queue[#info_queue+1] = G.P_CENTERS.j_zany
		--info_queue[#info_queue+1] = G.P_CENTERS.c_venus
		return {vars = {center.config.extra.amountoflevels, center.config.thepluralthing}}
	end,
	
	apply = function(self, tag, context)
		tag:yep('+', G.C.DARK_EDITION, print() )
			
			SMODS.add_card({ key = 'j_zany' })
			--SMODS.add_card({ key = 'c_venus' })
			SMODS.smart_level_up_hand(nil, "Three of a Kind", false, tag.config.extra.amountoflevels) 
			--play_sound('gold_seal')
		
		tag.triggered = true
		return true
	end,
}