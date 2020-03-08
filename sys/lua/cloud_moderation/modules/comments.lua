comments = {}

function comments.retrieve_comments()
    local c_menu = {
        title = "Comments",
        comments = {},
        items = {},
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}},
        big = true,
    }

    local file = io.open(directory.."data/comments.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        c_menu.comments[line_index] = line
        local time, ip, steam, usgn, id, team, name, comment = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: (.+)%]: ([%w%p ]+)")
        local action_menu = {
            title = name.." - "..ip,
            items = {
                {"Ban Name","",function(id) parse("banname " ..name) end},
                {"Ban IP","",function(id) parse("banip " .. ip) end},
                {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgn) end},
                {"Ban STEAM","",function(id) parse("bansteam " ..steam) end},
                {"Delete Comment","",
                function(id)
                    local tbl = {}
                    for k, v in ipairs(c_menu.comments) do
                        if k ~= line_index then
                            table.insert(tbl,v)
                        end
                    end
                    local content = table.concat(tbl,"\n")
                    local fd = io.open(directory.."data/comments.txt", "w")
                    fd:write(content)
                    fd:close()

                    unimenu.open(id, comments.retrieve_comments())
                end
                },
                {"Erase all Comments","",
                function(id)
                    local fd = io.open(directory.."data/comments.txt", "w")
                    fd:write()
                    fd:close()

                    unimenu.open(id, comments.retrieve_comments())
                end},
                fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
            },
        }
        table.insert(c_menu.items, {time.." - "..name, comment, function(id) unimenu.open(id, action_menu) end})
        i = i + 1
    end
    file:close()
    file = nil

    return c_menu
end
