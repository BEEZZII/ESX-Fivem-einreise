ESX = nil
local playerPed = PlayerPedId()
einr = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local EinreiseCoords = {
    x = Config.EinreiseCoordsX,
    y = Config.EinreiseCoordsY,
    z = Config.EinreiseCoordsZ,
    rot = 0
}

local releaseCoords = {
    x = Config.ReleaseCoordsX,
    y = Config.ReleaseCoordsY,
    z = Config.ReleaseCoordsZ,
    rot = 0
}

RegisterCommand(Config.Einreise, function(source, args, rawCommand)
    ESX.TriggerServerCallback('Einreise:getGroup', function(group)
        if group == 'admin' or group == 'mod' or group == 'Superadmin' or group == 'pl' then

            local player = tonumber(args[1])

            TriggerServerEvent('Einreise:SendToRelease', player)
        else
            ShowNotification(Config.NoPermissions)
        end
        
    end)
end)

RegisterCommand(Config.Work, function(source, args, rawCommand)
    ESX.TriggerServerCallback('Einreise:getGroup', function(group)
        if group == 'admin' or group == 'mod' or group == 'Superadmin' or group == 'pl' then

            local player = tonumber(args[1])
            SetEntityCoords(playerPed, EinreiseCoords.x, EinreiseCoords.y, EinreiseCoords.z, EinreiseCoords.rot)
        else
            ShowNotification(Config.NoPermissions)
        end
        
    end)
end)

RegisterNetEvent('Einreise:goToRelease')
AddEventHandler('Einreise:goToRelease', function(player)
    SetEntityCoords(playerPed, releaseCoords.x, releaseCoords.y, releaseCoords.z)
    ShowNotification(Config.Einreisebestanden)
end)



Citizen.CreateThread(function()
    while einr == 0 or einr == nil do
        Citizen.Wait(10000)
        ESX.TriggerServerCallback('Einreise:getEinreise', function(einreise)
            einr = einreise

            if playerPed == playerPed then
                local playerCoord = GetEntityCoords(playerPed, false)
                if einreise == 0 then
                    if Vdist(playerCoord, vector3(EinreiseCoords.x, EinreiseCoords.y, EinreiseCoords.z)) > Config.Range * 1.12 then
                        SetEntityCoords(playerPed, EinreiseCoords.x, EinreiseCoords.y, EinreiseCoords.z, EinreiseCoords.rot)
                        ShowNotification(Config.EinreiseVerlassen)
                    end
                end
            end
        end)
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end