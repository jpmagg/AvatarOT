local config = {
	removeOnUse = "yes",
	usableOnTarget = "no", -- can be used on target? (fe. healing friend)
	splashable = "no",
	range = -1,
	realAnimation = "no", -- make text effect visible only for players in range 1x1
	multiplier = {
		health = 1.0,
		mana = 1.0
	}
}

config.removeOnUse = getBooleanFromString(config.removeOnUse)
config.usableOnTarget = getBooleanFromString(config.usableOnTarget)
config.splashable = getBooleanFromString(config.splashable)
config.realAnimation = getBooleanFromString(config.realAnimation)

local POTIONS = {
	[7618] = {empty = 7635, splash = 42, health = {100, 200}},
	[7588] = {empty = 7618, splash = 42, health = {200, 400}},
	[7591] = {empty = 7588, splash = 42, health = {500, 700}},
	[8473] = {empty = 7635, splash = 42, health = {800, 1000}},

	[7620] = {empty = 7591, splash = 47, mana = {0, 0}},
	[7589] = {empty = 7620, splash = 47, mana = {0, 0}},
	[7590] = {empty = 7589, splash = 47, mana = {0, 0}},
	[8472] = {empty = 7635, splash = 43, health = {200, 400}},
}

local exhaust = createConditionObject(CONDITION_EXHAUST)
setConditionParam(exhaust, CONDITION_PARAM_TICKS, (getConfigInfo('timeBetweenExActions') - 100))

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local potion = POTIONS[item.itemid]
	if(not potion) then
		return false
	end

	if(not isPlayer(itemEx.uid) or (not config.usableOnTarget and cid ~= itemEx.uid)) then
		if(not config.splashable) then
			return false
		end

		if(toPosition.x == CONTAINER_POSITION) then
			toPosition = getThingPosition(item.uid)
		end

		doDecayItem(doCreateItem(POOL, potion.splash, toPosition))
		doRemoveItem(item.uid, 0)
		if(not potion.empty or config.removeOnUse) then
			return true
		end

		if(fromPosition.x ~= CONTAINER_POSITION) then
			doCreateItem(potion.empty, fromPosition)
		else
			doPlayerAddItem(cid, potion.empty, 0)
		end

		return true
	end

	if(hasCondition(cid, CONDITION_EXHAUST)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUAREEXHAUSTED)
		return true
	end

	if(((potion.level and getPlayerLevel(itemEx.uid) < potion.level) or (potion.vocations and not isInArray(potion.vocations, getPlayerVocation(itemEx.uid)))) and
		not getPlayerCustomFlagValue(cid, PLAYERCUSTOMFLAG_GAMEMASTERPRIVILEGES))
	then
		doCreatureSay(itemEx.uid, "You can't do this.", TALKTYPE_ORANGE_1)
		return true
	end

	if(config.range > 0 and cid ~= itemEx.uid and getDistanceBetween(getThingPosition(cid), getThingPosition(itemEx.uid)) > config.range) then
		return false
	end

	local health = potion.health
	if(health and not doCreatureAddHealth(itemEx.uid, math.ceil(math.random(health[1], health[2]) * config.multiplier.health))) then
		return false
	end

	local mana = potion.mana
	if(mana and not doPlayerAddMana(itemEx.uid, math.ceil(math.random(mana[1], mana[2]) * config.multiplier.mana))) then
		return false
	end

	doSendMagicEffect(getThingPosition(itemEx.uid), CONST_ME_POFF)
	if(not config.realAnimation) then
		doCreatureSay(itemEx.uid, "I can't drink this!", TALKTYPE_ORANGE_1)
	else
		for i, tid in ipairs(getSpectators(getThingPosition(itemEx.uid), 1, 1)) do
			if(isPlayer(tid)) then
				doCreatureSay(itemEx.uid, "I can't drink this!", TALKTYPE_ORANGE_1, false, tid)
			end
		end
	end

	doAddCondition(cid, exhaust)
	doRemoveItem(item.uid, 0)
	if(not potion.empty or config.removeOnUse) then
		return true
	end

	if(fromPosition.x ~= CONTAINER_POSITION) then
		doCreateItem(potion.empty, fromPosition)
	else
		doPlayerAddItem(cid, potion.empty, 0)
	end

	return true
end
