local sti = require "sti"
local gamera =  require 'gamera.gamera'
require 'music'

EPS = 3
EPSILON = 0.5
fizz = require("fizzx.fizz")
gamestate = {}
gamestate.jumps = 2
debug = true
zz = {}
back = {}
tile_width =32
lines = {}
tile_height=32
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1
  block.isWall = true
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.jump = true
  gamestate.world:add(block, x,y,w,h)
  return block
end
function findLinesAndSegments(layer)
  op = nil
  for k,v in pairs(layer.objects) do
    for kk,vv in pairs(v.polyline) do
      fizz.addStatic("circle", vv.x, vv.y, 0)
      if op ~= nil then
         -- local shape = fizz.addStatic("line", op.x, op.y, vv.x, vv.y)
          local shape = fizz.addStatic("line", vv.x, vv.y, op.x, op.y)
      
      lines[#lines+1] = shape

      end
        op = vv
    end
  end
end

function love.load()
  fizz.setGravity(0,50)
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  gamestate.map = sti.new("map2.lua")
    gamestate.cam = gamera.new(0,-100,20000,20000)
i = 0
  gamestate.me={x=120,y=50,dx=0,dy=0}
  gamestate.n_blocks = 0
  gamestate.blocks = {}
  local t = {}
  t.track = "music/theme_loop.wav"
  local n = {}
  n.track =  "music/themeloop2.wav"
  t.next = n
  n.next = t
  track = t
  play()
  gamestate.me.img =  love.graphics.newImage( "character.png" )
    gamestate.me.obj = fizz.addDynamic("circle", gamestate.me.x, gamestate.me.y, 16)
  gamestate.me.obj.gravity = 5
  --findSolidTiles(gamestate.map)
  findLinesAndSegments(gamestate.map.layers.col)
end

function love.update(dt)
      dt = math.min(dt,0.7)

TEsound.cleanup()
  if love.keyboard.isDown("left") then
                gamestate.me.dx = gamestate.me.dx-12
  end
  if love.keyboard.isDown("right") then
    gamestate.me.dx = gamestate.me.dx+12
  end
  if love.keyboard.isDown("up") and gamestate.jumps > 0 then

    if gamestate.jump == true and math.abs(gamestate.me.edy) <EPS then
      gamestate.jumps = gamestate.jumps -1  
      gamestate.me.dy = -50
      gamestate.jump = false
    end
  else
        gamestate.jump = true    
  end
  if(gamestate.me.dx >0) then
              gamestate.me.dx = (1-30*dt)*math.min(40,gamestate.me.dx)
else
              gamestate.me.dx = (1-30*dt)*math.max(-40,gamestate.me.dx)

end

if(love.keyboard.isDown("w")) then

      end
      local ddx, ddy = fizz.getVelocity(gamestate.me.obj)
      local oy = gamestate.me.obj.y
      local ox = gamestate.me.obj.x

      for i=1,18 do
        -- set all velocities to what you
           fizz.setVelocity(gamestate.me.obj,gamestate.me.dx,ddy+gamestate.me.dy)

      fizz.update(dt)
      end
gamestate.me.dy = 0
  gamestate.me.edx = gamestate.me.obj.x-ox
  gamestate.me.edy = gamestate.me.obj.y-oy 
    if(ddy >EPS and math.abs(ddy-gamestate.me.edy )> EPSILON) then
      gamestate.jumps = 2


  end
  gamestate.cam:setPosition(gamestate.me.obj.x, gamestate.me.obj.y)
  gamestate.cam.scale = (2.0)
end

function drawObject(v, r, g, b)
  local lg = love.graphics
  if v.shape == 'rect' then
    local x, y, w, h = v.x, v.y, v.hw, v.hh
    lg.setColor(r, g, b, 255)
    lg.rectangle("fill", x - w, y - h, w*2, h*2)
  elseif v.shape == 'circle' then
    local x, y, radius = v.x, v.y, v.r
    lg.setColor(r, g, b, 255)
    lg.circle("fill", x, y, radius, 32)
  elseif v.shape == 'line' then
    local x, y, x2, y2 = v.x, v.y, v.x2, v.y2
    lg.setColor(r, g, b, 255)
    lg.line(x, y, x2, y2)
  end
end



function love.draw()
  gamestate.cam:draw(function(l,t,w,h)
gamestate.map:draw()
 love.graphics.draw( gamestate.me.img,gamestate.me.obj.x-16, gamestate.me.obj.y-16 )
     for k,v in pairs (lines) do
        drawObject(v,0,255,0)
     end

end)

 love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  
end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


