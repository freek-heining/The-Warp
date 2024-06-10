local battleZoneGUID = "6e4f39"
local battleZoneObject = getObjectFromGUID(battleZoneGUID)
local attackerScriptingZoneGUID = "b6dd48"
local attackerScriptingZoneObject = getObjectFromGUID(attackerScriptingZoneGUID)
local defenderScriptingZoneGUID = "52ba59"
local defenderScriptingZoneObject = getObjectFromGUID(defenderScriptingZoneGUID)

local troopCountAttack = 1.0
local troopCountDefense = 1.0
local multiplierAttack = 1.0
local multiplierDefense = 1.0
local extraDiceAttack = 0.0
local extraDiceDefense = 0.0
local extraDieValueAttack = 0.0
local extraDieValueDefense = 0.0
local multiplyDieAttack = 0.0
local multiplyDieDefense = 0.0
local NoMaximumDieValueAttack = false
local NoMaximumDieValueDefense = false

-- Globals used in calculations
local attackSet = false
local defenseSet = false
local diceRolled = false

-- 8 red dice positions
local attackDicePositions = {
    [1] = vector(-39.00, 2.52, -6.75),
    [2] = vector(-33.00, 2.51, -6.75),
    [3] = vector(-27.00, 2.50, -6.75),
    [4] = vector(-39.00, 2.52, -2.25),
    [5] = vector(-33.00, 2.51, -2.25),
    [6] = vector(-27.00, 2.50, -2.25),
    [7] = vector(-36.00, 2.51, -4.50),
    [8] = vector(-30.00, 2.51, -4.50)
}

-- 9 black dice positions
local defenseDicePositions = {
    [1] = vector(-27.00, 2.51, 6.75),
    [2] = vector(-33.00, 2.51, 6.75),
    [3] = vector(-39.00, 2.52, 6.75), 
    [4] = vector(-27.00, 2.50, 2.25),
    [5] = vector(-33.00, 2.51, 2.25),
    [6] = vector(-39.00, 2.52, 2.25),
    [7] = vector(-30.00, 2.51, 4.50),
    [8] = vector(-36.00, 2.52, 4.50),
    [9] = vector(-30.00, 2.51, 0.00)
}

--#region Attack Side Change Events
function TroopCountAttackChange(player, value, id)
    local numberValue = tonumber(value) -- Convert from string to number
    if numberValue then
        troopCountAttack = numberValue
    end
    ResetAttackButton()
    diceRolled = false
    self.UI.setValue("troopCountAttackText", numberValue)
end

function MultiplierAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplierAttack = numberValue
    end
    ResetAttackButton()
    diceRolled = false
    self.UI.setValue("multiplierAttackText", numberValue)
end

function ExtraDiceAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDiceAttack = numberValue
    end
    ResetAttackButton()
    diceRolled = false
    self.UI.setValue("extraDiceAttackText", numberValue)
end

function ExtraDieValueAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDieValueAttack = numberValue
    end
    ResetAttackButton()
    diceRolled = false
    self.UI.setValue("extraDieValueAttackText", numberValue)
end

function MultiplyDieAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplyDieAttack = numberValue
    end
    ResetAttackButton()
    diceRolled = false
    self.UI.setValue("multiplyDieAttackText", numberValue)
end

function MaximumDieValueAttackChange(player, value, id)
    -- Boolean value from UI Toggle is a string here!
    if value == "False" then
        NoMaximumDieValueAttack = false
    elseif value == "True" then
        NoMaximumDieValueAttack = true
    end

    ResetAttackButton()
    diceRolled = false
end
--#endregion

--#region Defense Side Change Events
function TroopCountDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        troopCountDefense = numberValue
    end
    ResetDefenseButton()
    diceRolled = false
    self.UI.setValue("troopCountDefenseText", numberValue)
end

function MultiplierDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplierDefense = numberValue
    end
    ResetDefenseButton()
    diceRolled = false
    self.UI.setValue("multiplierDefenseText", numberValue)
end

function ExtraDiceDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDiceDefense = numberValue
    end
    ResetDefenseButton()
    diceRolled = false
    self.UI.setValue("extraDiceDefenseText", numberValue)
end

function ExtraDieValueDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDieValueDefense = numberValue
    end
    ResetDefenseButton()
    diceRolled = false
    self.UI.setValue("extraDieValueDefenseText", numberValue)
end

function MultiplyDieDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplyDieDefense = numberValue
    end
    ResetDefenseButton()
    diceRolled = false
    self.UI.setValue("multiplyDieDefenseText", numberValue)
end

function MaximumDieValueDefenseChange(player, value, id)
    -- Boolean value from UI Toggle is a string here!
    if value == "False" then
        NoMaximumDieValueDefense = false
    elseif value == "True" then
        NoMaximumDieValueDefense = true
    end
    ResetDefenseButton()
    diceRolled = false
