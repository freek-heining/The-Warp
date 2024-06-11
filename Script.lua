--#region DataTables
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
    [6] = { {28.91, 1.54, -6.31}, {0.08, 119.98, 0.03} }
}

-- B sides/backside of boards
local playerZonePositionsB = {
    [1] = { {13.60, 1.56, -15.24}, {0.02, 179.89, 0.08} },
    [2] = { {1.12, 1.58, -6.42}, {359.94, 239.81, 0.05} },
    [3] = { {2.52, 1.58, 8.80}, {359.92, 299.93, 359.97} },
    [4] = { {16.40, 1.56, 15.17}, {359.98, 359.92, 359.92} },
    [5] = { {28.89, 1.54, 6.35}, {0.06, 59.86, 359.95} },
    [6] = { {27.48, 1.54, -8.86}, {0.08, 119.88, 0.03} }
}

-- 2-5 players (position, rotation)
local connectZonePositions = {
    [2] = { {0.37, 1.58, -0.02}, {359.92, 270.21, 0.02} },
    [3] = { {7.69, 1.57, 12.65}, {359.95, 330.04, 359.94} },
    [4] = { {22.28, 1.55, 12.64}, {0.02, 29.89, 359.93} },
    [5] = { {29.60, 1.54, 0.04}, {0.08, 90.08, 359.98} }
}

local connectZonePositionsB = {
    [2] = { {3.29, 1.58, 4.98}, {359.92, 269.76, 0.02} },
    [3] = { {13.51, 1.57, 12.58}, {359.95, 329.84, 359.94} },
    [4] = { {25.19, 1.55, 7.63}, {0.02, 30.04, 359.92} },
    [5] = { {26.73, 1.54, -5.03}, {0.08, 90.10, 359.98} }
}

-- Players 1-6 (position, rotation)
local energyZonePositions = {
    [1] = {31.70, 1.53, -40.84},
    [2] = {-11.80, 1.59, -40.85},
    [3] = {-45.20, 1.66, 40.84},
    [4] = {-1.70, 1.60, 40.84},
    [5] = {41.80, 1.54, 40.84},
    [6] = {75.20, 1.46, -40.85}
}

-- Players 1-6 (position, rotation)
local goldZonePositions = {
    [1] = {26.32, 1.58, -40.81},
    [2] = {-17.18, 1.64, -40.81},
    [3] = {-39.82, 1.70, 40.81},
    [4] = {3.68, 1.64, 40.81},
    [5] = {47.18, 1.58, 40.81},
    [6] = {69.82, 1.52, -40.81},
}

local draftZonePositionsCW = {
    [1] = {-73.41, 15.61, 25.54},
    [2] = {-73.42, 15.62, 36.04},
    [3] = {-73.42, 15.62, 46.54},
    [4] = {-73.42, 15.62, 57.04},
    [5] = {-59.66, 15.59, 25.54},
    [6] = {-59.66, 15.60, 36.04},
    [7] = {-59.66, 15.60, 46.54},
    [8] = {-59.66, 15.60, 57.04}
}

local draftZonePositionsCCW = {
    [1] = {-73.41, 15.61, -56.96},
    [2] = {-73.41, 15.62, -46.46},
    [3] = {-73.41, 15.62, -35.96},
    [4] = {-73.41, 15.62, -25.46},
    [5] = {-59.66, 15.59, -56.96},
    [6] = {-59.66, 15.60, -46.46},
    [7] = {-59.66, 15.60, -35.96},
    [8] = {-59.66, 15.60, -25.46}
}

