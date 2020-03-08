comments = {}

local function generateCommentItem(c_menu, line, i, line_index)
    local time, ip, steam, usgn, id, team, name, comment = string.match(line, "(%d+%-%d+%-%d+ %d+:%d+ [AP]M) %- %[IP: ([%d%.]+)%] %[STEAM: (%d+)%] %[USGN: (%d+)%] %[ID: (%d+)%] %[Team: (%d+)%] %[Name: (.+)%]: ([%w%p ]+)")

    local ban_menu = {
        title = name.." - "..ip,
        items = {
            {"Ban Name","",function(id) parse("banname " ..name) end},
            {"Ban IP","",function(id) parse("banip " .. ip) end},
            {"Ban U.S.G.N.","",function(id) parse("banusgn " ..usgn) end},
            {"Ban STEAM","",function(id) parse("bansteam " ..steam) end}
        },
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
    }

    local action_menu = {
        title = name.." - "..ip,
        items = {
            {"Issue a Ban",">",function(id) unimenu.open(id, ban_menu) end},
            {"","",function(id) end},
            {"","",function(id) end},
            {"","",function(id) end},
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
            end}
        },
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}}
    }

    return {time.." - "..name, comment, function(id) unimenu.open(id, action_menu) end}
end

function comments.retrieve_comments()
    local c_menu = {
        title = "Comments",
        items = {},
        fixedItems = {[7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}},
        big = true,
        comments = {},
    }

    local file = io.open(directory.."data/comments.txt", "r")
    if not file then return end
    local i = 1
    for line in file:lines() do
        local line_index = i
        c_menu.comments[line_index] = line

        table.insert(c_menu.items, generateCommentItem(c_menu, line, i, line_index))
        i = i + 1
    end
    file:close()
    file = nil

    return c_menu
end
