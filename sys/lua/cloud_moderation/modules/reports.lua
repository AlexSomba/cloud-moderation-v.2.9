reports = {}

local function generateReportItem(r_menu, line, i, line_index)
    local time, ip, steam, usgn, id, team, name, nameTarget, steamTarget, usgnTarget, ipTarget, reason = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: (.+)%] %>> (.+) %| (%d+) %| (%d+) %| ([%d%.]+) %: ([%w%p ]+)")

    local ban_menu = {
        title = nameTarget.." - "..ipTarget,
        items = {
            {"Ban Name","",function(id) parse("banname " ..nameTarget) end},
            {"Ban IP","",function(id) parse("banip " .. ipTarget) end},
            {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgnTarget) end},
            {"Ban STEAM","",function(id) parse("bansteam " ..steamTarget) end}
        },
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
    }

    local action_menu = {
        title = nameTarget.." - "..ipTarget,
        items = {
            {"Issue a Ban",">",function(id) unimenu.open(id, ban_menu) end},
            {"","",function(id) end},
            {"","",function(id) end},
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

                unimenu.open(id, reports.retrieve_reports())
            end
            },
            {"Erase all Reports","",
            function(id)
                local fd = io.open(directory.."data/reports.txt", "w")
                fd:write()
                fd:close()

                unimenu.open(id, reports.retrieve_reports())
            end}
        },
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
    }

    return {time.." - "..nameTarget, reason, function(id) unimenu.open(id, action_menu) end}
end

function reports.retrieve_reports()
    local r_menu = {
        title = "Reports Issued by Players",
        items = {},
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}},
        reports = {},
        big = true,
	}

    local file = io.open(directory.."data/reports.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        r_menu.reports[line_index] = line

        table.insert(r_menu.items, generateReportItem(r_menu, line, i, line_index))
        i = i + 1
    end
    file:close()
    file = nil

    return r_menu
end
