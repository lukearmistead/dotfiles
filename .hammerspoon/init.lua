-- SET £
hs.loadSpoon("ControlEscape")
spoon.ControlEscape:start()

-- SET UP HYPERKEY
-- https://github.com/dbalatero/HyperKey.spoon#usage
-- local hyper = {'cmd', 'alt', 'ctrl', 'shift'}
local HyperKey = hs.loadSpoon("HyperKey")
hyperKey = HyperKey:new({'alt'}, {overlayTimeoutMs = 10000})
hyperKey
  :bind('1'):toApplication('/Users/luke.armistead/Applications/Island.app')
  :bind('2'):toApplication('/Applications/ITerm.app')
  :bind('3'):toApplication('/Applications/Cursor.app')
  :bind('4'):toApplication('/Applications/zoom.us.app')
  :bind('5'):toApplication('/Applications/Spotify.app')
