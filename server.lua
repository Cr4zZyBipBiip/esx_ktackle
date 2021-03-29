--Original Author: -- 2018 Henric 'Kekke' Johansson
--Edited & Patched By: Vyast

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getCoords(player)
	local coords = nil
	if player ~= nil then
		local ped = GetPlayerPed(player)
		if ped ~= nil then
			coords = GetEntityCoords(ped)
		end
	end
	return coords
end

local function log(info)
	print(info)
end

RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local src = source
	if src ~= nil and target ~= nil and target ~= -1 then
		local srcName = GetPlayerName(src)
		if srcName ~= nil then
			local xPlayer = ESX.GetPlayerFromId(src)
			local xTarget = ESX.GetPlayerFromId(target)
			
			local srcCoords, tgtCoords = getCoords(src), getCoords(target)

			if srcCoords ~= nil and tgtCoords ~= nil then
				local dist = #(srcCoords - tgtCoords)
				if xPlayer ~= nil and xTarget ~= nil then
					if xPlayer.job ~= nil then
						if xPlayer.job.name == 'police' then 
							if dist <= 7.5 then
								TriggerClientEvent('esx_kekke_tackle:getTackled', xTarget.source, src)
								TriggerClientEvent('esx_kekke_tackle:playTackle', src)
							else
								log('^4esx_kekke_tackle: ^1'..srcName..'['..tonumber(src)..']^0 is attempting to exploit the event "tryTackle"! Their distance from the target player is ^1'..dist..'^0.')
							end
						else
							log('^4esx_kekke_tackle: ^1'..srcName..'['..tonumber(src)..']^0 is attempting to exploit the event "tryTackle"! Their job was not police. Kicking player automatically.')
							DropPlayer(src, 'Kicked for Cheating! Exploit Detected: esx_kekke_tackle:tryTackle\nName: '..srcName..'\nDetails: Job was not police.')
						end
					end
				end
			end
		end
	end
end)
