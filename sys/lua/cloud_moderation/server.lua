local _TIMELOADED = os.millisecs()

print_mod = "\169000255000[Cloud Moderation] - "

if cloud == nil then cloud = {} end
if cloud.command_modules == nil then cloud.command_modules = {} end
if cloud.hooks == nil then cloud.hooks = {} end

function scriptPath()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

local path = scriptPath()
path = string.sub(path,1,-2)
sys, lua, path = path:match("([^,]+)/([^,]+)/([^,]+)")

directory = "sys/lua/"..path.."/"

function fileExists(path)
	local file = io.open(path, "r")
	if file ~= nil then
		io.close(file)
		return true
	else
		return false
	end
end

function dofileLua(path, create)
	if not fileExists(path) then
		if create == true then
			print(print_mod.."The file "..path.." could not be found or opened, creating one for you instead!")
			file = io.open(path, "w")
			io.close(file)
		else
			print(print_mod.."The file "..path.." could not be found or opened!")
			return false
		end
	end
	dofile(path)
end

-- Returns color codes into \169R.G.B --
function colors(name)
    return string.char(169)..cloud.colors[name]
end

-- Core
cloud.core = {"config","util","functions","commands","moderation","fix","unimenu"}

for k, v in pairs(cloud.core) do
	dofile(directory..v..".lua")
	print(print_mod..v..".lua CORE LOADED!")
end

-- Modules
for k, v in pairs(cloud.settings.modules) do
	if v then
		dofile(directory.."modules/"..k..".lua")
		print(print_mod..k..".lua MODULE LOADED!")
	end
end

print("\169000255000[Cloud Moderation] - loaded up successfully! (loaded in "..os.difftime(os.millisecs(),_TIMELOADED).."ms)")
