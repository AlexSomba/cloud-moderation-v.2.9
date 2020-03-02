lastlogged = {}

function join_module_lastlogged(id)
    for k, v in pairs(lastlogged) do
        if (v.ip == player(id, "ip")) then
            local oldname
            if (player(id, "name") ~= v.name) then
                oldname = v.name
            end
            lastlogged[k] = {
                ip = player(id, "ip"),
                usgnname = player(id, "usgnname"),
                usgn = player(id, "usgn"),
                time = os.time(),
                name = player(id, "name"),
                id = id
            }
            if (oldname) then
                if (not lastlogged[k].names) then lastlogged[k].names = {} end
                table.insert(lastlogged[k].names, oldname)
            end
            return
        end
    end
    table.insert(lastlogged, {
        ip = player(id, "ip"),
        usgnname = player(id, "usgnname"),
        usgn = player(id, "usgn"),
        time = os.time(),
        name = player(id, "name"),
        id = id
    })
end

function leave_module_lastlogged(id)
    for k, v in pairs(lastlogged) do
        if (v.id == id and v.ip == player(id, "ip")) then
            v.id = 0
            v.time = os.time()
        end
    end
end

function second_module_lastlogged()
    for k = #lastlogged, 1, -1 do
        local v = lastlogged[k]
        if (os.time()-v.time >= 600) then
            table.remove(lastlogged, k)
        end
    end
end

addhook("join","join_module_lastlogged",20)
addhook("leave","leave_module_lastlogged",20)
addhook("second","second_module_lastlogged",20)
