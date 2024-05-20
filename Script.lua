--#region DataTables
-- Fixed colors in clockwise order
local availablePlayerColors = { -- Fixed colors in clockwise order
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

local draftZonePositionsCW = {
    [1] = {-73.50, 15.61, 25.50},
    [2] = {-73.50, 15.62, 36.00},
    [3] = {-73.50, 15.62, 46.50},
    [4] = {-73.50, 15.62, 57.00},
    [5] = {-60.00, 15.59, 25.50},
    [6] = {-60.00, 15.60, 36.00},
    [7] = {-60.00, 15.60, 46.50},
    [8] = {-60.00, 15.60, 57.00}
}

local draftZonePositionsCCW = {
    [1] = {-73.50, 15.61, -57.00},
    [2] = {-73.50, 15.62, -46.50},
    [3] = {-73.50, 15.62, -36.00},
    [4] = {-73.50, 15.62, -25.50},
    [5] = {-60.00, 15.59, -57.00},
    [6] = {-60.00, 15.60, -46.50},
    [7] = {-60.00, 15.60, -36.00},
    [8] = {-60.00, 15.60, -25.50}
}
--#endregion

--#region StartScreenOptions
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

local playerCount = 0
local TurnOrderTable = {} -- Stores the colors in playing order, for Turns.order, dealing archive cards and resources etc.

function onload()
    SetInteractableFalse()
    --MoveHandZones("+", 300) -- Move away temporary so nobody selects color manually
    --UI.setAttribute("setupWindow", "active", false)
    --DealMissionCards()
end

function SetInteractableFalse() -- Initially sets a whole bunch of objects to interactable = false
    local abilityTokenBagGUID = "e98136"
    local abilityTokenBagObject = getObjectFromGUID(abilityTokenBagGUID)
    abilityTokenBagObject.interactable = false

    local exiledTokenBagGUID = "445eb7"
    local exiledTokenBagObject = getObjectFromGUID(exiledTokenBagGUID)
    exiledTokenBagObject.interactable = false

    local boardScriptingZoneGUID = "8a89e0"
    local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)
    boardScriptingZoneObject.interactable = false

    local playerZoneGUID = "dea9dd"
    local connectZoneGUID = "500df9"
    local centralZoneGUID = "9b6946"
    local portalGUID = "9aecf3"
    local playerZoneObject = getObjectFromGUID(playerZoneGUID)
    local connectZoneObject = getObjectFromGUID(connectZoneGUID)
    local centralZoneObject = getObjectFromGUID(centralZoneGUID)
    local portalObject = getObjectFromGUID(portalGUID)
    playerZoneObject.interactable = false
    centralZoneObject.interactable = false
    connectZoneObject.interactable = false
    portalObject.interactable = false

    local alienDeckGUID = "e6fef2"
    local advancedAlienDeckGUID = "5be236"
    local guardianDeckGUID = "21cccc"
    local advancedGuardianDeckGUID = "440784"
    local alienDeckObject = getObjectFromGUID(alienDeckGUID)
    local advancedAlienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
    local guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
    local advancedGuardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)
    alienDeckObject.interactable = false
    advancedAlienDeckObject.interactable = false
    guardianDeckObject.interactable = false
    advancedGuardianDeckObject.interactable = false

    local draftZoneClockwiseGUID = "e407b4"
    local draftZoneCounterClockwiseGUID = "2968a3"
    local draftZoneClockwiseObject = getObjectFromGUID(draftZoneClockwiseGUID)
    local draftZoneCounterClockwiseObject = getObjectFromGUID(draftZoneCounterClockwiseGUID)
    draftZoneClockwiseObject.interactable = false
    draftZoneCounterClockwiseObject.interactable = false

    local archiveDeckGUID = "6b2a67"
    local startCardDeckGUID = "ac5ebb"
    local startCardDeckObject = getObjectFromGUID(startCardDeckGUID)
    local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)
    startCardDeckObject.interactable = false
    archiveDeckObject.interactable = false

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
    progressDeckObject.interactable = false
    conquestDeckObject.interactable = false
    ProsperityDeckObject.interactable = false
    pioneeringDeckObject.interactable = false
    advancedPioneeringDeckObject.interactable = false

    local alienShadowRedLGUID = "3d9c76"
    local alienShadowRedRGUID = "656ba9"
    local alienShadowGreenLGUID = "c207c2"
    local alienShadowGreenRGUID = "ea4eae"
    local alienShadowPurpleLGUID = "57d762"
    local alienShadowPurpleRGUID = "e1e3cd"
    local alienShadowBlueLGUID = "4c4584"
    local alienShadowBlueRGUID = "c20bac"
    local alienShadowOrangeLGUID = "ac7bde"
    local alienShadowOrangeRGUID = "395d2b"
    local alienShadowBrownLGUID = "7dfdb7"
    local alienShadowBrownRGUID = "41881e"
    local alienShadowRedLObject = getObjectFromGUID(alienShadowRedLGUID)
    local alienShadowRedRObject = getObjectFromGUID(alienShadowRedRGUID)
    local alienShadowGreenLObject = getObjectFromGUID(alienShadowGreenLGUID)
    local alienShadowGreenRObject = getObjectFromGUID(alienShadowGreenRGUID)
    local alienShadowPurpleLObject = getObjectFromGUID(alienShadowPurpleLGUID)
    local alienShadowPurpleRObject = getObjectFromGUID(alienShadowPurpleRGUID)
    local alienShadowBlueLObject = getObjectFromGUID(alienShadowBlueLGUID)
    local alienShadowBlueRObject = getObjectFromGUID(alienShadowBlueRGUID)
    local alienShadowOrangeLObject = getObjectFromGUID(alienShadowOrangeLGUID)
    local alienShadowOrangeRObject = getObjectFromGUID(alienShadowOrangeRGUID)
    local alienShadowBrownLObject = getObjectFromGUID(alienShadowBrownLGUID)
    local alienShadowBrownRObject = getObjectFromGUID(alienShadowBrownRGUID)
    alienShadowRedLObject.interactable = false
    alienShadowRedRObject.interactable = false
    alienShadowGreenLObject.interactable = false
    alienShadowGreenRObject.interactable = false
    alienShadowPurpleLObject.interactable = false
    alienShadowPurpleRObject.interactable = false
    alienShadowBlueLObject.interactable = false
    alienShadowBlueRObject.interactable = false
    alienShadowOrangeLObject.interactable = false
    alienShadowOrangeRObject.interactable = false
    alienShadowBrownLObject.interactable = false
    alienShadowBrownRObject.interactable = false

    local guardianShadowGUID = "70bc1a"
    local exiledShadowGUID = "b19cd4"
    local guardianShadowObject = getObjectFromGUID(guardianShadowGUID)
    local exiledShadowObject = getObjectFromGUID(exiledShadowGUID)
    guardianShadowObject.interactable = false
    exiledShadowObject.interactable = false

    local archiveDiscardShadowGUID = "1be9a4"
    local archiveShadow1GUID = "cbd643"
    local archiveShadow2GUID = "5fc440"
    local archiveShadow3GUID = "6aa2c1"
    local archiveShadow4GUID = "b2570f"
    local archiveShadow5GUID = "e4369c"
    local archiveDiscardShadowObject = getObjectFromGUID(archiveDiscardShadowGUID)
    local archiveShadow1Object = getObjectFromGUID(archiveShadow1GUID)
    local archiveShadow2Object = getObjectFromGUID(archiveShadow2GUID)
    local archiveShadow3Object = getObjectFromGUID(archiveShadow3GUID)
    local archiveShadow4Object = getObjectFromGUID(archiveShadow4GUID)
    local archiveShadow5Object = getObjectFromGUID(archiveShadow5GUID)
    archiveDiscardShadowObject.interactable = false
    archiveShadow1Object.interactable = false
    archiveShadow2Object.interactable = false
    archiveShadow3Object.interactable = false
    archiveShadow4Object.interactable = false
    archiveShadow5Object.interactable = false

    local progressShadowGUID = "f04256"
    local prosperityShadowGUID = "0dc042"
    local conquestShadowGUID = "1decb4"
    local progressShadowObject = getObjectFromGUID(progressShadowGUID)
    local prosperityShadowObject = getObjectFromGUID(prosperityShadowGUID)
    local conquestShadowObject = getObjectFromGUID(conquestShadowGUID)
    progressShadowObject.interactable = false
    prosperityShadowObject.interactable = false
    conquestShadowObject.interactable = false

    local missionShadow1GUID = "743ef0"
    local missionShadow2GUID = "529334"
    local missionShadow3GUID = "a01105"
    local missionShadow4GUID = "2a3ed7"
    local missionShadow5GUID = "770d1f"
    local missionShadow6GUID = "ee3bd8"
    local missionShadow7GUID = "83ab9a"
    local missionShadow8GUID = "a73c21"
    local missionShadow9GUID = "d6524d"
    local missionShadow1Object = getObjectFromGUID(missionShadow1GUID)
    local missionShadow2Object = getObjectFromGUID(missionShadow2GUID)
    local missionShadow3Object = getObjectFromGUID(missionShadow3GUID)
    local missionShadow4Object = getObjectFromGUID(missionShadow4GUID)
    local missionShadow5Object = getObjectFromGUID(missionShadow5GUID)
    local missionShadow6Object = getObjectFromGUID(missionShadow6GUID)
    local missionShadow7Object = getObjectFromGUID(missionShadow7GUID)
    local missionShadow8Object = getObjectFromGUID(missionShadow8GUID)
    local missionShadow9Object = getObjectFromGUID(missionShadow9GUID)
    missionShadow1Object.interactable = false
    missionShadow2Object.interactable = false
    missionShadow3Object.interactable = false
    missionShadow4Object.interactable = false
    missionShadow5Object.interactable = false
    missionShadow6Object.interactable = false
    missionShadow7Object.interactable = false
    missionShadow8Object.interactable = false
    missionShadow9Object.interactable = false
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

