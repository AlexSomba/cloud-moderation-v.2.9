unban = {}
local unban_tbl = {}
local unban_types = { IP = true, USGN = true, Steam = true, Name = true }

function unban.retrieve_bans()
	local u_menu = {
	    title = "Unban User",
	    items = {},
	    fixedItems = {
	        [7] = {"<< Return", "", function(id) unimenu.historyBack(id) end}
	    },
	}
	parse("bans")

	-- this function basically turns whatever inside .stringlist to .tablelist (ready for menu-making)
	for index, str in pairs(unban_tbl) do
		local ban_type = string.match(str, "[A-z]+")
		local ban_isnotname, ban_mask, ban_dura, ban_reason

		if ban_type == "IP" then
			ban_mask = string.match(str, "((%d+)%.(%d+)%.(%d+)%.(%d+))")
			ban_isnotname = true
		elseif ban_type == "USGN" then
			ban_mask = tonumber(string.match(str, "#(%d+)"))
			ban_isnotname = true
		elseif ban_type == "Steam" then
			ban_mask = string.match(str, "(%d+)")
			ban_isnotname = true
		elseif ban_type == "Name" then -- who bans name anyway
			if string.find(str, "%(temp, (%d+) sec%)") then
				ban_dura = string.match(str, "%(temp, (%d+) sec%)")
			else
				ban_dura = "permanent"
			end
			ban_mask = string.sub(str, 8):gsub("%(temp, "..ban_dura.." sec%)","")
			ban_reason = "-"
			ban_isnotname = false
		end

		if ban_isnotname then
			if string.find(str, "%(temp, (%d+) sec%)") then
				ban_dura = string.match(str, "%(temp, (%d+) sec%)")
			else
				ban_dura = "permanent"
			end
			if string.find(str, "%[(.+)%]") then
				ban_reason = string.match(str, "%[(.+)%]")
			else
				ban_reason = "-"
			end
		end

		if tonumber(ban_dura) then ban_dura = math.floor(ban_dura/3600) .. "h " .. (math.floor(ban_dura/60)%60).. "m "..(ban_dura%60).."s" end

		local action_menu = {
	        title = "Lift player ban? - "..ban_mask,
	        modifiers = "s",
	        items = {
	            {"Lift Ban", "", function(id) parse("unban " ..ban_mask) msg2(id,cloud.tags.server.."Ban - "..ban_mask.." has been lifted.") end}
	        },
		}
		table.insert(u_menu.items, {ban_mask, ban_type, function(id) unimenu.open(id, action_menu) end})
	end

	return u_menu
end

function log_hook(text)
	-- this function hooked to "log" hook, to get strings!

	if string.find(text, "bans total: ") then
		local total = 0

		total = string.match(text, "(%d+)")
		unban_tbl = {} -- bcs it's new "bans" execution, the list is going to be cleared
	end

	if string.find(text, "%*") then -- probably it is
		if unban_types[string.match(text, "[A-z]+")] then -- I'm sure it is
			table.insert(unban_tbl, text)
		end
	end
end

addhook("log","log_hook")
