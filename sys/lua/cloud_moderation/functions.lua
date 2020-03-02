function readData(id, login, password)
    -- checks
    local id = tonumber(id)
    if not player(id,"exists") then
        return -- player does not exist, exit function
    end
    -- actual function
    local fileUSGN
    local fileSTEAM
    if login then
        fileUSGN = io.open(directory.."users/"..login..".txt")
    else
        fileUSGN = io.open(directory.."users/"..player(id,"usgn")..".txt")
        fileSTEAM = io.open(directory.."users/"..player(id,"steamid")..".txt")
    end
    local saved_data
    local assign_data = function(id)
        if fileUSGN then
            saved_data = table.deserialize(fileUSGN:read("*a"))
        elseif fileSTEAM then
            saved_data = table.deserialize(fileSTEAM:read("*a"))
        end
        -- Vars are not loaded, assign vars on join
        if Player[id].VARSLOADED == nil then
            assignSavedData(id, saved_data)
        end
        -- Login manually (with command)
        if password ~= nil then
            if saved_data.var_usgn_password == password and login ~= nil then
                msg2(id,cloud.tags.server.."Assigning user #"..login.." vars!")
                assignSavedData(id, saved_data)
                Player[id].var_login = login
            else
                msg2(id,cloud.tags.server.."The provided U.S.G.N. ID or password is incorrect!")
            end
        end
    end
    -- assign vars
    if fileUSGN then
        msg2(id,cloud.tags.server.."USGN-ID found.")
        assign_data(id)
        fileUSGN:close()
        fileUSGN = nil
        Player[id].VARSLOADED = true
    else
        if fileSTEAM then
            msg2(id,cloud.tags.server.."Steam-ID found.")
            assign_data(id)
            fileSTEAM:close()
            fileSTEAM = nil
            Player[id].VARSLOADED = true
        else
            if Player[id].VARSLOADED == nil then
                msg2(id,cloud.tags.server.."USGN-ID/Steam-ID NOT Found, assigning default user vars.")
                if player(id,"ip") == "0.0.0.0" and cloud.settings.local_admin then
                    assignRankData(id, "admin")
                else
                    assignRankData(id, "user")
                end
                Player[id].VARSLOADED = true
            else
                msg2(id,cloud.tags.server.."No user found with ID: #"..login..", password: "..password)
            end
        end
    end
    -- assign some other statements after everything from the save file is loaded
    if Player[id].VARSLOADED == true then
        -- Automatically ban players in the blacklist
        if cloud.settings.cloud_buster.ban_blacklisted then
            if Player[id].var_level == -1 then
                parse('banip '..player(id, "ip")..' "0" "\169255000000You have been blacklisted."')
                msg(cloud.tags.server..player(id, "name").." is in the blacklist and has been automatically kicked out.")
            end
        end
        -- Automatically turn ON players TAG (doesn't apply on server staff level ranks)
        if Player[id].var_level > -2 and Player[id].var_level < 4 then
            Player[id].var_tag_toggle = true
        end
        -- Cloud Buster Automatically rename inappropriate player's names
        if cloud.settings.cloud_buster.names_censor then
            if Player[id].var_level < 4 then
                CB_Join_censorName(id)
            end
        end
        -- Display welcome message
        timer(2000,"welcome",id)
    end
end

function writeData(id)
    local id = tonumber(id)
    -- create a save file for logged in users
    local file
    if player(id,"usgn") ~= 0 then
        file = io.open(directory.."users/"..player(id,"usgn")..".txt", "w")
    elseif player(id,"steamid") ~= "0" then
        file = io.open(directory.."users/"..player(id,"steamid")..".txt", "w")
    elseif Player[id].var_login then
        file = io.open(directory.."users/"..Player[id].var_login..".txt", "w")
    end
    if file then
        if Player[id].VARSLOADED == true then
            -- Disable these vars before saving
            Player[id].var_grab_toggle = false
            ------------------------------------
            -- Save vars that are written in the vars_list table in config
            local tbl = {}
            for _, field in pairs(cloud.settings.vars_list) do
                tbl[field] = Player[id][field]
            end
            file:write(table.serialize(tbl))
            file:flush()
            file:close()
            file = nil
            Player[id].VARSLOADED = nil
        else
            msg2(id,cloud.tags.server.."No stats found!")
        end
    end
end

function assignSavedData(id, saved_data)
    for k, v in pairs(saved_data) do
        Player[id][k] = v
    end
    Player[id].var_login = nil
    assignRankCommands(id, Player[id].var_level_name)
end

function assignRankData(id, rank)
    -- Core script vars
    Player[id].var_level = cloud.settings.users[rank].level
    Player[id].var_level_name = cloud.settings.users[rank].name
    Player[id].var_tag_name = cloud.settings.users[rank].tag
    Player[id].var_tag_color = cloud.settings.users[rank].tag_color
    Player[id].var_tag_toggle = true -- You can set this to 0 after the function call in the data loading function
    Player[id].var_god_toggle = false
    Player[id].var_tele_toggle = false
    Player[id].var_bigears_toggle = false
    Player[id].var_mute_toggle = false
    Player[id].var_mute_duration = 0
    if Player[id].var_usgn_password == nil then
        Player[id].var_usgn_password = ""
    end
    Player[id].var_login = nil
    Player[id].var_grab_toggle = false
    Player[id].var_grab_targetID = 0 -- this is actually the taget ID number
    assignRankCommands(id, rank)
    -- Other modules vars
    cloud.call_hook("firstload ", id, rank)
end

function assignRankCommands(id, rank)
    Player[id].var_commands = {}
    for _, cmd in pairs(cloud.settings.users[rank].commands) do
        Player[id].var_commands[cmd] = true
    end
end

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

-- Oher functions
function welcome(id)
    if player(id,"exists") then
        msg2(id,colors("cotton_candy").."== Cloud Moderation Version - "..cloud.settings.version.." ==")
        msg2(id,colors("cotton_candy").."== "..game("sv_name").." ==")
        msg2(id,colors("lime").."Welcome '"..player(id,"name").."' (U.S.G.N.: "..player(id,"usgnname").."#"..player(id,"usgn")..") "..player(id,"steamname").." (IP: "..player(id,"ip")..")")
        msg2(id,colors("electric_blue").."!comment <comment>"..colors("white").." - Leave us a comment/suggestion!")
        msg2(id,colors("white").."For help say "..colors("electric_blue").."!help"..colors("white")..", how to use the commands is also displayed.")

        parse('hudtxt2 '..id..' 99 '..colors("white")..cloud.settings.server..'" 470 100')
        parse('hudtxt2 '..id..' 100 '..colors("white")..cloud.settings.contact..'" 420 115')
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
