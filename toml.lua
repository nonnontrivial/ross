local Toml = {}

function Toml:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

function Toml:parseKV(line)
    local k, v = line:match("([^=]+)=([^#]+)")
    if k and v then
        k = trim(k)
        v = trim(v)
        if v:match('^"') then
            v = v:sub(2, -2)
        elseif v == "true" then
            v = true
        elseif v == "false" then
            v = false
        elseif tonumber(v) then
            v = tonumber(v)
        end
        return k, v
    end
    return nil
end

-- TODO full toml support https://toml.io/en/v1.0.0
function Toml:parse(filepath)
    local file = io.open(filepath, "r")
    if not file then
        error("could not read file")
    end
    local toml = {}
    local section = nil
    for line in file:lines() do
        line = trim(line:match("^[^#]*"))
        if line == "" then
            goto continue
        end
        local sectionName = line:match("^%[([%w_]+)%]$")
        if sectionName then
            section = sectionName
            toml[section] = toml[section] or {}
        else
            local k, v = self:parseKV(line)
            if k and v then
                if section then
                    toml[section][k] = v
                else
                    toml[k] = v
                end
            end
        end
        ::continue::
    end
    file:close()
    return toml
end

return Toml
