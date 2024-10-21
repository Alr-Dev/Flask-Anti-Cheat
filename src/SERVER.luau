local HttpService = game:GetService("HttpService")
local BAN_SERVER_URL = "http://127.0.0.1:5000"


local reportExploitEvent = Instance.new("RemoteEvent")
reportExploitEvent.Name = "ReportExploit"
reportExploitEvent.Parent = game.ReplicatedStorage


local function checkIfBanned(player)
	local data = {
		user_id = player.UserId
	}

	local success, response = pcall(function()
		return HttpService:PostAsync(BAN_SERVER_URL .. "/check_ban", HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		print('[API] Connect Sucess')
		local result = HttpService:JSONDecode(response)
		if result.status == "banned" then
			player:Kick('You are banned.')
		end
	else
		warn("[API] Failed to check ban status: " .. tostring(response))
	end
end


game.Players.PlayerAdded:Connect(function(player)
	checkIfBanned(player)
end)


local function banPlayer(player, reason)
	local data = {
		user_id = player.UserId,
		reason = reason
	}

	local success, response = pcall(function()
		return HttpService:PostAsync(BAN_SERVER_URL .. "/ban", HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		print(player.Name .. " has been banned for: " .. reason)
		player:Kick("You have been banned for: " .. reason)
	else
		warn("Failed to ban player: " .. tostring(response))
	end
end

reportExploitEvent.OnServerEvent:Connect(function(player, exploitType)
	if exploitType == "yourexploitype" then
		-- here u can add for your customize, using the banPlayer function, example:
		--[[
		banPlayer(player, "Chams detected.")

	elseif exploitType == "WalkSpeedexploit" then
		banPlayer(player, "WalkSpeed exceeded the limit")

	elseif exploitType == "flying_detected" then
		banPlayer(player, "Flying detected")

	elseif exploitType == "HBE detected" then
		banPlayer(player)  

	elseif exploitType == "antidestroy" then
		banPlayer(player) 
		]]
	end
end)
