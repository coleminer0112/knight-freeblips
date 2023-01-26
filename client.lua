local radarEsteso = false
local displayblip = false
local displaynames = false


RegisterNetEvent('displayBlips')
AddEventHandler('displayBlips', function(setting)
    displayblip = not displayblip
    if setting then
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
AddEventHandler('displayNames', function(setting)
    displaynames = not displaynames
    if setting then
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
            end
        end
    end
end)
