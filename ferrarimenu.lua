    
local MenuSize = vec2(900, 550)
local MenuStartCoords = vec2(300, 150)
local AccentColor = {191, 37, 37}  -- Menü renk vurgusu


function ShowMenu()
    local MenuWindow = MachoMenuTabbedWindow("Ferrari", MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, 200)
    MachoMenuSetAccent(MenuWindow, AccentColor[1], AccentColor[2], AccentColor[3])

    local playerTab = MachoMenuAddTab(MenuWindow, "Player")
    local VehiclesTab = MachoMenuAddTab(MenuWindow, "Vehicles")
    local riskyTab = MachoMenuAddTab(MenuWindow, "Risky")
    -- local menuTab = MachoMenuAddTab(MenuWindow, "Menu Options")


    local LeftSectionStart = vec2(220, 20)
    local LeftSectionEnd = vec2(MenuSize.x * 0.5 - 20, MenuSize.y - 20)
    local RightSectionStart = vec2(MenuSize.x * 0.5 + 10, 20)
    local RightSectionEnd = vec2(MenuSize.x - 20, MenuSize.y - 20)

--     local MenuSectionMain = MachoMenuGroup(menuTab, "Menu Options", LeftSectionStart.x, LeftSectionStart.y, LeftSectionEnd.x, LeftSectionEnd.y)

-- -- Renk Değiştirme Kontrolleri için Yeni Bir Sekme veya Grup Ekleyelim
-- local menuTab = MachoMenuAddTab(menuWindow, "Color Options")

--  -- Menu Color Picker (tek bir buton veya renk seçici aracı)
--  MachoMenuColorPicker(MenuSectionMain, "Menu Color", AccentColor, function(selectedColor)
--     AccentColor = selectedColor
--     MachoMenuSetAccent(menuWindow, AccentColor[1], AccentColor[2], AccentColor[3])  -- Yeni renk uygulandı
--     print("[LEVO]New menu color applied:", AccentColor[1], AccentColor[2], AccentColor[3])
-- end)




    local PlayerSectionMain = MachoMenuGroup(playerTab, "Main", LeftSectionStart.x, LeftSectionStart.y, LeftSectionEnd.x, LeftSectionEnd.y)
    local PlayerSectionMisc = MachoMenuGroup(playerTab, "Misc", RightSectionStart.x, RightSectionStart.y, RightSectionEnd.x, RightSectionEnd.y)


    
    -- Player Tab: Main Section
    MachoMenuCheckbox(PlayerSectionMain, "GodMode (Risky)", 
        function() MachoInjectResource("any", [[ SetEntityInvincible(PlayerPedId(), true) print("[LEVO]God Mode Enabled") ]]) end,
        function() MachoInjectResource("any", [[ SetEntityInvincible(PlayerPedId(), false) print("[LEVO]God Mode Disabled") ]]) end
    )

    MachoMenuCheckbox(PlayerSectionMain, "Semi GodMode", 
        function() MachoInjectResource("any", [[ SetPedCanRagdoll(PlayerPedId(), false) print("[LEVO]Semi God Mode Enabled") ]]) end,
        function() MachoInjectResource("any", [[ SetPedCanRagdoll(PlayerPedId(), true) print("[LEVO]Semi God Mode Disabled") ]]) end
    )

    MachoMenuCheckbox(PlayerSectionMain, "Fast Run", 
        function() MachoInjectResource("any", [[ SetRunSprintMultiplierForPlayer(PlayerId(), 1.49) print("[LEVO]Fast Run Enabled") ]]) end,
        function() MachoInjectResource("any", [[ SetRunSprintMultiplierForPlayer(PlayerId(), 1.0) print("[LEVO]Fast Run Disabled") ]]) end
    )

    MachoMenuCheckbox(PlayerSectionMain, "Infinite Stamina", 
        function() MachoInjectResource("any", [[ infiniteStaminaEnabled = true print("[LEVO]Infinite Stamina Enabled") ]]) end,
        function() MachoInjectResource("any", [[ infiniteStaminaEnabled = false print("[LEVO]Infinite Stamina Disabled") ]]) end
    )

    MachoMenuCheckbox(PlayerSectionMain, "Invisible", 
        function() MachoInjectResource("any", [[ SetEntityVisible(PlayerPedId(), false, false) print("[LEVO]Player is now invisible") ]]) end,
        function() MachoInjectResource("any", [[ SetEntityVisible(PlayerPedId(), true, false) print("[LEVO]Player is now visible") ]]) end
    )

    MachoMenuCheckbox(PlayerSectionMain, "No Ragdoll", 
        function() MachoInjectResource("any", [[ SetPedCanRagdoll(PlayerPedId(), false) print("[LEVO]No Ragdoll Enabled") ]]) end,
        function() MachoInjectResource("any", [[ SetPedCanRagdoll(PlayerPedId(), true) print("[LEVO]No Ragdoll Disabled") ]]) end
    )

    -- Player Tab: Super Jump ve Ped Changer ekleme
