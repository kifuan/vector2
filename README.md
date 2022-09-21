# Vector2 Library for Lua

## Introduction

Ａ 2d vector library designed for `LuaJIT`, and it can be used in normal `Lua` as well.


## Usage

It pretty easy to use, as this so-called *library* only contains single file.

So you can just copy it to your project, or wherever you want.

Then, you can just use it like what it should be in any other language:

```lua
local Vector2 = require('vector2').Vector2

local v1 = Vector2.new(1, 2)
local v2 = Vector2.new(2, 5)

-- Vector2(3, 7)
print(v1 + v2)

-- 12
print(v1:dot(v2))
```


## Features


+ Thanks to `ffi`, it can be really fast!
  
  By simply writing few code:
  ```lua
  ffi.cdef[[
      typedef struct { double x, y; } Vector2;
  ]]
  local CVector2 = ffi.metatype('Vector2', Vector2)
  
  v2 = function(x, y)
      return CVector2(x, y)
  end
  ```

+ Both `Lua` and `LuaJIT` are supported.
  
  It just use normal tables for pure Lua:

  ```lua
  v2 = function(x, y)
      return setmetatable({x=x, y=y}, Vector2)
  end
  ```

## APIs

All functions with `Ip` suffix means that they are **inplace functions**, which are not listed here.

**NOTE THAT YOU SHOULD use `feq(a, b)` to compare floats, as it allows tiny deviation(1e-4).**

| Name                                                         | Meaning                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `feq(a: number, b: number): boolean`                         | Compares two floats with deviation allowed.                  |
| `Vector2.new(x: number, y: number): Vector2`                 | Creates new vector.                                          |
| `Vector2:len2(): number`                                     | Gets squared length.                                         |
| `Vector2:len(): number`                                      | Gets length.                                                 |
| `Vector2:dist2(v: Vector2): number`                          | Squared distance with another vector.                        |
| `Vector2:dist(v: Vector2): number`                           | Distance with another vector.                                |
| `Vector2:normalize(silent: boolean = true): Vector2`         | Gets normalized vector. `silent` means whether it should throw an error when normalizing a zero-vector. |
| `Vector2:scale(n: number): Vector2`                          | Scales the vector by number.                                 |
| `Vector2:dot(v: Vector2): number`                            | Calculates the dot- or scalar-product.                       |
| `Vector2:cross(v: Vector2): number`                          | Calculates the cross- or out-product(in number).             |
| `Vector2:rotate(angle: number, rad: boolean = false): Vector2` | Gets a vector rotated with specified angle. `rad` means whether the angle is in radians. |
| `Vector2:reflect(n: Vector2, silent: boolean = true): Vector2` | Gets a vector reflected of the given vector. `silent` is the same as the parameter  `Vector2:normalize` takes. |
| `Vector2:isZero(): boolean`                                  | Returns whether the vector is a zero-vector.                 |
| `Vector2:isNormal(): boolean`                                | Returns whether the vector is normal.                        |
| `Vector2:clone(): Vector2`                                   | Clones the vector.                                           |
| `Vector2:incX(n: number): Vector2`                           | Increases x by n.                                            |
| `Vector2:incY(n: number): Vector2`                           | Increases y by n.                                            |
| `Vector2:inc(x: number, y: number): Vector2`                 | Increases both x and y.                                      |
| `Vector2:incV(v: Vector2): Vector2`                          | Increases by given vector.                                   |
| `Vector2:__sub(v: Vector2): Vector2`                         | v1 - v2                                                      |
| `Vector2:__unm(): Vector2`                                   | -v1                                                          |
| `Vector2:__eq(v: Vector2): boolean`                          | v1 == v2                                                     |
| `Vector2:__tostring(): string`                               | tostring(v1)                                                 |

Tips: You can use `len2`, `dist2` when you just care about whether the value is `0` or `1`.
