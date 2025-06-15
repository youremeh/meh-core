local vehicleLastUpdate = {}
RegisterNetEvent('curbboost:landing')
AddEventHandler('curbboost:landing', function(netVehicleId, velocity)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(netVehicleId)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    local curTime = os.time()
    local lastUpdate = vehicleLastUpdate[netVehicleId] or 0
    if curTime - lastUpdate < 0.5 then return end
    vehicleLastUpdate[netVehicleId] = curTime
    if type(velocity) ~= "table" or math.abs(velocity.x) > 100 or math.abs(velocity.y) > 100 or math.abs(velocity.z) > 100 then return end
    local vx = velocity.x * 0.85
    local vy = velocity.y * 0.85
    local vz = velocity.z
    SetEntityVelocity(vehicle, vx, vy, vz)
end)