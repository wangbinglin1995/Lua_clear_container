local Array1 = require('Array')

-- local arr = Array1:new({1,2,3})
-- print(arr[1])   -- 1
-- print(arr[4])   -- nil
-- arr[1] = 4
-- arr:print()     -- 4,3,2
-- arr[4] = 'a'    -- warning : [4] index out of range.
-- arr[2] = nil    -- warning : can not remove element by using  `nil`.
-- arr:insert('a')
-- arr:insert('b', 2)
-- arr:print()     -- 4,b,2,3,a
-- arr:removeAt(1)
-- arr:print()     -- b,2,3,a


print("========================")
local stt = Array1:new{"123", "wdf", insert=print, insert2="asd", removeAt="sdfd"}

print(tostring(stt))
stt:print()
stt.insert('2')

-- stt:printt()
stt:insert('aaa')