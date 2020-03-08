print(print_mod..'Config = LOADED')

print(print_mod..'Proceed into loading the hooks = STARTING...')

if Player == nil then Player = {} end -- for player vars

function mod_join(id)
	Player[id] = {}
--	search for a player save file and assign vars
--	no saved data found? then assign default vars
	load.loadData(id)

--	after at least 3 seconds the save file is loaded, assign some other tasks
	timer(3000,"load.onLoad",id)
--  these are just to compare messages for [Cloud Buster] functionability
--	no need to store them in player save files
	Player[id].var_msgs = 0
	Player[id].var_msgs_cd = 0
end
addhook("join","mod_join",10)

function mod_leave(id)
	-- create a save file for logged in users
	if Player[id] then
		if Player[id].VARSLOADED == true then
			save.writeData(id)
			Player[id].VARSLOADED = nil
		end
	end
end
addhook("leave","mod_leave",10)

--local ticker = 0
hudtxt_colorfade = 0
function mod_second()
	for _, id in pairs(player(0, "table")) do
        if Player[id] then
			-- CLOUD BUSTER Anti chat spam
--            ticker = ticker + 1
            -- remove one message cooldown each two seconds
--            if ticker == 2 then
                if Player[id].var_msgs then
                    if Player[id].var_msgs > 0 then
                        Player[id].var_msgs = Player[id].var_msgs - 1
                    end
                end
--                ticker = 0
--            end

            if Player[id].var_mute_duration then
                if Player[id].var_mute_duration > 0 then
                    Player[id].var_mute_duration = Player[id].var_mute_duration - 1
                    parse('hudtxt2 '..id..' 14 '..colors("electric_blue")..'Muted: '..colors("white")..getTimeValues(id,"mute_duration")..'" 15 160')
                end

                if Player[id].var_mute_duration == 1 then
                    Player[id].var_mute_duration = 0
                    Player[id].var_mute_toggle = true
                    msg(cloud.tags.server.."Player "..player(id,"name").." has been unmuted.")
                    parse("hudtxt2 "..id.." 14 \"\" 15 200")
                end
            end

            if Player[id].var_msgs_cd then
                if Player[id].var_msgs_cd > 0 then
                    Player[id].var_msgs_cd = Player[id].var_msgs_cd - 1
                end
            end
        end
    end

	if hudtxt_colorfade == 0 then
	    parse("hudtxtcolorfade 0 100 1000 255 0 0")
	    hudtxt_colorfade = 1
	elseif hudtxt_colorfade == 1 then
	    parse("hudtxtcolorfade 0 100 1000 255 255 0")
	    hudtxt_colorfade = 0
	end
end
addhook("second","mod_second",10)

function mod_always()
	for _, id in pairs(player(0,"table")) do
		if Player[id] then
			if Player[id].var_grab_toggle then
				if Player[id].var_grab_targetID ~= 0 and player(Player[id].var_grab_targetID,"exists") then
					reqcld(id,2)
				end
			end
		end
	end
end
addhook("always","mod_always",10)

function mod_clientdata(id, mode, data1, data2)
	if mode == 2 then
		if Player[id].var_tele_toggle then
			if data1 > 0 and data2 > 0 and data1 < map([[xsize]]) * 32 and data2 < map([[ysize]]) * 32 then
				parse("setpos "..id.." "..data1.." "..data2)
			else
				msg2(id,cloud.tags.error.."setpos - position is out of map bounds! X = "..data1.. " Y = "..data2)
			end
		elseif Player[id].var_grab_targetID ~= 0 and player(Player[id].var_grab_targetID,"exists") then
			if data1 >= 0 and data2 >= 0 and data1 <= map([[xsize]]) * 32 and data2 <= map([[ysize]]) * 32 then
				parse("setpos "..Player[id].var_grab_targetID.." "..data1.." "..data2)
			end
		end
	end
end
addhook("clientdata","mod_clientdata",10)

local main_menu = {
	title = function(page) return "[" .. page .. "] Main Menu" end,
	items = {
		{"Unban", "", function(id) unimenu.open(id, unban.retrieve_bans()) end},
		{"Reports", "", function(id) unimenu.open(id, reports.retrieve_reports()) end},
		{"Comments", "", function(id) unimenu.open(id, comments.retrieve_comments()) end},
		{"Logs", "", function(id) unimenu.open(id, logs.retrieve_logs()) end}
	},
}

function mod_serveraction(id, action)
	if action == 1 then
--		TODO// if cloud.settings.modules.unban then
			if Player[id].var_level >= 5 then
				unimenu.open(id, main_menu)
			else
				msg2(id,cloud.error.privilege)
			end
