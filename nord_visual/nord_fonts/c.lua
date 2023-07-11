local fonts = {}

function getFont(path, size)
    local font = fileExists("files/"..path)
    if not font then return end 

    if not fonts[path] then 
        fonts[path] = {}
    end 

    if not fonts[path][size] then 
        fonts[path][size] = dxCreateFont("files/"..path, size)
    end

    return (fonts[path][size] or false)
end