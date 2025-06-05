--[[if data.raw.technology["railway"] then
  table.insert(data.raw.technology["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = "rail-minimal"
  })
end]]

local function one_gravity_condition()
  return
  {
    {
      property = "gravity",
      min = 0.1
    }
  }
end

if mods["space-age"] then
  data.raw["curved-rail-b"]["curved-rail-b-minimal"].surface_conditions = one_gravity_condition()
  data.raw["curved-rail-a"]["curved-rail-a-minimal"].surface_conditions = one_gravity_condition()
  data.raw["half-diagonal-rail"]["half-diagonal-rail-minimal"].surface_conditions = one_gravity_condition()
  data.raw["straight-rail"]["straight-rail-minimal"].surface_conditions = one_gravity_condition()
  if mods["elevated-rails"] then
    data.raw["rail-ramp"]["rail-ramp-minimal"].surface_conditions = one_gravity_condition()
    data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b-minimal"].surface_conditions = one_gravity_condition()
    data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a-minimal"].surface_conditions = one_gravity_condition()
    data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail-minimal"].surface_conditions = one_gravity_condition()
    data.raw["elevated-straight-rail"]["elevated-straight-rail-minimal"].surface_conditions = one_gravity_condition()
  end
end

if mods["elevated-rails"] then
  local meld = require("__core__.lualib.meld")

  local rail_planner_with_elevated_rails_update =
  {
    rails = meld.append({
      "rail-ramp-minimal",
      "elevated-straight-rail-minimal",
      "elevated-curved-rail-a-minimal",
      "elevated-curved-rail-b-minimal",
      "elevated-half-diagonal-rail-minimal"
    }),
    support = "rail-support"
  }

  if data.raw.technology["elevated-rail"] then
    meld(data.raw["rail-planner"]["rail-minimal"], rail_planner_with_elevated_rails_update)
  end
end

for _, planet in pairs(data.raw["planet"]) do
  if planet.lightning_properties and planet.lightning_properties.exemption_rules then
    if data.raw["electric-pole"]["hidden-rail-pole"] then
      table.insert(planet.lightning_properties.exemption_rules, {type = "id", string = "hidden-rail-pole"})
    end
  end
end
