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
    [1] = { {16.48, 1.68, -15.19}, {0.02, 180.05, 0.08} },
    [2] = { {2.57, 1.68, -8.86}, {359.94, 240.05, 0.05} },
    [3] = { {1.11, 1.68, 6.34}, {359.92, 299.97, 359.97} },
    [4] = { {13.51, 1.68, 15.25}, {359.98, 359.81, 359.92} },
    [5] = { {27.43, 1.68, 8.91}, {0.06, 60.38, 359.95} },
    [6] = { {28.91, 1.68, -6.31}, {0.08, 119.98, 0.03} }
}

-- B sides/backside of boards
local playerZonePositionsB = {
    [1] = { {13.60, 1.68, -15.24}, {0.02, 179.89, 0.08} },
    [2] = { {1.12, 1.68, -6.42}, {359.94, 239.81, 0.05} },
    [3] = { {2.52, 1.68, 8.80}, {359.92, 299.93, 359.97} },
    [4] = { {16.40, 1.68, 15.17}, {359.98, 359.92, 359.92} },
    [5] = { {28.89, 1.68, 6.35}, {0.06, 59.86, 359.95} },
    [6] = { {27.48, 1.68, -8.86}, {0.08, 119.88, 0.03} }
}

-- 2-5 players (position, rotation)
local connectZonePositions = {
    [2] = { {0.37, 1.68, -0.02}, {359.92, 270.21, 0.02} },
    [3] = { {7.69, 1.68, 12.65}, {359.95, 330.04, 359.94} },
    [4] = { {22.28, 1.68, 12.64}, {0.02, 29.89, 359.93} },
    [5] = { {29.60, 1.68, 0.04}, {0.08, 90.08, 359.98} }
}

local portalBPositions = {
    [2] = {3.58, 1.78, 1.84},
    [3] = {10.78, 1.78, 10.62},
    [4] = {22.10, 1.78, 8.72},
    [5] = {26.67, 1.78, -1.89}
}

local connectZonePositionB = {
    [1] = { {22.37, 1.68, -12.69}, {0.05, 150.02, 0.06} }
}

-- Players 1-6 (position, rotation)
local energyZonePositions = {
    [1] = {30.85, 1.53, -46.12},
    [2] = {-12.65, 1.59, -46.12},
    [3] = {-44.27, 1.66, 46.12},
    [4] = {-0.74, 1.60, 46.12},
    [5] = {42.68, 1.54, 46.12},
    [6] = {74.35, 1.46, -46.12}
}

-- Players 1-6 (position, rotation)
local goldZonePositions = {
    [1] = {25.47, 1.58, -46.12},
    [2] = {-18.03, 1.64, -46.12},
    [3] = {-38.87, 1.70, 46.12},
    [4] = {4.61, 1.64, 46.12},
    [5] = {48.13, 1.58, 46.12},
    [6] = {68.97, 1.52, -46.12},
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
    Red = { {22.50, 1.67, -37.50}, {31.78, 1.67, -37.50} },
    Green = { {-21.00, 1.67, -37.50}, {-11.73, 1.67, -37.50} },
    Purple = { {-36.00, 1.67, 37.50}, {-45.29, 1.67, 37.50} },
    Blue = { {7.50, 1.67, 37.50}, {-1.78, 1.67, 37.50} },
    Orange = { {51.00, 1.67, 37.50}, {41.72, 1.67, 37.50} },
    Brown = { {66.01, 1.67, -37.50}, {75.28, 1.67, -37.50} }
}
--#endregion

--#region StartScreenOptions
local alternativeSetup = false
local advancedPioneering = false
local expansionRaces = false

function AlternativeMapToggled(player, isOn)
    UI.setAttribute("alternativeMapToggle", "isOn", isOn)
    
    -- Boolean value from UI Toggle is a string here!
    if isOn == "False" then
        alternativeSetup = false
    elseif isOn == "True" then
        alternativeSetup = true
    end
    log("alternativeSetup: " .. tostring(alternativeSetup))
end

function AdvancedPioneeringToggled(player, isOn)
    UI.setAttribute("advancedPioneeringToggle", "isOn", isOn)

    if isOn == "False" then
        advancedPioneering = false
    elseif isOn == "True" then
        advancedPioneering = true
    end
    log("advancedPioneering: " .. tostring(advancedPioneering))
end

function ExpansionRacesToggled(player, isOn)
    UI.setAttribute("expansionRacesToggle", "isOn", isOn)

    if isOn == "False" then
        expansionRaces = false
    elseif isOn == "True" then
        expansionRaces = true
    end
    log("expansionRaces: " .. tostring(expansionRaces))
end
--#endregion

local playerCount = 0 -- Important variable. Used in lots of functions
local startPlayerNumber = 0 -- Used in: DetermineStartingPlayer() & DealResourcesCoroutine()
local turnOrderTable = {} -- Stores the colors in playing order, for Turns.order, dealing archive cards and resources etc. ( DetermineStartingPlayer() )
local setupDone = false -- Set to true at the end of setup (when alien drafting is finished)

function onload(state)
    log("playerCount: " .. playerCount)
    log("startPlayerNumber: " .. startPlayerNumber)
    log("setupDone: " .. tostring(setupDone))

    -- JSON decode our saved state
    local decodedState = JSON.decode(state)

    if decodedState then
        playerCount = decodedState.variables.playerCount

        setupDone = decodedState.variables.setupDone
        if not setupDone then -- If nil somehow
            setupDone = false
        end

        turnOrderTable = decodedState.variables.turnOrderTable
    end

    --UI.setAttribute("setupWindow", "active", false) -- ENABLE when developing

    SetInteractableFalse() -- Initially set lots of components to interactable = false 

    if not setupDone then
        MoveHandZones("+", 300) -- DISABLE when developing or SAVING board! Move away temporary so nobody selects color manually. 
    else
        UI.setAttribute("setupWindow", "active", false)
    end
end

-- Save crucial data in case of reloading or rewinding. setupDone keeps track of game state
function onSave()
    local state = {
        variables = {
            playerCount = playerCount,
            startPlayerNumber = startPlayerNumber,
            setupDone = setupDone,
            turnOrderTable = turnOrderTable
        }
    }

    return JSON.encode(state)
end

