local set2 = require('Set2')
local set1 = require("Set")


local function pt(c)
    local strr = '('
    for k, v in pairs(c) do
        strr = strr .. tostring(k) .. ', '
    end
    if #(c) > 0 then
        strr = string.sub(strr, 1, -3)
    end
    strr = strr .. ')'
    print(type(c), strr)
end


local function test2()

    local a = set2:new()
    a:set({2,3,4,5})
    a:print()
    --pt(a.data)
    --print(type(a))

    local b = set2:init({1,6,3})
    b:print()
    --pt(b.data)
    local c = a + b
    c:print()


    local a = set2:new()
    a:set{101, 202, 100, 200} 
    --a:print()

    local b = set2:new()
    b:set{303, 404, 100, 400} 

    local c = set2:new()
    c:set{503, 604} 

    a:print()
    b:print()


    local d = a+b
    d:print()

    local e = a-b
    e:print()
end


local function test()

    local a = set1.new({2,3,4,5})    
    print(a)
    --pt(a.data)
    --print(type(a))

    local b = set1.new({1,6,3})
    print(b)
    --pt(b.data)
    local c = a + b
    

    print(c)


end

-- set3 = require("set_try")
-- test(set3)
set3 = require("set4")

local function test3()

    local a = set3.init({2,3,4,5,3, 3, 2})    
    print(a)
    a:printt()
    --pt(a.data)
    --print(type(a))

    local b = set3.init({1,6,3, 1,3})
    print(b)
    --pt(b.data)
    
    b:add('ss')

    local c = a + b    

    print(c)

    --set3.printt(b)
    a:printt()
    b:printt()
    c:printt()

    local d=set3.init{4,6,8, a=7, b=9}
    print(d)

end


local a = {}
a[5]=true
a[9]=true
a['d']=true

-- for k, v in pairs(a) do
--     print(k, ":= ",  v)
-- end
test3()











