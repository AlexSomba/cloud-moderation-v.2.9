mixmatch = {}

votes = 0
votes_percentage = 0

specvotes = 0
votes_percentage_spec = 0

lock = false

swapvotes = 0
votes_percentage_swap = 0

unspecvotes = 0
votes_percentage_unspec = 0

knifevotes = 0
votes_percentage_knife = 0
knife = 0

function join_mixmatch_module(id)
	Player[id].voted_restart = false
	Player[id].voted_spec = false
	Player[id].voted_swap = false
	Player[id].voted_unspec = false
	Player[id].voted_knife = false
end

function spawn_mixmatch_module(id)
	if knife == 1 then
		parse("setmoney "..id.." 0")
		parse("strip "..id.." 0")
		return "x"
	end
end

function leave_mixmatch_module(id)
	Player[id].voted_restart = false
	Player[id].voted_spec = false
	Player[id].voted_swap = false
	Player[id].voted_unspec = false
	if lock == true then
		local p = #player(0,"table")
		if p == 1 then
			lock = false
			msg("There are no players in the server. Teams have been unlocked.")
		end
	end
end

function startround_mixmatch_module()
	votes_percentage = 0
	votes = 0
end

function team_mixmatch_module(id,t)
	if lock == true and player(id,"team")==0 then
		if t == 1 or t == 2 then
			msg2(id,colors("red").."Error: Teams are locked! Vote to unlock the teams.")
			return 1
		end
	end
end

