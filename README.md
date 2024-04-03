
# A Simple MoonScript Setup for LÖVE

No configuration, no commands to run, no submodules, no baloney.

This project is set up for LÖVE 11.5 "Mysterious Mysteries."

Inside `lib/` you will find LuLPeg and a single-file splat of MoonScript, along
with a `love.errorhandler` implementation that uses MoonScript's error
rewriting.

The `main.lua` loads this error handler and `game.moon`, which holds an example
implementation of "Pickin' Sticks", a simple example game created by Moosadee
years ago (see: https://youtu.be/PYrS54WH96Q)

**Note:** If you want to distribute your game as a `.love` ZIP file, moonloader
_will not work_ because LÖVE relies on a custom Lua loader for zipped code
files. You will need to compile your MoonScript using `moonc` before compressing.
