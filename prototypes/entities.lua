local straightrail = table.deepcopy(data.raw["straight-rail"]["straight-rail"])
local curvedraila = table.deepcopy(data.raw["curved-rail-a"]["curved-rail-a"])
local curvedrailb = table.deepcopy(data.raw["curved-rail-b"]["curved-rail-b"])
local halfdiagonalrail = table.deepcopy(data.raw["half-diagonal-rail"]["half-diagonal-rail"])

local function replace_strings(t, pattern, replacement)
  for k, v in pairs(t) do
    if type(v) == "string" then
      t[k] = v:gsub(pattern, replacement)  -- Replace the pattern
    elseif type(v) == "table" then
      replace_strings(v, pattern, replacement)  -- Recursively handle nested tables
    end
  end
end

straightrail.name = "straight-rail-minimal"
straightrail.placeable_by = {item = "rail-minimal", count = 1}
straightrail.minable = {mining_time = 0.2, result = "rail-minimal", count = 1}
straightrail.icon = "__minimalist-rails__/graphics/icons/rail-minimal.png"

curvedraila.name = "curved-rail-a-minimal"
curvedraila.placeable_by = {item = "rail-minimal", count = 3}
curvedraila.deconstruction_alternative = "straight-rail-minimal"
curvedraila.minable = {mining_time = 0.2, result = "rail-minimal", count = 3}
curvedraila.icon = "__minimalist-rails__/graphics/icons/rail-minimal-curved.png"

curvedrailb.name = "curved-rail-b-minimal"
curvedrailb.placeable_by = {item = "rail-minimal", count = 3}
curvedrailb.deconstruction_alternative = "straight-rail-minimal"
curvedrailb.minable = {mining_time = 0.2, result = "rail-minimal", count = 3}
curvedrailb.icon = "__minimalist-rails__/graphics/icons/rail-minimal-curved.png"

halfdiagonalrail.name = "half-diagonal-rail-minimal"
halfdiagonalrail.placeable_by = {item = "rail-minimal", count = 2}
halfdiagonalrail.deconstruction_alternative = "straight-rail-minimal"
halfdiagonalrail.minable = {mining_time = 0.2, result = "rail-minimal", count = 2}
halfdiagonalrail.icon = "__minimalist-rails__/graphics/icons/rail-minimal-diagonal.png"


replace_strings(straightrail.pictures, "__base__", "__minimalist-rails__")
replace_strings(curvedraila.pictures, "__base__", "__minimalist-rails__")
replace_strings(curvedrailb.pictures, "__base__", "__minimalist-rails__")
replace_strings(halfdiagonalrail.pictures, "__base__", "__minimalist-rails__")


--[[
log(serpent.block("____________straightrail"))
log(serpent.block(straightrail))
log(serpent.block("____________curvedraila"))
log(serpent.block(curvedraila.pictures))
log(serpent.block("____________curvedrailb"))
log(serpent.block(curvedrailb.pictures))
log(serpent.block("____________halfdiagonalrail"))
log(serpent.block(halfdiagonalrail.pictures))
]]
data:extend({straightrail, curvedraila, curvedrailb, halfdiagonalrail})

data.raw["curved-rail-b"]["curved-rail-b-minimal"].max_health = 3000
data.raw["curved-rail-a"]["curved-rail-a-minimal"].max_health = 3000
data.raw["half-diagonal-rail"]["half-diagonal-rail-minimal"].max_health = 2000
data.raw["straight-rail"]["straight-rail-minimal"].max_health = 1000

data.raw["curved-rail-b"]["curved-rail-b-minimal"].fast_replaceable_group = "curved-rail-b"
data.raw["curved-rail-a"]["curved-rail-a-minimal"].fast_replaceable_group = "curved-rail-a"
data.raw["half-diagonal-rail"]["half-diagonal-rail-minimal"].fast_replaceable_group = "half-diagonal-rail"
data.raw["straight-rail"]["straight-rail-minimal"].fast_replaceable_group = "straight-rail"

data.raw["curved-rail-b"]["curved-rail-b-minimal"].minable.mining_time = 3
data.raw["curved-rail-a"]["curved-rail-a-minimal"].minable.mining_time = 3
data.raw["half-diagonal-rail"]["half-diagonal-rail-minimal"].minable.mining_time = 2
data.raw["straight-rail"]["straight-rail-minimal"].minable.mining_time = 1

data.raw["curved-rail-b"]["curved-rail-b"].fast_replaceable_group = "curved-rail-b"
data.raw["curved-rail-a"]["curved-rail-a"].fast_replaceable_group = "curved-rail-a"
data.raw["half-diagonal-rail"]["half-diagonal-rail"].fast_replaceable_group = "half-diagonal-rail"
data.raw["straight-rail"]["straight-rail"].fast_replaceable_group = "straight-rail"

data.raw["curved-rail-b"]["curved-rail-b"].next_upgrade = "curved-rail-b-minimal"
data.raw["curved-rail-a"]["curved-rail-a"].next_upgrade = "curved-rail-a-minimal"
data.raw["half-diagonal-rail"]["half-diagonal-rail"].next_upgrade = "half-diagonal-rail-minimal"
data.raw["straight-rail"]["straight-rail"].next_upgrade = "straight-rail-minimal"

