local following = false

-- Unfollow state
local function reset()
    following = false
    self.setColorTint({173/255, 173/255, 173/255})
    self.UI.setAttribute("followButton", "color", "clear")
    self.UI.setAttribute("followButton", "text", "Follow")
    self.UI.setAttribute("followButton", "fontSize", "45")
    self.UI.setAttribute("followButton", "textColor", "Black")
end

function FollowButtonClicked(player, option, id)
    if following == true then 
        reset()
        broadcastToAll(player.color .. " stops following...", player.color)
    else -- Follow state
        following = true
        self.setColorTint(player.color)
        self.UI.setAttribute("followButton", "color", clear)
        self.UI.setAttribute("followButton", "text", "Unfollow")
        self.UI.setAttribute("followButton", "fontSize", "37")
        self.UI.setAttribute("followButton", "textColor", "White")
        broadcastToAll(player.color .. " follows!", player.color)
    end
end

function onPlayerTurn()
    reset()
end