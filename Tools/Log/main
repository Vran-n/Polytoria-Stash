-- Made for Polytoria 1.x
-- by Vran
-- https://polytoria.com/u/Vran

----- Log v1.0
-- A simple utility script for better outputs. Supports tables


local function tostring_tbl (table_s)
    if type(table_s) ~= "table" then return print('<b><color=orange>[WARN]: '.. tostring(table_s)..' is a '..type(table_s)..', NOT a table' ..'</color></b>') end
    
    local function converter(table_t, indent)
        local str = ''
        local indent = indent or 5
        local Array = {}

        for i, v in next, table_t do
            table.insert(Array, {[i] = v})
        end

        for i, tbl in next, Array do
            for i_name, v in next, tbl do
                if type(v) == "table" then
                    str = i ~= #Array 
                        and string.format(
                            '%s\n%s[%s] = {%s\n%s},', 
                            str, 
                            string.rep(" ", indent), 
                            type(i_name) == "string" and string.format('"%s"', i_name) or tostring(i_name), 
                            converter(v, indent + 5),
                            string.rep(" ", indent)
                        )
                        or string.format(
                            '%s\n%s[%s] = {%s\n%s}', 
                            str, 
                            string.rep(" ", indent), 
                            type(i_name) == "string" and string.format('"%s"', i_name) or tostring(i_name),
                            converter(v, indent + 5),
                            string.rep(" ", indent)
                        )
                else
                    str = i ~= #Array
                        and string.format('%s\n%s[%s] = %s,', str, string.rep(" ", indent), 
                            type(i_name) == "string" and string.format('"%s"', i_name) or tostring(i_name),
                            type(v) == "string" and string.format('"%s"', v) or tostring(v))
                        or string.format('%s\n%s[%s] = %s', str, string.rep(" ", indent), 
                            type(i_name) == "string" and string.format('"%s"', i_name) or tostring(i_name),
                            type(v) == "string" and string.format('"%s"', v) or tostring(v))
                end
            end
        end

        return str
    end

    local result = converter(table_s)
    return result ~= "" and "{"..converter(table_s).."\n}" or "{}"
end


local log = {}

function log.warn(...)
    local arg = {...}
    for i, k in ipairs(arg) do
        arg[i] = type(k)=='string' and k or type(k)=='table' and tostring_tbl(k) or tostring(k)
        arg[i] = i == 1 and '<b><color=orange>[WARN]: '.. arg[i] ..'</color></b>' or '<b><color=orange>'.. arg[i] ..'</color></b>'
    end
    print(table.unpack(arg))
end

-- A severe warning
function log.crit(...)
    local arg = {...}
    for i, k in ipairs(arg) do
        arg[i] = type(k)=='string' and k or type(k)=='table' and tostring_tbl(k) or tostring(k)
        arg[i] = i == 1 and '<b><color=red>[CRITICAL]: '.. arg[i] ..'</color></b>' or '<b><color=red>'.. arg[i] ..'</color></b>'
    end
    print(table.unpack(arg))
end

function log.important(...)
    local arg = {...}
    for i, k in ipairs(arg) do
        arg[i] = type(k)=='string' and k or type(k)=='table' and tostring_tbl(k) or tostring(k)
        arg[i] = i == 1 and '<b><color=green>[IMPORTANT]: '.. arg[i] ..'</color></b>' or '<b><color=green>'.. arg[i] ..'</color></b>'
    end
    print(table.unpack(arg))
end

function log.yellow(...)
    local arg = {...}
    for i, k in ipairs(arg) do
        arg[i] = type(k)=='string' and k or type(k)=='table' and tostring_tbl(k) or tostring(k)
        arg[i] = '<b><color=yellow>'.. arg[i] ..'</color></b>'
    end
    print(table.unpack(arg))
end

-- Normal print, but with table support
function log.info(...)
    local arg = {...}
    for i, k in ipairs(arg) do
        arg[i] = type(k)=='string' and k or type(k)=='table' and tostring_tbl(k) or tostring(k)
    end
    print(table.unpack(arg))
end

return log