-- Super Jump fonksiyonunu aktif eden ve sürekli kontrol eden bir işlev
MachoMenuCheckbox(PlayerSectionMain, "Super Jump", 
    function() 
        MachoInjectResource("any", [[
            _G.superJumpActive = true
            print("[LEVO]Super Jump Enabled")

            Citizen.CreateThread(function()
                while _G.superJumpActive do
                    Citizen.Wait(0)
                    SetSuperJumpThisFrame(PlayerId())  -- Süper zıplamayı aktif ediyor
                end
            end)
        ]])
    end,
    function() 
        MachoInjectResource("any", [[
            _G.superJumpActive = false
            print("[LEVO]Super Jump Disabled")
        ]])
    end
)

    

    MachoMenuButton(PlayerSectionMain, "Heal", function()
        MachoInjectResource("any", [[ SetEntityHealth(PlayerPedId(), 200) print("[LEVO]Player healed") ]])
    end)

    MachoMenuButton(PlayerSectionMain, "Revive", function()
        MachoInjectResource("any", [[ TriggerEvent('hospital:client:Revive') print("[LEVO]Revive Triggered") ]])
    end)

    MachoMenuButton(PlayerSectionMain, "Suicide", function()
        MachoInjectResource("any", [[ SetEntityHealth(PlayerPedId(), 0) print("[LEVO]Suicide button pressed") ]])
    end)

    MachoMenuSlider(PlayerSectionMain, "HP Amount", 200, 0, 200, "", 0, function(Value)
        MachoInjectResource("any", string.format([[ SetEntityHealth(PlayerPedId(), %d) print("[LEVO]HP Amount set to %d") ]], Value, Value))
    end)

    MachoMenuSlider(PlayerSectionMain, "Armor Amount", 100, 0, 100, "", 0, function(Value)
        MachoInjectResource("any", string.format([[ SetPedArmour(PlayerPedId(), %d) print("[LEVO]Armor Amount set to %d") ]], Value, Value))
    end)

    -- Player Tab: Misc Section
    local weaponInputBox = MachoMenuInputbox(PlayerSectionMisc, "Weapon Name", "weapon_combatpistol")
    MachoMenuButton(PlayerSectionMisc, "Give Weapon", function()
        local WeaponName = MachoMenuGetInputbox(weaponInputBox)
        MachoInjectResource("any", string.format([[ GiveWeaponToPed(PlayerPedId(), GetHashKey("%s"), 999, false, true) print("[LEVO]Given weapon: %s") ]], WeaponName, WeaponName))
    end)

    MachoMenuDropDown(PlayerSectionMisc, "Set Weapon Attachment", function(index)
        MachoInjectResource("any", string.format([[ print("[LEVO]Weapon Attachment set to %d") ]], index))
    end, "None", "Extended Clip", "Flashlight", "Suppressor")

    -- Risky Tab Layout
    local RiskySectionMain = MachoMenuGroup(riskyTab, "Main", LeftSectionStart.x, LeftSectionStart.y, LeftSectionEnd.x, LeftSectionEnd.y)
    local RiskySectionMain = MachoMenuGroup(riskyTab, "Server", LeftSectionStart.x, LeftSectionStart.y, LeftSectionEnd.x, LeftSectionEnd.y)
    local VehiclesSectionMain = MachoMenuGroup(VehiclesTab, "Main", LeftSectionStart.x, LeftSectionStart.y, LeftSectionEnd.x, LeftSectionEnd.y)
    local VehiclesSectionoptions = MachoMenuGroup(VehiclesTab, "Options", RightSectionStart.x, RightSectionStart.y, RightSectionEnd.x, RightSectionEnd.y)

local HandlingSectionStart = vec2(RightSectionStart.x, RightSectionStart.y + 200)
local HandlingSectionEnd = vec2(RightSectionEnd.x, RightSectionEnd.y)

local VehiclesSectionhandling = MachoMenuGroup(VehiclesTab, "Handling", HandlingSectionStart.x, HandlingSectionStart.y, HandlingSectionEnd.x, HandlingSectionEnd.y)

local LicensePlateSectionStart = vec2(LeftSectionStart.x, LeftSectionStart.y + 150)  -- Main kısmının biraz altında
local LicensePlateSectionEnd = vec2(LeftSectionEnd.x, LeftSectionEnd.y)


-- AntiCheat Finder Butonu
MachoMenuButton(RiskySectionMain, "AntiCheat Finder", function()
    MachoInjectResource("any", [[
        CreateThread(function()
            local resources = GetNumResources()
            local belmaFound = true
            print("[LEVO]")
            print("[LEVO]  ^2Discord.gg/ferrari^2")
            for i = 0, resources - 1 do
                local resource = GetResourceByFindIndex(i)
                local files = GetNumResourceMetadata(resource, 'client_script')
                
                for j = 0, files - 1, 1 do
                    local x = GetResourceMetadata(resource, 'client_script', j)
                    if x ~= nil then
                        if string.find(x, "obfuscated") then
                            print("[LEVO] ^4AntiCheat: ^2[Fiveguard]")
                            print("[LEVO] ^4Resource: ^2[" .. resource .. "^2]")
                            print("[LEVO] ^2Thanks for Choosing Us .gg/ferrari")
                            belmaFound = true
                        end
                    end
                end
            end

            if not belmaFound then
                print("[LEVO][LEVO] ^2Fiveguard Bulunamadı.")
            end

            print("[LEVO]")
        end)
    ]])
end)

local soundLoopActive = false

-- Sonsuz Ses Döngüsü Butonu
MachoMenuCheckbox(RiskySectionMain, "Play Sound",
    function() 
        soundLoopActive = true
        Citizen.CreateThread(function()
            while soundLoopActive do
                PlaySoundFromCoord(-1, "FocusIn", 0, 0, 5, "HintCamSounds", true, 0, false)
                Citizen.Wait(50) -- Sürekli çalması için bekleme süresini sıfır olarak ayarladık
            end
        end)
        print("[LEVO]Infinite sound loop at coordinates started.")
    end,
    function() 
        soundLoopActive = false
        print("[LEVO]Infinite sound loop at coordinates stopped.")
    end
)



