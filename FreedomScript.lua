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

        local FreedomSVersion = "0.44"
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

            FreedomVehicles:toggle_loop("Helikopter Helikopter", {}, "Helikopter Helikopter.\nI'm not sure if DLC tanks works for us.\nRequirements: Tanks", function ()
                local ped = PLAYER.PLAYER_PED_ID()
                local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                    local speed = menu.get_value(FreedomForceTurret) * 0.01 
                    turretPosition = turretPosition - speed
                    if turretPosition < 0 then
                        turretPosition = 360
                    end
                    VEHICLE.SET_VEHICLE_TANK_TURRET_POSITION(veh, turretPosition, true)
                    util.yield(10)
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

                FreedomTeleports:action("Random Teleport Heterogenous", {'ftphe'}, "Teleport each player in the session to a random apartment heterogeneously?\nAlternative to Stand Features but may not karma you.\n\nToggle 'Exclude Self' to avoid using these functions.", function()
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
                local commands = {"breakup", "ban"}
                for _, pid in pairs(players.list(FreedomToggleS, FreedomToggleF, true)) do
                    if FreedomSession() then
                        local languageIndex = players.get_language(pid)
                            if languageIndex == 7 then
                            for _, command in ipairs(commands) do
                                menu.trigger_commands(command..players.get_name(pid))
                            end
                        end
                    end
                end
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
                v3.new(10, 0, -114), -- East 7
                v3.new(10, 0, -244), -- South West 8
            }

            local currentPosition = math.random(#positions)
            local lastBoeingSent = 0
            local isAssisting
            local toggleSong
            
            local FreeTwinTowers = FreedomWorld:list("Twin Towers", {}, "Do not laugh or you will send to the hell.\nIt's a warning, don't do that for praying for victims, don't laugh.")
            FreeTwinTowers:toggle("Toggle Teleport 'Twin Towers'", {}, "Toggle while teleporting House to assist 9/11 Crash Planes\n\n- Enable: you will be automatically teleported.\n- Disable: you will wont automatically teleported.", function(toggle) isAssisting = toggle end)
            FreeTwinTowers:toggle("Toggle Sound for 'Twin Towers'", {}, "Toggle while using song House for 9/11 Crash Planes\n\n- Enable: you will hear the sound (local).\n- Disable: you will not able to hear the sound (local).", function(toggle) toggleSong = toggle end)
            FreeTwinTowers:action("Twin Towers Boeing", {}, "Send Boeing to Twin Towers but you have each interval which you cannot spam more plane.\n\nNostalgic 9/11 but watch this.\n'Toggle Invincible Vehicle' can may be toggle (Find on Online > Vehicle Options)\n\nBeware, some planes can cross the Twin Towers, be very careful.", function()
                if lastBoeingSent ~= 1 then
                    lastBoeingSent = 1
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
                else
                    lastBoeingSent = 0
                    FreedomPlaySound(join_path(script_store_freedom_stop, "stop.wav"), SND_FILENAME | SND_ASYNC)
                    return
                end
            
                local hash = util.joaat("jet")
                load_model(hash)
                while not STREAMING.HAS_MODEL_LOADED(hash) do
                    util.yield()
                end
            
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
            end)

            FreedomWorld:toggle("Toggle Blackout", {}, "Only works locally", function(toggle)
                GRAPHICS.SET_ARTIFICIAL_LIGHTS_STATE(toggle)
                GRAPHICS.SET_ARTIFICIAL_VEHICLE_LIGHTS_STATE(toggle)
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
        FreedomMiscs:divider("Others")
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

                FreedomNeutral:action("Godmode Detection", {"fdgod"}, "", function()
                    if players.is_godmode(pid) then
                        if players.is_in_interior(pid) then
                            FreedomNotify("\n"..FreedomPName.." is in Godmode.".."\n".."But "..FreedomPName.." is in interior.")
                        end
                        FreedomNotify("\n"..FreedomPName.." is in Godmode.")
                    else
                        FreedomNotify("\n"..FreedomPName.." is not in Godmode.")
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
=