function StartClicked(player) -- Calls most setup functions and handles their timing/order
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
        
        local abilityTokenBagGUID = "e98136"
        local abilityTokenBagObject = getObjectFromGUID(abilityTokenBagGUID)
        abilityTokenBagObject. interactable = true
        abilityTokenBagObject.shuffle()

        local rewardDeckGUID = "ff7833"
        local rewardDeckObject = getObjectFromGUID(rewardDeckGUID)
        rewardDeckObject.shuffle()

        SetPlayerColors() -- Assigns colors/seats to players automatically (in order of joining the game)
        
        --MoveHandZones("-", 300) -- Restores hand zones to orignal positions

        DetermineStartingPlayer() -- 

        Wait.time(function ()
            startLuaCoroutine(Global, "DealAliensCoroutine")
        end, 1)
        
        Wait.time(function ()
            DealArchiveCards()
        end, 2.5)
        
        Wait.time(function ()
            SetMissionCards()
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

function SetPlayerColors() -- Sets player colors according to fixed positions in table
    for i, player in ipairs(Player.getPlayers()) do
        player.changeColor(availablePlayerColors[i]);
    end
end

function DetermineStartingPlayer() -- Sets starting player and color/turn order
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

function DealAliensCoroutine()
    local draftZoneClockwiseGUID = "e407b4"
    local draftZoneCounterClockwiseGUID = "2968a3"
    local draftZoneClockwiseObject = getObjectFromGUID(draftZoneClockwiseGUID)
    local draftZoneCounterClockwiseObject = getObjectFromGUID(draftZoneCounterClockwiseGUID)

    local scriptingZoneClockwiseGUID = "1c6165"
    local scriptingZoneCounterClockwiseGUID = "025a21"
    local scriptingZoneClockwiseObject = getObjectFromGUID(scriptingZoneClockwiseGUID)
    local scriptingZoneCounterClockwiseObject = getObjectFromGUID(scriptingZoneCounterClockwiseGUID)

    local alienDeckGUID = "e6fef2"
    local advancedAlienDeckGUID = "5be236"
    local guardianDeckGUID = "21cccc"
    local advancedGuardianDeckGUID = "440784"

    local alienDeckObject = getObjectFromGUID(alienDeckGUID)
    local advancedAlienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
    local guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
    local advancedGuardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)

    local alienPlayDeckObject

    if expansionRaces then
        alienPlayDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
        advancedGuardianDeckObject.interactable = true
        alienDeckObject.destruct()
        guardianDeckObject.destruct()
    else
        alienPlayDeckObject = getObjectFromGUID(alienDeckGUID)
        guardianDeckObject.interactable = true
        advancedAlienDeckObject.destruct()
        advancedGuardianDeckObject.destruct()
    end
    
    alienPlayDeckObject.shuffle()

    -- Left Exile
    alienPlayDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 5.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end) -- Optional numberFrames, default = 1 frame
        end
    })
    
    -- Right Exile
    alienPlayDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 12.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Create 2 random alien race piles. Card amount per pile = player count + 1
    for i = 1, playerCount + 1 do
        -- Counterclockwise alien pile
        alienPlayDeckObject.takeObject({
            position = draftZonePositionsCCW[i],
            callback_function = function(spawnedObject)
                spawnedObject.locked = true
                --counterClockwisePileTable[i] = spawnedObject
                spawnedObject.createButton({
                    click_function = "DraftZoneCounterClockwiseClicked",
                    width = 700,
                    height = 270,
                    position = {0,0,1.8},
                    color = TurnOrderTable[playerCount],
                    label = "Choose",
                    font_size = 130,
                    font_color = "White",
                    tooltip = "Press to choose this Alien race & pass turn to the player on your right"
                })
            end
        })

        -- Clockwise alien pile
        alienPlayDeckObject.takeObject({
            position = draftZonePositionsCW[i],
            callback_function = function(spawnedObject)
                spawnedObject.locked = true
                --clockwisePileTable[i] = spawnedObject
                spawnedObject.createButton({
                    click_function = "DraftZoneClockwiseClicked",
                    width = 700,
                    height = 270,
                    position = {0,0,1.8},
                    color = TurnOrderTable[1],
                    label = "Choose",
                    font_size = 130,
                    font_color = "White",
                    tooltip = "Press to choose this Alien race & pass turn to the player on your left"
                })
            end
        })
    end

    for _ = 1, 250 do
        coroutine.yield(0)
    end
    
    local clockwiseCounter = 1
    local counterClockwiseCounter = playerCount

    broadcastToAll(TurnOrderTable[clockwiseCounter] .. ", choose alien from right pile", TurnOrderTable[clockwiseCounter])
    broadcastToAll(TurnOrderTable[counterClockwiseCounter] .. ", choose alien from left pile", TurnOrderTable[counterClockwiseCounter])

    function DraftZoneCounterClockwiseClicked(obj, color)
        log(obj)
        log(color)

        -- --obj.removeButton(0)

        -- local cardObjects = scriptingZoneCounterClockwiseObject.getObjects()
        -- log(cardObjects)

        -- for _, card in ipairs(cardObjects) do
        --     card.editButton({index=0, color=TurnOrderTable[counterClockwiseCounter]})
        -- end

        -- obj.deal(1, TurnOrderTable[counterClockwiseCounter])
        -- counterClockwiseCounter = counterClockwiseCounter - 1
        
    end

    function DraftZoneClockwiseClicked(obj, color)
        if color == TurnOrderTable[clockwiseCounter] then
            obj.removeButton(0)
            obj.deal(1, TurnOrderTable[clockwiseCounter])

            clockwiseCounter = clockwiseCounter + 1
            
            local cardObjects = scriptingZoneClockwiseObject.getObjects() -- Grab all remaining cards each cycle
            log(cardObjects)
            log(clockwiseCounter)

            for _, object in ipairs(cardObjects) do
                if clockwiseCounter > playerCount and object.type == "Card" then -- When last card of pile is drafted, 1 remains for guardian draft. Remove button.
                    object.editButton({
                        index = 0,
                        label = "Guardian",
                        click_function = "GuardianClockwiseClicked",
                        tooltip = "Choose this alien to become the Warp Guardian!"
                    })
                elseif object.type == "Card" then
                    object.editButton({index=0, color=TurnOrderTable[clockwiseCounter]}) -- Change button color to next player in line's color
                end
            end
        else
            print("Not your turn to pick from this pile!")
        end
    end

    function GuardianClockwiseClicked()
        print("testt")
    end

    return 1
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

    archiveDeckObject.interactable = true
