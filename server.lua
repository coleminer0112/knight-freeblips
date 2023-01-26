KnightDutyInUse = (GetResourceState('knight-duty') == "started")

BLIPS = {}

function updateBlips(tbl)
    BLIPS = tbl
end

function permCheck(id)
    local id1 = tostring(id)
    local id2 = tonumber(id)

    if (id2 == 0) or (id2 == -1) then
        print("Console cannot run this command.")
        return false
    end

    if config.permtype == 0 then
        if IsPlayerAceAllowed(id, config.aceperm) then
            return true
        end
    end

    if config.permtype == 1 then
        local unit = exports['knight-duty']:GetUnitInfo(id)
        if unit and (string.upper(unit.dept) == string.upper(config.department)) then
            return true
        end
    end
    return false
end

local hasBlips = {}
local hasNames = {}

RegisterCommand('toggleblips', function(source,args,raw)
    if permCheck(source) then
        if not hasBlips[source] then
            hasBlips[source] = true
            TriggerClientEvent('displayBlips', source, true)
        else
            hasBlips[source] = false
            TriggerClientEvent('displayBlips', source)
        end
    end
end)


RegisterCommand('togglenames', function(source,args,raw)
    if permCheck(source) then
        TriggerClientEvent('displayNames', source)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(config.bliprefreshtime or 50)
        local playerList = GetPlayers()
        for _,id in pairs(playerList) do
            local ped = GetPlayerPed(id)
            local hdg = (ped ~= 0) and GetEntityHeading(ped) or 0
            local coords = (ped ~= 0) and GetEntityCoords(ped) or vector3(0.0,0.0,0.0)
            local name = GetPlayerName(id)

        end
    end
end)