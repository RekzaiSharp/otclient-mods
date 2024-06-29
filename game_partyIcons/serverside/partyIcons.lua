local OPCODE_PARTY = 136
local creatureEvent = CreatureEvent("partyLogin")
local ExtendedEvent = CreatureEvent("partyExtended")


function creatureEvent.onLogin(player)
    player:registerEvent("partyExtended")
    print("Registered partyExtended event")
    return true
end

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
    if opcode == OPCODE_PARTY then

        local party = player:getParty()
        if not party then
            return
        end
        local members = {}
        local leader = party:getLeader()
        local leaderName = leader:getName()
        
        if leader then
            table.insert(members, {name = leader:getName(), vocation = leader:getVocation():getName(), pos = leader:getPosition()})
        end
        
        for _, member in ipairs(party:getMembers()) do
            table.insert(members, {name = member:getName(), vocation = member:getVocation():getName(), pos = member:getPosition()})
        end

        for _, member in ipairs(party:getMembers()) do
            member:sendExtendedOpcode(OPCODE_PARTY, json.encode(members))
        end
        leader:sendExtendedOpcode(OPCODE_PARTY, json.encode(members))
        
    end
end

creatureEvent:type("login")
creatureEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()