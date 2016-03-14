
local _M = {
    _VERSION = '0.06',
}

local mt = { __index = _M }


function _M.new(self)
    return setmetatable({ }, mt)
end


function _M.eval(self, expr)
   local f = load('return ' .. expr)
   return f()
end

return _M

