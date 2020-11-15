
function Array(...)
    local new_array = {}

    local __array__ = {...}

    local __methods__ = {}

    function __methods__:push(v)
        table.insert(__array__, v)
    end
    function __methods__:pop()
        if #__array__ and #__array__>0 then
            table.remove(__array__, #__array__)
        end
    end

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

    function __methods__:sort(func)
        table.sort(__array__, func)
    end

    -- extend methods here

    local mt = {
        __index = function(t, k)  -- k => print/insert/removeAt , type: hash-map key (string)           
            if __array__[k] then
                return __array__[k]
            end
            if __methods__[k] then  -- __methods__[k] => print/insert/removeAt, type:func
                return __methods__[k]
            end
        end,
        __newindex = function(t, k, v)  -- k = print/insert/removeAt
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

local arr = Array(1,2,3)
print(arr[1])   -- 1
print(arr[4])   -- nil
arr[1] = 4
arr:print()     -- 4,3,2
arr[4] = 'a'    -- warning : [4] index out of range.
arr[2] = nil    -- warning : can not remove element by using  `nil`.
arr:insert('a')
arr:insert('b', 2)
arr:print()     -- 4,b,2,3,a
arr:removeAt(1)
arr:print()     -- b,2,3,a

arr:push(45)
arr:push('asdf')
arr:sort(function(a, b)
    if tostring(a) and tostring(b) then
        return tostring(a) < tostring(b)
    else
        return type(a)<type(b)
    end
end
)

arr:print()
arr:pop()
arr:pop()
arr:print()