end

function DealResourcesCoroutine() -- Deals gold/energy to players according to table in manual:
    local energySpawnerGUID = "98a3fe"
    local goldSpawnerGUID = "0b18bb"

    local energySpawnerObject = getObjectFromGUID(energySpawnerGUID)
    local goldSpawnerObject = getObjectFromGUID(goldSpawnerGUID)

    local playerIndex = StartPlayerNumber -- Start with number of starting player, then continue clockwise from there 

    -- Player 1: 4/4, Player 2: 5/4, Player 3: 5/5, Player 4: 5/5, Player 5: 6/5, Player 6: 6/6
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

        -- Wait X frames between players
        for _ = 1, 60 do
            coroutine.yield(0)
        end
    end

    return 1
end

function SetMissionCards()
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

    local pioneeringScriptingZoneGUID = "f54485"
    local pioneeringScriptingZoneObject = getObjectFromGUID(pioneeringScriptingZoneGUID)

    -- Deal 3 mission cards open to table
    -- Progress mission
    progressDeckObject.shuffle()
    progressDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 21.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    progressDeckObject.interactable = true

    -- Prosperity mission
    ProsperityDeckObject.shuffle()
    ProsperityDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 15.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    ProsperityDeckObject.interactable = true

    -- Conquest mission
    conquestDeckObject.shuffle()
    conquestDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 9.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    conquestDeckObject.interactable = true

    -- Pioneering mission cards #1-6 (Dealt from left to right, per row. The deck is in the correct order)
    -- #1 Overlord
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = 2.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #2 Infinite Riches
    pioneeringDeckObject.takeObject({
        position = {x = 66.75, y = 1.67, z = -3.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #3 Ascension (advanced) OR Expansion
    if advancedPioneering then -- destroy the default card
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
    else -- If not using advancedPioneering
        pioneeringDeckObject.takeObject({
            position = {x = 66.75, y = 1.67, z = -9.75},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
    end
    -- #4 Master Trader
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 2.25},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #5 Civilization)
    pioneeringDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = -3.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #6 King of Average (advanced) OR Empire
    if advancedPioneering then -- destroy the default card
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
    else -- If not using advancedPioneering
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

        Wait.time(function ()
            -- Destroy remaining card(s)
            local objects = pioneeringScriptingZoneObject.getObjects()
            for _, object in pairs(objects) do
                object.destruct()
            end     
        end, 1)

    else
        -- Destroy unused mission shadows and cards
        advancedPioneeringDeckObject.destruct()
        destroyObject(getObjectFromGUID("83ab9a"))
        destroyObject(getObjectFromGUID("a73c21"))
        destroyObject(getObjectFromGUID("d6524d"))
    end
end

function DealMissionCards()
    local progressDeckGUID = "935e48"
    local ProsperityDeckGUID = "5771e2"
    local conquestDeckGUID = "f4ccdd"

    local progressDeckObject = getObjectFromGUID(progressDeckGUID)
    local ProsperityDeckObject = getObjectFromGUID(ProsperityDeckGUID)
    local conquestDeckObject = getObjectFromGUID(conquestDeckGUID)

    print("inside dealmission")



    function DealMissionsClicked(obj, color, alt_click)
        print("inside testClick")
    end
end

function CreateBoardCoroutine()
    local portalGUID = "9aecf3"
    local portalObject = getObjectFromGUID(portalGUID)

    local playerZoneGUID = "dea9dd"
    local playerZoneObject = getObjectFromGUID(playerZoneGUID)

    local connectZoneGUID = "500df9"
    local connectZoneObject = getObjectFromGUID(connectZoneGUID)
        
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

    if playerCount < 6 then -- Connect Zone and portal are only needed for 2-5 players
        connectZoneObject.setPositionSmooth(connectZonePositions[playerCount][1], false, false)
        connectZoneObject.setRotationSmooth(connectZonePositions[playerCount][2], false, false)
        
        portalObject.setPositionSmooth({19.90, 1.65, -10.58}, false, false)
    else
        connectZoneObject.destruct()
        portalObject.destruct()
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
    exiledTokenBagObject.interactable = true
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