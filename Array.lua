
local _M = {}


function _M.init(...)
    local __array__ = {...}
end


--local mt = {}


function _M:new(array_)
    if array_ == nil then return nil end
    if type(array_) ~= 'table' then  array_ = {array_} end
    
    local __array__ = {}    
    for _, v in pairs(array_) do
        --print("map", k, v)
        table.insert(__array__, v)
    end
    for k, v in ipairs(array_) do
        --print("array", k, v)
        table.insert(__array__, k)
    end
    
    if #array_ < 1 then print(#array_); return nil end

     --array_
-- local __array__ = {...}
    local new_array = {}

    

    local __methods__ = {}
    function __methods__:insert(v, at)
        local len = #__array__ + 1
        at = type(at) == 'number' and at or len
        at = math.min(at, len)
        table.insert(__array__, at, v)
    end
    function __methods__:removeAt(at)
        at = type(at) == 'number' and at or #__array__
        table.remove(__array__, at)
    end
    function __methods__:print()
        print('---> array content begin  <---')
        for i, v in ipairs(__array__) do
            print(string.format('[%s] => ', i), v)
        end
        print('---> array content end  <---')
    end

    -- extend methods here

    local mt = {
        __index = function(t, k)   -- k = print/insert/removeAt
            print("======", tostring(k))
            if __array__[k] then
                return __array__[k]
            end
            if __methods__[k] then
                print("======", tostring(__methods__[k]))
                return __methods__[k]
            end
        end,
        __newindex = function(t, k, v)
            if nil == __array__[k] then
                print(string.format('warning : [%s] index out of range.', tostring(k)))
                return
            end
            if nil == v then
                print(string.format('warning : can not remove element by using  `nil`.'))
                return
            end
            __array__[k] = v
        end
    }
    setmetatable(new_array, mt)

    return new_array
end

return _M
