--[[
MIT License

Copyright (c) 2022 Kifuan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

---@class Vector2
---@field x number
---@field y number
local Vector2 = {}

local hasffi, ffi = pcall(require, 'ffi')

---The function to construct vector2 whose
---behavior depends on whether it has ffi library.
---@type fun(x: number, y: number): Vector2
local v2


if not hasffi then
    ffi.cdef[[
        typedef struct { double x, y; } Vector2;
    ]]
    local CVector2 = ffi.metatype('Vector2', Vector2)


    v2 = function(x, y)
        return CVector2(x, y)
    end
else
    v2 = function(x, y)
        return setmetatable({x=x, y=y}, Vector2)
    end
end


Vector2.__index = Vector2
Vector2.new = v2


---Gets the squared length of the vector.
---@return number
function Vector2:len2()
    local x, y = self.x, self.y
    return x*x + y*y
end


---Gets the length of the vector.
---@return number
function Vector2:len()
    return math.sqrt(self:len2())
end


---Gets normalized vector.
---@param inplace? boolean whether this operation is inplace, default by true.
---@param err? boolean whether this function could throw an error.
---@return Vector2
function Vector2:normalize(inplace, err)
    local len = self:len()
    if len == 0 then
        if err then
            error('Cannot normalize zero-vector.')
        end
        return self
    end
    return self:scale(1 / len, inplace)
end


---Scales the vector.
---@param n number
---@param inplace? boolean whether this operation is inplace, default by true.
---@return Vector2
function Vector2:scale(n, inplace)
    if inplace == nil then
        inplace = true
    end

    if not inplace then
        self = Vector2.new(0, 0)
    end

    self.x = n * self.x
    self.y = n * self.y
    return self
end


---Gets the dot product.
---@param v Vector2
---@return number
function Vector2:dot(v)
    return self.x*v.x + self.y*v.y
end


---Adds the vector with another one.
---@param v Vector2
---@return Vector2
function Vector2:__add(v)
    return Vector2.new(self.x+v.x, self.y+v.y)
end


---Subtracts the vector with another one.
---@param v Vector2
---@return Vector2
function Vector2:__sub(v)
    return Vector2.new(self.x-v.x, self.y-v.y)
end


---Shows the vector in string.
---@return string
function Vector2:__tostring()
    return 'Vector2(' .. self.x .. ', ' .. self.y .. ')'
end


return {
    Vector2 = Vector2
}
