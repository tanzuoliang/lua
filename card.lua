--   不带鬼牌的胡牌算法.txt
----
--mjlib胡牌思路 注意：不带鬼牌
--1、不同花色分开处理，分别校验是否能满足 将、顺子、刻子
--2、分析东南西北风中发白时，不需要分析顺子的情况，简单很多
--3、分析单一花色时，按连续性将麻将切割成小段
--比如：1筒2筒3筒3筒3筒3筒6筒7筒8筒2万3万3万3万4万
--拆成：a段 1筒2筒3筒3筒3筒3筒
--			b段 6筒7筒8筒
--			c段 2万3万3万3万4万
--
--4、将每小段去掉花色信息、点数信息以后只剩下形状
--a段变成 114
--b段变成 111
--c段变成 131
--
--5、如果小段中，牌的数量为 3*n
--查表wave_tbl判断是否满足拆分, 例，a的key为114, b的key为111
--查不到表示不满足拆分，不能胡
--
--6、如果小段中，牌的数量为 3*n + 2，代表里面有将牌
--查表wave_tbl_eye判断是否满足带将的拆分，例，c的key为131
--查不到表示不满足拆分，不能胡
--
--附：
--组合表，以长度3为示例
--wave_tbl = {
--		[111] = true,[222]=true,[333]=true,[444]=true,
--		[114] = true, [141]=true, [411]=true,
--		[144] = true, [414]=true, [441]=true,
--}
--
--wave_tbl_eye则是在wave_tbl表中通过三种方式加上一对牌:
--1、头部加一对牌 如, 2111
--2、尾部加一对牌 如, 1112
--3、中部加一对牌 如, 311, 131, 113
----



--     分拆法算法思路.txt

--步进分拆法：（注意：不带鬼牌）
--
--1、将牌按连续性进行拆分，拆出的组合为3*n 或 3*n + 2，如果有例外，则不能胡。
--2、检查数量为3*n的连续段是否满足胡牌条件，如果都能满足，再用方法3检查3*n+2
--3、在连续的牌中，牌张数为3*n + 2的张数拆出可能的将牌
--4、扣除将牌后，分别检查各连续的段是否满足胡牌
--
--检查段的思路：
--   例：连续段为 1筒1筒1筒2筒3筒3筒4筒4筒5筒
--	   数字表示为 31221
--
--   a、取3位数为key，从下表查询，如果有结果则扣除这个数字。
--	  312取到结果330，则余下数字为1221
--   b、如果a步骤没有结果，则取2位数为key
--   c、如果b步骤没有结果，则取1位数为key
--   如果c失败，则不能胡
--
--   31221拆分全步骤：
--   312 = 300 余 1221
--   122 = 111 余 111
--   111 = 111 全部拆分完毕，能胡
--
--拆分表：
--local t = {
--	[3] = 3, [4] = 3,
--	[31] = 30, [32] = 30, 33 = 33, 34 = 33, 44 = 33,
--	[111] = 111, [112] = 111, [113] = 111, [114] = 114,
--	[122] = 111, [123] = 111, [124] = 111,
--	[133] = 111, [134] = 111,
--	[141] = 141, [142] = 141, [143] = 141, [144] = 144,
--	[222] = 222, [223] = 222, [224] = 222,
--	[233] = 222, [234] = 222,
--	[244] = 222,
--	[311] = 300, [312] = 300, [313] = 300, [314] = 300,
--	[322] = 300, [323] = 300, [324] = 300,
--	[331] = 330, [332] = 330, [333] = 333, [334] = 333,
--	[341] = 330, [342] = 330, [343] = 330, [344] = 333,
--	[411] = 411, [412] = 411, [413] = 411, [414] = 414,
--	[422] = 411, [423] = 411, [424] = 411,
--	[433] = 411, [434] = 411,
--	[441] = 441, [442] = 441, [443] = 441, [444] = 444
--}
--
--表格生成思路：
--
--1、从边上取牌的数量
--2、如果是1，则取111
--3、如果是2，则取222
--4、如果是3，则取3
--5、如果是4，则取411



--带鬼牌的胡牌算法.txt
--
--mjlib胡牌思路 注意：带鬼牌
--1、统计牌中鬼牌个数 nGui，将鬼牌从牌数据中去除
--2、不同花色分开处理，分别校验是否能满足 将、顺子、刻子
--3、分析东南西北风中发白时，不需要分析顺子的情况，简单很多
--4、分析单一花色时，直接根据1-9点对应数字得出一个9位的整数，每位上为0-4代表该点数上有几张牌
--比如：1筒2筒3筒3筒3筒3筒6筒7筒8筒2万3万3万3万4万
--数字：筒: 1,1,4,0,0,1,1,1,0 得出的数字为114001110
--	万 0,1,3,1,0,0,0,0,0 得出的数字为13100000
-- 
--每种花色与赖子组合，如果所有花色都能配型成功则可胡牌
--检查配型时，每种花色的牌数量必需是3*n 或者 3*n + 2
--根据赖子个数、带不带将，查找对应表，看能否满足3*n 或 3*n+2的牌型
--
--表的产生:
--1、穷举筒、万两种花色的胡牌可能，将对应的牌型记录为数字（如上面的根据花色点数内容生成数字, 3*n的放入不带将的表，3*n+2的放入带将表）
--2、1张鬼牌表是根据穷举不带鬼的表，去除1个牌以后形成的数字
--3、2张鬼牌表是根据穷举不带鬼的表，去除2个牌以后形成的数字
--4、3张鬼牌表是根据穷举不带鬼的表，去除3个牌以后形成的数字
--5、4张鬼牌表是根据穷举不带鬼的表，去除4个牌以后形成的数字
--字牌表产出：
--1、穷举筒、字两个牌型的胡牌可能，将对应的牌型记录为数字（如上面的根据花色点数内容生成数字, 3*n的放入不带将的表，3*n+2的放入带将表）
--2，3，4，5，如上
--
--表的举例及规模：
--不带鬼 {300000000}	{300000002, 300000020, 300000200...}
--1鬼 {200000000}		{300000001, 200000002,...}
--...
--
--总数    18874368
--胡  206300
--失败    5201520
--没有鬼表大小    2867
--没有鬼将表大小  18858
--1鬼表大小   11639
--1鬼将表大小 55234
--2鬼表大小   19309
--2鬼将表大小 71128
--3鬼表大小   18481
--3鬼将表大小 58697
--4鬼表大小   12234
--4鬼将表大小 38630
--
--字牌表规模：
--总数    4477456
--胡  127044
--失败    1569835
--没有鬼表大小    99
--没有鬼将表大小  399
--1鬼表大小   294
--1鬼将表大小 945
--2鬼表大小   630
--2鬼将表大小 1576
--3鬼表大小   911
--3鬼将表大小 2135
--4鬼表大小   1050
--4鬼将表大小 2366

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