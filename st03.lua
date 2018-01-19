function readFile(name)
	local f = io.open(name,"r")
	local data = f:read("*all")
	f:close()
	return data
end

function getFileSize(name)
	local f = io.open(name,"r")
	local size = f:seek("end",0)
	f:close()
	return size
end

function getFileRoot(name)
	local f = io.popen("ls")
	local path = f:read("*all"):sub(1,-2)
	f:close()
	return path
end


print("------------------------------------------")
local lfs = require "lfs"

for k,v in pairs(lfs) do
	print(k)
end

for k in lfs.dir(lfs.currentdir()) do
	print(k)
end

function showTable(ta)
	for k,v in pairs(ta) do
		print(string.format("%s = %s",k,v))
	end
end


function compareFile(a,b)
	local ta = lfs.attributes(a)
	local tb = lfs.attributes(b)
	if ta.modification < tb.modification then
		return -1
	elseif 	ta.modification == tb.modification then
		return 0
	else
		return 1
	end		
end

print(compareFile("st.txt","777"))

showTable(lfs.symlinkattributes("st.txt"))
showTable(lfs.attributes("st.txt"))
--lfs.link("st.txt","777")


local u = require "util"
print(u.lua_hello())