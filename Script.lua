local playerCount = 0

local alienDeckGUID = "e6fef2"
local advancedAlienDeckGUID = "5be236"
local guardianDeckGUID = "21cccc"
local advancedGuardianDeckGUID = "440784"

local archiveDeckGUID = "6b2a67"
local startCardDeckGUID = "ac5ebb"
local rewardDeckGUID = "ff7833"
local progressDeckGUID = "935e48"
local ProsperityDeckGUID = "5771e2"
local conquestDeckGUID = "f4ccdd"
local pioneeringDeckGUID = "3f46df"
local advancedPioneeringDeckGUID = "4b6ff9"

local exiledTokenBagGUID = "445eb7"
local abilityTokenBagGUID = "e98136"

local availablePlayerColors = {
    [1] = "Red",
    [2] = "Green",
    [3] = "Purple",
    [4] = "Blue",
    [5] = "Orange",
    [6] = "Brown"
}

--#region StartScreenOptions
local alternativeSetup = false
local advancedPioneering = false
local expansionRaces = false

function PlayerCountSelected(player, option, playerCountSelection)
    playerCount = option:sub(1, 1)
    log("Player count: " .. playerCount)
end

function AlternativeMapToggled(player, isOn)
    alternativeSetup = isOn;
    log("alternativeSetup: " .. alternativeSetup)
end

function AdvancedPioneeringToggled(player, isOn)
    advancedPioneering = isOn;
    log("advancedPioneering: " .. advancedPioneering)
end

function ExpansionRacesToggled(player, isOn)
    expansionRaces = isOn;
    log("expansionRaces: " .. expansionRaces)
end

function StartClicked(player)
    if  player.host then
        log('Start game!')
        UI.hide("setupWindow")
        SetPlayers()
        DealAliens()
        DetermineStartingPlayer()
        DealArchiveCards()
        DealMissionCards()
    else
        broadcastToAll("Only the host can start the game!", "Red")
    end
end
--#endregion

function onload()
    --UI.hide("setupWindow") --temporary!
end

function SetPlayers()
    for i, player in ipairs(Player.getPlayers()) do
        player.changeColor(availablePlayerColors[i]);
        --playerCount = playerCount + 1 -- Enable later and remove dropdown
    end
    print("Starting the game with " .. playerCount .. " players!")
end

function DealAliens()
    local alienDeckObject
    local guardianDeckObject

    if expansionRaces then
        alienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
        guardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)
    else
        alienDeckObject = getObjectFromGUID(alienDeckGUID)
        guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
    end
    
    alienDeckObject.shuffle()
    guardianDeckObject.shuffle()

    -- Left Exile
    alienDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 5.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end) -- Optional numberFrames, default = 1 frame
        end
    })
    
    -- Right Exile
    alienDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 12.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Warp Guardian
    guardianDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = -9.00}
    })

    -- Draft piles
    for i = 1, playerCount + 1, 1 do
        -- Counterclockwise alien pile
        alienDeckObject.takeObject({
            position = {x = -38.66, y = 1.67, z = -20.25}
        })
        -- Clockwise alien pile
        alienDeckObject.takeObject({
            position = {x = -38.66, y = 1.67, z = 20.25}
        })
    end
end

function DetermineStartingPlayer()
    local startPlayer = math.random(playerCount)
    broadcastToAll(availablePlayerColors[startPlayer] .. " is the starting player!", availablePlayerColors[startPlayer])
end

function DealArchiveCards()
    local startCardDeckObject = getObjectFromGUID(startCardDeckGUID)
    local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)

    -- Deal 1 start card to each seated player
    startCardDeckObject.deal(1) 
    startCardDeckObject.destruct()

    -- Deals 4 archive cards open to table
    archiveDeckObject.shuffle()
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = 6.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = 0.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = -6.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = -12.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
end

function DealMissionCards()
    local progressDeckObject = getObjectFromGUID(progressDeckGUID)
    local ProsperityDeckObject = getObjectFromGUID(ProsperityDeckGUID)
    local conquestDeckObject = getObjectFromGUID(conquestDeckGUID)
    local pioneeringDeckObject = getObjectFromGUID(pioneeringDeckGUID)
    local advancedPioneeringDeckObject = getObjectFromGUID(advancedPioneeringDeckGUID)

    -- Deal 3 mission cards open to table
    -- Progress mission
    progressDeckObject.shuffle()
    progressDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 18.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Prosperity mission
    ProsperityDeckObject.shuffle()
    ProsperityDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 12.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Conquest mission
    conquestDeckObject.shuffle()
    conquestDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 6.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Pioneering cards
    pioneeringDeckObject.shuffle()

    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = -0.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = -6.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = -12.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = -0.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = -6.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = -12.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    for _, card in pairs(advancedPioneeringDeckObject) do
        if card.hasTag(ascension) then
            card.takeObject({
                position = {x = 66.75, y = 1.67, z = -0.75},
                callback_function = function(spawnedObject)
                    Wait.frames(function() spawnedObject.flip() end)
                end
            })
        end
    end

end