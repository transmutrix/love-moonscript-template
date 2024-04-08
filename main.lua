
-- Set our base require paths.
love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua;lib/?/init.lua")
love.filesystem.setCRequirePath("??;lib/??")

-- Import LPeg for current platform, fallback to LuLPeg.
do
  -- Set up native require paths (for LPeg).
  local os = require'love'.system.getOS()
  local c_require_path = love.filesystem.getCRequirePath()
  if os == "OS X" then
    print "setting LPeg require path for macOS ARM"
    love.filesystem.setCRequirePath(c_require_path .. ";lib/macOS_arm/??")
    -- If it doesn't load, try x64 architecture instead. Stupid hack.
    local success = pcall(require, "lpeg")
    if not success then
      print "setting LPeg require path for macOS x64"
      love.filesystem.setCRequirePath(c_require_path .. ";lib/macOS_x64/??")
    end
  elseif os == "Windows" then
    print "setting LPeg require path for Windows x64"
    love.filesystem.setCRequirePath(c_require_path .. ";lib/win32_x64/??")
  else
    print "WARNING: Supply LPeg .so for your platform here!"
  end
  -- Import LPeg
  local success, lpeg = pcall(require, "lpeg")
  if success then
    print("LPeg loaded successfully.")
  else
    print("WARNING: Falling back to LuLPeg. Some MoonScript features may not work!")
    lpeg = require("lulpeg"):register(not _ENV and _G)
  end
end

-- Import the MoonScript loader.
require "moonscript"

-- Import our custom error handler.
require "errorhandler"

-- Import the actual game code.
require "game"
