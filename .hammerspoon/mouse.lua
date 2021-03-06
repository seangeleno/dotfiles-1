local screens = require('screens')

local function round(num)
    return math.floor(num + 0.5)
end

local function mouseMover(direction)
    return function()
        local fromScreen = hs.mouse.getCurrentScreen()
        local toScreen = screens.inDirection(fromScreen, direction)
        if toScreen == nil then
            return
        end

        local win = hs.window.desktop()
        for _, w in pairs(hs.window.orderedWindows()) do
            if w:screen() == toScreen then
                win = w
                break
            end
        end

        local pos = hs.mouse.getRelativePosition()
        pos.x = round((pos.x / fromScreen:frame().w) * toScreen:frame().w)
        pos.y = round((pos.y / fromScreen:frame().h) * toScreen:frame().h)

        hs.mouse.setRelativePosition(pos, toScreen)
        win:focus()
    end
end

local mouseMovers = {'left', 'right'}
for k, dir in pairs(mouseMovers) do
    hs.hotkey.bind({'command', 'alt', 'shift'}, dir, mouseMover(dir))
end

