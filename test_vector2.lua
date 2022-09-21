local v = require('vector2')
local Vector2 = v.Vector2

local a = Vector2.new(3, 4)
local b = Vector2.new(7, 7)
local zero = Vector2.new(0, 0)

assert(a:len2() == 25)
assert(a:len() == 5)

assert(a:dist2(b) == 25)
assert(a:dist(b) == 5)

local a1 = a:clone()

-- Non-inplace normalize method.
a1:normalize(false)
assert(a == a1)

-- Inplace normalize method.
a1:normalize()
assert(a ~= a1)

-- Try to normlaize a zero vector.
local ok = pcall(zero.normalize, zero, true, false)
assert(not ok)

-- Scale the vector.
assert(a:scale(2, false) == Vector2.new(6, 8))

-- Dot- and cross- product.
assert(a:dot(b) == 21+28)
assert(a:cross(b) == 21-28)

-- Rotate the vector.
assert(a:rotate(90, false, false) == Vector2.new(-4, 3))


-- Addition and subtraction.
assert(a + b == Vector2.new(10, 11))
assert(a - b == Vector2.new(-4, -3))
