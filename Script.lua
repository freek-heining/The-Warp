
local abilityTokenBagGUID = "e98136"

-- Fixed colors in clockwise order
local availablePlayerColors = {
    [1] = "Red",
    [2] = "Green",
    [3] = "Purple",
    [4] = "Blue",
    [5] = "Orange",
    [6] = "Brown"
}

-- 1-6 players (position, rotation)
local playerZonePositions = {
    [1] = { {16.48, 1.55, -15.19}, {0.02, 180.05, 0.08} },
    [2] = { {2.57, 1.58, -8.86}, {359.94, 240.05, 0.05} },
    [3] = { {1.11, 1.58, 6.34}, {359.92, 299.97, 359.97} },
    [4] = { {13.51, 1.57, 15.25}, {359.98, 359.81, 359.92} },
    [5] = { {27.43, 1.55, 8.91}, {0.06, 60.38, 359.95} },
    [6] = { {28.91, 1.54, -6.31}, {0.08, 119.98, 0.03} },
}

-- 2-5 players (position, rotation)
local connectZonePositions = {
    [2] = { {0.37, 1.58, -0.02}, {359.92, 270.21, 0.02} },
    [3] = { {7.69, 1.57, 12.65}, {359.95, 330.04, 359.94} },
    [4] = { {22.28, 1.55, 12.64}, {0.02, 29.89, 359.93} },
    [5] = { {29.60, 1.54, 0.04}, {0.08, 90.08, 359.98} },
}

-- 1-6 players (position, rotation)
local energyZonePositions = {
    [1] = {31.70, 1.53, -40.84},
    [2] = {-11.80, 1.59, -40.85},
    [3] = {-45.20, 1.66, 40.84},
    [4] = {-1.70, 1.60, 40.84},
    [5] = {41.80, 1.54, 40.84},
    [6] = {75.20, 1.46, -40.85}
}

-- 1-6 players (position, rotation)
local goldZonePositions = {
    [1] = {26.32, 1.58, -40.81},
    [2] = {-17.18, 1.64, -40.81},
    [3] = {-39.82, 1.70, 40.81},
    [4] = {3.68, 1.64, 40.81},
    [5] = {47.18, 1.58, 40.81},
    [6] = {69.82, 1.52, -40.81},
}

--#region StartScreenOptions
local playerCount = 0
local TurnOrderTable = {} -- Stores the colors in playing order, for Turns.order, dealing archive cards and resources etc.
local alternativeSetup = false
local advancedPioneering = false
local expansionRaces = false

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
--#endregion

function onload()
    --MoveHandZones("+", 300) -- Move away temporary so nobody selects color manually
    UI.setAttribute("setupWindow", "active", false)
--end
end

function MoveHandZones(operation, moveValue)
    print("Moving hands with: " .. operation .. moveValue)
    local operations = {
        ["+"] = function(oldValue, moveValue) return oldValue + moveValue end,
        ["-"] = function (oldValue, moveValue) return oldValue - moveValue end
    }

    local RedHandZone = getObjectFromGUID("3feb12")
    local GreenHandZone = getObjectFromGUID("832b57")
    local PurpleHandZone = getObjectFromGUID("783920")
    local BlueHandZone = getObjectFromGUID("07898a")
    local OrangeHandZone = getObjectFromGUID("7261c8")
    local BrownHandZone = getObjectFromGUID("cc2c47")
    
    local redPos = RedHandZone.getPosition()
    RedHandZone.setPosition({operations[operation](redPos.x, moveValue), operations[operation](redPos.y, moveValue), operations[operation](redPos.z, moveValue)})
    local greenPos = GreenHandZone.getPosition()
    GreenHandZone.setPosition({operations[operation](greenPos.x, moveValue), operations[operation](greenPos.y, moveValue), operations[operation](greenPos.z, moveValue)})
    local purplePos = PurpleHandZone.getPosition()
    PurpleHandZone.setPosition({operations[operation](purplePos.x, moveValue), operations[operation](purplePos.y, moveValue), operations[operation](purplePos.z, moveValue)})
    local bluePos = BlueHandZone.getPosition()
    BlueHandZone.setPosition({operations[operation](bluePos.x, moveValue), operations[operation](bluePos.y, moveValue), operations[operation](bluePos.z, moveValue)})
    local orangePos = OrangeHandZone.getPosition()
    OrangeHandZone.setPosition({operations[operation](orangePos.x, moveValue), operations[operation](orangePos.y, moveValue), operations[operation](orangePos.z, moveValue)})
    local brownPos = BrownHandZone.getPosition()
    BrownHandZone.setPosition({operations[operation](brownPos.x, moveValue), operations[operation](brownPos.y, moveValue), operations[operation](brownPos.z, moveValue)})
