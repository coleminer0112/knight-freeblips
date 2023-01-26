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
        Wait(50)
        local playerList = GetPlayers()
        for _,id in pairs(playerList) do


        end


        if displayblip then
            if not DoesBlipExist(blip) then -- Con questo aggiungo i blip sulla testa dei giocatori.
                blip = AddBlipForEntity(ped)
                SetBlipSprite(blip, 1) -- imposto il blip sulla posizione "blip" con l'id 1
                ShowHeadingIndicatorOnBlip(blip, true) -- Aggiunge effettivamente il blip
            else -- se il blip esiste, allora lo aggiorno
                veh = GetVehiclePedIsIn(ped, false) -- questo lo uso per aggiornare ogni volta il veicolo su cui il ped è salito
                blipSprite = GetBlipSprite(blip)
                if not GetEntityHealth(ped) then -- controllo se il giocatore è morto o no
                    if blipSprite ~= 274 then
                        SetBlipSprite(blip, 274)
                        ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                    end
                elseif veh then -- controllo se il giocatore è su un veicolo.
                    calsseVeicolo = GetVehicleClass(veh)
                    modelloVeicolo = GetEntityModel(veh)
                    if calsseVeicolo == 15 then -- La classe 15 indica un veicolo volante
                        if blipSprite ~= 422 then -- controllo se il blip non è il 422, ovvero l'aereo
                            SetBlipSprite(blip, 422) -- se true lo imposto.
                            ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                        end
                    elseif calsseVeicolo == 16 then -- controllo se il ped sta su un aereo
                        if modelloVeicolo == GetHashKey("besra") or modelloVeicolo == GetHashKey("hydra") or modelloVeicolo == GetHashKey("lazer") then -- controllo se il modello è un jet militare
                            if blipSprite ~= 424 then
                                SetBlipSprite(blip, 424)
                                ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                            end
                        elseif blipSprite ~= 423 then
                            SetBlipSprite(blip, 423)
                            ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                        end
                    elseif calsseVeicolo == 14 then -- boat
                        if blipSprite ~= 427 then
                            SetBlipSprite(blip, 427)
                            ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                        end
                    elseif modelloVeicolo == GetHashKey("insurgent") or modelloVeicolo == GetHashKey("insurgent2") or modelloVeicolo == GetHashKey("limo2") then
                            if blipSprite ~= 426 then
                                SetBlipSprite(blip, 426)
                                ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                            end
                        elseif modelloVeicolo == GetHashKey("rhino") then -- tank
                            if blipSprite ~= 421 then
                                SetBlipSprite(blip, 421)
                                ShowHeadingIndicatorOnBlip(blip, false) -- Aggiunge effettivamente il blip
                            end
                        elseif blipSprite ~= 1 then -- default blip
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true) -- Aggiunge effettivamente il blip
                        end
                        -- Show number in case of passangers
                        passengers = GetVehicleNumberOfPassengers(veh)
                        if passengers then
                            if not IsVehicleSeatFree(veh, -1) then
                                passengers = passengers + 1
                            end
                            ShowNumberOnBlip(blip, passengers)
                        else
                            HideNumberOnBlip(blip)
                        end
                    else
                        -- Se nessuno degli else per le auto viene verificato, allora setto il blip normale.
                        HideNumberOnBlip(blip)
                        if blipSprite ~= 1 then -- il blip default è 1
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true) -- Aggiunge effettivamente il blip
                        end
                    end
                    SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) -- con questo aggiorno la rotazione a seconda del veicolo
                    SetBlipNameToPlayerName(blip, i) -- aggirono il blip del giocatore
                    SetBlipScale(blip, 0.85) -- dimensione
                    -- se il menù con la mappa grande è aperto, allora setto il blip con un alpha massimo
                    -- con questo poi controllo la distanza dal giocatore per il nome sulla testa
                    if IsPauseMenuActive() then
                        SetBlipAlpha(blip, 255)
                    else -- se la prima non è confermata
                        x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true)) -- non ho messo la z perché non mi serve
                        x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(i), true)) -- uguale qua sotto
                        distanza = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                        -- lo ho fatto così perché si....
                        if distanza < 0 then
                            distanza = 0
                        elseif distanza > 255 then
                            distanza = 255
                        end
                        SetBlipAlpha(blip, distanza)
                    end
                end
            else
                RemoveBlip(blip)
            end
        end
    end
end)