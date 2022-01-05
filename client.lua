ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local detected = false
local playerLoaded = false

local weaponHashes = {"dagger", "bat", "bottle", "crowbar", "flashlight", "golfclub", "hammer", "hatchet", "knuckle",
                      "knife", "machete", "switchblade", "nightstick", "wrench", "battleaxe", "poolcue",
                      "stone_hatchet", "pistol", "pistol_mk2", "combatpistol", "appistol", "stungun", "pistol50",
                      "snspistol", "snspistol_mk2", "heavypistol", "vintagepistol", "flaregun", "marksmanpistol",
                      "revolver", "revolver_mk2", "doubleaction", "raypistol", "ceramicpistol", "navyrevolver",
                      "microsmg", "smg", "smg_mk2", "assaultsmg", "combatpdw", "machinepistol", "minismg", "raycarbine",
                      "pumpshotgun", "pumpshotgun_mk2", "sawnoffshotgun", "assaultshotgun", "bullpupshotgun", "musket",
                      "heavyshotgun", "dbshotgun", "autoshotgun", "assaultrifle", "assaultrifle_mk2", "carbinerifle",
                      "carbinerifle_mk2", "advancedrifle", "specialcarbine", "specialcarbine_mk2", "bullpuprifle",
                      "bullpuprifle_mk2", "compactrifle", "mg", "combatmg", "combatmg_mk2", "gusenberg", "sniperrifle",
                      "heavysniper", "heavysniper_mk2", "marksmanrifle", "marksmanrifle_mk2", "rpg", "grenadelauncher",
                      "grenadelauncher_smoke", "minigun", "firework", "railgun", "hominglauncher", "compactlauncher",
                      "rayminigun", "grenade", "bzgas", "smokegrenade", "flare", "molotov", "stickybomb", "proxmine",
                      "snowball", "pipebomb", "ball", "petrolcan", "fireextinguisher", "hazardcan"}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerServerEvent("sky_antiweaponhack:checkBan", playerData)
    playerLoaded = true
end)

Citizen.CreateThread(function()
    while true do
        if not detected then
            if playerLoaded then
                ESX.TriggerServerCallback("sky_antiweaponhack:getCleanWeapons", function(cleanWeapons)
                    for k, v in ipairs(weaponHashes) do
                        if HasPedGotWeapon(PlayerPedId(), GetHashKey("weapon_" .. v)) then
                            local found = false
                            for l, m in ipairs(cleanWeapons) do
                                if GetHashKey(m.name) == GetHashKey("weapon_" .. v) then
                                    found = true
                                end
                            end
                            if not found then
                                detected = true
                                TriggerServerEvent("sky_antiweaponhack:hackedWeaponDetected")
                            end
                        end
                    end
                end)
            end
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        DisablePlayerVehicleRewards(PlayerId())
        Citizen.Wait(0)
    end
end)
