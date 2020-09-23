turtle.select(1)

local function refillBucket()
    engineStillRunning = turtle.getItemDetail(1) == turtle.getItemDetail(2)

    if not engineStillRunning then
        turtle.dropDown()
        os.sleep(3)
    end

    return engineStillRunning
end

local function feedFirst()
    turtle.up()
    turtle.drop()
    turtle.sleep(1)
    turtle.suck()
    turtle.down()
    return refillBucket()
end

local function feedSecond()
    turtle.turnLeft()
    turtle.up()
    turtle.drop()
    turtle.sleep(1)
    turtle.suck()
    turtle.down()
    return refillBucket()
end

local function feedThird()
    turtle.forward()
    turtle.turnRight()
    turtle.drop()
    turtle.sleep(1)
    turtle.suck()
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
    return refillBucket()
end

local function run()
    while true do
        while not feedFirst() do
            os.sleep(300)
        end

        while not feedSecond() do
            os.sleep(2)
        end

        while not feedThird() do
            os.sleep(2)
        end
    end
end

run()
