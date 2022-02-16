if IsVehicleVisible(GetVehiclePedIsIn(GetPlayerPed())) then
    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
    PolarisLog(source, "Invisible","basic")
end

if IsPlayerUsingSuperJump(GetPlayerPed()) then
    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
    PolarisLog(source, "SuperJump","basic")
end

if Polaris.AntiVDM then
Citizen.CreateThread(function()
        while true do
            N_0x4757f00bc6323cfe(-1553120962, 0.0) 
            Wait(0)
        end
    end)
end

if Polaris.TeleportKick then
    if playercoords.x > 0 or playercoords.x < 0) then
        newplayercoords = GetEntityCoords(GetPlayerPed()
        if died then
            playercoords = newplayercoords
            died = false
        else
            if not IsPedInAnyVehicle(GetPlayerPed() and not IsPedOnVehicle(GetPlayerPed() and not IsPlayerRidingTrain(PlayerId())) then
                --print(GetDistanceBetweenCoords(playercoords.x, playercoords.y, playercoords.z, newplayercoords.x, newplayercoords.y, newplayercoords.z, 0))
                if (GetDistanceBetweenCoords(playercoords.x, playercoords.y, playercoords.z, newplayercoords.x, newplayercoords.y, newplayercoords.z, 0) > 0.5) then
                    DropPlayer(source, "💙 Teleporting is disabled on this server")
                    PolarisLog(source, "Tried teleport","basic")
                end
            end
            playercoords = newplayercoords
        end
    end
end

NextKeep = function()
    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
    PolarisLog(source, "Menu Injection (NextGenMenu)","basic")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        for v, r in ipairs(Polaris.BlacklistedWeapons) do
            Wait(1)
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(r), false) == 1 then
                RemoveAllPedWeapons(PlayerPedId(), true)
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Blacklisted Weapon","basic")
            end
        end
    end)
end

if Polaris.DamageModifierDetection then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            local Weapon = GetPlayerWeaponDamageModifier(PlayerId())
            local Vehicle = GetPlayerVehicleDamageModifier(PlayerId())
            local Defence2 = GetPlayerWeaponDefenseModifier_2(PlayerId())
            local Defence = GetPlayerWeaponDefenseModifier(PlayerId())
            local VehicleDefense = GetPlayerVehicleDefenseModifier(PlayerId())
            local Meele = GetPlayerMeleeWeaponDefenseModifier(PlayerId())
            if Weapon > 1 and Weapon ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            elseif Defence > 1 and Defence ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            elseif Defence2 > 1 and Defence ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            elseif Vehicle > 1 and Vehicle ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            elseif VehicleDefense > 1 and VehicleDefense ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            elseif Meele > 1 and VehicleDefense ~= 0 then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Damage Modifier","basic")
            end
        end
    end)
end

if Polaris.DumpDetection then
    RegisterNUICallback("loadNuis", function(data, cb)
        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
        PolarisLog(source, "Dump","basic")
    end)
end

if Polaris.InvisibilityDetection then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            SetEntityVisible(GetPlayerPed(-1), true, 0)
         end
    end)
end

if Polaris.SpectateDetection then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if NetworkIsInSpectatorMode() then
                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)
                PolarisLog(source, "Spectate","basic")
            end
        end
    end)
end

if Polaris.PickupDetection then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            RemoveAllPickupsOfType(GetHashKey("PICKUP_ARMOUR_STANDARD"))
            RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_ARMOUR_STANDARD"))
            RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_SNACK"))
            RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_STANDARD"))
            RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD"))
            RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW"))
        end
    end)
end