end
--#endregion

-- Global tables needed/used when 'CalculateBattleResults' called from outside of 'BattleCoroutine'
local attackDiceObjects = {}
local defenseDiceObjects = {}

-- Removes all previous dice
local function removeOldDice(diceObjects)
    for _, object in ipairs(diceObjects) do
        if object.type == "Dice" then
            object.destruct()
        end
    end
end

-- Attack
function AttackButtonClicked(player, value, id)
    local attackObjects = attackerScriptingZoneObject.getObjects()
    removeOldDice(attackObjects)

    -- Spawn 1-8 dice
    local totalDice = troopCountAttack + extraDiceAttack
    -- Hard cap to 8
    if totalDice > 8 then
        totalDice = 8
    end
    for i = 1, totalDice do
        spawnObject({ type = "D6 Red", position = attackDicePositions[i] })
    end

    self.UI.setAttribute("attackButton", "interactable", false)
    self.UI.setAttribute("attackButton", "color", player.color)
    self.UI.setAttribute("attackButton", "textColor", "Grey")

    self.UI.setValue("attackResultText", "")
    self.UI.setAttribute("attackResultCell", "color", "")

    self.UI.setValue("defenseResultText", "")
    self.UI.setAttribute("defenseResultCell", "color", "")

    attackSet = true

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
        self.UI.setAttribute("battleButton", "textColor", "#09266E")
    end
end

function ResetAttackButton()
    attackSet = false
    self.UI.setAttribute("attackButton", "interactable", true)
    self.UI.setAttribute("attackButton", "color", "White")
    self.UI.setAttribute("attackButton", "textColor", "#09266E")
    self.UI.setAttribute("battleButton", "interactable", false)
end

-- Defend
function DefenseButtonClicked(player, value, id)
    local defenseObjects = defenderScriptingZoneObject.getObjects()
    removeOldDice(defenseObjects)

    -- Spawn 1-9 dice
    local totalDice = troopCountDefense + extraDiceDefense
    -- Hard cap to 9
    if totalDice > 9 then
        totalDice = 9
    end
    for i = 1, totalDice do
        spawnObject({ type = "D6 Black", position = defenseDicePositions[i] })
    end

    self.UI.setAttribute("defenseButton", "interactable", false)
    self.UI.setAttribute("defenseButton", "color", player.color)
    self.UI.setAttribute("defenseButton", "textColor", "Grey")

    self.UI.setValue("defenseResultText", "")
    self.UI.setAttribute("defenseResultCell", "color", "")

    self.UI.setValue("attackResultText", "")
    self.UI.setAttribute("attackResultCell", "color", "")

    defenseSet = true

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
        self.UI.setAttribute("battleButton", "textColor", "#09266E")
    end
end

function ResetDefenseButton()
    defenseSet = false
    self.UI.setAttribute("defenseButton", "interactable", true)
    self.UI.setAttribute("defenseButton", "color", "White")
    self.UI.setAttribute("defenseButton", "textColor", "#09266E")
    self.UI.setAttribute("battleButton", "interactable", false)
end

local function setInteractableFalse(element)
    self.UI.setAttribute(element, "interactable", false)
end
local function setInteractableTrue(element)
    self.UI.setAttribute(element, "interactable", true)
end

function BattleButtonClicked()
    -- Disable all inputs while rolling
    setInteractableFalse("troopCountAttackSlider")
    setInteractableFalse("multiplierAttackSlider")
    setInteractableFalse("extraDiceAttackSlider")
    setInteractableFalse("extraDieValueAttackSlider")
    setInteractableFalse("multiplyDieAttackSlider")
    setInteractableFalse("maximumDieValueAttackToggle")

    setInteractableFalse("troopCountDefenseSlider")
    setInteractableFalse("multiplierDefenseSlider")
    setInteractableFalse("extraDiceDefenseSlider")
    setInteractableFalse("extraDieValueDefenseSlider")
    setInteractableFalse("multiplyDieDefenseSlider")
    setInteractableFalse("maximumDieValueDefenseToggle")
    
    setInteractableFalse("battleButton")

    self.UI.setAttribute("battleButton", "interactable", false)
    startLuaCoroutine(self, "BattleCoroutine")
end

