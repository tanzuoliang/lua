function table_copy_table(ori_tab)
	if (type(ori_tab) ~= "table") then
		return nil
	end
	local new_tab = {}
	for i,v in pairs(ori_tab) do
		local vtyp = type(v)
		if (vtyp == "table") then
			new_tab[i] = table_copy_table(v)
		elseif (vtyp == "thread") then
			new_tab[i] = v
		elseif (vtyp == "userdata") then
			new_tab[i] = v
		else
			new_tab[i] = v
		end
	end
	return new_tab
end


function sort_card(t)
	table.sort(t, function(a,b)
		local sa,ra = a&0xf,a&0xf0
		local sb,rb = b&0xf,b&0xf0
		if ra == rb then
			return sa < sb
		else
			return ra < rb
		end

	end)
end

function remove_three_same(t)
	assert(#t%3 == 0 and #t > 0)
	local found = false
	local begin
	for i=1,#t - 2 do
		if t[i] == t[i + 1] and t[i] == t[i + 2] then
			found = true
			begin = i
			break
		end
	end

	if found then
		local ret = {}
		for k=1,3 do
			table.insert(ret,table.remove(t,begin))
		end
		return true,ret
	end
end

function remove_straight(t)
	assert(#t%3 == 0 and #t > 0)
	local ret = {}
	for i=1,#t - 2 do
		local found1
		local found2
		local position = {}
		table.insert(position,i)
		for k = i,#t do
			if not found1 and t[i] + 1 == t[k] then
				found1  = true 
				table.insert(position,k)
			end 

			if not found2 and t[i] + 2 == t[k] then
				found2  = true 
				table.insert(position,k)
			end 

			if found2 and found1 then
				break
			end
		end
		if found2 and found1 then
			for i = #position,1,-1 do
				table.insert(ret,table.remove(t,position[i]))
			end
			return true,ret
		end
	end
end


function check_3n(set)
	assert(#set%3 == 0)
	sort_card(set)
	local t1 = table_copy_table(set)
	local t2 = table_copy_table(set)

	if remove_three_same(t1) then
		if #t1 == 0 or check_3n(t1)then
			return true
		end
	end

	if remove_straight(t2) then
		if #t2 == 0 or check_3n(t2) then
			return true
		end
	end
	return false
end


function showTable(ta)
	local s = "tabble:\n"
	for k,v in ipairs(ta) do
		s =  s.."  "..v
	end	
	print(s)	
end

function check_hu(set)
	assert((#set)%3 == 2)
	sort_card(set)
	for i=1,#set - 1 do
		if set[i] == set[i + 1] then
			local check = {}
			for k = 1,#set do
				if k ~= i and k ~= i + 1 then
--					print("sort "..set[k])
					table.insert(check,set[k])
				end
			end
			showTable(check)
			

			if #check == 0 or check_3n(check) then
				return true
			end
		end
	end
end


local sets = {
	{0x11,0x11,0x11,0x11,0x12,0x12,0x12,0x12,0x13,0x13,0x13,0x13,0x14,0x14,0x14,0x14,0x15}, 
	{0x11,0x12,0x13,0x15,0x15},
	{0x12,0x13,0x14,0x23,0x23,0x24,0x25,0x26}
}


for k,v in pairs(sets) do
	print "--------------------------------------------------------"
	print(check_hu(v))
end