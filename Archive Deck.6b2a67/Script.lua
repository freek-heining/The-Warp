function onLoad()
    params = {
        click_function = "click_func",
        function_owner = self,
        label          = "Test",
        position       = {0, -1, 0},
        rotation       = {0, 0, 180},
        width          = 800,
        height         = 400,
        font_size      = 340,
        color          = {0.5, 0.5, 0.5},
        font_color     = {1, 1, 1},
        tooltip        = "This text appears on mouseover.",
    }
    self.createButton(params)
end

function click_func(obj, color, alt_click)
    print(obj)
    print(color)
    print(alt_click)
end