function SetInteractableFalse() -- Initially sets a whole bunch of objects to interactable = false. setupDone for reloading issues.
    local archivePlacementZoneGUID = "cbd643"
    if not setupDone then
        local archivePlacementZoneObject = getObjectFromGUID(archivePlacementZoneGUID)
        archivePlacementZoneObject.call("SetButton", false)
    end

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
    local tavmaTokenGUID = "57649f"
    if not setupDone then
        local alienDeckObject = getObjectFromGUID(alienDeckGUID)
        local advancedAlienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
        local guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
        local advancedGuardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)
        local tavmaTokenObject = getObjectFromGUID(tavmaTokenGUID)
        alienDeckObject.interactable = false
        advancedAlienDeckObject.interactable = false
        guardianDeckObject.interactable = false
        advancedGuardianDeckObject.interactable = false
        tavmaTokenObject.interactable = false
    end

    local alienDemoDeckGUID = "77b52f"
    local advancedAlienDemoDeckGUID = "edee87"
    local guardianDemoDeckGUID = "0c51b4"
    local advancedGuardianDemoDeckGUID = "16aac8"
    if not setupDone then
        local alienDemoDeckObject = getObjectFromGUID(alienDemoDeckGUID)
        local advancedAlienDemoDeckObject = getObjectFromGUID(advancedAlienDemoDeckGUID)
        local guardianDemoDeckObject = getObjectFromGUID(guardianDemoDeckGUID)
        local advancedGuardianDemoDeckObject = getObjectFromGUID(advancedGuardianDemoDeckGUID)
        alienDemoDeckObject.interactable = false
        advancedAlienDemoDeckObject.interactable = false
        guardianDemoDeckObject.interactable = false
        advancedGuardianDemoDeckObject.interactable = false
    end

    local draftZoneClockwiseGUID = "1a436f"
    local draftZoneCounterClockwiseGUID = "2968a3"
    if not setupDone then
        local draftZoneClockwiseObject = getObjectFromGUID(draftZoneClockwiseGUID)
        local draftZoneCounterClockwiseObject = getObjectFromGUID(draftZoneCounterClockwiseGUID)
        draftZoneClockwiseObject.interactable = false
        draftZoneCounterClockwiseObject.interactable = false
    end

    local archiveDeckGUID = "7695b8"
    local startCardDeckGUID = "97c815"
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
    local alienShadowGreenLGUID = "8e037b"
    local alienShadowGreenRGUID = "f176ea"
    local alienShadowPurpleLGUID = "bc0f8d"
    local alienShadowPurpleRGUID = "0835c0"
    local alienShadowBlueLGUID = "3007ae"
    local alienShadowBlueRGUID = "6c09e6"
    local alienShadowOrangeLGUID = "df7e1f"
    local alienShadowOrangeRGUID = "6fe106"
    local alienShadowBrownLGUID = "384a61"
    local alienShadowBrownRGUID = "b3aae6"
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

    local progressCompletedShadowRedGUID = "14add9"
    local prosperityCompletedShadowRedGUID = "470aa8"
    local conquestCompletedShadowRedGUID = "470ddd"
    local pioneeringCompletedShadowRedGUID = "90cde4"
    local progressCompletedShadowGreenGUID = "e7537e"
    local prosperityCompletedShadowGreenGUID = "8e2b8b"
    local conquestCompletedShadowGreenGUID = "e94d25"
    local pioneeringCompletedShadowGreenGUID = "fb2644"
    local progressCompletedShadowPurpleGUID = "1957e0"
    local prosperityCompletedShadowPurpleGUID = "a594c0"
    local conquestCompletedShadowPurpleGUID = "665def"
    local pioneeringCompletedShadowPurpleGUID = "1516ff"
    local progressCompletedShadowBlueGUID = "884025"
    local prosperityCompletedShadowBlueGUID = "e7853e"
    local conquestCompletedShadowBlueGUID = "75f22a"
    local pioneeringCompletedShadowBlueGUID = "d67543"
    local progressCompletedShadowOrangeGUID = "deedb3"
    local prosperityCompletedShadowOrangeGUID = "fc48f6"
    local conquestCompletedShadowOrangeGUID = "2e257c"
    local pioneeringCompletedShadowOrangeGUID = "0a7fd5"
    local progressCompletedShadowBrownGUID = "d11665"
    local prosperityCompletedShadowBrownGUID = "21dfde"
    local conquestCompletedShadowBrownGUID = "8cd70d"
    local pioneeringCompletedShadowBrownGUID = "cbf023"
    local progressCompletedShadowRedObject = getObjectFromGUID(progressCompletedShadowRedGUID)
    local prosperityCompletedShadowRedObject = getObjectFromGUID(prosperityCompletedShadowRedGUID)
    local conquestCompletedShadowRedObject = getObjectFromGUID(conquestCompletedShadowRedGUID)
    local pioneeringCompletedShadowRedObject = getObjectFromGUID(pioneeringCompletedShadowRedGUID)
    local progressCompletedShadowGreenObject = getObjectFromGUID(progressCompletedShadowGreenGUID)
    local prosperityCompletedShadowGreenObject = getObjectFromGUID(prosperityCompletedShadowGreenGUID)
    local conquestCompletedShadowGreenObject = getObjectFromGUID(conquestCompletedShadowGreenGUID)
    local pioneeringCompletedShadowGreenObject = getObjectFromGUID(pioneeringCompletedShadowGreenGUID)
    local progressCompletedShadowPurpleObject = getObjectFromGUID(progressCompletedShadowPurpleGUID)
    local prosperityCompletedShadowPurpleObject = getObjectFromGUID(prosperityCompletedShadowPurpleGUID)
    local conquestCompletedShadowPurpleObject = getObjectFromGUID(conquestCompletedShadowPurpleGUID)
    local pioneeringCompletedShadowPurpleObject = getObjectFromGUID(pioneeringCompletedShadowPurpleGUID)
    local progressCompletedShadowBlueObject = getObjectFromGUID(progressCompletedShadowBlueGUID)
    local prosperityCompletedShadowBlueObject = getObjectFromGUID(prosperityCompletedShadowBlueGUID)
    local conquestCompletedShadowBlueObject = getObjectFromGUID(conquestCompletedShadowBlueGUID)
    local pioneeringCompletedShadowBlueObject = getObjectFromGUID(pioneeringCompletedShadowBlueGUID)
    local progressCompletedShadowOrangeObject = getObjectFromGUID(progressCompletedShadowOrangeGUID)
    local prosperityCompletedShadowOrangeObject = getObjectFromGUID(prosperityCompletedShadowOrangeGUID)
    local conquestCompletedShadowOrangeObject = getObjectFromGUID(conquestCompletedShadowOrangeGUID)
    local pioneeringCompletedShadowOrangeObject = getObjectFromGUID(pioneeringCompletedShadowOrangeGUID)
    local progressCompletedShadowBrownObject = getObjectFromGUID(progressCompletedShadowBrownGUID)
    local prosperityCompletedShadowBrownObject = getObjectFromGUID(prosperityCompletedShadowBrownGUID)
    local conquestCompletedShadowBrownObject = getObjectFromGUID(conquestCompletedShadowBrownGUID)
    local pioneeringCompletedShadowBrownObject = getObjectFromGUID(pioneeringCompletedShadowBrownGUID)
    progressCompletedShadowRedObject.interactable = false
    prosperityCompletedShadowRedObject.interactable = false
    conquestCompletedShadowRedObject.interactable = false
    pioneeringCompletedShadowRedObject.interactable = false
    progressCompletedShadowGreenObject.interactable = false
    prosperityCompletedShadowGreenObject.interactable = false
    conquestCompletedShadowGreenObject.interactable = false
    pioneeringCompletedShadowGreenObject.interactable = false
    progressCompletedShadowPurpleObject.interactable = false
    prosperityCompletedShadowPurpleObject.interactable = false
    conquestCompletedShadowPurpleObject.interactable = false
    pioneeringCompletedShadowPurpleObject.interactable = false
    progressCompletedShadowBlueObject.interactable = false
    prosperityCompletedShadowBlueObject.interactable = false
    conquestCompletedShadowBlueObject.interactable = false
    pioneeringCompletedShadowBlueObject.interactable = false
    progressCompletedShadowOrangeObject.interactable = false
    prosperityCompletedShadowOrangeObject.interactable = false
    conquestCompletedShadowOrangeObject.interactable = false
    pioneeringCompletedShadowOrangeObject.interactable = false
    progressCompletedShadowBrownObject.interactable = false
    prosperityCompletedShadowBrownObject.interactable = false
    conquestCompletedShadowBrownObject.interactable = false
    pioneeringCompletedShadowBrownObject.interactable = false

    local guardianShadowGUID = "70bc1a"
    local exiledShadowGUID = "b19cd4"
    local guardianShadowObject = getObjectFromGUID(guardianShadowGUID)
    local exiledShadowObject = getObjectFromGUID(exiledShadowGUID)
    guardianShadowObject.interactable = false
    exiledShadowObject.interactable = false

    local boardShadowGUID = "7e77de"
    local boardShadowObject = getObjectFromGUID(boardShadowGUID)
    boardShadowObject.interactable = false

    local combatCardAttack1ShadowGUID = "ed677f"
    local combatCardAttack2ShadowGUID = "68a8c0"
    local combatCardDefenseShadowGUID = "ca7ee3"
    local combatCardAttack1ShadowObject = getObjectFromGUID(combatCardAttack1ShadowGUID)
    local combatCardAttack2ShadowObject = getObjectFromGUID(combatCardAttack2ShadowGUID)
    local combatCardDefenseShadowObject = getObjectFromGUID(combatCardDefenseShadowGUID)
    combatCardAttack1ShadowObject.interactable = false
    combatCardAttack2ShadowObject.interactable = false
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

    -- Advanced Pioneering shadows
    if not setupDone then
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

    local rewardDiscardShadowGUID = "4d7fd7"
    local rewardDiscardShadowObject = getObjectFromGUID(rewardDiscardShadowGUID)
    rewardDiscardShadowObject.interactable = false

    local gameBoxGUID = "415c8a"
    local gameBoxObject = getObjectFromGUID(gameBoxGUID)
    gameBoxObject.interactable = false
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

        if alternativeSetup then
            broadcastToAll("Starting the B-side game with " .. playerCount .. " players. Please wait while everything is being set up!")
        else
            broadcastToAll("Starting the standard game with " .. playerCount .. " players. Please wait while everything is being set up!")
        end
        
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

