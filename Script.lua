local playerCount = 0

local playerZoneGUID = "dea9dd"

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
local pioneeringDeckGUID = "9aa665"
local advancedPioneeringDeckGUID = "c7f175"

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

local playerZonePositions = {
    [1] = {position = {16.48, 1.55, -15.19}, rotation = {0.02, 180.05, 0.08}},
    [2] = {position = {2.57, 1.58, -8.86},  rotation = {359.94, 240.05, 0.05}},
    [3] = {position = {1.11, 1.58, 6.34}, rotation = {359.92, 299.97, 359.97}},
    [4] = {position = {13.51, 1.57, 15.25}, rotation = {359.98, 359.81, 359.92}},
    [5] = {position = {27.43, 1.55, 8.91}, rotation = {0.06, 60.38, 359.95}},
    [6] = {position = {28.91, 1.54, -6.31}, rotation = {0.08, 119.98, 0.03}},
}

local connectZonePositions = {

    [2] = {position = {0.37, 1.58, -0.02}, rotation = {359.92, 270.21, 0.02}},
    [3] = {position = {7.69, 1.57, 12.65}, rotation = {359.95, 330.04, 359.94}},
    [4] = {position = {22.28, 1.55, 12.64}, rotation = {0.02, 29.89, 359.93}},
    [5] = {position = {29.60, 1.54, 0.04}, rotation = {0.08, 90.08, 359.98}},
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
    UI.hide("setupWindow") --temporary!
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

    -- Deals 4 archive cards open to table left to right
    archiveDeckObject.shuffle()

    -- #1
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = 6.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #2
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = 0.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #3
    archiveDeckObject.takeObject({
        position = {x = 55.5, y = 1.67, z = -6.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #4
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
        position = {x = 62.25, y = 1.67, z = 21.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Prosperity mission
    ProsperityDeckObject.shuffle()
    ProsperityDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 15.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Conquest mission
    conquestDeckObject.shuffle()
    print(conquestDeckObject)
    conquestDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 9.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Pioneering mission cards #1-6 (dealt from left to right, per row)
    -- #1 (Overlord)
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = 2.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #2 (Infinite Riches)
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = -3.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #3 (Ascension OR Expansion)
    if advancedPioneering then
        pioneeringDeckObject.takeObject({
            position = {x = 66.75, y = 1.67, z = -9.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.destruct() end)
            end
        })

        for _, cardTable in ipairs(advancedPioneeringDeckObject.getObjects()) do
            print(cardTable)
            for _, cardTag in ipairs(cardTable.tags) do
                print(cardTag)
                if cardTag == "ascension" then
                    advancedPioneeringDeckObject.takeObject({
                        index = cardTable.index,
                        position = {x = 66.75, y = 1.67, z = -9.75},
                        callback_function = function(spawnedObject)
                            Wait.frames(function() spawnedObject.flip() end)
                        end
                    })
                    break
                end
            end
        end
    else
        pioneeringDeckObject.takeObject({
            position = {x = 66.75, y = 1.67, z = -9.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
    end
    -- #4 (Master Trader)
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 2.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #5 (Civilization)
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = -3.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #6 (King of Average OR Empire)
    if advancedPioneering then
        pioneeringDeckObject.takeObject({
            position = {x = 62.25, y = 1.67, z = -9.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.destruct() end)
            end
        })

        for _, cardTable in ipairs(advancedPioneeringDeckObject.getObjects()) do
            print(cardTable)
            for _, cardTag in ipairs(cardTable.tags) do
                print(cardTag)
                if cardTag == "king" then
                    advancedPioneeringDeckObject.takeObject({
                        index = cardTable.index,
                        position = {x = 62.25, y = 1.67, z = -9.75},
                        callback_function = function(spawnedObject)
                            Wait.frames(function() spawnedObject.flip() end)
                        end
                    })
                    break
                end
            end
        end
    else
        pioneeringDeckObject.takeObject({
            position = {x = 62.25, y = 1.67, z = -9.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
    end

    -- Advanced Pioneering random mission cards #7-9
    if advancedPioneering then
        advancedPioneeringDeckObject.shuffle()
        -- #7
        advancedPioneeringDeckObject.takeObject({
            position = {x = 66.75, y = 1.67, z = -15.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
        -- #8
        advancedPioneeringDeckObject.takeObject({
            position = {x = 66.75, y = 1.67, z = -21.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
        -- #9
        advancedPioneeringDeckObject.takeObject({
            position = {x = 62.25, y = 1.67, z = -15.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
    else
        -- Remove unused mission shadows
        destroyObject(getObjectFromGUID("83ab9a"))
        destroyObject(getObjectFromGUID("a73c21"))
        destroyObject(getObjectFromGUID("d6524d"))
    end
end