-- ESP aç/kapat işlevini kontrol eden buton
MachoMenuCheckbox(RiskySectionMain, "Open ID ESP (Risky)", 
    function() 
        MachoInjectResource("any", [[
            _G.espActive = true
            print("[LEVO] ESP Open.")

            Citizen.CreateThread(function()
                while _G.espActive do
                    Citizen.Wait(0)
                    local myServerId = GetPlayerServerId(PlayerId())  -- Sunucu ID'niz
                    for _, playerId in ipairs(GetActivePlayers()) do
                        local playerPed = GetPlayerPed(playerId)
                        local playerCoords = GetEntityCoords(playerPed)
                        local playerServerId = GetPlayerServerId(playerId)

                        -- Ekranda oyuncunun ID'sini göster
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, "ID: " .. tostring(playerServerId), {r = 255, g = 255, b = 255})  -- Beyaz
                    end
                end
            end)

            -- 3D yazı yazma fonksiyonu
            function DrawText3D(x, y, z, text, color)
                local onScreen, _x, _y = World3dToScreen2d(x, y, z)
                local px, py, pz = table.unpack(GetGameplayCamCoords())

                if onScreen then
                    SetTextScale(0.35, 0.35)
                    SetTextFont(4)
                    SetTextProportional(1)
                    SetTextEntry("STRING")
                    SetTextCentre(1)
                    SetTextColour(color.r, color.g, color.b, 255)  -- Renk ayarı
                    AddTextComponentString(text)
                    DrawText(_x, _y)
                    local factor = (string.len(text)) / 370
                    DrawRect(_x, _y + 0.0150, 0.015 + factor, 0.03, 0, 0, 0, 75)
                end
            end
        ]])
    end,
    function() 
        MachoInjectResource("any", [[
            _G.espActive = false
            print("[LEVO] ESP Close.")
        ]])
    end
)




-- -- Risky Tab: Target Player Actions
-- local targetIdInput = MachoMenuInputbox(RiskySectionMain, "Target Player ID", "")

-- -- Sessiz Öldürme
-- MachoMenuButton(RiskySectionMain, "Silent Kill", function()
--     SetEntityHealth(PlayerPedId(), 0)
--     print("Silent Kill uygulandı.")
-- end)

-- -- Patlama
-- MachoMenuButton(RiskySectionMain, "Explode", function()
--     local coords = GetEntityCoords(PlayerPedId())
--     AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
--     print("Patlama uygulandı.")
-- end)

-- -- Sersemletme
-- MachoMenuButton(RiskySectionMain, "Stun Player", function()
--     SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, true, true, false)
--     print("Stun Player uygulandı.")
-- end)

-- -- Kıyafet Kopyalama (yalnızca kendi karakterinize uygulanır)
-- MachoMenuButton(RiskySectionMain, "Copy Outfit", function()
--     local model = GetEntityModel(PlayerPedId())
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--         Wait(0)
--     end
--     SetPlayerModel(PlayerId(), model)
--     SetModelAsNoLongerNeeded(model)
--     print("Kıyafet kopyalandı.")
-- end)


-- Menüye başlık olarak "Object Spawner" ekleme
MachoMenuText(RiskySectionMain, "Object Spawner")

