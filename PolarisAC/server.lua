--local Text               = {}

local BanList            = {}

local BanListLoad        = false

CreateThread(function()

        while true do

                Wait(1000)

        if BanListLoad == false then

                        loadBanList()

                        if BanList ~= {} then

                                --print(Text.banlistloaded)

                                BanListLoad = true

                        else

                                --print(Text.starterror)

                        end

                end

        end

end)





CreateThread(function()

        while true do

                Wait(600000)

        if BanListLoad == true then

                        loadBanList()

                end

        end

end)



RegisterServerEvent('aopkfgebjzhfpazf77')

AddEventHandler('aopkfgebjzhfpazf77', function(reason,servertarget)

        local license,identifier,liveid,xblid,discord,playerip,target

        local duree     = 1

        local reason    = reason



        if not reason then reason = "Auto Anti-Cheat" end



        if tostring(source) == "" then

                target = tonumber(servertarget)

        else

                target = source

        end



        if target and target > 1 then

                local ping = GetPlayerPing(target)



                if ping and ping > 1 then

                        if duree and duree < 365 then

                                local sourceplayername = "PolarisAC"

                                local targetplayername = GetPlayerName(target)

                                        for k,v in ipairs(GetPlayerIdentifiers(target))do

                                                if string.sub(v, 1, string.len("license:")) == "license:" then

                                                        license = v

                                                elseif string.sub(v, 1, string.len("steam:")) == "steam:" then

                                                        identifier = v

                                                elseif string.sub(v, 1, string.len("live:")) == "live:" then

                                                        liveid = v

                                                elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then

                                                        xblid  = v

                                                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then

                                                        discord = v

                                                elseif string.sub(v, 1, string.len("ip:")) == "ip:" then

                                                        playerip = v

                                                end

                                        end



                                if duree > 1 then

                                        ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1)

                                        DropPlayer(target, "〈💙〉 Cracked Polaris: ".. Polaris.BanReason .. " https://github.com/0x98a")

                                else

                                        ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1)

                                        DropPlayer(target, "〈💙〉 Cracked Polaris: ".. Polaris.BanReason .. " https://github.com/0x98a")


                                end



                        else

                                --print("BanSql Error : Auto-Cheat-Ban time invalid.")

                        end

                else

                        --print("BanSql Error : Auto-Cheat-Ban target are not online.")

                end

        else

                --print("BanSql Error : Auto-Cheat-Ban have recive invalid id.")

        end

end)



AddEventHandler('playerConnecting', function (playerName,setKickReason)

        local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"



        for k,v in ipairs(GetPlayerIdentifiers(source)) do

                if string.sub(v, 1, string.len("license:")) == "license:" then

                        license = v

                elseif string.sub(v, 1, string.len("steam:")) == "steam:" then

                        steamID = v

                elseif string.sub(v, 1, string.len("live:")) == "live:" then

                        liveid = v

                elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then

                        xblid  = v

                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then

                        discord = v

                elseif string.sub(v, 1, string.len("ip:")) == "ip:" then

                        playerip = v

                end

        end



        if (Banlist == {}) then

                Citizen.Wait(1000)

        end





        for i = 1, #BanList, 1 do

                if

                          ((tostring(BanList[i].license)) == tostring(license)

                        or (tostring(BanList[i].identifier)) == tostring(steamID)

                        or (tostring(BanList[i].liveid)) == tostring(liveid)

                        or (tostring(BanList[i].xblid)) == tostring(xblid)

                        or (tostring(BanList[i].discord)) == tostring(discord)

                        or (tostring(BanList[i].playerip)) == tostring(playerip))

                then



                        if (tonumber(BanList[i].permanent)) == 1 then

                                setKickReason("〈💙〉 Cracked Polaris: ".. Polaris.BanReason .. " https://github.com/0x98a")


                CancelEvent()

                break

                        end

                end

        end

end)



function ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)

        local expiration = duree * 84000

        local timeat     = os.time()

        local added      = os.date()



        if expiration < os.time() then

                expiration = os.time()+expiration

        end



                table.insert(BanList, {

                        license    = license,

                        identifier = identifier,

                        liveid     = liveid,

                        xblid      = xblid,

                        discord    = discord,

                        playerip   = playerip,

                        reason     = reason,

                        expiration = expiration,

                        permanent  = permanent

          })



                MySQL.Async.execute(

                'INSERT INTO polaris_bans (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',

                {

                                ['@license']          = license,

                                ['@identifier']       = identifier,

                                ['@liveid']           = liveid,

                                ['@xblid']            = xblid,

                                ['@discord']          = discord,

                                ['@playerip']         = playerip,

                                ['@targetplayername'] = targetplayername,

                                ['@sourceplayername'] = sourceplayername,

                                ['@reason']           = reason,

                                ['@expiration']       = expiration,

                                ['@timeat']           = timeat,

                                ['@permanent']        = permanent,

                                },

                                function ()

                end)

                BanListHistoryLoad = true

end



function loadBanList()

        MySQL.Async.fetchAll(

                'SELECT * FROM polaris_bans',

                {},

                function (data)

                  BanList = {}



                  for i=1, #data, 1 do

                        table.insert(BanList, {

                                license    = data[i].license,

                                identifier = data[i].identifier,

                                liveid     = data[i].liveid,

                                xblid      = data[i].xblid,

                                discord    = data[i].discord,

                                playerip   = data[i].playerip,

                                reason     = data[i].reason,

                                expiration = data[i].expiration,

                                permanent  = data[i].permanent

                          })

                  end

    end)

