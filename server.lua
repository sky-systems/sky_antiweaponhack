ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local dcWebhook =
    "https://discord.com/api/webhooks/919536841101824052/TZEDdACjimGAi56KitBVZUsEB1B9pERaceLkM242egNwtBuApBhPwyNupyCyjmuvD8Z6"

ESX.RegisterServerCallback("sky_antiweaponhack:getCleanWeapons", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getLoadout())
end)

RegisterServerEvent("sky_antiweaponhack:hackedWeaponDetected")
AddEventHandler("sky_antiweaponhack:hackedWeaponDetected", function(weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    discordLog("Hacked weapon detected",
        xPlayer.getName() .. " has cheated a weapon\nIdentifier: " .. xPlayer.getIdentifier())
    MySQL.Async.execute("UPDATE users SET antiweaphackban = 1 WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.getIdentifier()
    })
    DropPlayer(_source, "sky_antiweaponhack: You were banned because of a cheated weapon")
end)

RegisterServerEvent("sky_antiweaponhack:checkBan")
AddEventHandler("sky_antiweaponhack:checkBan", function(playerData)
    local _source = source
    local xPlayer = playerData
    MySQL.Async.fetchAll("SELECT antiweaphackban FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        if result[1].antiweaphackban then
            DropPlayer(_source, "sky_antiweaponhack: You are banned because of a cheated weapon")    
        end
    end)
end)

function discordLog(title, message)
    PerformHttpRequest(dcWebhook, function(err, text, headers)
    end, 'POST', json.encode({
        username = "Sky-Systems",
        embeds = {{
            ["title"] = title,
            ["color"] = tonumber(0x00afd6),
            ["description"] = "" .. message .. "",
            ["footer"] = {
                ["text"] = "Sky-Systems - " .. os.date("%x %X %p"),
                ["icon_url"] = "https://cdn.discordapp.com/icons/866631884465373214/9eeb394f36d101b6281d4c64cc8609a4.webp?size=300"
            }
        }},
        avatar_url = "https://cdn.discordapp.com/icons/866631884465373214/9eeb394f36d101b6281d4c64cc8609a4.webp?size=300"
    }), {
        ['Content-Type'] = 'application/json'
    })
end
