-- TSprite = { x = 0, y = 0, }
-- function TSprite:setPosition(x, y)
--     self.x = x; self.y = y;
-- end

-- local who = TSprite;
-- TSprite = nil;
-- who:setPosition(1, 2);



local set = require('Set2')


local a = set:new({2,3,4,5})

print(type(a))

local b = set:new({1,6,3})
local c = a + b
set.print(c)
local s = a*b
set.print(s)

a:print()