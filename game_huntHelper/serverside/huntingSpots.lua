local OPCODE = 135

local globalEvent = GlobalEvent("HuntingStartup")
local creatureEvent = CreatureEvent("HuntingLogin")

-- table with hunting spots data
local spots = {
    AlDeeRats = {
        name = "Al Dee Rat Cave",
        recommended = {
            ["None"] = {level = 1, skill = 10, shielding = 10}, -- None
        },
        location = "Al_Dee_Rats",
        creatures = {
            {name = "Rat", lookType = { type = 21, lookTypeEx = 21}}
        },
        rank = {
            exp = 1,
            loot = 1
        },
        loot =  {
            {name = "Cheese", cid = 0}
        }
    },
    RookBearCave = {
        name = "Rookgaard Bear Cave",
        recommended = {
            ["None"] = {level = 5, skill = 10, shielding = 10}, -- None
        },
        location = "Rook_Bear_Cave",
        creatures = {
            {name = "Bear", lookType = { type = 16, lookTypeEx = 16}}
        },
        rank = {
            exp = 1,
            loot = 1
        },
        loot =  {
            {name = "Bear Paw", cid = 0},
            {name = "Honeycomb", cid = 0}
        }
    },
    RookMinoHell = {
        name = "Rookgaard Minotaur Hell",
        recommended = {
            ["None"] = {level = 6, skill = 10, shielding = 10}, -- None
        },
        location = "Rook_Mino_Hell",
        creatures = {
            {name = "Minotaur", lookType = { type = 25, lookTypeEx = 25}}
        },
        rank = {
            exp = 1,
            loot = 1
        },
        loot =  {
            {name = "Minotaur Horn", cid = 0},
            {name = "Minotaur Leather", cid = 0},
            {name = "Chain Armor", cid = 0},
            {name = "Mace", cid = 0},
            {name = "Brass Helmet", cid = 0},
            {name = "Plate Shield", cid = 0}
        }
    },
    RookOrcFortress = {
        name = "Rookgaard Orc Fortress",
        recommended = {
            ["None"] = {level = 7, skill = 10, shielding = 10}, -- None
        },
        location = "Rook_Orc_Fortress",
        creatures = {
            {name = "Snake", lookType = { type = 28, lookTypeEx = 28}},
            {name = "Wasp", lookType = { type = 44, lookTypeEx = 44}},
            {name = "Orc", lookType = { type = 5, lookTypeEx = 5}}
        },
        rank = {
            exp = 1,
            loot = 1
        },
        loot =  {
            {name = "Orc Tooth", cid = 0},
            {name = "Orc Leather", cid = 0},
            {name = "Antlers", cid = 0},
            {name = "Honeycomb", cid = 0},
            {name = "Sabre", cid = 0}
        }
    },
    AncientTemple = {
        name = "Ancient Temple",
        recommended = {
            ["Knight"] = {level = 8, skill = 30, shielding = 30}, -- Knight
            ["Paladin"] = {level = 13, skill = 30, shielding = 20}, -- Paladin
            ["Druid"] = {level = 8, skill = 2, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 8, skill = 2, shielding = 0} -- Sorcerer
        },
        location = "Ancient_Temple",
        creatures = {
            {name = "Rotworm", lookType = { type = 26, lookTypeEx = 26}},
            {name = "Skeleton", lookType = { type = 33, lookTypeEx = 33}},
            {name = "Poison Spider", lookType = { type = 36, lookTypeEx = 36}},
            {name = "Ghoul", lookType = { type = 18, lookTypeEx = 18}}
        },
        rank = {
            exp = 2,
            loot = 2
        },
        loot =  {
            {name = "Mace", cid = 0},
            {name = "Pelvis Bone", cid = 0},
            {name = "Legion Helmet ", cid = 0},
            {name = "Poison Spider Shell", cid = 0}
        }
    },
    CarlinGraveyard = {
        name = "Carlin Graveyard",
        recommended = {
            ["Knight"] = {level = 8, skill = 15, shielding = 15}, -- Knight
            ["Paladin"] = {level = 8, skill = 15, shielding = 10}, -- Paladin
            ["Druid"] = {level = 8, skill = 5, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 8, skill = 0, shielding = 0} -- Sorcerer
        },
        location = "Carlin_Graveyard",
        creatures = {
            {name = "Troll", lookType = { type = 33, lookTypeEx = 33}}
        },
        rank = {
            exp = 2,
            loot = 2
        },
        loot =  {
            {name = "Bunch of Troll Hair", cid = 0},
            {name = "Leather Boots", cid = 0},
            {name = "Silver Amulet", cid = 0}
        }
    },
    DarashiaRotwormTop = {
        name = "Darashia Rotworm",
        recommended = {
            ["Knight"] = {level = 8, skill = 40, shielding = 40}, -- Knight
            ["Paladin"] = {level = 8, skill = 30, shielding = 10}, -- Paladin
            ["Druid"] = {level = 7, skill = 2, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 7, skill = 2, shielding = 0} -- Sorcerer
        },
        location = "Darashia_Rotworm_Top",
        creatures = {
            {name = "Rotworm", lookType = { type = 26, lookTypeEx = 26}}
        },
        rank = {
            exp = 2,
            loot = 2
        },
        loot =  {
            {name = "Mace", cid = 0},
            {name = "Legion Helmet ", cid = 0}
        }
    },
    DarashiaDarkPyramid = {
        name = "Dark Pyramid",
        recommended = {
            ["Knight"] = {level = 8, skill = 20, shielding = 20}, -- Knight
            ["Paladin"] = {level = 8, skill = 20, shielding = 10}, -- Paladin
            ["Druid"] = {level = 7, skill = 1, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 7, skill = 1, shielding = 0} -- Sorcerer
        },
        location = "Darashia_Dark_Pyramid",
        creatures = {
            {name = "Minotaur", lookType = { type = 34, lookTypeEx = 34}}
        },
        rank = {
            exp = 1,
            loot = 2
        },
        loot =  {
            {name = "Minotaur Horn", cid = 0},
            {name = "Minotaur Leather", cid = 0},
            {name = "Chain Armor", cid = 0},
            {name = "Mace", cid = 0},
            {name = "Brass Helmet", cid = 0},
            {name = "Plate Shield", cid = 0}
        }
    },
    DarashiaDeeperDarkPyramid = {
        name = "Deeper Dark Pyramid",
        recommended = {
            ["Knight"] = {level = 20, skill = 50, shielding = 50}, -- Knight
            ["Paladin"] = {level = 20, skill = 50, shielding = 50}, -- Paladin
            ["Druid"] = {level = 20, skill = 5, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 20, skill = 5, shielding = 0} -- Sorcerer
        },
        location = "Darashia_Deeper_Dark_Pyramid",
        creatures = {
            {name = "Minotaur", lookType = { type = 34, lookTypeEx = 34}},
            {name = "Minotaur Archer", lookType = { type = 35, lookTypeEx = 35}},
            {name = "Minotaur Guard", lookType = { type = 37, lookTypeEx = 37}},
            {name = "Minotaur Mage", lookType = { type = 38, lookTypeEx = 38}},
            {name = "Mummy", lookType = { type = 39, lookTypeEx = 39}}
        },
        rank = {
            exp = 2,
            loot = 2
        },
        loot =  {
            {name = "Minotaur Horn", cid = 0},
            {name = "Minotaur Leather", cid = 0},
            {name = "Wand of Cosmic Energy", cid = 0},
            {name = "Black Shield", cid = 0},
            {name = "Taurus Mace", cid = 0},
            {name = "Crystal Ring", cid = 0}
        }
    },
    EdronRotwormCave = {
        name = "Edron Rotworm Cave",
        recommended = {
            ["Knight"] = {level = 8, skill = 25, shielding = 25}, -- Knight
            ["Paladin"] = {level = 8, skill = 30, shielding = 10}, -- Paladin
            ["Druid"] = {level = 7, skill = 2, shielding = 0}, -- Druid
            ["Sorcerer"] = {level = 7, skill = 2, shielding = 0} -- Sorcerer
        },
        location = "Edron_Rotworm_Cave",
        creatures = {
            {name = "Rotworm", lookType = { type = 26, lookTypeEx = 26}}
        },
        rank = {
            exp = 2,
            loot = 1
        },
        loot =  {
            {name = "Mace", cid = 0},
            {name = "Legion Helmet ", cid = 0}
        }
    }
}
-- run function to insert loot dinamically on server load
function globalEvent.onStartup()
	insertLoot()
    insertLookTypes()
	return true
