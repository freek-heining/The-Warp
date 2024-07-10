local archiveDiscardScriptingZoneGUID = "9198fd"
local archiveDiscardScriptingZoneObject = getObjectFromGUID(archiveDiscardScriptingZoneGUID)

local lastCardObject = nil
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

-- Check if card or deck present in scripting zone = true
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
            -- Only 1 card in discard, should not happen when deck is empty
            if object.type == "Card" then
                broadcastToAll("Cannot fully recreate Archive deck because cards are missing! Please discard all Archive cards on the discard pile.", "Red")
                object.flip()
                object.setPositionSmooth({-24.00, 1.92, -10.50}, false, false)
                
                return true
            -- Discard deck is present
            elseif object.type == "Deck" then
                object.flip()
                object.shuffle()
                object.setPositionSmooth({-24.00, 1.92, -10.50}, false, false)
                
                -- Set new deck object
                archiveDeckObject = object
                
                return true
            end
        end
    -- Empty discard and deck spots. This should never happen unless of wrong player behavior
    elseif not checkCardsPresent(archiveDeckScriptingZoneObject) and not checkCardsPresent(archiveDiscardScriptingZoneObject) then
        broadcastToAll("No Archive cards found on discard and deck spot! Please place all Archive cards on the correct spots and try again...", "Red")
    end

    return false
end

 -- Reset Archive because 4 of the same type. Check all 4 open piles + 1 discard pike for cards, and move them to deck location. Then shuffle and deal again.
function ResetArchiveCoroutine()
    -- Make sure there is an Archive deck
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end

    -- #1
    if checkCardsPresent(archiveScripting1ZoneObject) and archiveDeckObject ~= nil then
        for _, object in pairs(archiveScripting1ZoneObject.getObjects()) do
            if object.type == "Card" then
                object.putObject(archiveDeckObject)
            end
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #2
    if checkCardsPresent(archiveScripting2ZoneObject) and archiveDeckObject ~= nil then
        for _, object in pairs(archiveScripting2ZoneObject.getObjects()) do
            if object.type == "Card" then
                object.putObject(archiveDeckObject)
            end
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #3
    if checkCardsPresent(archiveScripting3ZoneObject) and archiveDeckObject ~= nil then
        for _, object in pairs(archiveScripting3ZoneObject.getObjects()) do
            if object.type == "Card" then
                object.putObject(archiveDeckObject)
            end
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #4
    if checkCardsPresent(archiveScripting4ZoneObject) and archiveDeckObject ~= nil then
        for _, object in pairs(archiveScripting4ZoneObject.getObjects()) do
            if object.type == "Card" then
                object.putObject(archiveDeckObject)
            end
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- Discard pile: if deck, move above Archive deck. If card, put in Archive deck
    if checkCardsPresent(archiveDiscardScriptingZoneObject) and archiveDeckObject ~= nil then
        for _, object in pairs(archiveDiscardScriptingZoneObject.getObjects()) do
            if object.type == "Deck" then
                object.flip()
                object.setPositionSmooth({-24.00, 3.90, -10.50}, false, true)
            end
            if object.type == "Card" then
                object.putObject(archiveDeckObject)
            end
        end
    end

    if archiveDeckObject ~= nil then
        for _ = 1, 250 do
            coroutine.yield(0)
        end

        archiveDeckObject.shuffle()

        for _ = 1, 100 do
            coroutine.yield(0)
        end
    
        startLuaCoroutine(self, "ReplenishSpotsCoroutine")
    end

    return 1
end

-- Checks the 4 spots for same type. Starts 'ResetArchiveCoroutine' if it is.
local function checkAllSameType()
    local type1
    local type2
    local type3
    local type4
    local cardCounter = 0

    local function getTypeTag(card)
        if card.hasTag("combat") then
            return "combat"
        elseif card.hasTag("upgrade") then
            return "upgrade"
        elseif card.hasTag("build")  then
            return "build"
        end
    end

    for _, object in pairs(archiveScripting1ZoneObject.getObjects()) do
        if object.type == "Card" then
            type1 = getTypeTag(object)
            cardCounter = cardCounter + 1
        end
    end
    for _, object in pairs(archiveScripting2ZoneObject.getObjects()) do
        if object.type == "Card" then
            type2 = getTypeTag(object)
            cardCounter = cardCounter + 1
        end
    end
    for _, object in pairs(archiveScripting3ZoneObject.getObjects()) do
        if object.type == "Card" then
            type3 = getTypeTag(object)
            cardCounter = cardCounter + 1
        end
    end
    for _, object in pairs(archiveScripting4ZoneObject.getObjects()) do
        if object.type == "Card" then
            type4 = getTypeTag(object)
            cardCounter = cardCounter + 1
        end
    end

    -- Only take action when 4 open Archive cards detected and all are of the same type
    if cardCounter ~= 4 then
        broadcastToAll("Less then 4 open Archive cards detected! Please make sure all cards are in place.", "Red")
    elseif type1 == type2 and type1 == type3 and type1 == type4 then
        broadcastToAll("4 Archive cards of the same type, so the Archive deck is reshuffled!")
        startLuaCoroutine(self, "ResetArchiveCoroutine")
    end
