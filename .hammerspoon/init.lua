-- ~/.hammerspoon/init.lua
-- Simple dock shortcuts

-- Function to launch or focus application
function launchOrFocusApp(appName)
    local app = hs.application.find(appName)
    if app then
        app:activate()
        hs.alert.show("→ " .. appName, {}, 0.8)
    else
        hs.application.launchOrFocus(appName)
        hs.alert.show("🚀 " .. appName, {}, 0.8)
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
