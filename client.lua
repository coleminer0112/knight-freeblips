local radarEsteso = false
local displayblip = false
local displaynames = false


RegisterNetEvent('displayBlips')
AddEventHandler('displayBlips', function()
    displayblip = not displayblip
    if displayblip then
        displayblip = true
        -- notifica blips enabled
        TriggerEvent('chatMessage', 'Blips', {0, 255, 0}, "enabled.")
    else
        displayblip = false
        -- notifica blips disabled
        TriggerEvent('chatMessage', 'Blips', {255, 0, 0}, "disabled.")
    end
end)


RegisterNetEvent('displayNames')
AddEventHandler('displayNames', function()
    displaynames = not displaynames
    if displaynames then
        displaynames = true
        -- notifica blips enabled
        TriggerEvent('chatMessage', 'Names', {0, 255, 0}, "enabled.")
    else
        displaynames = false
        -- notifica blips disabled
        TriggerEvent('chatMessage', 'Names', {255, 0, 0}, "disabled.")
    end
end)


Citizen.CreateThread(function()
    while true do
    Wait(1)
    -- controllo del giocatore, se esiste e ha un id.
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
            ped = GetPlayerPed(i)
            blip = GetBlipFromEntity(ped)
            -- Crea il nome sulla testa del giocatore
            idOverhead = CreateFakeMpGamerTag(ped, GetPlayerName(i), false, false, "", false)

            if displaynames then
                SetMpGamerTagVisibility(idOverhead, 0, true) -- Aggiunge il nome de giocatore sulla testa
                -- display se il giocatore sta parlando.
                if NetworkIsPlayerTalking(i) then
                    SetMpGamerTagVisibility(idOverhead, 9, true)
                else
                    SetMpGamerTagVisibility(idOverhead, 9, false)
                end
            else -- Rimuove tutti i blip se displaynames = false
                SetMpGamerTagVisibility(idOverhead, 9, false)
                SetMpGamerTagVisibility(idOverhead, 0, false)
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
    end
end)
