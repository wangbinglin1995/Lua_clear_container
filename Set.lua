local _M = {}
local mt = {}


function _M.new(t)
	local data = {}
	setmetatable(data, mt)
	for k, v in pairs(t) do
		data[v] = true
	end
	return data
end

function _M.tostring(s)
    local strr = {}
    for k in pairs(s) do
        table.insert(strr, tostring(k)) 
	end
	strr = table.concat(strr, ", ")
    
    return '(' .. strr .. ')'
end

function _M.print(s)
    print(_M.tostring(s))
end


function _M.union(a,b)     -- 并集
    if type(b) ~= type({}) then
        b = {b}
    end
	local data = _M.new{}
	for k in pairs(a) do
		data[k] = true
	end
	for k in pairs(b) do
		data[k] = true
	end
	return data
end

function _M.intersection(a,b)    -- 交集

	local data = _M.new{}
	for k in pairs(a) do
		if b[k] then
			data[k] = true
		end
	end
	return data
end


function _M.complementary(a,b)    --差集
	local data = _M.new{}
	for k in pairs(a) do
		if not b[k] then
			data[k] = true
		end
	end
	return data
end


--求A集合是不是B集合的真子集
function _M.lessthan(a, b)

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
mt.__lt = _M.lessthan

mt.__sub = _M.complementary

mt.__add = _M.union
mt.__mul = _M.intersection
mt.__tostring = _M.tostring


return _M