function serveraction_mixmatch_module(id, action)
	if action == 1 then
        local mult = 10^2
        local menu_tbl = {
            title = "Public menu",
    		modifiers = "s",
    		items = {
    			{"Round Restart", math.floor(votes_percentage * mult + 0.5) / mult.."%",
    			function(id)
    				if Player[id].voted_restart == false then
    					if player(id,"team") ~= 0 then
    						Player[id].voted_restart = true
    						p = #player(0,"tableliving")
    						votes = votes + 1
    						msg(player(id,"name")..colors("white").." has voted for a round restart!")
    						votes_percentage = votes / p * 100
    						if votes_percentage >= 50 and p > 2 then
    							parse("restart 5")
    							msg(colors("white").."Server: Good luck & have fun!")
    							Player[id].voted_restart = false
    						elseif votes_percentage == 100 and p == 2 then -- for 1n1 matches
    							parse("restart 5")
    							msg(colors("white").."Server: Good luck & have fun!")
    							Player[id].voted_restart = false
    						end
    					else
    						msg2(id,colors("red").."Error: Spectators cannot vote on this.")
    					end
    				else
    					msg2(id,colors("red").."Error: You have already voted on this")
    				end
    			end},
    			{"Lock Spec", math.floor(votes_percentage_spec * mult + 0.5) / mult.."%",
    			function(id)
    				if Player[id].voted_spec == false then
    					if player(id,"team") ~= 0 then
    						Player[id].voted_spec = true
    						p = #player(0,"tableliving")
    						specvotes = specvotes + 1
    						msg(player(id,"name")..colors("white").." has voted for a spec lock!")
    						votes_percentage_spec = specvotes / p * 100
    						if votes_percentage_spec >= 50 then
    							if lock == false then
    								Player[id].voted_spec = false
    								lock = true
    								msg(colors("spray").."Teams are now locked!")
    								votes_percentage_spec = 0
    								specvotes = 0
    							else
    								msg2(id,colors("red").."Error: Teams are already locked!")
    								Player[id].voted_spec = false
    							end
    						end
    					else
    						msg2(id,colors("red").."Error: Spectators cannot vote on this.")
    					end
    				else
    					msg2(id,colors("red").."Error: You have already voted on this")
    				end
    			end},
    			{"Swap Teams", math.floor(votes_percentage_swap * mult + 0.5) / mult.."%",
    			function(id)
    				if Player[id].voted_swap == false then
    					if player(id,"team") ~= 0 then
    						Player[id].voted_swap = true
    						p = #player(0,"tableliving")
    						swapvotes = swapvotes + 1
    						msg(player(id,"name")..colors("white").." has voted for a team swap!")
    						votes_percentage_swap = swapvotes / p * 100
    						if votes_percentage_swap >= 50 then
    							lock = false
    							Player[id].voted_swap = false
    							msg(colors("spray").."Teams have been swapped!")
    							votes_percentage_swap = 0
    							swapvotes = 0
    							for i = 1,32 do
    								if player(i,"team")==1 then
    									parse("makect "..i)
    								elseif player(i,"team")==2 then
    									parse("maket "..i)
    								end
    							end
    							lock = true
    						end
    					else
    						msg2(id,colors("red").."Error: Spectators cannot vote on this.")
    					end
    				else
    					msg2(id,colors("red").."Error: You have already voted on this")
    				end
    			end},
    			{"Unlock Spec", math.floor(votes_percentage_unspec * mult + 0.5) / mult.."%",
    			function(id)
    				if Player[id].voted_unspec == false then
    					if player(id,"team") ~= 0 then
    						Player[id].voted_unspec = true
    						p = #player(0,"tableliving")
    						unspecvotes = unspecvotes + 1
    						msg(player(id,"name")..colors("white").." has voted for a spec unlock!")
    						votes_percentage_unspec = unspecvotes / p * 100
    						if votes_percentage_unspec >= 75 then
    							if lock == true then
    								Player[id].voted_unspec = false
    								lock = false
    								msg(colors("spray").."Teams are now unlocked!")
    								votes_percentage_unspec = 0
    								unspecvotes = 0
    							else
    								msg2(id,colors("red").."Error: Teams are already unlocked!")
    								Player[id].voted_unspec = false
    							end
    						end
    					else
    						msg2(id,colors("red").."Error: Spectators cannot vote on this.")
    					end
    				else
    					msg2(id,colors("red").."Error: You have already voted on this")
    				end
    			end},
    			{"Knife Round", math.floor(votes_percentage_knife * mult + 0.5) / mult.."%",
    			function(id)
    				if Player[id].voted_knife == false then
    					if player(id,"team") ~= 0 then
    						Player[id].voted_knife = true
    						p = #player(0,"tableliving")
    						knifevotes = knifevotes + 1
    						msg(player(id,"name")..colors("white").." has voted for a knife round!")
    						votes_percentage_knife = knifevotes / p * 100
    						if votes_percentage_knife >= 50 then
    							if knife == 0 then
    								Player[id].voted_knife = false
    								knife = 1
    								parse("restart 5")
    								msg(colors("white").."Knife round in 5 seconds")
    								msg2(id,colors("white").."Info: Vote knife round again, to end the knife rounds!")
    								parse("mp_roundtime 100")
    								votes_percentage_knife = 0
    								knifevotes = 0
    								return 1
    							else
    								knife = 0
    								msg(colors("white").."Knife rounds ended")
    								parse("mp_roundtime 1.5")
    								parse("restart")
    								votes_percentage_knife = 0
    								knifevotes = 0
    								Player[id].voted_knife = false
    								return 1
    							end
    						end
    					else
    						msg2(id,colors("red").."Error: Spectators cannot vote on this.")
    					end
    				else
    					msg2(id,colors("red").."Error: You have already voted on this")
    				end
    			end},
    			{"Withdraw Votes", "", function(id)
    				if Player[id].voted_restart == true then
    					if votes ~= 0 then votes = votes - 1 end
    					votes_percentage = votes / p * 100
    					Player[id].voted_restart = false
    				end
    				if Player[id].voted_spec == true then
    					if specvotes ~= 0 then specvotes = specvotes - 1 end
    					votes_percentage_spec = specvotes / p * 100
    					Player[id].voted_spec = false
    				end
    				if Player[id].voted_swap == true then
    					if swapvotes ~= 0 then swapvotes = swapvotes - 1 end
    					votes_percentage_swap = swapvotes / p * 100
    					Player[id].voted_swap = false
    				end
    				if Player[id].voted_unspec == true then
    					if unspecvotes ~= 0 then unspecvotes = unspecvotes - 1 end
    					votes_percentage_unspec = unspecvotes / p * 100
    					Player[id].voted_unspec = false
    				end
    				if Player[id].voted_knife == true then
    					if knifevotes ~= 0 then knifevotes = knifevotes - 1 end
    					votes_percentage_knife = knifevotes / p * 100
    					Player[id].voted_knife = false
    				end
    				msg(colors("white")..""..player(id,"name").." has withdrawn his votes")
    			end}
    		},
    	}
		unimenu(id,true,menu_tbl,1)
    end