end

function insertLookTypes()
    for spot, data in pairs(spots) do
        for i = 1, #data.creatures do
            local creature = MonsterType(data.creatures[i].name)
            if (creature == nil) then
                print("[Hunting System] Error: Creature " .. data.creatures[i].name .. " not found.")
                break
            end
            data.creatures[i].lookType.type = creature:getOutfit().lookType
            data.creatures[i].lookType.lookTypeEx = creature:getOutfit().lookTypeEx
        end
    end

    print("[Hunting System] LookTypes dinamically loaded.")
end

function insertLoot()
    for spot, data in pairs(spots) do
        for i = 1, #data.loot do
            local item = ItemType(data.loot[i].name)
            data.loot[i].cid = item:getClientId()
        end
    end

    print("[Hunting System] Loot dinamically loaded.")
end

function creatureEvent.onLogin(player)

    local highestMelee = math.max(player:getSkillLevel(SKILL__SWORD), player:getSkillLevel(SKILL__AXE), player:getSkillLevel(SKILL__CLUB))
    
    local pInfo = {
        level = player:getLevel(),
        vocation = player:getVocation():getClientId(),
        skill = highestMelee,
        mlvl = player:getSkillLevel(SKILL__MAGLEVEL),
        shielding = player:getSkillLevel(SKILL__SHIELD)
    }

    player:sendExtendedOpcode(135, json.encode({player = pInfo, info = spots}))
    print("[Hunting System] Sent hunting spots data to " .. player:getName() .. ".")
    return true
end

globalEvent:register()
creatureEvent:register()