end

function StartClicked(player)
    UI.setAttribute("startButton", "interactable", false) -- Prevents button spam
    Wait.time(function ()
        UI.setAttribute("startButton", "interactable", true)
    end, 2)

    SetPlayerCount() -- Sets player count according to the current amount of ingame player

    if not player.host then
        broadcastToAll("Only the host can start the game!", "Red")
    elseif playerCount < 2 then
        broadcastToAll("Need 2 players minimum to start!", "Red")
    else
        print("Starting the game with " .. playerCount .. " players!")

        UI.setAttribute("setupWindow", "active", false)
        
        local rewardDeckGUID = "ff7833"
        local rewardDeckObject = getObjectFromGUID(rewardDeckGUID)
        rewardDeckObject.shuffle()

        SetPlayerColors() -- Assigns colors/seats to players automatically (in order of joining the game)
        
        MoveHandZones("-", 300) -- Restores hand zones to orignal positions

        DetermineStartingPlayer() -- 

        Wait.time(function ()
            DealAliens()
        end, 1)
        
        Wait.time(function ()
            DealArchiveCards()
        end, 2.5)
        
        Wait.time(function ()
            DealMissionCards()
        end, 4)
        
        Wait.time(function ()
            startLuaCoroutine(Global, "CreateBoardCoroutine")
        end, 5.5)

        Wait.time(function ()
            startLuaCoroutine(Global, "DealResourcesCoroutine")
        end, 10)
    end
end

function SetPlayerCount()
    playerCount = 0

    for _, _ in ipairs(Player.getPlayers()) do
        playerCount = playerCount + 1
    end

    log("playerCount = " .. playerCount)
end

function SetPlayerColors()
    for i, player in ipairs(Player.getPlayers()) do
        player.changeColor(availablePlayerColors[i]);
    end
end

-- Sets starting player and color/turn order
function DetermineStartingPlayer()
    StartPlayerNumber = math.random(playerCount) -- Integer from 1 - playerCount. Red = 1, Green = 2, Purple = 3, Blue = 4, Orange = 5, Brown = 6
    local startPlayerColor = availablePlayerColors[StartPlayerNumber] -- Fixed color matching player numbers/seats
    
    broadcastToAll("[" .. startPlayerColor .. "] is the starting player!", startPlayerColor)
    
    local colorIndex = StartPlayerNumber -- Start with color/number of starting player, then continue clockwise from there 

    for i = 1, playerCount do -- Fills the array with colors in player order for this game
        TurnOrderTable[i] = availablePlayerColors[colorIndex]
        
        colorIndex = colorIndex + 1

        if  colorIndex > playerCount then -- If last color was reached, reset to use remaining colors from beginning of table
            colorIndex = 1
        end
    end

    log("TurnOrderTable:")
    log(TurnOrderTable)

    Turns.enable = true
    Turns.type = 2
    Turns.order = TurnOrderTable
    Turns.turn_color = startPlayerColor
end

function DealAliens()
    local alienDeckGUID = "e6fef2"
    local advancedAlienDeckGUID = "5be236"
    local guardianDeckGUID = "21cccc"
    local advancedGuardianDeckGUID = "440784"

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

function DealArchiveCards()
    local archiveDeckGUID = "6b2a67"
    local startCardDeckGUID = "ac5ebb"

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

    -- Deals 4 archive cards to players 1-3, and 5 cards to players 4-6 (if any)
    for i = 1, playerCount do
        if i < 4 then
            archiveDeckObject.deal(4, TurnOrderTable[i])
        else    
            archiveDeckObject.deal(5, TurnOrderTable[i])
        end
    end
end

