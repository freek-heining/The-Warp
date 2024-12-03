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
    [1] = vector(73.50, 2.37, 6.39),
    [2] = vector(61.50, 2.38, 6.39),
    [3] = vector(61.50, 2.38, 1.50),
    [4] = vector(73.50, 2.36, 1.50),
    [5] = vector(70.50, 2.37, 3.76),
    [6] = vector(64.50, 2.38, 3.76),
    [7] = vector(67.50, 2.37, 6.39),
    [8] = vector(67.50, 2.37, 1.50)
}

-- 9 black dice positions
local defenseDicePositions = {
    [1] = vector(61.50, 2.38, -6.39),
    [2] = vector(73.50, 2.36, -6.38),
    [3] = vector(73.50, 2.36, -1.50),
    [4] = vector(61.50, 2.38, -1.50),
    [5] = vector(64.50, 2.37, -4.00),
    [6] = vector(70.50, 2.37, -4.00),
    [7] = vector(67.50, 2.37, -6.38),
    [8] = vector(67.50, 2.37, -1.50),
    [9] = vector(67.50, 2.37, -4.00)
}

--#region Attack Side Change Events
    function TroopCountAttackChange(player, value, id)
        local numberValue = tonumber(value) -- Convert from string to number
        if numberValue then
            troopCountAttack = numberValue
        end
        ResetAttackButtons()
        diceRolled = false
        self.UI.setValue("troopCountAttackText", numberValue)
        self.UI.setAttribute("troopCountAttackSlider", "value", value)
    end

    function MultiplierAttackChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            multiplierAttack = numberValue
        end
        ResetAttackButtons()
        diceRolled = false
        self.UI.setValue("multiplierAttackText", numberValue)
        self.UI.setAttribute("multiplierAttackSlider", "value", value)
    end

    function ExtraDiceAttackChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            extraDiceAttack = numberValue
        end
        ResetAttackButtons()
        diceRolled = false
        self.UI.setValue("extraDiceAttackText", numberValue)
        self.UI.setAttribute("extraDiceAttackSlider", "value", value)
    end

    function ExtraDieValueAttackChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            extraDieValueAttack = numberValue
        end
        ResetAttackButtons()
        diceRolled = false
        self.UI.setValue("extraDieValueAttackText", numberValue)
        self.UI.setAttribute("extraDieValueAttackSlider", "value", value)
    end

    function MultiplyDieAttackChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            multiplyDieAttack = numberValue
        end
        ResetAttackButtons()
        diceRolled = false
        self.UI.setValue("multiplyDieAttackText", numberValue)
        self.UI.setAttribute("multiplyDieAttackSlider", "value", value)
    end

    function MaximumDieValueAttackChange(player, value, id)
        -- Boolean value from UI Toggle is a string here!
        if value == "False" then
            NoMaximumDieValueAttack = false
        elseif value == "True" then
            NoMaximumDieValueAttack = true
        end

        -- Otherwise not visible to other players
        self.UI.setAttribute("maximumDieValueAttackToggle", "isOn", value)

        ResetAttackButtons()
        diceRolled = false
    end
--#endregion

--#region Defense Side Change Events
    function TroopCountDefenseChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            troopCountDefense = numberValue
        end
        ResetDefenseButtons()
        diceRolled = false
        self.UI.setValue("troopCountDefenseText", numberValue)
        self.UI.setAttribute("troopCountDefenseSlider", "value", value)
    end

    function MultiplierDefenseChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            multiplierDefense = numberValue
        end
        ResetDefenseButtons()
        diceRolled = false
        self.UI.setValue("multiplierDefenseText", numberValue)
        self.UI.setAttribute("multiplierDefenseSlider", "value", value)
    end

    function ExtraDiceDefenseChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            extraDiceDefense = numberValue
        end
        ResetDefenseButtons()
        diceRolled = false
        self.UI.setValue("extraDiceDefenseText", numberValue)
        self.UI.setAttribute("ExtraDiceDefenseSlider", "value", value)
    end

    function ExtraDieValueDefenseChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            extraDieValueDefense = numberValue
        end
        ResetDefenseButtons()
        diceRolled = false
        self.UI.setValue("extraDieValueDefenseText", numberValue)
        self.UI.setAttribute("extraDieValueDefenseSlider", "value", value)
    end

    function MultiplyDieDefenseChange(player, value, id)
        local numberValue = tonumber(value)
        if numberValue then
            multiplyDieDefense = numberValue
        end
        ResetDefenseButtons()
        diceRolled = false
        self.UI.setValue("multiplyDieDefenseText", numberValue)
        self.UI.setAttribute("multiplyDieDefenseSlider", "value", value)
    end

    function MaximumDieValueDefenseChange(player, value, id)
        -- Boolean value from UI Toggle is a string here!
        if value == "False" then
            NoMaximumDieValueDefense = false
        elseif value == "True" then
            NoMaximumDieValueDefense = true
        end

        -- Otherwise not visible to other players
        self.UI.setAttribute("maximumDieValueDefenseToggle", "isOn", value)

        ResetDefenseButtons()
        diceRolled = false
    end
