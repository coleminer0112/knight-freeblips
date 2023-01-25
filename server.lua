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


RegisterCommand('toggleblips', function(source,args,raw)
    if permCheck(source) then
        TriggerClientEvent('displayBlips', source)
    end
end)


RegisterCommand('togglenames', function(source,args,raw)
    if permCheck(source) then
        TriggerClientEvent('displayNames', source)
    end
end)
