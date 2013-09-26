function isWaterNearby(cid)
    local pos = getThingPos(cid)
    local radius = 5 -- Aqui você coloca o raio de checagem a partir do jogador, ou seja, vai checar sem tem água em um quadrado radius x radius ao redor do jogador
    local waterId = {493,6838,4664,4665,6838,4666,6967,670,671,493, 6838, 4664, 4665, 6838, 4666, 6967, 670, 671, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4820, 4821, 4822, 4823, 4824, 4825, 6580, 6581, 6582, 6583, 6584, 6585, 6586, 6587, 6588, 6589, 6590, 6591, 6592, 6593, 6594, 6595, 6596, 6597, 6598, 6599, 6600, 6601, 6602, 6603, 6604, 6605, 6606, 6607, 6608}
           
    for x = pos.x - radius, pos.x + radius do
        for y = pos.y - radius, pos.y + radius do
            if isInArray(waterId, getThingFromPos({x=x, y=y, z=pos.z}).itemid) then
                return true
            end
        end
    end
    return false
end

function doDecayWaterBottle(cid)
    local u = false
    local waterContainers = {2006, 7636, 7634, 7635, 7618, 7588, 7591, 7620, 7589, 7590}
    for i = 2, #waterContainers do
        if getPlayerItemCount(cid, waterContainers[i]) > 0 then
            doPlayerRemoveItem(cid, waterContainers[i], 1)
            doPlayerAddItem(cid, waterContainers[i-1], 1)
            u = true
            break
        end
    end
return u
end