-- Koordinatlar ve model girişi için input box'lar
local coordsInputBox = MachoMenuInputbox(RiskySectionMain, "Coordinates", "Enter Coordinates (X, Y, Z)")
local objectModelInputBox = MachoMenuInputbox(RiskySectionMain, "Object Model", "Enter Model Name")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start Object Spawn", function()
    local coordsText = MachoMenuGetInputbox(coordsInputBox)  -- Koordinatları al
    local objectModel = MachoMenuGetInputbox(objectModelInputBox)  -- Model adını al

    -- Koordinatları ayrıştırma
    local xCoord, yCoord, zCoord = coordsText:match("([^,]+),%s*([^,]+),%s*([^,]+)")
    xCoord, yCoord, zCoord = tonumber(xCoord), tonumber(yCoord), tonumber(zCoord)

    -- Koordinatlar ve modelin doğruluğunu kontrol et
    if not xCoord or not yCoord or not zCoord or objectModel == "" then
        print("[LEVO]Enter valid coordinates and model name!")
        return
    end

    -- Obje spawn işlevini başlatan kod
    MachoInjectResource("any", [[
        if _G.isSpawning then
            print("[LEVO]Object spawn process is already active.")
            return
        end

        _G.isSpawning = true
        local objectCoords = vector3(]] .. xCoord .. [[, ]] .. yCoord .. [[, ]] .. zCoord .. [[)
        local objectModel = GetHashKey("]] .. objectModel .. [[")

        function loadModel(model)
            if not IsModelInCdimage(model) or not IsModelValid(model) then
                print("[LEVO]invalid model!")
                return false
            end
            RequestModel(model)
            local startTime = GetGameTimer()
            while not HasModelLoaded(model) do
                Citizen.Wait(500)
                if GetGameTimer() - startTime > 5000 then
                    print("[LEVO]Failed to load model.")
                    _G.isSpawning = false
                    return false
                end
            end
            return true
        end

        function spawnObject(coords)
            if not loadModel(objectModel) then return end
            if DoesEntityExist(_G.object) then DeleteObject(_G.object) end
            _G.object = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, false)
            FreezeEntityPosition(_G.object, true)
            SetEntityInvincible(_G.object, true)
            print("[LEVO]Object spawned: " .. tostring(_G.object))
        end

        Citizen.CreateThread(function()
            spawnObject(objectCoords)
            while _G.isSpawning do
                if not DoesEntityExist(_G.object) then
                    spawnObject(objectCoords)
                end
                Citizen.Wait(1000)
            end
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop Object Spawn", function()
    MachoInjectResource("any", [[
        if not _G.isSpawning then
            print("[LEVO]Object spawn process has already been stopped!")
            return
        end
        _G.isSpawning = false
        if DoesEntityExist(_G.object) then
            DeleteObject(_G.object)
            _G.object = nil
        end
        print("[LEVO]Object spawn process has been stopped.")
    ]])
end)

-- Menüye başlık olarak "All Vehicles Spawn" ekleme
MachoMenuText(RiskySectionMain, "All Vehicles Spawn")

-- Araç modelini girmek için input box
local vehicleInputBox = MachoMenuInputbox(RiskySectionMain, "Vehicle Model", "Enter Vehicle Model")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start All Vehicles Spawn", function()
    local vehicleModel = MachoMenuGetInputbox(vehicleInputBox)  -- Girdi kutusundan araç modelini al
    if vehicleModel == nil or vehicleModel == "" then
        print("[LEVO]Enter a valid vehicle model!")
        return
    end

    -- Araç spawn işlevini başlatan kodu `MachoInjectResource` içinde çağırıyoruz
    MachoInjectResource("any", [[
        if _G.careverActive then
            print("[LEVO]Vehicle spawn is already active.")
            return
        end

        _G.careverActive = true  -- Global değişken
        local vehicleModel = "]] .. vehicleModel .. [["

        Citizen.CreateThread(function()
            print("[LEVO]Vehicle spawn process started, model:", vehicleModel)

            while _G.careverActive do
                RequestModel(vehicleModel)

                while not HasModelLoaded(vehicleModel) do
                    Wait(100)
                end

                local playerList = GetActivePlayers()
                for _, playerId in ipairs(playerList) do
                    local ped = GetPlayerPed(playerId)
                    local pos = GetEntityCoords(ped)
                    local heading = GetEntityHeading(ped)

                    local vehicle = CreateVehicle(vehicleModel, pos.x, pos.y, pos.z, heading, true, false)
                    SetEntityAsNoLongerNeeded(vehicle)
                end

                Citizen.Wait(350)
            end
            print("[LEVO]Vehicle spawn process has been stopped.")
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop All Vehicles Spawn", function()
    MachoInjectResource("any", [[
        _G.careverActive = false
        print("[LEVO]Vehicle spawn process has been stopped.")
    ]])
end)



-- Menüye başlık olarak "Koordinat Bilgisi" ekleme
MachoMenuText(RiskySectionMain, "Coordinate Information")

-- Koordinatları yazdırmak için bir buton
MachoMenuButton(RiskySectionMain, "Get Current Coordinates", function()
    MachoInjectResource("any", [[
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Koordinatları F8 konsoluna yazdır
        print(string.format("Your current coordinates: X: %.2f, Y: %.2f, Z: %.2f", playerCoords.x, playerCoords.y, playerCoords.z))
    ]])
end)
-- Menüye başlık olarak "World Spawn" ekleme
MachoMenuText(RiskySectionMain, "World Spawn")

-- World Spawn butonu
MachoMenuButton(RiskySectionMain, "Spawn Props at World Spawn", function()
    MachoInjectResource("any", [[
        local malibo = 2967811882
        local pos = GetEntityCoords(PlayerPedId())

        RequestModel(malibo)

        while not HasModelLoaded(malibo) do
            Wait(0)
        end

        local obj1 = CreateObject(malibo, pos.x, pos.y, pos.z, true, true, false)
        SetEntityHeading(obj1, 160.590)
        FreezeEntityPosition(obj1, true)

        local obj2 = CreateObject(malibo, pos.x, pos.y, pos.z, true, true, false)
        SetEntityHeading(obj2, 216.980)
        FreezeEntityPosition(obj2, true)

        local obj3 = CreateObject(malibo, pos.x, pos.y, pos.z, true, true, false)
        SetEntityHeading(obj3, 291.740)
        FreezeEntityPosition(obj3, true)

        print("[LEVO]Atws:Prop Code Ike Erects Mountains^7")
    ]])
end)







-- Risky Sekmesine Araç Modeli Girişi ve Araç Spawn Butonu Eklenmesi
local vehicleModelInput = MachoMenuInputbox(VehiclesSectionMain, "Vehicle Model", "Enter Vehicle Model")  -- Varsayılan olarak "adder" modeliyle gelir

MachoMenuButton(VehiclesSectionMain, "Spawn Vehicle", function()
    local vehicleModel = MachoMenuGetInputbox(vehicleModelInput)
    
    -- Girilen modelin geçerli olup olmadığını kontrol edelim
    if vehicleModel == nil or vehicleModel == "" then
        print("[LEVO]Invalid vehicle model!")
        return
    end
    
    -- Araç spawn işlevini `MachoInjectResource` kullanarak çalıştır
    MachoInjectResource("any", [[
        local vehicleModel = "]] .. vehicleModel .. [["

        -- Oyun içindeki oyuncuyu al
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Aracın modelini yüklüyor
        local vehicleHash = GetHashKey(vehicleModel)
        RequestModel(vehicleHash)

        -- Model yüklenene kadar bekle
        local startTime = GetGameTimer()
        while not HasModelLoaded(vehicleHash) do
            Wait(500)
            if GetGameTimer() - startTime > 5000 then
                print("[LEVO]Vehicle model could not be loaded.")
                return
            end
        end

        -- Aracı spawn et
        local vehicle = CreateVehicle(vehicleHash, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
        
        -- Oyuncuyu araca bindir
        SetPedIntoVehicle(playerPed, vehicle, -1)

        -- Modeli serbest bırak
        SetModelAsNoLongerNeeded(vehicleHash)

        print(vehicleModel .. " spawned successfully!")
    ]])
end)

-- Max Engine Tuning Butonu
MachoMenuButton(VehiclesSectionMain, "Max Engine Tuning", function()
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle and vehicle ~= 0 then
            -- Motor Tuning
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) -- Motor modunu maksimum yap
            SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) -- Frenleri maksimum yap
            SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false) -- Şanzıman modunu maksimum yap
            ToggleVehicleMod(vehicle, 18, true) -- Turbo ekle
            print("[LEVO]Max engine tuning applied.")
        else
            print("[LEVO]You are not in a vehicle!")
        end
    ]])
end)

