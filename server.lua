ESX = nil
MySQL = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Einreise:getGroup', function(src, cb)

    local xPlayer = ESX.GetPlayerFromId(src)
    cb(xPlayer.getGroup())
end)

ESX.RegisterServerCallback('Einreise:getEinreise', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    local einreise = MySQL.Sync.fetchScalar("SELECT einreise FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    })
   cb(einreise)
end)

RegisterNetEvent('Einreise:SendToRelease')
AddEventHandler('Einreise:SendToRelease', function(player)

    local xPlayer = ESX.GetPlayerFromId(player)
    if xPlayer ~= nil then
        TriggerClientEvent('Einreise:goToRelease', xPlayer.source, player)

        MySQL.Async.execute('UPDATE users SET einreise = 1 WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
          })

    end
end)
