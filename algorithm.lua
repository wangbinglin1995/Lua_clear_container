

-- random shuffle 
local function shuffle_array(a)
    if not a or #a<1 then
        return nil
    end

    math.randomseed(tostring(os.time()):reverse():sub(1,6))
    for i = n, 1, -1 do
        local j = math.random(i)
        a[i], a[j] = a[j], a[i]        

    end
    return 1
end




local function shuffle_n(n)
    if not n or n<1 then
        return nil
    end

    local a = {}
    for i = 1, n do
        table.insert(a, i)
    end

    shuffle_array(a)
    return a
end




