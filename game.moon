-- An example implementation of Pickin' Sticks.

require 'math'


-------------------------------------------------------------------------------
class PickinSticks
  collected: 0
  stick:
    x: 0
    y: 0
  player:
    x: 0
    y: 0
  board: [ [ 0 for y = 1,15 ] for x = 1,20 ]
  lastCollectTime: 0


-------------------------------------------------------------------------------
local data, boardWidth, boardHeight


-------------------------------------------------------------------------------
love.load = ->
  -- love.keyboard.setKeyRepeat true
  love.graphics.setDefaultFilter "nearest", "nearest"
  love.graphics.setLineWidth 2

  -- Load font.
  font = love.graphics.newImageFont(
    "font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""
  )
  love.graphics.setFont(font)

  -- Game data.
  data = PickinSticks()

  -- Drawing info.
  boardWidth = 32 * #data.board
  boardHeight = 32 * #data.board[1]

  -- Place walls.
  for x,col in ipairs data.board
    for y,tile in ipairs col
      data.board[x][y] = 1  if x==1 or y==1 or x==#data.board or y==#col

  -- Place player and stick.
  data.player.x = math.floor(boardWidth/32 / 2)
  data.player.y = math.floor(boardHeight/32 / 2)
  data.stick.x = data.player.x + 4
  data.stick.y = data.player.y


-------------------------------------------------------------------------------
love.keypressed = (key, scancode, isrepeat) ->
  oldx = data.player.x
  oldy = data.player.y

  -- Move the player.
  unless isrepeat
    switch key
      when "escape"
        love.event.quit!
      when "left","a"
        data.player.x -= 1  unless data.player.x <= 1
      when "right","d"
        data.player.x += 1  unless data.player.x >= #data.board - 2
      when "up","w"
        data.player.y -= 1  unless data.player.y <= 1
      when "down","s"
        data.player.y += 1  unless data.player.y >= #data.board[data.player.x] - 2
      -- This was for testing the errorhandler implementation.
      -- when "space"
        -- stinky! -- Runtime error!

  -- Collect sticks.
  if data.player.x != oldx or data.player.y != oldy
    if data.player.x == data.stick.x and data.player.y == data.stick.y
      data.collected += 1
      data.lastCollectTime = love.timer.getTime!
      data.stick.x = math.floor(math.random()*(#data.board - 3) + 1)
      data.stick.y = math.floor(math.random()*(#data.board[1] - 3) + 1)


-------------------------------------------------------------------------------
love.update = -> -- Nothing to do! ¯\_(ツ)_/¯


-------------------------------------------------------------------------------
love.draw = ->
  love.graphics.clear 0.25, 0.25, 0.8

  -- Draw board centered on the window.
  startX = (love.graphics.getWidth! - boardWidth)/2
  startY = (love.graphics.getHeight! - boardHeight)/2
  for x,col in ipairs data.board
    for y,tile in ipairs col
      switch tile
        when 0
          love.graphics.setColor 1,1,1,0.25
          love.graphics.rectangle "line", startX + (x-1)*32, startY + (y-1)*32, 32,32
        when 1
          love.graphics.setColor 0,0,0,1
          love.graphics.rectangle "fill", startX + (x-1)*32 + 6, startY + (y-1)*32 + 6, 32,32
          love.graphics.setColor 1,1,1,1
          love.graphics.rectangle "fill", startX + (x-1)*32, startY + (y-1)*32, 32,32

  -- Board outline.
  love.graphics.setColor 0,0,0,1
  love.graphics.rectangle "line", startX, startY, boardWidth, boardHeight
  love.graphics.rectangle "line", startX+32, startY+32, boardWidth-64, boardHeight-64

  -- Draw the stick.
  do
    x = startX + data.stick.x*32 + 6
    y = startY + data.stick.y*32 + 6
    love.graphics.setColor 0,0,0
    love.graphics.rectangle "fill", x+3,y+3, 20,20
    love.graphics.setColor 0.8,0.4,0.0
    love.graphics.rectangle "fill", x,y, 20,20
    love.graphics.setColor 0,0,0
    love.graphics.rectangle "line", x,y, 20,20

  -- Draw the player.
  do
    x = startX + data.player.x*32 + 4
    y = startY + data.player.y*32 - 12
    love.graphics.setColor 0,0,0
    love.graphics.rectangle "fill", x,y, 22+3,40+3
    love.graphics.setColor 0.4,0.8,0.0
    love.graphics.rectangle "fill", x,y, 22,40
    love.graphics.setColor 0,0,0
    love.graphics.rectangle "line", x,y, 22,40

  -- Draw the score.
  do
    amount = 0
    if data.lastCollectTime != 0
      elapsed = love.timer.getTime! - data.lastCollectTime
      f = math.max(0, 1.0 - elapsed)
      amount = -((math.sin(elapsed * 4 * math.pi * 2)+1)/2) * f
    love.graphics.setColor 1,1,1,1
    love.graphics.print "SCORE: " .. data.collected, 20,15+amount*8, 0, 2,2

  -- Draw the timer.
  do
    t = math.floor love.timer.getTime!
    hours = math.floor(t / 3600)
    minutes = math.floor((t - hours*3600) / 60)
    seconds = math.floor((t - hours*3600 - minutes*60))
    sh = ''..hours
    sm = ''..minutes
    ss = ''..seconds
    sh = '0'..sh  if #sh == 1
    sm = '0'..sm  if #sm == 1
    ss = '0'..ss  if #ss == 1
    s = sh .. ":" .. sm .. ":" .. ss
    love.graphics.setColor 1,1,1,1
    love.graphics.print s, love.graphics.getWidth! - 150,15, 0, 2,2
