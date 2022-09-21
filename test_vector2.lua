local v = require('vector2')
local Vector2 = v.Vector2
local feq = v.feq

local a = Vector2.new(3, 4)
local b = Vector2.new(7, 7)
local zero = Vector2.new(0, 0)

assert(feq(a:len2(), 25))
assert(feq(a:len(), 5))


assert(feq(a:dist2(b), 25))
assert(feq(a:dist(b), 5))

local a1 = a:clone()

-- Inplace normalize method.
a1:normalizeInplace()
assert(a ~= a1)

-- Try to normlaize a zero vector.
local ok = pcall(zero.normalize, zero, false)
assert(not ok)

-- Scale the vector.
assert(a:scale(2) == Vector2.new(6, 8))

-- Dot- and cross- product.
assert(feq(a:dot(b), 21+28))
assert(feq(a:cross(b), 21-28))

-- Rotate the vector.
assert(a:rotate(90) == Vector2.new(-4, 3))


-- Addition and subtraction.
assert(a + b == Vector2.new(10, 11))
assert(a - b == Vector2.new(-4, -3))
