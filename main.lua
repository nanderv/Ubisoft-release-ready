require("hex.grid")
debug = true
zz = {}
back = {}

function love.load(arg)
	love.math.setRandomSeed(129)
	math.random()
	math.random()
	math.random()
	math.random()
	math.random()
    hexgrid.start("hex/loader.lua")
  
end

function love.update(dt)
	while (true) do
		v = hexgrid.output:pop()
		if v == nil then
			break
		end
		hexgrid.map[v.x..":"..v.y] = v
		print(v[1])
	end
	hexgrid.get_render_area(2,2,30,30)
end

function love.draw(dt)

end
function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end