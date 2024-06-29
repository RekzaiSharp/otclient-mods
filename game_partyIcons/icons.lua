local OPCODE_POSITION = 136
local minimap = modules.game_minimap
local minimapWidget = nil


-- dirty code, needs to be one table and icons should be children of the name labels
local partyNames = {
}

local partyIcons = {

}

function init()
  connect(LocalPlayer, {
    onPositionChange = onSendPosition,
  })

  g_ui.displayUI('icons')
  minimapWidget = minimap.minimapWindow:recursiveGetChildById('minimap')
  ProtocolGame.registerExtendedOpcode(OPCODE_POSITION, onExtendedOpcode)
end
  
function terminate()
  disconnect(LocalPlayer, {
    onPositionChange = onSendPosition,
  })  

  ProtocolGame.unregisterExtendedOpcode(OPCODE_POSITION, onExtendedOpcode)
end


function onSendPosition()
  local player = g_game.getLocalPlayer()
  if not player:isPartyMember() then
    for name, widget in pairs(partyNames) do
      widget:destroy()
      partyNames[name] = nil
    end

    for name, widget in pairs(partyIcons) do
      widget:destroy()
      partyNames[name] = nil
    end
    return
  end
  
  -- we don't need to send the server anything besides an empty packet so this is obsolete
  local position = player:getPosition()
  
  local opcodeData = {
    x = position.x,
    y = position.y,
    z = position.z
  }
  
  local opcodeString = json.encode(opcodeData)
  
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
    protocolGame:sendExtendedOpcode(OPCODE_POSITION, opcodeString)
  else
    print("Error: ProtocolGame instance not found.")
  end
end

function onExtendedOpcode(protocol, code, buffer)
  local status, data =
        pcall(
            function()
                return json.decode(buffer)
            end
        )

    if not status then
        return false
    end

    displayPartyMembers(data)
end

-- needs to be changed to take client vocation id instead of server vocation name
function getIconByVocation(vocation)
  if vocation == "None" then
    return "icons/None"
  elseif vocation == "Knight" then
    return "icons/Knight"
  elseif vocation == "Paladin" then
    return "icons/Paladin" 
  elseif vocation == "Druid" then
    return "icons/Druid"
  elseif vocation == "Sorcerer" then
    return "icons/Sorcerer"
  else
    return "icons/None"
  end
end

-- needs a bit of refactoring
function displayPartyMembers(data)
  for name, widget in pairs(partyNames) do
    local found = false
    for _, member in pairs(data) do
      if member.name == name then
        found = true
        break
      end
    end

    if not found then
      widget:destroy()
      partyNames[name] = nil
    end
  end

  for _, member in pairs(data) do
    if g_game.getLocalPlayer():getName() ~= member.name then
      if not partyNames[member.name] then
        local widget = g_ui.createWidget("PlayerName", minimapWidget)
        local icon = g_ui.createWidget("PlayerIcon", minimapWidget)
        icon:setImageSource(getIconByVocation(member.vocation))
        widget:setText(member.name)
        partyNames[member.name] = widget
        partyIcons[member.name] = icon
      else
        local widget = partyNames[member.name]
        local pos = member.pos
        pos.z = minimapWidget:getCameraPosition().z
        minimapWidget:centerInPosition(widget, member.pos)
        widget:setMarginTop(-15)
  
        local icon = partyIcons[member.name]
        minimapWidget:centerInPosition(icon, member.pos)
      end
    end
  end
end