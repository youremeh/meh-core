local lastSendTime = 0
local SEND_COOLDOWN = 500

local function IsVehicleOnGround(vehicle)
    local heightAboveGround = GetEntityHeightAboveGround(vehicle)
    if heightAboveGround and heightAboveGround < 1.0 then
        return true
    else
        return false
    end
end

CreateThread(function()
    local prevOnGround = true
    local prevHeight = 0.0
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            local coords = GetEntityCoords(vehicle)
            local isOnGround = IsVehicleOnGround(vehicle)
            if not prevOnGround and isOnGround then
                local heightDiff = coords.z - prevHeight
                if heightDiff > 0.1 and heightDiff < 0.5 then
                    local currentTime = GetGameTimer()
                    if currentTime - lastSendTime > SEND_COOLDOWN then
                        local velocity = GetEntityVelocity(vehicle)
                        TriggerServerEvent('curbboost:landing', NetworkGetNetworkIdFromEntity(vehicle), vector3(velocity.x, velocity.y, velocity.z))
                        lastSendTime = currentTime
                    end
                end
            end
            prevOnGround = isOnGround
            prevHeight = coords.z
        else
            prevOnGround = true
            prevHeight = 0.0
        end
        Wait(50)
    end
end)