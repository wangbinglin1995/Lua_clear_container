
local _M = {}

local function tostringg(t)  -- print hash-map key
    local strr = {}
    for k, v in pairs(t) do
        table.insert(strr, tostring(k)) 
	end
	strr = table.concat(strr, ", ")    
    return '(' .. strr .. ')'    
end

local function union(a, b)    -- 并集
    local ans = {}   
	for k, v in pairs(a) do	
        ans[k] = true
    end	
    for k, v in pairs(b) do        
        ans[k] = true
	end   
	return _M:new(ans)	
end


local function complementary(a, b)    --差集
    local ans = {}
    for k, v in pairs(a) do
        if not b[k] then
            ans[k] = true
		end
    end	
	return _M:new(ans)
end

local function intersection(a, b)   -- 交集
    local ans = {}
	for k in pairs(a) do
		if b[k] then
			ans[k] = true
		end
	end
	return _M:new(ans)
end

--求A集合是不是B集合的真子集
local function lessthan(a, b)
	for k in pairs(a) do
		if not b[k] then
			return false
		end
	end
	return true
end



-- __add(加)
-- __sub(减)，__mul(乘)，__div(除)，__unm(相反数)，__mod(取模)，__pow(乘幂)
-- 关系类的元方法：
-- __eq(等于)，__lt(小于)，__le(小于等于)

 --new可以视为构造函数
function _M:new(o) 
    o = o or {}  -- 如果用户没有提供table，则创建一个
    if type(o) ~= 'table' then  
        o = {o}
    end
    setmetatable(o, self)
    self.__index = self    
    self.__add = union 
    self.__sub = complementary
    self.__mul = intersection

    self.__tostring = tostringg  
    self.__lt = lessthan
    
    return o
end

function _M:init(array)  -- "array" must be an array 
    local tx = {}
    for k, v in ipairs(array) do
        tx[v] = true
    end
    return _M:new(tx)    -- hash-map
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

function _M:printt (name)  
    local title =  "Set: ".. (name or "") .. " = "    
    print(title.. tostring(self) )
end


return _M
