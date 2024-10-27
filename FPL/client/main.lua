-- Automatic First Person POV Lock Script
local isFirstPerson = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Run every frame

        local playerPed = PlayerPedId()

        -- Check if the player is in a vehicle
        if IsPedInAnyVehicle(playerPed, false) then
            if isFirstPerson then
                -- If in a vehicle, reset first-person mode
                SetFollowPedCamViewMode(0) -- Reset to default camera mode
                isFirstPerson = false
            end
            Citizen.Wait(500) -- Check every half second if in vehicle
            goto continue
        end

        -- Check if the player is holding a weapon
        if IsPedArmed(playerPed, 6) then
            -- If not already in first person mode, switch to first person
            if not isFirstPerson then
                SetFollowPedCamViewMode(4) -- Set to first person
                isFirstPerson = true
            end

            -- Prevent camera mode change while holding a weapon
            if IsControlJustPressed(0, 25) or IsControlJustPressed(0, 263) then -- Right mouse button or another control
                -- Keep it in first person
                SetFollowPedCamViewMode(4) -- Force first person mode
            end
        else
            -- If not holding a weapon and is in first person, revert to default
            if isFirstPerson then
                SetFollowPedCamViewMode(0) -- Reset to default camera mode
                isFirstPerson = false
            end
        end

        ::continue::
    end
end)
