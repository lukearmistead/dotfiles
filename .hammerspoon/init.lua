-- ~/.hammerspoon/init.lua
-- Simple dock shortcuts

-- Function to launch or focus application
function launchOrFocusApp(appName)
    local app = hs.application.find(appName)
    if app then
        app:activate()
    else
        hs.application.launchOrFocus(appName)
    end
end

-- Set up simple hotkeys
hs.hotkey.bind({"alt"}, "`", function()
    launchOrFocusApp("Finder")
end)

hs.hotkey.bind({"alt"}, "1", function()
    launchOrFocusApp("Google Chrome")
end)

hs.hotkey.bind({"alt"}, "2", function()
    launchOrFocusApp("iTerm")
end)

-- Reload Hammerspoon config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)

print("Dock shortcuts loaded:")
print("Alt+` → Finder")
print("Alt+1 → Google Chrome") 
print("Alt+2 → iTerm")

hs.alert.show("Dock shortcuts ready!", {}, 1.5)

-- Window management shortcuts
-- Add this to your ~/.hammerspoon/init.lua

-- Helper function to get screen dimensions
function getScreenFrame()
    return hs.screen.mainScreen():frame()
end

-- Cmd+Ctrl+L: Move window to right half
hs.hotkey.bind({"cmd", "ctrl"}, "L", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = getScreenFrame()
        win:setFrame({
            x = screen.w / 2,
            y = 0,
            w = screen.w / 2,
            h = screen.h
        })
    end
end)

-- Cmd+Ctrl+H: Move window to left half
hs.hotkey.bind({"cmd", "ctrl"}, "H", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = getScreenFrame()
        win:setFrame({
            x = 0,
            y = 0,
            w = screen.w / 2,
            h = screen.h
        })
    end
end)

-- Cmd+Ctrl+K: Maximize window (not fullscreen)
hs.hotkey.bind({"cmd", "ctrl"}, "K", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = getScreenFrame()
        win:setFrame({
            x = 0,
            y = 0,
            w = screen.w,
            h = screen.h
        })
    end
end)

-- Cmd+Ctrl+J: Center window at half size
hs.hotkey.bind({"cmd", "ctrl"}, "J", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = getScreenFrame()
        local newWidth = screen.w * 0.6  -- 60% of screen width
        local newHeight = screen.h * 0.7 -- 70% of screen height
        win:setFrame({
            x = (screen.w - newWidth) / 2,   -- Center horizontally
            y = (screen.h - newHeight) / 2,  -- Center vertically
            w = newWidth,
            h = newHeight
        })

    end
end)

print("Window management shortcuts loaded:")
print("Cmd+Ctrl+H → Left half")
print("Cmd+Ctrl+L → Right half") 
print("Cmd+Ctrl+K → Maximize")
print("Cmd+Ctrl+J → Center (60% size)")
