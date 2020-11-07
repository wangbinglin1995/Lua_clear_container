
local _M = {}

local function union(a, b)
    local ans = {}   
	for k, v in pairs(a) do	
        ans[k] = true
    end	
    for k, v in pairs(b) do        
        ans[k] = true
	end   
	return _M:new(ans)	
end

local function tostringg(t)
    local strr = {}
    for k, v in pairs(t) do
        table.insert(strr, tostring(k)) 
	end
	strr = table.concat(strr, ", ")    
    return '(' .. strr .. ')'    
end

local function complementary(a, b)
    local c  
    --c:set{} 
    local ans={}
    for k, v in pairs(a) do
        if not b[k] then
            --c:add(k)
            ans[k] = true
		end
    end	
	return Set:new(ans)
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


local mt = {}


 --new可以视为构造函数
function _M:new(o) 
    o = o or {}  -- 如果用户没有提供table，则创建一个
    setmetatable(o, self)
    self.__index = self    
    self.__add = union 
    self.__tostring = tostringg  
    self.__lt = lessthan
    self.__sub = complementary
    self.__mul = intersection
    return o
end

function _M.init(array)  -- "array" must be an array 
    local tx = {}
    for k, v in ipairs(array) do
        tx[v] = true
    end
    return _M:new(tx)
end

function _M:add(array)
    if type(array) ~= type({}) then  
        array = {array}
    end
    for k, v in ipairs(array) do
        self[v] = true
    end     
end

function _M:get()
    local ans = {}
    for k, v in pairs(self) do
        table.insert(ans, k) 
    end
    return ans
end


function _M:printt () 
    local strr = {}
    for k, v in pairs(self) do
        table.insert(strr, tostring(k)) 
    end
	strr = table.concat(strr, ", ")

    print("set: ".. strr)
end





return _M
