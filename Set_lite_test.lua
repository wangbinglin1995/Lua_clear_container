local set1 = require("Set")

local function test()

    local a = set1.new({2,3,4,5})    
    print("a=", a)   -- (2, 3, 4, 5)
    set1.print(a)    -- (2, 3, 4, 5)

    local b = set1.new({1,6,3})
    print("b=", b) -- (1, 3, 6)

    local c = a + b  
    print("c=", c)    -- (1, 2, 3, 4, 5, 6)


    local d = a-b
    print("d=" , d)    -- (2, 4, 5)

    print("a>b? = "  , a>b) -- false

    local e = a*b    --交集
    print("e= ", e)    -- (2, 4, 5)

    local f = b*a
    print("f= " , f)    -- (2, 4, 5)


end


test()

