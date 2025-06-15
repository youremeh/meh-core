-- Gameplay and Environmental Tweaks
SetFlashLightKeepOnWhileMoving(true)
DisableIdleCamera(true)
DisableVehiclePassengerIdleCamera(true)
NetworkSetLocalPlayerSyncLookAt(true)
SetWeaponDamageModifier(`WEAPON_MUSKET`, 0.1)

-- Train Behavior
SwitchTrainTrack(0, true)
SwitchTrainTrack(3, true)
SetTrainTrackSpawnFrequency(0, 120000)
SetTrainTrackSpawnFrequency(3, 120000)
SetRandomTrains(true)

-- Repeating Game Environment Controls
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Wait(1000)

        SetAudioFlag("DisableFlightMusic", true)
        SetAudioFlag("PoliceScannerDisabled", true)
        SetRandomEventFlag(false)

        local disabledScenarios = {
            "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
            "WORLD_VEHICLE_BUSINESSMEN",
            "WORLD_VEHICLE_EMPTY",
            "WORLD_VEHICLE_MECHANIC",
            "WORLD_VEHICLE_MILITARY_PLANES_BIG",
            "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
            "WORLD_VEHICLE_POLICE_BIKE",
            "WORLD_VEHICLE_POLICE_CAR",
            "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
            "WORLD_VEHICLE_SALTON_DIRT_BIKE",
            "WORLD_VEHICLE_SALTON",
            "WORLD_VEHICLE_STREETRACE"
        }

        for _, scenario in ipairs(disabledScenarios) do
            SetScenarioTypeEnabled(scenario, false)
        end

        local disabledEmitters = {
            "LOS_SANTOS_VANILLA_UNICORN_01_STAGE",
            "LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",
            "LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",
            "se_dlc_aw_arena_construction_01",
            "se_dlc_aw_arena_crowd_background_main",
            "se_dlc_aw_arena_crowd_exterior_lobby",
            "se_dlc_aw_arena_crowd_interior_lobby"
        }

        for _, emitter in ipairs(disabledEmitters) do
            SetStaticEmitterEnabled(emitter, false)
        end

        StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
        StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
        DistantCopCarSirens(false)

        SetMaxWantedLevel(0)
        DisablePlayerVehicleRewards(ped)
    end
end)

-- Helmet and prop reset settings
lib.onCache('ped', function(ped)
    if ped then
        SetPedConfigFlag(ped, 35, false)
        SetPedResetFlag(ped, 337, true)
    end
end)

-- Vehicle dashboard color change
RegisterCommand('setdashboardcolor', function(_, args)
    local color = tonumber(args[1])
    if color then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleDashboardColour(vehicle, color)
    end
end)

-- Disable blind fire
CreateThread(function()
    while true do
		local sleep = 500
		local ped = PlayerPedId()
		if IsPedInCover(ped) and not IsPedAimingFromCover(ped) then
			sleep = 1
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 257, true)
		else
			sleep = 500
		end
		Wait(sleep)
    end
end)

-- Prevent stuck player state after shooting
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Wait(1000)
        if IsPedUsingActionMode(ped) then
            SetPedUsingActionMode(ped, false, -1, 'DEFAULT_ACTION')
        end
    end
end)

-- Force first person when aiming in vehicles and on bikes
-- Force first person while aiming
CreateThread(function()
    local unarmed = `WEAPON_UNARMED`
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local weapon = GetCurrentPedWeapon(ped)
        if IsPedInAnyVehicle(ped, false) and weapon ~= unarmed then
            sleep = 1
            if IsControlJustPressed(0, 25) then -- Right mouse button pressed
                SetFollowVehicleCamViewMode(3)
            elseif IsControlJustReleased(0, 25) then -- Right mouse button released
                SetFollowVehicleCamViewMode(0)
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    local unarmed = `WEAPON_UNARMED`
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local weapon = GetCurrentPedWeapon(ped)
        if IsPedOnAnyBike(ped) and weapon ~= unarmed then
            sleep = 1
            if IsControlJustPressed(0, 25) then -- Right mouse button pressed
                SetCamViewModeForContext(2, 3) -- Set bike cam to mode 3
            elseif IsControlJustReleased(0, 25) then -- Right mouse button released
                SetCamViewModeForContext(2, 0) -- Reset bike cam to mode 0
            end
        end
        Wait(sleep)
    end
end)

-- Remove attached props
RegisterCommand('propstuck', function()
    for _, obj in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), obj) then
            SetEntityAsMissionEntity(obj, true, true)
            DeleteObject(obj)
        end
    end
end)

-- Rockstar Editor Commands
RegisterCommand('record', function(_, args)
    if args[1] == 'start' then StartRecording(1) end
    if args[1] == 'stop' then StopRecordingAndSaveClip() end
    if args[1] == 'discard' then StopRecordingAndDiscardClip() end
end)

RegisterCommand('rockstareditor', function()
    ActivateRockstarEditor()
end)

RegisterCommand('picture', function()
    BeginTakeHighQualityPhoto()
    SaveHighQualityPhoto(-1)
    FreeMemoryForHighQualityPhoto()
end)

RegisterKeyMapping('record start', '(Rockstar editor) Start Recording', 'keyboard', '')
RegisterKeyMapping('record stop', '(Rockstar editor) Stop Recording', 'keyboard', '')
RegisterKeyMapping('record discard', '(Rockstar editor) Discard Recording', 'keyboard', '')
RegisterKeyMapping('picture', '(Rockstar editor) Take a Picture', 'keyboard', '')

-- Disable controls in air or upside-down for specific vehicle classes
local vehicleClassDisableControl = {
    [0] = true, [1] = true, [2] = true, [3] = true,
    [4] = true, [5] = true, [6] = true, [7] = true,
    [8] = false, [9] = true, [10] = true, [11] = true,
    [12] = true, [13] = false, [14] = false, [15] = false,
    [16] = false, [17] = true, [18] = true, [19] = false
}

CreateThread(function()
    while true do
        local player = PlayerId()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local class = GetVehicleClass(vehicle)
        Wait(1000)

        if GetPedInVehicleSeat(vehicle, -1) == ped and vehicleClassDisableControl[class] then
            if IsEntityInAir(vehicle) or IsEntityUpsidedown(vehicle) then
                DisableControlAction(2, 59, true)
                DisableControlAction(2, 60, true)
            end
        end
    end
end)

-- Custom Map Zoom Levels
CreateThread(function()
    SetMapZoomDataLevel(0, 2.75, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 2.8, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.0, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 20.0, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 35.0, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0)
    SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0)
    SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0)
    SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0)
end)