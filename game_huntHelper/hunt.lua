local CODE_TOOLTIPS = 135

local window = nil
local mapWindow = nil
local selectedEntry = nil
local consoleEvent = nil
local sortedData = nil
local huntButton

local sortByLevelButtonPressed = false
local sortBySkillButtonPressed = false

function init()
    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = destroy
    })

    window = g_ui.displayUI('hunt')
    -- open a new window for map
    mapWindow = g_ui.displayUI('map')
    mapWindow:setVisible(false)
    window:setVisible(false)

    g_keyboard.bindKeyDown('Escape', hideWindowzz)
	taskButton = modules.client_topmenu.addLeftGameButton('huntButton', tr('Hunting Places'), '/mods/game_huntHelper/huntIconColorless', toggleWindow)
    ProtocolGame.registerExtendedOpcode(CODE_TOOLTIPS, onRecieveHuntingPlaces)

end

function terminate()
    disconnect(g_game, {
        onGameEnd = destroy
    })
    taskButton:destroy()
    ProtocolGame.unregisterExtendedOpcode(CODE_TOOLTIPS, onRecieveHuntingPlaces)
    destroy()
end

function onGameStart()
    if (window) then
        window:destroy()
        window = nil
    end

    if (mapWindow) then
        mapWindow:destroy()
        mapWindow = nil
    end



    window = g_ui.displayUI('hunt')
    window:setVisible(false)

    mapWindow = g_ui.displayUI('map')
    mapWindow:setVisible(false)
    window.listSearch.search.onKeyPress = onFilterSearch
end

function destroy()
    if (window) then
        window:destroy()
        window = nil
    end

    if (mapWindow) then
        mapWindow:destroy()
        mapWindow = nil
    end
end


function toggleWindow()
    if (not g_game.isOnline()) then
        return
    end

    if (window:isVisible()) then
        window:setVisible(false)
    else
        window:setVisible(true)
    end
end

function toggleMapWindow()
    if (not g_game.isOnline()) then
        return
    end

    if (mapWindow:isVisible()) then
        mapWindow:setVisible(false)
    else
        mapWindow:setVisible(true)
    end
end

function hideWindowzz()
    if (not g_game.isOnline()) then
        return
    end

    if (window:isVisible()) then
        window:setVisible(false)
    end
end

function onRecieveHuntingPlaces(protocol, opcode, buffer)
    local status, data =
        pcall(
            function()
                return json.decode(buffer)
            end
        )

    if not status then
        return false
    end

    sortAndFillSpots(data)
end

function getVocationById(id)
    if id == 0 then
        return "None"
    elseif id == 1 then
        return "Knight"
    elseif id == 2 then
        return "Paladin"
    elseif id == 3 then
        return "Sorcerer"
    elseif id == 4 then
        return "Druid"
    end
end

function getSkullByLevel(playerLevel, targetLevel)
    local levelDifference = math.abs(targetLevel - playerLevel) / playerLevel * 100
    
    if playerLevel >= targetLevel then
        return "easy"
    end

    if levelDifference <= 5 then
        return "easy"
    elseif levelDifference <= 10 then
        return "normal"
    elseif levelDifference <= 20 then
        return "hard"
    elseif levelDifference <= 30 then
        return "very hard"
    elseif levelDifference <= 40 then
        return "insane"
    else
        return "nightmare"
    end
end

function setMapLocation(location)
    mapWindow.mapPanel:setImageSource("img/" .. location)
    toggleMapWindow()
end

