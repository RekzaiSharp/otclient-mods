local OPCODE_PARTY = 160

local minimap = modules.game_minimap
local minimapWidget = nil

-- Table for storing party members widgets
local partyMembers = {}

function init()
  print("Party Icons Loaded")
  g_ui.displayUI('icons')
  minimapWidget = minimap.minimapWindow:recursiveGetChildById('minimap')
  ProtocolGame.registerExtendedOpcode(OPCODE_PARTY, onPartyUpdate)
end
  
function terminate()
  ProtocolGame.unregisterExtendedOpcode(OPCODE_PARTY, onPartyUpdate)
end

function getIconByVocation(vocation)
  if vocation == 0 then
    return "icons/None"
  elseif vocation == 1 then
    return "icons/Knight"
  elseif vocation == 2 then
    return "icons/Paladin" 
  elseif vocation == 3 then
    return "icons/Druid"
  elseif vocation == 4 then
    return "icons/Sorcerer"
  else
    return "icons/None"
  end
end

function onPartyUpdate(protocol, opcode, buffer)
  print("OnPartyUpdate Called")
  local status, data =
    pcall(
    function()
      return json.decode(buffer)
    end
  )

  if not status then
      return false
  end

  if (data.type == "join") then
    for _, member in pairs(data.members) do
      print(member.name)
      if (member.name ~= g_game.getLocalPlayer():getName()) then
        if not partyMembers[member.name] then
          local widget = g_ui.createWidget("PlayerIcon", minimapWidget)
          widget:setImageSource(getIconByVocation(member.vocation))
          widget.name:setText(member.name)
          partyMembers[member.name] = widget
          minimapWidget:centerInPosition(widget, member.pos)
          widget.name:setMarginTop(-15)
          minimapWidget:centerInPosition(widget.name, member.pos)
        end
      end
    end
    return
  end


  if (data.type == "update") then
    if partyMembers[data.player.name] then
        local widget = partyMembers[data.player.name]
        local pos = data.player.pos
        pos.z = minimapWidget:getCameraPosition().z
        minimapWidget:centerInPosition(widget, data.player.pos)
        widget.name:setMarginTop(-15)
        minimapWidget:centerInPosition(widget.name, data.player.pos)
    end
    return
  end

  if (data.type == "leave") then
    if (data.name == g_game.getLocalPlayer():getName()) then
      for _, member in pairs(partyMembers) do
        member:destroy()
      end
      partyMembers = {}
    end
  else
    if partyMembers[data.name] then
      partyMembers[data.name]:destroy()
      partyMembers[data.name] = nil
    end
  end
  return
end