if mods["elevated-rails"] then
  local elevated_railramp = table.deepcopy(data.raw["rail-ramp"]["rail-ramp"])
  local elevated_straightrail = table.deepcopy(data.raw["elevated-straight-rail"]["elevated-straight-rail"])
  local elevated_curvedraila = table.deepcopy(data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"])
  local elevated_curvedrailb = table.deepcopy(data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"])
  local elevated_halfdiagonalrail = table.deepcopy(data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"])

  elevated_railramp.name = "rail-ramp-minimal"
  --elevated_railramp.placeable_by = {item = "rail-minimal", count = 1}
  elevated_railramp.minable = {mining_time = 0.2, result = "rail-ramp-minimal", count = 1}
  elevated_railramp.icon = "__minimalist-rails__/graphics/icons/rail-ramp-minimal.png"
  elevated_railramp.subgroup = "train-transport"
  elevated_railramp.order = "a[rail]-b2[rail-minimal]"

  elevated_straightrail.name = "elevated-straight-rail-minimal"
  elevated_straightrail.placeable_by = {item = "rail-minimal", count = 1}
  elevated_straightrail.minable = {mining_time = 0.2, result = "rail-minimal", count = 1}
  elevated_straightrail.icon = "__minimalist-rails__/graphics/icons/elevated-rail-minimal.png"

  elevated_curvedraila.name = "elevated-curved-rail-a-minimal"
  elevated_curvedraila.placeable_by = {item = "rail-minimal", count = 3}
  elevated_curvedraila.deconstruction_alternative = "elevated-straight-rail-minimal"
  elevated_curvedraila.minable = {mining_time = 0.2, result = "rail-minimal", count = 3}
  elevated_curvedraila.icon = "__minimalist-rails__/graphics/icons/elevated-rail-minimal-curved.png"

  elevated_curvedrailb.name = "elevated-curved-rail-b-minimal"
  elevated_curvedrailb.placeable_by = {item = "rail-minimal", count = 3}
  elevated_curvedrailb.deconstruction_alternative = "elevated-straight-rail-minimal"
  elevated_curvedrailb.minable = {mining_time = 0.2, result = "rail-minimal", count = 3}
  elevated_curvedrailb.icon = "__minimalist-rails__/graphics/icons/elevated-rail-minimal-curved.png"

  elevated_halfdiagonalrail.name = "elevated-half-diagonal-rail-minimal"
  elevated_halfdiagonalrail.placeable_by = {item = "rail-minimal", count = 2}
  elevated_halfdiagonalrail.deconstruction_alternative = "elevated-straight-rail-minimal"
  elevated_halfdiagonalrail.minable = {mining_time = 0.2, result = "rail-minimal", count = 2}
  elevated_halfdiagonalrail.icon = "__minimalist-rails__/graphics/icons/elevated-rail-minimal-diagonal.png"

  local replaced_images = {
    "elevated-rail/elevated-rail-backplates.png",
    "elevated-rail/elevated-rail-base.png",
    "elevated-rail/elevated-rail-base-shadow.png",
    "elevated-rail/elevated-rail-base-top.png",
    "elevated-rail-ramp/elevated-rail-ramp.png",
    "elevated-rail-ramp/elevated-rail-ramp-shadow.png",
  }

  local function escape_lua_pattern(s)
    return s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  end

  for _, replaced_image in pairs(replaced_images) do
    local pattern = escape_lua_pattern("__elevated-rails__/graphics/entity/" .. replaced_image)
    local replacement = "__minimalist-rails__/graphics/entity/" .. replaced_image
    replace_strings(elevated_railramp.pictures, pattern, replacement)
    replace_strings(elevated_straightrail.pictures, pattern, replacement)
    replace_strings(elevated_curvedraila.pictures, pattern, replacement)
    replace_strings(elevated_curvedrailb.pictures, pattern, replacement)
    replace_strings(elevated_halfdiagonalrail.pictures, pattern, replacement)
  end

  --log(serpent.block(elevated_halfdiagonalrail.pictures))
  data:extend({elevated_railramp, elevated_straightrail, elevated_curvedraila, elevated_curvedrailb, elevated_halfdiagonalrail})

  data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b-minimal"].max_health = 3000
  data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a-minimal"].max_health = 3000
  data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail-minimal"].max_health = 2000
  data.raw["elevated-straight-rail"]["elevated-straight-rail-minimal"].max_health = 1000

  data.raw["rail-ramp"]["rail-ramp"].fast_replaceable_group = "rail-ramp"
  data.raw["rail-ramp"]["rail-ramp-minimal"].fast_replaceable_group = "rail-ramp"
  data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].fast_replaceable_group = "elevated-curved-rail-b"
  data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b-minimal"].fast_replaceable_group = "elevated-curved-rail-b"
  data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].fast_replaceable_group = "elevated-curved-rail-a"
  data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a-minimal"].fast_replaceable_group = "elevated-curved-rail-a"
  data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].fast_replaceable_group = "elevated-half-diagonal-rail"
  data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail-minimal"].fast_replaceable_group = "elevated-half-diagonal-rail"
  data.raw["elevated-straight-rail"]["elevated-straight-rail"].fast_replaceable_group = "elevated-straight-rail"
  data.raw["elevated-straight-rail"]["elevated-straight-rail-minimal"].fast_replaceable_group = "elevated-straight-rail"

  data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b-minimal"].minable.mining_time = 3
  data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a-minimal"].minable.mining_time = 3
  data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail-minimal"].minable.mining_time = 2
  data.raw["elevated-straight-rail"]["elevated-straight-rail-minimal"].minable.mining_time = 1

  data.raw["rail-ramp"]["rail-ramp"].next_upgrade = "rail-ramp-minimal"
  data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].next_upgrade = "elevated-curved-rail-b-minimal"
  data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].next_upgrade = "elevated-curved-rail-a-minimal"
  data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].next_upgrade = "elevated-half-diagonal-rail-minimal"
  data.raw["elevated-straight-rail"]["elevated-straight-rail"].next_upgrade = "elevated-straight-rail-minimal"
end




  if mods["elevated-rails"] then
  end