end



RegisterCommand("unban", function(source, args, raw)

                cmdunban(source, args)

end)



function cmdunban(source, args)

    if args[1] then

        local target = table.concat(args, " ")

        MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', {

            ['@playername'] = ("%"..target.."%")

        }, function(data)

            if data[1] then

                if #data > 1 then

                else

                    MySQL.Async.execute('DELETE FROM banlist WHERE targetplayername = @name', {

                        ['@name']  = data[1].targetplayername

                    }, function ()

                        loadBanList()

                        TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', data[1].targetplayername.." was unban from PolarisAC" } } )

                    end)

                end

            else

            end

        end)

    else

    end

end



local validResourceList



local function collectValidResourceList()

	validResourceList = {}

	for i=0,GetNumResources()-1 do

    	validResourceList[GetResourceByFindIndex(i)] = true

  	end

end



collectValidResourceList()

AddEventHandler("onResourceListRefresh", collectValidResourceList)

RegisterNetEvent("Pl:CmR")

AddEventHandler("Pl:CmR", function(givenList)

  for _, resource in ipairs(givenList) do

    if not validResourceList[resource] then

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Tried to inject a resource that is not listed","basic")

      break

    end

  end

end)



AddEventHandler("RemoveAllPedWeaponsEvent", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Remove Weapon","basic")

end)



AddEventHandler("RemoveAllPedWeaponsEvent", function(source, data)

    if data.ByType == false then

        CancelEvent()

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Remove Weapon","basic")

    end

end)



AddEventHandler("RemoveAllPedWeapons", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Remove Weapon","basic")

end)



AddEventHandler("ShootSingleBulletBetweenCoordsEvent", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Taze","basic")

end)



AddEventHandler("ShootSingleBulletBetweenEvent", function(source, data)

    if data.coords then

        CancelEvent()

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Taze","basic")

    end

end)



AddEventHandler("shootSingleBulletBetweenCoordsEvent", function(source, data)

    if data.givenAsPickup == false then

        CancelEvent()

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Taze","basic")

    end

end)



AddEventHandler("ResetPlayerStamina", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Stamina Reset","basic")

end)



AddEventHandler("SetSuperJumpThisFrame", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "SuperJump","basic")

end)



AddEventHandler("AddAmmoToPed", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Add Ammo","basic")

end)



AddEventHandler("AddAmmoToPedEvent", function(source, data)

    if data.ByType then

        CancelEvent()

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Add Ammo","basic")

    end

end)



AddEventHandler("AddAmmoToPedEvent", function(source, data)

    if data.ByType == false then

        CancelEvent()

        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

        PolarisLog(source, "Add Ammo","basic")

    end

end)



AddEventHandler("ShootSingleBulletBetweenCoords", function(source)

    CancelEvent()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Taze","basic")

end)



local newestversion = "v6.0"

local versionac = Polaris.Version



function inTable(tbl, item)

    for key, value in pairs(tbl) do

        if value == item then return key end

    end

    return false

end



Citizen.CreateThread(function()

    logo()

    print("^1[PolarisAC] ^0Authenticating to PolarisAC.....")

    Wait(0)

    print("^7[PolarisAC] ^5Licensed to:^8 L CRACKED")

    if nullfieldcheck() then

        print("^8[PolarisAC] ^2Files Are Correct!^0")

    end

    ACStarted()

end)



