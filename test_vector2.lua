local Vector2 = require('Vector2')

local tests = {}


local function assertFeq(f1, f2)
    assert(Vector2.feq(f1, f2), string.format('%g != %g', f1, f2))
end


---@param a Vector2
---@param b Vector2
function tests.lenDist(a, b)
    local len2 = a.x^2+a.y^2
    local dist2 = (a.x-b.x)^2+(a.y-b.y)^2
    assertFeq(a:len2(), len2)
    assertFeq(a:len(), math.sqrt(len2))
    assertFeq(a:dist2(b), dist2)
    assertFeq(a:dist(b), math.sqrt(dist2))
end


---@param a Vector2
---@param b Vector2
function tests.normalize(a, b)
    local normalizedV1 = a:normalize()
    assert(normalizedV1:isNormal())
    assert(Vector2.new(1, 0):isNormal())
    -- Non-inplace function.
    assert(a ~= normalizedV1)

    -- Inplace function.
    b:normalizeIp()
    assert(b:isNormal())

    -- Cannot normalize zero-vector.
    local zero = Vector2.new(0, 0)
    local ok = pcall(zero.normalize, zero, false)
    assert(not ok)
end


---@param a Vector2
---@param b Vector2
function tests.scale(a, b)
    local scaled = a:scale(2)
    assert(scaled == Vector2.new(a.x*2, a.y*2))

    local b1 = b:clone()
    b:scaleIp(2)
    assert(b1 ~= b)
end


---@param a Vector2
---@param b Vector2
function tests.dotCross(a, b)
    assertFeq(a:dot(b), a.x*b.x+a.y*b.y)
    local cosAngle = a:dot(b)/a:len()/b:len()
    local sinAngle = math.sqrt(1 - cosAngle^2)
    assertFeq(math.abs(a:cross(b)), a:len() * b:len() * sinAngle)
end


---@param a Vector2
---@param b Vector2
function tests.rotate(a, b)
    assert(a:rotate(90) == a:rotate(math.pi / 2, true))

    local b1 = b:clone()
    b:rotateIp(90)
    assertFeq(b1:dot(b), 0)
end


---@param a Vector2
---@param b Vector2
function tests.operators(a, b)
    assert(a+b == Vector2.new(a.x+b.x, a.y+b.y))
    assert(a-b == Vector2.new(a.x-b.x, a.y-b.y))
    assert(-a == Vector2.new(-a.x, -a.y))
end


---@param a Vector2
---@param b Vector2
function tests.reflect(a, b)
    local r = a:reflect(Vector2.new(0, 1))
    assert(r == Vector2.new(a.x, -a.y))

    local ok1 = pcall(b.reflect, b, Vector2.new(0, 0), true, false)
    assert(not ok1)

    local ok2 = pcall(b.reflect, b, Vector2.new(0, 0), false, false)
    assert(not ok2)

    local b1 = b:clone()
    b:reflectIp(Vector2.new(0, 1))
    assert(b == Vector2.new(b1.x, -b1.y))
end


function tests.checkJIT()
    local jit = pcall(require, 'jit')
    assert(jit == Vector2.isJIT)
end


local function run()
    local function genVec()
        local x, y = 0, 0
        -- It mustn't be a zero-vector.
        while x == 0 or y == 0 do
            x = math.random(-100, 100)
            y = math.random(-100, 100)
        end
        return Vector2.new(x, y)
    end
    for name, func in pairs(tests) do
        print('Testing ' .. name)
        func(genVec(), genVec())
    end
end


run()
