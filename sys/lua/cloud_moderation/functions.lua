function displayUserCommands(id)
    local available = getUserCommands(id)
    for k, _ in ipairs(available) do
        if (k == 1) then
            msg2(id,cloud.tags.server..available[k])
        else
            msg2(id,cloud.tags.server..available[k])
        end
    end
end

function getUserCommands(id)
    local maxChars = 80

    local lines = {}
    local curLine = 1
    for k, _ in pairs(Player[id].var_commands) do
        if (not lines[curLine]) then
            lines[curLine] = cloud.settings.say_prefix[1]..k
        else
            lines[curLine] = lines[curLine]..", "..cloud.settings.say_prefix[1]..k
        end
        if (#lines[curLine] > maxChars) then
            lines[curLine] = lines[curLine]..","
            curLine = curLine + 1
        end
    end
    return lines
end

function getTimeValues(id,val)
    local duration
    local usgn = player(id, "usgn")
    local steam = player(id, "steamid")
    if val == "mute_duration" then
        duration = Player[id].var_mute_duration
    elseif val == "prison_duration" then
        duration = Player[id].var_prison_duration
    elseif val == "idle_time" then
        duration = tonumber(player(id, "idle"))
    elseif val == "played_time" then
        if usgn ~= 0 then
    		duration = tonumber(stats(usgn, "secs"))
    	elseif steam ~= "0" and usgn == 0 then
    		duration = tonumber(steamstats(steam, "secs"))
    	elseif steam == "0" and usgn == 0 then
    		duration = "No USGN or STEAM id found"
    	end
    end
    if duration <= 60 then
		return duration .. " secs"
	elseif duration > 60 and duration <= 3600 then
		return math.floor(duration/60) .. " mins"
	elseif duration > 3600 and duration <= 86400 then
		return math.floor(duration/3600) .. " hours"
	elseif duration > 86400 then
		return math.floor(duration/43200) .. " days"
	end
end

-- CLOUD BUSTER
-- Censor Names on Join
function CB_Join_censorName(id)
    local name = player(id, "name")
    for _, pattern in pairs(cloud.settings.censored_names) do
        if name:match(pattern) then
            util.rename_as(id, "Player")
            msg2(id,cloud.tags.buster.."Your name was inappropriate and has therefore been changed.")
            return
        end
    end
end

function addCommandModule(name, module)
    cloud.command_modules[name] = module
    print(print_mod.."COMMAND MODULE - "..name.." LOADED!")
end

-- Mostly used to check if a player ID is provided, if the player exists then return true
function playerExists(id, pl)
    if pl then
        if player(pl,"exists") then
            return true
        else
            msg2(id,cloud.error.noexist)
        end
    else
        msg2(id,cloud.error.noid)
    end
end

function returnToggleValue(id, name)
    return Player[id][name] and "ON" or "OFF"
end
