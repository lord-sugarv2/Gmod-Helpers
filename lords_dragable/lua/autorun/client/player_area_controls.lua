LordsUI = LordsUI or {}

local function IsPlayerBetweenPoints(ply, pointA, pointB)
    local playerPosition = ply:GetPos()
    if playerPosition.x >= math.min(pointA.x, pointB.x) and playerPosition.x <= math.max(pointA.x, pointB.x) then
        if playerPosition.y >= math.min(pointA.y, pointB.y) and playerPosition.y <= math.max(pointA.y, pointB.y) then
            if playerPosition.z >= math.min(pointA.z, pointB.z) and playerPosition.z <= math.max(pointA.z, pointB.z) then
                return true
            end
        end
    end

    return false
end

function LordsUI:IsInArea(ply, cornerOne, cornerTwo)
    return IsPlayerBetweenPoints(ply, cornerOne, cornerTwo)
end

LordsUI.Areas = {}
LordsUI.Players = {}

function LordsUI:OnEnterArea(cornerOne, cornerTwo, func)
    func = func or function() end

    table.Add(LordsUI.Areas, {{
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "OnEnter",
        func = func,
    }})
end

function LordsUI:OnExitArea(cornerOne, cornerTwo, func)
    func = func or function() end

    table.Add(LordsUI.Areas, {{
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "OnExit",
        func = func,
    }})
end

function LordsUI:WhileInArea(cornerOne, cornerTwo, func)
    func = func or function() end

    table.Add(LordsUI.Areas, {{
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "WhileIn",
        func = func,
    }})
end

function LordsUI:WhileNotInArea(cornerOne, cornerTwo, func)
    func = func or function() end

    table.Add(LordsUI.Areas, {{
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "WhileNotIn",
        func = func,
    }})
end

local function InArea(ply, data)
    if data.type == "OnEnter" and not LordsUI.Players[ply][data.id] then
        LordsUI.Players[ply][data.id] = true
        data.func(ply, data.cornerOne, data.cornerTwo)
    end

    if data.type == "WhileIn" then
        LordsUI.Players[ply][data.id] = true
        data.func(ply, data.cornerOne, data.cornerTwo)
    end
end

local function NotInArea(ply, data)
    if data.type == "OnExit" and LordsUI.Players[ply][data.id] then
        LordsUI.Players[ply][data.id] = false
        data.func(ply, data.cornerOne, data.cornerTwo)
    end

    if data.type == "WhileNotIn" and not LordsUI.Players[ply][data.id] then
        LordsUI.Players[ply][data.id] = false
        data.func(ply, data.cornerOne, data.cornerTwo)
    end
end

hook.Add("Think", "LordsUI:Areas", function()
    for _, data in ipairs(LordsUI.Areas) do
        for _, ply in ipairs(player.GetAll()) do
            LordsUI.Players[ply] = LordsUI.Players[ply] or {}
            if LordsUI:IsInArea(ply, data.cornerOne, data.cornerTwo) then
                InArea(ply, data)
            else
                NotInArea(ply, data)
            end
        end
    end
end)

--[[
local pos1 = Vector(-3293.659912, -2068.002686, 47.968750)
local pos2 = Vector(-2954.133057, -1164.360474, -195.968750)
LordsUI:OnEnterArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
    print(ply, "ENTERED THE BANK")
end)

LordsUI:OnExitArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
    print(ply, "LEFT THE BANK")
end)

LordsUI:WhileInArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
    print(ply, "IS IN THE BANK")
end)

LordsUI:WhileNotInArea(pos1, pos2, function(ply, cornerOne, cornerTwo)
    print(ply, "IS NOT IN THE BANK")
end)
--]]
