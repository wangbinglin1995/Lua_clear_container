
local _M = {}

function _M.new(...)
    local new_array = {}

    local __array__ = {...}

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
        __index = function(t, k)
            if __array__[k] then
                return __array__[k]
            end
            if __methods__[k] then
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
