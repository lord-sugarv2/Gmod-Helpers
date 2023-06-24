/*

This module allows you to monitor when players are in/out an area or when they enter/exit

Examples are:
LordsUI:IsInArea(ply, cornerOne, cornerTwo) -- Check wether they are in a box

-- Called when a player has entered an area
-- Will not be called if the area is joined and you are already in it 
LordsUI:OnEnterArea(cornerOne, cornerTwo, function(ply, cornerOne, cornerTwo)
    print(ply:Nick(), "entered the area")
end, mainID)

-- Called when a player leaves an area
-- If this is joined it will be called on the area you left last 
LordsUI:OnExitArea(cornerOne, cornerTwo, function(ply, cornerOne, cornerTwo)
    print(ply:Nick(), "left the area")
end, mainID)

-- Is called while you are in an area
function LordsUI:WhileInArea(cornerOne, cornerTwo, function(ply, cornerOne, cornerTwo)
    print(ply:Nick(), "is in the area")
end, mainID)

-- Is called while you are not in an area
LordsUI:WhileNotInArea(cornerOne, cornerTwo, function(ply, cornerOne, cornerTwo)
    print(ply:Nick(), "is not in the area")
end, mainID)

LordsUI:JoinAreas(mainIDOne, mainIDOneTwo) -- Join two areas so they act like one (make sure the areas overlap to actually use the feature properly)

LordsUI:PlayersWithinDistance(pos, dist) -- check if a player is within a distance

*/

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

function LordsUI:IsInID(ply, id)
    for _, data in ipairs(LordsUI.Areas) do
        if data.mainID ~= id then continue end
        return LordsUI:IsInArea(ply, data.cornerOne, data.cornerTwo)
    end
end

function LordsUI:GetIDData(ply, id)
    for _, data in ipairs(LordsUI.Areas) do
        if data.mainID ~= id then continue end
        return data
    end
end

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

function LordsUI:JoinAreas(idOne, idTwo)
    local areaOne = 0
    local areaTwo = 0
    for k, v in ipairs(LordsUI.Areas) do
        if v.mainID == idOne then
            areaOne = k
        end
    
        if v.mainID == idTwo then
            areaTwo = k
        end
    end

    if areaOne == 0 or areaTwo == 0 then return end
    LordsUI.Areas[areaOne].Joined = idTwo
    LordsUI.Areas[areaTwo].Joined = idOne
end

local function InArea(ply, data)
    if data.type == "OnEnter" and not LordsUI.Players[ply][data.id] then
        if data.Joined and LordsUI:IsInID(ply, data.Joined) then
            LordsUI.Players[ply][data.id] = true
            return
        end
    
        data.func(ply, data.cornerOne, data.cornerTwo)
        LordsUI.Players[ply][data.id] = true
    end

    if data.type == "WhileIn" then
        data.func(ply, data.cornerOne, data.cornerTwo)
    end
end

local function NotInArea(ply, data)
    if data.Joined and LordsUI:IsInID(ply, data.Joined) then
        return
    end

    if data.type == "OnExit" and LordsUI.Players[ply][data.id] then
        data.func(ply, data.cornerOne, data.cornerTwo)
        LordsUI.Players[ply][data.id] = false
        if data.Joined then
            LordsUI.Players[ply][LordsUI:GetIDData(ply, data.Joined).id] = false
        end
    end

    if data.type == "WhileNotIn" and not LordsUI.Players[ply][data.id] then
        data.func(ply, data.cornerOne, data.cornerTwo)
    end
end

hook.Add("Think", "LordsUI:Areas", function()
    for _, data in ipairs(LordsUI.Areas) do
        for _, ply in ipairs(player.GetAll()) do
            LordsUI.Players[ply] = LordsUI.Players[ply] or {}
            if LordsUI:IsInArea(ply, data.cornerOne, data.cornerTwo) and ply:Alive() then
                InArea(ply, data)
            else
                NotInArea(ply, data)
            end
        end
    end
end)

function LordsUI:PlayersWithinDistance(pos, dist)
    local distSqr = dist * dist
    local tbl = {}
    for k, ply in ipairs(player.GetAll()) do
        if ply:GetPos():DistToSqr(pos) > distSqr then continue end
        table.insert(tbl, ply)
    end
	return tbl
end

hook.Run("LordsUI:AreasLoaded")
