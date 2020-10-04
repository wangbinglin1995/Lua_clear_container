
 local function pt(c)
    local strr = '--('
    for k, v in pairs(c) do
        strr = strr .. tostring(k) .. ', '
    end
    if #(c) > 0 then
        strr = string.sub(strr, 1, -3)
    end
    strr = strr .. ')'
    print(type(c), strr)
end

local Set = {data = 0}

local function union(a, b)
	-- pt(a:get())
	-- pt(b.data)
    local c = Set:new{}  
    --c:set{} 
	for k, v in pairs(a:get()) do
		--print(k, v)
        c:add(k)
    end	
	for k, v in pairs(b.data or b) do
		--print(k, v)
        c:add(k)
	end
	-- pt(c.data)
	return c
	
end

local function complementary(a, b)
    local c = Set:new{}  
    --c:set{} 
    for k, v in pairs(a:get()) do
        if not b:get()[k] then
			c:add(k)
		end
    end	
	return c
end

local function intersection(a, b)
    local c = Set.new{}
    c:set{}
	for k in pairs(a:get()) do
		if b:get()[k] then
			c:add(k)
		end
	end
	return c
end



--求A集合是不是B集合的真子集
local function lessthan(a, b)

	for k in pairs(a:get()) do
		if not b:get()[k] then
			return false
		end
	end
	return true
end



 --new可以视为构造函数
function Set:new(t) 
    o = {}  -- 如果用户没有提供table，则创建一个
    setmetatable(o, self)
    self.__index = self
   
    if type(t) ~= type({}) then 
        t = {t}
    end 
    data = {}
    if t ~= nil  and #t>0 then 
        for k, v in pairs(t) do
            data[v] = true
        end     
    end
    self.data = data

    self.__add = union
    self.__lt = lessthan
    self.__sub = complementary
    self.__mul = intersection
    return o
end

function Set:print ()    
    -- if type(self.data) ~= type({}) then 
    --     self.data = {self.data}
    -- end

    local strr = '('
    for k, v in pairs(self.data) do
        strr = strr .. tostring(k) .. ', '
    end
    if #(self.data) > 0 then
        strr = string.sub(strr, 1, -3)
        --print('xsfvzxcvzxv')
    end
    strr = strr .. ')'

    print(strr)
end
 
function Set:set(t)
    if type(t) ~= type({}) then 
        t = {t}
    end 
    data = {}
    if t ~= nil  and #t>0 then 
        for k, v in pairs(t) do
            data[v] = true
        end     
    end
    self.data = data
end

function Set:init(t)
	local a = Set:new()
	a:set(t)	
	return a
end

function Set:add(v)
    if type(t) ~= type({}) then         
        self.data[v] = true
    end     
end

function Set:get()
    return self.data
end

return Set
