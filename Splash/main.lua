local sti = require "sti"
local gamera =  require 'gamera.gamera'
EPS = 3
XMINSP = 10
splash = require("splash.splash")
gamestate = {}
debug = true
zz = {}
GRAV = 1300
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

  for k,v in pairs(layer.objects) do
    for kk,vv in pairs(v.polyline) do
      if op ~= nil then
          local shape = splash.seg(op.x,op.y,vv.x-op.x,vv.y-op.y)
        print(vv.x-op.x,vv.y-op.y)
      lines[#lines+1] = gamestate.world:add({}, shape)
      

      end
        op = vv
    end
    op = nil
  end
  print (#lines)
end

function love.load()
  gamestate.world = splash.new(64) -- or splash(cellSize)
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  gamestate.map = sti.new("map2.lua")
    gamestate.cam = gamera.new(0,-100,20000,20000)
i = 0

  gamestate.me={x=120,y=50,dx=0,dy=0}
  gamestate.me.jumps = 2
  gamestate.n_blocks = 0
  gamestate.blocks = {}

  gamestate.me.img =  love.graphics.newImage( "character.png" )
  local shape = splash.circle(gamestate.me.x, gamestate.me.y, 16)
    gamestate.me.obj = gamestate.world:add({},shape)
  --findSolidTiles(gamestate.map)
  findLinesAndSegments(gamestate.map.layers.col)

  local shape = splash.aabb(150,50,50, 50)
  gamestate.world:add({},shape)
end

function love.update(dt)
    gamestate.me.dx = 0

  if love.keyboard.isDown("left") then
                gamestate.me.dx =-1
              end
                if love.keyboard.isDown("right") then
                gamestate.me.dx = 1
              end
      if love.keyboard.isDown("up") then
            if gamestate.jump == true and math.abs(gamestate.me.edy) <EPS and gamestate.me.jumps >0 then
              gamestate.me.jumps = gamestate.me.jumps -1
              gamestate.me.dy = -500
              gamestate.jump = false
              print("JUMP")
            end
        else

          gamestate.jump = true
          
        end
gamestate.me.dy = gamestate.me.dy + dt*GRAV
local ddy = gamestate.me.dy*dt
if(love.keyboard.isDown("w")) then
        print(gamestate.me.x..":"..gamestate.me.y)

      end

      local type,x,y,_,_ = gamestate.world:unpackShape(gamestate.me.obj)
      gamestate.me.x = x
      gamestate.me.y = y

      local xto, yto = gamestate.world:move(gamestate.me.obj, x+gamestate.me.dx, y+ddy)
  gamestate.me.edx = xto-x




  gamestate.me.edy = yto - y

  if(math.abs(gamestate.me.edy) < 0.1 and yto ~= y+ddy) then
    print("RESET"..gamestate.me.edy)
    gamestate.me.jumps = 2
  end


end

function drawObject(v, r, g, b)
    
    local _,x, y, x2, y2 = gamestate.world:unpackShape(v)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.line(x, y, x+x2, y+y2)
  
end



function love.draw()
  gamestate.cam:draw(function(l,t,w,h)
gamestate.map:draw()
 love.graphics.draw( gamestate.me.img,gamestate.me.x-16, gamestate.me.y-16 )
     for k,v in pairs (lines) do
        drawObject(v,0,255,0)
     end
     love.graphics.rectangle("fill",150,50,50, 50)
    -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
end)


 love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  
end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end


