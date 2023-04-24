-- SET 
hs.loadSpoon("ControlEscape")
spoon.ControlEscape:start()

-- SET UP HYPERKEY
-- https://github.com/dbalatero/HyperKey.spoon#usage
-- local hyper = {'cmd', 'alt', 'ctrl', 'shift'}
local hyper = {'alt'}

local HyperKey = hs.loadSpoon("HyperKey")
hyperKey = HyperKey:new(hyper)
hyperKey
  :bind('1'):toApplication('/Applications/Google Chrome.app')
  :bind('2'):toApplication('/Applications/ITerm.app')
  :bind('5'):toApplication('/Applications/Spotify.app')