end

mixmatch.commands = {
	knife = {
        syntax = cloud.tags.syntax.."!knife",
        about = cloud.tags.about.."Toggle knife round.",
        func = function(id, pl, text, tbl)
            msg("\169000100255"..player(id,"name").." used !knife")
			if knife == 0 then
				knife = 1
				parse("restart 5")
				msg(colors("white").."Knife round in 5 seconds")
				msg2(id,"Info: Use @knife again to disable knife rounds!")
				parse("mp_roundtime 100")
			else
				knife = 0
				msg(colors("white").."Knife rounds ended")
				parse("mp_roundtime 1.5")
				parse("restart")
			end
        end,
    },

    maket = {
        syntax = cloud.tags.syntax.."!maket",
        about = cloud.tags.about.."Change a player's team to Terrorist.",
        func = function(id, pl, text, tbl)
			if lock == true then lock,was_locked = false,true end
			parse("maket "..pl)
			msg(colors("dodger_blue")..player(id,"name").." used !maket")
			if was_locked == true then lock,was_locked = true,false end
        end,
    },

    makect = {
        syntax = cloud.tags.syntax.."!makect",
        about = cloud.tags.about.."Change a player's team to Counter-Terrorist.",
        func = function(id, pl, text, tbl)
            if lock == true then lock,was_locked = false,true end
			parse("makect "..pl)
			msg(colors("dodger_blue")..player(id,"name").." used @makect")
			if was_locked == true then lock,was_locked = true,false end
        end,
    },

    lock = {
        syntax = cloud.tags.syntax.."!lock",
        about = cloud.tags.about.."Lock player teams.",
        func = function(id, pl, text, tbl)
            if lock == false then
				msg(colors("dodger_blue")..player(id,"name").." used !lock")
				lock = true
				msg(colors("spray").."Teams are now locked!")
			else
				msg2(id,colors("red").."Error: Teams are already locked!")
			end
        end,
    },

    unlock = {
        syntax = cloud.tags.syntax.."!unlock",
        about = cloud.tags.about.."Unlock player teams.",
        func = function(id, pl, text, tbl)
            if lock == true then
                msg(colors("dodger_blue")..player(id,"name").." used !unlock")
                lock = false
                msg(colors("spray").."Teams are now unlocked!")
            else
                msg2(id,colors("red").."Error: Teams are already unlocked!")
            end
        end,
    },

    swap = {
        syntax = cloud.tags.syntax.."!swap",
        about = cloud.tags.about.."Swap player's teams.",
        func = function(id, pl, text, tbl)
            for i = 1,32 do
				if player(i,"team")==1 then
					parse("makect "..i)
				elseif player(i,"team")==2 then
					parse("maket "..i)
				end
			end
			msg(colors.colors.dodger_blue..player(id,"name").." used !swap")
			msg(colors.colors.spray.."Teams have been swapped!")
        end,
    }
}

if cloud.settings.enabled_command_modules.mixmatch == true then
	addCommandModule("mixmatch", mixmatch.commands)
end

addhook("join","join_mixmatch_module",30)
addhook("spawn", "spawn_mixmatch_module",30)
addhook("leave","leave_mixmatch_module",30)
addhook("startround","startround_mixmatch_module",30)
addhook("team","team_mixmatch_module",30)
addhook("serveraction","serveraction_mixmatch_module",30)