-- Left and right spot
local alienRacePlayerZones = {
    Red = { {21.75, 1.56, -32.25}, {30.75, 1.54, -32.25} },
    Green = { {-21.75, 1.62, -32.25}, {-12.75, 1.60, -32.25} },
    Purple = { {-35.25, 1.65, 32.25}, {-44.25, 1.67, 32.25} },
    Blue = { {8.25, 1.59, 32.25}, {-0.75, 1.61, 32.25} },
    Orange = { {51.75, 1.53, 32.25}, {42.75, 1.55, 32.25} },
    Brown = { {65.25, 1.49, -32.25}, {74.25, 1.48, -32.25} }
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

local playerCount = 0 -- Important variable. Used in lots of functions
local TurnOrderTable = {} -- Stores the colors in playing order, for Turns.order, dealing archive cards and resources etc. ( DetermineStartingPlayer() )
local setupDone = false

function onload(state)
    log("playerCount: " .. playerCount)
    log("setupDone: " .. tostring(setupDone))

    -- JSON decode our saved state
    local decodedState = JSON.decode(state)
    log(decodedState)

    if decodedState then
        playerCount = decodedState.variables.playerCount

        setupDone = decodedState.variables.setupDone
        if not setupDone then -- If nil somehow
            setupDone = false
        end

        TurnOrderTable = decodedState.variables.turnOrderTable
    end

    --UI.setAttribute("setupWindow", "active", false)

    -- Set lots of components to interactable = false initially
    SetInteractableFalse()

    if not setupDone then
        MoveHandZones("+", 300) -- Move away temporary so nobody selects color manually
    else
        UI.setAttribute("setupWindow", "active", false)
    end

    log("setupDone after onLoad: " .. tostring(setupDone))
end

-- Save crucial data in case of reloading or rewinding. setupDone keeps track of game state
function onSave()
    local state = {
        variables = {
            playerCount = playerCount,
            setupDone = setupDone,
            turnOrderTable = TurnOrderTable
        }
    }
    return JSON.encode(state)
end

function SetInteractableFalse() -- Initially sets a whole bunch of objects to interactable = false
    local abilityTokenBagGUID = "e98136"
    if not setupDone then
        local abilityTokenBagObject = getObjectFromGUID(abilityTokenBagGUID)
        abilityTokenBagObject.interactable = false
    end

    local exiledTokenBagGUID = "445eb7"
    if not setupDone then
        local exiledTokenBagObject = getObjectFromGUID(exiledTokenBagGUID)
        exiledTokenBagObject.interactable = false
    end
    
    local boardScriptingZoneGUID = "8a89e0"
    if not setupDone then
        local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)
        boardScriptingZoneObject.interactable = false
    end
    
    local battleZoneGUID = "6e4f39"
    local battleZoneObject = getObjectFromGUID(battleZoneGUID)
    battleZoneObject.interactable = false

    local playerZoneAGUID = "dea9dd"
    local playerZoneBGUID = "6006e1"
    local connectZoneAGUID = "500df9"
    local connectZoneBGUID = "cc1ce5"
    local centralZoneGUID = "9b6946"
    local portalGUID = "9aecf3"
    if not setupDone then
        local playerZoneAObject = getObjectFromGUID(playerZoneAGUID)
        local playerZoneBObject = getObjectFromGUID(playerZoneBGUID)
        local connectZoneAObject = getObjectFromGUID(connectZoneAGUID)
        local connectZoneBObject = getObjectFromGUID(connectZoneBGUID)
        local centralZoneObject = getObjectFromGUID(centralZoneGUID)
        local portalObject = getObjectFromGUID(portalGUID)
        playerZoneAObject.interactable = false
        playerZoneBObject.interactable = false
        connectZoneAObject.interactable = false
        connectZoneBObject.interactable = false
        centralZoneObject.interactable = false
        portalObject.interactable = false
    end

    local alienDeckGUID = "e6fef2"
    local advancedAlienDeckGUID = "5be236"
    local guardianDeckGUID = "21cccc"
    local advancedGuardianDeckGUID = "440784"
    if not setupDone then
        local alienDeckObject = getObjectFromGUID(alienDeckGUID)
        local advancedAlienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
        local guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
        local advancedGuardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)
        alienDeckObject.interactable = false
        advancedAlienDeckObject.interactable = false
        guardianDeckObject.interactable = false
        advancedGuardianDeckObject.interactable = false
    end

    local draftZoneClockwiseGUID = "1a436f"
    local draftZoneCounterClockwiseGUID = "2968a3"
    if not setupDone then
        local draftZoneClockwiseObject = getObjectFromGUID(draftZoneClockwiseGUID)
        local draftZoneCounterClockwiseObject = getObjectFromGUID(draftZoneCounterClockwiseGUID)
        draftZoneClockwiseObject.interactable = false
        draftZoneCounterClockwiseObject.interactable = false
    end

    local archiveDeckGUID = "6b2a67"
    local startCardDeckGUID = "ac5ebb"
    if not setupDone then
        local startCardDeckObject = getObjectFromGUID(startCardDeckGUID)
        local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)
        startCardDeckObject.interactable = false
        archiveDeckObject.interactable = false
    end

    local progressDeckGUID = "935e48"
    local ProsperityDeckGUID = "5771e2"
    local conquestDeckGUID = "f4ccdd"
    local pioneeringDeckGUID = "9aa665"
    local advancedPioneeringDeckGUID = "c7f175"
    if not setupDone then
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
    end

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

    local combatCardAttackShadowGUID = "0e582a"
    local combatCardDefenseShadowGUID = "a9bb10"
    local combatCardAttackShadowObject = getObjectFromGUID(combatCardAttackShadowGUID)
    local combatCardDefenseShadowObject = getObjectFromGUID(combatCardDefenseShadowGUID)
    combatCardAttackShadowObject.interactable = false
    combatCardDefenseShadowObject.interactable = false

    local rewardDeckGUID = "ff7833"
    local rewardDeckObject = getObjectFromGUID(rewardDeckGUID)
    rewardDeckObject.interactable = false

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
    local missionShadow1Object = getObjectFromGUID(missionShadow1GUID)
    local missionShadow2Object = getObjectFromGUID(missionShadow2GUID)
    local missionShadow3Object = getObjectFromGUID(missionShadow3GUID)
    local missionShadow4Object = getObjectFromGUID(missionShadow4GUID)
    local missionShadow5Object = getObjectFromGUID(missionShadow5GUID)
    local missionShadow6Object = getObjectFromGUID(missionShadow6GUID)
    missionShadow1Object.interactable = false
    missionShadow2Object.interactable = false
    missionShadow3Object.interactable = false
    missionShadow4Object.interactable = false
    missionShadow5Object.interactable = false
    missionShadow6Object.interactable = false

    if not setupDone then
    -- Advanced Pioneering shadows
        local missionShadow7GUID = "83ab9a"
        local missionShadow8GUID = "a73c21"
        local missionShadow9GUID = "d6524d"
        local missionShadow7Object = getObjectFromGUID(missionShadow7GUID)
        local missionShadow8Object = getObjectFromGUID(missionShadow8GUID)
        local missionShadow9Object = getObjectFromGUID(missionShadow9GUID)
        missionShadow7Object.interactable = false
        missionShadow8Object.interactable = false
        missionShadow9Object.interactable = false
    end
end

