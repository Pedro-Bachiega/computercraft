if not fs.exists("constants") then
    error("Please create \"constants\" file with loot chest coordinates referenced as \"CHEST_X\", \"CHEST_Y\", \"CHEST_Z\"")
end

os.loadApi("constants")

local startPosition = vector.new(gps.locate(5))
local chestPosition = vector.new(constants.CHEST_X, constants.CHEST_Y, constants.CHEST_Z)

print("How many steps?")
local steps = io.read()

local function walk(shouldDig)
    for i=0, steps, 1 do
        if shouldDig then
            if not Turtle.forward() then 
                Turtle.dig()
                Turtle.forward()
            end
            Turtle.digUp()
            Turtle.digDown()
        else
            Turtle.forward()
        end
    end
end

local function depositItems()
    print("I am " .. tostring(startPosition - chestPosition) .. " steps away from the chest")
end

walk(true)
Turtle.turnRight()
Turtle.turnRight()
walk(false)
depositItems()
