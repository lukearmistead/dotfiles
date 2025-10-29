-- ~/.hammerspoon/init.lua

-- Function to launch or focus application
function launchOrFocusApp(appName)
    local app = hs.application.find(appName)
    if app then
        app:activate()
    else
        hs.application.launchOrFocus(appName)
    end
end

-- Application shortcuts
hs.hotkey.bind({"alt"}, "`", function() launchOrFocusApp("Finder") end)
hs.hotkey.bind({"alt"}, "1", function() launchOrFocusApp("Google Chrome") end)
hs.hotkey.bind({"alt"}, "2", function() launchOrFocusApp("iTerm") end)

-- Reload Hammerspoon config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function() hs.reload() end)

-- Cmd+Ctrl+L: Move window to right half
hs.hotkey.bind({"cmd", "ctrl"}, "L", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x + screen.w / 2,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
    end
end)

-- Cmd+Ctrl+H: Move window to left half
hs.hotkey.bind({"cmd", "ctrl"}, "H", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
    end
end)

-- Cmd+Ctrl+K: Maximize window (not fullscreen)
hs.hotkey.bind({"cmd", "ctrl"}, "K", function()
    local win = hs.window.focusedWindow()
    if win then
        win:maximize()
    end
end)

-- Cmd+Ctrl+J: Center window at 60% size
hs.hotkey.bind({"cmd", "ctrl"}, "J", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        local newWidth = screen.w * 0.6
        local newHeight = screen.h * 0.7
        win:setFrame({
            x = screen.x + (screen.w - newWidth) / 2,
            y = screen.y + (screen.h - newHeight) / 2,
            w = newWidth,
            h = newHeight
        })
    end
end)

-- Ctrl+Cmd+U: Move window to left monitor
hs.hotkey.bind({"ctrl", "cmd"}, "U", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenWest(nil, nil, 0)  -- instant movement
    end
end)

-- Ctrl+Cmd+D: Move window to right monitor
hs.hotkey.bind({"ctrl", "cmd"}, "D", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveOneScreenEast(nil, nil, 0)  -- instant movement
    end
end)

-- Print all shortcuts
print("Shortcuts loaded:")
print("Alt+` → Finder")
print("Alt+1 → Google Chrome") 
print("Alt+2 → iTerm")
print("Cmd+Ctrl+H → Left half")
print("Cmd+Ctrl+L → Right half") 
print("Cmd+Ctrl+K → Maximize")
print("Cmd+Ctrl+J → Center (60% size)")
print("Ctrl+Cmd+U → Move to left monitor")
print("Ctrl+Cmd+D → Move to right monitor")

hs.alert.show("Hammerspoon ready!", {}, 1.5)
