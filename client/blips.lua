local QBCore = exports['qb-core']:GetCoreObject()

local blips = {
    -- Police Stations
    {title = 'Police Station', id = 60, coord = vec2(639.13, 1.52),     c = 30, jobs = {'lspd', 'bcso', 'sasp', 'fib', 'ems'}},
    {title = 'Police Station', id = 60, coord = vec2(1810.33, 3668.5),  c = 30, jobs = {'lspd', 'bcso', 'sasp', 'fib', 'ems'}},
    {title = 'Police Station', id = 60, coord = vec2(-436.41, 6015.22), c = 30, jobs = {'lspd', 'bcso', 'sasp', 'fib', 'ems'}},

    -- Prison
    {title = 'Prison', id = 188, coord = vec2(1680.81, 2601.99), c = 3, s = 1.1, jobs = {'lspd', 'bcso', 'sasp', 'fib', 'ems'}},

    -- Development Zone [enables being able to set waypoints on cayo perico]
    {title = 'zBoundry', id = 37, coord = vec2(5771.59, -6211.9), s = 0.0}
}

local createdBlips = {}
local function RemoveAllBlips()
    for _, blip in pairs(createdBlips) do RemoveBlip(blip) end
    createdBlips = {}
end

local function HasJobAccess(job, allowedJobs)
    if not allowedJobs then return true end
    for _, allowed in ipairs(allowedJobs) do
        if job == allowed then return true end
    end
    return false
end

local function CreateBlipsForJob(jobName)
    RemoveAllBlips()
    for _, blipData in pairs(blips) do
        if HasJobAccess(jobName, blipData.jobs) then
            local x, y = blipData.coord.x, blipData.coord.y
            local blip = AddBlipForCoord(x, y, 0.0)
            SetBlipSprite(blip, blipData.id or 66)
            SetBlipDisplay(blip, blipData.d or 2)
            SetBlipColour(blip, blipData.c or 0)
            SetBlipScale(blip, blipData.s or 0.7)
            SetBlipAsShortRange(blip, blipData.shortRange ~= false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipData.title)
            EndTextCommandSetBlipName(blip)
            table.insert(createdBlips, blip)
        end
    end
end

CreateThread(function()
    while not QBCore.Functions.GetPlayerData().job do Wait(200) end
    CreateBlipsForJob(QBCore.Functions.GetPlayerData().job.name)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job) CreateBlipsForJob(job.name) end)