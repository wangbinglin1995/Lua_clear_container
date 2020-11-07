local set2 = require('set2_oop')

local function test()
    local a = set2:init({2,3,4,5,3, 3, 2})    
    print(a)
    a:print('a')

    local b = set2:init({1,6,3, 1,3})
    b:print('b')
    
    b:add('ss')
    b:print('new b')
    b:delete('ss')
    b:print('delete ss b')
    b:delete(6)
    b:print('delete 6 b')
    b:add('6')

    local c = a + b  
    c:print('union c')

    local d = a - b
    d:print('sub d')    -- (2, 4, 5)

    print("a>b? = "  , a>b) -- false

    local e = a*b    --交集
    e:print('e=a*b')    -- (3)

    local f = b*a
    f:add('rfg')
    f:print('f')    -- (3)

    local g=set2:init{4,6,8, a=7, b=9}  -- init must get an array
    g:print('g')  -- (4, 6, 8)
    local h=set2:init{a=7, b=9}  -- init must get an array
    h:print('h')  -- ()

end

test()