function MoveHandZones(operation, moveValue)
    -- Stores the moving away and back to original operations
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

function StartClicked(player) -- Calls most setup functions and handles their timing/order. A lot of functions are 'chained' in other functions. See comments
    UI.setAttribute("startButton", "interactable", false) -- Prevents button spam
    Wait.time(function ()
        UI.setAttribute("startButton", "interactable", true)
    end, 2)

    -- Set player count according to the current amount of ingame players
    SetPlayerCount()

    if not player.host then
        broadcastToAll("Only the host can start the game!", "Red")
    elseif playerCount < 2 then
        broadcastToAll("Need 2 players minimum to start!", "Red")
    else
        UI.setAttribute("setupWindow", "active", false) -- Hide the UI

        broadcastToAll("Starting the game with " .. playerCount .. " players. Please wait while everything is being set up!")
        
        -- #1: Shuffle ability bag and reward deck
        local abilityTokenBagGUID = "e98136"
        local abilityTokenBagObject = getObjectFromGUID(abilityTokenBagGUID)
        abilityTokenBagObject. interactable = true
        abilityTokenBagObject.shuffle()

        local rewardDeckGUID = "ff7833"
        local rewardDeckObject = getObjectFromGUID(rewardDeckGUID)
        rewardDeckObject.interactable = true
        rewardDeckObject.shuffle()

        -- #2: Assign colors/seats to players automatically (in order of joining the game)
        SetPlayerColors()

        -- #3: Determine starting player and fix color/turn order
        Wait.time(function ()
            DetermineStartingPlayer()
        end, 2.5)

        -- #4: Restore hand zones to orignal positions
        MoveHandZones("-", 300)
        
        -- #5: Deal Archive cards
        Wait.time(function ()
            startLuaCoroutine(Global, "DealArchiveCardsCoroutine")
        end, 4)
        
        -- #6: Deal Mission cards
        Wait.time(function ()
            SetMissionCards()
        end, 9)
        
        -- #7: Create the board
        Wait.time(function ()
            startLuaCoroutine(Global, "CreateBoardCoroutine")
        end, 12)
    end
end

-- Sets player count each time when start is pressed
function SetPlayerCount()
    playerCount = 0

    for _, _ in ipairs(Player.getPlayers()) do
        playerCount = playerCount + 1
    end
    log("playerCount: " .. playerCount)
end

function SetPlayerColors() -- Sets player colors according to fixed positions in table
    for i, player in ipairs(Player.getPlayers()) do
        player.changeColor(availablePlayerColors[i]);
    end
end

function DetermineStartingPlayer() -- Determines starting player and color/turn order
    StartPlayerNumber = math.random(playerCount) -- Integer from 1 - playerCount. Red = 1, Green = 2, Purple = 3, Blue = 4, Orange = 5, Brown = 6
    local startPlayerColor = availablePlayerColors[StartPlayerNumber] -- Fixed color matching player numbers/seats
    
    broadcastToAll("-" .. startPlayerColor .. "- is the starting player!", startPlayerColor)
    
    local colorIndex = StartPlayerNumber -- Start with color/number of starting player, then continue clockwise from there 

    for i = 1, playerCount do -- Fills the array with colors in player order for this game
        TurnOrderTable[i] = availablePlayerColors[colorIndex]
        
        colorIndex = colorIndex + 1

        if  colorIndex > playerCount then -- If last color was reached, reset to use remaining colors from beginning of table
            colorIndex = 1
        end
    end

    Turns.enable = true
    Turns.type = 2
    Turns.order = TurnOrderTable
    Turns.turn_color = startPlayerColor
end

