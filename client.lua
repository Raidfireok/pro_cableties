-- ESX
ESX               = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

-- Locals

local cuffed = false
local dict = "mp_arresting"
local anim = "idle"
local flags = 49
local ped = PlayerPedId()
local changed = false
local prevMaleVariation = 0
local prevFemaleVariation = 0
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")
local IsLockpicking    = false
local IsBreakable = true

-- Put on cableties
RegisterNetEvent('pro_cableties:tie')
AddEventHandler('pro_cableties:tie', function()
    ped = GetPlayerPed(-1)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

       ClearPedTasks(ped)
       SetEnableCableties(ped, false)
       Untied(ped)

        if GetEntityModel(ped) == femaleHash then -- mp female
            SetPedComponentVariation(ped, 7, prevFemaleVariation, 0, 0)
        elseif GetEntityModel(ped) == maleHash then -- mp male
            SetPedComponentVariation(ped, 7, prevMaleVariation, 0, 0)
        end    
    
    cuffed = not cuffed

    changed = true
end)
-- ENABLE WITH INSERT OF LINES IN ESX_POLICEJOB
--RegisterNetEvent('pro_cableties:cablecheck')
--AddEventHandler('pro_cableties:cablecheck', function()
--  local player, distance = ESX.Game.GetClosestPlayer()
--  if distance ~= -1 and distance <= 3.0 then
--  				  RequestAnimDict("amb@prop_human_bum_bin@idle_b")
--				  TaskPlayAnim(ped,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0, 130)
--								ESX.ShowNotification('~g~You have used your cableties')
--				Wait(8000)
--		TriggerServerEvent('esx_policejob:cabletied', GetPlayerServerId(player))
--				ESX.ShowNotification('~r~Person Tied/Loose')
-- else
--    ESX.ShowNotification('No players nearby')
--	end
--end)
-- ENABLE WITH INSERT OF LINES IN ESX_POLICEJOB
RegisterNetEvent('pro_cableties:lockcheck')
AddEventHandler('pro_cableties:lockcheck', function()
	local player, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('pro_cableties:cutting', GetPlayerServerId(player))
  else
    ESX.ShowNotification('No players nearby')
	end
end)

RegisterNetEvent('pro_cableties:cuttingcable')
AddEventHandler('pro_cableties:cuttingcable', function()
  local player, distance = ESX.Game.GetClosestPlayer()
	local ped = GetPlayerPed(-1)

	if IsBreakable == false then
		ESX.UI.Menu.CloseAll()
		FreezeEntityPosition(player,  true)
		FreezeEntityPosition(ped,  true)

		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

		IsBreakable = true

		Wait(30000)

		IsBreakable = false

		FreezeEntityPosition(player,  false)
		FreezeEntityPosition(ped,  false)

		ClearPedTasksImmediately(ped)

		TriggerServerEvent('pro_policejob:cabletied', GetPlayerServerId(player))
		ESX.ShowNotification('Cableties Cut')
	else
		ESX.ShowNotification('You are allready cutting them')
	end
end)

-- ??
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not changed then
            ped = PlayerPedId()
            local IsCuffed = IsPedCuffed(ped)
            if IsCuffed and not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
                Citizen.Wait(0)
                TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
            end
        else
            changed = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if cuffed then
        end
    end
end)