-- Max Cosmetic Tuning Butonu (Rastgele Parçalar ve Renk)
MachoMenuButton(VehiclesSectionMain, "Max Cosmetic Tuning", function()
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle and vehicle ~= 0 then
            -- Kozmetik Tuning
            SetVehicleModKit(vehicle, 0)
            
            -- Renkleri rastgele ayarla
            local primaryColor = math.random(0, 159) -- Ana renk rastgele seç
            local secondaryColor = math.random(0, 159) -- Yan renk rastgele seç
            SetVehicleColours(vehicle, primaryColor, secondaryColor)
            
            -- Ekstra renkler rastgele ayarla
            local pearlColor = math.random(0, 159) -- İnci renk rastgele seç
            local wheelColor = math.random(0, 159) -- Tekerlek rengi rastgele seç
            SetVehicleExtraColours(vehicle, pearlColor, wheelColor)

            -- Cam rengi rastgele ayarla
            SetVehicleWindowTint(vehicle, math.random(0, 5))
            
            -- Rastgele mod parçalarını ekle
            for modType = 0, 49 do
                local maxMods = GetNumVehicleMods(vehicle, modType)
                if maxMods > 0 then
                    local randomModIndex = math.random(0, maxMods - 1)
                    SetVehicleMod(vehicle, modType, randomModIndex, false)
                end
            end
            
            print("[LEVO]Randomized cosmetic tuning applied.")
        else
            print("[LEVO]You are not in a vehicle!")
        end
    ]])
end)

-- GodMode Butonu
MachoMenuCheckbox(VehiclesSectionMain, "Vehicle GodMode (Risky)",
    function() 
        MachoInjectResource("any", [[
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                SetEntityInvincible(vehicle, true)
                SetVehicleCanBeDamaged(vehicle, false)
                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                print("[LEVO]Vehicle God Mode Enabled")
            else
                print("[LEVO]You are not in a vehicle!")
            end
        ]])
    end,
    function() 
        MachoInjectResource("any", [[
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                SetEntityInvincible(vehicle, false)
                SetVehicleCanBeDamaged(vehicle, true)
                SetVehicleCanBeVisiblyDamaged(vehicle, true)
                print("[LEVO]Vehicle God Mode Disabled")
            else
                print("[LEVO]You are not in a vehicle!")
            end
        ]])
    end
)


-- Anahtarsız Çalıştırma Butonu
MachoMenuCheckbox(VehiclesSectionMain, "Always Force Engine",
    function() 
        MachoInjectResource("any", [[
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                SetVehicleEngineOn(vehicle, true, true, false)
                print("[LEVO]Always Force Engine Enabled")
            else
                print("[LEVO]You are not in a vehicle!")
            end
        ]])
    end,
    function() 
        MachoInjectResource("any", [[
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                SetVehicleEngineOn(vehicle, false, true, false)
                print("[LEVO]Always Force Engine Disabled")
            else
                print("[LEVO]You are not in a vehicle!")
            end
        ]])
    end
)


-- Menüye başlık olarak "Spoof Vehicle" ekleme
MachoMenuText(VehiclesSectionMain, "Spoof Vehicle")

-- Araç modelini girmek için input box
local vehicleInputBox = MachoMenuInputbox(VehiclesSectionMain, "Vehicle Model", "Enter Vehicle Model")