end

-- Check for last card from deck and set it. Or re-set deck object to be sure. We filter our card and deck types from other retrieved objects!
local function setDeckOrLastCard()
    for _, object in pairs(archiveDeckScriptingZoneObject.getObjects()) do
        if object.type == "Card" then
            -- Set last card of deck to use
            log("set card")
            lastCardObject = object
            archiveDeckObject = nil
        elseif object.type == "Deck" then
            -- Set new deck object
            log("set deck")
            archiveDeckObject = object
            lastCardObject = nil
        end
    end
end

-- Checks all 4 spots if empty and refills them. Then after delay, check if all are same type with checkAllSameType(), only when replenished
function ReplenishSpotsCoroutine()
    local replenished = false

    -- #1 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end

    -- Check for last card from deck each spot. (Deck stops existing then)
    setDeckOrLastCard()

    if not checkCardsPresent(archiveScripting1ZoneObject) then
        if archiveDeckObject ~= nil then
            archiveDeckObject.takeObject({
                position = {-24.00, 2.00, 0.00},
                flip = true
            })
            replenished = true
        elseif lastCardObject ~= nil then
            lastCardObject.setPosition({-24.00, 3.00, 0.00})
            Wait.frames(function() lastCardObject.flip() end, 10)
            replenished = true
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #2 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end

    -- Check for last card from deck each spot. (Deck stops existing then)
    setDeckOrLastCard()

    if not checkCardsPresent(archiveScripting2ZoneObject) then
        if archiveDeckObject ~= nil then
            archiveDeckObject.takeObject({
                position = {-24.00, 1.63, 6.00},
                flip = true
            })
            replenished = true
        elseif lastCardObject ~= nil then
            lastCardObject.setPosition({-24.00, 1.63, 6.00})
            Wait.frames(function() lastCardObject.flip() end, 10)
            replenished = true
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #3 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end

    -- Check for last card from deck each spot. (Deck stops existing then)
    setDeckOrLastCard()

    if not checkCardsPresent(archiveScripting3ZoneObject) then
        if archiveDeckObject ~= nil then
            archiveDeckObject.takeObject({
                position = {-24.00, 1.63, 12.00},
                flip = true
            })
            replenished = true
        elseif lastCardObject ~= nil then
            lastCardObject.setPosition({-24.00, 1.63, 12.00})
            Wait.frames(function() lastCardObject.flip() end, 10)
            replenished = true
        end

        for _ = 1, 30 do
            coroutine.yield(0)
        end
    end

    -- #4 Check if empty and deck to draw from. If so, replenish and recreate if needed.
    if checkDeckEmptyAndRecreate() then
        -- Wait for new deck to settle
        for _ = 1, 250 do
            coroutine.yield(0)
        end
    end

    -- Check for last card from deck each spot. (Deck stops existing then)
    setDeckOrLastCard()

    if not checkCardsPresent(archiveScripting4ZoneObject) then
        if archiveDeckObject ~= nil then
            archiveDeckObject.takeObject({
                position = {-24.00, 1.63, 18.00},
                flip = true
            })
            replenished = true
        elseif lastCardObject ~= nil then
            lastCardObject.setPosition({-24.00, 1.63, 18.00})
            Wait.frames(function() lastCardObject.flip() end, 10)
            replenished = true
        end
    end

    -- If replenished spot(s), wait for new cards to settle, then check if all are of the same type.
    if replenished then
        for _ = 1, 200 do
            coroutine.yield(0)
        end
        checkAllSameType()
    end

    return 1
end

-- Starts ReplenishSpotsCoroutine initially
function ReplenishClicked()
    startLuaCoroutine(self, "ReplenishSpotsCoroutine")
end

-- Automates Archive discarding and makes them all face-up
function onObjectEnterZone(zone, object)
    if zone.guid == "9198fd" and (object.type == "Card" or object.type == "Deck") then
        local objectPosition = object.getPosition()
        local objectYPosition = tonumber(objectPosition.y)

        -- Only activate when dragging/holding cards from hand
        if objectYPosition > 2.2 and object.type == "Card" then
            MoveWaitId = Wait.time(function ()
                object.setPositionSmooth({-24.00, 3.00, -19.50}, false, false)
            end, 0.4)
        end

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
        if MoveWaitId then
            Wait.stop(MoveWaitId)
        end
    end
end