--#endregion

--#region Hidden Zones Attack & Defense
    -- Hidden zone attacker spawn
    local attackerHiding = false
    local attackZoneObject
    
    local function unhideAttacker()
        attackerHiding = false
        destroyObject(attackZoneObject)
        self.UI.setAttribute("hiddenZoneAttackerButton", "text", "Hide")
        self.UI.setAttribute("hiddenZoneAttackerButton", "color", "White")
        self.UI.setAttribute("hiddenZoneAttackerButton", "textColor", "#09266E")
    end

    function HiddenZoneAttackerButtonClicked(player)
        if attackerHiding then
            unhideAttacker()
        else
            attackerHiding = true
            self.UI.setAttribute("hiddenZoneAttackerButton", "text", "Unhide")
            self.UI.setAttribute("hiddenZoneAttackerButton", "color", player.color)
            self.UI.setAttribute("hiddenZoneAttackerButton", "textColor", "White")
            attackZoneObject = spawnObjectData({
                data = {
                    Name = "FogOfWarTrigger",
                    Transform = {
                        posX = 67.51,
                        posY = 2.69,
                        posZ = 19.49,
                        rotX = 0,
                        rotY = 0,
                        rotZ = 0,
                        scaleX = 15,
                        scaleY = 3,
                        scaleZ = 8
                    },
                    FogColor = player.color,
                    Locked = true,
                    Nickname = "Attacker Hidden Zone",
                    Description = "Use to secretly choose your combat card option. Removed when attack is set!"
                }
            })
        end
    end

    -- Hidden zone defender spawn
    local defenderHiding = false
    local defendZoneObject

    local function unhideDefender()
        defenderHiding = false
        destroyObject(defendZoneObject)
        self.UI.setAttribute("hiddenZoneDefenderButton", "text", "Hide")
        self.UI.setAttribute("hiddenZoneDefenderButton", "color", "White")
        self.UI.setAttribute("hiddenZoneDefenderButton", "textColor", "#09266E")
    end

    function HiddenZoneDefenderButtonClicked(player)
        if defenderHiding then
            unhideDefender()
        else
            defenderHiding = true
            self.UI.setAttribute("hiddenZoneDefenderButton", "text", "Unhide")
            self.UI.setAttribute("hiddenZoneDefenderButton", "color", player.color)
            self.UI.setAttribute("hiddenZoneDefenderButton", "textColor", "White")
            defendZoneObject = spawnObjectData({
                data = {
                    Name = "FogOfWarTrigger",
                    Transform = {
                        posX = 67.51,
                        posY = 2.69,
                        posZ = -19.49,
                        rotX = 0,
                        rotY = 0,
                        rotZ = 0,
                        scaleX = 6,
                        scaleY = 3,
                        scaleZ = 8
                    },
                    FogColor = player.color,
                    Locked = true,
                    Nickname = "Defender Hidden Zone",
                    Description = "Use to secretly choose your combat card option. Removed when defense is set!"
                }
            })
        end
    end

    -- Remove hiding zones
    function onPlayerTurn() -- Called at the start of a player's turn. Turns must be enabled.
        if attackerHiding then
            unhideAttacker()
        end
        if defenderHiding  then
            unhideDefender()
        end
    end
--#endregion