-- Deals gold/energy to players according to table in manual:
-- Player 1: 4/4, Player 2: 5/4, Player 3: 5/5, Player 4: 5/5, Player 5: 6/5, Player 6: 6/6
function DealResourcesCoroutine()
    local energySpawnerGUID = "98a3fe"
    local goldSpawnerGUID = "0b18bb"

    local energySpawnerObject = getObjectFromGUID(energySpawnerGUID)
    local goldSpawnerObject = getObjectFromGUID(goldSpawnerGUID)

    local playerIndex = StartPlayerNumber -- Start with number of starting player, then continue clockwise from there 

    for i = 1, playerCount do
        -- Player 1
        if i == 1 then
            for _ = 1, 4 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 4 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
        -- Player 2
        elseif i == 2 then
            for _ = 1, 5 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 4 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
        -- Player 3 & 4
        elseif i == 3 or i ==4 then
            for _ = 1, 5 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 5 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
        -- Player 5
        elseif i == 5 then
            for _ = 1, 6 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 5 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
        -- Player 6
        elseif i == 6 then
            for _ = 1, 6 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 6 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerIndex]
                })
                for _ = 1, 20 do
                    coroutine.yield(0)
                end
            end
        end

        playerIndex = playerIndex + 1

        if  playerIndex > playerCount then -- If last player number was reached, reset to use remaining numbers from beginning of table
            playerIndex = 1
        end

        -- Wait X frames
        for _ = 1, 100 do
            coroutine.yield(0)
        end
    end

    return 1
end

function DealMissionCards()
    local progressDeckGUID = "935e48"
    local ProsperityDeckGUID = "5771e2"
    local conquestDeckGUID = "f4ccdd"
    local pioneeringDeckGUID = "9aa665"
    local advancedPioneeringDeckGUID = "c7f175"

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
            for _, cardTag in ipairs(cardTable.tags) do
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
            for _, cardTag in ipairs(cardTable.tags) do
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

function CreateBoardCoroutine()
    local playerZoneGUID = "dea9dd"
    local connectZoneGUID = "500df9"
    local centralZoneGUID = "9b6946"

    local playerZoneObject = getObjectFromGUID(playerZoneGUID)
    
    local connectZoneObject = getObjectFromGUID(connectZoneGUID)
    local centralZoneObject = getObjectFromGUID(centralZoneGUID)
    
    playerZoneObject.interactable = false
    centralZoneObject.interactable = false
    connectZoneObject.interactable = false

    for i = 2, playerCount, 1 do
        local clone = playerZoneObject.clone()
        clone.setPositionSmooth(playerZonePositions[i][1], false, false)
        clone.setRotationSmooth(playerZonePositions[i][2], false, false)
        clone.interactable = false
        
        local count = 0
        while count < 100 do
            count = count + 1
            coroutine.yield(0) -- Wait X frames between placing boards
        end
    end

    if playerCount < 6 then
        connectZoneObject.setPositionSmooth(connectZonePositions[playerCount][1], false, false)
        connectZoneObject.setRotationSmooth(connectZonePositions[playerCount][2], false, false)
    else
        connectZoneObject.destruct()
    end

    -- Wait 2 seconds before dealing exile tokens
    Wait.time(function ()
        DealExileTokens()
    end, 2)

    return 1
end

function DealExileTokens()
    local boardScriptingZoneGUID = "8a89e0"
    local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)
    
    local exiledTokenBagGUID = "445eb7"
    local exiledTokenBagObject = getObjectFromGUID(exiledTokenBagGUID)
    
    exiledTokenBagObject.shuffle()
    
    local objectsInZone = boardScriptingZoneObject.getObjects()

    for _, object in ipairs(objectsInZone) do
        for _, snapPointTable in pairs(object.getSnapPoints()) do
            if snapPointTable.tags[1] == "exile_open" then
                local localPos = snapPointTable.position
                local worldPos = object.positionToWorld(localPos)

                exiledTokenBagObject.takeObject({
                    position = { worldPos.x, worldPos.y, worldPos.z }
                })
            elseif snapPointTable.tags[1] == "exile_closed" then
                local localPos = snapPointTable.position
                local worldPos = object.positionToWorld(localPos)
                local localRot = exiledTokenBagObject.getRotation()
                            
                exiledTokenBagObject.takeObject({
                    position = { worldPos.x, worldPos.y+0.2, worldPos.z },
                    rotation = { localRot.x, localRot.y, localRot.z+180 }, -- Optional, defaults to the container's rotation.
                })
            end
        end
    end
end