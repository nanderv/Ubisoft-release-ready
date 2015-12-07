local sti = require "Simple-Tiled-Implementation"
local gamera =  require 'gamera.gamera'
gamestate = {}
debug = true
zz = {}
back = {}
tile_width =32
tile_height=32
local function addBlock(x,y,w,h,gamestate)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  gamestate.n_blocks =gamestate.n_blocks +1
  block.isWall = true
  gamestate.blocks["a"..gamestate.n_blocks] = block
  gamestate.world:add(block, x,y,w,h)
  return block
end
function findSolidTiles(map)
    local collidable_tiles = {}
    local layer = map.layers["collision"]
    for y = 1, map.height do
    	for x = 1, map.width do

        if layer.data[y][x] then
          collidable_tiles[#collidable_tiles] = addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,gamestate)
        end
      end
    end

    return collidable_tiles
end
function love.load()
	gamestate.map = sti.new("map.lua")
	  gamestate.cam = gamera.new(0,0,2000,2000)
i = 0
  findSolidTiles(gamestate.map)
end

function love.update(dt)
	gamestate.cam:setPosition(400+i,200)
	i = i + dt*60
end

function love.draw(dt)
	gamestate.cam:draw(function(l,t,w,h)
gamestate.map:draw()
end)
	   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	
end
function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end