--		else
--			msg2(id,cloud.tags.server.."This module is disabled.")
--		end
	elseif action == 3 then
		if Player[id].var_level >= 5 then
			if player(id,"health") ~= 0 then
				if Player[id].var_tele_toggle then
					reqcld(id,2)
				end
			else
				msg2(id,cloud.tags.server.."You ain't gonna teleport nowhere while dead.")
			end
		else
			msg2(id,cloud.error.privilege)
		end
	end
end
addhook("serveraction","mod_serveraction",10)

function mod_minute()
	if cloud.settings.periodic_msgs then
		local chance = math.random(1,#cloud.settings.periodic_msg)
		msg(colors("heliotrope")..cloud.settings.periodic_msg[chance][1])
		msg(colors("white")..cloud.settings.periodic_msg[chance][2])
	end
end
addhook("minute","mod_minute",10)

function mod_say(id, text)
	-- log chat commmands
	if id then
		local file = io.open(directory.."data/logs.txt", "a")
		file:write(os.date("%Y-%m-%d %I:%M %p").." - [IP: "..player(id, "ip").."] [STEAM: "..player(id, "steamid").."] [USGN: "..player(id, "usgn").."] [ID: "..id.."] [Team: "..player(id, "team").."] [Name: "..player(id, "name").."]: "..text.."\n")
		file:close()
		file = nil
	end

	local tbl = util.toTable(text)
	local cmd = tbl[1]:sub(2)
	local pl = tonumber(tbl[2])

	-- CLOUD BUSTER Dissalow the usage of capital letters
	if cloud.settings.cloud_buster.use_C then
		if text:sub(-2,-1) == "@C" then
	        if Player[id].var_level < 6 then
	            msg2(id,cloud.cloud_buster.capital_letters)
	            return 1
	        end
	    end
	end
	-- CLOUD BUSTER Anti chat spam
	if cloud.settings.cloud_buster.chat_antispam then
        if Player[id].var_mute_duration > 0 then
            msg2(id,cloud.cloud_buster.muted.." "..getTimeValues(id,"mute_duration")..".")
            return 1
        else
            Player[id].var_msgs = Player[id].var_msgs + 1
            if Player[id].var_msgs > 5 then
                Player[id].var_mute_duration = 20
                if Player[id].var_msgs_cd > 0 then
                    Player[id].var_mute_duration = Player[id].var_mute_duration + Player[id].var_msgs_cd
                    Player[id].var_mute_toggle = true
                end
                Player[id].var_msgs_cd = Player[id].var_msgs_cd + 25
                msg2(id,cloud.cloud_buster.muted.." "..getTimeValues(id,"mute_duration")..".")
                return 1
            end
        end
    end
	-- CLOUD BUSTER Bad words filter (censor words)
	if cloud.settings.cloud_buster.chat_censor then
		local new_string = util.censor_text(text)
		if new_string ~= text then
			-- Censor the message
			msg(player(id, "name")..": *CENSORED*")
			if player(id, "team") ~= 0 and player(id, "health") > 0 then
				parse("slap " .. id)
			end
			return 1
		end
	end

	if (text:sub(1,1) == cloud.settings.say_prefix[1] or text:sub(1,1) == cloud.settings.say_prefix[2]) and text ~= "rank" then
		for _, module_name in pairs(cloud.settings.enabled_command_modules) do
			local command_module = cloud.command_modules[module_name]
    		if command_module[cmd] and command_module[cmd].func then
	            if Player[id].var_commands[cmd] then
	                command_module[cmd].func(id, pl, text, tbl)
	            else
	                msg2(id,cloud.error.privilege)
	            end
				return 1
	        end
		end
		msg2(id,cloud.tags.error.."Unknown command: <"..cmd.."> say "..cloud.settings.say_prefix[1].."help <command name>.")
		displayUserCommands(id)
		return 1
	end

	if text ~= "rank" and not Player[id].var_mute_toggle then
		local color
		local name = player(id,"name")
		if player(id,"team") == 0 then
			color = colors("slate_gray")..name..":"..colors("golden_yellow").." "
		elseif player(id,"team") == 1 then
			color = colors("scarlet")..name..":"..colors("golden_yellow").." "
		elseif player(id,"team") == 2 then
			color = colors("dodger_blue")..name..":"..colors("golden_yellow").." "
		end
		if Player[id].var_tag_toggle then
			msg(Player[id].var_tag_color..cloud.settings.users[Player[id].var_level_name].tag.." "..color..text)
			return 1 -- if tag is ON then return no message but custom
		else
			msg(cloud.settings.users.user.tag_color..cloud.settings.users.user.tag.." "..color..text)
			return 1
		end
	end
end
addhook("say","mod_say",10)
