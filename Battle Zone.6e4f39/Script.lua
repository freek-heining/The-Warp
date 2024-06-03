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
local attackSet = false
local defenseSet = false

local attackDicePositions = {
    [1] = vector(-39.00, 2.52, -6.75),
    [2] = vector(-33.00, 2.51, -6.75),
    [3] = vector(-27.00, 2.50, -6.75),
    [4] = vector(-39.00, 2.52, -2.25),
    [5] = vector(-33.00, 2.51, -2.25),
    [6] = vector(-27.00, 2.50, -2.25)
}

local defenseDicePositions = {
    [1] = vector(-27.00, 2.51, 6.75),
    [2] = vector(-33.00, 2.51, 6.75),
    [3] = vector(-39.00, 2.52, 6.75),
    [4] = vector(-27.00, 2.50, 2.25),
    [5] = vector(-33.00, 2.51, 2.25),
    [6] = vector(-39.00, 2.52, 2.25)
}

--#region Attack Side Change Events
function TroopCountAttackChange(player, value, id)
    local numberValue = tonumber(value) -- Convert from string to number
    if numberValue then
        troopCountAttack = numberValue
    end
    ResetAttackButton()
    self.UI.setValue("troopCountAttackText", numberValue)
end

function MultiplierAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplierAttack = numberValue
    end
    ResetAttackButton()
    self.UI.setValue("multiplierAttackText", numberValue)
end

function ExtraDiceAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDiceAttack = numberValue
    end
    ResetAttackButton()
    self.UI.setValue("extraDiceAttackText", numberValue)
end

function ExtraDieValueAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDieValueAttack = numberValue
    end
    ResetAttackButton()
    self.UI.setValue("extraDieValueAttackText", numberValue)
end

function MultiplyDieAttackChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplyDieAttack = numberValue
    end
    ResetAttackButton()
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
end
--#endregion

--#region Defense Side Change Events
function TroopCountDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        troopCountDefense = numberValue
    end
    ResetDefenseButton()
    self.UI.setValue("troopCountDefenseText", numberValue)
end

function MultiplierDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplierDefense = numberValue
    end
    ResetDefenseButton()
    self.UI.setValue("multiplierDefenseText", numberValue)
end

function ExtraDiceDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDiceDefense = numberValue
    end
    ResetDefenseButton()
    self.UI.setValue("extraDiceDefenseText", numberValue)
end

function ExtraDieValueDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        extraDieValueDefense = numberValue
    end
    ResetDefenseButton()
    self.UI.setValue("extraDieValueDefenseText", numberValue)
end

function MultiplyDieDefenseChange(player, value, id)
    local numberValue = tonumber(value)
    if numberValue then
        multiplyDieDefense = numberValue
    end
    ResetDefenseButton()
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
end
--#endregion

-- Attack
function AttackButtonClicked(player, value, id)
    -- Delete all previous dice
    local objects = attackerScriptingZoneObject.getObjects()
    for _, object in ipairs(objects) do
        if object.type == "Dice" then
            object.destruct()
        end
    end

    -- Spawn 1-6 dice
    local totalDice = troopCountAttack + extraDiceAttack
    for i = 1, totalDice do
        spawnObject({ type = "D6 Red", position = attackDicePositions[i] })
    end

    self.UI.setAttribute("attackButton", "interactable", false)
    self.UI.setAttribute("attackButton", "color", player.color)
    attackSet = true

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
    end
end

function ResetAttackButton()
    attackSet = false
    self.UI.setAttribute("attackButton", "interactable", true)
    self.UI.setAttribute("attackButton", "color", "White")
    self.UI.setAttribute("battleButton", "interactable", false)
end

-- Defend
function DefenseButtonClicked(player, value, id)
    -- Delete all previous dice
    local objects = defenderScriptingZoneObject.getObjects()
    for _, object in ipairs(objects) do
        if object.type == "Dice" then
            object.destruct()
        end
    end

    -- Spawn 1-6 dice
    local totalDice = troopCountDefense + extraDiceDefense
    for i = 1, totalDice do
        spawnObject({ type = "D6 Black", position = defenseDicePositions[i] })
    end

    self.UI.setAttribute("defenseButton", "interactable", false)
    self.UI.setAttribute("defenseButton", "color", player.color)
    defenseSet = true

    if attackSet and defenseSet then
        self.UI.setAttribute("battleButton", "interactable", true)
    end
