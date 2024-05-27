local battleZoneGUID = "6e4f39"
local battleZoneObject = getObjectFromGUID(battleZoneGUID)
local battleScriptingZoneGUID = "b6dd48"
local battleScriptingZoneObject = getObjectFromGUID(battleScriptingZoneGUID)


local troopCountAttack = 1
local troopCountDefend = 1
local multiplierAttack = 1
local multiplierDefend = 1
local extraDiceAttack = 0
local extraDiceDefend = 0

local attackDicePositions = {
    [1] = vector(-33.00, 2.86, -10.50),
    [2] = vector(-28.50, 2.85, -10.50),
    [3] = vector(-24.00, 2.85, -10.50),
    [4] = vector(-24.00, 2.85, -4.50),
    [5] = vector(-28.50, 2.85, -4.50),
    [6] = vector(-33.00, 2.86, -4.50)
}

local defenseDicePositions = {
    [1] = vector(-33.00, 2.86, 10.50),
    [2] = vector(-28.50, 2.85, 10.50),
    [3] = vector(-24.00, 2.85, 10.50),
    [4] = vector(-24.00, 2.85, 4.50),
    [5] = vector(-28.50, 2.85, 4.50),
    [6] = vector(-33.00, 2.86, 4.50)
}

-- Attack
function TroopCountAttackChange(player, value, id)
    troopCountAttack = value
    self.UI.setValue("troopCountAttackText", value)
end

function MultiplierAttackChange(player, value, id)
    multiplierAttack = value
    self.UI.setValue("multiplierAttackText", value)
end

function ExtraDiceAttackChange(player, value, id)
    extraDiceAttack = value
    self.UI.setValue("extraDiceAttackText", value)
end

function AttackClicked(player, value, id)
    -- Delete all previous dice
    local objects = battleScriptingZoneObject.getObjects()
    for _, object in ipairs(objects) do
        if object.type == "Dice" then
            object.destruct()
        end
    end

    -- Spawn 1-6 dice
    local totalDice = troopCountAttack + extraDiceAttack
    for i = 1, totalDice do
        spawnObject({
            type = "D6 Black",
            position = attackDicePositions[i]
        })
    end

    self.UI.setAttribute("attackButton", "interactable", false)
end

-- Defend
function TroopCountDefendChange(player, value, id)
    troopCountDefend = value
    self.UI.setValue("troopCountDefendText", value)
end

function MultiplierDefendChange(player, value, id)
    multiplierDefend = value
    self.UI.setValue("multiplierDefendText", value)
end

function ExtraDiceDefendChange(player, value, id)
    extraDiceDefend = value
    self.UI.setValue("extraDiceDefendText", value)
end

function DefendClicked(player, value, id)
    spawnObject({
        type = "D6 Black",
        position = {}, 
    })
end