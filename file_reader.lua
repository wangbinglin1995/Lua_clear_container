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


local function file_reader_stream(file_name)    
    local file = io.open(file_name, "rb")
    if not file then        
        return nil
    end
    return function(n)
        n = n or 64   
        local eof = false    
        local data = file:read(n)
        if data == nil or #data < n then 
            eof = true
            file:close()
        end  
        return data, eof
    end
end
