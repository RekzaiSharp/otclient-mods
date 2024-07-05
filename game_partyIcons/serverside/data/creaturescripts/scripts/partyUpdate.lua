local OPCODE_PARTY = 160

function onThink(creature, interval)
    local _data = {name = creature:getName(), pos = creature:getPosition()}
    local leader = creature:getParty():getLeader()
    local party = creature:getParty()

    if (#party:getMembers() > 0) then
        for _, member in ipairs(party:getMembers()) do
            member:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "update", player = _data}))
        end
    end

    if (creature ~= leader) then
        leader:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "update", player = _data}))
    end

    return true
end