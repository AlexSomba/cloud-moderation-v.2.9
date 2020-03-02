reports = {}

function reports.retrieve_reports()
    local r_menu = {
        reports = {},
        title = "Reports Issued by Players",
        items = {},
    }

    local file = io.open(directory.."data/reports.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        r_menu.reports[line_index] = line
        local time, ip, steam, usgn, id, team, name, nameTarget, steamTarget, usgnTarget, ipTarget, reason = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: ([%w%p ]+)%] %>> ([%w%p ]+) %| (%d+) %| (%d+) %| ([%d%.]+) %: ([%w%p ]+)")
        local action_menu = {
            title = nameTarget.." - "..usgnTarget.." - "..ipTarget,
            modifiers = "s",
            items = {
                {"Ban Name","",function(id) parse("banname " ..nameTarget) end},
                {"Ban IP","",function(id) parse("banip " .. ipTarget) end},
                {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgnTarget) end},
                {"Ban STEAM","",function(id) parse("bansteam " ..steamTarget) end},
                {"","",function(id) end},
                {"Delete Report","",
                function(id)
                    local tbl = {}
                    for k, v in ipairs(r_menu.reports) do
                        if k ~= line_index then
                            table.insert(tbl,v)
                        end
                    end
                    local content = table.concat(tbl,"\n")
                    local fd = io.open(directory.."data/reports.txt", "w")
                    fd:write(content)
                    fd:close()
                end
                },
                {"Erase all Reports","",
                function(id)
                    local fd = io.open(directory.."data/reports.txt", "w")
                    fd:write()
                    fd:close()
                end}
            },
        }
        table.insert(r_menu.items, {time.." - "..name, reason, function(id) unimenu(id, true, action_menu, 1) end})
        i = i + 1
    end
    file:close()
    file = nil

    return r_menu
end
