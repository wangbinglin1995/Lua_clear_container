local set = require('Set2')


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


local a = set:new()
a:set({2,3,4,5})
a:print()
--pt(a.data)
--print(type(a))

local b = set:init({1,6,3})
b:print()
--pt(b.data)
local c = a + b
c:print()


local a = set:new()
a:set{101, 202, 100, 200} 
--a:print()

local b = set:new()
b:set{303, 404, 100, 400} 

local c = set:new()
c:set{503, 604} 

a:print()
b:print()


local d = a+b
d:print()

local e = a-b
e:print()