-- Global tables needed/used when 'CalculateBattleResults' called from outside of 'BattleCoroutine'
local attackDiceObjectsGlobal = {}
local defenseDiceObjectsGlobal = {}
-- Also combined table to determine if combat or normal die is rolled
local allDiceObjectsGlobal = {}

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
    -- Remove old dice and empty table
    removeOldDice(attackDiceObjectsGlobal)
    attackDiceObjectsGlobal = {}

    -- Spawn 1-8 attack/red dice and insert to global table
    local totalDice = troopCountAttack + extraDiceAttack
    -- Hard cap to 8
    if totalDice > 8 then
        totalDice = 8
    end
    for i = 1, totalDice do
        spawnObject({
            type = "D6 Red",
            position = attackDicePositions[i],
            callback_function = function(spawned_die)
                table.insert(attackDiceObjectsGlobal, spawned_die)
                table.insert(allDiceObjectsGlobal, spawned_die)
            end
        })
    end

    self.UI.setAttribute("attackButton", "interactable", false)
    self.UI.setAttribute("attackButton", "color", player.color)
    self.UI.setAttribute("attackButton", "textColor", "Grey")

    self.UI.setValue("attackResultText", "")
    self.UI.setAttribute("attackResultCell", "color", "")

    self.UI.setValue("defenseResultText", "")
    self.UI.setAttribute("defenseResultCell", "color", "")

    attackSet = true

    -- Removes hidden zone and prevents creating it during battle
    if attackerHiding then
        unhideAttacker()
    end
    self.UI.setAttribute("hiddenZoneAttackerButton", "interactable", false)

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
        self.UI.setAttribute("battleButton", "textColor", "#09266E")
    end
end

function ResetAttackButtons()
    attackSet = false
    self.UI.setAttribute("attackButton", "interactable", true)
    self.UI.setAttribute("attackButton", "color", "White")
    self.UI.setAttribute("attackButton", "textColor", "#09266E")
    self.UI.setAttribute("battleButton", "interactable", false)
    
    self.UI.setAttribute("hiddenZoneAttackerButton", "interactable", true)
    if attackerHiding then -- textColor somehow becomes default/black when setting interactable to true. This will overwrite it.
        self.UI.setAttribute("hiddenZoneAttackerButton", "textColor", "White")
    end
end

-- Defend
function DefenseButtonClicked(player, value, id)
    -- Remove old dice and empty table
    removeOldDice(defenseDiceObjectsGlobal)
    defenseDiceObjectsGlobal = {}

    -- Spawn 1-9 black/defense dice
    local totalDice = troopCountDefense + extraDiceDefense
    -- Hard cap to 9
    if totalDice > 9 then
        totalDice = 9
    end
    for i = 1, totalDice do
        spawnObject({
            type = "D6 Black",
            position = defenseDicePositions[i],
            callback_function = function(spawned_die)
                table.insert(defenseDiceObjectsGlobal, spawned_die)
                table.insert(allDiceObjectsGlobal, spawned_die)
            end
        })
    end

    self.UI.setAttribute("defenseButton", "interactable", false)
    self.UI.setAttribute("defenseButton", "color", player.color)
    self.UI.setAttribute("defenseButton", "textColor", "Grey")

    self.UI.setValue("defenseResultText", "")
    self.UI.setAttribute("defenseResultCell", "color", "")

    self.UI.setValue("attackResultText", "")
    self.UI.setAttribute("attackResultCell", "color", "")

    defenseSet = true

    -- Removes hidden zone and prevents creating it during battle
    if defenderHiding then
        unhideDefender()
    end
    self.UI.setAttribute("hiddenZoneDefenderButton", "interactable", false)

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
        self.UI.setAttribute("battleButton", "textColor", "#09266E")
    end
end

function ResetDefenseButtons()
    defenseSet = false
    self.UI.setAttribute("defenseButton", "interactable", true)
    self.UI.setAttribute("defenseButton", "color", "White")
    self.UI.setAttribute("defenseButton", "textColor", "#09266E")
    self.UI.setAttribute("battleButton", "interactable", false)

    self.UI.setAttribute("hiddenZoneDefenderButton", "interactable", true)
    if defenderHiding then -- textColor somehow becomes default/black when setting interactable to true. This will overwrite it.
        self.UI.setAttribute("hiddenZoneDefenderButton", "textColor", "White")
    end
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

    -- Clear global combined dice table each battle
    allDiceObjectsGlobal = {}

    -- Fill combined dice table with new dice
    for _, die in ipairs(attackDiceObjectsGlobal) do
        table.insert(allDiceObjectsGlobal, die)
    end
    for _, die in ipairs(defenseDiceObjectsGlobal) do
        table.insert(allDiceObjectsGlobal, die)
    end

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
    rollDice(allDiceObjectsGlobal)

    local restingCounter = 0
    local totalDiceCount = #allDiceObjectsGlobal

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
        for _ = 1, 170 do
            coroutine.yield(0)
        end
    end

    checkIfRolling(allDiceObjectsGlobal)

    --#region UI
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
    CalculateBattleResults(attackDiceObjectsGlobal, defenseDiceObjectsGlobal)

    diceRolled = true

    return 1
