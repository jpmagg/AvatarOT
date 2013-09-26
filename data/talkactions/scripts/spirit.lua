function onSay(cid, words, param, channel)
local param = string.lower(param)
local spiriton = {["on"]={1}}
local spiritoff = {["off"]={2}}
local myOutfit = getCreatureOutfit(cid)

local config = {
		efeito = 48,
		storage = 120,
		mensagemon = "Spirit mode!",
		mensagemoff = "Normal mode!",
		outfitAirbender = 2,
		outfitAirbenderMale = {lookType = 413, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0, lookAddons = 0},
		outfitAirbenderFemale = {lookType = 407, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookTypeEx = 0, lookAddons = 0}
}

	if(param ~= "" and spiriton[param]) then
		if getPlayerStorageValue(cid, config.storage) <= 0 then
			if isInRange(getThingPos(cid), {x=1114,y=1091,z=8}, {x=1116,y=1093,z=8}) then
				if myOutfit.lookType == 410 or myOutfit.lookType == 387 then
					if getPlayerSex(cid) == 0 then
						doSetCreatureOutfit(cid, config.outfitAirbenderFemale, -1)
					else
						doSetCreatureOutfit(cid, config.outfitAirbenderMale, -1)
					end
					setPlayerStorageValue(cid, config.storage, 1)
					doCreatureSay(cid, config.mensagemon, TALKTYPE_ORANGE_1)
					doSendMagicEffect(getCreaturePosition(cid), config.efeito)
				end
			else
				doPlayerSendCancel(cid,"You can't turn on the Spirit mode here.")
			end
		else
			doPlayerSendCancel(cid,"You already are spirit.")
		end
	elseif(param ~= "" and spiritoff[param]) then
		if getPlayerStorageValue(cid, config.storage) >= 1 then
			if isInRange(getThingPos(cid), {x=1114,y=1091,z=8}, {x=1116,y=1093,z=8}) then
				doRemoveCondition(cid, CONDITION_OUTFIT)
				setPlayerStorageValue(cid, config.storage, 0)
				doCreatureSay(cid, config.mensagemoff, TALKTYPE_ORANGE_1)
			else
				doPlayerSendCancel(cid,"You can't turn off the Spirit mode here.")
			end
		else
			doPlayerSendCancel(cid,"You aren't a Spirit.")
		end
	else
		doPlayerSendCancel(cid,"Invalid param specified.")
	end
	return true	
end
