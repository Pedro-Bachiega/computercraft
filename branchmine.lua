local shouldStopDigging = false
local currentDisplacement = 0
local steps = arg[1]
if steps == nil then
    print("How many steps?")
    steps = io.read()
end

steps = tonumber(steps)

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

local function depositItems()
    turtle.select(2)
    turtle.placeDown()

    for i = 3, 16 do
        turtle.select(i)
        turtle.dropDown()
    end

    turtle.digDown()
end

checkFuel(false)

walk(true)
turtle.turnRight()
turtle.turnRight()
walk(false)

depositItems()
