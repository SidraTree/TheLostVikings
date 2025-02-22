function loadStarfield ()
	starfield = {}
    for i = 1,250,1 do
        table.insert(starfield, 
            {
                x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2)),
                y = math.random(love.graphics.getHeight()),
                speed = (math.random(300) + 200),
                size = (math.random(2))
            })
    end
end

function updateStarfield(dt)
    for k,v in pairs(starfield) do
        v.y = v.y + (v.speed * dt)
        if v.y > love.graphics.getHeight() then
                v.x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2))
                v.y = 0 - math.random(love.graphics.getHeight())
        end
    end
end

function drawStarfield()
    love.graphics.setColor(255,255,255)
    for k,v in pairs(starfield) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end