function SetPlayerCount() -- Sets player count each time when start is pressed
    playerCount = 0

    for _, _ in ipairs(Player.getPlayers()) do
        playerCount = playerCount + 1
    end
    log("playerCount: " .. playerCount)
end

function SetPlayerColors() -- Sets player colors according to fixed positions in table
    for i, player in ipairs(Player.getPlayers()) do
        player.changeColor(availablePlayerColors[i])
    end
end

function DetermineStartingPlayer() -- Determines starting player and color/turn order
    startPlayerNumber = math.random(playerCount) -- Integer from 1 - playerCount. Red = 1, Green = 2, Purple = 3, Blue = 4, Orange = 5, Brown = 6
    local startPlayerColor = availablePlayerColors[startPlayerNumber] -- Fixed color matching player numbers/seats
    
    broadcastToAll("-" .. startPlayerColor .. "- is the starting player!", startPlayerColor)
    
    local colorIndex = startPlayerNumber -- Start with color/number of starting player, then continue clockwise from there 

    for i = 1, playerCount do -- Fills the array with colors in player order for this game
        turnOrderTable[i] = availablePlayerColors[colorIndex]
        
        colorIndex = colorIndex + 1

        if  colorIndex > playerCount then -- If last color was reached, reset to use remaining colors from beginning of table
            colorIndex = 1
        end
    end

    Turns.enable = true
    Turns.type = 2 -- 2 = custom.
    Turns.order = turnOrderTable
    Turns.turn_color = startPlayerColor
end

function MoveHandZones(operation, moveValue) -- Move the hand zones back and forth
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

