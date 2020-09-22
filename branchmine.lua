local shouldPlaceTorches = false
local currentDisplacement = 0
local steps = arg[1]
local repeatCount = arg[2]
if steps == nil then
    print("How many steps?")
    steps = io.read()
end
if repeatCount == nil then
    print("How many repetitions?")
    repeatCount = io.read()
end

currentLap = 0

steps = tonumber(steps)
repeatCount = tonumber(repeatCount)

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

local function depositItems()
    turtle.select(2)
    turtle.placeDown()

    for i = 3, 16 do
        turtle.select(i)
        turtle.dropDown()
    end

    --ONLY WHEN USING ENDER CHEST
    --turtle.digDown()
end

local function checkInventorySpace()
    hasSpace = false

    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then hasSpace = true end
    end

    if not hasSpace then
        depositItems()
    end
end

local function placeTorch()
    turtle.select(1)
    turtle.placeDown(1)
end

local function walk(isDigging)
    for i=0, steps, 1 do
        if i > 0 and i % 5 == 0 and isDigging and shouldPlaceTorches then
            placeTorch()
        --ONLY WHEN USING ENDER CHEST
        --elseif i % 10 == 0 and isDigging then 
            --checkInventorySpace()
        end

        if isDigging then
            while not turtle.forward() do 
                turtle.dig()
            end

            currentDisplacement = currentDisplacement + 1
            turtle.digUp()
            turtle.digDown()
        elseif not isDigging and currentDisplacement > 0 then
            turtle.forward()
            currentDisplacement = currentDisplacement - 1
        end
    end
end

for i=0, repeatCount, 1 do
    currentLap = i + 1

    turtle.select(1)
    shouldPlaceTorches = turtle.compareDown()

    checkFuel(false)

    if not turtle.forward() then
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
    end

    walk(true)
    turtle.turnLeft()
    turtle.turnLeft()
    walk(false)

    if currentLap % 2 == 0 then
        checkFuel(false)
        depositItems()
    end

    turtle.select(1)
    turtle.forward()
    turtle.turnLeft()
    if not turtle.forward() then turtle.dig() end
    if not turtle.compareDown() then turtle.digDown() end
    turtle.digUp()
    turtle.turnLeft()
end