end

-- Calculate rolled dice. Global, because called from BattleCoroutine()
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

    -- Multiply X2 logic
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

    -- Multiply dice if 'X2' is enabled
    if multiplyDieAttack > 0 then
        multiplyDice(attackValuesArray, multiplyDieAttack, NoMaximumDieValueAttack)
    end
    if multiplyDieDefense > 0 then
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

-- Recalculate on die flip or re-roll, only on battle board (combat card ability, track bonus. Can reroll or flip one die multiple times)

-- Id returned from Wait.time()
local waitId
local rolTriggered -- Prevents message spam
local flipTriggered -- Prevents message spam

-- Check if dice already rolling to prevent roll spam on single die
local function checkDiceRolling(currentDie)
    if currentDie.resting then
        return false
    else
        return true
    end
end

-- Check if die on battleboard / in global attack or defense dice table
local function checkDiceOnBoard(currentDie)
    for _, die in ipairs(attackDiceObjectsGlobal) do
        if currentDie == die then
            return true
        end
    end
    for _, die in ipairs(defenseDiceObjectsGlobal) do
        if currentDie == die then
            return true
        end
    end

    return false
end

-- Reacts to player interaction on battle board only. targets[1] = first selected object/die (In hotseat mode, this event fires twice sometimes!)
function onPlayerAction(player, action, targets)
    local rolledOrFlippedObject = targets[1]

    if checkDiceOnBoard(rolledOrFlippedObject) then
        -- Stop current scheduled calculate 
        if waitId then
            Wait.stop(waitId)
            waitId = nil
        end

        -- ROLL: Recalculate on die roll only when all dice are already rolled (attackDiceObjects & defenseDiceObjects are then filled & diceRolled = true)
        if action == Player.Action.Randomize and rolledOrFlippedObject.type == "Dice" and diceRolled then
            if checkDiceRolling(rolledOrFlippedObject) then
                broadcastToAll("Don't roll more then once please", "Red")
            else
                broadcastToAll(player.color .. " rolled a die with value '" .. rolledOrFlippedObject.getValue() .. "'. Recalculating result...")
            end

            -- Wait to prevent multiple calculates. Reset process when roll again (with Wait.stop)
            waitId = Wait.time(function() CalculateBattleResults(attackDiceObjectsGlobal, defenseDiceObjectsGlobal) end, 3)
        
        -- Don't do anything when rolling manually before battle was started (attackDiceObjects & defenseDiceObjects are empty)
        elseif action == Player.Action.Randomize and rolledOrFlippedObject.type == "Dice" and not rolTriggered then
            broadcastToAll(player.color .. " rolled a die. Please wait till after battle results...")

            rolTriggered = true
            Wait.time(function() rolTriggered = false end, 2)
        end

        -- FLIP: Recalculate on die flip only when all dice are already rolled (attackDiceObjects & defenseDiceObjects are then filled & diceRolled = true)
        if action == Player.Action.FlipOver and rolledOrFlippedObject.type == "Dice" and diceRolled then
            local flippedDie = rolledOrFlippedObject
            broadcastToAll(player.color .. " player flipped a die with value '" .. flippedDie.getValue() .. "'. Recalculating result...")

            -- Wait to prevent multiple calculates. Reset process when flip again (with Wait.stop)
            waitId = Wait.time(function() CalculateBattleResults(attackDiceObjectsGlobal, defenseDiceObjectsGlobal) end, 3)
        
        -- When flipping before dice are rolled:
        elseif action == Player.Action.FlipOver and rolledOrFlippedObject.type == "Dice" and not flipTriggered then
            broadcastToAll(player.color .. " player flipped a die. Please wait till after battle results...")

            flipTriggered = true
            Wait.time(function() flipTriggered = false end, 2)
        end
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

