util = {}

--this is meant to be the same as string.split, except mch is a simple string of characters that count as separators,
-- e.g.  ",/:" or "%s" for just spaces (by default)
-- it's potentially kinda fragile though
-- since it just concats mch in the middle of a regex
function util.toTable(str,mch)
	local tmp = {}
	if not mch then mch = "[^%s]+" else mch = "[^"..mch.."]+" end
	for wrd in string.gmatch(str,mch) do
		table.insert(tmp, wrd)
	end
	return tmp
end

-- The SPLIT function splits the string around the pattern pat and returns an array of strings.
-- You can specify regular expressions as patterns.
-- pat is the pattern of what to keep, or extract, not the pattern of what counts as a separator
function string.split(str,pat)
	pat = pat or "[^%s]+"
	local t = {}
	for w in string.gmatch(str,pat) do
		t[#t+1]=w
	end
	return t
end

function table.serialize(tbl)
    local function serialize(v)
        if (type(v) == "number") then return v end
        if (type(v) == "string") then return "[[" .. v .. "]]" end
        if (type(v) == "boolean") then return tostring(v) end
        if (type(v) == "nil") then return "nil" end
        if (type(v) == "table") then return table.serialize(v) end
        return "nil"
    end

    if (type(tbl) ~= "table") then
        return serialize(tbl)
    end

    local ser = "{\n"
    for k, v in pairs(tbl) do
        ser = ser .. "[ " .. serialize(k) .. " ] = " .. serialize(v) .. ",\n"
    end
    ser = ser .. "}"

    return ser
end

function table.deserialize(ser)
    return loadstring("return " .. ser)()
end

-- table.contains checks if tbl contains the element el
-- if it does, it returns true and the key of that element
function table.contains(tbl,el)
	for k,v in pairs(tbl) do
		if v == el then
			return true,k
		end
	end
end

-- table.copy creates a shallow copy of the given table
-- i.e. making a new table with the same key-value pairs as the given table
function table.copy(t)
	local tt = {}
	for k,v in pairs(t) do
		tt[k] = v
	end
	return tt
end

-- table.removevalue removes the first encountered copy of val from tbl
-- using table.remove (adjusting all other keys by one
-- if del isn't given or simply setting the key to nil if del is true
function table.removevalue(tbl,val,del)
	for k,v in pairs(tbl) do
		if v == val then
			if not del then
				table.remove(tbl,k)
			else
				tbl[k] = nil
			end
		end
	end
end

-- toboolean converts numbers (1, 0) and strings ("true", "false") to their corresponding boolean values
function util.toboolean(v)
	if v == "true" or v == 1 then return true end
	if v == "false" or v ==0 then return false end
	return nil
end

function util.censor_text(text)
    return text:gsub("%a+", util.censor_word)
end

function util.censor_word(w)
    local word = util.censored_words[w:lower()]
    if word then
        return word
    end
    return w
end

function util.init_censored_words_table()
	local t = {}
	for i,word in ipairs(cloud.settings.censored_words) do
		local length = word:len()
		t[word] = word:sub(1, 1) .. string.rep("*", length - 2) .. word:sub(length, length)
	end
	util.censored_words = t
end

function util.rename_as(id, name)
    parse("setname " .. id .. " \"" .. name .. "\"")
end

-- cloud buster init censored words
util.init_censored_words_table()

function cloud.on(hook, func)
	if not cloud.hooks[hook] then cloud.hooks[hook] = {} end
    if not cloud.hooks[hook][func] then cloud.hooks[hook][func] = true end
end

function cloud.call_hook(hook, ...) -- literal "..." here, I'm not abbreviating!
	if not cloud.hooks[hook] then return end
    for func, _ in pairs(cloud.hooks[hook]) do
        func(...)
    end
end

function cloud.register_player_vars(vars)
    for _, v in pairs(vars) do
        table.insert(cloud.settings.vars_list, v)
    end
end

--[[
in a for k, v in pairs(...) loop, k is the table key, and v is the table value
{
    [1] = "hello 1",
    [2] = "hello 2"
}

for a table like this, k will be 1 and v will be "hello 1" during the first
iteration, k == 2 and v == "hello 2" during the second

{"hello 1", "hello 2"}

is equivalent to

{
    [1] = "hello 1",
    [2] = "hello 2"
}

therefore, in a pairs iteration of cloud.settings.credits, k will always be
numbers (the keys of the strings you have in there)
and v will be the actual strings
]]
