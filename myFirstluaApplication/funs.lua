local device = require("device")

local tools = {}
local debugCount = 1
function tools.add(a,b)
	return a + b
end


function tools.log(object)
	local t = type(object)
	local msg = nil
	if t == "string" then
		msg = object
	elseif t == "table" then
		msg = "{\n"
		for k,v in pairs(object) do
			msg = string.format("%s\t%s = %s\n",msg,k,v)
		end
		msg = msg.."}"
	end
	print( string.format("[debug %d] %s",debugCount,msg))
	debugCount = debugCount + 1
end


function tools.extend(parent,attr)
	local cls = {}
	for key,value in pairs(attr) do
		if type(value) == "function"  then
			cls[key] = (function (key,fn)
				return function (self,...)
					local tmp = self._super;
					self._super = function (...)
						parent[key](self,...)
					end
					local ret = fn(self,...)
				end
			end)(key,value)
		else	
			cls[key] = value
		end
		
	end
	
	cls.__index = cls;
	
	setmetatable(cls,parent)
	
	function cls.new(...)
		local ret = {}
		setmetatable(ret,cls)
		ret:ctor(...)
		return ret
	end
			
	return cls
end

function tools.writeToFile(file,msg)
	local f = io.open(file,"a")
	if f ~= nil then
		--io.output(f)
		f:write(msg)
		f:close()
		return string.format("write %s to %s sussfully",msg,file)
	else
		return string.format("write %s to %s fail",msg,file)
	end
end

function tools.readFile(file)
	local f = io.open(file,"r")
	if f ~= nil then
		--io.input(f)
		local data = f:read("*a")
		--io.close(f)
		f:close()
		return data
	else
		return string.format("file %s is not exists",file)
	end
end

function tools.isFileExists(file)
	local f = io.open(file,"r")
	return f ~= nil
end


function tools.currDir()
  os.execute("cd > cd.tmp")
  local f = io.open("cd.tmp", r)
  local cwd = f:read("*a")
  f:close()
  os.remove("cd.tmp")
  return cwd
end

function tools.mkdirs(path)
	if device.plaform == "window" then
		os.execute("mkdir \""..path.."\"")
	else
		os.execute("mkdir -p \""..path.."\"")
	end
end

function tools.removeDir(path)
	if device.plaform == "window" then
		os.execute("rm -rf \""..path.."\"")
	else
		os.execute("rm -rf -p \""..path.."\"")
	end
end


function string:split(sp)
	local re,ret = string.format("([^%s])",sp),{}
	string.gsub(self,re,function(item) table.insert(ret,item) end)
	return ret
end

return tools