local archiveDiscardScriptingZoneGUID = "9198fd"
local archiveDiscardScriptingZoneObject = getObjectFromGUID(archiveDiscardScriptingZoneGUID)

local archiveDeckGUID = "7695b8"
local archiveDeckObject = getObjectFromGUID(archiveDeckGUID)
local archiveDeckScriptingZoneGUID = "ceb0b5"
local archiveDeckScriptingZoneObject = getObjectFromGUID(archiveDeckScriptingZoneGUID)

local archiveScripting1ZoneGUID = "a6953a"
local archiveScripting1ZoneObject = getObjectFromGUID(archiveScripting1ZoneGUID)
local archiveScripting2ZoneGUID = "c138c6"
local archiveScripting2ZoneObject = getObjectFromGUID(archiveScripting2ZoneGUID)
local archiveScripting3ZoneGUID = "d7b4e8"
local archiveScripting3ZoneObject = getObjectFromGUID(archiveScripting3ZoneGUID)
local archiveScripting4ZoneGUID = "5b418e"
local archiveScripting4ZoneObject = getObjectFromGUID(archiveScripting4ZoneGUID)

-- Check if card present in scripting zone
local function checkCardsPresent(scriptingZone)
    for _, object in pairs(scriptingZone.getObjects()) do
        if object.type == "Card" then
            return true
        elseif object.type == "Deck" then
            return true
        end
    end

    return false
end

 -- Check if Archive deck is empty and discard pile has cards. If so, recreate new deck from discard pile
 local function checkDeckEmptyAndRecreate()
    if not checkCardsPresent(archiveDeckScriptingZoneObject) and checkCardsPresent(archiveDiscardScriptingZoneObject) then
        for _, object in pairs(archiveDiscardScriptingZoneObject.getObjects()) do
            if object.type == "Card" then
                broadcastToAll("Please discard all Archive cards on the corresponding discard pile", "Red")
                
                object.flip()
                object.setPositionSmooth({-24.00, 1.92, -10.50}, false, false)
                
                return true
            elseif object.type == "Deck" then
                log("Deck found on discard pile")
                
                object.flip()
                object.shuffle()
                object.setPositionSmooth({-24.00, 1.92, -10.50}, false, false)
                
                archiveDeckObject = object
                
                return true
            end
        end
    end

    return false
end

function ReplenishSpotsCoroutine()
    -- #1 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end
    if not checkCardsPresent(archiveScripting1ZoneObject) then
        log("1 is empty")
        archiveDeckObject.takeObject({
            position = {-24.00, 1.63, 0.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end, 10)
            end
        })
    end

    -- #2 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end
    if not checkCardsPresent(archiveScripting2ZoneObject) then
        log("2 is empty")
        archiveDeckObject.takeObject({
            position = {-24.00, 1.63, 6.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end, 10)
            end
        })
    end

    -- #3 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end
    if not checkCardsPresent(archiveScripting3ZoneObject) then
        log("3 is empty")
        archiveDeckObject.takeObject({
            position = {-24.00, 1.63, 12.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end, 10)
            end
        })
    end

    -- #4 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end
    if not checkCardsPresent(archiveScripting4ZoneObject) then
        log("4 is empty")
        archiveDeckObject.takeObject({
            position = {-24.00, 1.63, 18.00},
            callback_function = function(spawnedObject)
                Wait.frames(function() spawnedObject.flip() end, 10)
            end
        })
    end

    TODO: 4 of same type check

    return 1
end

function ReplenishClicked()
    startLuaCoroutine(self, "ReplenishSpotsCoroutine")
end

-- Automates Archive discarding and makes them all face-up
function onObjectEnterZone(zone, object)
    if zone.guid == "9198fd" and object.type == "Card" then
        MoveWaitId = Wait.time(function ()
            object.setPositionSmooth({-24.00, 3.00, -19.50}, false, false)
        end, 0.4)

        if object.is_face_down then
            Wait.time(function ()
                object.flip()
            end, 1)
        end
    end
end

-- Stops the scheduled motion when manually drawing card from discard. Or we can't draw anymore if we wanted.
function onObjectLeaveZone(zone, object)
    if zone.guid == "9198fd" and object.type == "Card" then
        Wait.stop(MoveWaitId)
    end
end