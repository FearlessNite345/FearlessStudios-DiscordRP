function roundToNearest5(number)
  return math.floor(number / 5 + 0.5) * 5
end

Citizen.CreateThread(function() 
    SetDiscordAppId(config.DiscordAppID)
    SetDiscordRichPresenceAsset(config.RichPresenceLogoName)
    SetDiscordRichPresenceAssetSmall(config.SmallRichPresenceLogoName)
    SetDiscordRichPresenceAction(0, config.ServerNameAbbrv, config.DiscordLink)
    while true do 
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		Citizen.Wait(2500)
        if StreetHash ~= nil then
            StreetName = GetStreetNameFromHashKey(StreetHash)
            local player = PlayerPedId()
            if IsPedOnFoot(player) and not IsEntityInWater(player) then
                if IsPedSprinting(player) then 
                    SetRichPresence('Sprinting down '..StreetName)
                elseif IsPedRunning(player) then 
                    SetRichPresence('Running down '..StreetName)
                elseif IsPedWalking(player) then 
                    SetRichPresence('Walking down '..StreetName)
                elseif IsPedStill(player) then
                    SetRichPresence('Standing on '..StreetName)
                end
            elseif GetVehiclePedIsUsing(player) ~= nil and not IsPedInAnyHeli(player) and not IsPedOnAnyBike(player) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) and not IsPedInAnyPoliceVehicle(player) and not IsPedInAnyTaxi(player) then 
                local Speed = GetEntitySpeed(GetVehiclePedIsUsing(player))
                local CurrentSpeedMPH = math.ceil(Speed * 2.236936)
                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                if CurrentSpeedMPH > config.SpeedingThreshold then 
                    SetRichPresence('Speeding down '..StreetName..' Driving a '..VehName)
                elseif CurrentSpeedMPH < config.SpeedingThreshold and CurrentSpeedMPH > 1 then 
                    SetRichPresence('Cruising down '..StreetName)
                elseif CurrentSpeedMPH <= 1 then 
                    SetRichPresence('Parked on '..StreetName)
                end
            elseif GetVehiclePedIsUsing(player) ~= nil and IsPedInAnyPoliceVehicle(player) then
                local Speed = GetEntitySpeed(GetVehiclePedIsUsing(player))
                local CurrentSpeedMPH = math.ceil(Speed * 2.236936)
                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                if CurrentSpeedMPH > config.SpeedingThreshold then 
                    SetRichPresence('Speeding down '..StreetName)
                elseif CurrentSpeedMPH < config.SpeedingThreshold and CurrentSpeedMPH > 1 then 
                    SetRichPresence('Patroling on '..StreetName)
                elseif CurrentSpeedMPH <= 1 then 
                    SetRichPresence('Parked on '..StreetName)
                end
            elseif IsPedOnAnyBike(player) then 
                local Speed = GetEntitySpeed(GetVehiclePedIsUsing(player))
                local CurrentSpeedMPH = math.ceil(Speed * 2.236936)
                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                if CurrentSpeedMPH > config.SpeedingThreshold then 
                    SetRichPresence('Speeding down '..StreetName)
                elseif CurrentSpeedMPH < config.SpeedingThreshold and CurrentSpeedMPH > 1 then 
                    SetRichPresence('Riding down '..StreetName)
                elseif CurrentSpeedMPH <= 1 then 
                    SetRichPresence('Parked on '..StreetName)
                end
            elseif IsPedInAnyHeli(player) or IsPedInAnyPlane(player) then 
                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(player))))
                local height = roundToNearest5(GetEntityHeightAboveGround(GetVehiclePedIsUsing(player)) * 3.281)
                if IsEntityInAir(GetVehiclePedIsUsing(player) or height > 5.0) then 
                    SetRichPresence('Flying over '..StreetName..'at aprox '..height..' feet')
                else
                    SetRichPresence('Landed at '..StreetName)
                end
            elseif IsEntityInWater(player) then 
                SetRichPresence('Swimming')
            elseif IsPedInAnyBoat(player) and IsEntityInWater(GetVehiclePedIsUsing(player)) then 
                local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				SetRichPresence("Boating around in a "..VehName)
            elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("in a submarine")
            end
        end
    end
end)