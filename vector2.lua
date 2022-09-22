--[[
https://github.com/kifuan/vector2

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


---Allowed deviation for floats.
local ALLOWED_DEVIATION = 1e-4


---Returns whether the floats are equal.
---@param a number
---@param b number
---@return boolean
local function feq(a, b)
    return math.abs(a-b) < ALLOWED_DEVIATION
end


Vector2.__index = Vector2
Vector2.new = v2


---Gets the squared length of the vector.
---@return number
function Vector2:len2()
    return self.x^2 + self.y^2
end


---Gets the length of the vector.
---@return number
function Vector2:len()
    return math.sqrt(self:len2())
end


---Calculates the squared distance to another vector.
---@param v Vector2
---@return number
function Vector2:dist2(v)
    local dx = v.x - self.x
    local dy = v.y - self.y
    return dx^2 + dy^2
end


---Calculates the distance to another vector.
---@param v Vector2
---@return number
function Vector2:dist(v)
    return math.sqrt(self:dist2(v))
end


---Gets normalized vector inplace.
---@param silent? boolean whether this function should be silent when it is zero-vector, default by true.
---@return Vector2
function Vector2:normalizeIp(silent)
    if silent == nil then
        silent = true
    end

    if self:isZero() then
        if not silent then
            error('Cannot normalize zero vector.')
        end
        return self
    end
    return self:scaleIp(1/self:len())
end


---Gets normalized vector.
---@param silent? boolean whether this function should be silent when it is zero-vector, default by true.
---@return Vector2
function Vector2:normalize(silent)
    return self:clone():normalizeIp(silent)
end


---Scales the vector by number inplace.
---@param n number
---@return Vector2
function Vector2:scaleIp(n)
    self.x = n * self.x
    self.y = n * self.y
    return self
end


---Scales the vector by number.
---@param n number
---@return Vector2
function Vector2:scale(n)
    return self:clone():scaleIp(n)
end


---Calcuates the dot- or scalar-product.
---@param v Vector2
---@return number
function Vector2:dot(v)
    return self.x*v.x + self.y*v.y
end


---Calcuates the cross- or out-product.
---It should be a vector3 like (0, 0, z), this function
---only returns the Z coordinate.
---@param v Vector2
---@return number
function Vector2:cross(v)
    return self.x*v.y - self.y*v.x
end


---Rotates the vector with specified angle inplace.
---@param angle number the angle to rotate.
---@param rad? boolean whether the angle is in radians, default by false.
---@return Vector2
function Vector2:rotateIp(angle, rad)
    if not rad then
        angle = math.rad(angle)
    end

    local cos, sin = math.cos(angle), math.sin(angle)
    local x, y = self.x, self.y

    self.x = x*cos - y*sin
    self.y = x*sin + y*cos

    return self
end


---Gets a vector rotated with specified angle.
---@param angle number the angle to rotate.
---@param rad? boolean whether the angle is in radians, default by false.
---@return Vector2
function Vector2:rotate(angle, rad)
    return self:clone():rotateIp(angle, rad)
end


---Gets a vector reflected of a given vector inplace.
---@param n Vector2
---@param normalized? boolean whether the vector has been normalized, default by false.
---@param silent? boolean whether it should be silent when something goes wrong, default by true.
---@return Vector2 itself.
function Vector2:reflectIp(n, normalized, silent)
    if silent == nil then
        silent = true
    end

    if normalized == nil then
        normalized = false
    end

    if not normalized then
        n = n:normalize(silent)
    end
    if not silent and n:isZero() then
        error('Normal must not be zero-vector.')
    end
    -- If the normal vector is indeed zero-vector, then
    -- self won't change because it just means
    -- that the increment vector will be zero-vector.
    return self:incV(n:scale(-2*self:dot(n)))
end


---Gets a vector reflected of a given vector.
---@param n Vector2
---@param normalized? boolean whether the vector has been normalized, default by false.
---@param silent? boolean whether it should be silent when something goes wrong, default by true.
---@return Vector2
function Vector2:reflect(n, normalized, silent)
    return self:clone():reflectIp(n, normalized, silent)
end


---Returns whetehr the vector is a zero-vector.
---@return boolean
function Vector2:isZero()
    return feq(self.x, 0) and feq(self.y, 0)
end


---Returns whether the vector is normal.
function Vector2:isNormal()
    -- As we only care about if it is 1, using squared length is suitable.
    return feq(self:len2(), 1)
end


---Increases x.
---@param n number
---@return Vector2 itself.
function Vector2:incX(n)
    self.x = self.x + n
    return self
end


---Increases y.
---@param n number
---@return Vector2 itself.
function Vector2:incY(n)
    self.y = self.y + n
    return self
end


---Incrases with another vector.
---@param v Vector2
---@return Vector2 itself.
function Vector2:incV(v)
    return self:inc(v.x, v.y)
end


---Increases both x and y.
---@param x number
---@param y number
---@return Vector2 itself.
function Vector2:inc(x, y)
    self.x = self.x + x
    self.y = self.y + y
    return self
end


---Clones the vector.
---@return Vector2
function Vector2:clone()
    return Vector2.new(self.x, self.y)
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


---Gets the vector in opposite direction.
---@return Vector2
function Vector2:__unm()
    return self:scale(-1)
end


---Shows the vector in string.
---@return string
function Vector2:__tostring()
    return 'Vector2(' .. self.x .. ', ' .. self.y .. ')'
end


---Compares the vector with another one.
---@return boolean
function Vector2:__eq(v)
    return feq(self.x, v.x) and feq(self.y, v.y)
end


return {
    Vector2 = Vector2,
    feq = feq
}