function onFilterSearch()
    local creatureString = window.listSearch.search:getText():lower()

    if creatureString == "" then
        fillSpots(sortedData)
        return
    end

    local filteredSpots = {}
    for _, entry in ipairs(sortedData.info) do
        local spot = entry.spot
        if spot.creatures and type(spot.creatures) == "table" then
            for _, creature in ipairs(spot.creatures) do
                if creature.name:lower():sub(1, #creatureString) == creatureString then
                    table.insert(filteredSpots, entry)
                    break
                end
            end
        end
    end

    if sortByLevelButtonPressed then
        sortByLevelButtonPressed = false
        window.listSearch.sortLevel:setColor("red")
    end

    local filteredData = {player = sortedData.player, info = filteredSpots}
    fillSpots(filteredData)
end

function sortAndFillSpots(data)
    local vocation = getVocationById(data.player.vocation)
    local sortedSpots = {}

    for name, spot in pairs(data.info) do
        if spot.recommended[vocation] then
            table.insert(sortedSpots, {name = name, spot = spot})
        end
    end

    table.sort(sortedSpots, function(a, b)
        return a.spot.recommended[vocation].level < b.spot.recommended[vocation].level
    end)

    sortedData = {player = data.player, info = sortedSpots}
    fillSpots(sortedData)
end

function sortByLevel()
    sortByLevelButtonPressed = not sortByLevelButtonPressed

    if sortByLevelButtonPressed then
        window.listSearch.sortLevel:setColor("green")
        local playerLevel = sortedData.player.level
        local filteredSpots = {}

        for _, entry in ipairs(sortedData.info) do
            local spot = entry.spot
            local recommendedLevel = spot.recommended[getVocationById(sortedData.player.vocation)].level
            local minLevel = math.floor(playerLevel * 0.8)
            local maxLevel = math.ceil(playerLevel * 1.2)

            if recommendedLevel >= minLevel and recommendedLevel <= maxLevel then
                table.insert(filteredSpots, entry)
            end
        end

        local filteredData = {player = sortedData.player, info = filteredSpots}
        fillSpots(filteredData)
    else
        window.listSearch.sortLevel:setColor("red")
        fillSpots(sortedData)
    end
end

function sortBySkills()
    sortBySkillButtonPressed = not sortBySkillButtonPressed

    if sortBySkillButtonPressed then
        window.listSearch.sortSkills:setColor("green")
        local playerLevel = sortedData.player.level
        local playerSkill = sortedData.player.skill
        local filteredSpots = {}

        for _, entry in ipairs(sortedData.info) do
            local spot = entry.spot
            local recommendedLevel = spot.recommended[getVocationById(sortedData.player.vocation)].level
            local recommendedSkills = spot.recommended[getVocationById(sortedData.player.vocation)].skill
            local minLevel = math.floor(playerLevel * 0.8)
            local maxLevel = math.ceil(playerLevel * 1.2)

            if recommendedLevel >= minLevel and recommendedLevel <= maxLevel and recommendedSkills <= playerSkill then
                table.insert(filteredSpots, entry)
            end
        end

        local filteredData = {player = sortedData.player, info = filteredSpots}
        fillSpots(filteredData)
    else
        window.listSearch.sortSkills:setColor("red")
        fillSpots(sortedData)
    end

    if sortByLevelButtonPressed then
        sortByLevelButtonPressed = false
        window.listSearch.sortLevel:setColor("red")
    end
end

function fillSpots(sortedData)
    local selectionList = window.spotPanel
    selectionList:destroyChildren()
    
    -- Adjusted to iterate over an array
    for _, entry in ipairs(sortedData.info) do
        local name = entry.name
        local spot = entry.spot
        local huntSpot = g_ui.createWidget("HuntPanel", window.spotPanel)
        huntSpot:setId(name)

        -- Set the Title
        local voc = getVocationById(sortedData.player.vocation)
        if (spot.recommended[voc].level <= sortedData.player.level) then
            huntSpot:setText("Recommended")
            huntSpot:setColor("green")
        else
            huntSpot:setText("Not Recommended")
            huntSpot:setColor("red")
        end

        -- Set Data
        huntSpot.centeredImage:setImageSource("img/skulls/" .. getSkullByLevel(sortedData.player.level, spot.recommended[voc].level))
        huntSpot.spotName:setText(spot.name)
        huntSpot.spotName:setTextAlign(AlignCenter)

        -- Set Stars
        huntSpot.expImage:setImageSource("img/stars/" .. spot.rank.exp)
        huntSpot.expImage:setWidth(spot.rank.exp * 10)
        huntSpot.lootImage:setImageSource("img/stars/" .. spot.rank.loot)
        huntSpot.lootImage:setWidth(spot.rank.loot * 10)

        -- Set Recommended Level and Skills
        huntSpot.reqLevel:setText(spot.recommended[voc].level)

        local skillText = ""
        if sortedData.player.vocation < 3 then
            skillText = spot.recommended[voc].skill .. "/" .. spot.recommended[voc].shielding
        else
            skillText = "N/A"
        end

        huntSpot.reqSkills:setText(skillText)

        -- Set Creatures
        for _, creature in pairs(spot.creatures) do
            local creaturePanel = g_ui.createWidget("CreatureIcon", huntSpot.creatureList)
            creaturePanel:setOutfit(creature.lookType)
            creaturePanel:setTooltip(creature.name)
        end

        -- Set Loot
        for _, loot in pairs(spot.loot) do
            if (loot.cid == 0) then
                break
            end
            local lootPanel = g_ui.createWidget("LootItem", huntSpot.notableLoot)
            lootPanel:setItemId(loot.cid)
            lootPanel:setTooltip(loot.name)
        end
    end
end