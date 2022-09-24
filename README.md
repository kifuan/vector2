# Vector2 Library for Lua

## Introduction

Ａ 2d vector library designed for `LuaJIT`, and it can be used in normal `Lua` as well.


## Usage

It pretty easy to use, as this so-called *library* only contains single file.

So you can just copy it to your project, or wherever you want.

Then, you can just use it like what it should be in any other language:

```lua
local Vector2 = require('Vector2')

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
  ```

  It can use `struct` in C, which is much more faster than `table` in Lua.

+ Both `Lua` and `LuaJIT` are supported.
  
  It just use normal tables for pure Lua:

  ```lua
  function Vector2.new(x, y)
      return setmetatable({x=x, y=y}, Vector2)
  end
  ```

## APIs

Some functions are *non-inplace*, that is, all effects will not change the vector itself.

**NOTE: YOU SHOULD use `feq(a, b)` to compare floats, as it allows tiny deviation(1e-4).**

Besides, `==` operator is overwritten for `Vector2` with deviation allowed, so you can compare two vectors with floats simply by `v1 == v2`.

## Static fields

They should be accessed via `Vector2.xxx`, such as using `Vector2.isJIT` to get `isJIT` field.

| Name                                 | Description                                  |
| ------------------------------------ | -------------------------------------------- |
| `feq(a: number, b: number): boolean` | Compares two floats with deviation allowed.  |
| `isJIT: boolean`                     | A variable representing whether JIT is used. |
| `new(x: number, y: number): Vector2` | Creates a new vector.                        |

## Non-inplace functions

They are all `instance methods`, which should be called via `v:func()`, such as using `v:len2()` to get squared length.

Tips: You can use `len2`, `dist2` when you just care about whether the value is `0` or `1`.

| Name                                                         | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `len2(): number`                                             | Gets squared length.                                         |
| `len(): number`                                              | Gets length.                                                 |
| `dist2(v: Vector2): number`                                  | Calculates the squared distance to another vector.           |
| `dist(v: Vector2): number`                                   | Calculates the distance to another vector.                   |
| `normalize(silent: boolean = true): Vector2`                 | Gets normalized vector. `silent` means whether it should throw an error when normalizing a zero-vector. |
| `scale(n: number): Vector2`                                  | Scales the vector by number.                                 |
| `dot(v: Vector2): number`                                    | Calculates the dot- or scalar-product.                       |
| `cross(v: Vector2): number`                                  | Calculates the cross- or out-product(in number).             |
| `rotate(angle: number, rad: boolean = false): Vector2`       | Gets a vector rotated with specified angle. `rad` means whether the angle is in radians. |
| `reflect(n: Vector2, normalized: boolean = false, silent: boolean = true): Vector2` | Gets a vector reflected of the given vector. `normalized` is whether the given normal vector is already normalized(it will not check), and `silent` is whether it should silent when something goes wrong. |
| `isZero(): boolean`                                          | Returns whether the vector is a zero-vector.                 |
| `isNormal(): boolean`                                        | Returns whether the vector is normal.                        |
| `clone(): Vector2`                                           | Clones the vector.                                           |
| `__add(v: Vector2): Vector2`                                 | `v1 + v2`                                                    |
| `__sub(v: Vector2): Vector2`                                 | `v1 - v2`                                                    |
| `__unm(): Vector2`                                           | `- v1`                                                       |
| `__eq(v: Vector2): boolean`                                  | `v1 == v2`                                                   |
| `__tostring(): string`                                       | `tostring(v1)`                                               |

## Inplace functions

They should be called when you just want to change the vector itself, via `v:xxx()` as well.

| Name                                                         | Description                 |
| ------------------------------------------------------------ | --------------------------- |
| `incX(n: number): Vector2`                                   | Increases x by n.           |
| `incY(n: number): Vector2`                                   | Increases y by n.           |
| `inc(x: number, y: number): Vector2`                         | Increases both x and y.     |
| `incV(v: Vector2): Vector2`                                  | Increases by given vector.  |
| `normalizeIp(silent: boolean = true): Vector2`               | Inplace `Vector:normalize`. |
| `scaleIp(n: number): Vector2`                                | Inplace `Vector:scale`      |
| `rotateIp(angle: number, rad: boolean = false): Vector2`     | Inplace `Vector:rotate`.    |
| `reflectIp(n: Vector2, normalized: boolean = false, silent: boolean = true): Vector2` | Inplace `Vector:reflect`.   |
