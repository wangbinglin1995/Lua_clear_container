local set2 = require('set2_oop')

local function test()
    local a = set2:init({2,3,4,5,3, 3, 2})    
    print(a)
    a:printt('a')

    local b = set2:init({1,6,3, 1,3})
    b:printt('b')
    
    b:add('ss')
    b:printt('new b')

    local c = a + b  
    c:printt('union c')

    local d = a - b
    d:printt('sub d')    -- (2, 4, 5)

    print("a>b? = "  , a>b) -- false

    local e = a*b    --交集
    e:printt('e=a*b')    -- (3)

    local f = b*a
    f:add('rfg')
    f:printt('f')    -- (3)

    local g=set2:init{4,6,8, a=7, b=9}  -- init must get an array
    g:printt('g')  -- (4, 6, 8)
    local h=set2:init{a=7, b=9}  -- init must get an array
    h:printt('h')  -- ()

end

test()

