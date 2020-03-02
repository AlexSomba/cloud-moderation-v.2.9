cloud.commands = {
	-- User commands
    help = {
        syntax = cloud.tags.syntax.."!help <command name>",
        about = cloud.tags.about.."Get help for a particular command.",
        func = function(id, pl, text, tbl)
            -- If a command has been supplied, if it exists in the table, and if it has a help message (i.e. if none of those are nil)
            for _, module_name in pairs(cloud.settings.enabled_command_modules) do
                local command_module = cloud.command_modules[module_name]
                if tbl[2] and command_module[tbl[2]] and command_module[tbl[2]].about then
                    msg2(id,command_module[tbl[2]].syntax)
                    msg2(id,command_module[tbl[2]].about)
                    return 1
                end
            end
            msg2(id,cloud.tags.server.."You must specify a particular command to get help for!")
            displayUserCommands(id)
        end,
	},

	pm = {
		syntax = cloud.tags.syntax.."!pm <id>",
        about = cloud.tags.about.."Sends a private message to someone.",
		func = function(id, pl, text, tbl)
			local pmsg = string.sub(text,(string.len("!pm")+1+string.len(id)+1),#text)
            if playerExists(id, pl) then
                if pmsg ~= nil then
					if id ~= pl then
						msg2(pl,cloud.tags.pm.."< "..player(id,"name").." ("..id..")]:"..pmsg)
						msg2(id,cloud.tags.pm.."> "..player(pl,"name").." ("..pl..")]:"..pmsg)
                        -- display others PM for moderators (bigears)
                        for _, all in pairs(player(0,"table")) do
                            if Player[all].var_bigears_toggle then
                                if all ~= id and all ~= pl then
                                    msg2(all,cloud.tags.pm..player(id,"name").." ("..id..") > "..player(pl,"name").." ("..pl..")]:"..pmsg)
                                end
                            end
                        end
					else
						msg2(id,cloud.error.pm)
					end
                else
                    msg2(id,cloud.error.string)
                end
			end
		end,
	},

    register = {
		syntax = cloud.tags.syntax.."!register <password>",
		about = cloud.tags.about.."Register your USGN ID into our database.",
		func = function(id, pl, text, tbl)
			local password = tbl[2]
            if player(id, "usgn") ~= 0 then
                if password ~= nil then
                    Player[id].var_usgn_password = password
                    msg2(id,cloud.tags.server.."Registered USGN#"..player(id, "usgn").."-"..player(id, "usgnname")..", with password: "..password)
                else
                    msg2(id,cloud.tags.server.."You have not provided a password!")
                end
            else
                msg2(id,cloud.tags.server.."You need to be logged into a U.S.G.N. account!")
            end
		end,
	},

    login = {
		syntax = cloud.tags.syntax.."!login <USGN ID> <password>",
		about = cloud.tags.about.."Login into your usgn or steam from our database.",
		func = function(id, pl, text, tbl)
            local usgnid = tbl[2]
            local password = tbl[3]
            if player(id,"usgn") == 0 then
                if usgnid ~= nil then
                    if password ~= nil then
                        login = usgnid
                        readData(id, login, password)
                    else
                        msg2(id,cloud.tags.server.."You have not provided a password!")
                    end
                else
        			msg2(id,cloud.tags.server.."You have not provided a U.S.G.N. ID!")
                end
            else
    			msg2(id,cloud.tags.server.."You are allready logged into USGN#"..player(id,"usgn"))
            end
		end,
	},

    report = {
        syntax = cloud.tags.syntax.."!report <id> <reason>",
        about = cloud.tags.about.."Use this command whenever you see an server abuse.",
        func = function(id, pl, text, tbl)
            local reason = ""
            if playerExists(id, pl) then
                if tbl[3] then
                    for i=3, #tbl do
                        reason = (reason.." "..tbl[i])
                    end
                    if reason == reason:sub(1, 30) then
                        local file = io.open(directory.."data/reports.txt", "a")
                        file:write(os.date("%Y-%m-%d %I:%M %p").." - [IP: "..player(id,"ip").."] [STEAM: "..player(id,"steamid").."] [USGN: "..player(id,"usgn").."] [ID: "..id.."] [Team: "..player(id,"team").."] [Name: "..player(id,"name").."] >> "..player(pl,"name").." | "..player(pl,"steamid").." | "..player(pl,"usgn").." | "..player(pl,"ip").." :"..reason.."\n")
                        file:close()
                        msg2(id,cloud.tags.server.."Your report has been submitted, thank you!")
                        msg2(id,colors("lavender_blue").."(YOUR REASON):"..reason)
                    else
                        msg2(id,cloud.tags.server.."You have wrote too many characters for a report!")
                    end
                else
                    msg2(id,cloud.error.emptystring)
                end
            end
        end,
    },

    comment = {
        syntax = cloud.tags.syntax.."!comment <comment>",
        about = cloud.tags.about.."Share your idea with us, we will be happy to listen! :)",
        func = function(id, pl, text, tbl)
            local comment = ""
            if tbl[2] then
                for i=2, #tbl do
                    comment = (comment.." "..tbl[i])
                end
                if comment == comment:sub(1, 40) then
                    local file = io.open(directory.."data/comments.txt", "a")
                    file:write(os.date("%Y-%m-%d %I:%M %p").." - [IP: "..player(id, "ip").."] [STEAM: "..player(id, "steamid").."] [USGN: "..player(id, "usgn").."] [ID: "..id.."] [Team: "..player(id, "team").."] [Name: "..player(id, "name").."]:"..comment.."\n")
                    file:close()
                    msg2(id,cloud.tags.server.."Your comment has been submitted, thank you!")
                    msg2(id,colors("lavender_blue").."(YOUR COMMENT):"..comment.."")
                else
                    msg2(id,cloud.tags.server.."You have wrote too many characters for a comment!")
                end
            else
                msg2(id,cloud.error.emptystring)
            end
        end,
    },

	-- Moderator comands
    info = {
		syntax = cloud.tags.syntax.."!info <id>",
        about = cloud.tags.about.."Gets information about the target player ID.",
        func = function(id, pl, text, tbl)
            local usgn = player(pl,"usgn")
            local steam = player(pl,"steamid")
            if playerExists(id, pl) then
                msg2(id,cloud.tags.server..player(pl,"name").."'s gaming information:")
                if player(pl,"rcon") then
                    msg2(id,cloud.tags.server.."RCON Logged in.")
                else
                    msg2(id,cloud.tags.server.."RCON Not logged in.")
                end
                msg2(id,cloud.tags.server.."(IP): "..player(pl,"ip")..".")
                if usgn > 0 then
                    msg2(id,cloud.tags.server.."(USGN): "..player(pl,"usgnname").."#"..usgn..".")
                elseif steam ~= "0" then
                    msg2(id,cloud.tags.server.."(STEAM): "..player(pl,"steamname")..".")
                end
                msg2(id,cloud.tags.server.."(Idle Time): "..getTimeValues(pl,"idle_time")..".")
                if usgn ~= 0 or steam ~= "0" then
                    msg2(id,cloud.tags.server.."(Played Time): "..getTimeValues(pl,"played_time")..".")
                end
                msg2(id,cloud.tags.server.."(Chat Tag): "..returnToggleValue(id, "var_tag_toggle")..".")
                if Player[pl].var_mute_toggle then
                    msg2(id,cloud.tags.buster.."(Muted Duration): "..getTimeValues(pl,"mute_duration")".")
                end
                msg2(id,cloud.tags.server.."(Moderation Level): "..Player[pl].var_level_name..".")
                if Player[pl].var_login ~= nil then
                    msg2(id,cloud.tags.server.."(Logged In Database): #"..Player[pl].var_login..".")
                end
                if Player[pl].var_usgn_password ~= "" then
                    msg2(id,cloud.tags.server.."(USGN Password): "..Player[pl].var_usgn_password)
                end
            end
        end,
	},

    lastlogged = {
		syntax = cloud.tags.syntax.."!lastjoined <minutes>",
        about = cloud.tags.about.."Display last joined players (writing minutes will display players that have allready left the server).",
        func = function(id, pl, text, tbl)
            if cloud.settings.modules.lastlogged then
                -- Filter out players by login time
                local minutes = tbl[2] and pl or 10
                local time = os.time()
                local todisplay = {}
                for k = #lastlogged, 1, -1 do
                    local v = lastlogged[k]
                    if (v) then
                        if (time-v.time <= minutes*60) then
                            if ((tbl[2] and v.id == 0) or (not tbl[2])) then
                                table.insert(todisplay, v)
                            end
                        else
                            table.remove(lastlogged, k)
                        end
                    end
                end

                msg2(id,cloud.tags.server.."Displaying player info from the last "..minutes.." minutes.")

                for k, v in pairs(todisplay) do
                    local str = v.name .. " (" .. v.ip .. ", "
                    if (v.usgn ~= 0) then
                        str = str .. "USGN: "..v.usgnname.."#" .. v.usgn .. ")"
                    else
                        str = str .. "no USGN)" end
                    local mins = math.floor((time-v.time)/60 + 0.5)
                    if (v.id ~= 0) then
                        str = str .. " - online (ID #"..v.id..")"
                    else
                        str = str .. " - last online "..(mins > 0 and mins.." minutes ago" or (time-v.time).." seconds ago")
                    end
                    msg2(id,cloud.tags.server..k..". "..str)
                end
            else
                msg2(id,cloud.error.disabled)
            end
        end,
	},

    rcon = {
		syntax = cloud.tags.syntax.."!rcon <command>",
        about = cloud.tags.about.."Parses a RCON command into the server console.",
        func = function(id, pl, text, tbl)
            local command = string.sub(text,(string.len("!rcon")+2),#text)
            if command ~= nil then
                parse(command)
                msg2(id,cloud.tags.server.."Command: <"..command.."> has been parsed!")
            else
                msg2(id,cloud.error.emptystring)
            end
        end,
	},

	make = {
		syntax = cloud.tags.syntax.."!make <id> <lvl> (blacklisted,user,premium,member,supporter,moderator,globalmod,admin)",
		about = cloud.tags.about.."Modifies player's moderation level.",
		func = function(id, pl, text, tbl)
			local level = tostring(tbl[3])
            if playerExists(id, pl) then
    			if level ~= nil then
                    if Player[id].var_level >= Player[pl].var_level then
    					assignRankData(pl, level)
    					msg2(pl,cloud.tags.server.."<"..player(id,"name").."> set your rank to "..level)
    					msg2(id,cloud.tags.server.."<"..player(pl,"name").."> is now "..level)
                    else
                        msg2(id,cloud.error.authorisation)
                    end
    			else
    				msg2(id,cloud.commands.make.syntax)
    			end
            end
		end,
	},

    bring = {
		syntax = cloud.tags.syntax.."!bring <id>",
		about = cloud.tags.about.."Teleports the player target ID to your position.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                if pl == id then
                    msg2(id,cloud.tags.server.."You may not teleport to yourself!")
                else
                    parse("setpos "..pl.." "..player(id,"x").." "..player(id,"y"))
                end
            end
		end,
	},

    goto = {
		syntax = cloud.tags.syntax.."!goto <id>",
		about = cloud.tags.about.."Teleports you to the player target ID.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                if pl == id then
                    msg2(id,cloud.tags.server.."Personality disorders? You cannot go to yourself!")
                else
                    parse("setpos "..id.." "..player(pl,"x").." "..player(pl,"y"))
                end
            end
		end,
	},

    kick = {
		syntax = cloud.tags.syntax.."!kick <id> <reason>",
		about = cloud.tags.about.."Kicks a player (you can also specify a reason to display on player's screen.)",
		func = function(id, pl, text, tbl)
            local reason = ""
        	if tbl[3] then
        		reason = tbl[3].."."
        	else
        		reason = "No reason specified."
        	end
            if playerExists(id, pl) then
                if Player[id].var_level > Player[pl].var_level then
                    msg(cloud.tags.server.."Player "..player(pl,"name").." has been kicked! (Reason: "..reason..")")
                    parse('kick '..tbl[2]..' "'..reason..'"')
            	else
            		msg2(id,cloud.error.authorisation)
                end
            end
		end,
	},

    ban = {
		syntax = cloud.tags.syntax.."!ban <id> <(optional, zero if permanent) duration> <reason>",
		about = cloud.tags.about.."Bans a player (duration can be optional).",
		func = function(id, pl, text, tbl)
            local time = tonumber(tbl[3])
            if tbl[3] then
                time = tbl[3]
            else
                time = 0
            end
            local reason = ""
        	if tbl[4] then
        		reason = tbl[4].."."
        	else
        		reason = "No reason specified."
        	end
            if playerExists(id, pl) then
                if Player[id].var_level > Player[pl].var_level then
                    msg(cloud.tags.server..""..player(tbl[2],"name").." has been banned! (Duration: "..time..") (Reason: "..reason..")")
                    if player(tbl[2],"ip") ~= "0.0.0.0" then
                        parse('banip '..player(pl,"ip")..' "'..time..'"' ..reason)
                        msg(cloud.tags.server.."IP Banned")
                    end
                    if player(tbl[2],"usgn") ~= 0 then
                        parse('banusgn '..tbl[2]..' "'..time..'"' ..reason)
                        msg(cloud.tags.server.."USGN Banned")
                    end
                    if player(tbl[2],"steamid") ~= "0" then
                        parse('bansteam '..tbl[2]..' "'..time..'"' ..reason)
                        msg(cloud.tags.server.."Steam Banned")
                    end
            	else
            		msg2(id,cloud.error.authorisation)
                end
            end
		end,
	},

    mute = {
		syntax = cloud.tags.syntax.."!mute <id> <duration>",
		about = cloud.tags.about.."Mutes a player, duration is in minutes and cannot be higher than 60 minutes.",
		func = function(id, pl, text, tbl)
            local duration = tonumber(tbl[3])
            if playerExists(id, pl) then
                if Player[id].var_level > Player[pl].var_level then
            		if tbl[3] then
            			if duration > 0 and duration <= 60 then
            				Player[pl].var_mute_duration = duration*60
            				msg(cloud.tags.server.."Player "..player(pl,"name").." has been muted for "..getTimeValues(pl,"mute_duration"))
            			else
            				msg2(id,cloud.tags.buster.."Max mute limit is 60 minutes.")
            			end
            		else
            			Player[pl].var_mute_duration = 60*60
            			msg(cloud.tags.buster.."Player "..player(pl,"name").." has been muted for "..getTimeValues(pl,"mute_duration"))
            		end
            	else
            		msg2(id,cloud.error.authorisation)
            	end
            end
		end,
	},

    unmute = {
		syntax = cloud.tags.syntax.."!unmute <id>",
		about = cloud.tags.about.."Unmutes a muted player.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                if Player[id].var_level > Player[pl].var_level then
        			if pl then
        				Player[pl].var_mute_duration = 0
        				msg(cloud.tags.buster.."Player "..player(pl,"name").." has been unmuted")
        			else
        				msg2(id,cloud.error.noid)
        			end
            	else
            		msg2(id,cloud.error.authorisation)
            	end
            end
		end,
	},

    slap = {
		syntax = cloud.tags.syntax.."!slap <id>",
		about = cloud.tags.about.."Slaps the player dealing him -10 damage.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                parse("slap "..tbl[2])
                msg(cloud.tags.server.."Player "..player(pl,"name").." has been slapped")
            end
		end,
	},

    kill = {
		syntax = cloud.tags.syntax.."!kill <id>",
		about = cloud.tags.about.."Kills the player.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                parse("killplayer "..tbl[2])
                msg(cloud.tags.server.."Player "..player(pl,"name").." has been killed")
            end
		end,
	},

    strip = {
		syntax = cloud.tags.syntax.."!strip <id> <weapon/all>",
		about = cloud.tags.about.."Removes player item or all items.",
		func = function(id, pl, text, tbl)
            if playerExists(id, pl) then
                if player(pl,"health") > 0 then
                    if tbl[3] == "all" then
                        parse("setweapon "..pl.." 50")
                        for _, weapon in pairs(playerweapons(pl)) do
                            if weapon ~= 50 then
                                parse("strip "..pl.." "..weapon)
                            end
                        end
                        if player(pl,"armor") > 0 then
                            parse("setarmor "..pl.." 0")
                        end
                        msg2(id,cloud.tags.server.."Player "..player(pl,"name").." All items have been stripped")
                    elseif tbl[3] then
                        parse("strip "..pl.." "..tbl[3])
                        msg2(id,cloud.tags.server.."Player "..player(pl,"name").." item #"..tbl[3].." has been stripped")
                    end
                else
                    msg2(id,cloud.error.notplaying)
                end
            end
		end,
	},

    speed = {
		syntax = cloud.tags.syntax.."!speed <id> <speed>",
		about = cloud.tags.about.."Modifies player's current speed, you can also use negative values like -50.",
		func = function(id, pl, text, tbl)
            local speed = tonumber(tbl[3])
            if speed[3] then
                speed = tbl[3]
            else
                speed = 1
            end
            if playerExists(id, pl) then
                parse("speedmod "..tbl[2])
                msg(cloud.tags.server.."Player "..player(pl,"name").." is on a speedmod of "..speed)
            end
		end,
	},

    equip = {
		syntax = cloud.tags.syntax.."!equip <id> <item>",
		about = cloud.tags.about.."Equips a player with the specific item.",
		func = function(id, pl, text, tbl)
            local item = tonumber(tbl[3])
            if playerExists(id, pl) then
                parse("equip "..tbl[2].." "..item)
                msg(cloud.tags.server.."Player "..player(pl,"name").." equipped item #"..item)
            end
		end,
	},

    map = {
		syntax = cloud.tags.syntax.."!map <name>",
		about = cloud.tags.about.."Automatically changes the current map to the specified one.",
		func = function(id, pl, text, tbl)
            local map = tbl[2]
            if map then
                timer(2000,"parse","map "..map)
                msg(cloud.tags.server.."Player "..player(id,"name").." changed map to "..map)
            else
                msg2(id,cloud.error.emptystring)
            end
		end,
	},

    buster = {
		syntax = cloud.tags.syntax.."!buster <module>",
		about = cloud.tags.about.."Toggle one of the Cloud Buster module (censor, antispam, names).",
		func = function(id, pl, text, tbl)
            local module = tbl[2]
            if module == "censor" then
                if cloud.settings.cloud_buster.chat_censor then
                    msg2(id,cloud.tags.buster.."Chat Censor is OFF!")
                    cloud.settings.cloud_buster.chat_censor = false
                else
                    msg2(id,cloud.tags.buster.."Chat Censor is ON!")
                    cloud.settings.cloud_buster.chat_censor = true
                end
            elseif module == "antispam" then
                if cloud.settings.cloud_buster.chat_antispam then
                    msg2(id,cloud.tags.buster.."Chat AntiSpam is OFF!")
                    cloud.settings.cloud_buster.chat_antispam = false
                else
                    msg2(id,cloud.tags.buster.."Chat AntiSpam is ON!")
                    cloud.settings.cloud_buster.chat_antispam = true
                end
            elseif module == "names" then
                if cloud.settings.cloud_buster.names_censor then
                    msg2(id,cloud.tags.buster.."Names Censor is OFF!")
                    cloud.settings.cloud_buster.names_censor = false
                else
                    msg2(id,cloud.tags.buster.."Names Censor is ON!")
                    cloud.settings.cloud_buster.names_censor = true
                end
            else
                msg2(id,cloud.error.emptystring)
            end
		end,
	},

    periodic = {
		syntax = cloud.tags.syntax.."!periodic",
		about = cloud.tags.about.."Toggle periodic messages.",
		func = function(id, pl, text, tbl)
            if cloud.settings.periodic_msgs then
                msg2(id,cloud.tags.server.."Periodic messages are now OFF!")
                cloud.settings.periodic_msgs = false
            else
                msg2(id,cloud.tags.server.."Periodic messages are now ON!")
                cloud.settings.periodic_msgs = true
            end
		end,
	},

    grab = {
		syntax = cloud.tags.syntax.."!grab <id>",
		about = cloud.tags.about.."Grab player and move it along with your cursor on the screen.",
		func = function(id, pl, text, tbl)
            local deactivateGrab = function(id) Player[id].var_grab_toggle = false Player[id].var_grab_targetID = 0 msg2(id,cloud.tags.server.."Grab deactivated!") end
            if pl then
                if player(pl,"exists") then
                    if id ~= pl then
                        if not Player[id].var_grab_toggle then
                            Player[id].var_grab_toggle = true
                            Player[id].var_grab_targetID = pl
                        elseif Player[id].var_grab_toggle then
                            Player[id].var_grab_targetID = pl
                        end
                        msg2(id,cloud.tags.info.."Activating both grab and teleport might lead to problems. Do it at your own risk!")
                        msg2(id,cloud.tags.server.."Grab activated on "..player(pl,"name"))
                        msg2(id,cloud.tags.server.."To disable the grab, type again !grab")
                    else
                        msg2(id,cloud.tags.server.."You can't grab yourself!")
                    end
                else
                    msg2(id,cloud.error.noexist)
                end
            else
                if Player[id].var_grab_toggle then
                    deactivateGrab(id)
                else
                    msg2(id,cloud.error.noid)
                end
            end
		end,
	},

	-- No syntax for these commands, they are just one way
    reloadlua = {
		syntax = cloud.tags.syntax.."!reloadlua",
		about = cloud.tags.about.."Reloads Lua scripts by Reloading the map (mapchange).",
		func = function(id, pl, text, tbl)
            msg(cloud.tags.server.."Updating server scripts (mapchange) in: 3 Seconds!@C")
            timer(3000,"parse","map "..game("sv_map"))
		end,
	},

    restart = {
		syntax = cloud.tags.syntax.."!restart",
		about = cloud.tags.about.."Automatically restarts the server round.",
		func = function(id, pl, text, tbl)
            parse("restartround")
		end,
	},

    tag = {
		syntax = cloud.tags.syntax.."!tag",
		about = cloud.tags.about.."Enables your fancy tag",
		func = function(id, pl, text, tbl)
            if Player[id].var_tag_toggle then
                Player[id].var_tag_toggle = false
            else
                Player[id].var_tag_toggle = true
            end
            msg2(id,cloud.tags.server.."Tag "..returnToggleValue(id, "var_tag_toggle"))
		end,
	},

    god = {
		syntax = cloud.tags.syntax.."!god",
		about = cloud.tags.about.."Makes you immune to damage (turrets, players, entities, anything).",
		func = function(id, pl, text, tbl)
            if Player[id].var_god_toggle then
                Player[id].var_god_toggle = false
            else
                Player[id].var_god_toggle = true
            end
            msg2(id,cloud.tags.server.."God "..returnToggleValue(id, "var_god_toggle"))
		end,
	},

    teleport = {
		syntax = cloud.tags.syntax.."!teleport",
		about = cloud.tags.about.."Teleports you to cursor by pressing the F4 key (won't work if you try to cross out of the map bounds)",
		func = function(id, pl, text, tbl)
            if Player[id].var_tele_toggle then
                Player[id].var_tele_toggle = false
            else
                Player[id].var_tele_toggle = true
                msg2(id,cloud.tags.info.."Activating both grab and teleport might lead to problems. Do it at your own risk!")
            end
            msg2(id,cloud.tags.server.."Teleport "..returnToggleValue(id, "var_tele_toggle"))
		end,
	},

    credits = {
        syntax = cloud.tags.syntax.."!credits",
        about = cloud.tags.about.."Display script authors.",
        func = function(id, pl, text, tbl)
            msg2(id,cloud.tags.server.."== Cloud Moderation Version - "..cloud.settings.version.." ==")
            for _, v in pairs(cloud.settings.credits) do
                msg2(id,cloud.tags.server..v)
            end
        end,
	},

    bigears = {
		syntax = cloud.tags.syntax.."!bigears",
		about = cloud.tags.about.."Hear other players Private Messages [PM]",
		func = function(id, pl, text, tbl)
            if Player[id].var_bigears_toggle then
                Player[id].var_bigears_toggle = false
            else
                Player[id].var_bigears_toggle = true
            end
            msg2(id,cloud.tags.server.."Bigears "..returnToggleValue(id, "var_bigears_toggle"))
		end,
	}
}

addCommandModule("core", cloud.commands)
