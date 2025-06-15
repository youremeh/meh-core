local revivedPeds = {}

local function isValidDeadNPC(ped)
    return DoesEntityExist(ped) and IsEntityDead(ped) and not IsPedAPlayer(ped) and GetEntityType(ped) == 1 and not revivedPeds[ped]
end

CreateThread(function()
    while true do
        local sleep = 2000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyPeds = {}
        for _, ped in pairs(GetGamePool('CPed')) do
            if #(playerCoords - GetEntityCoords(ped)) < 25.0 then table.insert(nearbyPeds, ped) end
        end
        for _, ped in pairs(nearbyPeds) do
            if isValidDeadNPC(ped) then
                exports.ox_target:addLocalEntity(ped, {
                    {
                        label = 'Revive NPC',
                        icon = 'fas fa-heartbeat',
                        distance = 2.0,
                        onSelect = function()
                            local playerPed = PlayerPedId()
                            local pedHeading = GetEntityHeading(ped)
                            local reviveOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.6, 0.0)
                            local reviveHeading = pedHeading + 180.0

                            TaskGoStraightToCoord(playerPed, reviveOffset, 1.0, -1, reviveHeading, 0.0)
                            Wait(1000)
                            FreezeEntityPosition(playerPed, true)
                            exports["rpemotes-reborn"]:EmoteCommandStart('medic')
                            Wait(2000)
                            exports["rpemotes-reborn"]:EmoteCommandStart('cpr')

                            local success = lib.progressBar({
                                duration = 15000,
                                label = 'Reviving NPC...',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {move = true, car = true, combat = true}
                            })

                            reviving = false
                            exports["rpemotes-reborn"]:EmoteCancel()
                            FreezeEntityPosition(playerPed, false)

                            if success then
                                TriggerEvent('meh:reviveai:revivePed', ped)
                            else
                                lib.notify({title = 'Revive Cancelled', description = 'You stopped reviving the NPC.', type = 'error'})
                            end
                        end
                    }
                })
                revivedPeds[ped] = true
                sleep = 500
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('meh:reviveai:revivePed', function(ped)
    if DoesEntityExist(ped) and IsEntityDead(ped) then
        ClearPedTasksImmediately(ped)
        ResurrectPed(ped)
        ClearPedBloodDamage(ped)
        SetEntityHealth(ped, 150)
        RequestAnimSet("move_m@lester")
        while not HasAnimSetLoaded("move_m@lester") do Wait(10) end
        SetPedMovementClipset(ped, "move_m@lester", 0.25)
        TaskWanderStandard(ped, 1.0, 10)
        revivedPeds[ped] = true
    end
end)