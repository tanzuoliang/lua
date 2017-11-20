--local f = require("util")
--print(f.add(12,34))
--
--
--function show()
--print "show func"
--end

function getMain()
	local data = {
			debug = function(msg) print("[message] "..msg) end
		}
		
	return {
		__index = function(mytable,key)
			return data[key]
		end,
		
		__newindex = function(mytable,key,value)
			if data == nil then data = {} end
			print("set key "..key.." "..value)
			data[key] = value
		end
	}
end


local myModel = setmetatable({name="wda"}, getMain())
myModel["name"] = "ysj"
print(myModel["name"])
myModel.debug("fu")


local child = setmetatable({},{__index=myModel})
child.debug("ch")
print(child.name)


local Account = {value = 0}
function Account:new(o)  -- 这里是冒号哦
	 o = o or {}  -- 如果用户没有提供table，则创建一个
	 setmetatable(o, self)
	 self.__index = self
	 return o
end

function Account:display()
	 self.value = self.value + 100
	 print(self.value)
end

local a = Account:new{} -- 这里使用原型Account创建了一个对象a
a:display() --(1)
a:display() --(2)