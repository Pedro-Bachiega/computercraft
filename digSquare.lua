print("Square size:")
local size = io.read()

function digStraight(totalBlocks)
    for currentBlock = 1, totalBlocks, 1 do
        while not turtle.forward() do turtle.dig() end
        turtle.digUp()
        turtle.digDown()
    end
end

function dig()
    digStraight(size)

    local direction = "left"
    for currentRow = 1, size-1, 1 do
        if direction == "left" then
            turtle.turnLeft()
            digStraight(1)
            turtle.turnLeft()
            direction = "right"
        else
            turtle.turnRight()
            digStraight(1)
            turtle.turnRight()
            direction = "left"
        end
        digStraight(size -1)
    end
end

dig()