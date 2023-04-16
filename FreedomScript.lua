--[[
    FreedomScript Reloaded for Stand by StealthyAD.
    The All-In-One Script combines every RAAAAH NUKE
            ___     __  ___ ______ ____   ____ ______ ___ 
           /   |   /  |/  // ____// __ \ /  _// ____//   |
          / /| |  / /|_/ // __/  / /_/ / / / / /    / /| |
         / ___ | / /  / // /___ / _, _/_/ / / /___ / ___ |
        /_/  |_|/_/  /_//_____//_/ |_|/___/ \____//_/  |_|
                                                        
     ________  ___  ___   ________   ___  __             ___    ___  _______    ________   ___  ___     
    |\  _____\|\  \|\  \ |\   ____\ |\  \|\  \          |\  \  /  /||\  ___ \  |\   __  \ |\  \|\  \    
    \ \  \__/ \ \  \\\  \\ \  \___| \ \  \/  /|_        \ \  \/  / /\ \   __/| \ \  \|\  \\ \  \\\  \   
     \ \   __\ \ \  \\\  \\ \  \     \ \   ___  \        \ \    / /  \ \  \_|/__\ \   __  \\ \   __  \  
      \ \  \_|  \ \  \\\  \\ \  \____ \ \  \\ \  \        \/  /  /    \ \  \_|\ \\ \  \ \  \\ \  \ \  \ 
       \ \__\    \ \_______\\ \_______\\ \__\\ \__\     __/  / /       \ \_______\\ \__\ \__\\ \__\ \__\
        \|__|     \|_______| \|_______| \|__| \|__|    |\___/ /         \|_______| \|__|\|__| \|__|\|__|
                                                       \|___|/                                          
        ______                     _                     _____              _         _   
        |  ____|                   | |                   / ____|            (_)       | |  
        | |__  _ __  ___   ___   __| |  ___   _ __ ___  | (___    ___  _ __  _  _ __  | |_ 
        |  __|| '__|/ _ \ / _ \ / _` | / _ \ | '_ ` _ \  \___ \  / __|| '__|| || '_ \ | __|
        | |   | |  |  __/|  __/| (_| || (_) || | | | | | ____) || (__ | |   | || |_) || |_ 
        |_|   |_|   \___| \___| \__,_| \___/ |_| |_| |_||_____/  \___||_|   |_|| .__/  \__|
                                                                                | |
                                                                                |_|

    Features:
    - Compatible All Stand Versions if deprecated versions too.

    Help with Lua?
    - GTAV Natives: https://nativedb.dotindustries.dev/natives/
    - FiveM Docs Natives: https://docs.fivem.net/natives/
    - Stand Lua Documentation: https://stand.gg/help/lua-api-documentation
    - Lua Documentation: https://www.lua.org/docs.html
]]--

    util.keep_running()
    util.require_natives(1663599433)

    ----======================================----
    ---             Basic Functions
    --- The most essential part of Lua Script.
    ----======================================----

        local aalib = require("aalib")
        local FreedomPlaySound = aalib.play_sound
        local SND_ASYNC<const> = 0x0001
        local SND_FILENAME<const> = 0x00020000

        local FreedomSVersion = "0.46e"
        local FreedomSMessage = "> FreedomScript "..FreedomSVersion
        local FreedomToast = util.toast
        local FreedomHelpMessage = "~w~Free~p~dom~r~Script ".."~s~"..FreedomSVersion

        local int_min = -2147483647
        local int_max = 2147483647
    
        FreedomNotify = function(str) if ToggleNotify then if NotifMode == 2 then util.show_corner_help(FreedomHelpMessage.."~s~~n~"..str ) else FreedomToast(FreedomSMessage.."\n"..str) end end end
        FreedomSession =  function() return util.is_session_started() and not util.is_session_transition_active() end

    ----========================================----
    ---              Functions Parts
    --- The part of functions which need to work
    ----========================================----

        local wait = util.yield
        local ScriptDir <const> = filesystem.scripts_dir()
        local required_files <const> = {
            "lib\\FreedomScript\\Functions.lua",
        }

        for _, file in pairs(required_files) do
            local file_path = ScriptDir .. file
            if not filesystem.exists(file_path) then
                FreedomNotify("Sorry, you missed these documents:" .. file_path, TOAST_ALL)
            end
        end

        require "FreedomScript.Functions"

    ----==========================================----
    ---             Core Functions
    --- The most important part of the lua scripts
    ----==========================================----

        local script_store_freedom = filesystem.store_dir() .. SCRIPT_NAME -- Redirects to %appdata%\Stand\Lua Scripts\store\FreedomScript
        if not filesystem.is_dir(script_store_freedom) then
            filesystem.mkdirs(script_store_freedom)
        end

        local script_store_freedom_stop = filesystem.store_dir() .. SCRIPT_NAME .. '/stops' -- Redirects to %appdata%\Stand\Lua Scripts\store\FreedomScript\stops
        if not filesystem.is_dir(script_store_freedom_stop) then
            filesystem.mkdirs(script_store_freedom_stop)
        end

        local script_store_freedom_raah = filesystem.store_dir() .. SCRIPT_NAME .. '/raaah' -- Redirects to %appdata%\Stand\Lua Scripts\store\FreedomScript\raaah
        if not filesystem.is_dir(script_store_freedom_raah) then
            filesystem.mkdirs(script_store_freedom_raah)
        end

        local script_store_freedom_songs = filesystem.store_dir() .. SCRIPT_NAME .. '/songs' -- Redirects to %appdata%\Stand\Lua Scripts\store\FreedomScript\songs
        if not filesystem.is_dir(script_store_freedom_songs) then
            filesystem.mkdirs(script_store_freedom_songs)
        end

        local script_store_911_songs = filesystem.store_dir() .. SCRIPT_NAME .. '/911' -- Redirects to %appdata%\Stand\Lua Scripts\store\FreedomScript\911
        if not filesystem.is_dir(script_store_911_songs) then
            filesystem.mkdirs(script_store_911_songs)
        end

        local script_resources_dir = filesystem.resources_dir() .. SCRIPT_NAME -- Redirects to %appdata%\Stand\Lua Scripts\resources\FreedomScript
        if not filesystem.is_dir(script_resources_dir) then
            filesystem.mkdirs(script_resources_dir)
        end

        local played_songs = {} 
        local song_files = filesystem.list_files(script_store_freedom_songs)
        local last_auto_time = 0
        local auto_interval = 90 -- 2 minutes

        function FreedomAuto()
            local current_time = os.time()
            local remaining_time = auto_interval - (current_time - last_auto_time)
            if remaining_time <= 0 then
                last_auto_time = current_time
                if #song_files > 0 then
                    local song_path
                    repeat 
                        song_path = song_files[math.random(#song_files)]
                    until not played_songs[song_path] or #played_songs == #song_files
                    if #played_songs == #song_files then
                        FreedomNotify("All songs have been played.")
                        played_songs = {}
                    else
                        played_songs[song_path] = true
                        os.sleep(1)
                        AutoPlay(song_path)
                    end
                else
                    FreedomNotify("There is no music in the storage folder.")
                end
            else
                local remaining_minutes = math.floor(remaining_time / 60)
                local remaining_seconds = remaining_time % 60
                local remaining_time_string = ""
                if remaining_minutes > 0 then
                    remaining_time_string = remaining_time_string .. remaining_minutes .. " minute(s) "
                end
                remaining_time_string = remaining_time_string .. remaining_seconds .. " second(s)"
                FreedomNotify("Please wait " .. remaining_time_string .. " before playing another song.")
            end
        end

        function SET_INT_GLOBAL(global, value)
            memory.write_int(memory.script_global(global), value)
        end

        function GET_INT_GLOBAL(global)
            return memory.read_int(memory.script_global(global))
        end

        local function linear_transition(start_value, end_value, duration, current_time)
            local progress = current_time / duration
            progress = math.min(progress, 1)
            return start_value + (end_value - start_value) * progress
        end

        local function CameraMoving(pid, force) -- most of script use ShakeCamera
            local entity = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
            FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 7, 0, false, true, force)
        end

        local function FreedomPassive(pid)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local hash = 0x787F0BB
        
            local audible = true
            local visible = true
        
            load_weapon_asset(hash)
            
            for i = 0, 50 do
                if PLAYER.IS_PLAYER_DEAD(pid) then
                    FreedomNotify("\n".."Successfully killed " .. players.get_name(pid))
                    return
                end
        
                local coords = ENTITY.GET_ENTITY_COORDS(ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z - 2, 100, 0, hash, 0, audible, not visible, 2500)
                
                util.yield(10)
            end
        
            FreedomNotify("\n".."We are not able to kill " .. players.get_name(pid) .. ". Verify if the player is not in ragdoll mode or godmode.")
        end

        local function FreedomSilent(pid)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local PName = players.get_name(pid)
            for i = 0, 50 do
                if PLAYER.IS_PLAYER_DEAD(pid) then
                    FreedomNotify("\n"..PName.." has been silently killed.")
                    return
                end

                local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
                FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'] + 2, 7, 1000, false, true, 0)
                util.yield(10)
            end

            FreedomNotify("\n"..PName.. " could not silently killed.")
        end
        
        local vehicleData = util.get_vehicles()
        for k,v in vehicleData do
            vehicleData[k] = v.name
        end

    ----=============================================----
    ---                Updates Features
    --- Update manually/automatically the Lua Scripts
    ----=============================================----

        -- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
        local status, auto_updater = pcall(require, "auto-updater")
        if not status then
            local auto_update_complete = nil FreedomNotify("Installing auto-updater...", TOAST_ALL)
            async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
                function(result, headers, status_code)
                    local function parse_auto_update_result(result, headers, status_code)
                        local error_prefix = "Error downloading auto-updater: "
                        if status_code ~= 200 then FreedomNotify(error_prefix..status_code, TOAST_ALL) return false end
                        if not result or result == "" then FreedomNotify(error_prefix.."Found empty file.", TOAST_ALL) return false end
                        filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                        local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                        if file == nil then FreedomNotify(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                        file:write(result) file:close() FreedomNotify("Successfully installed auto-updater lib", TOAST_ALL) return true
                    end
                    auto_update_complete = parse_auto_update_result(result, headers, status_code)
                end, function() FreedomNotify("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
            async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
            if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
            auto_updater = require("auto-updater")
        end
        if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

        local default_check_interval = 604800
        local auto_update_config = {
            source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/FreedomScript.lua",
            script_relpath=SCRIPT_RELPATH,
            switch_to_branch=selected_branch,
            verify_file_begins_with="--",
            check_interval=86400,
            silent_updates=true,
            dependencies={
                {
                    name="Functions",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/lib/FreedomScript/Functions.lua",
                    script_relpath="lib/FreedomScript/Functions.lua",
                    check_interval=default_check_interval,
                },
                {
                    name="intro",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/resources/FreedomScript/FreedomScript.png",
                    script_relpath="resources/FreedomScript/FreedomScript.png",
                    check_interval=default_check_interval,
                },
                {
                    name="911",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/store/FreedomScript/911/911.wav",
                    script_relpath="store/FreedomScript/911/911.wav",
                    check_interval=default_check_interval,
                },
                {
                    name="Eagle",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/store/FreedomScript/raaah/oil.wav",
                    script_relpath="store/FreedomScript/raaah/oil.wav",
                    check_interval=default_check_interval,
                },
                {
                    name="Fortunate_Son",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/store/FreedomScript/songs/FortunateSon.wav",
                    script_relpath="store/FreedomScript/songs/FortunateSon.wav",
                    check_interval=default_check_interval,
                },
                {
                    name="Stops",
                    source_url="https://raw.githubusercontent.com/StealthyAD/FreedomScript/main/store/FreedomScript/stops/stop.wav",
                    script_relpath="store/FreedomScript/stops/stop.wav",
                    check_interval=default_check_interval,
                },
            }
        }

        auto_updater.run_auto_update(auto_update_config)
    
    ----========================================----
    ---              Root Parts
    ---     The part of root which redirects.
    ----========================================----
    
        local FreedomRoot = menu.my_root()
        FreedomRoot:divider("FreedomScript "..FreedomSVersion)
        local FreedomSelf = FreedomRoot:list("Self")
        local FreedomVehicles = FreedomRoot:list("Vehicles")
        local FreedomOnline = FreedomRoot:list("Online")
        local FreedomWorld = FreedomRoot:list("World")
        local FreedomMiscs = FreedomRoot:list("Miscs")
        FreedomRoot:action("Changelog", {}, "", function()
        async_http.init("raw.githubusercontent.com","/StealthyAD/FreedomScript/main/Changelog",function(content)
            if content ~= "404: Not Found" then
                local changelog = string.gsub(content, "\n$", "")
                    FreedomNotify("\n"..changelog)
                end
            end)
            async_http.dispatch()
        end)

        ----========================================----
        ---              Self Part
        ---   The part of self part, local, normal
        ----========================================----

            local FreedomWeapons = FreedomSelf:list("Weapons")
            local FreedomAnimations = FreedomSelf:list("Animations")
            local FreedomAnimals = FreedomSelf:list("Animals")

            ----========================================----
            ---              Weapons Parts
            ---     The part of weapons part, local
            ----========================================----

                local FreedomVisionTweaks = FreedomWeapons:list("Weapon Vision Tweaks")
                local FreedomOthersTweaks = FreedomWeapons:list("Other Tweaks")
                local FreedomReloads = FreedomWeapons:list("Reload Tweaks")
                FreedomVisionTweaks:toggle_loop("Night Vision Scope" ,{}, "Press E while aiming to activate.\n\nRecommended to use only night time, using daytime can may have complication on your eyes watching the screen.",function()
                    local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
                    local FreedomNV = menu.ref_by_path('Game>Rendering>Night Vision')
                    if GRAPHICS.GET_USINGNIGHTVISION() and not aiming then
                        menu.trigger_command(FreedomNV,"off")
                        GRAPHICS.SET_NIGHTVISION(false)
                    elseif PAD.IS_CONTROL_JUST_PRESSED(38,38) then
                        if menu.get_value(FreedomNV) or not aiming then
                            menu.trigger_command(FreedomNV,"off")
                            GRAPHICS.SET_NIGHTVISION(false)
                        else
                            menu.trigger_command(FreedomNV,"on")
                            GRAPHICS.SET_NIGHTVISION(true)
                        end
                    end
                end)

                FreedomVisionTweaks:toggle_loop("Thermal Vision Scope" ,{}, "Press E while aiming to activate.\n\nBest function to make better wallhack and see through players.",function()
                    local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
                    local FreedomThermal = menu.ref_by_path('Game>Rendering>Thermal Vision')
                    if GRAPHICS.GET_USINGSEETHROUGH() and not aiming then
                        menu.trigger_command(FreedomThermal,"off")
                        GRAPHICS.SET_SEETHROUGH(false)
                        GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
                    elseif PAD.IS_CONTROL_JUST_PRESSED(38,38) then
                        if menu.get_value(FreedomThermal) or not aiming then
                            menu.trigger_command(FreedomThermal,"off")
                            GRAPHICS.SET_SEETHROUGH(false)
                            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
                        else
                            menu.trigger_command(FreedomThermal,"on")
                            GRAPHICS.SET_SEETHROUGH(true)
                            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(3500)
                        end
                    end
                end)

                local FreedomNR = menu.ref_by_path('Self>Weapons>No Recoil')
                FreedomWeapons:toggle_loop("No Recoil Alt", {}, "Press E while aiming to activate.\n\nRecommended to use standard weapon or RPG.", function()
                    local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
                    if not aiming then
                        menu.trigger_command(FreedomNR, 'off')
                    elseif PAD.IS_CONTROL_JUST_PRESSED(38, 38) then
                        if not menu.get_value(FreedomNR) then
                            menu.trigger_command(FreedomNR, 'on')
                        else
                            menu.trigger_command(FreedomNR, 'off')
                        end
                    end
                end)

                FreedomOthersTweaks:toggle_loop("Orbital Gun Weapon", {}, "Shoot everywhere to orbital player without reason.", function()
                    local last_hit_coords = v3.new()
                    if WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), last_hit_coords) then
                        FreedomOrbital(last_hit_coords)
                    end
                end)

                FreedomOthersTweaks:toggle_loop("Castle Bravo", {}, "Make boom explosion but single fire usage.", function()
                    if PED.IS_PED_SHOOTING(players.user_ped()) then
                        local hash = util.joaat("prop_military_pickup_01")
                        request_model(hash)
                        local player_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 5.0, 3.0)
                        local dir = v3.new()
                        local c2 = v3.new(0,0,0)
                        c2 = get_offset_from_gameplay_camera(1000)
                        dir.x = (c2.x - player_pos.x) * 1000
                        dir.y = (c2.y - player_pos.y) * 1000
                        dir.z = (c2.z - player_pos.z) * 1000
                        local nuke = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, player_pos.x, player_pos.y, player_pos.z, true, false, false)
                        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(nuke, players.user_ped(), false)
                        ENTITY.APPLY_FORCE_TO_ENTITY(nuke, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
                        ENTITY.SET_ENTITY_HAS_GRAVITY(nuke, true)
                
                        while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(nuke) and not ENTITY.IS_ENTITY_IN_WATER(nuke) do
                            util.yield(0)
                        end
                        local nukePos = ENTITY.GET_ENTITY_COORDS(nuke, true)
                        entities.delete_by_handle(nuke)
                        CreateNuke(nukePos)
                    end
                end)    

                FreedomOthersTweaks:toggle_loop("Explosive Ammo", {}, "Simple Explosive Ammo for all weapons.", function()
                    MISC.SET_EXPLOSIVE_AMMO_THIS_FRAME(players.user())
                end)

                FreedomWeapons:toggle("Infinite Ammo", {""}, "Lock your ammo to get not reloading fire.\n\nAlternative to Stand, has reloading fire. Better alternative to avoid reloading and made reloading easier without losing time.", function(toggle)
                    local WeaponHashes = { -- Added Hash Weapons to look the real infinite weapon without reloading
                        0x1B06D571,0xBFE256D4,0x5EF9FEC4,0x22D8FE39,0x3656C8C1,0x99AEEB3B,0xBFD21232,0x88374054,0xD205520E,0x83839C4,0x47757124,
                        0xDC4DB296,0xC1B3C3D1,0xCB96392F,0x97EA20B8,0xAF3696A1,0x2B5EF5EC,0x917F6C8C,0x13532244,0x2BE6766B,0x78A97CD0,0xEFE7E2DF,
                        0xA3D4D34,0xDB1AA450,0xBD248B55,0x476BF155,0x1D073A89,0x555AF99A,0x7846A318,0xE284C527,0x9D61E50F,0xA89CB99E,0x3AABBBAA,
                        0xEF951FBB,0x12E82D3D,0xBFEFFF6D,0x394F415C,0x83BF0278,0xFAD1F1C9,0xAF113F99,0xC0A3098D,0x969C3D67,0x7F229F94,0x84D6FAFD,
                        0x624FE830,0x9D07F764,0x7FD62962,0xDBBD7280,0x61012683,0x5FC3C11,0xC472FE2,0xA914799,0xC734385A,0x6A6C02E0,0xB1CA77B1,
                        0xA284510B,0x4DD2DC56,0x42BF8A85,0x7F7497E5,0x6D544C99,0x63AB0442,0x781FE4A,0xB62D1F67,0x93E220BD,0xA0973D5E,0xFDBC8A50,0x6E7DDDEC,
                        0x497FACC3,0x24B17070,0x2C3731D9,0xAB564B93,0x787F0BB,0xBA45E8B8,0x23C9F95C,0xFEA23564,0xDB26713A,0x1BC4FDB9,0xD1D5F52B,0x45CD9CF3,
                        0x42BF8A85
                    }

                    for k,v in WeaponHashes do
                        WEAPON.SET_PED_INFINITE_AMMO(players.user_ped(), toggle, v)
                        WEAPON.SET_PED_INFINITE_AMMO_CLIP(PLAYER.PLAYER_PED_ID(), toggle)
                    end
                end)

                FreedomReloads:toggle_loop("Quick Reload", {}, "Reload faster than normal weapon.\n\nRecommended for big magazine which it's very slow to reload", function()
                    if PED.IS_PED_RELOADING(PLAYER.PLAYER_PED_ID()) then
                        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(PLAYER.PLAYER_PED_ID())
                    end
                end)

                FreedomReloads:toggle_loop("Quick Reload while Rolling", {}, "Reload automatically while rolling\n\nRecommended for PvP or something else.", function()
                if TASK.GET_IS_TASK_ACTIVE(PLAYER.PLAYER_PED_ID(), 4) and PAD.IS_CONTROL_PRESSED(2, 22) and not PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                    wait(600)
                    WEAPON.REFILL_AMMO_INSTANTLY(PLAYER.PLAYER_PED_ID())
                    end
                end)

                FreedomReloads:toggle_loop("Quick Weapon Change", {}, "Speed up the action while changing weapon\n\nExample: Changing AP Pistol to RPG/Sniper/Carbine/Shotgun...", function()
                    if PED.IS_PED_SWITCHING_WEAPON(PLAYER.PLAYER_PED_ID()) then
                        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(PLAYER.PLAYER_PED_ID())
                    end
                end)

                FreedomReloads:toggle_loop("No Reload while Shooting", {""}, "Refill Instantly your ammo without reloading while losing ammo.\n\nAlternative to Stand, have the same feature but it will make easier to not reloading.", function() 
                    WEAPON.REFILL_AMMO_INSTANTLY(PLAYER.PLAYER_PED_ID())
                end)

                FreedomWeapons:action("Fill All Weapons Ammo", {"freefammo"}, "", function()
                    local WeaponHashes = { -- Added Hash Weapons to look the real infinite weapon without reloading
                        0x1B06D571,0xBFE256D4,0x5EF9FEC4,0x22D8FE39,0x3656C8C1,0x99AEEB3B,0xBFD21232,0x88374054,0xD205520E,0x83839C4,0x47757124,
                        0xDC4DB296,0xC1B3C3D1,0xCB96392F,0x97EA20B8,0xAF3696A1,0x2B5EF5EC,0x917F6C8C,0x13532244,0x2BE6766B,0x78A97CD0,0xEFE7E2DF,
                        0xA3D4D34,0xDB1AA450,0xBD248B55,0x476BF155,0x1D073A89,0x555AF99A,0x7846A318,0xE284C527,0x9D61E50F,0xA89CB99E,0x3AABBBAA,
                        0xEF951FBB,0x12E82D3D,0xBFEFFF6D,0x394F415C,0x83BF0278,0xFAD1F1C9,0xAF113F99,0xC0A3098D,0x969C3D67,0x7F229F94,0x84D6FAFD,
                        0x624FE830,0x9D07F764,0x7FD62962,0xDBBD7280,0x61012683,0x5FC3C11,0xC472FE2,0xA914799,0xC734385A,0x6A6C02E0,0xB1CA77B1,
                        0xA284510B,0x4DD2DC56,0x42BF8A85,0x7F7497E5,0x6D544C99,0x63AB0442,0x781FE4A,0xB62D1F67,0x93E220BD,0xA0973D5E,0xFDBC8A50,0x6E7DDDEC,
                        0x497FACC3,0x24B17070,0x2C3731D9,0xAB564B93,0x787F0BB,0xBA45E8B8,0x23C9F95C,0xFEA23564,0xDB26713A,0x1BC4FDB9,0xD1D5F52B,0x45CD9CF3,
                        0x42BF8A85
                    }
                    for k,v in WeaponHashes do
                        local MaxAmmo = memory.alloc_int()
                        WEAPON.GET_MAX_AMMO(players.user_ped(), v, MaxAmmo)
                        MaxAmmo = memory.read_int(MaxAmmo)
                        WEAPON.SET_PED_AMMO(players.user_ped(), v, MaxAmmo, false) 
                    end
                end)

            -------------------------------------------------------------------------------------------------------------------

            FreedomSelf:toggle_loop("Force Clean Ped & Wetness", {}, "Force Cleanup Ped & Wetness against blood or damage.", function() 
                PED.CLEAR_PED_BLOOD_DAMAGE(PLAYER.PLAYER_PED_ID()) 
                PED.CLEAR_PED_WETNESS(PLAYER.PLAYER_PED_ID())
            end)

            FreedomSelf:toggle("Ghost Rider", {}, "Become Ghost Rider.\nMake sure you are not using god mode right now.", function(toggle)
                if toggle then
                    FIRE.START_ENTITY_FIRE(PLAYER.PLAYER_PED_ID())
                    PLAYER.SET_PLAYER_INVINCIBLE(PLAYER.PLAYER_PED_ID(), true)
                else
                    FIRE.STOP_ENTITY_FIRE(PLAYER.PLAYER_PED_ID())
                    PLAYER.SET_PLAYER_INVINCIBLE(PLAYER.PLAYER_PED_ID(), false)
                end
            end)

            FreedomSelf:toggle("Reduce Footsteps", {}, "", function(toggle) -- Everyone use the part of the script, but I will add this if they need this.
                AUDIO.SET_PED_FOOTSTEPS_EVENTS_ENABLED(PLAYER.PLAYER_PED_ID(), not toggle)
            end)

            FreedomSelf:toggle_loop("Force Respawn", {}, "Able to respawn faster while toggle.", function()
                local gwobaw = memory.script_global(2672505 + 1685 + 756)
                if PED.IS_PED_DEAD_OR_DYING(Freedom.player) then
                    GRAPHICS.ANIMPOSTFX_STOP_ALL()
                    memory.write_int(gwobaw, memory.read_int(gwobaw) | 1 << 1)
                end
            end)

            ----========================================----
            ---              Animation Parts
            ---     The part of animation part, local
            ----========================================----

                local FreedomAnime = {
                    ToggleFeature = {},
                    ToggleMenu = {},
                }
                FreedomAnime.task_list = {
                    { 1,   "Climb Ladder" },
                    { 2,   "Exit Vehicle" },
                    { 3,   "Combat Roll" },
                    { 16,  "Get Up" },
                    { 17,  "Get Up And Stand Still" },
                    { 50,  "Vault" },
                    { 54,  "Open Door" },
                    { 121, "Steal Vehicle" },
                    { 128, "Melee" },
                    { 135, "Synchronized Scene" },
                    { 150, "In Vehicle Basic" },
                    { 152, "Leave Any Car" },
                    { 160, "Enter Vehicle" },
                    { 162, "Open Vehicle Door From Outside" },
                    { 163, "Enter Vehicle Seat" },
                    { 164, "Close Vehicle Door From Inside" },
                    { 165, "In Vehicle Seat Shuffle" },
                    { 167, "Exit Vehicle Seat" },
                    { 168, "Close Vehicle Door From Outside" },
                    { 177, "Try To Grab Vehicle Door" },
                    { 286, "Throw Projectile" },
                    { 300, "Enter Cover" },
                    { 301, "Exit Cover" },
                }

                FreedomAnimations:toggle_loop("Toggle Feature", {}, "Turning On/Off for Fast Animation", function()
                    for id, toggle in pairs(FreedomAnime.ToggleFeature) do
                        if toggle and TASK.GET_IS_TASK_ACTIVE(players.user_ped(), id) then
                            PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
                        end
                    end
                end)
    
                FreedomAnimations:divider("Options")
                FreedomAnimations:toggle("Enable/Disable Feature", {}, "", function(toggle)
                    for _, v in pairs(FreedomAnime.ToggleMenu) do
                        if menu.is_ref_valid(v) then
                            menu.set_value(v, toggle)
                        end
                    end
                end)
    
                for _, v in pairs(FreedomAnime.task_list) do
                    local id = v[1]
                    local name = v[2]
    
                    FreedomAnime.ToggleFeature[id] = false
    
                    local menu_toggle = menu.toggle(FreedomAnimations, name, {}, "", function(toggle)
                        FreedomAnime.ToggleFeature[id] = toggle
                    end)
                    FreedomAnime.ToggleMenu[id] = menu_toggle
                end

            ----========================================----
            ---              Animals Parts
            ---     The part of animals parts, local
            ----========================================----

                FreedomAnimals:toggle_loop("Meoww cat", {}, "", function()
                    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
                        local pet = util.joaat("a_c_cat_01")
                        Freedom.request_model(pet)
                        local pos = players.get_position(players.user())
                        custom_pet = entities.create_ped(28, pet, pos, 0)
                        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
                    end
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
                    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
                    util.yield(2500)
                end, function()
                    entities.delete_by_handle(custom_pet)
                    custom_pet = nil
                end)

                FreedomAnimals:toggle_loop("Polish Cow", {}, "", function()
                    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
                        local pet = util.joaat("a_c_cow")
                        Freedom.request_model(pet)
                        local pos = players.get_position(players.user())
                        custom_pet = entities.create_ped(28, pet, pos, 0)
                        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
                    end
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
                    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
                    util.yield(2500)
                end, function()
                    entities.delete_by_handle(custom_pet)
                    custom_pet = nil
                end)

                FreedomAnimals:toggle_loop("Canadian Deer", {}, "", function()
                    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
                        local pet = util.joaat("a_c_deer")
                        Freedom.request_model(pet)
                        local pos = players.get_position(players.user())
                        custom_pet = entities.create_ped(28, pet, pos, 0)
                        PED.SET_PED_COMPONENT_VARIATION(custom_pet, 0, 0, 1, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
                    end
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
                    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
                    util.yield(2500)
                end, function()
                    entities.delete_by_handle(custom_pet)
                    custom_pet = nil
                end)

                FreedomAnimals:toggle_loop("German Shepherd", {}, "", function()
                    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
                        local pet = util.joaat("a_c_shepherd")
                        Freedom.request_model(pet)
                        local pos = players.get_position(players.user())
                        custom_pet = entities.create_ped(28, pet, pos, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
                    end
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
                    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
                    util.yield(2500)
                end, function()
                    entities.delete_by_handle(custom_pet)
                    custom_pet = nil
                end)

                FreedomAnimals:toggle_loop("iShowSpeed Favorite Animal", {}, "Yo bro, I just summoned iShowSpeed Monkey", function()
                    if not custom_pet or not ENTITY.DOES_ENTITY_EXIST(custom_pet) then
                        local pet = util.joaat("a_c_chimp")
                        Freedom.request_model(pet)
                        local pos = players.get_position(players.user())
                        custom_pet = entities.create_ped(28, pet, pos, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(custom_pet, true)
                    end
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(custom_pet)
                    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(custom_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
                    util.yield(2500)
                end, function()
                    entities.delete_by_handle(custom_pet)
                    custom_pet = nil
                end)

        ----========================================----
        ---              Vehicle Parts
        ---  The part of vebicle parts, impact much
        ----========================================----

            local FreedomCounters = FreedomVehicles:list("Countermeasures")
            local FreedomSpawners = FreedomVehicles:list("Vehicle Spawning")
            local FreedomDetection = FreedomVehicles:list("Radar Detections")
            local FreedomAPS = FreedomCounters:list("Trophy ADS")

            FreedomAPS:toggle("Trophy ADS", {"taps"}, "APS (Active Protection System), is a System that will Defend your Vehicle from Missles by Shooting them out of the Sky before they Hit you.\nBefore the machine works, you need to change the range slightly to have better efficient machine.", function(on)
                APS_charges = CMAPSCharges
                vehicle_APS = on
                mod_uses("object", if on then 1 else -1)
            end)
            
            CMAPSRange = 10
            FreedomAPS:slider("APS Range", {"tapsrange"}, "The Range at which APS will Destroy Incoming Projectiles.", 15, 100, 15, 5, function(value)
                CMAPSRange = value
            end)
            
            CMAPSCharges = 8
            FreedomAPS:slider("APS Charges", {"tapscharge"}, "Set the Amount of Charges / Projectiles the APS can Destroy before having to Reload.", 1, 100, 8, 1, function(value)
                CMAPSCharges = value
            end)
            
            CMAPSTimeout = 8000
            FreedomAPS:slider("APS Reload Time", {"tapsrt"}, "Set the Time, in Seconds, for how Long it takes the APS to Reload after Depleting all of its Charges. This is not after every Shot, just the Reload after EVERY Charge has been used.", 1, 100, 8, 1, function(value)
                local MultipliedTime = value * 1000
                CMAPSTimeout = MultipliedTime
            end)

            local turretPosition = 0
            local seat_id = -1
            local moved_seat = FreedomVehicles:slider("Move To Seat", {"freeseat"}, "Move to a different seat while in the vehicle.", 0, 0, 0, 1, function(value)
            if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
                seat_id = value - 1
                TASK.TASK_WARP_PED_INTO_VEHICLE(players.user_ped(), entities.get_user_vehicle_as_handle(), seat_id)
                else
                    FreedomNotify("\n".."You're not in a vehicle!")
                end
            end)
            
            menu.on_tick_in_viewport(moved_seat, function()
                if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
                local max_seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(entities.get_user_vehicle_as_handle()))
                    moved_seat.max_value = max_seats - 1
                else
                    moved_seat.max_value = 1
                    seat_id = -1
                end
            end)

            FreedomWarthog = FreedomVehicles:toggle_loop("A-10 Warthog Avenger", {}, "Only Works on the B-11. Makes the Cannon like how it is in Real Life, you could make BRRRTTT.\n\nNOTE: It will disable when you are not in B-11 Strikeforce.", function(on) -- Improvement about condition vehicle
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("strikeforce") then
                    local A10_while_using = entities.get_user_vehicle_as_handle()
                    local CanPos = ENTITY.GET_ENTITY_BONE_POSTION(A10_while_using, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(A10_while_using, "weapon_1a"))
                    local target = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(A10_while_using, 0, 175, 0)
                    if PAD.IS_CONTROL_PRESSED(114, 114) then
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(CanPos['x'], CanPos['y'], CanPos['z'], target['x']+math.random(-1,1), target['y']+math.random(-1,1), target['z']+math.random(-1,1), 100.0, true, 3800181289, players.user_ped(), true, false, 100.0)
                    end
                else
                    FreedomNotify("You have to be in a B-11 Strikeforce to use the feature.")
                    menu.trigger_command(FreedomWarthog, "off")
                end
            end)


            FreedomKhanjali = FreedomVehicles:toggle_loop("Khanjali Rapid Fire", {}, "", function()
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat("khanjali") then
                    VEHICLE.SET_VEHICLE_MOD(player_veh, 10, math.random(-1, 0), false)
                else
                    FreedomNotify("You have to be in a Khanjali to use the feature.")
                    menu.trigger_command(FreedomKhanjali, "off")
                end
            end)

            local ExplosiveHits = nil
            FreeWeap = FreedomVehicles:toggle_loop("Explosive Weapon Planes", {}, "Explosive Ammo to destroy everything with planes.", function()
                ExplosiveHits = menu.ref_by_path("Self>Weapons>Explosive Hits")
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                local ped = PLAYER.PLAYER_PED_ID()
                if PED.IS_PED_IN_ANY_PLANE(ped) and ENTITY.GET_ENTITY_MODEL(player_veh) then
                    menu.trigger_command(ExplosiveHits, "on")
                else
                    menu.trigger_command(ExplosiveHits, "off")
                    menu.trigger_command(FreeWeap, "off")
                    FreedomNotify("I'm sorry, you need to sit in every each plane using armored vehicle.")
                end
                end, function()
                if ExplosiveHits ~= nil then
                    menu.trigger_command(ExplosiveHits, "off")
                end
            end)
            
            FreedomCounters:toggle_loop("AC-130 Flares", {""}, "Spawns Flares Behind the Vehicle. Don't spam E button or flare will not appear correctly, entites contains +30 flares.\nCompatible vehicles: Titan, Bombushka, AC-130U Spooky (GTA5Mods)\n\nNOTE: Each 10 seconds running out, it will disable preventing false fire shot flares.", function(on)
                local specificPlanes = {"titan", "bombushka", "ac130u", "mc27us"} -- + Bonus if you want use AC-130U Spooky, required Regular to import (gta5mods)
                -- Link: https://www.gta5-mods.com/vehicles/ac-130u-spooky-ii-gunship-add-on-working-cannons (to have ac-130u better) - Optional
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())    
                if PAD.IS_CONTROL_PRESSED(46, 46) then
                    for _, plane in ipairs(specificPlanes) do
                        if ENTITY.GET_ENTITY_MODEL(player_veh) == util.joaat(plane) then
                            for i = 0, 750, 1 do 
                                local target = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, -2, -2)
                                local target2 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, -18, -2)
                                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target2['x'], target2['y'], target2['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                                local targetP = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -2, -2.0, 0)
                                local targetFG = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -3, -25.0, 0)
                                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP['x'], targetP['y'], targetP['z'], targetFG['x'], targetFG['y'], targetFG['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                                local targetP1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 2, -2.0, 0)
                                local targetFG1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 3, -25.0, 0)
                                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP1['x'], targetP1['y'], targetP1['z'], targetFG1['x'], targetFG1['y'], targetFG1['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                                util.yield(100)
                            end

                            FreedomNotify("Flares is ready to reload.\nEstimated time: 10 seconds.\nNOTE: Disabling and re-enable 'AC-130 Flares' will not become efficient.")
                            util.yield(10000)
                            FreedomNotify("Flares is ready to start.")
                        end
                    end
                end
            end)

            FreedomCounters:toggle_loop("Toggle Flares", {""}, "Spawns Flares Behind the Vehicle. Don't spam E button or flare will not appear correctly, entites contains +20 flares.\n\nNOTE: Each 15 seconds running out, it will disable preventing false fire shot flares.", function(on)
                if PAD.IS_CONTROL_PRESSED(46, 46) then
                    local ped = PLAYER.PLAYER_PED_ID()
                    if PED.IS_PED_IN_ANY_PLANE(ped) then
                        local targetP = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -2, -2.0, 0)
                        local targetFG = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -3, -25.0, 0)
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP['x'], targetP['y'], targetP['z'], targetFG['x'], targetFG['y'], targetFG['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                        local targetP1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 2, -2.0, 0)
                        local targetFG1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 3, -25.0, 0)
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP1['x'], targetP1['y'], targetP1['z'], targetFG1['x'], targetFG1['y'], targetFG1['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                        util.yield(300)

                        local targetP2 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -4, -2.0, 0)
                        local targetFG2 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -10, -20.0, -1)
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP2['x'], targetP2['y'], targetP2['z'], targetFG2['x'], targetFG2['y'], targetFG2['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                        local targetP3 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 4, -2.0, 0)
                        local targetFG3 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 10, -20.0, -1)
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP3['x'], targetP3['y'], targetP3['z'], targetFG3['x'], targetFG3['y'], targetFG3['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                        util.yield(300)

                        for i = 0, 4, 2 do
                            local targetP4 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -4, -2.0, 0)
                            local target2 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -10, -15.0, -1)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP4['x'], targetP4['y'], targetP4['z'], target2['x'], target2['y'], target2['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                            local targetP5 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 4, -2.0, 0)
                            local target3 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 10, -15.0, -1)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP5['x'], targetP5['y'], targetP5['z'], target3['x'], target3['y'], target3['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                            util.yield(300)
                        end

                        for i = 0, 6, 2 do
                            local targetP6 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -4, -2.0, 0)
                            local target4 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -10, -10.0, -1)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP6['x'], targetP6['y'], targetP6['z'], target4['x'], target4['y'], target4['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                            local targetP7 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 4, -2.0, 0)
                            local targetG = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 10, -10.0, -1)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(targetP7['x'], targetP7['y'], targetP7['z'], targetG['x'], targetG['y'], targetG['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 25.0)
                            util.yield(300)
                        end

                        FreedomNotify("Flares is ready to reload.\nEstimated time: 15 seconds.\nNOTE: Disabling and re-enable 'Toggle Flares' will not become efficient.")
                        util.yield(15000)
                        FreedomNotify("Flares is ready to start.")
                    end
                end
            end)

            FreedomSpawners:list_action("Preset Cars", {}, "", vehicleData, function(index)
                local hash = util.joaat(vehicleData[index])
                local ped = PLAYER.GET_PLAYER_PED()
                if not STREAMING.HAS_MODEL_LOADED(hash) then
                    load_model(hash)
                end
                local function upgrade_vehicle(vehicle)
                    if menu.get_value(FreedomSelfToggleUpgrade) == true then
                        for i = 0,49 do
                            local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                            VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                        end
                    else
                        VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                    end
                    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, menu.get_value(FreedomSelfPlateIndex))
    
                    if menu.get_value(FreedomSelfRandomPaint) == true then
                        local paintRand = math.random(0, 6)
                        local colorRand = math.random(0, 159)
                        local pearlRand = math.random(0, 159)
                        VEHICLE.SET_VEHICLE_MOD_COLOR_1(vehicle, paintRand, colorRand, pearlRand)
                        VEHICLE.SET_VEHICLE_MOD_COLOR_2(vehicle, paintRand, colorRand)
                    end
    
                    if FreedomSelfPlateName == nil then
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlate())
                    else
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomSelfPlateName)
                    end
                end
                local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 6.5, -1.0)
                local veh = entities.create_vehicle(hash, c, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
                upgrade_vehicle(veh)
                ENTITY.SET_ENTITY_INVINCIBLE(veh, menu.get_value(FreedomSelfToggleGod))
                VEHICLE.SET_VEHICLE_WINDOW_TINT(veh, menu.get_value(FreedomSelfWindowTint))
                request_control_of_entity(veh)
                local InvincibleStatus = menu.get_value(FreedomSelfToggleGod) and "Active" or "Inactive"
                local UpgradedCar = menu.get_value(FreedomSelfToggleUpgrade) and "Active" or "Inactive"
                if FreedomSelfPlateName == nil then
                    FreedomNotify("\n".."You have spawned: "..vehicleData[index].. " for yourself with the parameters: \n- Plate Name: "..FreedomPlate().."\n- Plate Color: "..menu.get_value(FreedomSelfPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomSelfWindowTint).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                else
                    FreedomNotify("\n".."You have spawned: "..vehicleData[index].. " for yourself with the parameters: \n- Plate Name: "..FreedomSelfPlateName.."\n- Plate Color: "..menu.get_value(FreedomSelfPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomSelfWindowTint).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                end
            end)

            FreedomSpawners:action("Spawn Vehicle", {"freesp"}, "", function(text)
                menu.show_command_box_click_based(text, "freesp ")
            end, function(arg)
                local hash = util.joaat(arg)
                local ped = PLAYER.GET_PLAYER_PED()
                if not STREAMING.HAS_MODEL_LOADED(hash) then
                    load_model(hash)
                end
                local function upgrade_vehicle(vehicle)
                    if menu.get_value(FreedomSelfToggleUpgrade) == true then
                        for i = 0,49 do
                            local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                            VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                        end
                    else
                        VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                    end
                    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, menu.get_value(FreedomSelfPlateIndex))

                    if menu.get_value(FreedomSelfRandomPaint) == true then
                        local paintRand = math.random(0, 6)
                        local colorRand = math.random(0, 159)
                        local pearlRand = math.random(0, 159)
                        VEHICLE.SET_VEHICLE_MOD_COLOR_1(vehicle, paintRand, colorRand, pearlRand)
                        VEHICLE.SET_VEHICLE_MOD_COLOR_2(vehicle, paintRand, colorRand)
                    end

                    if FreedomSelfPlateName == nil then
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlate())
                    else
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomSelfPlateName)
                    end
                end
                if STREAMING.IS_MODEL_A_VEHICLE(hash) then
                    local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 6.5, -1.0)
                    local veh = entities.create_vehicle(hash, c, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
                    upgrade_vehicle(veh)
                    ENTITY.SET_ENTITY_INVINCIBLE(veh, menu.get_value(FreedomSelfToggleGod))
                    VEHICLE.SET_VEHICLE_WINDOW_TINT(veh, menu.get_value(FreedomSelfWindowTint))
                    request_control_of_entity(veh)
                    local InvincibleStatus = menu.get_value(FreedomSelfToggleGod) and "Active" or "Inactive"
                    local UpgradedCar = menu.get_value(FreedomSelfToggleUpgrade) and "Active" or "Inactive"
                    if FreedomSelfPlateName == nil then
                        FreedomNotify("\n".."You have spawned: "..arg.. " for yourself with the parameters: \n- Plate Name: "..FreedomPlate().."\n- Plate Color: "..menu.get_value(FreedomSelfPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomSelfWindowTint).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    else
                        FreedomNotify("\n".."You have spawned: "..arg.. " for yourself with the parameters: \n- Plate Name: "..FreedomSelfPlateName.."\n- Plate Color: "..menu.get_value(FreedomSelfPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomSelfWindowTint).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    end
                else
                    FreedomNotify("The model named: "..arg.." is not recognized, please retry later.")
                end
            end)

            FreedomSpawners:text_input("Plate Name", {"freesplname"}, "Apply Plate Name when summoning vehicles.\nYou are not allowed to write more than 8 characters.", function(name)
                if name ~= "" then
                    FreedomSelfPlateName = name:sub(1, 8)
                else
                    FreedomSelfPlateName = nil
                end                    
            end)

            FreedomSelfToggleGod = FreedomSpawners:toggle_loop("Toggle Invincible Vehicle", {}, "", function() end)
            FreedomSelfToggleUpgrade = FreedomSpawners:toggle_loop("Toggle Upgrade Cars", {}, "", function()end)
            FreedomSelfRandomPaint = FreedomSpawners:toggle_loop("Toggle Random Paint", {}, "", function()end)
            FreedomSelfPlateIndex = FreedomSpawners:slider("Plate Color", {"freespc"}, "Choose Plate Color.", 0, 5, 0, 1, function()end)
            FreedomSelfWindowTint = FreedomSpawners:slider("Window Tint", {"freeswt"}, "Choose Window tint Color.", 0, 6, 0, 1, function()end)

            ----========================================----
            ---              Detection Options
            --- The part of online parts, become stealth
            ----========================================----

            local NoLockRadar = nil
            local StealthRadar = nil
            FreedomDetection:toggle_loop("Stealth Radar High Altitude", {}, "Only works for plane.\nEnable/Disable OTR when the aircraft reaches a certain altitude.", function()
                StealthRadar = menu.ref_by_path("Online>Off The Radar")
                NoLockRadar = menu.ref_by_path("Vehicle>Can't Be Locked On")
                local altitude = 1050 -- Cruise Altitude
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                local ped = PLAYER.PLAYER_PED_ID()
                if PED.IS_PED_IN_ANY_PLANE(ped) and ENTITY.GET_ENTITY_MODEL(player_veh) then
                    local plane = PED.GET_VEHICLE_PED_IS_USING(ped)
                    if ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(plane) > altitude then
                        HUD.TOGGLE_STEALTH_RADAR(true)
                        menu.trigger_command(StealthRadar, "on")
                        menu.trigger_command(NoLockRadar, "on")
                    else
                        HUD.TOGGLE_STEALTH_RADAR(false)
                        menu.trigger_command(StealthRadar, "off")
                        menu.trigger_command(NoLockRadar, "off")
                    end
                end
                end, function()
                if StealthRadar ~= nil and NoLockRadar ~= nil then
                    HUD.TOGGLE_STEALTH_RADAR(false)
                    menu.trigger_command(StealthRadar, "off")
                    menu.trigger_command(NoLockRadar, "off")
                end
            end)

            FreedomDetection:toggle_loop("Stealth Radar Optimal Altitude", {}, "Only works for plane.\nEnable/Disable OTR when the aircraft reaches a certain altitude.", function()
                StealthRadar = menu.ref_by_path("Online>Off The Radar")
                NoLockRadar = menu.ref_by_path("Vehicle>Can't Be Locked On")
                local highaltitude = 1550 -- High altitude while leaving the stealth zone
                local lowAltitude = 50 -- Low Altitude might be detected
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                local ped = PLAYER.PLAYER_PED_ID()
                if PED.IS_PED_IN_ANY_PLANE(ped) and ENTITY.GET_ENTITY_MODEL(player_veh) then
                    local plane = PED.GET_VEHICLE_PED_IS_USING(ped)
                    if ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(plane) <= highaltitude and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(plane) >= lowAltitude then
                        HUD.TOGGLE_STEALTH_RADAR(true)
                        menu.trigger_command(StealthRadar, "on")
                        menu.trigger_command(NoLockRadar, "on")
                    else
                        HUD.TOGGLE_STEALTH_RADAR(false)
                        menu.trigger_command(StealthRadar, "off")
                        menu.trigger_command(NoLockRadar, "off")
                    end
                end
                end, function()
                if StealthRadar ~= nil and NoLockRadar ~= nil then
                    HUD.TOGGLE_STEALTH_RADAR(false)
                    menu.trigger_command(StealthRadar, "off")
                    menu.trigger_command(NoLockRadar, "off")
                end
            end)

            local LowestRadar = nil
            FreedomDetection:toggle_loop("Stealth Radar Low Altitude", {}, "Only works for plane and helicopters.\nEnable/Disable OTR when the aircraft/helicopters reaches a certain altitude.", function()
                LowestRadar = menu.ref_by_path("Online>Off The Radar")
                NoLockRadar = menu.ref_by_path("Vehicle>Can't Be Locked On")
                local altitude = 75 -- Lowest altitude which can be undetected.
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                local ped = PLAYER.PLAYER_PED_ID()
                if PED.IS_PED_IN_ANY_PLANE(ped) or PED.IS_PED_IN_ANY_HELI(ped) and ENTITY.GET_ENTITY_MODEL(player_veh) then
                    local plane = PED.GET_VEHICLE_PED_IS_USING(ped)
                    if ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(plane) < altitude then
                        HUD.TOGGLE_STEALTH_RADAR(true)
                        menu.trigger_command(LowestRadar, "on")
                        menu.trigger_command(NoLockRadar, "on")
                    else
                        HUD.TOGGLE_STEALTH_RADAR(false)
                        menu.trigger_command(LowestRadar, "off")
                        menu.trigger_command(NoLockRadar, "off")
                    end
                end
                end, function()
                if StealthRadar ~= nil and NoLockRadar ~= nil then
                    HUD.TOGGLE_STEALTH_RADAR(false)
                    menu.trigger_command(LowestRadar, "off")
                    menu.trigger_command(NoLockRadar, "off")
                end
            end)

            FreedomDetection:toggle_loop("Car Stealth Radar", {}, "Only works for ground vehicles.", function()
                OTR = menu.ref_by_path("Online>Off The Radar")
                local altitude = 5 -- Allow only ground vehicles which can able to fly
                local altitudeBike = 75 -- Allow only ground bikes (Oppressor1/MK2 and others bikes) vehicles which can able to fly
                local player_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
                local ped = PLAYER.PLAYER_PED_ID()
                if PED.IS_PED_ON_ANY_BIKE(ped) and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(PED.GET_VEHICLE_PED_IS_USING(ped)) < altitudeBike then 
                    HUD.TOGGLE_STEALTH_RADAR(true)
                    menu.trigger_command(OTR, "on")
                elseif PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_IN_ANY_HELI(ped) and not PED.IS_PED_IN_ANY_PLANE(ped) and ENTITY.GET_ENTITY_MODEL(player_veh) then
                    if ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(PED.GET_VEHICLE_PED_IS_USING(ped)) < altitude then -- Disable while using Deluxo or Scramjet or every else
                        HUD.TOGGLE_STEALTH_RADAR(true)
                        menu.trigger_command(OTR, "on")
                    else
                        HUD.TOGGLE_STEALTH_RADAR(false)
                        menu.trigger_command(OTR, "off")
                    end
                else
                    HUD.TOGGLE_STEALTH_RADAR(false)
                    menu.trigger_command(OTR, "off")
                end
            end, function()
                if OTR ~= nil then
                    HUD.TOGGLE_STEALTH_RADAR(false)
                    menu.trigger_command(OTR, "off")
                end
            end)

        ----========================================----
        ---              Online Session
        ---   The part of online parts, much impact
        ----========================================----

            local FreedomExclude = FreedomOnline:list("Exclude Options", {}, "Applicable for all features like: \n- Session Options \n- Vehicle Options \n- Teleport Options")
            local FreedomSessionL = FreedomOnline:list("Session Options")
            local FreedomLVehicles = FreedomOnline:list("Vehicle Options")
            local FreedomTeleports = FreedomOnline:list("Teleport Options")

            local FreedomToggleS = true
            local FreedomToggleF = true
            
            local function toggleSelfCallback(toggle)
                FreedomToggleS = not toggle
            end
            
            local function toggleFriendCallback(toggle)
                FreedomToggleF = not toggle
            end

            FreedomExclude:toggle("Exclude Self", {"feself"}, "Exclude Self for using these features.\nIncludes: \n- Session Options \n- Vehicle Options \n- Teleport Options", toggleSelfCallback)
            FreedomExclude:toggle("Exclude Friends", {"fefriend"}, "Exclude Friends for using these features.\nIncludes: \n- Session Options \n- Vehicle Options \n- Teleport Options", toggleFriendCallback)

            ----========================================----
            ---              Vehicle Options
            ---   The part of online parts, vehicles
            ----========================================----

                FreedomLVehicles:list_action("Preset Cars", {}, "", vehicleData, function(index)
                    local hash = util.joaat(vehicleData[index])
                    local function upgrade_vehicle(vehicle)
                        if menu.get_value(FreedomToggleCar) == true then
                            for i = 0,49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        else
                            VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                        end
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, menu.get_value(FreedomPlateIndex))
                        if FreedomPlateName == nil then
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlate())
                        else
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlateName)
                        end
                    end
                    if not STREAMING.HAS_MODEL_LOADED(hash) then
                        load_model(hash)
                    end
                    for k,v in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(v)
                        local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 6.5, -1.0)
                        local veh = entities.create_vehicle(hash, c, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
                        upgrade_vehicle(veh)
                        ENTITY.SET_ENTITY_INVINCIBLE(veh, menu.get_value(FreedomToggleGod))
                        VEHICLE.SET_VEHICLE_WINDOW_TINT(veh, menu.get_value(FreedomTintWindow))
                        request_control_of_entity(veh)
                    end
                    local InvincibleStatus = menu.get_value(FreedomToggleGod) and "Active" or "Inactive"
                    local UpgradedCar = menu.get_value(FreedomToggleCar) and "Active" or "Inactive"
                    if FreedomPlateName == nil then
                        FreedomNotify("\n".."You have spawned: "..vehicleData[index].. " for everyone with the parameters: \n- Plate Name: "..FreedomPlate().." (Randomized)".."\n- Plate Color: "..menu.get_value(FreedomPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomTintWindow).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    else
                        FreedomNotify("\n".."You have spawned: "..vehicleData[index].. " for everyone with the parameters: \n- Plate Name: "..FreedomPlateName.."\n- Plate Color: "..menu.get_value(FreedomPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomTintWindow).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    end
                end)

                FreedomLVehicles:action("Spawn Vehicle", {"freedomspawn"}, "Spawn everyone a vehicle.\nNOTE: It will applied also some modification like Plate License (name/color)", function (click_type)
                    menu.show_command_box_click_based(click_type, "freedomspawn ")
                end,
                function (txt)
                    local hash = util.joaat(txt)
                    
                    if not STREAMING.HAS_MODEL_LOADED(hash) then
                        load_model(hash)
                    end
                    local function upgrade_vehicle(vehicle)
                        if menu.get_value(FreedomToggleCar) == true then
                            for i = 0,49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        else
                            VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                        end
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, menu.get_value(FreedomPlateIndex))
                        if FreedomPlateName == nil then
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlate())
                        else
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlateName)
                        end
                    end
                    for k,v in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                        if STREAMING.IS_MODEL_A_VEHICLE(hash) then
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(v)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                            local vehicle = entities.create_vehicle(hash, c, 0)
                            ENTITY.SET_ENTITY_INVINCIBLE(vehicle, menu.get_value(FreedomToggleGod))
                            VEHICLE.SET_VEHICLE_WINDOW_TINT(vehicle, menu.get_value(FreedomTintWindow))
                            upgrade_vehicle(vehicle)
                            request_control_of_entity(vehicle)
                        else
                            FreedomNotify("The model named: "..txt.." is not recognized, please retry later.")
                        end
                        wait()
                    end
                    local InvincibleStatus = menu.get_value(FreedomToggleGod) and "Active" or "Inactive"
                    local UpgradedCar = menu.get_value(FreedomToggleCar) and "Active" or "Inactive"
                    if FreedomPlateName == nil then
                        FreedomNotify("\n".."You have spawned: "..txt.. " for everyone with the parameters: \n- Plate Name: "..FreedomPlate().." (Randomized)".."\n- Plate Color: "..menu.get_value(FreedomPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomTintWindow).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    else
                        FreedomNotify("\n".."You have spawned: "..txt.. " for everyone with the parameters: \n- Plate Name: "..FreedomPlateName.."\n- Plate Color: "..menu.get_value(FreedomPlateIndex).."\n- Window Tint: "..menu.get_value(FreedomTintWindow).."\n- Invincible Status: "..InvincibleStatus.."\n- Upgrade Status: "..UpgradedCar)
                    end
                end)

                FreedomLVehicles:text_input("Plate Name", {"fplatename"}, "Apply Plate Name when summoning vehicles.\nNOTE: It will also too apply to 'Friendly' spawning vehicles.\nYou are not allowed to write more than 8 characters.\nNOTE: It will applicable for 'Friendly'.", function(name)
                    if name ~= "" then
                        FreedomPlateName = name:sub(1, 8)
                    else
                        FreedomPlateName = nil
                    end                    
                end)

                FreedomPlateIndex = FreedomLVehicles:slider("Plate Color", {"fplatecol"}, "Choose Plate Color.\nNOTE: It will applicable for 'Friendly'.", 0, 5, 0, 1, function()end)

                FreedomToggleGod = FreedomLVehicles:toggle_loop("Toggle Invincible Vehicle", {}, "", function() end)
                FreedomToggleCar = FreedomLVehicles:toggle_loop("Toggle Upgrade Cars", {}, "", function()end)
                FreedomTintWindow = FreedomLVehicles:slider("Window Tint", {""}, "Choose Window tint Color.\nNOTE: It will applicable for 'Friendly'.", 0, 6, 0, 1, function()end)

            ---------------------------------------------------------------------------------------------------------------------

            FreedomOnline:toggle_loop("Disable RP Gain", {}, "Disable while earning RP.",function()
                memory.write_float(memory.script_global(262145 + 1),0)
            end,function()
                memory.write_float(memory.script_global(262145 + 1),1)
            end)

            local Fconfig = {
                disable_traffic = true,
                disable_peds = true,
            }

            local pop_multiplier_id

            FreedomOnline:toggle("Toggle No Traffic", {}, "Toggle On/Off Traffic if NPC are driving.\nNOTE: It will not clearly affects nearby players who drive.\nChanging the session will revert back Normal Traffic NPC.", function(on)
                if on then
                    local ped_sphere, traffic_sphere
                    if Fconfig.disable_peds then ped_sphere = 0.0 else ped_sphere = 1.0 end
                    if Fconfig.disable_traffic then traffic_sphere = 0.0 else traffic_sphere = 1.0 end
                    pop_multiplier_id = MISC.ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0, ped_sphere, traffic_sphere, false, true)
                    MISC.CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
                else
                    MISC.REMOVE_POP_MULTIPLIER_SPHERE(pop_multiplier_id, false);
                end
            end)

        ----========================================----
        ---              Teleport Features
        ---   The part of online parts, teleports
        ----========================================----

                FreedomTPNumb = FreedomTeleports:slider("Choose Apartment Location", {"faptnum"}, "Refer to Player List where to teleport Apartment", 1, 114, 1, 1, function()end)

                FreedomTPWarning = FreedomTeleports:action("Teleport Location", {"fapt"}, "Teleport the entire session?\nAlternative to Stand Features but may not karma you.\n\nToggle 'Exclude Self' to avoid using these functions.",function(type)
                    menu.show_warning(FreedomTPWarning, type, "Do you really want teleport the entire session to the same apartment location?\nNOTE: Teleporting all players will cost a fight against players.", function()
                        for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                            if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" then
                                menu.trigger_commands("apt"..menu.get_value(FreedomTPNumb)..players.get_name(pid))
                            end
                        end
                    end)
                end)

                FreedomTP1Warning = FreedomTeleports:action("Near Location Teleport", {"ftpnlt"}, "Teleport the entire session?\nAlternative to Stand Features but may not karma you.\n\nToggle 'Exclude Self' to avoid using these functions.",function(type)
                    menu.show_warning(FreedomTP1Warning, type, "Do you really want teleport the entire session to the same apartment location?\nNOTE: Teleporting all players will cost a fight against players.", function()
                        for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                            if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" then
                                menu.trigger_commands("aptme"..players.get_name(pid))
                            end
                        end
                    end)
                end)
                
                FreedomTP2Warning = FreedomTeleports:action("Random Teleport Homogenous", {'ftpho'}, "Teleport the entire session into random apartment homogenously?\nAlternative to Stand Features but may not karma you.\n\nToggle 'Exclude Self' to avoid using these functions.", function(type)
                    menu.show_warning(FreedomTP2Warning, type, "Do you really want teleport the entire session to the random apartment?\nNOTE: Teleporting all players will cost a fight against players.", function()
                    local FreedomAPTRand = RandomGenerator(1, 114)
                        for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                            if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" then
                                menu.trigger_commands("apt"..FreedomAPTRand..players.get_name(pid))
                            end
                        end
                    end)
                end)

                FreedomTP3Warning = FreedomTeleports:action("Random Teleport Heterogenous", {'ftphe'}, "Teleport each player in the session to a random apartment heterogeneously?\nAlternative to Stand Features but may not karma you.\n\nToggle 'Exclude Self' to avoid using these functions.", function(click)
                    menu.show_warning(FreedomTP3Warning, click, "Do you really want teleport the entire session to the random apartment heterogeneously?\nNOTE: Teleporting all players will not really cost a fight against players.", function()
                    local assignedApartments = {}
                        for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                            if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" then
                                local FreedomAPTRand
                                repeat
                                    FreedomAPTRand = RandomGenerator(1, 114)
                                until not assignedApartments[FreedomAPTRand]
                    
                                assignedApartments[FreedomAPTRand] = true
                                menu.trigger_commands("apt"..FreedomAPTRand..players.get_name(pid))
                            end
                        end
                    end)
                end)

        ----========================================----
        ---              Session Players
        ---   The part of online parts, teleports
        ----========================================----
                    
            FreedomSessionL:toggle_loop("Auto Kick Host Token Users", {}, "Kick automatically users while using 'Aggressive', 'Sweet Spot' or 'Handicap' features which can be nuisible and destroy and control the entire session.", function()
                local commands = {"breakup", "ban", "kick", "confusionkick", "nonhostkick", "pickupkick"}
                for _, pid in pairs(players.list(false, FreedomToggleF, true)) do --adding false because it will affect self while using host token.
                    local SpoofToken = players.get_host_token_hex(pid)
                    local isSpoofToken
                    if string.sub(SpoofToken, 1, 4) == "FFFF" then
                        isSpoofToken = "Handicap"
                        for _, command in ipairs(commands) do
                            menu.trigger_commands(command..players.get_name(pid))
                            FreedomNotify("\n"..players.get_name(pid).." is using "..isSpoofToken.."\n".."User has been force breakup(ed).")
                        end
                    elseif string.sub(SpoofToken, 1, 4) == "0021" then
                        local tokenValue = tonumber(string.sub(SpoofToken, 5, 8), 16)
                        if tokenValue and tokenValue >= 16 and tokenValue <= 37 then
                            isSpoofToken = "Sweet Spot"
                            for _, command in ipairs(commands) do
                                menu.trigger_commands(command..players.get_name(pid))
                                FreedomNotify("\n"..players.get_name(pid).." is using "..isSpoofToken.."\n".."User has been force breakup(ed).")
                            end
                        end
                    elseif string.sub(SpoofToken, 1, 4) == "0000" then
                        isSpoofToken = "Aggressive"
                        for _, command in ipairs(commands) do
                            menu.trigger_commands(command..players.get_name(pid))
                            FreedomNotify("\n"..players.get_name(pid).." is using "..isSpoofToken.."\n".."User has been force breakup(ed).")
                        end
                    end
                end
            end)

            FreedomSessionL:toggle_loop("No Russian in the Session", {}, "Breakup all annoying russians.\nWARNING: You might be karma if you leave the 'No Russian in the Session' option on too long.", function()
                local commands = {"breakup", "kick"}
                local kick_time = 0
                for players.list(false, false, true) as pid do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    util.yield(10)
                    kick_time += 1
                    local languageIndex = players.get_language(pid)
                        if languageIndex == 7 then
                            kick_time += 1
                            util.yield(15)
                            if kick_time >= 3 and not players.get_name(pid) ~= "UndiscoveredPlayer" then
                                for _, command in ipairs(commands) do
                                    menu.trigger_commands(command .. players.get_name(pid))
                                end
                                repeat
                                    util.yield()
                                until pid ~= nil
                                kick_time = 0
                            end
                        end
                    end
                end, function()
            end)

            local explosion_circle_angle = 0
            FreedomSessionL:toggle_loop("Gas Chamber Mode", {}, "", function()
                for k,v in pairs(players.list(false, true, true)) do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(v)
                    explosion_circle(ped, explosion_circle_angle, 5)
                end
            
                explosion_circle_angle += 0.3
                util.yield(250)
            end)

            FreedomSessionL:toggle_loop('Restrict Fly Zone', {'fflyzone'}, "Forces all players in air born vehicles into the ground.", function()
                for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                    local FPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local FreedomVehPed = PED.GET_VEHICLE_PED_IS_IN(FPid, false)
                    if ENTITY.IS_ENTITY_IN_AIR(FreedomVehPed) then
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(FreedomVehPed)
                        ENTITY.APPLY_FORCE_TO_ENTITY(FreedomVehPed, 5, 0, 0, -0.8, 0, 0, 0.5, 0, false, false, true)
                        ENTITY.APPLY_FORCE_TO_ENTITY(FreedomVehPed, 1, 0, 0, -0.8, 0, 0, 0.5, 0, false, false, true)
                    end
                end
            end)

            FreedomSessionL:toggle_loop("Pretend God Mode", {"fgll"}, "This is not the real god mode, you shoot (he's not invincible), but if you fight with fist, it will consider Invincible.\n\nNOTE: It may detected like 'attacking while invulnerable' if your friend or your foe attack, be careful.",function()
                for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                    local playerPed = PLAYER.GET_PLAYER_PED(pid)
                    if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" and not PLAYER.GET_PLAYER_INVINCIBLE(playerPed) then
                        ENTITY.SET_ENTITY_INVINCIBLE(playerPed, true)
                        PLAYER.SET_PLAYER_INVINCIBLE(playerPed, true)
                    else
                        ENTITY.SET_ENTITY_INVINCIBLE(playerPed, false)
                        PLAYER.SET_PLAYER_INVINCIBLE(playerPed, false)
                    end
                end
            end)

            FreedomSessionL:toggle_loop("Camera Moving", {'fcms'}, "Moving, shake with the hardest force in the session.\n\nToggle 'Exclude Self' to avoid using these features", function()
                for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                    local playerPed = players.get_name(pid)
                    if FreedomSession() and players.get_name(pid) ~= "UndiscoveredPlayer" then
                        CameraMoving(playerPed, 50000)
                    end
                end
            end)

            local timerStarted = false
            FreedomNukeWarning = FreedomSessionL:action("Freedom Special Nuke", {"fnuke"}, "I love Joe Biden.\nIt will not applicable for 'Friends' or 'Self' Features.", function(type)
                menu.show_warning(FreedomNukeWarning, type, "Do you really want send nuke button to all players.", function()
                    if not timerStarted then
                        timerStarted = true
                        local countdownSeconds = 10
                        FreedomPlaySound(join_path(script_store_freedom_songs, "FortunateSon.wav"), SND_FILENAME | SND_ASYNC)
                        local function playWarningSound()
                            Freedom.play_all("5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 500)
                        end
                        for i = countdownSeconds, 1, -1 do
                            local delay = i > 2 and i % 2 == 1 and 125 or 500
                            playWarningSound(delay)
                            FreedomNotify("Ready to Explode?\n"..i.." seconds to detonate.")
                            util.yield(delay + 750)
                        end
                        FreedomNotify("Detonation Ready, you are ready to nuke the session.")
                        Freedom.play_all("Air_Defences_Activated", "DLC_sum20_Business_Battle_AC_Sounds", 3000)
                        for i = 0, 31 do
                            if NETWORK.NETWORK_IS_PLAYER_CONNECTED(i) then
                                local ped = PLAYER.GET_PLAYER_PED(i)
                                local playerCoords = ENTITY.GET_ENTITY_COORDS(ped)
                                PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, true)
                                PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(ped, true)
                                PED.SET_PED_CONFIG_FLAG(ped, 32, false)
                                PED.SET_PED_CONFIG_FLAG(ped, 223, false)
                                PED.SET_PED_CONFIG_FLAG(ped, 224, false)
                                PED.SET_PED_CONFIG_FLAG(ped, 228, false)

                                local ped = PLAYER.GET_PLAYER_PED(i)
                                ENTITY.SET_ENTITY_INVINCIBLE(ped, false)
                                PLAYER.SET_PLAYER_INVINCIBLE(ped, false)

                                FIRE.ADD_EXPLOSION(playerCoords.x, playerCoords.y, playerCoords.z + 1, 59, 1, true, false, 1.0, false)
                                while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                                    STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                                    GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
                                    GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", playerCoords.x, playerCoords.y, playerCoords.z + 1, 0, 180, 0, 1.0, true, true, true)
                                    kill_player(i)
                                    passive_mode_kill(i)
                                end
                            end
                        end
                        Freedom.explode_all(EARRAPE_FLASH, 0, 150)
                        util.yield(250)
                        Freedom.explode_all(EARRAPE_BED)
                        Freedom.explode_all(EARRAPE_NONE)
                        local playersKilled = 0
                        for i = 0, 31 do
                            if NETWORK.NETWORK_IS_PLAYER_CONNECTED(i) then
                                local ped = PLAYER.GET_PLAYER_PED(i)
                                local health = ENTITY.GET_ENTITY_HEALTH(ped)
                                if health <= 0 then
                                    playersKilled = playersKilled + 1
                                end
                                kill_player(i)
                            end
                        end
                    if playersKilled == 0 then
                        FreedomNotify("Detonation complete!\nNo one has been eliminated.")
                    else
                        FreedomNotify("Detonation complete!\n"..playersKilled.." player(s) has been eliminated.")
                    end
                        timerStarted = false
                    else
                        FreedomNotify("I'm sorry but the timer has already started.")
                    end
                    FreedomPlaySound(join_path(script_store_freedom_stop, "stop.wav"), SND_FILENAME | SND_ASYNC)
                end)
            end)

            BreakupForceHost = FreedomSessionL:action("Breakup Host", {}, "Breakup players position until become host.",function(type) --skid from akatozi
                if FreedomSession() then
                    if players.get_host() ~= players.user() then
                        local players_before_host = players.get_host_queue_position(players.user())
                        menu.show_warning(BreakupForceHost, type, "Warning: You are about to kick around".." "..players_before_host.." ".."players until you become host. Are you sure ?", function()
                            if FreedomSession() then
                                while players.get_host() ~= players.user() do
                                    local host = players.get_host()
                                    if players.exists(host) then
                                        menu.trigger_commands("breakup"..players.get_name(host))
                                    end
                                    util.yield(50)
                                end
                                FreedomNotify("\n".."You are host.")
                            end
                        end)
                    else
                        FreedomNotify("\n".."You are already host.".."\n".."Please try later.")
                    end
                end
            end)

            FreedomSessionL:action("Kill All Players", {}, "Kill all players without using explosion.\nToggle only 'Friends' Features to avoid abusing these features.", function() -- player is not affected
                for k,v in pairs(players.list(false, FreedomToggleF, true)) do
                    kill_player(v)
                    util.yield()
                end
            end)

        ----========================================----
        ---              World Parts
        ---   The part of worlds parts, useless
        ----========================================----

            local freeGunVans = {
                {v3.new(-30.691593170166016, 6440.61181640625, 31.46271514892578), "Gunvan 1 (Paleto Bay)"},
                {v3.new(1708.04541015625,4818.873046875,42.020225524902344), "Gunvan 2 (Grapeseed)"},
                {v3.new(1799.9373779296875,3901.3955078125,34.05502700805664), "Gunvan 3 (Sandy Shores)"},
                {v3.new(1339.3294677734375,2758.759765625,51.40709686279297), "Gunvan 4 (Grand Senora Desert 'Part 1')"},
                {v3.new(785.4343872070313,1214.0382080078125,336.1535949707031), "Gunvan 5 (Vinewood Hills)"},
                {v3.new(-3195.79150390625,1059.0968017578125,20.859222412109375), "Gunvan 6 (Chumash)"},
                {v3.new(-797.0811157226563,5404.021484375,34.05730438232422), "Gunvan 7 (Paleto Forest)"},
                {v3.new(-17.769180297851563,3054.6484375,41.4296875), "Gunvan 8 (Zancudo River)"},
                {v3.new(2667.525634765625,1469.25537109375,24.50077247619629), "Gunvan 9 (Palmer Taylor Station)"},
                {v3.new(-1455.878662109375,2669.613525390625,17.643640518188477), "Gunvan 10 (Lago Zancudo Bridge)"},
                {v3.new(2347.800537109375,3052.162841796875,48.184085845947266), "Gunvan 11 (Grand Senora Desert 'Part 2')"},
                {v3.new(1513.4649658203125,-2143.073486328125,76.97412872314453), "Gunvan 12 (El Burrito Heights)"},
                {v3.new(1156.6365966796875,-1359.7158203125,34.70103454589844), "Gunvan 13 (Murrieta Heights)"},
                {v3.new(-58.51665115356445,-2651.006103515625,6.0007123947143555), "Gunvan 14 (Elysian Island)"},
                {v3.new(1906.2650146484375,560.096923828125,175.74546813964844), "Gunvan 15 (Tataviam Mountains)"},
                {v3.new(966.0137939453125,-1711.8599853515625,30.243873596191406), "Gunvan 16 (La Mesa)"},
                {v3.new(795.4525756835938,-3271.485595703125,5.900516033172607), "Gunvan 17 (Terminal Port)"},
                {v3.new(-582.546142578125,-1640.6015625,19.550588607788086), "Gunvan 18 (La Puerta)"},
                {v3.new(734.7702026367188,-733.7327880859375,26.44579315185547), "Gunvan 19 (La Mesa 'Part 2')"},
                {v3.new(-1689.081787109375,-448.0471496582031,40.953269958496094), "Gunvan 20 (Del Perro)"},
                {v3.new(-1322.4208984375,-1164.1304931640625,4.779491901397705), "Gunvan 21 (Vespucci / Magellan Ave)"},
                {v3.new(-501.4334716796875,50.08109664916992,56.49615478515625), "Gunvan 22 (West Vinewood)"},
                {v3.new(273.6707763671875,72.75302124023438,99.89118194580078), "Gunvan 23 (Downtown Vinewood)"},
                {v3.new(258.6902160644531,-753.9094848632813,34.63716125488281), "Gunvan 24 (Pillbox Hill)"},
                {v3.new(-473.2128,-738.3798,30.56298), "Gunvan 25 (Little Seoul)"},
                {v3.new(904.8756103515625,3607.78564453125,32.81423568725586), "Gunvan 26 (Alamo Sea)"},
                {v3.new(-2164.646484375,4280.94091796875,48.957191467285156), "Gunvan 27 (North Chumash)"},
                {v3.new(1464.5263671875,6554.38525390625,14.094414710998535), "Gunvan 28 (Mount Chiliad)"},
                {v3.new(1099.485107421875,-331.3899841308594,67.20771789550781), "Gunvan 29 (Mirror Park)"},
                {v3.new(155.89004516601563,-1649.0552978515625,29.291664123535156), "Gunvan 30 (Davis)"},
            }

            local freeLandmarks = {
                {v3.new(-1028.3832, -2735.1409, 13.756649), "Airport Entrance"},
                {v3.new(-1170.4204, 4926.473, 224.33012), "Altruist Camp"},
                {v3.new(-520.25476, 4436.8955, 89.79521), "Calafia Train Bridge"},
                {v3.new(928.1053, -2878.5774, 19.012945), "Cargo Ship"},
                {v3.new(3411.0686, 3755.0962, 30.101265), "Humane Labs"},
                {v3.new(-2243.81, 264.048, 174.61525), "Kortz Center"},
                {v3.new(2121.7, 4796.3, 41.108337), "McKenzie Airfield"},
                {v3.new(486.43237, -3339.7036, 6.0699167), "Merryweather Dock"},
                {v3.new(464.54227, 5568.8213, 790.4641), "Mount Chiliad"},
                {v3.new(2532.4246, -383.2167, 92.99277), "N.O.O.S.E Headquarters"},
                {v3.new(1746.9985, 3273.6802, 41.14016), "Sandy Shores Airfield"},
                {v3.new(760.4, -2943.2, 5.800333), "Terminal Jetsam"},
                {v3.new(2208.6907, 5578.223, 53.736073), "Weed Farm"},
                {v3.new(2353.8342, 1830.2937, 101.169365), "Wind Farm"}
            }

            local freeUnderwaters = {
                {"Hatch", v3.new(4283.7285, 2963.618, -182.20798), ""},
                {"Panzer II Tank", v3.new(4201.7407, 3644.483, -38.688774), "I love Nazis"},
                {"Sea Monster", v3.new(-3373.7266, 504.7183, -24.418417), ""},
                {"Sunken Cargo Ship", v3.new(3194.2065, -366.6386, -19.867027), ""},
                {"Sunken Plane", v3.new(-943.3077, 6609.274, -20.725874), ""}
            }
            
            local freeInteriors = {
                {"Comedy Club", v3.new(379.33194, -1002.38336, -98.99994)},
                {"Floyd's House", v3.new(-1151.8948, -1517.4011, 10.632715)},
                {"FIB Bureau (RAID)", v3.new(149.68756, -741.0188, 254.15218)},
                {"FIB Interior Rooftop", v3.new(121.159454, -740.33936, 258.152)},
                {"Franklin's House (Interior)", v3.new(-2.8133092, 529.7468, 176.06947)},
                {"Franklin's House (Room)", v3.new(2.1897643, 525.6434, 171.30257)},
                {"IAA Office", v3.new(124.21153, -618.8245, 206.04698)},
                {"Mineshaft", v3.new(-593.2174, 2080.1958, 131.39897)},
                {"Michael's House", v3.new(-813.04065, 179.86508, 72.15916)},
                {"Motel Room", v3.new(152.21722, -1001.37317, -99.00002)},
                {"Pacific Standard Vault Room", v3.new(255.99345, 217.02151, 101.683556)},
                {"Safe Room Space (AFK Only)", v3.new(-155.31094, -969.80676, 219.12654)},
                {"Torture Room", v3.new(142.746, -2201.189, 4.6918745)},
                {"Trevor's House (Sandy Shores)", v3.new(1973.6528, 3817.9497, 33.436283)},
                {"Vanilla Unicorn Office", v3.new(97.55246, -1290.9927, 29.268766)},
                {"Zancudo Control Tower", v3.new(-2356.094, 3248.645, 101.45063)}
            }

            local freeEssentials = {
                {
                    "Ammu-Nation",
                    v3.new(14.729667, -1130.4623, 28.38218),
                    v3.new(811.5394, -2136.2268, 29.298626),
                    v3.new(1703.9557, 3749.8425, 34.06373),
                    v3.new(235.26694, -42.48556, 69.696236),
                    v3.new(844.6901, -1018.00684, 27.545353),
                    v3.new(-325.35016, 6068.0625, 31.279776),
                    v3.new(-664.4737, -949.35846, 21.533388),
                    v3.new(-1325.7206, -386.22247, 36.602425),
                    v3.new(-1110.5096, 2685.986, 18.646143),
                    v3.new(-3159.859, 1079.9518, 20.694046),
                    v3.new(2570.869, 310.5462, 108.461),
                },
                {
                    "Arena War",
                    v3.new(-374.40808, -1856.8129, 20.299635)
                },
                {
                    "Barber Shop",
                    v3.new(-828.62286, -188.61504, 37.62003),
                    v3.new(129.84355, -1714.4921, 29.236816),
                    v3.new(-1292.8214, -1117.3197, 6.628836),
                    v3.new(1935.2532, 3717.9526, 32.385254),
                    v3.new(1200.9613, -468.50922, 66.28133),
                    v3.new(-30.15244, -141.15417, 57.041813),
                    v3.new(-286.0247, 6235.8604, 31.465664),
                },
                {
                    "Benny's Motor Works",
                    v3.new(-221.68788, -1303.7201, 30.783205)
                },
                {
                    "Clothing Store",
                    v3.new(-151.23697, -305.93384, 38.308353),
                    v3.new(413.63574, -805.7931, 29.316673),
                    v3.new(-813.3747, -1087.347, 10.947831),
                    v3.new(-1207.3555, -783.1656, 17.088503),
                    v3.new(618.20264, 2739.6418, 41.92529),
                    v3.new(129.76231, -201.78064, 54.51178),
                    v3.new(-3165.1697, 1062.4639, 20.83883),
                    v3.new(85.45275, -1392.5825, 29.255098),
                    v3.new(1681.4573, 4822.2695, 42.062),
                    v3.new(-1091.7141, 2700.7275, 19.632227),
                    v3.new(1197.4186, 2697.1492, 37.936787),
                    v3.new(-2.4914842, 6519.3267, 31.465714),
                    v3.new(-719.6272, -158.39229, 37.000366),
                    v3.new(-1459.5343, -227.91628, 49.196167),
                },
                {
                    "Diamond Casino",
                    v3.new(917.64594, 50.39213, 80.40586)
                },
                {
                    "Eclipse Towers",
                    v3.new(-793.00836, 294.89856, 85.34387)
                },
                {
                    "Fort Zancudo Airbase/Airfield",
                    v3.new(-1544.4578, 2751.5488, 17.777958),
                },
                {
                    "Los Santos Customs",
                    v3.new(-383.23624, -123.49709, 38.19501),
                    v3.new(-1134.1277, -1988.4802, 13.183585),
                    v3.new(708.4548, -1080.1211, 22.401926),
                    v3.new(1174.5228, 2653.681, 38.145153),
                },
                {
                    "Los Santos Car Meet",
                    v3.new(782.53174, -1893.9546, 28.654327)
                }
            }
            

            local FreedomTeleports = FreedomWorld:list("Teleports")

            local FreedomLandmarks = FreedomTeleports:list("Landmarks", {}, "", function()end)  -- Landmarks
            for _, freeLandmarks in ipairs(freeLandmarks) do
                FreedomLandmarks:action(freeLandmarks[2], {}, "", function()
                    local UserPos = freeLandmarks[1] or nil
                    ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                end)
            end

            local FreedomUnderwaters = FreedomTeleports:list("Underwaters", {}, "", function()end)  -- Underwaters
            for _, freeUnderwaters in ipairs(freeUnderwaters) do
                FreedomUnderwaters:action(freeUnderwaters[1], {}, freeUnderwaters[3], function()
                    local UserPos = freeUnderwaters[2] or nil
                    ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                end)
            end

            local FreedomInteriors = FreedomTeleports:list("Interiors", {}, "Can may your ped instantly die.", function()end)  -- Interiors
            for _, freeInteriors in ipairs(freeInteriors) do
                FreedomInteriors:action(freeInteriors[1], {}, "", function()
                    local UserPos = freeInteriors[2] or nil
                    ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                end)
            end

            local FreedomEssentials = FreedomTeleports:list("Essentials Locations", {}, "", function()end)  -- Interiors
            for _, freeEssential in ipairs(freeEssentials) do
                local UserPos = nil
                FreedomEssentials:action(freeEssential[1], {}, "", function()
                    if #freeEssential > 2 then
                        local teleportIndex = math.random(#freeEssential - 2) 
                        UserPos = freeEssential[teleportIndex + 2]
                    elseif #freeEssential == 2 then
                        UserPos = freeEssential[2]
                    else
                        UserPos = freeEssential[1]
                    end
                    ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                end)
            end                

            FreedomTeleports:divider("Others")
            local FreedomGunVans = FreedomTeleports:list("Gunvan Locations", {}, "", function()end) -- Gun Van
            for _, freeGunVans in ipairs(freeGunVans) do
                FreedomGunVans:action(freeGunVans[2], {}, "", function()
                    local UserPos = freeGunVans[1] or nil
                    ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                end)
            end

        ----========================================----
        ---              Twin Towers Parts
        ---   The part of worlds parts, useless
        ----========================================----

            local positions = {
                {v3.new(125.72, -1146.2, 222.75), v3.new(286.49008, -1007.72217, 90.0402), {"Boeing 747 appears at Pilbox Hill (North)"}}, -- North 1
                {v3.new(118.13, -365.5, 213.06), v3.new(246.32755, -285.16418, 68.83013), {"Boeing 747 appears at Alta (South East)"}}, -- South East 2
                {v3.new(-126.54, -508.41, 226.35), v3.new(-151.16615, -276.66415, 81.63583), {"Boeing 747 appears at Vinewood (East)"}}, -- East 3
                {v3.new(368.63, -656.42, 199.41), v3.new(590.4069, -607.59656, 41.821896), {"Boeing 747 appears at Textile City/Strawberry Ave (South West)"}}, -- South West 4
                {v3.new(486.79584, -836.7407, 201.24078), v3.new(460.1325, -1097.1022, 43.075542), {"Boeing 747 appears at Textile City (West)"}},  -- West 5
                {v3.new(324.71548, -60.498875, 232.9209), v3.new(313.43738, -60.363735, 153.29718), {"Boeing 747 appears at Hawick (South)"}}, -- South 6
                {v3.new(-875.4278, -191.15733, 260.2907), v3.new(-491.05692, -335.17578, 96.19807), {"Boeing 747 appears at Rockford Hills (East)"}}, -- East 7
                {v3.new(578.16266, -443.25204, 205.79388), v3.new(712.1099, -243.52017, 67.47418), {"Boeing 747 appears at Alta (South West)"}}, -- South West 8
            }
            
            local orientations = {
                v3.new(0, 0, -3), -- North 1
                v3.new(0, 10, -180), -- South East 2
                v3.new(10, 0, -118), -- East 3
                v3.new(10, 0, -244), -- South West 4
                v3.new(10, 0, -285), -- West 5
                v3.new(10, 0, -200), -- South 6
                v3.new(10, 0, -113), -- East 7
                v3.new(10, 0, -244), -- South West 8
            }

            local currentPosition = math.random(#positions)
            local isAssisting = false
            local toggleSong
            local isCooldown = false
            local lastTimeUsed = 0
            local warnlists = false
            FreeTwinTowers = FreedomWorld:list("Twin Towers", {}, "", function()
                if warnlists then
                    warnlists = true
                    return
                end
                menu.show_warning(FreeTwinTowers, CLICK_MENU, "Do not laugh or you will send to the hell.\nIt's a warning, don't do that for praying for victims, don't laugh.", function()
                    warnlists = true
                    menu.trigger_command(FreeTwinTowers, "")
                end)
            end)

            FreeTimerTowers = FreeTwinTowers:slider("Cooldown Duration", {"freettcoold"}, "", 15, 600, 15, 1, function()end)
            FreeTwinTowers:toggle("Toggle Teleport 'Twin Towers'", {}, "Toggle while teleporting House to assist 9/11 Crash Planes\n\n- Enable: you will be automatically teleported.\n- Disable: you will not be automatically teleported.", function(toggle) isAssisting = toggle end)
            FreeTwinTowers:toggle("Toggle Sound for 'Twin Towers'", {}, "Toggle while using song House for 9/11 Crash Planes\n\n- Enable: you will hear the sound (local).\n- Disable: you will not be able to hear the sound (local).", function(toggle) toggleSong = toggle end)
            FreeTwinTowers:action("Twin Towers Boeing", {}, "Send Boeing to Twin Towers but you have each interval which you cannot spam more plane.\n\nNostalgic 9/11 but watch this.\n'Toggle Invincible Vehicle' can may be toggle (Find on Online > Vehicle Options)\n\nBeware, some planes can cross the Twin Towers, be very careful. Do not abuse the features.", function()
                local cooldownTime = menu.get_value(FreeTimerTowers)
                if isAssisting then
                    local UserPos = positions[currentPosition] and positions[currentPosition][2] or nil
                    if UserPos then
                        ENTITY.SET_ENTITY_COORDS(players.user_ped(), UserPos.x, UserPos.y, UserPos.z)
                    end
                end
                if toggleSong then
                    FreedomPlaySound(join_path(script_store_911_songs, "911.wav"), SND_FILENAME | SND_ASYNC)
                end
                musicStartTime = os.clock()
                local hash = util.joaat("jet")
                load_model(hash)
                while not STREAMING.HAS_MODEL_LOADED(hash) do
                    util.yield()
                end
                local currentTime = os.time()
                local elapsedTime = currentTime - lastTimeUsed
                if not isCooldown or elapsedTime >= cooldownTime then
                    isCooldown = true
                    lastTimeUsed = currentTime
                    
                    if positions[currentPosition] ~= nil then
                        local pos = positions[currentPosition][1]
                        local orient = orientations[currentPosition]
            
                        local boeing = entities.create_vehicle(hash, pos, orient.z)
                        ENTITY.SET_ENTITY_INVINCIBLE(boeing, menu.get_value(FreedomToggleGod))
            
                        local speed = currentPosition == 1 and 850.0 or 650.0
                        VEHICLE.SET_VEHICLE_FORWARD_SPEED(boeing, speed)
                        VEHICLE.SET_VEHICLE_MAX_SPEED(boeing, speed)
            
                        if currentPosition > 0 then
                            ENTITY.SET_ENTITY_ROTATION(boeing, orient.x, orient.y, orient.z, 2, false)
                            VEHICLE.SET_HELI_BLADES_SPEED(boeing, 0)
                            if positions[currentPosition][3] then
                                local str = table.concat(positions[currentPosition][3])
                                FreedomNotify(str)
                            end
                        end
            
                        VEHICLE.CONTROL_LANDING_GEAR(boeing, 3)
                    end
            
                    currentPosition = math.random(#positions + 1)
                    while os.clock() - musicStartTime < 11 do
                        util.yield()
                    end
                    FreedomPlaySound(join_path(script_store_freedom_stop, "stop.wav"), SND_FILENAME | SND_ASYNC)
                    isCooldown = false
                else
                    local remainingTime = cooldownTime - elapsedTime
                    if remainingTime >= 60 then
                        local minutes = math.floor(remainingTime / 60)
                        local seconds = math.floor(remainingTime % 60)
                        local pluralMinutes = minutes > 1 and "s" or ""
                        local pluralSeconds = seconds > 1 and "s" or ""
                        FreedomNotify("Please wait " .. minutes .. " minute" .. pluralMinutes .. " and " .. seconds .. " second" .. pluralSeconds .. " to start again.")
                    else
                        local plural = remainingTime > 1 and "s" or ""
                        local seconds = math.floor(remainingTime)
                        FreedomNotify("Please wait " .. seconds .. " second" .. plural .. " to start again.")
                    end
                    FreedomPlaySound(join_path(script_store_freedom_stop, "stop.wav"), SND_FILENAME | SND_ASYNC)
                    isAssisting = false
                end
            end)

            local posCas = 
            {
                v3.new(618.32416, 43.211624, 105.66624), 
                v3.new(1171.9432, -95.993965, 105.080505),
                v3.new(733.55536, -308.09018, 118.84326),
                v3.new(896.63477, 314.4733, 113.98827),
            }
            local oriTCas = 
            {
                v3.new(0, 0, -88), 
                v3.new(0, 0, 60),
                v3.new(0, 0, -34),
                v3.new(0, 0, -173)
            }
            local lastPosition = math.random(#posCas)
            
            FreedomWorld:action("Send Boeing to Casino", {}, "Recommended for blocking roads on the casino.", function()
                local hash = util.joaat("jet")
                load_model(hash)
                while not STREAMING.HAS_MODEL_LOADED(hash) do
                    util.yield()
                end
                local currentPosition = math.random(#posCas)
                while currentPosition == lastPosition do
                    currentPosition = math.random(#posCas)
                end
                lastPosition = currentPosition
            
                local pos = posCas[currentPosition]
                local orient = oriTCas[currentPosition]
            
                local boeing = entities.create_vehicle(hash, pos, orient.z)
                ENTITY.SET_ENTITY_INVINCIBLE(boeing, menu.get_value(FreedomToggleGod))
            
                local speed = currentPosition == 1 and 850.0 or 500.0
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(boeing, speed)
                VEHICLE.SET_VEHICLE_MAX_SPEED(boeing, speed)
            
                if currentPosition > 1 then
                    ENTITY.SET_ENTITY_ROTATION(boeing, orient.x, orient.y, orient.z, 2, false)
                    VEHICLE.SET_HELI_BLADES_SPEED(boeing, 0)
                end
            
                VEHICLE.CONTROL_LANDING_GEAR(boeing, 3)
                wait()
            end)

            FreedomWorld:action("Blow up your vehicle", {}, "Destroy your own car while using, previous car or current car.\n\nNOTE: Without Godmode, you will instantly die with explosion or burnt-out vehicle.", function()
                local vehicle = entities.get_user_vehicle_as_handle()
                if vehicle ~= 0 then
                    RequestControl(vehicle)
                    VEHICLE.EXPLODE_VEHICLE_IN_CUTSCENE(vehicle)
                end
            end)

            FreedomWorld:action("Blow up nearby vehicles", {}, "It will guaranteed burning all vehicles Specific Personal Vehicles.\n\nNOTE: It will affect players while driving and can burn, die easily.", function()
                for _, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
                    if vehicle ~= entities.get_user_personal_vehicle_as_handle() then
                        RequestControl(vehicle)
                        VEHICLE.EXPLODE_VEHICLE_IN_CUTSCENE(vehicle)
                    end
                end
            end)

    ----========================================----
    ---              Miscs Part
    ---   The part of miscs parts, useless but..
    ----========================================----

        FreedomMiscs:divider("Settings")

        local FreedomOtherMiscs = FreedomMiscs:list("Others Features")

        NotifMode = "Stand"
        FreedomMiscs:list_select("Notify Mode", {}, "", {"Stand", "Help Message"}, 1, function(selected_mode)
            NotifMode = selected_mode
        end)

        ToggleNotify = true
        FreedomMiscs:toggle("Toggle Notify", {}, "", function(on)
            util.yield()
            ToggleNotify = on
        end, true)

        FreedomMiscs:readonly("Script Version", FreedomSVersion)
        FreedomMiscs:divider("Credits & Others")
        FreedomMiscs:action("StealthyAD", {}, "", function()end)
        FreedomMiscs:hyperlink("Github Page", "https://github.com/StealthyAD")
        FreedomMiscs:action("Check for Updates", {}, "The script will automatically check for updates at most daily, but you can manually check using this option anytime.", function()
        auto_update_config.check_interval = 0
            if auto_updater.run_auto_update(auto_update_config) then
                FreedomNotify("\n".."No updates found.")
            end
        end)
    
        FreedomMiscs:action("Clean Reinstall", {}, "Force an update to the latest version, regardless of current version.", function()
            auto_update_config.clean_reinstall = true
            auto_updater.run_auto_update(auto_update_config)
        end)

        FreedomOtherMiscs:divider("Money Features")
        local money_delay = 1
        FreedomOtherMiscs:slider("Delay Money", {"freerdelay"}, "Money delay", 1, 10000, 1, 1, function(s)
            money_delay = s
        end)

        local money_amt = 30000000
        FreedomOtherMiscs:slider("Amount of Money", {"freermoney"}, "Money amount", int_min, int_max, 30000000, 1, function(s)
            money_amt = s
        end)

        local money_random = false
        FreedomOtherMiscs:toggle("Random Money", {}, "Randomize money amount", function(on)
            money_random = on
        end)

        FreedomOtherMiscs:toggle_loop("Toggle Fake Money", {}, "Make yourself rich or become poor.", function(on)
            local amt
            if money_random then
                amt = math.random(100000000, int_max)
            else
                amt = money_amt
            end
            HUD.CHANGE_FAKE_MP_CASH(amt, amt)
            util.yield(money_delay)
        end)

        FreedomOtherMiscs:divider("Other Features")
        local FreedomAlert = FreedomOtherMiscs:list("Fake Alert")
        FreedomOtherMiscs:toggle_loop("Toggle Skip Cutscene", {}, "Skip automatically cutscene", function() CUTSCENE.STOP_CUTSCENE_IMMEDIATELY() end)
        FreedomOtherMiscs:toggle("Block Phone Calls", {""}, "Blocks incoming phones calls", function(state)
            local phone_calls = menu.ref_by_command_name("nophonespam")
            phone_calls.value = state
        end)

        FreedomOtherMiscs:toggle("Display Money", {}, "", function(toggle)
            if toggle then
                HUD.SET_MULTIPLAYER_WALLET_CASH()
                HUD.SET_MULTIPLAYER_BANK_CASH()
            else
                HUD.REMOVE_MULTIPLAYER_WALLET_CASH()
                HUD.REMOVE_MULTIPLAYER_BANK_CASH()
            end
        end)

        FreedomOtherMiscs:toggle_loop("Toggle Radar/HUD", {}, "", function()
            HUD.DISPLAY_RADAR(false)
            HUD.DISPLAY_HUD(false)
        end, function()
            HUD.DISPLAY_RADAR(true)
            HUD.DISPLAY_HUD(true)
        end)

        ----========================================----
        ---              Fake Alert Part
        ---     The part of miscs alerts, useless
        ----========================================----

            FreedomAlert:action("Custom Alert Suspension", {"fsusalert"}, "Put the fake alert of your choice. (Write the date like that: 'February 24 2022')", function()
                FreedomSus = menu.show_command_box("fsusalert ")
            end, function(on_command)
                show_custom_rockstar_alert("You have been suspended from Grand Theft Auto Online until "..on_command..".~n~In addition, your Grand Theft Auto Online character(s) will be reset.~n~Return to Grand Theft Auto V.")
            end)

            FreedomAlert:action("Ban Message", {"ffakebanp"}, "A Fake Ban Message.", function()
                show_custom_rockstar_alert("You have been banned from Grand Theft Auto Online permanently.~n~Return to Grand Theft Auto V.")
            end)
            
            FreedomAlert:action("Services Unavailable", {"freefakesu"}, "A Fake 'Servives Unavailable' Message.", function()
                show_custom_rockstar_alert("The Rockstar Game Services are Unavailable right now.~n~Please Return to Grand Theft Auto V.")
            end)

            FreedomAlert:action("Case Support", {"fcasesupport"}, "A Fake 'Support Channel' Message.", function()
                show_custom_rockstar_alert("Remember, if you find this, this is not the Support Channel.~n~Return to Grand Theft Auto V.")
            end)
            
            FreedomAlert:action("Custom Alert", {"ffakecustomalert"}, "Put the fake alert of your choice.", function()
                menu.show_command_box("ffakecustomalert ")
            end, function(on_command)
                show_custom_rockstar_alert(on_command)
            end)

    ----========================================----
    ---              Player Options
    ---   The part of players parts, useful but
    ---   we are ready to make raaaaaaaahhhhhhhh
    ----========================================----

        players.on_join(function(pid)
            local FreedomPlayer = menu.player_root(pid)
            local FreedomPName = players.get_name(pid)

                FreedomPlayer:divider("FreedomScript "..FreedomSVersion)
                local FreedomScriptP = FreedomPlayer:list("FreedomScript Tools")
                local FreedomInfoPlayers = FreedomScriptP:list("Informations")
                local FreedomFriendly = FreedomScriptP:list("Friendly")
                local FreedomNeutral = FreedomScriptP:list("Neutral")
                local FreedomTrolling = FreedomScriptP:list("Trolling")

            ----========================================----
            ---              Friendly Options
            ---   The part of players parts, useful but
            ---   we are ready to be friendly okay?
            ----========================================----

                FreedomFriendly:toggle("Toggle Infinite Ammo", {}, "Put Infinite ammo to "..FreedomPName..", able to shoot x times without reloading.\nI'm not sure if the function works to players.\n\nNOTE: Don't use the feature if it's against players.", function(toggle)
                    if FreedomSession() and toggle then
                        local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        WEAPON.SET_PED_INFINITE_AMMO_CLIP(playerPed, true)
                    else
                        WEAPON.SET_PED_INFINITE_AMMO_CLIP(playerPed, false)
                    end
                end)

                FreedomFriendly:action("Spawn Vehicle", {"fspawn"}, "", function (click_type)
                menu.show_command_box_click_based(click_type, "fspawn" .. FreedomPName .. " ")end,
                function(txt)
                    local hash = util.joaat(txt)
                    local function platechanger(vehicle)
                        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, menu.get_value(FreedomPlateIndex))
                        if FreedomPlateName == nil then
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlate())
                        else
                            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, FreedomPlateName)
                        end
                    end
                    local function upgradecar(vehicle)
                        if menu.get_value(FreedomToggleCar) == true then
                            for i = 0,49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        else
                            VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                        end
                    end
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                    if not STREAMING.HAS_MODEL_LOADED(hash) then
                        load_model(hash)
                    end
                    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
                        local vehicle = entities.create_vehicle(hash, c, 0)
                        ENTITY.SET_ENTITY_INVINCIBLE(vehicle, menu.get_value(FreedomToggleCar))
                        VEHICLE.SET_VEHICLE_WINDOW_TINT(vehicle, menu.get_value(FreedomTintWindow))
                        platechanger(vehicle)
                        upgradecar(vehicle)
                        request_control_of_entity(vehicle)
                        FreedomNotify("\n".."You have spawned: "..txt.. " for " ..FreedomPName)
                    else
                        FreedomNotify("The model named: "..txt.." is not recognized, please retry later.")
                    end
                end)

                FreedomFriendly:action("Spawn Liberator", {"freelib"}, "", function ()
                    local function upgradecar(vehicle)
                        if menu.get_value(FreedomToggleCar) == true then
                            for i = 0,49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        else
                            VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                        end
                    end
                    local function give_lib(pid)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                    local hash = util.joaat("monster")
                    if not STREAMING.HAS_MODEL_LOADED(hash) then
                        load_model(hash)
                    end
                    local liberator = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                    VEHICLE.SET_VEHICLE_WINDOW_TINT(liberator, menu.get_value(FreedomTintWindow))
                    ENTITY.SET_ENTITY_INVINCIBLE(liberator, menu.get_value(FreedomToggleGod))
                        upgradecar(liberator)
                    end
                    give_lib(pid)
                    util.yield()
                end)

                FreedomFriendly:action("Spawn A-10 Warthog", {"freea10"}, "", function ()
                    local function upgradecar(vehicle)
                        if menu.get_value(FreedomToggleCar) == true then
                            for i = 0,49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        else
                            VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                        end
                    end
                    local function give_warthog(pid)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 11.5, 0.0)
                    local hash = util.joaat("strikeforce")
                    if not STREAMING.HAS_MODEL_LOADED(hash) then
                        load_model(hash)
                    end
                    local warthogs = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                    VEHICLE.SET_VEHICLE_WINDOW_TINT(warthogs, menu.get_value(FreedomTintWindow))
                    ENTITY.SET_ENTITY_INVINCIBLE(warthogs, menu.get_value(FreedomToggleGod))
                        upgradecar(warthogs)
                    end
                    give_warthog(pid)
                    util.yield()
                end)

            ----========================================----
            ---            Neutral Options
            ---   The part of players parts, useful but
            ---     we are ready to be neutral.
            ----========================================----

                FreedomNeutral:action("Detection Language", {"flang"}, "", function()
                    if FreedomSession() then
                        local languageList = {"English/or non-recognized language", "French", "German", "Italian", "Spanish", "Portuguese/Brazilian", "Polish", "Russian", "Korean", "Chinese (Taiwan)", "Japanese", "Spanish (Mexican)", "Chinese (Mainland China)"}
                        local languageIndex = players.get_language(pid)
                        if languageIndex >= 0 and languageIndex <= 12 then
                            FreedomNotify(FreedomPName .. " is " .. languageList[languageIndex + 1]..".")
                        end
                    end
                end)

                local godmodeMessageDisplayed = false
                FreedomNeutral:action("Godmode Detection", {"fdgod"}, "", function()
                    if players.is_godmode(pid) then
                        if players.is_in_interior(pid) then
                            if not godmodeMessageDisplayed then
                                FreedomNotify("\n"..FreedomPName.." is in Godmode.".."\n".."But "..FreedomPName.." is in interior.")
                                godmodeMessageDisplayed = true
                            end
                        else
                            if not godmodeMessageDisplayed then
                                FreedomNotify("\n"..FreedomPName.." is in Godmode.")
                                godmodeMessageDisplayed = true
                            end
                        end
                    else
                        FreedomNotify("\n"..FreedomPName.." is not in Godmode.")
                        godmodeMessageDisplayed = false
                    end
                end)

                FreedomNeutral:action("Flag Host Token", {"fflagtoken"}, "Detect if someone uses spoof host token.", function()
                    local tokenTypes = {
                        ["FFFF"] = "Handicap",
                        ["0000"] = "Aggressive",
                    }
                    for i=16,37 do
                        local hex = string.format("%04X", i)
                        tokenTypes[hex] = "Sweet Spot"
                    end
                    local spoofToken = players.get_host_token_hex(pid)
                    local spoofType = tokenTypes[string.sub(spoofToken, 1, 4)] or "Unconfirmed"
                    FreedomNotify("\n"..FreedomPName.." is "..(spoofType ~= "Unconfirmed" and "using "..spoofType.." " or "not using Spoof Host Token."))
                end)
                
                ----========================================----
                ---            Trolling Options
                ---   The part of players parts, useful but
                ---     we are ready to troll everyone okay?
                ----========================================----

                    local spawned_objects = {}
                    local FreedomCage = FreedomTrolling:list("Cage Options")
                    local FreedomCongestion = FreedomTrolling:list("Vehicle Congestion", {}, "What is Vehicle Congestion?\nIt will saturate the session while spamming manually vehicle.")

                    FreedomCage:action("Normal Cage", {}, "", function()
                        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        if not PED.IS_PED_IN_ANY_VEHICLE(player_ped) then
                            local modelHash = util.joaat("prop_gold_cont_01")
                            local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
                            local obj = Create_Network_Object(modelHash, pos.x, pos.y, pos.z)
                            ENTITY.FREEZE_ENTITY_POSITION(obj, true)
                        end
                    end)

                    FreedomCage:action("Electric Cage", {}, "Same as Cage but if he tries to move, he will gonna eletrocute himself.", function(on_click)
                        SpawnObjects = {}
                        get_vtable_entry_pointer = function(address, index)
                            return memory.read_long(memory.read_long(address) + (8 * index))
                        end
                        local FTotalCage = 6
                        local FElectricBox = util.joaat("prop_elecbox_12")
                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        local pos = ENTITY.GET_ENTITY_COORDS(ped)
                        pos.z = pos.z - 0.5
                        SendRequest(FElectricBox)
                        local temp_v3 = v3.new(0, 0, 0)
                        for i = 1, FTotalCage do
                            local angle = (i / FTotalCage) * 360
                            temp_v3.z = angle
                            local obj_pos = temp_v3:toDir()
                            obj_pos:mul(2.5)
                            obj_pos:add(pos)
                            for offs_z = 1, 5 do
                                local ElecCages = entities.create_object(FElectricBox, obj_pos)
                                SpawnObjects[#SpawnObjects + 1] = ElecCages
                                ENTITY.SET_ENTITY_ROTATION(ElecCages, 90.0, 0.0, angle, 2, 0)
                                obj_pos.z = obj_pos.z + 0.75
                                ENTITY.FREEZE_ENTITY_POSITION(ElecCages, true)
                            end
                        end
                    end)

                    FreedomCage:action("Container Box", {}, "Same as Cage, but container, we will remove his weapon for life.", function()
                        SpawnObjects = {}
                        get_vtable_entry_pointer = function(address, index)
                            return memory.read_long(memory.read_long(address) + (8 * index))
                        end
                        local ContainerBox = util.joaat("prop_container_ld_pu")
                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        local pos = ENTITY.GET_ENTITY_COORDS(ped)
                        SendRequest(ContainerBox)
                        pos.z = pos.z - 1
                        local Container = entities.create_object(ContainerBox, pos, 0)
                        SpawnObjects[#SpawnObjects + 1] = container
                        ENTITY.FREEZE_ENTITY_POSITION(Container, true)
                        WEAPON.REMOVE_ALL_PED_WEAPONS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
                        menu.trigger_commands("disarm"..FreedomPName)
                    end)

                    FreedomCage:action("Coffin Cage",{},"",function()
                        local number_of_cages = 6
                        local coffin_hash = util.joaat("prop_coffin_02b")
                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        local pos = ENTITY.GET_ENTITY_COORDS(ped)
                        Freedom.request_model(coffin_hash)
                        local temp_v3 = v3.new(0, 0, 0)
                        for i = 1, number_of_cages do
                            local angle = (i / number_of_cages) * 360
                            temp_v3.z = angle
                            local obj_pos = temp_v3:toDir()
                            obj_pos:mul(0.8)
                            obj_pos:add(pos)
                            obj_pos.z += 0.1
                        local coffin = entities.create_object(coffin_hash, obj_pos)
                        spawned_objects[#spawned_objects + 1] = coffin
                        ENTITY.SET_ENTITY_ROTATION(coffin, 90.0, 0.0, angle,  2, 0)
                        ENTITY.FREEZE_ENTITY_POSITION(coffin, true)
                        end
                    end)

                    FreedomTrolling:toggle_loop("Camera Moving",{'fcam'}, "You really want put camera moving "..FreedomPName.." ?\nNOTE: It may be detected by player and may possible karma you if he's a modder.",function()
                        if FreedomSession() then
                            if FreedomPName then
                                CameraMoving(pid, 99999)
                            end
                        end
                    end)

                    FreedomTrolling:toggle_loop("Loop Passive Kill", {"fpassivekillp"}, "", function()
                        FreedomPassive(pid)
                    end)

                    FreedomTrolling:action("Silent Kill", {"fsilentkill"}, "", function()
                        FreedomSilent(pid)
                    end)

                    FreedomTrolling:action("Freedom Airstrike", {"freestrike"}, "", function()
                        local pidPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                        local abovePed = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(pidPed, 0, 0, 8)
                        local missileCount = RandomGenerator(16, 24)
                        for i=1, missileCount do
                            local missileOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(pidPed, math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(abovePed.x, abovePed.y, abovePed.z, missileOffset.x, missileOffset.y, missileOffset.z, 100, true, 1752584910, 0, true, false, 250)
                        end
                    end)

                    FreedomTrolling:action_slider("Send Plane", {}, "Call the Plane to send "..FreedomPName.." to die.\n\nBOEING IS THE FASTEST PLANE EVER THAN SHITTY PLANES.", {"Boeing 747","F-16 Falcon","Antonov AN-225"}, function(select)
                        if select == 1 then
                            local function upgrade_vehicle(vehicle)
                                if menu.get_value(FreedomToggleCar) == true then
                                    for i = 0,49 do
                                        local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                        VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                                    end
                                else
                                    VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                                end
                            end
        
                            local function summon_entity_face(entity, targetplayer, inclination)
                                local pos1 = ENTITY.GET_ENTITY_COORDS(entity, false)
                                local pos2 = ENTITY.GET_ENTITY_COORDS(targetplayer, false)
                                local rel = v3.new(pos2)
                                rel:sub(pos1)
                                local rot = rel:toRot()
                                if not inclination then
                                    ENTITY.SET_ENTITY_HEADING(entity, rot.z)
                                else
                                    ENTITY.SET_ENTITY_ROTATION(entity, rot.x, rot.y, rot.z, 2, false)
                                end
                            end
        
                            local function GiveSPlane(pid)
                                local targetID = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                                local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(targetID, 0.0, 0, 200.0)
                            
                                local hash = util.joaat("jet")
                            
                                if not STREAMING.HAS_MODEL_LOADED(hash) then
                                    load_model(hash)
                                end
                            
                                local boeing = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(targetID))
                                ENTITY.SET_ENTITY_INVINCIBLE(boeing, menu.get_value(FreedomToggleGod))
                                summon_entity_face(boeing, targetID, true)
                                VEHICLE.SET_VEHICLE_FORWARD_SPEED(boeing, 1000.0)
                                VEHICLE.SET_VEHICLE_MAX_SPEED(boeing, 1000.0)
                                VEHICLE.CONTROL_LANDING_GEAR(boeing, 3)
                                upgrade_vehicle(boeing)
                            end
                            if FreedomSession() then
                                if FreedomPName then
                                    GiveSPlane(pid)
                                    wait()
                                end
                            end
                        elseif select == 2 then
                            local function upgrade_vehicle(vehicle)
                                if menu.get_value(FreedomToggleCar) == true then
                                    for i = 0,49 do
                                        local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                        VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                                    end
                                else
                                    VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                                end
                            end
        
                            local function summon_entity_face(entity, targetplayer, inclination)
                                local pos1 = ENTITY.GET_ENTITY_COORDS(entity, false)
                                local pos2 = ENTITY.GET_ENTITY_COORDS(targetplayer, false)
                                local rel = v3.new(pos2)
                                rel:sub(pos1)
                                local rot = rel:toRot()
                                if not inclination then
                                    ENTITY.SET_ENTITY_HEADING(entity, rot.z)
                                else
                                    ENTITY.SET_ENTITY_ROTATION(entity, rot.x, rot.y, rot.z, 2, false)
                                end
                            end
        
                            local function GiveSPlane(pid)
                                local targetID = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                                local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(targetID, 0.0, 40, 125.0)
                            
                                local hash = util.joaat("lazer")
                            
                                if not STREAMING.HAS_MODEL_LOADED(hash) then
                                    load_model(hash)
                                end
                            
                                local lazersuicide = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(targetID))
                                ENTITY.SET_ENTITY_INVINCIBLE(lazersuicide, menu.get_value(FreedomToggleGod))
                                summon_entity_face(lazersuicide, targetID, true)
                                VEHICLE.SET_VEHICLE_FORWARD_SPEED(lazersuicide, 540.0)
                                VEHICLE.SET_VEHICLE_MAX_SPEED(lazersuicide, 540.0)
                                VEHICLE.CONTROL_LANDING_GEAR(lazersuicide, 3)
                                upgrade_vehicle(lazersuicide)
                            end
                            if FreedomSession() then
                                if FreedomPName then
                                    GiveSPlane(pid)
                                    wait()
                                end
                            end
                        else
                            local function upgrade_vehicle(vehicle)
                                if menu.get_value(FreedomToggleCar) == true then
                                    for i = 0,49 do
                                        local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                        VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                                    end
                                else
                                    VEHICLE.SET_VEHICLE_MOD(vehicle, 0, 0 - 1, true)
                                end
                            end
        
                            local function summon_entity_face(entity, targetplayer, inclination)
                                local pos1 = ENTITY.GET_ENTITY_COORDS(entity, false)
                                local pos2 = ENTITY.GET_ENTITY_COORDS(targetplayer, false)
                                local rel = v3.new(pos2)
                                rel:sub(pos1)
                                local rot = rel:toRot()
                                if not inclination then
                                    ENTITY.SET_ENTITY_HEADING(entity, rot.z)
                                else
                                    ENTITY.SET_ENTITY_ROTATION(entity, rot.x, rot.y, rot.z, 2, false)
                                end
                            end
        
                            local function GiveSPlane(pid)
                                local targetID = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                                local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(targetID, 0.0, 0, 200.0)
                            
                                local hash = util.joaat("cargoplane")
                            
                                if not STREAMING.HAS_MODEL_LOADED(hash) then
                                    load_model(hash)
                                end
                            
                                local cargoplane = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(targetID))
                                ENTITY.SET_ENTITY_INVINCIBLE(cargoplane, menu.get_value(FreedomToggleGod))
                                summon_entity_face(cargoplane, targetID, true)
                                VEHICLE.SET_VEHICLE_FORWARD_SPEED(cargoplane, 1000.0)
                                VEHICLE.SET_VEHICLE_MAX_SPEED(cargoplane, 1000.0)
                                VEHICLE.CONTROL_LANDING_GEAR(cargoplane, 3)
                                upgrade_vehicle(cargoplane)
                            end
                            if FreedomSession() then
                                if FreedomPName then
                                    GiveSPlane(pid)
                                    wait()
                                end
                            end
                        end
                    end)

                ----========================================----
                ---            Vehicle Congestion
                ---   The part of players parts, useful but
                ---   saturate the enemy lines with vehicle
                ----========================================----

                    local FreedomSpam = 250
                    FreedomCongestion:action("Summon Kosatka", {"freekosatka"}, "Spawn Big Submarine for "..FreedomPName.."\nSpawning Submarine to "..FreedomPName.." will create +50 entites submarines.", function ()
                        local function upgrade_vehicle(vehicle)
                            for i = 0, 49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        end
                        local function give_kosatka(pid)
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                        
                            local hash = util.joaat("kosatka")
                        
                            if not STREAMING.HAS_MODEL_LOADED(hash) then
                                load_model(hash)
                            end
        
                            
                            while FreedomSpam >= 1 do
                                entities.create_vehicle(hash, c, 0)
                                FreedomSpam = FreedomSpam - 1
                                util.yield(10)
                            end
                        
                            local kosatka = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                        
                            upgrade_vehicle(kosatka)
                        end
                        give_kosatka(pid)
                        util.yield()
                    end, nil, nil, COMMANDPERM_AGGRESSIVE)
        
                    FreedomCongestion:action("Summon Cargo Plane", {"freecargoplane"}, "Spawn Big Cargo for "..FreedomPName.."\nSpawning Cargo Plane to "..FreedomPName.." will create +50 entites Cargo Plane.", function ()
                        local function upgrade_vehicle(vehicle)
                            for i = 0, 49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        end
                        local function give_cargoplane(pid)
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                        
                            local hash = util.joaat("cargoplane")
                        
                            if not STREAMING.HAS_MODEL_LOADED(hash) then
                                load_model(hash)
                            end
        
                            while FreedomSpam >= 1 do
                                entities.create_vehicle(hash, c, 0)
                                FreedomSpam = FreedomSpam - 1
                                util.yield(10)
                            end
                        
                            local cargoplane = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                        
                            upgrade_vehicle(cargoplane)
                        end
                        give_cargoplane(pid)
                        util.yield()
                    end, nil, nil, COMMANDPERM_AGGRESSIVE)
        
                    FreedomCongestion:action("Summon Boeing", {"freeboeing"}, "Spawn Big Boeing 747 for "..FreedomPName.."\nSpawning Boeing to "..FreedomPName.." will create +50 entites Boeing 747.", function ()
                        local function upgrade_vehicle(vehicle)
                            for i = 0, 49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        end
                        local function give_boeing(pid)
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                        
                            local hash = util.joaat("jet")
                        
                            if not STREAMING.HAS_MODEL_LOADED(hash) then
                                load_model(hash)
                            end
        
                            while FreedomSpam >= 1 do
                                entities.create_vehicle(hash, c, 0)
                                FreedomSpam = FreedomSpam - 1
                                util.yield(10)
                            end
                        
                            local boeing = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                        
                            upgrade_vehicle(boeing)
                        end
                        give_boeing(pid)
                        util.yield()
                    end, nil, nil, COMMANDPERM_AGGRESSIVE)
        
                    FreedomCongestion:action("Summon B-1B Lancer", {"freelancer"}, "Spawn Mass B-1B Lancer for "..FreedomPName.."\nSpawning B-1B Lancer to "..FreedomPName.." will create +50 entites B-1B Lancer.", function ()
                        local function upgrade_vehicle(vehicle)
                            for i = 0, 49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        end
                        local function give_lancer(pid)
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                        
                            local hash = util.joaat("alkonost")
                        
                            if not STREAMING.HAS_MODEL_LOADED(hash) then
                                load_model(hash)
                            end
        
                            while FreedomSpam >= 1 do
                                entities.create_vehicle(hash, c, 0)
                                FreedomSpam = FreedomSpam - 1
                                util.yield(10)
                            end
                        
                            local lancer = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                        
                            upgrade_vehicle(lancer)
                        end
                        give_lancer(pid)
                        util.yield()
                    end, nil, nil, COMMANDPERM_AGGRESSIVE)
        
                    FreedomCongestion:action("Summon Rhino Tank", {"freeleo"}, "Spawn Mass Leopard Tank for "..FreedomPName.."\nSpawning Leopard to "..FreedomPName.." will create +50 entites Leopard.", function ()
                        local function upgrade_vehicle(vehicle)
                            for i = 0, 49 do
                                local num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
                                VEHICLE.SET_VEHICLE_MOD(vehicle, i, num - 1, true)
                            end
                        end
                        local function give_leopard(pid)
                            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                            local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 5.0, 0.0)
                        
                            local hash = util.joaat("rhino")
                        
                            if not STREAMING.HAS_MODEL_LOADED(hash) then
                                load_model(hash)
                            end
        
                            while FreedomSpam >= 1 do
                                entities.create_vehicle(hash, c, 0)
                                FreedomSpam = FreedomSpam - 1
                                util.yield(10)
                            end
                        
                            local leopard = entities.create_vehicle(hash, c, ENTITY.GET_ENTITY_HEADING(ped))
                        
                            upgrade_vehicle(leopard)
                        end
                        give_leopard(pid)
                        util.yield()
                    end, nil, nil, COMMANDPERM_AGGRESSIVE)

                FreedomSpec = {}

                FreedomScriptP:toggle("Spectate", {"freespec"}, "", function(on)
                    if on then
                        if #FreedomSpec ~= 0 then
                            menu.trigger_commands("freespec"..FreedomSpec[1].." off")
                        end
                            table.insert(FreedomSpec, FreedomPName)
                            menu.trigger_commands("spectate"..FreedomPName.." on")
                            FreedomNotify("You are currently spectating "..FreedomPName)
                        else
                            if players.exists(pid) then
                                menu.trigger_commands("spectate"..FreedomPName.." off")
                                FreedomNotify("You are stopping spectating "..FreedomPName)
                            end
                        table.remove(FreedomSpec, 1)
                    end
                end)

                FreedomScriptP:action("Force Breakup", {"fbp"}, "Force "..FreedomPName.." to leave the session.", function()
                    local commands = {"breakup", "kick", "confusionkick", "aids", "orgasmkick", "nonhostkick", "pickupkick"}
                    for _, command in ipairs(commands) do
                        menu.trigger_commands(command..FreedomPName)
                    end
                    FreedomNotify("\n"..FreedomPName.." has been forced breakup.")
                end, nil, nil, COMMANDPERM_AGGRESSIVE)

                local Controller = players.is_using_controller(pid) and "Confirmed" or "Unconfirmed" wait()
                local ModderDetect = players.is_marked_as_modder(pid) and "Confirmed" or "Unconfirmed" wait()
                local GodModeDetect = players.is_godmode(pid) and "Confirmed" or "Unconfirmed" wait()
                local DetectVPN = players.is_using_vpn(pid) and "Confirmed" or "Unconfirmed" wait()
                local OffRadar = players.is_otr(pid) and "Confirmed" or "Unconfirmed" wait()
                local Interior = players.is_in_interior(pid) and "Interior" or "Exterior" wait()

                local languageList = {"English / N/A", "French", "German", "Italian", "Spanish", "Portuguese/Brazilian", "Polish", "Russian", "Korean", "Chinese (Taiwan)", "Japanese", "Spanish (Mexican)", "Chinese (Mainland China)"}
                local languageIndex = players.get_language(pid)
                if languageIndex >= 0 and languageIndex <= 12 then

                local tokenTypes = {
                    ["FFFF"] = "Handicap", -- handicap mode
                    ["0000"] = "Aggressive", -- aggressive mode
                }
                for i=16,37 do
                    local hex = string.format("%04X", i)
                    tokenTypes[hex] = "Sweet Spot" -- value between 0010 & 0025
                end

                local spoofToken = players.get_host_token_hex(pid)
                local spoofType = tokenTypes[string.sub(spoofToken, 1, 4)] or "Unconfirmed"
                local playerInfos = {
                    {label = "Name", value = FreedomPName},
                    {label = "Language", value = languageList[languageIndex + 1]},
                }

                local sessionInfos = {
                    {label = "Modder", value = ModderDetect},
                    {label = "Host Token", value = spoofType},
                    {label = "Godmode Status", value = tostring(GodModeDetect)},
                    {label = "Off the Radar", value = OffRadar},
                    {label = "Interior Status", value = Interior},
                }

                local otherInfos = {
                    {label = "Controller Usage", value = Controller},
                    {label = "VPN Usage", value = DetectVPN},
                }

                FreedomInfoPlayers:divider("Player Infos")
                for i, info in ipairs(playerInfos) do
                    FreedomInfoPlayers:readonly(info.label, info.value)
                end

                FreedomInfoPlayers:divider("Last Session Infos")
                for i, info in ipairs(sessionInfos) do
                    FreedomInfoPlayers:readonly(info.label, info.value)
                end

                FreedomInfoPlayers:divider("Others")
                for i, info in ipairs(otherInfos) do
                    FreedomInfoPlayers:readonly(info.label, info.value)
                end
            end
        end)

        players.dispatch_on_join()
        players.on_leave(function()end)

    ----========================================----
    ---        Startup Menus & Exit Menus
    ---   It make will able to launch or stop
    ----========================================----

        if not SCRIPT_SILENT_START then
            
            local FreedomLogo = directx.create_texture(script_resources_dir .. "/FreedomScript.png")
            FreedomPlaySound(join_path(script_store_freedom_raah, "oil.wav"), SND_FILENAME | SND_ASYNC)
            local time_start = os.clock()
            local duration = 1.5
            local alpha_start = 0
            local alpha_end = 255
            local time_passed = 0
            local display_duration = 3
            while true do
                local elapsed_time = os.clock() - time_start
                if elapsed_time > duration + display_duration then
                    break
                end
                if elapsed_time > duration then
                    local alpha = linear_transition(alpha_end, alpha_start, duration, elapsed_time - display_duration)
                    directx.draw_texture(FreedomLogo, 0.08, 0.08, 0.5, 0.5, 0.5, 0.5, 0, {r = 1, g = 1, b = 1, a = alpha/255})
                elseif elapsed_time <= duration then
                    local alpha = linear_transition(alpha_start, alpha_end, duration, elapsed_time)
                    directx.draw_texture(FreedomLogo, 0.08, 0.08, 0.5, 0.5, 0.5, 0.5, 0, {r = 1, g = 1, b = 1, a = alpha/255})
                end
                time_passed = elapsed_time - duration
                util.yield(0)
            end
        end

        util.on_stop(function()
            FreedomPlaySound(join_path(script_store_freedom_stop, "stop.wav"), SND_FILENAME | SND_ASYNC)
        end)
