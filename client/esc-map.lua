local preventPropSpaz = false
local Animation = false

local function clearAnimation()
    local playerPed = PlayerPedId()
    Animation = false
    ClearPedTasks(playerPed)
    exports['rpemotes-reborn']:EmoteCancel()
end

local function startAnimation()
    if not preventPropSpaz then
        Animation = true
        preventPropSpaz = true
        exports['rpemotes-reborn']:EmoteCommandStart('map2')
    end
end

CreateThread(function()
    local sleep = 1000
    while true do
        local playerPed = PlayerPedId()
        if IsPauseMenuActive() then
            startAnimation()
            sleep = 1
        else
            if Animation then clearAnimation() end
            preventPropSpaz = false
            sleep = 1000
        end
        Wait(sleep)
    end
end)