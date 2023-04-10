--[[
    FreedomScript Reloaded for Stand by StealthyAD.
    The All-In-One Script combines every RAAAAH NUKE
    Part: Functions

    Features:
    - Compatible All Stand Versions if deprecated versions too.

    Help with Lua?
    - GTAV Natives: https://nativedb.dotindustries.dev/natives/
    - FiveM Docs Natives: https://docs.fivem.net/natives/
    - Stand Lua Documentation: https://stand.gg/help/lua-api-documentation
    - Lua Documentation: https://www.lua.org/docs.html
]]--

    ----======================================----
    ---             Basic Functions
    --- The most essential part of Lua Script.
    ----======================================----

        local aalib = require("aalib")
        local FreedomPlaySound = aalib.play_sound
        local SND_ASYNC<const> = 0x0001
        local SND_FILENAME<const> = 0x00020000

    ----==========================================----
    ---             Core Functions
    --- The most important part of the lua scripts
    ----==========================================----

        function FreedomPlate()
            local plate = ""
                for i=1,8 do
                    local r = math.random(1,36)
                    if r <= 10 then
                        plate = plate .. tostring(r-1) 
                        else
                        r = r + 54 
                        if r > 90 then
                        r = r + 6 
                        end
                        plate = plate .. string.char(r)
                    end
                end
            return plate
        end

        function show_custom_rockstar_alert(l1)
            poptime = os.time()
            while true do
                if PAD.IS_CONTROL_JUST_RELEASED(18, 18) then
                    if os.time() - poptime > 0.1 then
                        break
                    end
                end
                native_invoker.begin_call()
                native_invoker.push_arg_string("ALERT")
                native_invoker.push_arg_string("JL_INVITE_ND")
                native_invoker.push_arg_int(2)
                native_invoker.push_arg_string("")
                native_invoker.push_arg_bool(true)
                native_invoker.push_arg_int(-1)
                native_invoker.push_arg_int(-1)
                -- line here
                native_invoker.push_arg_string(l1)
                -- optional second line here
                native_invoker.push_arg_int(0)
                native_invoker.push_arg_bool(true)
                native_invoker.push_arg_int(0)
                native_invoker.end_call("701919482C74B5AB")
                util.yield()
            end
        end

        function RandomGenerator(min, max)
            return math.random(min, max)
        end

        function kill_player(pid)
            local entity = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local coords = ENTITY.GET_ENTITY_COORDS(entity, true)
            FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'] + 2, 7, 1000, false, true, 0)
        end

        function load_weapon_asset(hash)
            while not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) do
                WEAPON.REQUEST_WEAPON_ASSET(hash)
                util.yield(50)
            end
        end

        function passive_mode_kill(pid)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local hash = 0x787F0BB

            local audible = true
            local visible = true

            load_weapon_asset(hash)
            
            for i = 0, 50 do
                if PLAYER.IS_PLAYER_DEAD(pid) then
                    return
                end

                local coords = ENTITY.GET_ENTITY_COORDS(ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z - 2, 100, 0, hash, 0, audible, not visible, 2500)
                
                util.yield(10)
            end
        end

        function request_control_of_entity(ent, time)
            if ent and ent ~= 0 then
                local end_time = os.clock() + (time or 3)
                while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) and os.clock() < end_time do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
                    util.yield()
                end
                return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent)
            end
            return false
        end

        function join_path(parent, child)
            local sub = parent:sub(-1)
            if sub == "/" or sub == "\\" then
                return parent .. child
            else
                return parent .. "/" .. child
            end
        end

        function RequestControl(entity, tick)
            if tick == nil then tick = 20 end
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and util.is_session_started() then
                entities.set_can_migrate(entities.handle_to_pointer(entity), true)

                local i = 0
                while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and i <= tick do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
                    i = i + 1
                    util.yield()
                end
            end
            return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity)
        end

        function FreedomOrbital(Position)
            local FreedomPed = players.user_ped()
            FIRE.ADD_EXPLOSION(Position.x, Position.y, Position.z + 1, 59, 1, true, false, 1.0, false)
            while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", Position.x, Position.y, Position.z, 0, 180, 0, 1.0, true, true, true)
                STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                util.yield(0)
            end
            GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", Position.x, Position.y, Position.z + 1, 0, 180, 0, 1.0, true, true, true)
            for i = 1, 4 do
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", FreedomPed, 0, true, false)
            end
        end

        local function get_distance_between(pos1, pos2)
            if math.type(pos1) == "integer" then
                pos1 = ENTITY.GET_ENTITY_COORDS(pos1)
            end
            if math.type(pos2) == "integer" then 
                pos2 = ENTITY.GET_ENTITY_COORDS(pos2)
            end
            return pos1:distance(pos2)
        end

        function SummonCar(model_name)
            local hash = util.joaat(model_name)
            local ped = PLAYER.GET_PLAYER_PED()
            if STREAMING.IS_MODEL_A_VEHICLE(hash) then
                util.request_model(hash)
                local c = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 7.5, 0.0)
                local veh = entities.create_vehicle(hash, c, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
            else
                FreedomNotify("The model is not recognize, please retry later.")
            end
        end

        function get_offset_from_gameplay_camera(distance)
            local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
            local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
            local direction = v3.toDir(cam_rot)
            local destination = {
            x = cam_pos.x + direction.x * distance, 
            y = cam_pos.y + direction.y * distance, 
            z = cam_pos.z + direction.z * distance 
            }
            return destination
        end

        function request_model(hash)
            local timeout = 3
            STREAMING.REQUEST_MODEL(hash)
            local end_time = os.time() + timeout
            repeat util.yield() until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
            return STREAMING.HAS_MODEL_LOADED(hash)
        end

        function CreateNuke(Position, Named) -- Shortcut of Nuke Features
            local Owner
            if Named then
                Owner = players.user_ped()
            else
                Owner = 0
            end
            local function spawn_explosion()
                while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                    STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                    util.yield(0)
                end
                FIRE.ADD_EXPLOSION(Position.x, Position.y, Position.z, 59, 1, true, false, 5.0, false)
                GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
                GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", Position.x, Position.y, Position.z, 0, 180, 0, 4.5, true, true, true)
            end
            for i = 1, 7 do
                spawn_explosion()
            end
            for i=-30,30,10 do
                for j=-30,30,10 do
                    if i~=0 or j~=0 then
                        FIRE.ADD_EXPLOSION(Position.x+i, Position.y+j, Position.z, 59, 1.0, true, false, 1.0, false)
                    end
                end
            end

            for i = 1, 4 do
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", players.user_ped(), 0, true, false)
            end
            
            offsets = {{10, 30}, {30, 10}, {-30, -10}, {-10, -30}, {-10, 30}, {-30, 10}, {30,-10}, {10,-30}}
            for _, offset in ipairs(offsets) do
                local x_offset = offset[1]
                local y_offset = offset[2]
                FIRE.ADD_EXPLOSION(Position.x + x_offset ,Position.y + y_offset ,Position.z ,59 ,1.0 ,true ,false ,1.0 ,false)
            end
            local coords = {1, 3, 5, 7, 10, 12, 15, 17}

            while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                util.yield(0)
            end

            for i = 1, #coords do
                if coords[i] % 2 ~= 0 then
                    FIRE.ADD_EXPLOSION(Position.x, Position.y, Position.z+coords[i], 59, 1, true, false, 5.0, false)
                end
                GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
                GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", Position.x, Position.y, Position.z+coords[i], 0, 180, 0, 1.5, true, true, true)
                util.yield(10)
            end
            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", Position.x, Position.y, Position.z+80, 0, 0, 0, 3, true, true, true)

            for pid = 0, 31 do
                if players.exists(pid) and get_distance_between(players.get_position(pid), Position) < 200 then
                    local pid_pos = players.get_position(pid)
                    FIRE.ADD_EXPLOSION(pid_pos.x, pid_pos.y, pid_pos.z, 59, 1.0, true, false, 1.0, false)
                end
            end

            local peds = entities.get_all_pickups_as_handles()
            for i = 1, #peds do
                if get_distance_between(peds[i], Position) < 400 and NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(peds[i]) ~= players.user() then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(peds[i])
                    local ped_pos = ENTITY.GET_ENTITY_COORDS(peds[i], false)
                    FIRE.ADD_EXPLOSION(ped_pos.x, ped_pos.y, ped_pos.z, 3, 1.0, true, false, 0.1, false)
                    PED.SET_PED_TO_RAGDOLL(peds[i], 1000, 1000, 0, false, false, false)
                end
            end

            local vehicles = entities.get_all_vehicles_as_handles()
            for i = 1, #vehicles do
                if get_distance_between(vehicles[i], Position) < 400 then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicles[i])
                    VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicles[i], -999.90002441406)
                    VEHICLE.EXPLODE_VEHICLE(vehicles[i], true, false)
                elseif get_distance_between(vehicles[i], Position) < 400 then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicles[i])
                    VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicles[i], -4000)
                end
            end
        end

        local current_sound_handle = nil
        local random_enabled = false

        function AutoPlay(sound_location)
            if current_sound_handle then
                current_sound_handle = nil
            end

            local play_count = 0
            current_sound_handle = FreedomPlaySound(sound_location, SND_FILENAME | SND_ASYNC, function()
                if random_enabled and play_count < 10 then
                    play_count = play_count + 1
                    AutoPlay(sound_location)
                end
            end)
        end

        function SendRequest(hash, timeout)
            timeout = timeout or 3
            STREAMING.REQUEST_MODEL(hash)
            local end_time = os.time() + timeout
            repeat
                util.yield()
            until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
            return STREAMING.HAS_MODEL_LOADED(hash)
        end

        function load_model(hash)
            local request_time = os.time()
            if not STREAMING.IS_MODEL_VALID(hash) then
                return
            end
            STREAMING.REQUEST_MODEL(hash)
            while not STREAMING.HAS_MODEL_LOADED(hash) do
                if os.time() - request_time >= 10 then
                    break
                end
                util.yield()
            end
        end

        function FRModel(Hash)
            if STREAMING.IS_MODEL_VALID(Hash) then
                STREAMING.REQUEST_MODEL(Hash)
                while not STREAMING.HAS_MODEL_LOADED(Hash) do
                    STREAMING.REQUEST_MODEL(Hash)
                    util.yield()
                end
            end
        end

        function Create_Network_Object(modelHash, x, y, z)
            FRModel(modelHash)
            local obj = OBJECT.CREATE_OBJECT_NO_OFFSET(modelHash, x, y, z, true, true, false)
            ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(obj, true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(obj, true, false)
            ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(obj, true)

            NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(obj)
            local net_id = NETWORK.OBJ_TO_NET(obj)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(net_id, true)
            NETWORK.SET_NETWORK_ID_CAN_MIGRATE(net_id, true)
            for _, player in pairs(players.list(true, true, true)) do
                NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(net_id, player, true)
            end
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(modelHash)
            return obj
        end

        Freedom = {
            get_coords = function(entity)
                entity = entity or PLAYER.PLAYER_PED_ID()
                return ENTITY.GET_ENTITY_COORDS(entity, true)
            end,

            player = players.user_ped(),

            play_all = function(sound, sound_group, wait_for)
                for i=0, 31, 1 do
                    AUDIO.PLAY_SOUND_FROM_ENTITY(-1, sound, PLAYER.GET_PLAYER_PED(i), sound_group, true, 20)
                end
                util.yield(wait_for)
            end,

            explode_all = function(earrape_type, wait_for) -- Required for Nuke Session
                for i=0, 31, 1 do
                    coords = Freedom.get_coords(PLAYER.GET_PLAYER_PED(i))
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 100, true, false, 150, false)
                    if earrape_type == EARRAPE_BED then
                        AUDIO.PLAY_SOUND_FROM_COORD(-1, "Bed", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                    end
                    if earrape_type == EARRAPE_FLASH then
                        AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                        AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                        AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", coords.x, coords.y, coords.z, "WastedSounds", true, 999999999, true)
                    end
                end
                util.yield(wait_for)
            end,

            request_model = function(hash, timeout)
                timeout = timeout or 3
                STREAMING.REQUEST_MODEL(hash)
                local end_time = os.time() + timeout
                repeat
                    util.yield()
                until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
                return STREAMING.HAS_MODEL_LOADED(hash)
            end,
        }

        function explosion_circle(ped, angle, radius)
            local ped_coords = ENTITY.GET_ENTITY_COORDS(ped)

            local offset_x = ped_coords.x
            local offset_y = ped_coords.y

            local x = offset_x + radius * math.cos(angle)
            local y = offset_y + radius * math.sin(angle)

            FIRE.ADD_EXPLOSION(x, y, ped_coords.z, 48, 1, true, false, 0)
        end

        local function ls_log(content)
            if ls_debug then
                util.toast(content)
            end
        end

        object_uses = 0
        function mod_uses(type, incr)
            if incr < 0 and is_loading then
                ls_log("Not incrementing use var of type " .. type .. " by " .. incr .. "- script is loading")
                return
            end
            ls_log("Incrementing use var of type " .. type .. " by " .. incr)
            if type == "vehicle" then
                if vehicle_uses <= 0 and incr < 0 then
                    return
                end
                vehicle_uses = vehicle_uses + incr
            elseif type == "pickup" then
                if pickup_uses <= 0 and incr < 0 then
                    return
                end
                pickup_uses = pickup_uses + incr
            elseif type == "ped" then
                if ped_uses <= 0 and incr < 0 then
                    return
                end
                ped_uses = ped_uses + incr
            elseif type == "player" then
                if player_uses <= 0 and incr < 0 then
                    return
                end
                player_uses = player_uses + incr
            elseif type == "object" then
                if object_uses <= 0 and incr < 0 then
                    return
                end
                object_uses = object_uses + incr
            end
        end

        local function is_entity_a_projectile_all(hash)
            local all_projectile_hashes = {
                util.joaat("w_ex_vehiclemissile_1"),
                util.joaat("w_ex_vehiclemissile_2"),
                util.joaat("w_ex_vehiclemissile_3"),
                util.joaat("w_ex_vehiclemissile_4"),
                util.joaat("w_ex_vehiclemortar"),
                util.joaat("w_ex_apmine"),
                util.joaat("w_ex_arena_landmine_01b"),
                util.joaat("w_ex_birdshat"),
                util.joaat("w_ex_grenadefrag"),
                util.joaat("xm_prop_x17_mine_01a"),
                util.joaat("xm_prop_x17_mine_02a"),
                util.joaat("w_ex_grenadesmoke"),
                util.joaat("w_ex_molotov"),
                util.joaat("w_ex_pe"),
                util.joaat("w_ex_pipebomb"),
                util.joaat("w_ex_snowball"),
                util.joaat("w_lr_rpg_rocket"),
                util.joaat("w_lr_homing_rocket"),
                util.joaat("w_lr_firework_rocket"),
                util.joaat("xm_prop_x17_silo_rocket_01"),
                util.joaat("w_ex_vehiclegrenade"),
                util.joaat("w_ex_vehiclemine"),
                util.joaat("w_lr_40mm"),
                util.joaat("w_smug_bomb_01"),
                util.joaat("w_smug_bomb_02"),
                util.joaat("w_smug_bomb_03"),
                util.joaat("w_smug_bomb_04"),
                util.joaat("w_am_flare"),
                util.joaat("w_arena_airmissile_01a"),
                util.joaat("w_pi_flaregun_shell"),
                util.joaat("w_smug_airmissile_01b"),
                util.joaat("w_smug_airmissile_02"),
                util.joaat("w_sr_heavysnipermk2_mag_ap2"),
                util.joaat("w_battle_airmissile_01"),
                util.joaat("gr_prop_gr_pmine_01a")
            }
            return table.contains(all_projectile_hashes, hash)
        end

        local function is_entity_a_missle(hash) 
            local missle_hashes = {
                util.joaat("w_ex_vehiclemissile_1"),
                util.joaat("w_ex_vehiclemissile_2"),
                util.joaat("w_ex_vehiclemissile_3"),
                util.joaat("w_ex_vehiclemissile_4"),
                util.joaat("w_lr_rpg_rocket"),
                util.joaat("w_lr_homing_rocket"),
                util.joaat("w_lr_firework_rocket"),
                util.joaat("xm_prop_x17_silo_rocket_01"),
                util.joaat("w_arena_airmissile_01a"),
                util.joaat("w_smug_airmissile_01b"),
                util.joaat("w_smug_airmissile_02"),
                util.joaat("w_battle_airmissile_01"),
                util.joaat("h4_prop_h4_airmissile_01a")
            }
            return table.contains(missle_hashes, hash)
        end

        local function is_entity_a_grenade(hash)   
            local grenade_hashes = {
                util.joaat("w_ex_vehiclemortar"),
                util.joaat("w_ex_grenadefrag"),
                util.joaat("w_ex_grenadesmoke"),
                util.joaat("w_ex_molotov"),
                util.joaat("w_ex_pipebomb"),
                util.joaat("w_ex_snowball"),
                util.joaat("w_ex_vehiclegrenade"),
                util.joaat("w_lr_40mm")
            }
            return table.contains(grenade_hashes, hash)
        end

        objects_thread = util.create_thread(function(thr)
            while true do
                if object_uses > 0 then
                    all_objects = entities.get_all_objects_as_handles()
                    for k,obj in pairs(all_objects) do
                        if is_entity_a_projectile_all(ENTITY.GET_ENTITY_MODEL(obj)) then  --Edit Proj Offsets Here
                            if projectile_spaz then 
                                local strength = 20
                                ENTITY.APPLY_FORCE_TO_ENTITY(obj, 1, math.random(-strength, strength), math.random(-strength, strength), math.random(-strength, strength), 0.0, 0.0, 0.0, 1, true, false, true, true, true)
                            end
                            if slow_projectiles then
                                ENTITY.SET_ENTITY_MAX_SPEED(obj, 0.5)
                            end
                            if vehicle_APS then
                                local gce_all_objects = entities.get_all_objects_as_handles()
                                local Range = CMAPSRange
                                local RangeSq = Range * Range
                                local EntitiesToTarget = {}
                                for index, entity in pairs(gce_all_objects) do
                                    if is_entity_a_missle(ENTITY.GET_ENTITY_MODEL(entity)) or is_entity_a_grenade(ENTITY.GET_ENTITY_MODEL(entity)) then
                                        local EntityCoords = ENTITY.GET_ENTITY_COORDS(entity)
                                        local LocalCoords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
                                        local VehCoords = ENTITY.GET_ENTITY_COORDS(entities.get_user_vehicle_as_handle())
                                        local ObjPointers = entities.get_all_objects_as_pointers()
                                        local vdist = SYSTEM.VDIST2(VehCoords.x, VehCoords.y, VehCoords.z, EntityCoords.x, EntityCoords.y, EntityCoords.z)
                                        if vdist <= RangeSq then
                                            EntitiesToTarget[#EntitiesToTarget+1] = entities.pointer_to_handle(ObjPointers[index])
                                        end
                                        if EntitiesToTarget ~= nil then
                                            local dist = 999999
                                            for i = 1, #EntitiesToTarget do
                                                local tarcoords = ENTITY.GET_ENTITY_COORDS(EntitiesToTarget[index])
                                                local e = SYSTEM.VDIST2(VehCoords.x, VehCoords.y, VehCoords.z, EntityCoords.x, EntityCoords.y, EntityCoords.z)
                                                if e < dist then
                                                    dist = e
                                                    local closestEntity = entity
                                                    local ProjLocation = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(closestEntity, 0, 0, 0)
                                                    local ProjRotation = ENTITY.GET_ENTITY_ROTATION(closestEntity)
                                                    local lookAtProj = v3.lookAt(VehCoords, EntityCoords)
                                                    STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_sm_counter")
                                                    STREAMING.REQUEST_NAMED_PTFX_ASSET("core") 
                                                    STREAMING.REQUEST_NAMED_PTFX_ASSET("weap_gr_vehicle_weapons")
                                                    if STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_sm_counter") and STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("core") and STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("veh_xs_vehicle_mods") then
                                                        ENTITY.SET_ENTITY_ROTATION(entity, lookAtProj.x - 180, lookAtProj.y, lookAtProj.z, 1, true)
                                                        lookAtPos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entity, 0, Range - 2, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_sm_counter")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_sm_counter_chaff", ProjLocation.x, ProjLocation.y, ProjLocation.z, ProjRotation.x + 90, ProjRotation.y, ProjRotation.z, 1, 0, 0, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("core")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("exp_grd_sticky", ProjLocation.x, ProjLocation.y, ProjLocation.z, ProjRotation.x - 90, ProjRotation.y, ProjRotation.z, 0.2, 0, 0, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("weap_gr_vehicle_weapons")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("muz_mounted_turret_apc_missile", lookAtPos.x, lookAtPos.y, lookAtPos.z + .2, lookAtProj.x + 180, lookAtProj.y, lookAtProj.z, 1.3, 0, 0, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("weap_gr_vehicle_weapons")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("muz_mounted_turret_apc", lookAtPos.x, lookAtPos.y, lookAtPos.z + .2, lookAtProj.x + 180, lookAtProj.y, lookAtProj.z, 1.3, 0, 0, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("weap_gr_vehicle_weapons")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("muz_mounted_turret_apc_missile", lookAtPos.x, lookAtPos.y, lookAtPos.z + .2, lookAtProj.x + 180, lookAtProj.y, lookAtProj.z, 1.3, 0, 0, 0)
                                                        GRAPHICS.USE_PARTICLE_FX_ASSET("weap_gr_vehicle_weapons")
                                                        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("muz_mounted_turret_apc", lookAtPos.x, lookAtPos.y, lookAtPos.z + .2, lookAtProj.x + 180, lookAtProj.y, lookAtProj.z, 1.3, 0, 0, 0)
                                                        entities.delete_by_handle(entity)
                                                        APS_charges = APS_charges - 1
                                                        FreedomNotify("APS Destroyed Incoming Projectile.\n"..APS_charges.."/"..CMAPSCharges.." APS Shells Left.")
                                                        if APS_charges == 0 then
                                                            FreedomNotify("No APS Shells Left. Reloading...")
                                                            util.yield(CMAPSTimeout)
                                                            APS_charges = CMAPSCharges
                                                            FreedomNotify("APS Ready.")
                                                        end
                                                    else
                                                        for i = 0, 10, 1 do
                                                            STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_sm_counter")
                                                            STREAMING.REQUEST_NAMED_PTFX_ASSET("core") 
                                                            STREAMING.REQUEST_NAMED_PTFX_ASSET("veh_xs_vehicle_mods")
                                                        end
                                                        if not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_sm_counter") or STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("core") or STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("veh_xs_vehicle_mods") then
                                                            FreedomNotify("Could not Load Particle Effect.")
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end 
                        end
                    end
                end
                util.yield()
            end
        end)