-- Handles the alien/guardian drafting. Last function te be called in the setup chain. Sets setupDone = true at the end
function DealAliensCoroutine()
    local draftZoneClockwiseGUID = "1a436f"
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

    -- Bring in the 2 plateaus
    draftZoneClockwiseObject.setPositionSmooth({-65.25, 15.00, 41.25}, false, false)
    draftZoneCounterClockwiseObject.setPositionSmooth({-65.25, 15.00, -41.25}, false, false)

    -- Wait for draft zones to complete moving
    for _ = 1, 250 do
        coroutine.yield(0)
    end

    -- Fill these with the base deck or advanced decks. (Easier then using the above objects)
    local alienPlayDeckObject
    local guardianPlayDeckObject

    if expansionRaces then -- If using the expansion (6) and kickstarter (2) races (24 total)
        alienPlayDeckObject = advancedAlienDeckObject
        guardianPlayDeckObject = advancedGuardianDeckObject
        alienDeckObject.destruct()
        guardianDeckObject.destruct()
    else -- Use only the base game races (16 total)
        alienPlayDeckObject = alienDeckObject
        guardianPlayDeckObject = guardianDeckObject
        advancedAlienDeckObject.destruct()
        advancedGuardianDeckObject.destruct()
    end
    
    alienPlayDeckObject.shuffle()

    for _ = 1, 50 do
        coroutine.yield(0)
    end

    -- Left Exile
    alienPlayDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 5.25},
        callback_function = function(spawnedObject)
            Wait.time(function() spawnedObject.flip() end, 1)
            Wait.time(function() spawnedObject.setLock(true) end, 3)
        end
    })
    
    -- Right Exile
    alienPlayDeckObject.takeObject({
        position = {x = -51.41, y = 1.67, z = 12.75},
        callback_function = function(spawnedObject)
            Wait.time(function() spawnedObject.flip() end, 1)
            Wait.time(function() spawnedObject.setLock(true) end, 3)
        end
    })

    -- Create 2 random alien race piles. Card amount per pile = player count + 1
    for i = 1, playerCount + 1 do
        -- Counterclockwise alien pile
        alienPlayDeckObject.takeObject({
            position = draftZonePositionsCCW[i],
            callback_function = function(spawnedObject)
                spawnedObject.locked = true
                spawnedObject.createButton({
                    click_function = "DraftZoneCounterClockwiseClicked",
                    width = 800,
                    height = 300,
                    position = {0,0,1.9},
                    color = TurnOrderTable[playerCount],
                    label = "Choose",
                    font_size = 140,
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
                spawnedObject.createButton({
                    click_function = "DraftZoneClockwiseClicked",
                    width = 800,
                    height = 300,
                    position = {0,0,1.9},
                    color = TurnOrderTable[1],
                    label = "Choose",
                    font_size = 140,
                    font_color = "White",
                    tooltip = "Press to choose this Alien Race & pass turn to the player on your left"
                })
            end
        })
    end

    for _ = 1, 250 do
        coroutine.yield(0)
    end
    
    local clockwiseCounter = 1 -- Keeps track of right pile active player
    local counterClockwiseCounter = playerCount -- Keeps track of left pile active player

    broadcastToAll(TurnOrderTable[clockwiseCounter] .. ", choose an Alien Race from the 'Clockwise' pile.", TurnOrderTable[clockwiseCounter])
    broadcastToAll(TurnOrderTable[counterClockwiseCounter] .. ", choose an Alien Race from the 'Counterclockwise' pile.", TurnOrderTable[counterClockwiseCounter])

    function DraftZoneCounterClockwiseClicked(obj, color) -- Left draft pile
        if color == TurnOrderTable[counterClockwiseCounter] then
            obj.removeButton(0)
            obj.locked = false
            obj.setPositionSmooth(alienRacePlayerZones[TurnOrderTable[counterClockwiseCounter]][1], false, false)
            
            if color == "Brown" or color == "Red" or color == "Green" then
                obj.setRotationSmooth({0, 180, 0}, false, false)
            else
                obj.setRotationSmooth({0, 0, 0}, false, false)
            end

            -- Lock cards after 3 seconds
            Wait.time(function ()
                obj.setLock(true)
            end, 3)

            counterClockwiseCounter = counterClockwiseCounter - 1 -- Counting down = counterclockwise

            local cardObjects = scriptingZoneCounterClockwiseObject.getObjects() -- Grab all remaining cards each cycle

            for _, object in ipairs(cardObjects) do
                if counterClockwiseCounter < 1 and object.type == "Card" then -- When 2nd last card of pile is drafted, 1 remains for guardian draft.
                    object.editButton({
                        index = 0,
                        label = "Warp Guardian",
                        click_function = "GuardianClicked",
                        tooltip = "Choose this Alien Race to become the Warp Guardian!",
                        width = 1100,
                        color = TurnOrderTable[playerCount] -- Reset button color to last player in order
                    })
                elseif object.type == "Card" then -- Change all buttons color to next player in line's color
                    object.editButton({index=0, color=TurnOrderTable[counterClockwiseCounter]}) 
                end
            end
            
            if clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
                broadcastToAll(TurnOrderTable[playerCount] .. ", choose the Warp Guardian from the left or right pile.", TurnOrderTable[playerCount])
            elseif counterClockwiseCounter >= 1 then
                broadcastToAll(TurnOrderTable[counterClockwiseCounter] .. ", choose an Alien Race from the -left- pile.", TurnOrderTable[counterClockwiseCounter])
            end
        else
            print("Not your turn to pick from this pile!")
        end
    end

    function DraftZoneClockwiseClicked(obj, color) -- Right draft pile
        if color == TurnOrderTable[clockwiseCounter] then
            obj.removeButton(0)
            obj.locked = false
            obj.setPositionSmooth(alienRacePlayerZones[TurnOrderTable[clockwiseCounter]][2], false, false)

            if color == "Brown" or color == "Red" or color == "Green" then
                obj.setRotationSmooth({0, 180, 0}, false, false)
            else
                obj.setRotationSmooth({0, 0, 0}, false, false)
            end

            -- Lock cards after 3 seconds
            Wait.time(function ()
                obj.setLock(true)
            end, 3)

            clockwiseCounter = clockwiseCounter + 1 -- Counting up = clockwise
            
            local cardObjects = scriptingZoneClockwiseObject.getObjects() -- Grab all remaining cards each cycle

            for _, object in ipairs(cardObjects) do
                if clockwiseCounter > playerCount and object.type == "Card" then -- When 2nd last card of pile is drafted, 1 remains for guardian draft.
                    object.editButton({
                        index = 0,
                        label = "Warp Guardian",
                        click_function = "GuardianClicked",
                        tooltip = "Choose this Alien Race to become the Warp Guardian!",
                        width = 1100
                    })
                elseif object.type == "Card" then -- Change all buttons color to next player in line's color
                    object.editButton({index=0, color=TurnOrderTable[clockwiseCounter]})
                end
            end

            if clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
                broadcastToAll(TurnOrderTable[playerCount] .. ", choose the Warp Guardian from the left or right pile.", TurnOrderTable[playerCount])
            elseif clockwiseCounter <= playerCount then
                broadcastToAll(TurnOrderTable[clockwiseCounter] .. ", choose an Alien Race from the -right- pile.", TurnOrderTable[clockwiseCounter])
            end
        else
            print("Not your turn to pick from this pile!")
        end
    end

    -- Only when 1 alien left on both sides can we choose the warp guardian
    function GuardianClicked(obj, color)
        if color == TurnOrderTable[playerCount] and clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
            local chosenGuardianName = obj.getName()
            broadcastToAll("'" .. chosenGuardianName .. "' is chosen to be the Warp Guardian.")

            obj.removeButton(0)
            obj.setPositionSmooth({-51.41, 1.66, -9.00}, false, false) -- Move to Guardian spot on table

            -- Destroy remaining cards
            Wait.time(function ()
                obj.setLock(true)

                local rightCardObjects = scriptingZoneClockwiseObject.getObjects() -- Grab all remaining cards
                local leftCardObjects = scriptingZoneCounterClockwiseObject.getObjects() -- Grab all remaining cards
    
                -- Destroy all remaining objects from the draft
                for _, object in ipairs(rightCardObjects) do
                    object.destruct()
                end
                for _, object in ipairs(leftCardObjects) do
                    object.destruct()
                end

                broadcastToAll("Don't forget to put tokens on the Exiled Races and Warp Guardian!")
            end, 3)

            Wait.time(function ()
                local guardianGUID = nil
                -- Look for corresponding guardian in the guardian deck, to place over the chosen alien guardian card
                for _, guardianCard in ipairs(guardianPlayDeckObject.getObjects()) do
                    if  guardianCard.name == chosenGuardianName then
                        guardianGUID = guardianCard.guid
                    end
                end
            
                -- Take corresponding guardian from deck to place over the chosen alien card
                if guardianGUID then
                    guardianPlayDeckObject.takeObject({
                        guid = guardianGUID,
                        position = {-51.41, 1.80, -9.00},
                        callback_function = function(chosenGuardian)
                            Wait.time(function ()
                                chosenGuardian.setLock(true)
                            end, 1.5)
                        end
                    })
                end
                
                alienPlayDeckObject.interactable = true
                guardianDeckObject.interactable = true
            end, 1.5)

            -- When drafting is done, deal 6 mission cards to each player
            Wait.time(function ()
                startLuaCoroutine(Global, "DealMissionCardsCoroutine")
            end, 3)

        elseif color == TurnOrderTable[playerCount] then
            print("Wait for the other draft pile to complete!")
        else
            print("You cannot choose the Warp Guardian!")
        end
    end

    setupDone = true

    return 1
end

function DealArchiveCardsCoroutine()
    local archiveDeckGUID = "6b2a67"
    local startCardDeckGUID = "ac5ebb"

    local startCardDeckObject = getObjectFromGUID(startCardDeckGUID)
    local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)

    -- Deal 1 start card to each player
    for i = 1, playerCount do
        startCardDeckObject.deal(1, TurnOrderTable[i])
    end
    startCardDeckObject.destruct()

    for _ = 1, 100 do
        coroutine.yield(0)
    end

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

    for _ = 1, 100 do
        coroutine.yield(0)
    end

    -- Deals 4 archive cards to players 1-3, and 5 cards to players 4-6 (if any)
    for i = 1, playerCount do
        if i < 4 then
            archiveDeckObject.deal(4, TurnOrderTable[i])
            for _ = 1, 100 do
                coroutine.yield(0)
            end
        else
            archiveDeckObject.deal(5, TurnOrderTable[i])
            for _ = 1, 100 do
                coroutine.yield(0)
            end
        end
    end

    archiveDeckObject.interactable = true

    return 1
end

-- Deals starting gold/energy to players according to table in manual. Also calls DealAliensCoroutine() when finished
function DealResourcesCoroutine() 
    local energySpawnerGUID = "98a3fe"
    local goldSpawnerGUID = "0b18bb"

    local energySpawnerObject = getObjectFromGUID(energySpawnerGUID)
    local goldSpawnerObject = getObjectFromGUID(goldSpawnerGUID)

    local playerColorIndex = StartPlayerNumber -- Start with number/color of starting player, then continue clockwise from there 

    -- Gold/Energy amounts:
    -- Player 1: 4/4, Player 2: 5/4, Player 3: 5/5, Player 4: 5/5, Player 5: 6/5, Player 6: 6/6
    for i = 1, playerCount do
        -- Player 1
        if i == 1 then
            for _ = 1, 4 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 4 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
        -- Player 2
        elseif i == 2 then
            for _ = 1, 5 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 4 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
        -- Player 3 & 4
        elseif i == 3 or i ==4 then
            for _ = 1, 5 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 5 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
        -- Player 5
        elseif i == 5 then
            for _ = 1, 6 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 5 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
        -- Player 6
        elseif i == 6 then
            for _ = 1, 6 do
                goldSpawnerObject.takeObject({
                    position = goldZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
            for _ = 1, 6 do
                energySpawnerObject.takeObject({
                    position = energyZonePositions[playerColorIndex]
                })
                for _ = 1, 15 do
                    coroutine.yield(0)
                end
            end
        end

        playerColorIndex = playerColorIndex + 1

        -- If last player number/color on current game board is reached, reset to use remaining numbers/colors from beginning of game board
        if  playerColorIndex > playerCount then
            playerColorIndex = 1
        end

        -- Wait X frames between players
        for _ = 1, 60 do
            coroutine.yield(0)
        end
    end

    -- Finally, deal Aliens for drafting
    Wait.time(function ()
        startLuaCoroutine(Global, "DealAliensCoroutine")
    end, 1)

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

    -- Prosperity mission
    ProsperityDeckObject.shuffle()
    ProsperityDeckObject.takeObject({
        position = {x = 62.25, y = 1.67, z = 15.75},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end) -- * Optional, defaults to `1`. *
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
        -- Get the advanced card
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
        -- Get the advanced card
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

function DealMissionCardsCoroutine()
    local progressDeckGUID = "935e48"
    local ProsperityDeckGUID = "5771e2"
    local conquestDeckGUID = "f4ccdd"

    local progressDeckObject = getObjectFromGUID(progressDeckGUID)
    local ProsperityDeckObject = getObjectFromGUID(ProsperityDeckGUID)
    local conquestDeckObject = getObjectFromGUID(conquestDeckGUID)

    for _, color in pairs(TurnOrderTable) do
        progressDeckObject.deal(2, color)
        for _ = 1, 60 do
            coroutine.yield(0)
        end
        ProsperityDeckObject.deal(2, color)
        for _ = 1, 60 do
            coroutine.yield(0)
        end
        conquestDeckObject.deal(2, color)
    end

    broadcastToAll("Keep 1 mission of each color, and place the others back facedown on their repective draw pile. Shuffle afterwards.")

    ProsperityDeckObject.interactable = true
    progressDeckObject.interactable = true
    conquestDeckObject.interactable = true

    return 1
end

-- Used in DealPlayerTokensCoroutine() and filled in CreateBoardCoroutine()
local playerZoneObjects = {}

-- Create game board dynamically. Also calls DealExileTokens() and DealPlayerTokensCoroutine() when finished
function CreateBoardCoroutine()
    local portalGUID = "9aecf3"
    local portalObject = getObjectFromGUID(portalGUID)

    local centralZoneGUID = "9b6946"
    local centralZoneObject = getObjectFromGUID(centralZoneGUID)

    local connectZoneAGUID = "500df9"
    local connectZoneAObject = getObjectFromGUID(connectZoneAGUID)

    local connectZoneBGUID = "cc1ce5"
    local connectZoneBObject = getObjectFromGUID(connectZoneBGUID)

    local playerZoneAGUID = "dea9dd"
    local playerZoneAObject = getObjectFromGUID(playerZoneAGUID)
    
    local playerZoneBGUID = "6006e1"
    local playerZoneBObject = getObjectFromGUID(playerZoneBGUID)

    local playerZoneObject
    local connectZoneObject

    -- When using alternative B-side setup
    local function swapBoards()
        -- Swap all tables/positions for the B versions to be used
        playerZonePositions = playerZonePositionsB
        connectZonePositions = connectZonePositionsB

        -- swap central zone manually
        params = {
            image = "http://cloud-3.steamusercontent.com/ugc/2508016228644603765/BB45181317EA04A5823CF4EB33944313E5C74D82/",
            thickness = 0.2,
            merge_distance = 5,
            stackable = false,
        }
        centralZoneObject.setCustomObject(params)
        centralZoneObject.reload()
        centralZoneObject.interactable = false

        -- Destroy A-side boards
        connectZoneAObject.destruct()
        playerZoneAObject.destruct()

        -- Move B-side in position for cloning
        playerZoneBObject.setPositionSmooth(playerZonePositions[1][1], false, false)
        playerZoneBObject.setRotationSmooth(playerZonePositions[1][2], false, false)

        -- Wait X frames after moving new board
        for _ = 1, 130 do
            coroutine.yield(0)
        end
    end

    if alternativeSetup then
        swapBoards()
        playerZoneObject = playerZoneBObject
        connectZoneObject = connectZoneBObject
    else
        playerZoneObject = playerZoneAObject
        playerZoneBObject.destruct()
        connectZoneObject = connectZoneAObject
        connectZoneBObject.destruct()
    end

    table.insert(playerZoneObjects, playerZoneObject) -- Insert initial board
    
    for i = 2, playerCount, 1 do
        local playerZone = playerZoneObject.clone()
        table.insert(playerZoneObjects, playerZone)
        playerZone.setPositionSmooth(playerZonePositions[i][1], false, false)
        playerZone.setRotationSmooth(playerZonePositions[i][2], false, false)
        playerZone.interactable = false
        
        -- Wait X frames between placing boards
        for _ = 1, 110 do
            coroutine.yield(0)
        end
    end

    if playerCount < 6 then -- Connect Zone and portal are only needed for 2-5 players
        connectZoneObject.setPositionSmooth(connectZonePositions[playerCount][1], false, false)
        connectZoneObject.setRotationSmooth(connectZonePositions[playerCount][2], false, false)
        
        if alternativeSetup then
            portalObject.setPositionSmooth({16.36, 1.66, -9.80}, false, false)
        else
            portalObject.setPositionSmooth({19.90, 1.65, -10.58}, false, false)
        end
    else
        connectZoneObject.destruct()
        portalObject.destruct()
    end

    -- Deal Exile Tokens: Wait x seconds before dealing exile tokens, so every part of the board is completely done
    Wait.time(function ()
        DealExileTokens()
    end, 2)

    -- Deal player starting tokens: Wait x seconds before dealing player tokens, so every part of the board is completely done
    Wait.time(function ()
        startLuaCoroutine(Global, "DealPlayerTokensCoroutine")
    end, 4)

    return 1
end

-- Deals all starting tokens to players. Also calls DealResourcesCoroutine() when finished
function DealPlayerTokensCoroutine()
    -- All local positions relative to player zone. (Needed to inverse coordinates on x-axis because 180 rotation of zone object)
    -- Order: Troop x3, Troop right, Mine, Trade, Command, Plant (Like in scripting zone right to left)
    local playerTokenLocationsA = {
        [1] = vector(-1.18 , 0.116 , 1.035),
        [2] = vector(-0.003 , 0.108 , 0.672),
        [3] = vector(-0.177 , 0.108 , 0.786),
        [4] = vector(-0.209 , 0.108 , 1.004),
        [5] = vector(-0.048 , 0.105 , 1.247),
        [6] = vector(0.2 , 0.120 , 1.003),
        [7] = vector(0.655 , 0.120 , 0.791),
        [8] = vector(0.591 , 0.105 , 1.298)
    }

    -- Locations when using B-side
    local playerTokenLocationsB = {
        [1] = vector(-0.574 , 0.120 , 0.666),
        [2] = vector(-0.746 , 0.120 , 0.784),
        [3] = vector(-0.755 , 0.107 , 0.996),
        [4] = vector(-1.753 , 0.111 , 1.039),
        [5] = vector(-0.621 , 0.121 , 1.251),
        [6] = vector(-0.373 , 0.106 , 1.007),
        [7] = vector(0.082 , 0.106 , 0.795),
        [8] = vector(0.018 , 0.106 , 1.302)
    }

    -- All starting miniatures, filtered per color in indexed order: Troop, Troop, Troop, Troop, Mine, Trade, Command, Plant
    -- Nested tables for different player numbers!
    local playerTokenObjects = {}

    -- Filter and insert tokens in playerTokenObjects table 
    local function insertRotateToTable(objects)
        local trimmedTable = {}
        local j = 1

        -- Remove nameless/useless catched objects and rotate & order the rest
        for i, object in ipairs(objects) do
            if object.getName() == "" then
                table.remove(objects, i)
            elseif object == nil then
                table.remove(objects, i)
            elseif object.getName() == "Troop Token"  then
                object.rotate({x=0, y=60, z=0})
                trimmedTable[j] = object
                j = j + 1
            elseif object.getName() == "Mine"  then
                object.rotate({x=0, y=60, z=0})
                trimmedTable[5] = object
            elseif object.getName() == "Trade Post"  then
                object.rotate({x=0, y=-30, z=0})
                trimmedTable[6] = object
            elseif object.getName() == "Command Center"  then
                object.rotate({x=0, y=-30, z=0})
                trimmedTable[7] = object
            elseif object.getName() == "Power Plant"  then
                object.rotate({x=0, y=-90, z=0})
                trimmedTable[8] = object
            end
        end

        table.insert(playerTokenObjects, trimmedTable)

        for _ = 1, 10, 1 do
            coroutine.yield(0)
        end
    end

    -- #1 Red
    local redScriptingZoneGUID = "be23c6"
    local redScriptingZoneObject = getObjectFromGUID(redScriptingZoneGUID)
    local redTokenObjects = redScriptingZoneObject.getObjects()
    insertRotateToTable(redTokenObjects)

    -- #2 Green
    local greenScriptingZoneGUID = "c88802"
    local greenScriptingZoneObject = getObjectFromGUID(greenScriptingZoneGUID)
    local greenTokenObjects = greenScriptingZoneObject.getObjects()
    insertRotateToTable(greenTokenObjects)

    -- #3 Purple
    local purpleScriptingZoneGUID = "cd4ab7"
    local purpleScriptingZoneObject = getObjectFromGUID(purpleScriptingZoneGUID)
    local purpleTokenObjects = purpleScriptingZoneObject.getObjects()
    insertRotateToTable(purpleTokenObjects)

    -- #4 Blue
    local blueScriptingZoneGUID = "df35ef"
    local blueScriptingZoneObject = getObjectFromGUID(blueScriptingZoneGUID)
    local blueTokenObjects = blueScriptingZoneObject.getObjects()
    insertRotateToTable(blueTokenObjects)

    -- #5 Orange
    local orangeScriptingZoneGUID = "535afd"
    local orangeScriptingZoneObject = getObjectFromGUID(orangeScriptingZoneGUID)
    local orangeTokenObjects = orangeScriptingZoneObject.getObjects()
    insertRotateToTable(orangeTokenObjects)

    -- #6 Black
    local blackScriptingZoneGUID = "baed0b"
    local blackScriptingZoneObject = getObjectFromGUID(blackScriptingZoneGUID)
    local blackTokenObjects = blackScriptingZoneObject.getObjects()
    insertRotateToTable(blackTokenObjects)

    for _ = 1, 70, 1 do
        coroutine.yield(0)
    end

    -- For each player, move and rotate tokens into positions. (+60 or -60 degrees for each following player)
    for i = 1, playerCount do
        for j, object in ipairs(playerTokenObjects[i]) do -- Cycle through the 8 player tokens j for current player i. #1 & #4 are already good so skip
            if i == 2 or i == 5 then
                object.rotate({x=0, y=60, z=0})
            elseif i == 3 or i == 6 then
                object.rotate({x=0, y=-60, z=0})
            end

            for _ = 1, 5 do
                coroutine.yield(0)
            end

            if alternativeSetup then
                object.setPositionSmooth(playerZoneObjects[i].positionToWorld(playerTokenLocationsB[j]), false, false) -- Set 8 tokens j on current player i's player zone
            else
                object.setPositionSmooth(playerZoneObjects[i].positionToWorld(playerTokenLocationsA[j]), false, false) -- Set 8 tokens j on current player i's player zone
            end

            -- Wait between tokens
            for _ = 1, 15 do
                coroutine.yield(0)
            end
        end
        
        -- Wait between players
        for _ = 1, 80, 1 do
            coroutine.yield(0)
        end
    end

    -- When done deal starting resources
    Wait.time(function ()
        startLuaCoroutine(Global, "DealResourcesCoroutine")
    end, 0.5)

    return 1
end

-- Deals open & closed Exile Tokens to the game board
function DealExileTokens()
    local boardScriptingZoneGUID = "8a89e0"
    local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)
    
    local exiledTokenBagGUID = "445eb7"
    local exiledTokenBagObject = getObjectFromGUID(exiledTokenBagGUID)
    exiledTokenBagObject.interactable = true
    exiledTokenBagObject.shuffle()
    
    local objectsInZone = boardScriptingZoneObject.getObjects()

    for _, object in ipairs(objectsInZone) do
        -- Loop all snapppoint boardScriptingZoneObject and place random exile tokens
        for _, snapPointTable in pairs(object.getSnapPoints()) do
            if snapPointTable.tags[1] == "exile_open" then
                local localPos = snapPointTable.position
                local worldPos = object.positionToWorld(localPos)

                exiledTokenBagObject.takeObject({
                    position = { worldPos.x, worldPos.y, worldPos.z }
                })
            -- Rotate 180 degrees on z when exile closed
            elseif snapPointTable.tags[1] == "exile_closed" then
                local localPos = snapPointTable.position
                local worldPos = object.positionToWorld(localPos)
                local localRot = exiledTokenBagObject.getRotation()
                            
                exiledTokenBagObject.takeObject({
                    position = { worldPos.x, worldPos.y+0.2, worldPos.z },
                    rotation = { localRot.x, localRot.y, localRot.z+180 }, -- Optional, defaults to the container's rotation.
                    callback_function = function(takenObject)
                        takenObject.tooltip = false -- Turn off tooltip when face down
                    end
                })
            end
        end
    end

    -- Collect all tokens after 1 second
    Wait.time(function ()
        CollectExileTokens()
    end, 1)
end

-- All exile tokens on board. Filled in CollectExileTokens(). Used in checkIfExileToken()
local exileTokensTable = {}

function CollectExileTokens()
    local boardScriptingZoneGUID = "8a89e0"
    local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)

    -- Iterate through object occupying the zone
    for _, occupyingObject in ipairs(boardScriptingZoneObject.getObjects(true)) do
        if occupyingObject.type == "Tile" then
            table.insert(exileTokensTable, occupyingObject)
        end
    end
end

local function checkIfExileToken(flippedObject)
    for _, exileToken in ipairs(exileTokensTable) do
        if exileToken == flippedObject then
            return true
        end
    end
end

-- In hotseat mode, this fires twice!
function onPlayerAction(player, action, targets)
    local flippedObject = targets[1]

    -- Only act when an exile token on game board is being flipped. Not newly drawn tokens etc.
    if action == Player.Action.FlipOver and checkIfExileToken(flippedObject) then
        flippedObject.tooltip = true
        broadcastToAll(player.color .. " player flipped the exile token: " .. "`" .. flippedObject.getName() .. "`.")
    end
end

--#region Secret demo stuff, don't look!
local counter  = 0
function DemoClicked(player)
    if player.host then
        counter = counter + 1
    end
    if counter == 10 then
        broadcastToAll("Demo mode unlocked!")
        UI.setAttribute("setupWindow", "active", false) -- Hide the normal UI
        UI.setAttribute("demoWindow", "active", true) -- Show the demo UI
        playerCount = 4
    end
end

function PlayerCountSelected(player, option, id)
    local optionValue = string.sub(option, 1, 1)
    local number = tonumber(optionValue)
    if number then
        playerCount = number
    end
end

function DemoStartClicked()
    UI.setAttribute("demoWindow", "active", false) -- Hide the UI
    
    broadcastToAll("Starting the game with " .. playerCount .. " players. Please wait while everything is being set up!")
    
    -- #1: Shuffle ability bag and reward deck
    local abilityTokenBagGUID = "e98136"
    local abilityTokenBagObject = getObjectFromGUID(abilityTokenBagGUID)
    abilityTokenBagObject. interactable = true
    abilityTokenBagObject.shuffle()

    local rewardDeckGUID = "ff7833"
    local rewardDeckObject = getObjectFromGUID(rewardDeckGUID)
    rewardDeckObject.interactable = true
    rewardDeckObject.shuffle()

    -- #2: Assign colors/seats to players automatically (in order of joining the game)
    SetPlayerColors()

    -- #3: Determine starting player and fix color/turn order
    Wait.time(function ()
        DetermineStartingPlayer()
    end, 2.5)

    -- #4: Restore hand zones to orignal positions
    MoveHandZones("-", 300)
    
    -- #5: Deal Archive cards
    Wait.time(function ()
        startLuaCoroutine(Global, "DealArchiveCardsCoroutine")
    end, 5)
    
    -- #6: Deal Mission cards
    Wait.time(function ()
        SetMissionCards()
    end, 7)
    
    -- #7: Create the board
    Wait.time(function ()
        startLuaCoroutine(Global, "CreateBoardCoroutine")
    end, 9)
end
--#endregion