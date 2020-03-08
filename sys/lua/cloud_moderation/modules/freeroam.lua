freeroam = {}

-- Coordinates where Premium members spawns
freeroam.positions = {
    [1] = {37,4}
}

-- Coordinates where players spawns in a prison cell
freeroam.prison_cells = {
    [1] = {14,5}
}

freeroam.color = {string.char(169).."107142035"}

freeroam.settings = {
    -- general settings
    name = freeroam.color[1].."SAFE ZONE",
    zones = {
        -- use map editor to add more zones
        -- from x,y / to x,y
        {{2,2},{8,8}},
        {{1,12},{27,23}}
    },
    -- For how long you want to be protected after leaving the safe zone --
    duration = 3
}

local menu_tbl = {
    [1] = {
        title = "Premium Teleport",
        items = {
            {"Shop", "", function(id) parse("setpos "..id.." ".. 22*32+16 .." ".. 17*32+16) end},
            {"Blue Portal", "", function(id) parse("setpos "..id.." ".. 52*32+16 .." ".. 56*32+16) end},
            {"Red Portal", "", function(id) parse("setpos "..id.." ".. 22*32+16 .." ".. 82*32+16) end},
            {"White Portal", "", function(id) parse("setpos "..id.." ".. 4*32+16 .." ".. 150*32+16) end},
            {"Green Portal", "", function(id) parse("setpos "..id.." ".. 33*32+16 .." ".. 104*32+16) end}
        },
    },
    [2] = {
        title = "Premium Equip",
        items = {
            {"Deagle", "", function(id) parse("equip "..id.." 3") end},
            {"Wrench", "", function(id) parse("equip "..id.." 74") end},
            {"M4A1", "", function(id) parse("equip "..id.." 32") end},
            {"Armor", "50%", function(id) parse("equip "..id.." 80") end}
        },
    },
    [3] = {
        title = "Spawn Item",
        items = {
            {"Deagle", "", function(id) parse("spawnitem 3 42 3") end},
            {"Wrench", "", function(id) parse("spawnitem 74 42 3") end},
            {"M4A1", "", function(id) parse("spawnitem 32 42 3") end},
            {"Armor", "50%", function(id) parse("spawnitem 80 42 3") end}
        },
    },
    [4] = {
        title = "Travel to Ruins?",
        items = {
            {"Yes", "", function(id) parse("setpos "..id.." ".. 9*32+16 .." ".. 163*32+16) end},
            {"No", "", function(id) msg2(id,cloud.tags.server.."See you later aligator!") end}
        },
    }
}

function spawn_module_freeroam(id)
	if Player[id].var_level > 4 then
		parse("setpos "..id.." "..freeroam.positions[1][1]*32+16 .." "..freeroam.positions[1][2]*32+16)
	end
    if Player[id].var_prison then
        parse("setpos "..id.." ".. freeroam.prison_cells[1][1]*32+16 .." ".. freeroam.prison_cells[1][2]*32+16)
        msg2(id,cloud.tags.server.."You are still imprisoned for "..getTimeValues(id,"prison_duration"))
    end
end

function movetile_module_freeroam(id, x, y)
    for _,z in pairs(freeroam.settings.zones) do
        if x >= z[1][1] and y >= z[1][2] and x <= z[2][1] and y <= z[2][2] then
            if not freeroam[id].insafezone then
                freeroam[id].insafezone = true
                parse('hudtxt2 '..id..' 5 "'..freeroam.settings.name..'" 320 200 1')
                if freeroam[id].safe_protection == 1 then
                    freeroam[id].safe_protection = 0
                    parse('hudtxt2 '..id..' 7 "" 320 200 1')
                end
            end
            break
        else
            if freeroam[id].insafezone then
                freeroam[id].insafezone = false
                freeroam[id].safe_protection = 1
                freeroam[id].safe_timer = freeroam.settings.duration
                parse('hudtxt2 '..id..' 5 "" 320 200 1')
            end
        end
    end
    if x == 22 and y >= 106 and y <= 108 or x == 14 and y == 109 then
        if Player[id].var_level < 4 then
            parse("setpos "..id.." "..(player(id,"x")+32).." "..player(id,"y"))
            msg2(id,cloud.tags.server.."Premium members only I'm afraid.")
            msg2(id,cloud.tags.server.."Register at discord.gg/xYyM3zQ and get your premium rank!")
        end
    elseif x == 37 and y == 7 then
        unimenu.open(id, menu_tbl[1])
    elseif x == 37 and y == 2 then
        unimenu.open(id, menu_tbl[2])
    elseif x == 42 and y == 3 then
        unimenu.open(id, menu_tbl[3])
    elseif x == 68 and y == 40 then
        unimenu.open(id, menu_tbl[4])
    elseif x == 68 and y == 69 then
        unimenu.open(id, menu_tbl[1])
    elseif x == 76 and y == 81 then
        unimenu.open(id, menu_tbl[3])
    end