-- Spoof Vehicle butonu
MachoMenuButton(VehiclesSectionMain, "Spawn Spoofed Vehicle", function()
    local vehicleName = MachoMenuGetInputbox(vehicleInputBox)  -- Girdi kutusundan araç adını al
    if vehicleName == nil or vehicleName == "" then
        print("[LEVO]Enter a valid vehicle name!")
        return
    end

    -- Verilen aracı spawn eden kodu `MachoInjectResource` içinde çağırıyoruz
    MachoInjectResource("any", [[
        local vehicleName = "]] .. vehicleName .. [["

        -- Oyun içindeki oyuncuyu al
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Aracın modelini yüklüyor
        local vehicleModel = GetHashKey(vehicleName)
        RequestModel(vehicleModel)

        -- Model yüklenene kadar bekle
        local startTime = GetGameTimer()
        while not HasModelLoaded(vehicleModel) do
            Wait(500)
            if GetGameTimer() - startTime > 5000 then
                print("[LEVO]Vehicle model could not be loaded.")
                return
            end
        end

        -- Araç spawn ediyor
        local vehicle = CreateVehicle(vehicleModel, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), false, false)

        -- Network ayarları: Aracın sadece senin client'ında görünmesini sağlıyor
        SetEntityVisible(vehicle, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(vehicle), false)
        
        -- Oyuncuyu araca bindiriyor
        SetPedIntoVehicle(playerPed, vehicle, -1)

        -- Modeli serbest bırakıyoruz
        SetModelAsNoLongerNeeded(vehicleModel)

        print(vehicleName .. " The vehicle named spawned visible only to you.!")
    ]])
end)





-- Plaka değiştirme için input alanı ve buton
local plateInput = MachoMenuInputbox(VehiclesSectionMain, "License Plate", "Enter Plate")

MachoMenuButton(VehiclesSectionMain, "Set License Plate", function()
    local plateText = MachoMenuGetInputbox(plateInput)

    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local plateText = "]] .. plateText .. [["

        if vehicle and vehicle ~= 0 then
            if plateText and plateText ~= "" then
                SetVehicleNumberPlateText(vehicle, plateText)
                print("[LEVO]Vehicle license plate set: " .. plateText)
            else
                print("[LEVO]Please enter a valid license plate number.")
            end
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)



-- Araç Tamiri
MachoMenuButton(VehiclesSectionoptions, "Repair Vehicle", function()
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle and vehicle ~= 0 then
            SetVehicleFixed(vehicle)
            SetVehicleDirtLevel(vehicle, 0)
            print("[LEVO]Vehicle repaired.")
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)

-- Primary Color Slider
local primaryColor = 0
MachoMenuSlider(VehiclesSectionoptions, "Primary Color", 0, 0, 160, "-", 1, function(value)
    primaryColor = value
end)

-- Secondary Color Slider
local secondaryColor = 0
MachoMenuSlider(VehiclesSectionoptions, "Secondary Color", 0, 0, 160, "-", 1, function(value)
    secondaryColor = value
end)

-- Apply Color Butonu
MachoMenuButton(VehiclesSectionoptions, "Apply Color", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and vehicle ~= 0 then
        SetVehicleColours(vehicle, primaryColor, secondaryColor)
        print("[LEVO]Araç rengi uygulandı: Primary (" .. primaryColor .. "), Secondary (" .. secondaryColor .. ")")
    else
        print("[LEVO]Aracın içinde değilsiniz!")
    end
end)

