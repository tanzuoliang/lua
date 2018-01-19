
local mt = {
	__add = function(a,b)
		return a.age + b.age
	end
}

function string:append(b)
	return string.format("%s%s",self,b)
end

local s = "a"

print(s:append("bb"))



local a = {age=12}
setmetatable(a,mt)
local b = {age=15}
setmetatable(b,mt)

print(a + b)