--  工具类
cc.exports.Utils = class("Utils")
-- 下面的二进制=ascii
 
-- 二进制转int
function Utils:bufToInt32(num1, num2, num3, num4)
    local num = 0;
    num = num + self:leftShift(num1, 24);
    num = num + self:leftShift(num2, 16);
    num = num + self:leftShift(num3, 8);
    num = num + num4;
    return num;
end
 
-- int转二进制
function Utils:int32ToBufStr(num)
    local str = "";
    str = str .. self:numToAscii(self:rightShift(num, 24));
    str = str .. self:numToAscii(self:rightShift(num, 16));
    str = str .. self:numToAscii(self:rightShift(num, 8));
    str = str .. self:numToAscii(num);
    return str;
end
 
-- 二进制转shot
function Utils:bufToInt16(num1, num2)
    local num = 0;
    num = num + self:leftShift(num1, 8);
    num = num + num2;
    return num;
end
 
-- shot转二进制
function Utils:int16ToBufStr(num)
    local str = "";
    str = str .. self:numToAscii(self:rightShift(num, 8));
    str = str .. self:numToAscii(num);
    return str;
end
 
 
-- 左移
function Utils:leftShift(num, shift)
    return math.floor(num * (2 ^ shift));
end
 
-- 右移
function Utils:rightShift(num, shift)
    return math.floor(num / (2 ^ shift));
end
 
-- 转成Ascii
function Utils:numToAscii(num)
    num = num % 256;
    return string.char(num);
end

local function bin2hex(s)
    s=string.gsub(s,"(.)",function (x) return string.format("%02X ",string.byte(x)) end)
    return s
end

local function bin2number(str)
    local res = 0
    for i = 1, #str do
        res = res * 256 + tonumber(string.byte(string.sub(str, i, i)))
    end
    return res
end