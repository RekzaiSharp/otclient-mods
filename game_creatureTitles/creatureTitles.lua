
local titleFont = "verdana-11px-rounded"

local colors =
{
	["Elite"] = "#ababab", -- grey
	["Champion"] = "#c8ffab", -- green
	["Overlord"] = "#ffc982", -- orange
	["Insane"] = "#ff0000" -- red
}

local titles =
{
	["Elite"] = "Elite",
	["Champion"] = "Champion",
	["Overlord"] = "Overlord",
	["Insane"] = "Insane"
}

local insaneRanks =
{
	["1"] = "I",
	["2"] = "II",
	["3"] = "III",
	["4"] = "IV",
	["5"] = "V",
	["6"] = "VI",
	["7"] = "VII",
	["8"] = "VIII",
	["9"] = "IX",
	["10"] = "X"
}


function init()
  connect(Creature, {
    onAppear = showTitle,
  })
end

function terminate()

disconnect(Creature, {
    onAppear = showTitle,
  })  
end


function showTitle(creature)
	if creature:isMonster() then
		local finalTitle = ""
		for title, _ in pairs(titles) do
			if string.match(creature:getName(), title) then
				if title == "Insane" then
					local rank = string.match(creature:getName(), "%[(%d+)%]")
					if rank then
						finalTitle = title .. " " .. insaneRanks[rank]
						creature:setName(creature:getName():gsub(" Insane %[%d+%]", ""))
					end
				else
					finalTitle = title
					creature:setName(creature:getName():gsub(" " .. title, ""))
				end
				creature:setTitle(finalTitle, titleFont, colors[title])
			end
		end
	end
end