-- Grip Scale
MachoMenuSlider(VehiclesSectionhandling, "Grip Scale", 10, 0, 20, "x", 1, function(gripScale)
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local gripScale = ]] .. gripScale * 0.1 .. [[
        
        if vehicle and vehicle ~= 0 then
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", gripScale)
            print("[LEVO]Grip Scale set to: " .. gripScale .. "x")
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)

-- Torque Scale
MachoMenuSlider(VehiclesSectionhandling, "Torque Scale", 100, 50, 150, "%", 10, function(torqueScale)
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local torqueScale = ]] .. torqueScale / 100 .. [[

        if vehicle and vehicle ~= 0 then
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", torqueScale)
            print("[LEVO]Torque Scale set to: " .. (torqueScale * 100) .. "%")
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)

-- Power Scale
MachoMenuSlider(VehiclesSectionhandling, "Power Scale", 100, 50, 150, "%", 10, function(powerScale)
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local powerScale = ]] .. (powerScale - 100) .. [[

        if vehicle and vehicle ~= 0 then
            SetVehicleEnginePowerMultiplier(vehicle, powerScale)
            print("[LEVO]Power Scale set to: " .. (powerScale + 100) .. "%")
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)

-- Traction Scale
MachoMenuSlider(VehiclesSectionhandling, "Traction Scale", 100, 50, 150, "%", 10, function(tractionScale)
    MachoInjectResource("any", [[
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local tractionScale = ]] .. tractionScale / 100 .. [[

        if vehicle and vehicle ~= 0 then
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionLossMult", tractionScale)
            print("[LEVO]Traction Scale set to: " .. (tractionScale * 100) .. "%")
        else
            print("[LEVO]You are not in the vehicle!")
        end
    ]])
end)




-- Araç Renk Değiştirme
local colorOptions = {
    {name = "Black", id = 0},
    {name = "White", id = 111},
    {name = "Red", id = 27},
    {name = "Blue", id = 64},
    {name = "Green", id = 37},
    {name = "Yellow", id = 88},
    {name = "Purple", id = 145},
    {name = "Pink", id = 135},
    {name = "Orange", id = 38}
}

local colorNames = {}
for _, color in ipairs(colorOptions) do
    table.insert(colorNames, color.name)
end


local RiskySectionMain = MachoMenuGroup(riskyTab, "Fuck", RightSectionStart.x, RightSectionStart.y, RightSectionEnd.x, RightSectionEnd.y)







local playerIdInput  -- ID girişi için değişken

-- ID Girişi için alan ve Start, Stop butonları
playerIdInput = MachoMenuInputbox(RiskySectionMain, "Target Player ID", "Enter Player ID")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start Rain Car", function()
    local playerId = tonumber(MachoMenuGetInputbox(playerIdInput))  -- Girilen ID'yi al ve sayıya çevir
    if not playerId then
        print("[LEVO]Enter a valid player ID.")
        return
    end

    -- Araç yağmuru işlevini başlatan kodu `MachoInjectResource` içinde çağırıyoruz
    MachoInjectResource("any", [[
        if _G.rainActive then
            print("[LEVO]Vehicle rain is already active.")
            return
        end

        _G.rainActive = true  -- Global değişken
        local playerId = ]] .. playerId .. [[

        Citizen.CreateThread(function()
            print("[LEVO]Vehicle rain started, target player ID:", playerId)

            while _G.rainActive do
                local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
                if not DoesEntityExist(playerPed) then
                    print("[LEVO]Invalid player ID.")
                    _G.rainActive = false
                    break
                end

                local playerCoords = GetEntityCoords(playerPed)
                print("[LEVO]Target player coordinates:", playerCoords.x, playerCoords.y, playerCoords.z)

                local carHash = GetHashKey("drafter")
                RequestModel(carHash)

                -- Modelin yüklendiğinden emin ol
                local startTime = GetGameTimer()
                while not HasModelLoaded(carHash) do
                    Citizen.Wait(0)
                    if GetGameTimer() - startTime > 5000 then
                        print("[LEVO]Vehicle model could not be loaded. Model ismi: drafter")
                        _G.rainActive = false
                        return
                    end
                end

                -- Oyuncunun tam üstünden araç düşür
                local x, y, z = table.unpack(playerCoords)
                local vehicle = CreateVehicle(carHash, x, y, z + 50, 0.0, true, true)
                if vehicle == 0 then
                    print("[LEVO]The vehicle could not be spawned. Possible causes: the model may not have been loaded or the CreateVehicle function failed.")
                else
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetEntityLodDist(vehicle, 1000)
                    SetVehicleGravityAmount(vehicle, 100.0)
                    print("[LEVO]Vehicle spawned, model: drafter, coordinates:", x, y, z + 50)
                end

                Citizen.Wait(2500)
            end
            print("[LEVO]Vehicle rain stopped.")
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop Rain Car", function()
    -- `_G.rainActive` değişkenini durdurmak için `MachoInjectResource` kullanarak false yapıyoruz
    MachoInjectResource("any", [[
        _G.rainActive = false
        print("[LEVO]car rainActive is set to false to stop vehicle rain.")
    ]])
end)



local airdropActive = false
local heliTargetIdInput  -- ID girişi için değişken

-- ID Girişi için alan ve Start, Stop butonları
heliTargetIdInput = MachoMenuInputbox(RiskySectionMain, "Target Player ID for Heli", "Enter Player ID")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start Heli Airdrop", function()
    local targetId = tonumber(MachoMenuGetInputbox(heliTargetIdInput))  -- Girilen ID'yi al ve sayıya çevir
    if not targetId then
        print("[LEVO]Enter a valid player ID.")
        return
    end

    -- Helikopter spawn işlevini başlatan kodu `MachoInjectResource` içinde çağırıyoruz
    MachoInjectResource("any", [[
        airdropActive = true
        local targetId = ]] .. targetId .. [[

        local function getRandomOffset()
            return math.random(-3, 3) + 0.1
        end

        local function getRandomDelay()
            return math.random(1500, 3000)
        end

        Citizen.CreateThread(function()
            print("[LEVO]Helicopter spawn process has started, target player ID:", targetId)

            while airdropActive do
                local playerPed = GetPlayerPed(GetPlayerFromServerId(targetId))
                if not DoesEntityExist(playerPed) then
                    print("[LEVO]Invalid player ID.")
                    airdropActive = false
                    break
                end

                local playerCoords = GetEntityCoords(playerPed)
                local randomX = playerCoords.x + getRandomOffset()
                local randomY = playerCoords.y + getRandomOffset()
                local randomZ = playerCoords.z + 10.0

                local heliModel = GetHashKey('volatus')
                RequestModel(heliModel)

                local startTime = GetGameTimer()
                while not HasModelLoaded(heliModel) do
                    Citizen.Wait(500)
                    if GetGameTimer() - startTime > 5000 then
                        print("[LEVO]Could not load helicopter model.")
                        airdropActive = false
                        return
                    end
                end

                local heli = CreateVehicle(heliModel, randomX, randomY, randomZ, 0.0, true, false)
                if heli == 0 then
                    print("[LEVO]Helicopter could not spawn.")
                else
                    SetEntityAsMissionEntity(heli, true, true)
                    SetVehicleHasBeenOwnedByPlayer(heli, true)
                    SetEntityDynamic(heli, true)
                    SetVehicleGravity(heli, true)
                    ApplyForceToEntity(heli, 1, 0.0, 0.0, -50.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)
                    SetEntityHealth(heli, 500)
                    SetVehicleEngineHealth(heli, -4000)
                    SetVehicleBodyHealth(heli, 500)
                    SetVehicleEngineOn(heli, false, true, true)
                    SetVehicleForwardSpeed(heli, 0.0)

                    print("[LEVO]Helicopter spawned and left to fall.")
                end

                Citizen.Wait(getRandomDelay())
            end
            print("[LEVO]Helicopter spawning has been stopped.")
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop Heli Airdrop", function()
    MachoInjectResource("any", [[
        airdropActive = false
    ]])
end)

local playerIdInput  -- ID girişi için değişken

-- ID Girişi için alan ve Start, Stop butonları
playerIdInput = MachoMenuInputbox(RiskySectionMain, "Target Player ID", "Enter Player ID")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start Car Ram", function()
    local playerId = tonumber(MachoMenuGetInputbox(playerIdInput))  -- Girilen ID'yi al ve sayıya çevir
    if not playerId then
        print("[LEVO]Enter a valid player ID.")
        return
    end

    -- Araç çarpma işlevini başlatan kodu `MachoInjectResource` içinde çağırıyoruz
    MachoInjectResource("any", [[
        if _G.carSpawnActive then
            print("[LEVO]Vehicle collision is already active.")
            return
        end

        _G.carSpawnActive = true  -- Global değişken
        local targetPlayer = ]] .. playerId .. [[

        local vehicles = {
            "drafter",
            "blista",
            "buffalo",
            "cavalcade",
            "elegy",
            "entityxf",
        }

        local function getRandomDelay()
            return math.random(1000, 3000)
        end

        Citizen.CreateThread(function()
            print("[LEVO]Vehicle crashing started, target player ID:", targetPlayer)

            while _G.carSpawnActive do
                local playerPed = GetPlayerPed(GetPlayerFromServerId(targetPlayer))

                if DoesEntityExist(playerPed) then
                    local playerCoords = GetEntityCoords(playerPed)

                    print("[LEVO]The vehicle spawns on the player's head: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)

                    local carModel = GetHashKey(vehicles[math.random(#vehicles)])
                    RequestModel(carModel)

                    local startTime = GetGameTimer()
                    while not HasModelLoaded(carModel) do
                        Citizen.Wait(500)
                        if GetGameTimer() - startTime > 5000 then
                            print("[LEVO]Vehicle model could not be loaded.")
                            _G.carSpawnActive = false
                            return
                        end
                    end

                    -- Araç belirtilen oyuncunun üstüne spawn ediliyor
                    local spawnDistance = 30.0
                    local randomX = playerCoords.x + spawnDistance * math.cos(math.random() * 2 * math.pi)
                    local randomY = playerCoords.y + spawnDistance * math.sin(math.random() * 2 * math.pi)
                    local randomZ = playerCoords.z + 1.0

                    local car = CreateVehicle(carModel, randomX, randomY, randomZ, GetEntityHeading(playerPed), true, false)

                    local targetX, targetY, targetZ = table.unpack(playerCoords)
                    SetEntityAsMissionEntity(car, true, true)
                    SetVehicleHasBeenOwnedByPlayer(car, true)

                    local speed = 100.0
                    local dx = (targetX - randomX)
                    local dy = (targetY - randomY)
                    local distance = math.sqrt(dx * dx + dy * dy)
                    dx = dx / distance
                    dy = dy / distance

                    SetEntityVelocity(car, dx * speed, dy * speed, 0.0)

                    Citizen.Wait(2000)
                    DeleteVehicle(car)

                    print("[LEVO]Vehicle spawned and deleted.")

                    Citizen.Wait(getRandomDelay())
                else
                    print("[LEVO]The specified player was not found!")
                    _G.carSpawnActive = false
                    break
                end

                if not _G.carSpawnActive then
                    print("[LEVO]Vehicle crashing has been stopped.")
                    break
                end
            end
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop Car Ram", function()
    MachoInjectResource("any", [[
        _G.carSpawnActive = false
        print("[LEVO]Vehicle crashing has been stopped.")
    ]])
end)

local pedModel = "a_f_y_eastsa_02"  -- Varsayılan ped modeli

-- Menüye "Ped Spawn" başlığını ekleme
MachoMenuText(RiskySectionMain, "Ped Spawn")

-- Start Butonu
MachoMenuButton(RiskySectionMain, "Start Ped Spawn", function()
    MachoInjectResource("any", [[
        if _G.pedSpawning then
            print("[LEVO]Pad spawning is already active.")
            return
        end

        _G.pedSpawning = true  -- Global değişken

        Citizen.CreateThread(function()
            print("[LEVO]Pad spawning process started, model:", "]] .. pedModel .. [[")

            while _G.pedSpawning do
                RequestModel("]] .. pedModel .. [[")

                while not HasModelLoaded("]] .. pedModel .. [[") do
                    Wait(100)
                end

                local playerList = GetActivePlayers()
                for _, playerId in ipairs(playerList) do
                    local ped = GetPlayerPed(playerId)
                    local pos = GetEntityCoords(ped)
                    local heading = GetEntityHeading(ped)

                    local newPed = CreatePed(28, "]] .. pedModel .. [[", pos.x, pos.y, pos.z, heading, true, false)
                    TaskWanderInArea(newPed, pos.x, pos.y, pos.z, 10.0, 10.0, 10.0)
                    SetPedAsNoLongerNeeded(newPed)
                end

                Citizen.Wait(350)
            end
            print("[LEVO]Pad spawning has been stopped.")
        end)
    ]])
end)

-- Stop Butonu
MachoMenuButton(RiskySectionMain, "Stop Ped Spawn", function()
    MachoInjectResource("any", [[
        _G.pedSpawning = false
        print("[LEVO]Pad spawning has been stopped.")
    ]])
end)






local KeysBin = MachoWebRequest("website_url_with_keys")
local CurrentKey = MachoAuthenticationKey()

local KeyPresent = string.find(KeysBin, CurrentKey)
if KeyPresent ~= nil then
    print("Key is authenticated [" .. CurrentKey .. "]")
else
    print("Key is not in the list [" .. CurrentKey .. "]")
end





end

ShowMenu()
