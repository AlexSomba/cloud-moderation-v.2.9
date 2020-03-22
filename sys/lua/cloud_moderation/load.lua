load = {}

-- assign saved data vars (steam/usgn found)
function load.assignSavedData(id, saved_data)
    for k, v in pairs(saved_data) do
        Player[id][k] = v
    end
    Player[id].var_login = nil
    load.assignRankCommands(id, Player[id].var_level_name)
end

function load.assignRankCommands(id, rank)
    Player[id].var_commands = {}
    for _, cmd in pairs(cloud.settings.users[rank].commands) do
        Player[id].var_commands[cmd] = true
    end
end

-- assign default user vars (no steam/usgn found)
function load.assignRankData(id, rank)
    -- Core script vars
    Player[id].var_level = cloud.settings.users[rank].level
    Player[id].var_level_name = rank
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
    load.assignRankCommands(id, rank)
    -- Other modules vars
    cloud.call_hook("firstload ", id, rank)
end

-- Login automatically
function load.readData(id)
    -- checks
    local id = tonumber(id)
    if not player(id,"exists") then
        return -- player does not exist, exit function
    end

    -- open save file with read properties
    local fileUSGN
    local fileSTEAM
    fileUSGN = io.open(directory.."users/"..player(id,"usgn")..".txt", "r")
    fileSTEAM = io.open(directory.."users/"..player(id,"steamid")..".txt", "r")

    -- read save file contents (deserialize) and parse its contents into a table
    -- and close the file
    local saved_data
    if fileUSGN then
        msg2(id,cloud.tags.server.."USGN-ID found.")
        saved_data = table.deserialize(fileUSGN:read("*a"))
        fileUSGN:close()
    elseif fileSTEAM then
        msg2(id,cloud.tags.server.."Steam-ID found.")
        saved_data = table.deserialize(fileSTEAM:read("*a"))
        fileSTEAM:close()
    end
    return saved_data
end

function load.loadData(id)
    -- read data
    local saved_data = load.readData(id)

    -- is the player vars loaded? proceed if not
    if Player[id].VARSLOADED == nil then
        -- check if save file exists and assign saved data vars (steam/usgn found)
        if saved_data then
            load.assignSavedData(id, saved_data)
        else
            msg2(id,cloud.tags.server.."USGN-ID/Steam-ID NOT Found, assigning default user vars.")
            if player(id,"ip") == "0.0.0.0" and cloud.settings.local_admin then
                load.assignRankData(id, "admin")
            else
                load.assignRankData(id, "user")
            end
        end
        Player[id].VARSLOADED = true
    end
end

-- Login manually (with command)
function load.loginUSGN(id, login, password)
    local fileUSGN = io.open(directory.."users/"..login..".txt", "r")
    local saved_data

    if fileUSGN then
        saved_data = table.deserialize(fileUSGN:read("*a"))
        fileUSGN:close()
    else
        msg2(id,cloud.tags.server.."No user found with ID: #"..login..", password: "..password)
    end

    if saved_data.var_usgn_password == password and login ~= nil then
        msg2(id,cloud.tags.server.."Success! Assigning user USGN#"..login.." vars!")
        msg2(id,cloud.tags.server.."You are now logged in as USGN#"..login)
        load.assignSavedData(id, saved_data)
        Player[id].var_login = login
    else
        msg2(id,cloud.tags.server.."The provided U.S.G.N. ID or password is incorrect!")
    end
end

function load.onLoad(id)
    local id = tonumber(id)
    if not player(id,"exists") then
        return -- player does not exist, exit function
    end
    -- assign some other statements after everything from the save file is loaded
    if Player[id].VARSLOADED then
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
        -- Display welcome message after 2 seconds have passed
        welcome = function(id)
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
        timer(2000,"welcome",id)
    end
end
