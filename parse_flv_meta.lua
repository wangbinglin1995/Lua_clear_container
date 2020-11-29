bit  = require "bit"


local function Reader(data)
    local pos = 1
    return function(n)
        if pos >= #data then
            return "", true
        elseif n + pos >= #data then             
            return string.sub(data, pos, #data), true
        end
        local res = string.sub(data, pos, pos+n-1)
        pos = pos + n
        return res, false
    end
end

local function Reader_bias(data)
    local pos = 1
    return function(n)
        if pos >= #data then            
            return 0, 0, true
        elseif n + pos >= #data then             
            return pos, #data, true            
        end
        local old_pos = pos
        pos = pos + n 
        return old_pos, pos-1, false
    end
end

local function bin2number(str)
    local res = 0
    for i = 1, #str do
        res = res * 256 + tonumber(string.byte(string.sub(str, i, i)))
    end
    return res
end

    
local function get_data()
    -- local file = io.open('E:\\Project_test\\read_flv\\output_full.flv', "rb")
    local file = io.open('D:\\tt.flv', "rb")
    if not file then        
        return nil
    end
    local data = file:read("*a")
    file:close()
    return data
end


local function list_flv_all_tags()
    print('=========== list_flv_all_tags =================')
    local data = get_data()
    print("ALL data size: " .. (#data))

    local reader = Reader(data)
    local header, eof = reader(13)

    while true do
        if eof then  break  end

        local tagHeader, eof = reader(11)
        local tag_data_length = bin2number(string.sub(tagHeader, 2, 4))
        local timeStamp = bin2number(string.sub(tagHeader, 5, 7))

        local tagData, eof = reader(tag_data_length)
        local tag_end_flag, eof = reader(4)
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


local function parse_meta_bias()
    local data = get_data()
    if data == nil then
        print('file open fiald')
        return 
    end
    print("ALL data size: " .. (#data))

    local reader = Reader_bias(data)  -- 闭包

    local pos = 1
    -- local header = string.sub(data, pos, pos+12)
    -- print(#header, string.sub(header,1, 3), "'" .. header .. "'")
    pos = pos + 13   -- header end, tags start

    local is_video = false;    local video_data = nil
    local is_audio = false;    local audio_data = nil
    local is_meta  = false;    local meta_data  = nil

    while true do
        if eof then  break  end

        local tag_start_pos = pos
        local tag_data_length = bin2number(string.sub(data, pos+2-1, pos+4-1))
        -- local timeStamp = bin2number(string.sub(data, pos+5-1, pos+7-1))
        -- local tagData = string.sub(data, tag_start_pos+11+1, tag_start_pos+11+tag_data_length)
        pos = pos + 11  -- tag_data start
        pos = pos + tag_data_length  -- tag_end_flag start, (tag_data end)

        -- local tag_end_flag = string.sub(data, pos, pos+4-1)
        -- local tagSize = bin2number(tag_end_flag)
        pos = pos + 4
        local tag_end_pos = pos-1

        local tag_number = bin2number(string.sub(data, tag_start_pos, tag_start_pos))
        if tag_number == 18 and not is_meta then    -- script_tag should be the first
            is_meta = true
            meta_data = {tag_start_pos, tag_end_pos}

        elseif tag_number == 8 and not is_audio then    -- audio tag            
            is_audio = true

            local audio_type = bin2number(string.sub(data, tag_start_pos+11, tag_start_pos+11))  
            if bit.band(audio_type, 240) == 160 then   -- AAC格式: want "第一个 audio tag"
                audio_data = {tag_start_pos, tag_end_pos}         
            end

        elseif tag_number == 9 and not is_video then   -- video tag 
            is_video = true

            local video_type = bin2number(string.sub(data, tag_start_pos+11, tag_start_pos+11))         
            if bit.band(video_type, 15) == 7 then  -- AVC-H264编码 SPS +PPS: want "第一个 video tag"  
                video_data = {tag_start_pos, tag_end_pos}                
            end

        else
            print('This may NOT be a .flv file!')
            return
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
    print(#meta_data, #video_data, #audio_data)    

    return header, meta_data or "", video_data or "", audio_data or ""
end


local function parse_meta()
    local data = get_data()
    print("ALL data size: " .. (#data))

    local reader = Reader(data)  -- 闭包

    local header, eof = reader(13)
    print(#header, string.sub(header,1,3), "'" .. header .. "'")

    local is_video = false;    local video_data = nil
    local is_audio = false;    local audio_data = nil
    local is_meta  = false;    local meta_data  = nil

    local tag_pos = {0, 0,  0, 0,  0, 0}
    while true do
        if eof then  break  end

        local tagHeader, eof = reader(11)             -- read tag_header
        local tag_data_length = bin2number(string.sub(tagHeader, 2, 4))
        local timeStamp = bin2number(string.sub(tagHeader, 5, 7))

        local tagData, eof = reader(tag_data_length)  -- read tag_body
        local tag_end_flag, eof = reader(4)           -- read tag_end_flag
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
    print(#meta_data, #video_data, #audio_data)
    return header, meta_data, video_data, audio_data

end


parse_meta_bias()
-- parse_meta()
-- list_flv_all_tags()

