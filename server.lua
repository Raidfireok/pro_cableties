ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('cableties', function(source) -- Added to get handcuff animations and procedure. 
	local xPlayer = ESX.GetPlayerFromId(source)	       -- Will most likely break with usage of knife. Explore option and test

	TriggerClientEvent('pro_cableties:cablecheck', source)
end)

RegisterServerEvent('pro_cableties:cabletied')
AddEventHandler('pro_cableties:cabletied', function(source)
  TriggerClientEvent('pro_cableties:tied', source)
end)

----
ESX.RegisterUsableItem('knife', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('knife', 1)

	TriggerClientEvent('pro_cableties:cuttingcable', source)
end)

RegisterServerEvent('pro_cableties:cutting')
AddEventHandler('pro_cableties:cutting', function(source)
  TriggerClientEvent('pro_cableties:cuttingcable', source)
end)