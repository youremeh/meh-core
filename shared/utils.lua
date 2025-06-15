-- Initialize character sets once
local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end    -- '0'-'9'
for i = 65, 90 do table.insert(Charset, string.char(i)) end           -- 'A'-'Z'
for i = 97, 122 do table.insert(Charset, string.char(i)) end          -- 'a'-'z'

-- Seed random once at resource start
math.randomseed(GetGameTimer())

-- Generate random numeric string of given length
local function GRN(length)
    local result = {}
    for _ = 1, length do
        table.insert(result, NumberCharset[math.random(#NumberCharset)])
    end
    return table.concat(result)
end
exports('GRN', GRN)

-- Generate random alphabetic string of given length (upper and lower case)
local function GRL(length)
    local result = {}
    for _ = 1, length do
        table.insert(result, Charset[math.random(#Charset)])
    end
    return table.concat(result)
end
exports('GRL', GRL)

-- Generate plate: 2 numbers + 3 letters (uppercase) + 3 numbers
local function GenPlate()
    return GRN(2) .. string.upper(GRL(3)) .. GRN(3)
end
exports('GenPlate', GenPlate)
