ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_Mafia:checkmafiaxp', function(source, cb)
    MySQL.Async.fetchAll("SELECT criminalxp FROM xpsystem WHERE identifier=@identifier",{['@identifier'] = GetPlayerIdentifiers(source)[1]}, function(data)  
    if data[1].criminalxp >= .CriminalXPNeededToCreateMafia then
        cb(true)
    else 
        cb(false)
    end
end)
end)

ESX.RegisterServerCallback('esx_Mafia:isaboss', function(source, cb)
    MySQL.Async.fetchAll("SELECT isboss FROM createmafia WHERE identifier=@identifier",{['@identifier'] = GetPlayerIdentifiers(source)[1]}, function(data)  
    if data[1].isboss == 1 then
        cb(true)
    elseif data[1].isboss == 0 then
        cb(false)
    end
end)
end)

RegisterCommand('testmafia', function(source)
    MySQL.Async.fetchAll("SELECT bossrole FROM createmafia WHERE bossrole = @bossrole",{['@bossrole'] = "BallassBoss"}, function(data)
        print(data[1])
    end)
end)


AddEventHandler('playerConnecting', function()
    local name = GetPlayerName(source)
    print('^2User: ^1'..GetPlayerIdentifier(source)..' ^2Has Created')
    MySQL.Async.execute('INSERT INTO createmafia (`identifier`, `jobname`, `isboss`) VALUES (@identifier, @jobname, @isboss);', {
        jobname        = "NO MAFIA",
        isboss  = 0,
        identifier = GetPlayerIdentifier(source)
    }, function(rowsChanged)
    end)
    MySQL.Async.execute('UPDATE createmafia SET player_name = @name WHERE identifier = @identifier', {
        ['@name']        = name,
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(rowsChanged)
    end)
end)

RegisterServerEvent('esx:CreateMafiaUser')
AddEventHandler('esx:CreateMafiaUser', function(v,u,k)
    print('Player: '..GetPlayerIdentifier(source)..' Has Created A '..v)
    MySQL.Async.execute('UPDATE createmafia SET jobname = @job, isboss = @isboss, bossrole = @bossrole WHERE identifier = @identifier', {
        ['@job']        = v,
        ['@isboss']  = u,
        ['@bossrole'] = k,
        ['@identifier'] = GetPlayerIdentifier(source)
    }, function(rowsChanged)
    end)
end)

ESX.RegisterServerCallback('esx_CreateMafia:showmafiamambers', function(source, cb)
    MySQL.Async.fetchAll("SELECT jobname FROM createmafia WHERE identifier=@identifier",{['@identifier'] = GetPlayerIdentifiers(source)[1]}, function(data)  
    MySQL.Async.fetchAll('SELECT identifier FROM users WHERE jobname = @job', {
        ['@job'] = data[1].jobname
    }, function (results)
        local employees = {}

        for i=1, #results, 1 do
            table.insert(employees, {
                identifier = results[i].identifier
            })
        end

        cb(employees)
    end)
end)
end)

RegisterServerEvent('esx:CreateSetJob')
AddEventHandler('esx:CreateSetJob', function(v,u,k)
    MySQL.Async.execute('UPDATE createmafia SET jobname = @job, isboss = @isboss WHERE identifier = @identifier', {
        ['@job']        = v,
        ['@isboss']  = u,
        ['@identifier'] = k
    }, function(rowsChanged)
    end)
end)

RegisterServerEvent('esx:CreateMafia')
AddEventHandler('esx:CreateMafia', function(k,v,i)
    MySQL.Async.execute('INSERT INTO createmafiamafias (`mafianame`, `type`, `mafialevel`, `boss`) VALUES (@mafianame, @type, @mafialevel, @boss);', {
        mafianame        = k,
        type  = v,
        mafialevel = 0,
        boss = GetPlayerIdentifier(source)
    }, function(rowsChanged)
    end)
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end