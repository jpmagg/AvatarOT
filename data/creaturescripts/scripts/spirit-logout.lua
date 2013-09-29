function onLogout(cid)
	if not isCreature(cid) then return true 
    if getPlayerStorageValue(cid, SPIRIT_STORAGE) >= 1 then
      doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    end
  end
  return true
end
