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



log(serpent.block("____________straightrail"))
log(serpent.block(straightrail.pictures))
log(serpent.block("____________curvedraila"))
log(serpent.block(curvedraila.pictures))
log(serpent.block("____________curvedrailb"))
log(serpent.block(curvedrailb.pictures))
log(serpent.block("____________halfdiagonalrail"))
log(serpent.block(halfdiagonalrail.pictures))

data:extend({straightrail, curvedraila, curvedrailb, halfdiagonalrail})
