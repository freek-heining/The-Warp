local alienDeckGUID = "e6fef2"
local advancedAlienDeckGUID = "5be236"
local guardianDeckGUID = "21cccc"
local advancedGuardianDeckGUID = "440784"

local archiveDeckGUID = "6b2a67"
local rewardDeckGUID = "ff7833"
local progressDeckGUID = "935e48"
local ProsperityDeckGUID = "5771e2"
local conquestDeckGUID = "440784"
local pioneeringDeckGUID = "3f46df"
local advancedPioneeringDeckGUID = "4b6ff9"

local exiledTokenBagGUID = "445eb7"
local abilityTokenBagGUID = "e98136"

function onload()
    print("Hello World")
end

--#region StartScreen
local playerCount = 4
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

function StartClicked()
    log('Start game!')
    UI.hide("setupWindow")
    DealAliens()
end
--#endregion

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
        position = {x = -45, y = 1.57, z = 3},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end) -- Optional numberFrames, default = 1 frame
        end,
    })
    
    -- Right Exile
    alienDeckObject.takeObject({
        position = {x = -45, y = 1.57, z = 10.5},
        callback_function = function(spawnedObject)
            Wait.frames(function() spawnedObject.flip() end)
        end,
    })

    -- Warp Guardian
    guardianDeckObject.takeObject({
        position = {x = -45, y = 1.57, z = -13.5}
    })

    for i = 1, playerCount + 1, 1 do
        -- Left alien pile
        alienDeckObject.takeObject({
            position = {x = -51, y = 1.57, z = 21}
        })
        -- Right alien pile
        alienDeckObject.takeObject({
            position = {x = 31.5, y = 1.57, z = 21}
        })       
    end
end

function ExampleCoroutine()
    print("This will run right away, on load.")
    for i=1, 200 do
        coroutine.yield(0)
    end
    print("This will run 200 frames after on load.")
    return 1
end