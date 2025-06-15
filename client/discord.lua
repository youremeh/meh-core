-- Config Section
local Config = {
    AppID = '',

    LargeImage = {
        name = 'logo',
        hoverText = '',
    },

    SmallImage = {
        name = '',
        hoverText = '',
    },

    DiscordButtons = {
        {index = 0, name = 'Join our Discord', url = 'https://discord.gg/'},
        {index = 1, name = 'Join the Server', url = 'https://cfx.re/join/'}
    },

    DefaultPresence = 'Roleplaying'
}

-- Utils Section
local function getZoneName(x, y, z)
    local zoneCode = GetNameOfZone(x, y, z)
    local zoneName = GetLabelText(zoneCode)
    if zoneName == 'NULL' or zoneName == '' then zoneName = 'San Andreas' end
    return zoneName
end

local function getHeadingDirection(heading)
    heading = heading % 360
    local directions = {'North', 'North East', 'East', 'South East', 'South', 'South West', 'West', 'North West'}
    local index = math.floor((heading + 22.5) / 45) % 8 + 1
    return directions[index]
end

local function getVehicleLabel(vehicle)
    if not vehicle or vehicle == 0 then return '' end
    local label = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    if label == 'NULL' or label == 'CARNOTFOUND' then label = '' end
    return label
end

-- Discord Presence Section
local WhichPresence = 'all'
local CustomText = Config.DefaultPresence
local StartDiscordPresence = true

local function setRichPresence(text) SetRichPresence(text) end

local function updateAssets()
    SetDiscordAppId(Config.AppID)
    SetDiscordRichPresenceAsset(Config.LargeImage.name)
    SetDiscordRichPresenceAssetText(Config.LargeImage.hoverText)
    SetDiscordRichPresenceAssetSmall(Config.SmallImage.name)
    SetDiscordRichPresenceAssetSmallText(Config.SmallImage.hoverText)
end

local function buildPresenceText()
    local PlayerPedID = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedID, true))
    local streetHash = GetStreetNameAtCoord(x, y, z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local zoneName = getZoneName(x, y, z)
    local heading = getHeadingDirection(GetEntityHeading(PlayerPedID))
    local vehicle = GetVehiclePedIsUsing(PlayerPedID)
    local vehicleLabel = getVehicleLabel(vehicle)
    local speedMph = vehicle and math.ceil(GetEntitySpeed(vehicle) * 2.236936) or 0

    if zoneName == 'Cayo Perico' then return 'Hanging out on Cayo Perico' end

    if IsPedOnFoot(PlayerPedID) and not IsEntityInWater(PlayerPedID) then
        if IsPedStill(PlayerPedID) then
            return 'Standing on ' .. streetName .. ' [' .. zoneName .. ']'
        elseif IsPedWalking(PlayerPedID) then
            return 'Walking ' .. heading .. ' on ' .. streetName .. ' [' .. zoneName .. ']'
        elseif IsPedRunning(PlayerPedID) then
            return 'Running ' .. heading .. ' on ' .. streetName .. ' [' .. zoneName .. ']'
        elseif IsPedSprinting(PlayerPedID) then
            return 'Sprinting ' .. heading .. ' on ' .. streetName .. ' [' .. zoneName .. ']'
        end
    elseif vehicle and not IsPedOnFoot(PlayerPedID) and
        not IsPedInAnyHeli(PlayerPedID) and not IsPedInAnyPlane(PlayerPedID) and
        not IsPedInAnyBoat(PlayerPedID) and not IsPedInAnySub(PlayerPedID) then
        if speedMph < 2 then
            return 'Parked on ' .. streetName .. ' [' .. zoneName .. '] in a ' .. vehicleLabel
        else
            return 'Driving ' .. heading .. ' on ' .. streetName .. ' [' .. zoneName .. '] in a ' .. vehicleLabel
        end
    elseif IsPedInAnyHeli(PlayerPedID) or IsPedInAnyPlane(PlayerPedID) then
        if IsEntityInAir(vehicle) or GetEntityHeightAboveGround(vehicle) > 5.0 then
            return 'Flying near ' .. streetName .. ' [' .. zoneName .. '] in a ' .. vehicleLabel
        else
            return 'Landed on ' .. streetName .. ' [' .. zoneName .. '] in a ' .. vehicleLabel
        end
    elseif IsEntityInWater(PlayerPedID) then
        return 'Swimming near ' .. zoneName
    elseif IsPedInAnyBoat(PlayerPedID) and IsEntityInWater(vehicle) then
        return 'Boating near ' .. zoneName .. ' in a ' .. vehicleLabel
    elseif IsPedInAnySub(PlayerPedID) and IsEntityInWater(vehicle) then
        return 'Diving in a submersible'
    end

    return Config.DefaultPresence
end

local function initDiscordButtons()
    if StartDiscordPresence then
        for _, button in ipairs(Config.DiscordButtons) do SetDiscordRichPresenceAction(button.index, button.name, button.url) end
        StartDiscordPresence = false
    end
end

local function startPresenceLoop()
    updateAssets()
    CreateThread(function()
        while true do
            local sleep = 5000
            if WhichPresence == 'all' then
                setRichPresence(buildPresenceText())
            elseif WhichPresence == 'custom' then
                setRichPresence(CustomText)
            elseif WhichPresence == 'hide' then
                setRichPresence(Config.DefaultPresence)
                sleep = 10000
            else
                setRichPresence(Config.DefaultPresence)
                sleep = 10000
            end
            Wait(sleep)
        end
    end)
end

local function setPresenceMode(mode, customText)
    if mode == 'show' then
        WhichPresence = 'all'
    elseif mode == 'hide' then
        WhichPresence = 'hide'
    elseif mode == 'custom' then
        WhichPresence = 'custom'
        if customText then CustomText = customText end
    end
end

-- Event and Command Handlers
AddEventHandler('playerSpawned', function() initDiscordButtons() end)

RegisterCommand('discord', function(src, args)
    local option = args[1]
    local ctext = args[2]
    setPresenceMode(option, ctext)
end, false)

TriggerEvent('chat:addSuggestion', '/discord', 'Set your Discord Rich Presence status', {{name = "options", help = "show/hide/custom"}})

-- Start Discord Presence
startPresenceLoop()