function DealArchiveCardsCoroutine() -- Deals starting card and 4/5 random archive cards to each player
    local archiveDeckGUID = "7695b8"
    local startCardDeckGUID = "97c815"
    local startCardDeckObject = getObjectFromGUID(startCardDeckGUID)
    local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)

    -- Move away scripting zone temporarily, or it will interfere with dealing cards
    local archiveDiscardScriptingZoneGUID = "9198fd"
    local archiveDiscardScriptingZoneObject = getObjectFromGUID(archiveDiscardScriptingZoneGUID)
    local zonePosition = archiveDiscardScriptingZoneObject.getPosition()
    archiveDiscardScriptingZoneObject.setPosition({zonePosition.x, zonePosition.y + 100, zonePosition.z})

    for _ = 1, 20 do
        coroutine.yield(0)
    end

    -- Deal 1 start card to each player 
    for i = 1, playerCount do
        startCardDeckObject.deal(1, turnOrderTable[i])
    end

    for _ = 1, 100 do
        coroutine.yield(0)
    end

    -- Deals 4 archive cards open to table left to right
    archiveDeckObject.shuffle()

    -- #1
    archiveDeckObject.takeObject({
        position = {-24.00, 1.63, 0.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #2
    archiveDeckObject.takeObject({
        position = {-24.00, 1.63, 6.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #3
    archiveDeckObject.takeObject({
        position = {-24.00, 1.63, 12.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #4
    archiveDeckObject.takeObject({
        position = {-24.00, 1.63, 18.00},
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
            archiveDeckObject.deal(4, turnOrderTable[i])
            for _ = 1, 100 do
                coroutine.yield(0)
            end
        else
            archiveDeckObject.deal(5, turnOrderTable[i])
            for _ = 1, 100 do
                coroutine.yield(0)
            end
        end
    end

    -- Move back scripting zone.
    zonePosition = archiveDiscardScriptingZoneObject.getPosition()
    archiveDiscardScriptingZoneObject.setPosition({zonePosition.x, zonePosition.y - 100, zonePosition.z})

    for _ = 1, 20 do
        coroutine.yield(0)
    end

    -- Remove remaining start cards
    local archiveDiscardScriptingZoneGUID = "9198fd"
    local archiveDiscardScriptingZoneObject = getObjectFromGUID(archiveDiscardScriptingZoneGUID)
    for _, object in pairs(archiveDiscardScriptingZoneObject.getObjects()) do
        if object.type == "Card" or object.type == "Deck" then
            object.destruct()
        end
    end

    archiveDeckObject.interactable = true

    -- Re-enable replenish button
    local archivePlacementZoneGUID = "cbd643"
    local archivePlacementZoneObject = getObjectFromGUID(archivePlacementZoneGUID)
    archivePlacementZoneObject.call("SetButton", true)

    return 1
end

function SetMissionCards() -- Lay down 3 random missions and the default or advanced pioneering missions
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
        position = {-33.00, 1.65, -21.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Prosperity mission
    ProsperityDeckObject.shuffle()
    ProsperityDeckObject.takeObject({
        position = {-33.00, 1.65, -15.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end) -- * Optional, defaults to `1`. *
        end
    })

    -- Conquest mission
    conquestDeckObject.shuffle()
    conquestDeckObject.takeObject({
        position = {-33.00, 1.65, -9.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })

    -- Pioneering mission cards #1-6 (Dealt from left to right, per row. The deck is in the correct order)
    -- #1 Overlord
    pioneeringDeckObject.takeObject({
        position = {-37.50, 1.65, -3.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #2 Infinite Riches
    pioneeringDeckObject.takeObject({
        position = {-37.50, 1.65, 3.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #3 Ascension (advanced) OR Expansion
    if advancedPioneering then -- destroy the default card
        pioneeringDeckObject.takeObject({
            position = {-37.50, 1.65, 9.00},
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
                        position = {-37.50, 1.65, 9.00},
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
            position = {-37.50, 1.65, 9.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
    end
    -- #4 Master Trader
    pioneeringDeckObject.takeObject({
        position = {-33.00, 1.65, -3.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #5 Civilization)
    pioneeringDeckObject.takeObject({
        position = {-33.00, 1.65, 3.00},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end
    })
    -- #6 King of Average (advanced) OR Empire
    if advancedPioneering then -- destroy the default card
        pioneeringDeckObject.takeObject({
            position = {-33.00, 1.65, 9.00},
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
                        position = {-33.00, 1.65, 9.00},
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
            position = {-33.00, 1.65, 9.00},
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
            position = {-37.50, 1.65, 15.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
        -- #8
        advancedPioneeringDeckObject.takeObject({
            position = {-33.00, 1.65, 15.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })
        -- #9
        advancedPioneeringDeckObject.takeObject({
            position = {-33.00, 1.65, 21.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end)
            end
        })

        Wait.time(function ()
            -- Destroy remaining card(s)
            local objects = pioneeringScriptingZoneObject.getObjects()
            for _, object in pairs(objects) do
                if object.type == "Card" then
                    object.destruct()
                end
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

local playerZoneObjects = {} -- Stores all used player zones for DealPlayerTokensCoroutine(), filled in CreateBoardCoroutine() (Global var because we cannot pass parameters to a coroutine function).

function CreateBoardCoroutine() -- Create game board dynamically. Also calls DealExileTokens() and DealPlayerTokensCoroutine() when finished
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
        connectZonePositions = connectZonePositionB

        -- swap central zone manually
        params = {
            image = "http://cloud-3.steamusercontent.com/ugc/2508016228644603765/BB45181317EA04A5823CF4EB33944313E5C74D82/",
            thickness = 0.2,
            merge_distance = 5,
            stackable = false,
        }
        centralZoneObject.setCustomObject(params)
        centralZoneObject.reload()
        centralZoneObject = getObjectFromGUID(centralZoneGUID)
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
        if alternativeSetup then -- Just one fixed position for side B!
            connectZoneObject.setPositionSmooth(connectZonePositions[1][1], false, false)
            connectZoneObject.setRotationSmooth(connectZonePositions[1][2], false, false)
        else
            connectZoneObject.setPositionSmooth(connectZonePositions[playerCount][1], false, false)
            connectZoneObject.setRotationSmooth(connectZonePositions[playerCount][2], false, false)
        end
        
        if alternativeSetup then
            portalObject.setPositionSmooth(portalBPositions[playerCount], false, false)
        else
            portalObject.setPositionSmooth({20.26, 1.78, -11.48}, false, false)
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

function DealExileTokens() -- Deals open & closed Exile Tokens to the game board
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

function DealPlayerTokensCoroutine() -- Deals all starting tokens to players. Also calls DealResourcesCoroutine() when finished
    -- All local positions relative to player zone. (Needed to inverse coordinates on x-axis because 180 rotation of zone object)
    -- Order: Troop x3, Troop right, Mine, Trade, Command, Plant (Like in scripting zone right to left)
    local playerTokenLocationsA = {
        [1] = vector(-1.18 , 0.116 , 1.035),
        [2] = vector(-0.003 , 0.108 , 0.672),
        [3] = vector(-0.177 , 0.108 , 0.786),
        [4] = vector(-0.209 , 0.108 , 1.004),
        [5] = vector(0.655 , 0.120 , 0.791),
        [6] = vector(-0.048 , 0.105 , 1.247),
        [7] = vector(0.591 , 0.105 , 1.298),
        [8] = vector(0.2 , 0.120 , 1.003)
    }

    -- Locations when using B-side
    local playerTokenLocationsB = {
        [1] = vector(-0.574 , 0.120 , 0.666),
        [2] = vector(-0.746 , 0.120 , 0.784),
        [3] = vector(-0.755 , 0.107 , 0.996),
        [4] = vector(-1.753 , 0.111 , 1.039),
        [5] = vector(0.082 , 0.106 , 0.795),
        [6] = vector(-0.621 , 0.121 , 1.251),
        [7] = vector(0.018 , 0.106 , 1.302),
        [8] = vector(-0.373 , 0.106 , 1.007)
    }

    -- All starting miniatures, filtered per color in indexed order: Troop, Troop, Troop, Troop, Mine, Trade, Command, Plant
    -- Nested tables for different player numbers!
    local playerTokenObjects = {}

    -- Filter and insert tokens in playerTokenObjects table 
    local function insertRotateToTable(objects)
        local trimmedTable = {}
        local j = 1 -- Counter for troop tokens 1-4
        -- Ignore nameless/useless catched objects and rotate & order the rest
        for _, object in ipairs(objects) do
            if object.getName() == "" then
                -- do nothing
            elseif object == nil then
                -- do nothing
            elseif object.getName() == "Troop Token"  then
                object.rotate({x=0, y=60, z=0})
                trimmedTable[j] = object
                j = j + 1
            elseif object.getName() == "Mine"  then
                object.rotate({x=0, y=60, z=0})
                trimmedTable[6] = object
            elseif object.getName() == "Trade Post"  then
                object.rotate({x=0, y=-30, z=0})
                trimmedTable[8] = object
            elseif object.getName() == "Command Center"  then
                object.rotate({x=0, y=-30, z=0})
                trimmedTable[5] = object
            elseif object.getName() == "Energy Plant"  then
                object.rotate({x=0, y=-90, z=0})
                trimmedTable[7] = object
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
        for j, object in ipairs(playerTokenObjects[i]) do -- Cycle through the 8 player tokens 'j', to rotate for current player 'i'. #1 & #4 are already good so skip
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
        for _ = 1, 70, 1 do
            coroutine.yield(0)
        end
    end

    -- When done deal starting resources
    Wait.time(function ()
        startLuaCoroutine(Global, "DealResourcesCoroutine")
    end, 0.5)

    return 1
end

function DealResourcesCoroutine() -- Deals starting gold/energy to players according to table in manual. Also calls DealAliensCoroutine() when finished 
    local energySpawnerGUID = "98a3fe"
    local goldSpawnerGUID = "0b18bb"

    local energySpawnerObject = getObjectFromGUID(energySpawnerGUID)
    local goldSpawnerObject = getObjectFromGUID(goldSpawnerGUID)

    local playerColorIndex = startPlayerNumber -- Start with number/color of starting player, then continue clockwise from there 

    broadcastToAll("Almost done setting up...")

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

function DealAliensCoroutine() -- Handles the alien/guardian drafting. Also calls DealMissionCardsCoroutine() Sets setupDone = true at the end
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
    local tavmaTokenGUID = "57649f"

    local alienDeckObject = getObjectFromGUID(alienDeckGUID)
    local advancedAlienDeckObject = getObjectFromGUID(advancedAlienDeckGUID)
    local guardianDeckObject = getObjectFromGUID(guardianDeckGUID)
    local advancedGuardianDeckObject = getObjectFromGUID(advancedGuardianDeckGUID)
    local tavmaTokenObject = getObjectFromGUID(tavmaTokenGUID)

    broadcastToAll("Time to draft our Alien Races...")

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
        position = {-49.16, 1.66, 4.50},
        callback_function = function(spawnedObject)
            Wait.time(function() spawnedObject.flip() end, 1)
            Wait.time(function() spawnedObject.setLock(true) end, 3)
        end
    })
    
    -- Right Exile
    alienPlayDeckObject.takeObject({
        position = {-49.16, 1.67, 12.00},
        callback_function = function(spawnedObject)
            Wait.time(function() spawnedObject.flip() end, 1)
            Wait.time(function() spawnedObject.setLock(true) end, 3)
        end
    })

    -- Create 2 random alien race piles with Classic UI buttons. Card amount per pile = player count + 1
    for i = 1, playerCount + 1 do
        -- Counterclockwise alien pile
        alienPlayDeckObject.takeObject({
            position = draftZonePositionsCCW[i],
            callback_function = function(spawnedObject)
                spawnedObject.locked = true
                spawnedObject.createButton({
                    click_function = "DraftZoneCounterClockwiseClicked",
                    width = 1000,
                    height = 300,
                    position = {0,0,1.9},
                    color = turnOrderTable[playerCount],
                    label = turnOrderTable[playerCount] .. " choose",
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
                    width = 1000,
                    height = 300,
                    position = {0,0,1.9},
                    color = turnOrderTable[1],
                    label = turnOrderTable[1] .. " choose",
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

    local tavmaChosen = false -- Flag for Tava token, to know if to destroy it yes or no later

    local clockwiseCounter = 1 -- Keeps track of right pile active player
    local counterClockwiseCounter = playerCount -- Keeps track of left pile active player

    broadcastToAll(turnOrderTable[clockwiseCounter] .. ", choose an Alien Race from the 'Clockwise' pile.", turnOrderTable[clockwiseCounter])
    broadcastToAll(turnOrderTable[counterClockwiseCounter] .. ", choose an Alien Race from the 'Counterclockwise' pile.", turnOrderTable[counterClockwiseCounter])

    function GrabMatchingGuardianCounterclockwiseCoroutine() -- Is fired twice because of clone card also being detected
        local matchingGuardianGUID = nil
        local remainingAlienPosition = nil
        local remainingAlienName = nil

        -- Wait first so last chosen card is settled at player
        for _ = 1, 100 do
            coroutine.yield(0)
        end

        local zoneObjects1 = scriptingZoneCounterClockwiseObject.getObjects()

        -- Get data from the 1 remaining Alien Race
        for _, object in ipairs(zoneObjects1) do
            if object.type == "Card" then
                remainingAlienPosition = object.getPosition()
                remainingAlienName = object.getName()
            end
        end

        -- Look for matching guardian in the guardian deck and save its GUID
        if remainingAlienName then -- Nill check
            for _, guardianCard in ipairs(guardianPlayDeckObject.getObjects()) do
                if  guardianCard.name == remainingAlienName then
                    matchingGuardianGUID = guardianCard.guid
                end
            end
        end

        local function putBackCard(card)
            guardianPlayDeckObject.setLock(false) -- putObject doesn't work on locked objects!
            guardianPlayDeckObject.putObject(card)
            guardianPlayDeckObject.setLock(true)
        end

        -- Take matching guardian from deck to clone and place near unchosen Alien card
        if matchingGuardianGUID then -- Nill check
            guardianPlayDeckObject.takeObject({
                guid = matchingGuardianGUID,
                callback_function = function(matchingGuardian)
                    matchingGuardian.clone({ position = remainingAlienPosition })
                    putBackCard(matchingGuardian)
                end
            })
        end

        -- Wait for cloned card to settle
        for _ = 1, 300 do
            coroutine.yield(0)
        end

        -- Lock cloned card
        local zoneObjects2 = scriptingZoneCounterClockwiseObject.getObjects()
        for _, object in ipairs(zoneObjects2) do
            if object.type == "Card" then
                object.setLock(true)
            end
        end

        return 1
    end

    function GrabMatchingGuardianClockwiseCoroutine() -- Is fired twice because of clone card also being detected
        local matchingGuardianGUID = nil
        local remainingAlienPosition = nil
        local remainingAlienName = nil

        -- Wait first so last chosen card is settled at player
        for _ = 1, 100 do
            coroutine.yield(0)
        end

        local zoneObjects1 = scriptingZoneClockwiseObject.getObjects()

        -- Get data from the 1 remaining Alien Race
        for _, object in ipairs(zoneObjects1) do
            if object.type == "Card" then -- Should only be 1 card total!
                remainingAlienPosition = object.getPosition()
                remainingAlienName = object.getName()
            end
        end

        -- Look for matching guardian in the guardian deck and save its GUID
        if remainingAlienName then -- Nill check
            for _, guardianCard in ipairs(guardianPlayDeckObject.getObjects()) do
                if  guardianCard.name == remainingAlienName then
                    matchingGuardianGUID = guardianCard.guid
                end
            end
        end

        local function putBackCard(card)
            guardianPlayDeckObject.setLock(false) -- putObject doesn't work on locked objects!
            guardianPlayDeckObject.putObject(card)
            guardianPlayDeckObject.setLock(true)
        end

        -- Take matching guardian from deck to clone and place near unchosen Alien card
        if matchingGuardianGUID then -- Nill check
            guardianPlayDeckObject.takeObject({
                guid = matchingGuardianGUID,
                callback_function = function(matchingGuardian)
                    matchingGuardian.clone({ position = remainingAlienPosition })
                    putBackCard(matchingGuardian)
                end
            })
        end

        -- Wait for cloned card to settle
        for _ = 1, 300 do
            coroutine.yield(0)
        end

        -- Lock cloned card
        local zoneObjects2 = scriptingZoneClockwiseObject.getObjects()
        for _, object in ipairs(zoneObjects2) do
            if object.type == "Card" then
                object.setLock(true)
            end
        end

        return 1
    end

    function DraftZoneCounterClockwiseClicked(obj, color) -- Left draft pile
        if color == turnOrderTable[counterClockwiseCounter] then
            obj.removeButton(0)
            obj.locked = false
            local targetLocation = alienRacePlayerZones[turnOrderTable[counterClockwiseCounter]][1]
            obj.setPositionSmooth(targetLocation, false, false)
            
            -- If Tavma is chosen, move token with it
            if obj.getName() == "Tavma Morphlings" then
                tavmaChosen = true
                local tokenLocation = Vector(targetLocation[1]+3, targetLocation[2], targetLocation[3])
                tavmaTokenObject.interactable = true
                if color == "Brown" or color == "Red" or color == "Green" then
                    tavmaTokenObject.setRotationSmooth({0, 180, 0}, false, false)
                else
                    tavmaTokenObject.setRotationSmooth({0, 0, 0}, false, false)
                end
                tavmaTokenObject.setPositionSmooth(tokenLocation, false, false)
            end

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

            local zoneObjects = scriptingZoneCounterClockwiseObject.getObjects() -- Grab all remaining objects in scripting zone each cycle

            for _, object in ipairs(zoneObjects) do
                if counterClockwiseCounter < 1 and object.type == "Card" then -- When 2nd last card of pile is drafted, 1 remains for guardian draft. 
                    object.editButton({ -- Only affects the last remaining card, because we destroy the buttons on the others. There is still more then 1 object in zoneObjects table!
                        index = 0,
                        label = "Warp Guardian",
                        click_function = "GuardianClicked",
                        tooltip = "Choose this Alien Race to become the Warp Guardian!",
                        width = 1100,
                        color = turnOrderTable[playerCount] -- Reset button color to last player in order
                    })

                    startLuaCoroutine(Global, "GrabMatchingGuardianCounterclockwiseCoroutine")

                elseif object.type == "Card" then -- Change all buttons color to next player in line's color
                    object.editButton({
                        index=0, 
                        color=turnOrderTable[counterClockwiseCounter],
                        label=turnOrderTable[counterClockwiseCounter] .. " choose",
                    })
                end
            end
            
            if clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
                broadcastToAll(turnOrderTable[playerCount] .. ", choose the Warp Guardian from the left or right pile.", turnOrderTable[playerCount])
            elseif counterClockwiseCounter >= 1 then
                broadcastToAll(turnOrderTable[counterClockwiseCounter] .. ", choose an Alien Race from the 'Counterclockwise' pile.", turnOrderTable[counterClockwiseCounter])
            end
        else
            print("Not your turn to pick from this pile!")
        end
    end

    function DraftZoneClockwiseClicked(obj, color) -- Right draft pile
        if color == turnOrderTable[clockwiseCounter] then
            obj.removeButton(0)
            obj.locked = false
            local targetLocation = alienRacePlayerZones[turnOrderTable[clockwiseCounter]][2]
            obj.setPositionSmooth(targetLocation, false, false)

            -- If Tavma is chosen, move token with it
            if obj.getName() == "Tavma Morphlings" then
                tavmaChosen = true
                local tokenLocation = Vector(targetLocation[1]+3, targetLocation[2], targetLocation[3])
                tavmaTokenObject.interactable = true
                if color == "Brown" or color == "Red" or color == "Green" then
                    tavmaTokenObject.setRotationSmooth({0, 180, 0}, false, false)
                else
                    tavmaTokenObject.setRotationSmooth({0, 0, 0}, false, false)
                end
                tavmaTokenObject.setPositionSmooth(tokenLocation, false, false)
            end

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
            
            local zoneObjects = scriptingZoneClockwiseObject.getObjects() -- Grab all remaining cards each cycle

            for _, object in ipairs(zoneObjects) do
                if clockwiseCounter > playerCount and object.type == "Card" then -- When 2nd last card of pile is drafted, 1 remains for guardian draft.
                    object.editButton({
                        index = 0,
                        label = "Warp Guardian",
                        click_function = "GuardianClicked",
                        tooltip = "Choose this Alien Race to become the Warp Guardian!",
                        width = 1100
                    })

                    startLuaCoroutine(Global, "GrabMatchingGuardianClockwiseCoroutine")

                elseif object.type == "Card" then -- Change all buttons color to next player in line's color
                    object.editButton({
                        index=0, 
                        color=turnOrderTable[clockwiseCounter],
                        label=turnOrderTable[clockwiseCounter] .. " choose",
                    })
                end
            end

            if clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
                broadcastToAll(turnOrderTable[playerCount] .. ", choose the Warp Guardian from the left or right pile.", turnOrderTable[playerCount])
            elseif clockwiseCounter <= playerCount then
                broadcastToAll(turnOrderTable[clockwiseCounter] .. ", choose an Alien Race from the 'Clockwise' pile.", turnOrderTable[clockwiseCounter])
            end
        else
            print("Not your turn to pick from this pile!")
        end
    end

    -- Only when 1 alien left on both sides can we choose the warp guardian. Selecting one moves it to the guardian spot on table
    function GuardianClicked(obj, color)
        if color == turnOrderTable[playerCount] and clockwiseCounter > playerCount and counterClockwiseCounter < 1 then
            local chosenGuardianName = obj.getName()
            broadcastToAll("'" .. chosenGuardianName .. "' is chosen to be the Warp Guardian.")

            obj.removeButton(0)
            obj.setPositionSmooth({-49.16, 1.66, -11.25}, false, false) -- Move to Guardian spot on table

            -- Destroy remaining cards (after 3 seconds)
            Wait.time(function ()
                obj.setLock(true) -- Lock chosen alien card 

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

            -- Look for corresponding guardian in the guardian deck, to place over the chosen alien guardian card (after 1,5 seconds)
            Wait.time(function ()
                local guardianGUID = nil
                for _, guardianCard in ipairs(guardianPlayDeckObject.getObjects()) do
                    if  guardianCard.name == chosenGuardianName then
                        guardianGUID = guardianCard.guid
                    end
                end
            
                -- Take corresponding guardian from deck to place over the chosen alien card. (y=1.80 /higher)
                if guardianGUID then
                    guardianPlayDeckObject.takeObject({
                        guid = guardianGUID,
                        position = {-49.16, 1.80, -11.25},
                        callback_function = function(chosenGuardian)
                            Wait.time(function ()
                                chosenGuardian.setLock(true) -- Lock guardian after 2 seconds
                            end, 2)
                        end
                    })
                end
                
                -- Remove leftover decks
                alienPlayDeckObject.destruct()
                guardianPlayDeckObject.destruct()

                -- Remove Tavma token if nobody chose it
                if not tavmaChosen then
                    tavmaTokenObject.destruct()
                end
            end, 1.5)

            -- When drafting is done, deal 6 mission cards to each player
            Wait.time(function ()
                startLuaCoroutine(Global, "DealMissionCardsCoroutine")
            end, 4)

            -- Set demo decks interactable again after 1 second
            Wait.time(function ()
            local alienDemoDeckGUID = "77b52f"
            local advancedAlienDemoDeckGUID = "edee87"
            local guardianDemoDeckGUID = "0c51b4"
            local advancedGuardianDemoDeckGUID = "16aac8"
            local alienDemoDeckObject = getObjectFromGUID(alienDemoDeckGUID)
            local advancedAlienDemoDeckObject = getObjectFromGUID(advancedAlienDemoDeckGUID)
            local guardianDemoDeckObject = getObjectFromGUID(guardianDemoDeckGUID)
            local advancedGuardianDemoDeckObject = getObjectFromGUID(advancedGuardianDemoDeckGUID)
            alienDemoDeckObject.interactable = true
            advancedAlienDemoDeckObject.interactable = true
            guardianDemoDeckObject.interactable = true
            advancedGuardianDemoDeckObject.interactable = true
            end, 1)

        elseif color == turnOrderTable[playerCount] then
            print("Wait for the other draft pile to complete!")
        else
            print("You cannot choose the Warp Guardian!")
        end
    end

    setupDone = true

    return 1
end

function DealMissionCardsCoroutine() -- Deals 2 missions of each color to the players to keep 1 of each. Last function te be called in the setup chain.
    local progressDeckGUID = "935e48"
    local ProsperityDeckGUID = "5771e2"
    local conquestDeckGUID = "f4ccdd"

    local progressDeckObject = getObjectFromGUID(progressDeckGUID)
    local ProsperityDeckObject = getObjectFromGUID(ProsperityDeckGUID)
    local conquestDeckObject = getObjectFromGUID(conquestDeckGUID)

    -- Move away scripting zone temporarily, or it will interfere with dealing cards
    local archiveDiscardScriptingZoneGUID = "9198fd"
    local archiveDiscardScriptingZoneObject = getObjectFromGUID(archiveDiscardScriptingZoneGUID)
    local zonePosition = archiveDiscardScriptingZoneObject.getPosition()
    archiveDiscardScriptingZoneObject.setPosition({zonePosition.x, zonePosition.y + 100, zonePosition.z})

    for _ = 1, 20 do
        coroutine.yield(0)
    end

    for _, color in pairs(turnOrderTable) do
        progressDeckObject.deal(2, color)
        for _ = 1, 60 do
            coroutine.yield(0)
        end
        ProsperityDeckObject.deal(2, color)
        for _ = 1, 60 do
            coroutine.yield(0)
        end
        conquestDeckObject.deal(2, color)
        for _ = 1, 60 do
            coroutine.yield(0)
        end
    end

    broadcastToAll("Keep 3 missions of any color, and place the others back facedown on their repective draw pile. Shuffle afterwards.")

    ProsperityDeckObject.interactable = true
    progressDeckObject.interactable = true
    conquestDeckObject.interactable = true

    -- Move back scripting zone.
    zonePosition = archiveDiscardScriptingZoneObject.getPosition()
    archiveDiscardScriptingZoneObject.setPosition({zonePosition.x, zonePosition.y - 100, zonePosition.z})

    return 1
end

-- All exile tokens on board. Filled in CollectExileTokens(). Used in checkIfExileTokenOnBoard()
local exileTokensTable = {}

-- Gets all exile tokens on board and put in exileTokensTable. Called in DealExileTokens()
function CollectExileTokens() 
    local boardScriptingZoneGUID = "8a89e0"
    local boardScriptingZoneObject = getObjectFromGUID(boardScriptingZoneGUID)

    for _, occupyingObject in ipairs(boardScriptingZoneObject.getObjects(true)) do
        if occupyingObject.type == "Tile" then
            table.insert(exileTokensTable, occupyingObject)
        end
    end
end

local function checkIfExileTokenOnBoard(flippedObject)
    for _, exileToken in ipairs(exileTokensTable) do
        if exileToken == flippedObject then
            return true
        end
    end
end

-- Exile token flip sets tooltip and notify
function onPlayerAction(player, action, targets)
    local flippedObject = targets[1]

    -- Only act when an exile token on game board is being flipped. Not newly drawn tokens etc.
    if action == Player.Action.FlipOver and checkIfExileTokenOnBoard(flippedObject) then
        flippedObject.tooltip = true
        broadcastToAll(player.color .. " player flipped the exile token: " .. "'" .. flippedObject.getName() .. "'.")
    end
end


local cardClick1Toggled = false
function cardClick1(obj, color, alt_click)
    if cardClick1Toggled then -- off
        obj.editButton({
            index=0,
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick1Toggled = false
    else -- on
        obj.editButton({
            index=0,
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick1Toggled = true
    end
end
local cardClick2Toggled = false
function cardClick2(obj, color, alt_click)
    if cardClick2Toggled then -- off
        obj.editButton({
            index=1, 
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick2Toggled = false
    else -- on
        obj.editButton({
            index=1, 
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick2Toggled = true
    end
end
local cardClick3Toggled = false
function cardClick3(obj, color, alt_click)
    if cardClick3Toggled then -- off
        obj.editButton({
            index=2, 
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick3Toggled = false
    else -- on
        obj.editButton({
            index=2, 
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick3Toggled = true
    end
end
local cardClick4Toggled = false
function cardClick4(obj, color, alt_click)
    if cardClick4Toggled then -- off
        obj.editButton({
            index=0,
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick4Toggled = false
    else -- on
        obj.editButton({
            index=0,
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick4Toggled = true
    end
end
local cardClick5Toggled = false
function cardClick5(obj, color, alt_click)
    if cardClick5Toggled then -- off
        obj.editButton({
            index=1, 
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick5Toggled = false
    else -- on
        obj.editButton({
            index=1, 
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick5Toggled = true
    end
end
local cardClick6Toggled = false
function cardClick6(obj, color, alt_click)
    if cardClick6Toggled then -- off
        obj.editButton({
            index=2, 
            color={192/255, 192/255, 192/255},       -- grey
            hover_color={0/255, 200/255, 47/255},    -- darker green
            press_color={0/255, 154/255, 37/255},    -- darkest green
        })
        cardClick6Toggled = false
    else -- on
        obj.editButton({
            index=2, 
            color={0/255, 247/255, 58/255},          -- green
            hover_color={143/255, 143/255, 143/255}, -- darker grey
            press_color={93/255, 93/255, 93/255},    -- darkest grey
        })
        cardClick6Toggled = true
    end
end

-- Sets UI radio buttons at spawned combat cards (type 2,3 & 4's)
function onObjectSpawn(obj)
    local params1 = {
        click_function = "cardClick1",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, -0.65},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }
    local params2 = {
        click_function = "cardClick2",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, 0},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }
    local params3 = {
        click_function = "cardClick3",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, 0.65},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }
    local params4 = {
        click_function = "cardClick4",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, -0.23},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }
    local params5 = {
        click_function = "cardClick5",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, 0.27},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }
    local params6 = {
        click_function = "cardClick6",
        function_owner = self,
        label          = "←",
        position       = {0.93, 0.4, 0.77},
        width          = 140,
        height         = 140,
        font_size      = 120,
        color          = {192/255, 192/255, 192/255},   -- grey
        font_color     = {1, 1, 1},                     -- white
        hover_color    = {0/255, 200/255, 47/255},      -- darker green
        press_color    = {0/255, 154/255, 37/255},      -- darkest green
        tooltip        = "Choose this combat option",
    }

    if obj.hasTag("combat_card_2") then
        obj.createButton(params1)
        obj.createButton(params2)
    elseif obj.hasTag("combat_card_3") then
        obj.createButton(params1)
        obj.createButton(params2)
        obj.createButton(params3)
    elseif obj.hasTag("combat_card_4") then
        obj.createButton(params4)
        obj.createButton(params5)
        obj.createButton(params6)
    end
end