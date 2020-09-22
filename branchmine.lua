if fs.exists("constants") then
    os.loadApi("constants")
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
    turtle.place(1)
end

local function walk(isDigging)
    for i=0, steps, 1 do
        if i % 5 == 0 then
            placeTorch()
        elseif i % 10 == 0 then 
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
    print("I am " .. tostring(startPosition - chestPosition) .. " steps away from the chest")
end

checkFuel(false)

walk(true)
turtle.turnRight()
turtle.turnRight()
walk(false)
depositItems()
