local tools = require("funs")

local parent = {["name"] = "father",where="sh",id="0"}

function parent:ctor(id)
	self.id = id;
end

function parent:show()
	tools.log("my id is "..self.id)
end

parent.__index = parent




local child = tools.extend(parent,{
	name = nil,
	age = nil,
	ctor = function (self,name,age)
		self._super(14567);
		self.name = name
		self.age = age
	end,
	
	show = function (self)
		self._super()
		tools.log("my name is "..self.name.." and my age is "..self.age)		
	end
})

local c = child.new("child",15)
c:show()

local st = tools.extend(parent,{
	name="student",
	age=12,
	show = function(self,name)
		print("------------------------")
		--self._super()
		tools.log("my age is "..self.where.." and my name is "..name)
	end
	
})


st.new():show("just a student")