-- Battle Section
function BattleCoroutine()
    local attackColor = self.UI.getAttribute("attackButton", "color")
    local defenseColor = self.UI.getAttribute("defenseButton", "color")
    broadcastToAll("Battle started! " .. attackColor .. " attacks, " .. defenseColor .. " defends")

    -- Clear global dice tables each battle
    while #attackDiceObjects ~= 0 do rawset(attackDiceObjects, #attackDiceObjects, nil) end
    while #defenseDiceObjects ~= 0 do rawset(defenseDiceObjects, #defenseDiceObjects, nil) end

    -- Get all attack & defense side dice
    local attackObjects = attackerScriptingZoneObject.getObjects()
    local defenseObjects = defenderScriptingZoneObject.getObjects()
    local allDiceObjects = {}

    -- Filter spawned dice from other objects and add to attackDiceObjects & defenseDiceObjects tables
    local function filterDice (objects, diceObjects)
        for _, object in ipairs(objects) do
            if object.type == "Dice" then
                -- Add to seperate and combined table
                table.insert(diceObjects, object)
                table.insert(allDiceObjects, object)
            end
        end
    end
    filterDice(attackObjects, attackDiceObjects)
    filterDice(defenseObjects, defenseDiceObjects)

    -- Rolls all dice 5x
    local function rollDice (diceObjects)
        for _, dice in ipairs(diceObjects) do
            dice.roll()
            dice.roll()
            dice.roll()
            dice.roll()
            dice.roll()
        end
    end
    rollDice(allDiceObjects)

    local restingCounter = 0
    local totalDiceCount = #allDiceObjects

    -- Check all dice if resting and continue, otherwise wait in loop till restingCounter > totalDiceCount
    local function checkIfRolling(diceObjects)
        local counter = 0 -- Failsafe, wait 1000 frames max
        while restingCounter <= totalDiceCount and counter < 1000 do
            coroutine.yield(0)
            counter = counter + 1
            for _, dice in pairs(diceObjects) do
                if dice.resting then
                    restingCounter = restingCounter + 1
                end
            end
            coroutine.yield(0)
        end
        -- Some extra waiting frames
        for _ = 1, 150 do
            coroutine.yield(0)
        end
    end
    checkIfRolling(allDiceObjects)

    --#region UI settings
    setInteractableTrue("troopCountAttackSlider")
    setInteractableTrue("multiplierAttackSlider")
    setInteractableTrue("extraDiceAttackSlider")
    setInteractableTrue("extraDieValueAttackSlider")
    setInteractableTrue("multiplyDieAttackSlider")
    setInteractableTrue("maximumDieValueAttackToggle")

    setInteractableTrue("troopCountDefenseSlider")
    setInteractableTrue("multiplierDefenseSlider")
    setInteractableTrue("extraDiceDefenseSlider")
    setInteractableTrue("extraDieValueDefenseSlider")
    setInteractableTrue("multiplyDieDefenseSlider")
    setInteractableTrue("maximumDieValueDefenseToggle")
    --#endregion

    -- Start calculating when all dice are resting
    CalculateBattleResults(attackDiceObjects, defenseDiceObjects)

    diceRolled = true

    return 1
end

