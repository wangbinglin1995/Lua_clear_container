bit  = require "bit"


local function file_data_reader(file_path)    
    local file = io.open(file_path, "rb")
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


local function bin2number(str)
    local res = 0
    for i = 1, #str do
        res = res * 256 + tonumber(string.byte(string.sub(str, i, i)))
    end
    return res
end


local function list_flv_all_tags(file_path)
    print('=========== list_flv_all_tags =================')
    local reader = file_data_reader(file_path)
    local header, eof = reader(13)
    local tagHeader, tagData, tag_end_flag
    
    while not eof do  
        tagHeader, eof = reader(11)
        if not tagHeader then  break  end 

        local tag_data_length = bin2number(string.sub(tagHeader, 2, 4))
        local timeStamp = bin2number(string.sub(tagHeader, 5, 7))

        tagData, eof = reader(tag_data_length)
        tag_end_flag, eof = reader(4)
        local tagSize = bin2number(tag_end_flag)

        local tag_number = bin2number(string.sub(tagHeader, 1, 1))
        if tag_number == 18 and not is_meta then    -- script tag           
            print('tagType=scripts', tagSize, "timeStamp="..tostring(timeStamp))

        elseif tag_number == 8 and not is_audio then    -- audio tag               
            print('tagType=audio', tagSize, "timeStamp="..tostring(timeStamp))

        elseif tag_number == 9 and not is_video then   -- video tag             
            print('tagType=video', tagSize, "timeStamp="..tostring(timeStamp))

        else
            print('This may NOT be a .flv file!')
            return
        end       
    end     
end


local function parse_meta(file_path)
    local data_reader = file_data_reader(file_path)
    if data_reader == nil then
        print('file open fiald')
        return 
    end
    local data, eof = data_reader()    

    local is_video = false;    local video_data = nil
    local is_audio = false;    local audio_data = nil
    local is_meta  = false;    local meta_data  = nil

    local pos = 14  -- header end, tags start
    local tag_count = 0
    while not eof do    
        local tag_start_pos = pos
        if pos+11 > #data then
            local data_add, eof_local = data_reader() 
            if not data_add then
                break
            end
            data = data .. data_add
        end
        local tag_data_length = bin2number(string.sub(data, pos+2-1, pos+4-1))
        
        pos = pos + 11  -- tag_data start
        pos = pos + tag_data_length  -- tag_end_flag start, (tag_data end)        
        pos = pos + 4    -- tag_end_flag: 4 byte data of tag_size
        local tag_end_pos = pos-1
        tag_count = tag_count + 1
        
        while pos > #data do
            local data_add, eof_local = data_reader() 
            if not data_add then
                break
            end
            data = data .. data_add
            if eof_local then eof = true end
        end

        local tag_number = bin2number(string.sub(data, tag_start_pos, tag_start_pos))
        if tag_number == 18 and not is_meta then    -- script_tag should be the first
            is_meta = true
            meta_data = {tag_start_pos, tag_end_pos}

        elseif tag_number == 8 and not is_audio then    -- audio tag            
            is_audio = true
            local audio_type = bin2number(string.sub(data, tag_start_pos+11, tag_start_pos+11))  
            if bit.band(audio_type, 240) == 160 then   -- AAC格式: record "第一个 audio tag"
                audio_data = {tag_start_pos, tag_end_pos}         
            end

        elseif tag_number == 9 and not is_video then   -- video tag 
            is_video = true
            local video_type = bin2number(string.sub(data, tag_start_pos+11, tag_start_pos+11))         
            if bit.band(video_type, 15) == 7 then  -- AVC-H264: record "第一个 video tag"- SPS+PPS
                video_data = {tag_start_pos, tag_end_pos}                
            end

        else
            if tag_number == 8 and tag_number == 9 and tag_number == 18 then
                print('This may NOT be a .flv file!')
                return
            end
        end
        if is_meta and is_audio and is_video then
            break
        end
    end

    if meta_data then
        meta_data = string.sub(data, meta_data[1], meta_data[2])
    end
    if video_data then
        video_data = string.sub(data, video_data[1], video_data[2])
    end
    if audio_data then
        audio_data = string.sub(data, audio_data[1], audio_data[2])    
    end
    print("tag_count: ", tag_count)
    print(#(meta_data or ""), #(video_data or ""), #(audio_data or ""))

    return header, meta_data or "", video_data or "", audio_data or ""
end


local function parse_meta_demo(file_path)
    local reader = file_data_reader(file_path)  -- 闭包

    local header, eof = reader(13)
    print(#header, string.sub(header,1,3), "'" .. header .. "'")

    local is_video = false;    local video_data = nil
    local is_audio = false;    local audio_data = nil
    local is_meta  = false;    local meta_data  = nil

    local tagHeader, tagData, tag_end_flag
    while not eof do

        tagHeader, eof = reader(11)             -- read tag_header
        if not tagHeader then break end

        local tag_data_length = bin2number(string.sub(tagHeader, 2, 4))
        local timeStamp = bin2number(string.sub(tagHeader, 5, 7))

        tagData, eof = reader(tag_data_length)  -- read tag_body
        tag_end_flag, eof = reader(4)           -- read tag_end_flag
        local tagSize = bin2number(tag_end_flag)


        local tag_number = bin2number(string.sub(tagHeader, 1, 1))
        if tag_number == 18 and not is_meta then    -- script_tag should be the first
            is_meta = true
            meta_data = tagHeader .. tagData .. tag_end_flag
            print('tagType=scripts', tagSize, "timeStamp="..tostring(timeStamp))

        elseif tag_number == 8 and not is_audio then    -- audio tag            
            is_audio = true

            local audio_type = bin2number(string.sub(tagData, 1, 1))  
            if bit.band(audio_type, 240) == 160 then   -- AAC格式: want "第一个 audio tag"
                audio_data = tagHeader .. tagData .. tag_end_flag  
            else
                audio_data = ""
            end
            print('tagType=audio', tagSize, "timeStamp="..tostring(timeStamp))

        elseif tag_number == 9 and not is_video then   -- video tag 
            is_video = true

            local video_type = bin2number(string.sub(tagData, 1, 1))         
            if bit.band(video_type, 15) == 7 then  -- AVC-H264编码: want "第一个 video tag"  
                video_data = tagHeader .. tagData .. tag_end_flag  
            else
                video_data = ""
            end
            print('tagType=video', tagSize, "timeStamp="..tostring(timeStamp))

        else
            print('This may NOT be a .flv file!')
            return
        end
        if is_meta and is_audio and is_video then
            break
        end

    end
    print(#(meta_data or ""), #(video_data or ""), #(audio_data or ""))
    return header, meta_data, video_data, audio_data

end


local file_path = 'E:\\Project_test\\read_flv\\output_full.flv'
list_flv_all_tags(file_path)  -- demo 列出flv中所有的tag
print("===============================")
parse_meta_demo(file_path)   -- demo 有大量字符串切片拼接操作, 执行效率不高
print("===============================")
parse_meta(file_path)  -- 解析 flv 

