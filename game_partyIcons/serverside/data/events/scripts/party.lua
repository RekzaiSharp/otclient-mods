local OPCODE_PARTY = 160

function Party:onJoin(player)

	-- PARTY ICON START
	-- scuffed workaround because members only get populated after we returned true :/
	local _members = {}
	local leader = self:getLeader()

	table.insert(_members, {name = player:getName(), vocation = player:getVocation():getClientId(), pos = player:getPosition()})
	for _, member in ipairs(self:getMembers()) do
		table.insert(members, {name = member:getName(), vocation = member:getVocation():getClientId(), pos = member:getPosition()})
	end
	table.insert(_members, {name = leader:getName(), vocation = leader:getVocation():getClientId(), pos = leader:getPosition()})

	player:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "join", members = _members}))
	leader:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "join", members = _members}))

	for _, member in ipairs(self:getMembers()) do
		member:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "join", members = _members}))
	end

	player:registerEvent("partyUpdate")

	if #self:getMembers() == 0 then
		leader:registerEvent("partyUpdate")
	end
	-- PARTY ICON END

	return true
end

function Party:onLeave(player)
	-- PARTY ICON START
	local members = self:getMembers()

	for _, member in ipairs(members) do
		member:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "leave", name = player:getName()}))
	end
	self:getLeader():sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "leave", name = player:getName()}))

	player:unregisterEvent("partyUpdate")
	-- PARTY ICON END

	return true
end

function Party:onDisband()
	-- PARTY ICON START
	local members = self:getMembers()

	for _, member in ipairs(members) do
		member:sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "leave", name = member:getName()}))
		member:unregisterEvent("partyUpdate")
	end
	self:getLeader():sendExtendedOpcode(OPCODE_PARTY, json.encode({type = "leave", name = self:getLeader():getName()}))
	self:getLeader():unregisterEvent("partyUpdate")
	-- PARTY ICON END

	return true
end

function Party:onShareExperience(exp)
	local sharedExperienceMultiplier = 1.20 --20%
	local vocationsIds = {}

	local vocationId = self:getLeader():getVocation():getBase():getId()
	if vocationId ~= VOCATION_NONE then
		table.insert(vocationsIds, vocationId)
	end

	for _, member in ipairs(self:getMembers()) do
		vocationId = member:getVocation():getBase():getId()
		if not table.contains(vocationsIds, vocationId) and vocationId ~= VOCATION_NONE then
			table.insert(vocationsIds, vocationId)
		end
	end

	local size = #vocationsIds
	if size > 1 then
		sharedExperienceMultiplier = 1.0 + ((size * (5 * (size - 1) + 10)) / 100)
	end

	return (exp * sharedExperienceMultiplier) / (#self:getMembers() + 1)
end
