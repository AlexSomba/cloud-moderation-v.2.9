logs = {}

function logs.retrieve_logs()
    local l_menu = {
        title = "Logs",
        items = {},
        fixedItems = {
	        [7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}
	    },
        big = true,
        logs = {},
	}

    local file = io.open(directory.."data/logs.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        l_menu.logs[line_index] = line
        local time, ip, steam, usgn, id, team, name, log = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: (.+)%]: ([%w%p ]+)")
        logs.action_menu = {
            [1] = {
                title = name.." - "..ip,
                items = {
                    {"Issue a Ban",">",function(id) unimenu.open(id, logs.action_menu[2]) end},
                    {"Mute Player",">",function(id) unimenu.open(id, logs.action_menu[3]) end},
                    {"","",function(id) end},
                    {"Show player info","",function(id) unimenu.open(id, logs.action_menu[4]) msg2(id,cloud.tags.server..time.." - "..name.." - "..ip.." - USGN: "..usgn.." - STEAM: "..steam.." - ID: "..id.." - Team: "..team.." - Log: "..log) end},
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
                fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
            },
            [2] = {
                title = name.." - "..ip,
                items = {
                    {"Ban Name","",function(id) parse("banname " ..name) end},
                    {"Ban IP","",function(id) parse("banip " .. ip) end},
                    {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgn) end},
                    {"Ban STEAM","",function(id) parse("bansteam " ..steam) end}
                },
                fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
            },
            [3] = {
                title = name.." - "..ip,
                items = {
                    {"5 Minutes","",function(id)
                        local var_mute_duration = 5
                        msg2(id,cloud.tags.server.."Player "..name.." will be muted for 5 minutes next time he rejoins the server.")
                    end},
                    {"30 Minutes","",function(id) end},
                    {"1 Hour","",function(id) end},
                    {"24 Hours","",function(id) msg2(id,cloud.tags.server.."This feature is in development.") end}
                },
                fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
            },
            [4] = {
                title = "Info - Click on an info button to print in chat.",
                items = {
                    {"Name",name,function(id) unimenu.historyBack(id) end},
                    {"IP",ip,function(id) unimenu.historyBack(id) end},
                    {"STEAM",steam,function(id) unimenu.historyBack(id) end},
                    {"USGN",usgn,function(id) unimenu.historyBack(id) end}
                },
                fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}},
                big = true
            }
        }
        table.insert(l_menu.items, {time.." - "..name, log, function(id) unimenu.open(id, logs.action_menu[1]) end})
        i = i + 1
    end
    file:close()
    file = nil

    return l_menu
end
