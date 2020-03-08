save = {}

function save.writeData(id)
    local id = tonumber(id)

    -- open save file with write properties
    local file
    if player(id,"usgn") ~= 0 then
        file = io.open(directory.."users/"..player(id,"usgn")..".txt", "w")
    elseif player(id,"steamid") ~= "0" then
        file = io.open(directory.."users/"..player(id,"steamid")..".txt", "w")
    elseif Player[id].var_login then
        file = io.open(directory.."users/"..Player[id].var_login..".txt", "w")
    end

    -- does the file exists?
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
            -- proceed into writing the file contents
            file:write(table.serialize(tbl))
            file:flush()
            -- close the file
            file:close()
        else
            msg2(id,cloud.tags.server.."No stats found!")
        end
    end
end
