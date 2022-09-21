# Vector2 Library for Lua

## Introduction

Ａ 2d vector library designed for `LuaJIT`, and it can be used in normal `Lua` as well.

**NOTE: it is still developing. Breaking changes may happen.**

**Please do not use it in production environment for now.**


## Usage

It pretty easy to use, as this so-called *library* only contains single file.

So you can just copy it to your project, or wherever you want.

Then, you can just use it like what it should be in any other language:

```lua
local vector = require('vector')

local v1 = vector.Vector2.new(1, 2)
local v2 = vector.Vector2.new(2, 5)

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