function logo()

    print([[



    ^8    __        __         _                                   

    ^8    \ \      / /   ___  | |   ___    ___    _ __ ___     ___ 

    ^8     \ \ /\ / /   / _ \ | |  / __|  / _ \  | '_ ` _ \   / _ \

    ^8      \ V  V /   |  __/ | | | (__  | (_) | | | | | | | |  __/

    ^8       \_/\_/     \___| |_|  \___|  \___/  |_| |_| |_|  \___|

                                                                 



]])

end



function show()

    print([[

        ^8        _______ad88888888888888888888888a, 

        ^8________a88888"8888888888888888888888, 

        ^8______,8888"__"P88888888888888888888b, 

        ^8______d88_________`""P88888888888888888, 

        ^8_____,8888b_______________""88888888888888, 

        ^8_____d8P'''__,aa,______________""888888888b 

        ^8_____888bbdd888888ba,__,I_________"88888888, 

        ^8_____8888888888888888ba8"_________,88888888b 

        ^8____,888888888888888888b,________,8888888888 

        ^8____(88888888888888888888,______,88888888888, 

        ^8____d888888888888888888888,____,8___"8888888b 

        ^8____88888888888888888888888__.;8'"""__(888888 

        ^8____8888888888888I"8888888P_,8"_,aaa,__888888 

        ^8____888888888888I:8888888"_,8"__`b8d'__(88888 

        ^8____(8888888888I'888888P'_,8)__________88888 

        ^8_____88888888I"__8888P'__,8")__________88888 

        ^8_____8888888I'___888"___,8"_(._.)_______88888 

        ^8_____(8888I"_____"88,__,8"_____________,8888P 

        ^8______888I'_______"P8_,8"_____________,88888) 

        ^8_____(88I'__________",8"__M""""""M___,888888' 

        ^8____,8I"____________,8(____"aaaa"___,8888888 

        ^8___,8I'____________,888a___________,8888888) 

        ^8__,8I'____________,888888,_______,888888888 

        ^8_,8I'____________,8888888'`-===-'888888888' 

        ^8,8I'____________,8888888"________88888888" 

        ^88I'____________,8"____88_________"888888P 

        ^88I____________,8'_____88__________`P888" 

        ^88I___________,8I______88____________"8ba,. 

        ^8(8,_________,8P'______88______________88""8bma,. 

        ^8_8I________,8P'_______88,______________"8b___""P8ma, 

        ^8_(8,______,8d"________`88,_______________"8b_____`"8a 

        ^8__8I_____,8dP_________,8X8,________________"8b.____:8b 

        ^8__(8____,8dP'__,I____,8XXX8,________________`88,____8) 

        ^8___8,___8dP'__,I____,8XxxxX8,_____I,_________8X8,__,8 

        ^8___8I___8P'__,I____,8XxxxxxX8,_____I,________`8X88,I8 

        ^8___I8,__"___,I____,8XxxxxxxxX8b,____I,________8XXX88I, 

        ^8___`8I______I'__,8XxxxxxxxxxxxXX8____I________8XXxxXX8, 

        ^8____8I_____(8__,8XxxxxxxxxxxxxxxX8___I________8XxxxxxXX8, 

        ^8___,8I_____I[_,8XxxxxxxxxxxxxxxxxX8__8________8XxxxxxxxX8, 

        ^8___d8I,____I[_8XxxxxxxxxxxxxxxxxxX8b_8_______(8XxxxxxxxxX8, 

        ^8___888I____`8,8XxxxxxxxxxxxxxxxxxxX8_8,_____,8XxxxxxxxxxxX8 

        ^8___8888,____"88XxxxxxxxxxxxxxxxxxxX8)8I____.8XxxxxxxxxxxxX8 

        ^8__,8888I_____88XxxxxxxxxxxxxxxxxxxX8_`8,__,8XxxxxxxxxxxxX8" 

        ^8__d88888_____`8XXxxxxxxxxxxxxxxxxX8'__`8,,8XxxxxxxxxxxxX8" 

        ^8__888888I_____`8XXxxxxxxxxxxxxxxX8'____"88XxxxxxxxxxxxX8" 

        ^8__88888888bbaaaa88XXxxxxxxxxxxXX8)______)8XXxxxxxxxxXX8" 

        ^8__8888888I,_``""""""8888888888888888aaaaa8888XxxxxXX8" 

        ^8__(8888888I,______________________.__```"""""88888P" 

        ^8___88888888I,___________________,8I___8,_______I8" 

        ^8____"""88888I,________________,8I'____"I8,____;8" 

        ^8___________`8I,_____________,8I'_______`I8,___8) 

        ^8____________`8I,___________,8I'__________I8__:8' 

        ^8_____________`8I,_________,8I'___________I8__:8 

        ^8______________`8I_______,8I'_____________`8__(8 

        ^8_______________8I_____,8I'________________8__(8; 

        ^8_______________8I____,8"__________________I___88, 

        ^8______________.8I___,8'_______________________8"8, 

        ^8______________(PI___'8_______________________,8,`8, 

        ^8_____________.88'____________,@@___________.a8X8,`8, 

        ^8_____________(88_____________@@@_________,a8XX888,`8, 

        ^8____________(888_____________@@'_______,d8XX8"__"b_`8, 

        ^8___________.8888,_____________________a8XXX8"____"a_`8, 

        ^8__________.888X88___________________,d8XX8I"______9,_`8, 

        ^8_________.88:8XX8,_________________a8XxX8I'_______`8__`8, 

        ^8________.88'_8XxX8a_____________,ad8XxX8I'________,8___`8, 

        ^8________d8'__8XxxxX8ba,______,ad8XxxX8I"__________8__,__`8, 

        ^8_______(8I___8XxxxxxX888888888XxxxX8I"____________8__II__`8 

        ^8_______8I'___"8XxxxxxxxxxxxxxxxxxX8I'____________(8__8)___8; 

        ^8______(8I_____8XxxxxxxxxxxxxxxxxX8"______________(8__8)___8I 

        ^8______8P'_____(8XxxxxxxxxxxxxxX8I'________________8,_(8___:8 

        ^8_____(8'_______8XxxxxxxxxxxxxxX8'_________________`8,_8____8 

        ^8_____8I________`8XxxxxxxxxxxxX8'___________________`8,8___;8 

        ^8_____8'_________`8XxxxxxxxxxX8'_____________________`8I__,8' 

        ^8_____8___________`8XxxxxxxxX8'_______________________8'_,8' 

        ^8_____8____________`8XxxxxxX8'________________________8_,8' 

        ^8_____8_____________`8XxxxX8'________________________d'_8' 

        ^8_____8______________`8XxxX8_________________________8_8' 

        ^8_____8________________"8X8'_________________________"8" 

        ^8_____8,________________`88___________________________8 

        ^8_____8I________________,8'__________________________d) 

        ^8_____`8,_______________d8__________________________,8 

        ^8______(b_______________8'_________________________,8' 

        ^8_______8,_____________dP_________________________,8' 

        ^8_______(b_____________8'________________________,8' 

        ^8________8,___________d8________________________,8' 

        ^8________(b___________8'_______________________,8' 

        ^8_________8,_________a8_______________________,8' 

        ^8_________(b_________8'______________________,8' 

        ^8__________8,_______,8______________________,8' 

        ^8__________(b_______8'_____________________,8' 

        ^8___________8,_____,8_____________________,8' 

        ^8___________(b_____8'____________________,8' 

        ^8____________8,___d8____________________,8' 

        ^8____________(b__,8'___________________,8' 

        ^8_____________8,,I8___________________,8' 

        ^8_____________I8I8'__________________,8' 

        ^8_____________`I8I__________________,8' 

        ^8______________I8'_________________,8' 

        ^8______________"8_________________,8' 

        ^8______________(8________________,8' 

        ^8______________8I_______________,8' 

        ^8______________(b,___8,________,8) 

        ^8______________`8I___"88______,8i8, 

        ^8_______________(b,__________,8"8") 

        ^8_______________`8I__,8______8)_8_8 

        ^8________________8I__8I______"__8_8 

        ^8________________(b__8I_________8_8 

        ^8________________`8__(8,________b_8, 

        ^8_________________8___8)________"b"8, 

        ^8_________________8___8(_________"b"8 

        ^8_________________8___"I__________"b8, 

        ^8_________________8________________`8) 

        ^8_________________8_________________I8 

        ^8_________________8_________________(8 

        ^8_________________8,_________________8, 

        ^8_________________Ib_________________8) 

        ^8_________________(8_________________I8 

        ^8__________________8_________________I8 

        ^8__________________8_________________I8 

        ^8__________________8,________________I8 

        ^8__________________Ib________________8I 

        ^8__________________(8_______________(8' 

        ^8___________________8_______________I8 

        ^8___________________8,______________8I 

        ^8___________________Ib_____________(8' 

        ^8___________________(8_____________I8 

        ^8___________________`8_____________8I 

        ^8____________________8____________(8' 

        ^8____________________8,___________I8 

        ^8____________________Ib___________8I 

        ^8____________________(8___________8' 

        ^8_____________________8,_________(8 

        ^8_____________________Ib_________I8 

        ^8_____________________(8_________8I 

        ^8______________________8,________8' 

        ^8______________________(b_______(8 

        ^8_______________________8,______I8 

        ^8_______________________I8______I8 

        ^8_______________________(8______I8 

        ^8________________________8______I8, 

        ^8________________________8______8_8, 

        ^8________________________8,_____8_8' 

        ^8_______________________,I8_____"8" 

        ^8______________________,8"8,_____8, 

        ^8_____________________,8'_`8_____`b 

        ^8____________________,8'___8______8, 

        ^8___________________,8'____(a_____`b 

        ^8__________________,8'_____`8______8, 

        ^8__________________I8/______8______`b, 

        ^8__________________I8-/_____8_______`8, 

        ^8__________________(8/-/____8________`8, 

        ^8___________________8I/-/__,8_________`8 

        ^8___________________`8I/--,I8________-8) 

        ^8____________________`8I,,d8I_______-8) 

        ^8______________________"bdI"8,_____-I8 

        ^8___________________________`8,___-I8' 

        ^8____________________________`8,,--I8 

        ^8_____________________________`Ib,,I8 

        ^8______________________________`I8I^0

    ]])

end






function nullfieldcheck()

    if Polaris.LogWebhook == "" then

        print("^3[PolarisAC] ^7 ^4Polaris.LogWebhook ^7: ^1MISSING or is NULL ^7!")

        print("^3[PolarisAC] ^7 ^1Stopping Anticheat...")

        Wait(10000)

        os.exit()

    elseif Polaris.Version == "" or Polaris.Version == nil then

        print("^3[PolarisAC] ^7 ^4Polaris.Version ^7: ^1MISSING or is NULL ^7!")

        print("^3[PolarisAC] ^7 ^1Stopping Anticheat...")

        Wait(10000)

        os.exit()

    else

        return true

    end

end



--=====================================================--



if Polaris.EjerToolBan then

RegisterServerEvent('RunCode:RunStringRemotelly')

AddEventHandler('RunCode:RunStringRemotelly', function()

    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

    PolarisLog(source, "Ejer Tool","basic")

    CancelEvent()

    end)

end



--=====================================================--



if Polaris.AntiAdminAbuse then

    RegisterNetEvent('murtaza:fix')

    AddEventHandler('murtaza:fix', function()

        CancelEvent()

        DropPlayer(source, "💙 "..Polaris.AntiAdminAbuseKickMessage)

    end)

end



--=====================================================--



if Polaris.AntiAdminAbuse then

    RegisterNetEvent('fix')

    AddEventHandler('fix', function()

        CancelEvent()

        DropPlayer(source, "💙 "..Polaris.AntiAdminAbuseKickMessage)

    end)

end



--=====================================================--



if Polaris.AntiAdminAbuse then

    RegisterNetEvent('staff.revive')

    AddEventHandler('staff.revive', function()

        CancelEvent()

        DropPlayer(source, "💙 "..Polaris.AntiAdminAbuseKickMessage)

    end)

end



--=====================================================--



if Polaris.ForceDiscord then

local function OnPlayerConnecting(name, setKickReason, deferrals)

    local player = source

    local discordIdentifier

    local identifiers = GetPlayerIdentifiers(player)

    deferrals.defer()

  

    Wait(0)

  

    for _, v in pairs(identifiers) do

        if string.find(v, "discord") then

            discordIdentifier = v

            break

        end

    end

  

    Wait(0)

  

    if not discordIdentifier then

            deferrals.done("💙 " .. Polaris.ForceDiscordMessage)

                if Polaris.ForceDiscordConsoleLogs then

                    print("^6ForceDiscord^0 " .. name .. " ^3Rejected for not using discord.")

                end

        else

            deferrals.done()

        end

     end

end

  

  AddEventHandler("playerConnecting", OnPlayerConnecting)



--=====================================================--



if Polaris.ForceSteam then

local function OnPlayerConnecting(name, setKickReason, deferrals)

    local player = source

    local steamIdentifier

    local identifiers = GetPlayerIdentifiers(player)

    deferrals.defer()

  

    Wait(0)

  

    for _, v in pairs(identifiers) do

        if string.find(v, "steam") then

            steamIdentifier = v

            break

        end

    end

  

    Wait(0)

  

    if not steamIdentifier then

            deferrals.done("💙 " .. Polaris.ForceSteamMessage)

                if Polaris.ForceSteamConsoleLogs then

                    print("^9ForceSteam^0 " .. name .. " ^7Rejected for not using steam.")

                end

        else

            deferrals.done()

        end

     end

end

  

  AddEventHandler("playerConnecting", OnPlayerConnecting)



--=====================================================--



if Polaris.ClearPedTasksImmediatelyDetection then

    AddEventHandler("clearPedTasksEvent", function(source, data)

        if data.immediately then

            CancelEvent()

            TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

            PolarisLog(source, "ClearPedTasksImmediately","basic")

        end

    end)

end



--=====================================================--



if Polaris.LicenseOwner == "CRACKED" or Polaris.LicenseOwner == "CHANGE ME" then

    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")
    print("^5Polaris.LicenseOwner ^8was cracked because the kid used bytecode for his protection!")

end



--=====================================================--








function AuthLog(Webhook, Message)

    local Content = {

        {

            ["author"] = {

                ["name"] = "PolarisAC",

                                -- ["url"] = "",

                                ["icon_url"] = "https://i.gyazo.com/af35b463c2d750e8798443cb8944261e.png"

            },

            ["color"] = "16711680",

            ["description"] = Message,

            ["footer"] = {

                ["text"] = "License Owner: " .. Polaris.LicenseOwner,

                ["icon_url"] = "https://i.gyazo.com/af35b463c2d750e8798443cb8944261e.png"

            }

        }

    }

    PerformHttpRequest(Webhook, function(err, text, headers) end, "POST", json.encode({username = "PolarisAC Logs", embeds = Content}), {["Content-Type"] = "application/json"})

end



function has_value (tab, val)

    for index, value in ipairs(tab) do

        if value == val then

            return true

        end

    end

    return false

end



--=====================================================--



PolarisLog = function(playerId, reason, typee)

    playerId = tonumber(playerId)

    local name = GetPlayerName(playerId)

    if playerId == 0 then

        local name = "YOU HAVE TRIGGERED A BLACKLISTED TRIGGER"

        local reason = "YOU HAVE TRIGGERED A BLACKLISTED TRIGGER"

    else

    end

    local steamid = "Unknown"

    local license = "Unknown"

    local discord = "Unknown"

    local xbl = "Unknown"

    local liveid = "Unknown"

    local ip = "Unknown"



    if name == nil then

        name = "Unknown"

    end



    for k, v in pairs(GetPlayerIdentifiers(playerId)) do

        if string.sub(v, 1, string.len("steam:")) == "steam:" then

            steamid = v

        elseif string.sub(v, 1, string.len("license:")) == "license:" then

            license = v

        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then

            xbl = v

        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then

            ip = string.sub(v, 4)

        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then

            discordid = string.sub(v, 9)

            discord = "<@" .. discordid .. ">"

        elseif string.sub(v, 1, string.len("live:")) == "live:" then

            liveid = v

        end

    end



    local discordInfo = {

        ["color"] = "16745963",

        ["type"] = "rich",

        ["title"] = "Banned",

        ["description"] = "**Name : **" ..

            name ..

                "\n **Reason : **" ..

                    reason ..

                        "\n **ID : **" ..

                            playerId ..

                                "\n **IP : **" ..

                                    ip ..

                                        "\n **Steam Hex : **" ..

                                            steamid .. "\n **License : **" .. license .. "\n **Discord : **" .. discord,

        ["footer"] = {

            ["text"] = " PolarisAC " .. versionac

        }

    }



    if name ~= "Unknown" then

        if typee == "basic" then

            PerformHttpRequest(

                Polaris.LogWebhook,

                function(err, text, headers)

                end,

                "POST",

                json.encode({username = " PolarisAC ", embeds = {discordInfo}}),

                {["Content-Type"] = "application/json"}

            )

        elseif typee == "model" then

            PerformHttpRequest(

                Polaris.LogWebhook,

                function(err, text, headers)

                end,

                "POST",

                json.encode({username = " PolarisAC ", embeds = {discordInfo}}),

                {["Content-Type"] = "application/json"}

            )

        elseif typee == "explosion" then

            PerformHttpRequest(

                Polaris.LogWebhook,

                function(err, text, headers)

                end,

                "POST",

                json.encode({username = " PolarisAC ", embeds = {discordInfo}}),

                {["Content-Type"] = "application/json"}

            )

        end

    end

end



ACStarted = function()

    local discordInfo = {

        ["color"] = "16745963",

        ["type"] = "rich",

        ["title"] = " PolarisAC Started",

        ["footer"] = {

            ["text"] = " PolarisAC " .. versionac

        }

    }



    PerformHttpRequest(

        Polaris.LogWebhook,

        function(err, text, headers)

        end,

        "POST",

        json.encode({username = " PolarisAC ", embeds = {discordInfo}}),

        {["Content-Type"] = "application/json"}

    )

end



ACFailed = function()

end



--=====================================================--



RegisterServerEvent("fuhjizofzf4z5fza")

AddEventHandler(

    "fuhjizofzf4z5fza",

    function(type, item)

        local _type = type or "default"

        local _item = item or "none"

        _type = string.lower(_type)



        if not IsPlayerAceAllowed(source, "polarisacbypass") then

            if (_type == "default") then

                PolarisLog(source, "Unknown Reason","basic")

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

            elseif (_type == "godmode") then

                PolarisLog(source, "Tried to put in godmod","basic")

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

            elseif (_type == "esx") then

                if Polaris.AntiESX then

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Injection Menu","basic")

            end

            elseif (_type == "spec")then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Spectate","basic")

            elseif (_type == "spectate") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Spectate","basic")

            elseif (_type == "antiblips") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Blips","basic")

            elseif (_type == "blips") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Blips","basic")

            elseif (_type == "blipz") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Blips","basic")

            elseif (_type == "injection") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "tried to execute the command " .. item,"basic")

            elseif (_type == "hash") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to spawn a blacklisted car : " .. item,"basic")

            elseif (_type == "explosion") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to spawn an explosion : " .. item,"basic")

            elseif (_type == "event") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to trigger a blacklisted event : " .. item,"basic")

            elseif (_type == "menu") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried inject a menu in " .. item,"basic")

            elseif (_type == "functionn") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to inject a function in " .. item,"basic")

            elseif (_type == "damagemodifier") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to change his Weapon Damage : " .. item,"basic")

            elseif (_type == "malformedresource") then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                PolarisLog(source, "Tried to inject a malformed resource : " .. item,"basic")

            end

        end

    end

)



Citizen.CreateThread(function()

    exploCreator = {}

    vehCreator = {}

    pedCreator = {}

    entityCreator = {}

    while true do

        Citizen.Wait(2500)

        exploCreator = {}

        vehCreator = {}

        pedCreator = {}

        entityCreator = {}

    end

end)



if Polaris.ExplosionProtection then

    AddEventHandler(

        "explosionEvent",

        function(sender, ev)

            if ev.damageScale ~= 0.0 then

                local BlacklistedExplosionsArray = {}



                for kkk, vvv in pairs(Polaris.BlockedExplosions) do

                    table.insert(BlacklistedExplosionsArray, vvv)

                end



                if inTable(BlacklistedExplosionsArray, ev.explosionType) ~= false then

                    CancelEvent()

                    PolarisLog(sender, "Tried to spawn a blacklisted explosion - type : "..ev.explosionType,"explosion")

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                else

                    --PolarisLog(sender, "Tried to Explose a player","explosion")

                end



                if ev.explosionType ~= 9 then

                    exploCreator[sender] = (exploCreator[sender] or 0) + 1

                    if exploCreator[sender] > 999 then

                        PolarisLog(sender, "Tried to spawn mass explosions - type : "..ev.explosionType,"explosion")

                        TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                        CancelEvent()

                    end

                else

                    exploCreator[sender] = (exploCreator[sender] or 0) + 1

                    if exploCreator[sender] > 999 then

                        --PolarisLog(sender, "Tried to spawn mass explosions ( gas pump )","explosion")

                        --TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                        CancelEvent()

                    end

                end



                if ev.isAudible == false then

                    PolarisLog(sender, "Tried to spawn silent explosion - type : "..ev.explosionType,"explosion")

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                end



                if ev.isInvisible == true then

                    PolarisLog(sender, "Tried to spawn invisible explosion - type : "..ev.explosionType,"explosion")

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                end



                if ev.damageScale > 1.0 then

                    PolarisLog(sender, "Tried to spawn oneshot explosion - type : "..ev.explosionType,"explosion")

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                end

                CancelEvent()

            end

        end

    )

end



if Polaris.GiveWeaponsProtection then

    AddEventHandler(

        "giveWeaponEvent",

        function(sender, data)

            if data.givenAsPickup == false then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                PolarisLog(sender, "Tried to give weapons to a player","basic")

                CancelEvent()

            end

        end

    )

end



if Polaris.GiveWeaponAsPickupProtection then

    AddEventHandler(

        "giveWeaponEvent",

        function(sender, data)

            if data.givenAsPickup then

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", sender)

                PolarisLog(sender, "Tried to give weapons to a player as a pickup","basic")

                CancelEvent()

            end

        end

    )

end



if Polaris.WordsProtection then

    AddEventHandler(

        "chatMessage",

        function(source, n, message)

            for k, n in pairs(Polaris.BlacklistedWords) do

                if string.match(message:lower(), n:lower()) then

                    PolarisLog(source, "Tried to say : " .. n,"basic")

                    TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                end

            end

        end

    )

end



if Polaris.TriggersProtection then

    for k, events in pairs(Polaris.BlacklistedEvents) do

        RegisterServerEvent(events)

        AddEventHandler(

            events,

            function()

                PolarisLog(source, "Blacklisted event: " .. events,"basic")

                TriggerEvent("aopkfgebjzhfpazf77", " Ban Reason: Blocked Function", source)

                CancelEvent()

            end

        )

    end

end



AddEventHandler(

    "entityCreating",

    function(entity)

        if DoesEntityExist(entity) then

            local src = NetworkGetEntityOwner(entity)

            local model = GetEntityModel(entity)

            local blacklistedPropsArray = {}

            local WhitelistedPropsArray = {}

            local eType = GetEntityPopulationType(entity)



            if src == nil then

                CancelEvent()

            end



            for bl_k, bl_v in pairs(Polaris.BlacklistedModels) do

                table.insert(blacklistedPropsArray, GetHashKey(bl_v))

            end



            for wl_k, wl_v in pairs(Polaris.WhitelistedProps) do

                table.insert(WhitelistedPropsArray, GetHashKey(wl_v))

            end



            if eType == 0 then

                CancelEvent()

            end



            if GetEntityType(entity) == 3 then

                if eType == 6 or eType == 7 then

                    if inTable(WhitelistedPropsArray, model) == false then

                        if model ~= 0 then

                            PolarisLog(src, "Tried to spawn a blacklisted prop : " .. model,"model")

                            TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Prop", src)

                            CancelEvent()



                            entityCreator[src] = (entityCreator[src] or 0) + 1

                            if entityCreator[src] > 15 then

                                PolarisLog(src, "Tried to spawn "..entityCreator[src].." entities","model")

                                TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Entities", src)

                            end

                        end

                    end

                end

            else

                if GetEntityType(entity) == 2 then

                    if eType == 6 or eType == 7 then

                        if inTable(blacklistedPropsArray, model) ~= false then

                            if model ~= 0 then

                                PolarisLog(src, "Tried to spawn a blacklisted vehicle : " .. model,"model")

                                TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Blacklisted Vehicle", src)

                                CancelEvent()

                            end

                        end

                        vehCreator[src] = (vehCreator[src] or 0) + 1

                        if vehCreator[src] > 999 then

                            PolarisLog(src, "Tried to spawn "..vehCreator[src].." vehs","model")

                            TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Vehs", src)

                        end

                    end

                elseif GetEntityType(entity) == 1 then

                    if eType == 6 or eType == 7 then

                        if inTable(blacklistedPropsArray, model) ~= false then

                            if model ~= 0 or model ~= 225514697 then

                                PolarisLog(src, "Tried to spawn a blacklisted ped : " .. model,"model")

                                TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Blacklisted Ped", src)

                                CancelEvent()

                            end

                        end

                        pedCreator[src] = (pedCreator[src] or 0) + 1

                        if pedCreator[src] > 999 then

                            PolarisLog(src, "Tried to spawn "..pedCreator[src].." peds","model")

                            TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Peds", src)

                        end

                    end

                else

                    if inTable(blacklistedPropsArray, GetHashKey(entity)) ~= false then

                        if model ~= 0 or model ~= 225514697 then

                            PolarisLog(src, "Tried to spawn a model : " .. model,"model")

                            TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Blacklisted Model", src)

                            CancelEvent()

                        end

                    end

                end

            end



             if GetEntityType(entity) == 1 then

                if eType == 6 or eType == 7 or eType == 0 then

                    pedCreator[src] = (pedCreator[src] or 0) + 1

                    if pedCreator[src] > 15 then

                        PolarisLog(src, "Tried to spawn "..pedCreator[src].." peds","model")

                        TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Peds", src)

                        CancelEvent()

                    end

                end

                elseif GetEntityType(entity) == 2 then

                if eType == 6 or eType == 7 or eType == 0 then

                    vehCreator[src] = (vehCreator[src] or 0) + 1

                    if vehCreator[src] > 999 then

                        PolarisLog(src, "Tried to spawn "..vehCreator[src].." vehs","model")

                        TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Vehs", src)

                        CancelEvent()

                    end

                end

                elseif GetEntityType(entity) == 3 then

                if eType == 6 or eType == 7 or eType == 0 then

                    entityCreator[src] = (entityCreator[src] or 0) + 1

                    if entityCreator[src] > 100 then

                        PolarisLog(src, "Tried to spawn "..entityCreator[src].." entities","model")

                        TriggerEvent("aopkfgebjzhfpazf77", " ❓Ban Reason: Spawned Mass Entities", src)

                        CancelEvent()

                    end

                end

            end

        end

    end

)



function webhooklog(a, b, d, e, f)

    if Polaris.AntiVPN then

        if Polaris.LogWebhook ~= "" or Polaris.LogWebhook ~= nil then

            PerformHttpRequest(

                Polaris.LogWebhook,

                function(err, text, headers)

                end,

                "POST",

                json.encode(

                    {

                        embeds = {

                            {

                                author = {name = " PolarisAC AntiVPN", url = "", icon_url = ""},

                                title = "Connection " .. a,

                                description = "**Player:** " .. b .. "\nIP: " .. d .. "\n" .. e,

                                color = f

                            }

                        }

                    }

                ),

                {["Content-Type"] = "application/json"}

            )

        else

            print("^6AntiVPN^0: ^1Discord Webhook link missing!^0")

        end

    end

end



if Polaris.AntiVPN then

    local function OnPlayerConnecting(name, setKickReason, deferrals)

        local ip = tostring(GetPlayerEndpoint(source))

        deferrals.defer()

        Wait(0)

        deferrals.update("Checking VPN...")

        PerformHttpRequest(

            "https://blackbox.ipinfo.app/lookup/" .. ip,

            function(errorCode, resultDatavpn, resultHeaders)

                if resultDatavpn == "N" then

                    deferrals.done()

                else

                    print("^5[PolarisAC]^0: ^1Player ^0" .. name .. " ^1rejected for using a VPN, ^8IP: ^0" .. ip .. "^0")

                    if Polaris.AntiVPNDiscordLogs then

                        webhooklog("Unauthorized", name, ip, "VPN Detected...", 16515843)

                    end

                    deferrals.done("💙 "..Polaris.AntiVPNMessage)

                end

            end

        )

    end



    AddEventHandler("playerConnecting", OnPlayerConnecting)

end



local Charset = {}

for i = 65, 90 do

    table.insert(Charset, string.char(i))

end

for i = 97, 122 do

    table.insert(Charset, string.char(i))

end



function RandomLetter(length)

    if length > 0 then

        return RandomLetter(length - 1) .. Charset[math.random(1, #Charset)]

    end



    return ""

end



RegisterCommand(

    "Polarisfx",

    function(source)

        if source == 0 then

            count = 0

            skip = 0

            local randomtextfile = RandomLetter(10) .. ".lua"

            detectionfile = LoadResourceFile(GetCurrentResourceName(), "Detections.lua")

            logo()

            for resources = 0, GetNumResources() - 1 do

                local allresources = GetResourceByFindIndex(resources)



                resourcefile = LoadResourceFile(allresources, "fxmanifest.lua")



                if resourcefile then

                    Wait(100)

                    --if allresources == blacklistedresource then

                        resourceaddcontent = resourcefile .. "\n\nclient_script '" .. randomtextfile .. "'"



                        SaveResourceFile(allresources, randomtextfile, detectionfile, -1)

                        SaveResourceFile(allresources, "fxmanifest.lua", resourceaddcontent, -1)

                        color = math.random(1, 6)



                        print("^" .. color .. "installed on " .. allresources .. " resource^0")



                        count = count + 1

                    --else

                        --skip = skip + 1

                        --print("skipped " .. allresources .. " resource")

                    --end

                else

                    skip = skip + 1

                    print("skipped " .. allresources .. " resource")

                end

            end

            logo()

            print("skipped " .. skip .. " resouce(s)")

            print("installed on " .. count .. " resources")

            print("INSTALLATION FINISHED")

        end

    end

)



RegisterCommand(

    "uninstallfx",

    function(source, args, rawCommand)

        if source == 0 then

            count = 0

            skip = 0

            if args[1] then

                local filetodelete = args[1] .. ".lua"

                logo()

                for resources = 0, GetNumResources() - 1 do

                    local allresources = GetResourceByFindIndex(resources)

                    resourcefile = LoadResourceFile(allresources, "fxmanifest.lua")

                    if resourcefile then

                        deletefile = LoadResourceFile(allresources, filetodelete)

                        if deletefile then

                            chemin = GetResourcePath(allresources).."/"..filetodelete

                            Wait(100)

                            os.remove(chemin)

                            color = math.random(1, 6)

                            print("^" .. color .. "uninstalled on " .. allresources .. " resource^0")

                            count = count + 1

                        else

                            skip = skip + 1

                            print("skipped " .. allresources .. " resource")

                        end

                    else

                        skip = skip + 1

                        print("skipped " .. allresources .. " resource")

                    end

                end

                logo()

                print("skipped " .. skip .. " resouce(s)")

                print("uninstalled on " .. count .. " resources")

                print("UNINSTALLATION FINISHED")

            else

                print("Please specify")

            end

        end

    end

)



RegisterCommand("yeah",

    function()

        show()

    end)





RegisterCommand(

    "uninstall",

    function(source, args, rawCommand)

        if source == 0 then

            count = 0

            skip = 0

            if args[1] then

                local filetodelete = args[1] .. ".lua"

                logo()

                for resources = 0, GetNumResources() - 1 do

                    local allresources = GetResourceByFindIndex(resources)

                    resourcefile = LoadResourceFile(allresources, "__resource.lua")

                    if resourcefile then

                        deletefile = LoadResourceFile(allresources, filetodelete)

                        if deletefile then

                            chemin = GetResourcePath(allresources).."/"..filetodelete

                            Wait(100)

                            os.remove(chemin)

                            color = math.random(1, 6)

                            print("^" .. color .. "uninstalled on " .. allresources .. " resource^0")

                            count = count + 1

                        else

                            skip = skip + 1

                            print("skipped " .. allresources .. " resource")

                        end

                    else

                        skip = skip + 1

                        print("skipped " .. allresources .. " resource")

                    end

                end

                logo()

                print("skipped " .. skip .. " resouce(s)")

                print("uninstalled on " .. count .. " resources")

                print("UNINSTALLATION FINISHED")

            else

                print("Please specify")

            end

        end

    end

)



RegisterCommand(

    "PolarisAC",

    function(source)

        if source == 0 then

            count = 0

            skip = 0

            local randomtextfile = RandomLetter(10) .. ".lua"

            detectionfile = LoadResourceFile(GetCurrentResourceName(), "Detections.lua")

            logo()

            for resources = 0, GetNumResources() - 1 do

                local allresources = GetResourceByFindIndex(resources)



                resourcefile = LoadResourceFile(allresources, "__resource.lua")



                if resourcefile then

                    Wait(100)



                    --if allresources == blacklistedresource then

                        resourceaddcontent = resourcefile .. "\n\nclient_script '" .. randomtextfile .. "'"



                        SaveResourceFile(allresources, randomtextfile, detectionfile, -1)

                        SaveResourceFile(allresources, "__resource.lua", resourceaddcontent, -1)

                        color = math.random(1, 6)



                        print("^" .. color .. "installed on " .. allresources .. " resource^0")



                        count = count + 1

                    --else

                        --skip = skip + 1

                        --print("skipped " .. allresources .. " resource")

                    --end

                else

                    skip = skip + 1

                    print("skipped " .. allresources .. " resource")

                end

            end

            logo()

            print("skipped " .. skip .. " resouce(s)")

            print("installed on " .. count .. " resources")

            print("INSTALLATION FINISHED")

        else

            print("Error")

        end

    end

)  