end

function ResetDefenseButton()
    defenseSet = false
    self.UI.setAttribute("defenseButton", "interactable", true)
    self.UI.setAttribute("defenseButton", "color", "White")
    self.UI.setAttribute("battleButton", "interactable", false)
end

function BattleButtonClicked()
    self.UI.setAttribute("battleButton", "interactable", false)
    startLuaCoroutine(self, "BattleCoroutine")
end

-- Battle Section
function BattleCoroutine()
    local attackValuesArray = {}
    local defenseValuesArray = {}

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

    -- Get all attack & Defense side objects
    local attackObjects = attackerScriptingZoneObject.getObjects()
    local defenseObjects = defenderScriptingZoneObject.getObjects()

    -- Rolls all dice 5x
    local function rollDice (objects)
        for _, object in ipairs(objects) do
            if object.type == "Dice" then
                object.roll()
                object.roll()
                object.roll()
                object.roll()
                object.roll()
            end
        end
    end

    rollDice(attackObjects)
    rollDice(defenseObjects)
    
    -- Wait for all dice to settle
    for _ = 1, 400 do
        coroutine.yield(0)
    end

    -- Gets all dice values and add to array 
    local function getDiceValues(objects, valuesArray, extraDieValue, noMaximumDieValue)
        print("Values:")
        for _, object in ipairs(objects) do
            if object.type == "Dice" then
                local diceValue = object.getValue()
    
                -- Add value to die if enabled with Combat Card or ability
                diceValue = diceValue + extraDieValue
                
                -- Cap value to 6 when maximum is still set
                if not noMaximumDieValue and diceValue > 6 then
                    diceValue = 6
                end
    
                -- Store final die value in array
                table.insert(valuesArray, diceValue)
    
                print(diceValue)
            end
        end
    end

    -- Get Attack & Defense dice values
    getDiceValues(attackObjects, attackValuesArray, extraDieValueAttack, NoMaximumDieValueAttack)
    getDiceValues(defenseObjects, defenseValuesArray, extraDieValueDefense, NoMaximumDieValueDefense)

    local function multiplyDice (valuesArray, multiplyDie, noMaximumDieValue)
        -- Multiply X2 without maximum value
        if multiplyDie > 0 and noMaximumDieValue then
            print("Sorting A!")
            table.sort(valuesArray, sortLargeToSmall)

            print("Attack Array:")
            for _, value in ipairs(valuesArray) do
                print(value)
            end

            -- Double highest die/dice for maximum profit
            for i = 1, multiplyDie do
                print("Doubling result A:")
                valuesArray[i]  = valuesArray[i] * 2
                print(valuesArray[i])
            end

        -- Multiply X2 with maximum value 6    
        elseif  multiplyDie > 0 then
            print("Sorting B!")
            table.sort(valuesArray, sortMaxProfit)

            print("Attack Array:")
            for _, value in ipairs(valuesArray) do
                print(value)
            end

            -- Double die/dice 3 > 2/4 > rest for maximum profit
            for i = 1, multiplyDie do
                print("Doubling result B:")
                valuesArray[i]  = valuesArray[i] * 2

                -- Cap value to 6 when maximum is still set
                if valuesArray[i] > 6 then
                    valuesArray[i] = 6
                end

                print(valuesArray[i])
            end
        end
    end

    -- Multiply attack dice if enabled
    multiplyDice(attackValuesArray, multiplyDieAttack, NoMaximumDieValueAttack)

    -- Multiply defense dice if enabled
    multiplyDice(defenseValuesArray, multiplyDieDefense, NoMaximumDieValueDefense)

    -- Calculate total from all dice values * multiplier
    local function calculateTotalValue(valuesArray, multiplier)
        local sum = 0.0

        for _, diceValue in ipairs(valuesArray) do
            sum = sum + diceValue
        end

        print("sum")
        print(sum)

        return sum * multiplier
    end

    -- Set attack result
    self.UI.setValue("attackResultText", calculateTotalValue(attackValuesArray, multiplierAttack))
    
    -- Set defense result
    self.UI.setValue("defenseResultText", calculateTotalValue(defenseValuesArray, multiplierDefense))

    return 1
end

TODO: redo after dice flip