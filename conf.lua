
-- Import LuLPeg.
local success, lpeg = pcall(require, "lpeg")
lpeg = success and lpeg or require"lib.lulpeg":register(not _ENV and _G)

-- Import the MoonScript loader.
require 'lib.moonscript'

-- Config.
function love.conf(t)
  t.version = "11.5"
  t.window.title = "Pickin' Sticks"
  t.modules.physics = false
  t.modules.joystick = false
  t.modules.thread = false
end
