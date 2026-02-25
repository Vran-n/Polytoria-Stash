local PlayerGUI = game['PlayerGUI']
local ScriptService = game['ScriptService']

local Utils = ScriptService['Utils']

local Benchmarker = require(Utils['Benchmarker'])


-- EXAMPLER #1
Benchmarker.Test("Control", 4, function(Time)
    wait(1)
end)


-- EXAMPLER #2
Benchmarker.Test("Control #2", 4, function(Time)
    wait(0.1)
    Time.Split(1)
    wait(0.2)
end)


-- EXAMPLER #2
Benchmarker.Start("New & Destroy XYZ", 20,function(Time)
    local bxs = {}

    for x = 1, 10 do
        for z = 1, 10 do
            for y = 1, 10 do
                local brick = Instance.New("Part")
                brick.Parent = game['Environment']
                brick.Position = Vector3.New((x*2) + 40, (y*2) + 2, (-z)*2)
                brick.Size = Vector3.New(1, 1, 1)
                table.insert(bxs, brick)
            end 
        end
    end

    Time.Split()

    for _, value in ipairs(bxs) do
        value:Destroy()
    end
end).And("New & Destroy XZ", function(Time)
    local bxs = {}

    for x = 1, 10 do
        for z = 1, 10 do
            local brick = Instance.New("Part")
            brick.Parent = game['Environment']
            brick.Position = Vector3.New((x*2) + 40, 2, (-z)*2)
            brick.Size = Vector3.New(1, 1, 1)
            table.insert(bxs, brick)
        end
    end

    Time.Split()

    for _, value in ipairs(bxs) do
        value:Destroy()
    end
end).Finish()
