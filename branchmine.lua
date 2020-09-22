if fs.exists("constants") then
    os.loadAPI("constants")
    if CHEST_X == 0 and CHEST_Z == 0 and CHEST_Y == 0 then
        print("Please write the coordinates to the dump chest inside the file \"constants\"")
    end
else
    local file = io.open("constants", "w")
    file:write([[
        CHEST_X=0
        CHEST_Z=0
        CHEST_Y=0
    ]])
    file:close()

    print("Please write the coordinates to the dump chest inside the file \"constants\"")
end

local shouldStopDigging = false
local startPosition = vector.new(gps.locate(5))
local chestPosition = vector.new(constants.CHEST_X, constants.CHEST_Y, constants.CHEST_Z)

local currentDisplacement = 0
local steps = arg[1]
if steps == nil then
    print("How many steps?")
    steps = io.read()
end

steps = tonumber(steps)

DIR_WEST=1
DIR_SOUTH=2
DIR_EAST=3
DIR_NORTH=4

local function checkFuel(printError)
    if turtle.getFuelLevel() < (steps*2) then
        if printError then error("Insufficient fuel") end

        for i = 1, 16 do
            turtle.select(i)
            if turtle.refuel(0) then
                local halfStack = math.ceil(turtle.getItemCount(i)/2)
                turtle.refuel(halfStack)
            end
        end

        checkFuel(true)
    end
end

local function checkInventorySpace()
    hasSpace = false

    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then hasSpace = true end
    end

    shouldStopDigging = not hasSpace
end

local function placeTorch()
    turtle.select(1)
    turtle.placeUp(1)
end

local function walk(isDigging)
    for i=0, steps, 1 do
        if i % 5 == 0 and isDigging then
            placeTorch()
        elseif i % 10 == 0 and isDigging then 
            checkInventorySpace() 
        end

        if not shouldStopDigging and isDigging then
            if not turtle.forward() then 
                turtle.dig()
                turtle.forward()
                currentDisplacement = currentDisplacement + 1
            end
            turtle.digUp()
            turtle.digDown()
        elseif not isDigging and currentDisplacement > 0 then
            turtle.forward()
            currentDisplacement = currentDisplacement - 1
        end
    end
end

--[[
-x = 1
-z = 2
+x = 3
+z = 4
--]]
local function getOrientation()
    loc1 = vector.new(gps.locate(5, false))
    turtle.forward()
    loc2 = vector.new(gps.locate(5, false))
    heading = loc2 - loc1

    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()

    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
end

local function move(distance)
    moveDistance = distance
    if moveDistance < 0 then moveDistance = (dismoveDistancetance * -1) end
    for i=0, moveDistance - 1, 1 do
        turtle.forward()
    end
end

local function isAtChestSpot(currentPosition)
    return currentPosition.x == chestPosition.x and currentPosition.z == chestPosition.z and currentPosition.y == chestPosition.y + 1 and turtle.detectDown()
end

local function moveToChest(currentPosition)
    distance = 0
    orientation = getOrientation()

    if currentPosition.x > chestPosition.x then
        if orientation == DIR_NORTH then
            turtle.turnLeft()
        elseif orientation == DIR_EAST then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif orientation == DIR_SOUTH then
            turtle.turnRight()
        end

        distance = currentPosition.x - chestPosition.x
        move(distance)
    elseif currentPosition.x < chestPosition.x then
        if orientation == DIR_NORTH then
            turtle.turnRight()
        elseif orientation == DIR_WEST then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif orientation == DIR_SOUTH then
            turtle.turnLeft()
        end

        distance = chestPosition.x - currentPosition.x
        move(distance)
    elseif currentPosition.z > chestPosition.z then
        if orientation == DIR_NORTH then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif orientation == DIR_WEST then
            turtle.turnLeft()
        elseif orientation == DIR_EAST then
            turtle.turnRight()
        end

        distance = currentPosition.z - chestPosition.z
        move(distance)
    elseif chestPosition.z > currentPosition.z then
        if orientation == DIR_SOUTH then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif orientation == DIR_WEST then
            turtle.turnRight()
        elseif orientation == DIR_EAST then
            turtle.turnLeft()
        end

        distance = chestPosition.z - currentPosition.z
        move(distance)
    end

    position = vector.new(gps.locate(5))

    if not isAtChestSpot(position) then moveToChest(position) end
end

local function depositItems()
    currentPosition = vector.new(gps.locate(5))

    if isAtChestSpot(currentPosition) then
        for i = 1, 16 do
            turtle.select(i)
            turtle.dropDown()
        end
    else
        moveToChest(currentPosition)
        depositItems()
    end
end

checkFuel(false)

walk(true)
turtle.turnRight()
turtle.turnRight()
walk(false)

depositItems()
