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

LordsUI.Areas = LordsUI.Areas or {}
LordsUI.Players = LordsUI.Players or {}

function LordsUI:OnEnterArea(cornerOne, cornerTwo, func, mainID)
    func = func or function() end
    mainID = mainID or math.random(1, 999999)

    for k, v in ipairs(LordsUI.Areas) do
        if v.mainID == mainID then
            table.remove(LordsUI.Areas, k)
            break
        end
    end

    table.Add(LordsUI.Areas, {{
        mainID = mainID,
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "OnEnter",
        func = func,
    }})
end

function LordsUI:OnExitArea(cornerOne, cornerTwo, func, mainID)
    func = func or function() end
    mainID = mainID or math.random(1, 999999)

    for k, v in ipairs(LordsUI.Areas) do
        if v.mainID == mainID then
            table.remove(LordsUI.Areas, k)
            break
        end
    end

    table.Add(LordsUI.Areas, {{
        mainID = mainID,
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "OnExit",
        func = func,
    }})
end

function LordsUI:WhileInArea(cornerOne, cornerTwo, func, mainID)
    func = func or function() end
    mainID = mainID or math.random(1, 999999)

    for k, v in ipairs(LordsUI.Areas) do
        if v.mainID == mainID then
            table.remove(LordsUI.Areas, k)
            break
        end
    end

    table.Add(LordsUI.Areas, {{
        mainID = mainID,
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "WhileIn",
        func = func,
    }})
end

function LordsUI:WhileNotInArea(cornerOne, cornerTwo, func, mainID)
    func = func or function() end
    mainID = mainID or math.random(1, 999999)

    for k, v in ipairs(LordsUI.Areas) do
        if v.mainID == mainID then
            table.remove(LordsUI.Areas, k)
            break
        end
    end

    table.Add(LordsUI.Areas, {{
        mainID = mainID,
        id = tostring(cornerOne + cornerTwo),
        cornerOne = cornerOne,
        cornerTwo = cornerTwo,
        type = "WhileNotIn",
        func = func,
    }})
end

local function InArea(ply, data)
    if data.type == "OnEnter" and not LordsUI.Players[ply][data.id] then
        data.func(ply, data.cornerOne, data.cornerTwo)
        LordsUI.Players[ply][data.id] = true
    end

    if data.type == "WhileIn" then
        data.func(ply, data.cornerOne, data.cornerTwo)
    end
end

local function NotInArea(ply, data)
    if data.type == "OnExit" and LordsUI.Players[ply][data.id] then
        data.func(ply, data.cornerOne, data.cornerTwo)
        LordsUI.Players[ply][data.id] = false
    end

    if data.type == "WhileNotIn" and not LordsUI.Players[ply][data.id] then
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