end

function second_module_freeroam()
    for _, id in ipairs(player(0,"table")) do
        if Player[id] then
            if Player[id].var_prison then
                if Player[id].var_prison_duration > 0 then
                    Player[id].var_prison_duration = Player[id].var_prison_duration - 1
                    parse('hudtxt2 '..id..' 13 '..string.char(169)..'153255255Prison: '..string.char(169)..'255255255'..getTimeValues(id,"prison_duration")..'" 15 140')
                end
                if Player[id].var_prison_duration == 0 then
                    Player[id].var_prison = false
                    Player[id].var_prison_duration = 0
                    parse("hudtxt2 "..id.." 13 \"\" 15 140")
                    if player(id,"health") > 0 then
                        parse("killplayer "..id)
                    end
                    msg2(id,"You have been un-prisoned!")
                end
            end

            if freeroam[id].safe_timer then
                if freeroam[id].safe_timer > 0 then
                    freeroam[id].safe_timer = freeroam[id].safe_timer -1
                end

                if freeroam[id].safe_timer == 0 then
                    freeroam[id].safe_protection = 0
                    parse('hudtxt2 '..id..' 7 "" 320 200 1')
                end
            end

            if freeroam[id].safe_protection == 1 then
                parse('hudtxt2 '..id..' 7 "'..freeroam.settings.name..' '..string.char(169)..'255000000 '..freeroam[id].safe_timer..'" 320 200 1')
            end
        end
    end
end

function join_module_freeroam(id)
    freeroam[id] = {}
    freeroam[id].safe_timer = 0
    freeroam[id].insafezone = false
    freeroam[id].safe_protection = 0
end

function walkover_module_freeroam(id, iid, type, ain, a, mode)
    if Player[id].var_level < 6 then
        if type == 88 or type == 45 then
            msg2(id,cloud.tags.server.."You have stumbled upon an Admin weapon, and is too heavy to lift it up!")
            return 1
        end
    end
end

function die_module_freeroam(victim, killer, weapon, x, y, killerobject)
    if player(victim,"exists") and player(victim,"money") > 0 then
        local money
        if player(victim,"money") >= 1000 then
            money = player(victim,"money") - 1000
            parse("spawnitem".. " 68 " .. player(victim,"tilex") .. " " .. player(victim,"tiley"))
        elseif player(victim,"money") >= 500 then
            money = player(victim,"money") - 500
            parse("spawnitem".. " 67 " .. player(victim,"tilex") .. " " .. player(victim,"tiley"))
        elseif player(victim,"money") >= 100 then
            money = player(victim,"money") - 100
            parse("spawnitem".. " 66 " .. player(victim,"tilex") .. " " .. player(victim,"tiley"))
        end
        parse("setmoney ".. victim .. " " ..money)
    end
end

freeroam.advertise = {
    "gfx/cloud/freeroam/advertise/battlefield.png",
    "gfx/cloud/freeroam/advertise/freeroam.png",
    "gfx/cloud/freeroam/advertise/rpgaurora.png",
    "gfx/cloud/freeroam/advertise/trenchwars.png",
    "gfx/cloud/freeroam/advertise/zombieplague.png"
}

freeroam.img = image(freeroam.advertise[1],34*32+16,112*32+16,3)