-- Calculate rolled dice
function CalculateBattleResults(attackDice, defenseDice)
    local attackValuesArray = {}
    local defenseValuesArray = {}

    -- Gets all dice object values and add to value arrays
    local function getDiceValues(diceObjects, valuesArray, extraDieValue, noMaximumDieValue)
        for _, dice in ipairs(diceObjects) do
            local diceValue = dice.getValue()

            -- Add value to die if enabled with Combat Card or ability
            diceValue = diceValue + extraDieValue
            
            -- Cap value to 6 when maximum is still set
            if not noMaximumDieValue and diceValue > 6 then
                diceValue = 6
            end

            -- Store final die values in array
            table.insert(valuesArray, diceValue)
        end
    end
    getDiceValues(attackDice, attackValuesArray, extraDieValueAttack, NoMaximumDieValueAttack)
    getDiceValues(defenseDice, defenseValuesArray, extraDieValueDefense, NoMaximumDieValueDefense)

    -- Multiply dice if 'X2' is enabled
    local function multiplyDice (valuesArray, multiplyDie, noMaximumDieValue)
        -- Sorting used when 'No Maximum Die Value' is set
        local function sortLargeToSmall(dice1, dice2)
            return dice1 > dice2
        end

        -- Sorting used when 'No Maximum Die Value' is not set
        -- Example 6 dice: 6, 5, 3, 4, 1, 3, 2
        -- Example wanted result: 3, 3, 4, 2, 5, 1, 6,
        local function sortMaxProfit(dice1, dice2)
            if dice1 == 3 and dice2 == 3 then
                return false
            elseif dice1 == 3 and dice2 ~=3 then
                return true
            elseif dice1 ~=3 and dice2 == 3 then
                return false
            elseif (dice1 == 2 or dice1 == 4) and (dice2 == 2 or dice2 == 4) then
                return false
            elseif (dice1 == 2 or dice1 == 4) and (dice2 ~= 2 and dice2 ~= 4) then
                return true
            elseif (dice1 ~= 2 and dice1 ~= 4) and (dice2 == 2 or dice2 == 4) then
                return false
            else
                return dice1 < dice2
            end
        end

        if multiplyDie > 0 and noMaximumDieValue then
            table.sort(valuesArray, sortLargeToSmall)

            -- Double highest die/dice for maximum profit
            for i = 1, multiplyDie do
                valuesArray[i]  = valuesArray[i] * 2
            end

        -- Multiply X2 with maximum value 6    
        elseif  multiplyDie > 0 then
            table.sort(valuesArray, sortMaxProfit)

            -- Double die/dice 3 > 2/4 > rest for maximum profit
            for i = 1, multiplyDie do
                valuesArray[i]  = valuesArray[i] * 2

                -- Cap value to 6 when maximum is still set
                if valuesArray[i] > 6 then
                    valuesArray[i] = 6
                end
            end
        end
    end
    if multiplyDieAttack > 0 then
        multiplyDice(attackValuesArray, multiplyDieAttack, NoMaximumDieValueAttack)
        multiplyDice(defenseValuesArray, multiplyDieDefense, NoMaximumDieValueDefense)
    end

    -- Calculate and set total from all dice values * multiplier
    local function calculateTotalValue(valuesArray, multiplier)
        local sum = 0.0

        for _, diceValue in ipairs(valuesArray) do
            sum = sum + diceValue
        end

        return sum * multiplier
    end
    
    local attackResult = calculateTotalValue(attackValuesArray, multiplierAttack)
    local defenseResult = calculateTotalValue(defenseValuesArray, multiplierDefense)

    local attackColor = self.UI.getAttribute("attackButton", "color")
    local defenseColor = self.UI.getAttribute("defenseButton", "color")

    self.UI.setValue("attackResultText", attackResult)
    self.UI.setValue("defenseResultText", defenseResult)
    self.UI.setAttribute("attackResultCell", "color", attackColor)
    self.UI.setAttribute("defenseResultCell", "color", defenseColor)

    -- Attacker wins
    if attackResult > defenseResult then
        broadcastToAll(attackColor .. " wins the attack versus " .. defenseColor .. "!" .. " (" .. attackResult .. " vs. " .. defenseResult .. ")", attackColor)
    -- Tie
    elseif attackResult == defenseResult then
        broadcastToAll("It's a tie! (If the defender has atleast 1 troop remaining, the attacker retreats)" .. " (" .. attackResult .. " vs. " .. defenseResult .. ")")
    -- Defender wins
    elseif attackResult < defenseResult then
        broadcastToAll(defenseColor .. " wins the defense against " .. attackColor .. "!" .. " (" .. attackResult .. " vs. " .. defenseResult .. ")", defenseColor)
    end
end

-- Recalculate on die flip (combat card ability)

-- Id returned from Wait.time()
local waitId
local rolTriggered -- Prevents message spam
local flipTriggered -- Prevents message spam

-- In hotseat mode, this fires twice!
function onPlayerAction(player, action, targets)
    -- Stop if a calculate is starting already 
    if waitId then
        Wait.stop(waitId)
        waitId = nil
    end

    if action == Player.Action.Randomize and targets[1].type == "Dice" and not rolTriggered then
        local rolledDie = targets[1]
        broadcastToAll(player.color .. " rolled a die with value '" .. rolledDie.getValue() .. "'. Please use the buttons only...")
        rolTriggered = true
        Wait.time(function() rolTriggered = false end, 2)
    end
    
    -- Only recalculate on die flip when all dice are already rolled (attackDiceObjects & defenseDiceObjects are then filled)
    if action == Player.Action.FlipOver and targets[1].type == "Dice" and diceRolled then
        local flippedDie = targets[1]
        broadcastToAll(player.color .. " player flipped a die with value '" .. flippedDie.getValue() .. "'. Recalculating result...")

        -- Wait to prevent multiple calculates. Reset process when flip again
        waitId = Wait.time(function() CalculateBattleResults(attackDiceObjects, defenseDiceObjects) end, 2.5)
    -- When flipping before dice are rolled:
    elseif action == Player.Action.FlipOver and targets[1].type == "Dice" and not flipTriggered then
        broadcastToAll(player.color .. " player flipped a die. Please wait till after rolling...")

        flipTriggered = true
        Wait.time(function() flipTriggered = false end, 2)
    end
end

-- Prevent dice change with num keys, doesn't work on normal keys sadly
local numberTriggered -- Prevents message spam
function onObjectNumberTyped(object, player_color, number)
    if not numberTriggered then
        broadcastToAll(player_color .. " typed " .. number .. " whilst hovering over a " .. object.type .. "'. Please use the buttons only...")
        numberTriggered = true
        Wait.time(function() numberTriggered = false end, 2)
    end

    return true
end