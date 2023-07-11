function getPlayerSID(player)
    return getElementData(player, "player:id") or 0
end

function readFile(path)
    local file = fileOpen(path)
    if not file then
        return false
    end
    local count = fileGetSize(file)
    local data = fileRead(file, count) 
    fileClose(file) 
    return data
end

function formatNumber(number, separator)
    if not number or not tonumber(number) then return false end
    local separator = (separator or ",")
    local money = number
    for i = 1, string.len(tostring(money))/3 do
        money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..separator.."%2")
    end
    return money
end

