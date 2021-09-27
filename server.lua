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

-- Credits to discord docs for the api ref
function SendToDiscord(name, msg, col)
	local embed = {
		{
			["color"] = 9109247, -- If you have an issue with the string like this change it to "9109247"
			["title"] = "**"..name.."**",
			["description"] = msg,
			["footer"] = {
				["text"] = "discord.gg/Example"
			},
		}
	}
	PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Exploit Log", embeds = embed, avatar_url = "https://cdn.discordapp.com/attachments/891828087912796190/892186680839254086/fcdev.png"}), {['Content-Type'] = 'application/json'})
end
-- (Example of discord log)	SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'eventhere'\n**Resource:** "..GetCurrentResourceName())

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
                                SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'tryTackle'\n**Resource:** "..GetCurrentResourceName())

							end
						else
							log('^4esx_kekke_tackle: ^1'..srcName..'['..tonumber(src)..']^0 is attempting to exploit the event "tryTackle"! Their job was not police. Kicking player automatically.')
                            SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'tryTackle'\n**Resource:** "..GetCurrentResourceName())
							DropPlayer(src, 'Kicked for Cheating! Exploit Detected: esx_kekke_tackle:tryTackle\nName: '..srcName..'\nDetails: Job was not police.')
						end
					end
				end
			end
		end
	end
end)
