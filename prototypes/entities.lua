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

  replace_strings(elevated_railramp.pictures, "__elevated", "__minimalist")
  replace_strings(elevated_straightrail.pictures, "__elevated", "__minimalist")
  replace_strings(elevated_curvedraila.pictures, "__elevated", "__minimalist")
  replace_strings(elevated_curvedrailb.pictures, "__elevated", "__minimalist")
  replace_strings(elevated_halfdiagonalrail.pictures, "__elevated", "__minimalist")

  replace_strings(elevated_railramp.fence_pictures, "__elevated", "__minimalist")
  replace_strings(elevated_straightrail.fence_pictures, "__elevated", "__minimalist")
  replace_strings(elevated_curvedraila.fence_pictures, "__elevated", "__minimalist")
  replace_strings(elevated_curvedrailb.fence_pictures, "__elevated", "__minimalist")
  replace_strings(elevated_halfdiagonalrail.fence_pictures, "__elevated", "__minimalist")

  --log(serpent.block(elevated_halfdiagonalrail.pictures))
  data:extend({elevated_railramp, elevated_straightrail, elevated_curvedraila, elevated_curvedrailb, elevated_halfdiagonalrail})
end