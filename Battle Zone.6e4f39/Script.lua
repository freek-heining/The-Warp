local battleZoneGUID = "6e4f39"
local battleZoneObject = getObjectFromGUID(battleZoneGUID)
local attackerScriptingZoneGUID = "b6dd48"
local attackerScriptingZoneObject = getObjectFromGUID(attackerScriptingZoneGUID)
local defenderScriptingZoneGUID = "52ba59"
local defenderScriptingZoneObject = getObjectFromGUID(defenderScriptingZoneGUID)

local troopCountAttack = 1
local troopCountDefense = 1
local multiplierAttack = 1
local multiplierDefense = 1
local extraDiceAttack = 0
local extraDiceDefense = 0
local dieValueAttack = 0
local dieValueDefense = 0
local multiplyDieAttack = 0
local multiplyDieDefense = 0
local maximumDieValueAttack = false
local maximumDieValueDefense = false

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

-- Attack Side
function TroopCountAttackChange(player, value, id)
    troopCountAttack = value
    ResetAttackButton()
    self.UI.setValue("troopCountAttackText", value)
end

function MultiplierAttackChange(player, value, id)
    multiplierAttack = value
    ResetAttackButton()
    self.UI.setValue("multiplierAttackText", value)
end

function ExtraDiceAttackChange(player, value, id)
    extraDiceAttack = value
    ResetAttackButton()
    self.UI.setValue("extraDiceAttackText", value)
end

function DieValueAttackChange(player, value, id)
    dieValueAttack = value
    ResetAttackButton()
    self.UI.setValue("dieValueAttackText", value)
end

function MultiplyDieAttackChange(player, value, id)
    multiplyDieAttack = value
    ResetAttackButton()
    self.UI.setValue("multiplyDieAttackText", value)
end

function MaximumDieValueAttackChange(player, value, id)
    maximumDieValueAttack = value
    ResetAttackButton()
end

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
        spawnObject({
            type = "D6 Red",
            position = attackDicePositions[i]
        })
    end

    local totalAttack = totalDice * multiplierAttack

    self.UI.setValue("attackResultText", totalAttack)

    self.UI.setAttribute("attackButton", "interactable", false)
    self.UI.setAttribute("attackButton", "color", player.color)
    self.UI.setAttribute("defenseButton", "interactable", true)
end

function ResetAttackButton()
    self.UI.setAttribute("attackButton", "interactable", true)
    self.UI.setAttribute("attackButton", "color", "White")
end


-- Defense Side
function TroopCountDefenseChange(player, value, id)
    troopCountDefense = value
    ResetDefenseButton()
    self.UI.setValue("troopCountDefenseText", value)
end

function MultiplierDefenseChange(player, value, id)
    multiplierDefense = value
    ResetDefenseButton()
    self.UI.setValue("multiplierDefenseText", value)
end

function ExtraDiceDefenseChange(player, value, id)
    extraDiceDefense = value
    ResetDefenseButton()
    self.UI.setValue("extraDiceDefenseText", value)
end

function DieValueDefenseChange(player, value, id)
    dieValueDefense = value
    ResetDefenseButton()
    self.UI.setValue("dieValueDefenseText", value)
end

function MultiplyDieDefenseChange(player, value, id)
    multiplyDieDefense = value
    ResetDefenseButton()
    self.UI.setValue("multiplyDieDefenseText", value)
end

function MaximumDieValueDefenseChange(player, value, id)
    maximumDieValueDefense = value
    ResetDefenseButton()
end

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
        spawnObject({
            type = "D6 Black",
            position = defenseDicePositions[i]
        })
    end

    self.UI.setAttribute("defenseButton", "interactable", false)
    self.UI.setAttribute("defenseButton", "color", player.color)
end

function ResetDefenseButton()
    self.UI.setAttribute("defenseButton", "interactable", true)
    self.UI.setAttribute("defenseButton", "color", "White")
end