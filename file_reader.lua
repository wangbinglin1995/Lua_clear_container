local flv_reader = {}

function flv_reader:init(d)
    local reader = {
        pos = 1,
        eof = false,
        data = d
    }    
    setmetatable(reader, self)
    self.__index = self      
    return reader 
end
    
function flv_reader:read(n)
    if n + self.pos > #self.data then 
        self.eof = true
        return
    end
    local res = string.sub(self.data, self.pos, self.pos+n-1)
    self.pos = self.pos + n
    return res
end