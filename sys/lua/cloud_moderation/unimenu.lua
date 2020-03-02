main_menu = {
	[1] = {
		title = "Main Menu",
		modifiers = "s",
		items = {
			{"Unban", "", function(id) unimenu(id,true,unban.retrieve_bans(),1) end},
			{"Reports", "", function(id) unimenu(id,true,reports.retrieve_reports(),1) end},
			{"Comments", "", function(id) unimenu(id,true,comments.retrieve_comments(),1) end},
			{"Logs", "", function(id) unimenu(id,true,logs.retrieve_logs(),1) end}
		},
	}
}

menus = {
	[1] = {
		title = "",
		items = {}
	}
}

spages={{}}
pmenu={}
ppage={}

function unimenu(id,construct,m,p)
	if not spages[id] then spages[id]={} end
	if m~="current" and construct~="old" then
		if construct then
			local custom
			if type(m)=="table" then
				custom=true
			else
				custom=false
			end
			pmenu[id]=m
			ppage[id]=p
			local paget
			local title
			if not custom then
				if not menus[m] then menu(id, "Invalid menu,(No entries found)") return end
				paget=math.ceil(#menus[m].items/7)
				title=menus[m].title
			else
				paget=math.ceil(#m.items/7)
				title=m.title
			end
			local modifiers
			if not custom then
				modifiers = menus[m].modifiers
			else
				modifiers = m.modifiers
			end
			if paget>0 then
				for i = 1, paget do
					if not custom then
						spages[id][i]="["..i.."] "..title
					else
						spages[id][i]="["..i.."] "..title
					end
					if modifiers then
						if not modifiers:find("s") then
							spages[id][i]=spages[id][i].."@b"
						end
						if modifiers:find("i") then
							spages[id][i]=spages[id][i].."@i"
						end
					else
						spages[id][i]=spages[id][i].."@b"
					end
					spages[id][i]=spages[id][i]..","
					for ii = 1,7 do
						local sid = ii+(7*(i-1))
						if not custom then
							if menus[m].items[sid] then
								spages[id][i]=spages[id][i]..menus[m].items[sid][1].."|"..menus[m].items[sid][2]..","
							else
								spages[id][i]=spages[id][i]..","
							end
						else
							if m.items[sid] then
								spages[id][i]=spages[id][i]..m.items[sid][1].."|"..m.items[sid][2]..","
							else
								spages[id][i]=spages[id][i]..","
							end
						end
					end
					if i<paget then spages[id][i]=spages[id][i].."Next" end
					if i>1 then spages[id][i]=spages[id][i]..",Back" end
				end
			else
				spages[id][p]="[0] "..title
			end
		end
	end
	if construct=="old" then
		p=ppage[id]
	end
	if spages[id][p] then
		menu(id,spages[id][p])
	else
		local _,e=pcall(menu,id,spages[id][p])
		if e then
			print(string.char(169).."255000000LUA ERROR: "..e)
		end
	end
end

addhook("menu","unimenuhook")
function unimenuhook(id,menu,sel)
--	if menu ~= "Amount" and menu ~= "Actions" and menu ~= "Put how many?" then
		local p=tonumber(menu:match("\[(%d+)\]"))
		if sel<8 and sel>0 then
			local s=sel+(7*(p-1))
			if type(pmenu[id])=="table" then
				pmenu[id].items[s][3](id,pmenu[id].items[s])
			else
				menus[pmenu[id]].items[s][3](id,menus[pmenu[id]].items[s])
			end
		else
			if sel==8 then
				unimenu(id,true,"current",p+1)
			elseif sel==9 then
				unimenu(id,true,"current",p-1)
			end
		end
--	end
end
