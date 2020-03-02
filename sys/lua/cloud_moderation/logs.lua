logs = {}

function logs.retrieve_logs()
    local l_menu = {
        logs = {},
        title = "Logs",
        items = {},
    }

    local file = io.open(directory.."data/logs.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        l_menu.logs[line_index] = line
        local time, ip, steam, usgn, id, team, name, comment = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: ([%w%p ]+)%]: ([%w%p ]+)")
        local action_menu = {
            title = name.." - "..usgn.." - "..ip,
            modifiers = "s",
            items = {
                {"Ban Name","",function(id) parse("banname " ..name) end},
                {"Ban IP","",function(id) parse("banip " .. ip) end},
                {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgn) end},
                {"Ban STEAM","",function(id) parse("bansteam " ..steam) end},
                {"","",function(id) end},
                {"Delete Log","",
                function(id)
                    local tbl = {}
                    for k, v in ipairs(l_menu.logs) do
                        if k ~= line_index then
                            table.insert(tbl,v)
                        end
                    end
                    local content = table.concat(tbl,"\n")
                    local fd = io.open(directory.."data/logs.txt", "w")
                    fd:write(content)
                    fd:close()
                end},
                {"Erase all Logs","",
                function(id)
                    local fd = io.open(directory.."data/logs.txt", "w")
                    fd:write()
                    fd:close()
                end}
            },
        }
        table.insert(l_menu.items, {name.." - "..usgn.." - "..ip, comment, function(id) unimenu(id, true, action_menu, 1) end})
        i = i + 1
    end
    file:close()
    file = nil

    if i == 1 then return end
    return l_menu
end
