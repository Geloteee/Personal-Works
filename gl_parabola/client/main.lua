--[[
    Developed by Geloteee#2901
    https://discord.gg/eBufX2WAYV
]]

local gravity = -9.8        -- Here we save the gravity acceleration (By default is set to -9.8)
local height = 400.0        -- Here we save the max height that the parabola is going to have
local resolution = 30       -- Here we save the number of lines that the parabola is going to have (More lines = More quality)

local from = vector3(580.7303, 2925.1121, 40.8883)
local target = vector3(240.7303, 2425.1121, 60.8883)

function math.sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
end

function CalculateLaunchData(from, target, height)
    local displacementY = target.z - from.z
    local displacementXZ = vector3(target.x - from.x, target.y - from.y, 0)
    local time = math.sqrt(-2*height/gravity) + math.sqrt(2*(displacementY - height)/gravity)
    local velocityY = vector3(0, 0, 1) * math.sqrt(-2 * gravity * height)
    local velocityXZ = displacementXZ / time
    return (velocityXZ + velocityY * -math.sign(gravity)), (time)
end

Citizen.CreateThread(function()
    while true do                                                                                                                       -- We create the while loop
        local initialVelocity, timeToTarget = CalculateLaunchData(from, target, height)                                                 -- Here you can change the function settings for each parabola
        local previousDrawPoint = from                                                                                                  -- Here we save a variable to get the previous point needed to make a the parabola
        for i=1, resolution do                                                                                                          -- Here we create the parabola with the resolution saved in the variable "resolution"
            local simulationTime = i / resolution * timeToTarget                                                                        -- Here we save a new variable to get the entire amount of time that the parabola is going to take
            local displacement = initialVelocity * simulationTime + vector3(0, 0, 1) * gravity * simulationTime * simulationTime / 2    -- Here we calculate the desplacement that the previous vector is going to make so we can get the draw point and connect both vectors
            local drawPoint = from + displacement                                                                                       -- Here we save the final draw point variable
            DrawLine(previousDrawPoint, drawPoint, 255, 0, 0, 255)                                                                      -- Here we draw the line with the function "DrawLine" of FiveM with the input of both vectors
            previousDrawPoint = drawPoint                                                                                               -- Here we set the previous point to connect the line
        end
        Citizen.Wait(0)                                                                                                                 -- If you don't ad any delay, it will crash the game
    end
end)

--[[
    Developed by Geloteee#2901
    https://discord.gg/eBufX2WAYV
]]