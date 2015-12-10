Collider = require 'HardonCollider'
local text = {}
function on_collide(dt, shape_a, shape_b)
    -- determine which shape is the ball and which is not
    local other

    if shape_a == ball then
        other = shape_b
    elseif shape_b == ball then
        other = shape_a
    else -- no shape is the ball. exit
        return
    end

    -- reset on goal
    if other == goalLeft then
        ball.velocity = {x = 1000, y = 0}
        ball:moveTo(400,300)
    elseif other == goalRight then
        ball.velocity = {x = -1000, y = 0}
        ball:moveTo(400,300)
    elseif other == borderTop or other == borderBottom then
    -- bounce off top and bottom
        ball.velocity.y = -ball.velocity.y
    else
    -- bounce of paddle
        local px,py = other:center()
        local bx,by = ball:center()
        local dy = by - py
        ball.velocity.x = -ball.velocity.x
        ball.velocity.y = dy

        -- keep the ball at the same speed
        local len = math.sqrt(ball.velocity.x^2 + ball.velocity.y^2)
        ball.velocity.x = ball.velocity.x / len * 1000
        ball.velocity.y = ball.velocity.y / len * 1000
    end
end

function love.load()
    for k,v in pairs(Collider) do
        print("KEY"..k)
        print(v)
    end
    ball        = Collider.circle(400,300, 10)
    leftPaddle  = Collider.rectangle(10,250, 20,100)
    rightPaddle = Collider.rectangle(770,250, 20,100)

    ball.velocity = {x = -1000, y = 0}

    borderTop    = Collider.rectangle(0,-100, 800,100)
    borderBottom = Collider.rectangle(0,600, 800,100)
    goalLeft     = Collider.rectangle(-100,0, 100,600)
    goalRight    = Collider.rectangle(800,0, 100,600)
end

function love.update(dt)
    ball:move(ball.velocity.x * dt, ball.velocity.y * dt)

    -- left player movement
    if love.keyboard.isDown('w') then
        leftPaddle:move(0, -100 * dt)
    elseif love.keyboard.isDown('s') then
        leftPaddle:move(0,  100 * dt)
    end

    -- right player movement
    if love.keyboard.isDown('up') then
        rightPaddle:move(0, -100 * dt)
    elseif love.keyboard.isDown('down') then
        rightPaddle:move(0,  100 * dt)
    end
    for shape, delta in pairs(Collider.collisions(ball)) do
        text[#text+1] = string.format("Colliding. Separating vector = (%s,%s)",
                                      delta.x, delta.y)
         on_collide(dt,ball,shape)
    end
   -- Collider:update(dt)
end

function love.draw()
    for i = 1,#text do
        love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
        love.graphics.print(text[#text - (i-1)], 10, i * 15)
    end
    ball:draw('fill', 16)
    leftPaddle:draw('fill')
    rightPaddle:draw('fill')
end
