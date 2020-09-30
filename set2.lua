local Set = {_set = {}}

self = {}
-- Meta class
-- Shape = {area = 0}
-- 基础类方法 new




function Set.union(a,b)
    if type(b) ~= type({}) then
        b = {b}
    end
	local set = Set.new{}
	for k in pairs(a) do
		set[k] = true
	end
	for k in pairs(b) do
		set[k] = true
	end
	return set
end

function Set.intersection(a,b)

	local set = Set.new{}
	for k in pairs(a) do
		if b[k] then
			set[k] = true
		end
	end
	return set
end


function Set.complementary(a,b)
	local set = Set.new{}
	for k in pairs(a) do
		if not b[k] then
			set[k] = true
		end
	end
	return set
end


--求A集合是不是B集合的真子集
function Set.lessthan(a, b)

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
self.__lt = Set.lessthan

self.__sub = Set.complementary

self.__add = Set.union
self.__mul = Set.intersection



function Set:new (t)
    o = {}
    setmetatable(o, self)
    self.__index = self
    
    local set = {}
    for k,v in pairs(t) do
        set[v] = true
    end 

    self._set = set;
    return o
end
-- 基础类方法 printArea
function Set:print ()    
    local strr = '('
    for k in pairs(self._set) do
        strr = strr .. tostring(k) .. ', '
    end
    if #self._set > 0 then
        strr = string.sub(strr, 1, -3)
    end
    strr = strr .. ')'

    print(strr)
end

return Set

