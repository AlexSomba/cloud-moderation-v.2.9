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
        local time, ip, steam, usgn, id, team, name, log = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: ([%w%p ]+)%]: ([%w%p ]+)")
        print(time.." "..ip.." "..steam.." "..usgn.." "..id.." "..team.." "..name.." "..log)
        logs.action_menu = {
            [1] = {
                title = name.." - "..ip,
                modifiers = "s",
                items = {
                    {"Issue a Ban",">",function(id) unimenu(id, true, logs.action_menu[2], 1) end},
                    {"Mute Player",">",function(id) unimenu(id, true, logs.action_menu[3], 1) end},
                    {"","",function(id) end},
                    {"","",function(id) end},
                    {"Show player info","",function(id) msg2(id,cloud.tags.server..time.." - "..name.." - "..ip.." - USGN: "..usgn.." - STEAM: "..steam.." - ID: "..id.." - Team: "..team.." - Log: "..log) end},
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
            },
            [2] = {
                title = name.." - "..ip,
                modifiers = "s",
                items = {
                    {"Ban Name","",function(id) parse("banname " ..name) end},
                    {"Ban IP","",function(id) parse("banip " .. ip) end},
                    {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgn) end},
                    {"Ban STEAM","",function(id) parse("bansteam " ..steam) end}
                },
            },
            [3] = {
                title = name.." - "..ip,
                modifiers = "s",
                items = {
                    {"5 Minutes","",function(id) msg2(id,cloud.tags.server.."This feature is in development.") end},
                    {"30 Minutes","",function(id) msg2(id,cloud.tags.server.."This feature is in development.") end},
                    {"1 Hour","",function(id) msg2(id,cloud.tags.server.."This feature is in development.") end},
                    {"24 Hours","",function(id) msg2(id,cloud.tags.server.."This feature is in development.") end}
                },
            }
        }
        table.insert(l_menu.items, {time.." - "..name, log, function(id) unimenu(id, true, logs.action_menu[1], 1) end})
        i = i + 1
    end
    file:close()
    file = nil

    if i == 1 then return end
    return l_menu
end