function usebutton_module_freeroam(id, x, y)
    local index = math.random(1,#freeroam.advertise)
    if entity(x,y,"name") == "advbutton" then
        freeimage(freeroam.img)
        freeroam.img = image(freeroam.advertise[index],34*32+16,112*32+16,3)
    end
end

freeroam.commands = {
    -- Freeroam module commands
    prison = {
		syntax = cloud.tags.syntax.."!prison <id> <duration> <crime> <fee>",
		about = cloud.tags.about.."Imprisons a player, duration is in minutes and cannot be higher than 60 minutes.",
		func = function(id, pl, text, tbl)
            local duration = tonumber(tbl[3])
            if playerExists(id, pl) then
                if duration then
                    if duration > 0 and duration <= 60 then
                        Player[pl].var_prison = true
                        Player[pl].var_prison_duration = duration*60
                    else
                        if duration == 0 then
                            Player[pl].var_prison_duration = 0
                        end
                    end
                end
                if tbl[4] then
                    Player[pl].var_prisoncrime = tbl[4]
                else
                    Player[pl].var_prisoncrime = "No description."
                end
                if tbl[5] then
                    Player[pl].var_prisonfee = tonumber(tbl[5])
                else
                    Player[pl].var_prisonfee = 0
                end
                if Player[id].var_level >= Player[pl].var_level then
                    parse("setpos "..id.." ".. freeroam.prison_cells[1][1]*32+16 .." ".. freeroam.prison_cells[1][2]*32+16)
                    msg(cloud.tags.server.."Player "..player(pl,"name").." has been imprisoned for "..getTimeValues(pl,"prison_duration").." Crime: "..Player[pl].var_prisoncrime.." Fee: "..Player[pl].var_prisonfee)
                else
            		msg2(id,cloud.error.authorisation)
                end
            end
		end,
	},

    unprison = {
		syntax = cloud.tags.syntax.."!unprison <id>",
		about = cloud.tags.about.."Unprisons a imprisoned player.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                if Player[id].var_level >= Player[pl].var_level then
                    if Player[pl].var_prison then
        				Player[pl].var_prison = false
                        Player[pl].var_prison_duration = 0
                        Player[pl].var_prisoncrime = ""
                        Player[pl].var_prisonfee = 0
                        parse("hudtxt2 "..pl.." 13 \"\" 15 140")
                        parse("killplayer "..pl)
        				msg(cloud.tags.server.."Player "..player(pl,"name").." has been unprisoned.")
                    else
                        msg2(id,cloud.tags.server.."This player is allready un-prisoned!")
                    end
            	else
            		msg2(id,cloud.error.authorisation)
            	end
            end
		end,
	},

    payfee = {
		syntax = cloud.tags.syntax.."!payfee",
		about = cloud.tags.about.."",
		func = function(id, pl, text, tbl)
            if Player[id].var_prison then
                if Player[id].var_prisonfee ~= 0 then
                    if player(id,"money") > Player[id].var_prisonfee then
                        parse("setmoney "..id.." "..player(id,"money")-Player[id].var_prisonfee)
        				Player[id].var_prison = false
                        Player[id].var_prison_duration = 0
                        Player[id].var_prisoncrime = ""
                        Player[id].var_prisonfee = 0
                        parse("hudtxt2 "..id.." 13 \"\" 15 140")
                        parse("killplayer "..id)
        				msg(cloud.tags.server.."Player "..player(id,"name").." has been unprisoned.")
                    else
                        msg2(id,cloud.tags.server.."You do not have enough money to pay the Fee!")
                    end
                else
                    msg2(id,cloud.tags.server.."You cannot pay your fee!")
                end
            else
                msg2(id,cloud.tags.server.."This player is allready un-prisoned!")
            end
		end,
	}
}

-- Load commands
addCommandModule("freeroam", freeroam.commands)

-- What vars to load?
freeroam.vars = {"var_prison","var_prison_duration","var_prisonfee","var_prisoncrime"}

cloud.register_player_vars(freeroam.vars)

-- Load vars
cloud.on("firstload ", function(id, rank)
    Player[id].var_prison = false
    Player[id].var_prison_duration = 0
    Player[id].var_prisonfee = 0
    if Player[id].var_prisoncrime == nil then
        Player[id].var_prisoncrime = ""
    end
end)

addhook("spawn","spawn_module_freeroam",-999999)
addhook("movetile","movetile_module_freeroam",-999999)
addhook("second","second_module_freeroam",-999999)
addhook("join","join_module_freeroam",-999999)
addhook("walkover","walkover_module_freeroam",-999999)
addhook("die","die_module_freeroam",-999999)
addhook("usebutton","usebutton_module_freeroam",-999999)
--addhook("hit","hit_module_freeroam")

parse("mp_hudscale 2")
