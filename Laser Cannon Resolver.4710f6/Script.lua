local numberOfShots = 1

function OneShotToggleChange(player, value, id)
    -- Boolean value from UI Toggle is a capital string here!
    if value == "True" then
        numberOfShots = 1
    end

    self.UI.setAttribute("laserResult", "text", "")

    -- Otherwise not visible in UI to other players
    self.UI.setAttribute("oneShotToggle", "isOn", value)
end

function TwoShotsToggleChange(player, value, id)
    -- Boolean value from UI Toggle is a capital string here!
    if value == "True" then
        numberOfShots = 2
    end

    self.UI.setAttribute("laserResult", "text", "")

    -- Otherwise not visible in UI to other players
    self.UI.setAttribute("twoShotsToggle", "isOn", value)
end

function LaserOneFireButtonClicked(player, value, id)
    self.UI.setAttribute("laserOneFireButton", "interactable", false) -- Prevents button spam
    Wait.time(function ()
        self.UI.setAttribute("laserOneFireButton", "interactable", true)
    end, 5)
    
    self.UI.setAttribute("laserResult", "text", "")
    self.UI.setAttribute("laserResult", "color", "#09266E")

    if numberOfShots == 1 then
        broadcastToAll("Player ".. player.color .. " fired 1 shot with a Laser Cannon!", player.color)
    elseif numberOfShots == 2 then
        broadcastToAll("Player ".. player.color .. " fired 2 shots with a Laser Cannon!", player.color)
    end

    local hits = 0
    local rolledValues = {}

    for i = 1, numberOfShots, 1 do
        local dieValue = math.random(6)

        table.insert(rolledValues, dieValue)

        if dieValue > 3 then
            hits = hits + 1
        end
    end

    Wait.time(function ()
        local rolledValuesString = table.concat(rolledValues, " & ")

        if hits == 1 then
            broadcastToAll("Rolled a " .. rolledValuesString .. ", scoring 1 hit!", player.color)
            self.UI.setAttribute("laserResult", "text", "1 hit!")
            self.UI.setAttribute("laserResult", "color", "Green")
        elseif hits == 2 then
            broadcastToAll("Rolled a " .. rolledValuesString .. ", scoring 2 hits!", player.color)
            self.UI.setAttribute("laserResult", "text", "2 hits!")
            self.UI.setAttribute("laserResult", "color", "Green")
        else
            broadcastToAll("Rolled a " .. rolledValuesString .. ", scoring 0 hits...", player.color)
            self.UI.setAttribute("laserResult", "text", "0 hits...")
            self.UI.setAttribute("laserResult", "color", "Red")
        end
    end, 1.5)
end

-- Remove result
function onPlayerTurn() -- Called at the start of a player's turn. Turns must be enabled.
    self.UI.setAttribute("laserResult", "text", "test")
end