if data.raw.technology["railway"] then
  table.insert(data.raw.technology["railway"].effects,
  {
    type = "unlock-recipe",
    recipe = "rail-minimal"
  })
end

local function one_gravity_condition()
  return
  {
    {
      property = "gravity",
      min = 1
    }
  }
end

if mods["space-age"] then
  data.raw["curved-rail-b"]["curved-rail-b-minimal"].surface_conditions = one_gravity_condition()
  data.raw["curved-rail-a"]["curved-rail-a-minimal"].surface_conditions = one_gravity_condition()
  data.raw["half-diagonal-rail"]["half-diagonal-rail-minimal"].surface_conditions = one_gravity_condition()
  data.raw["straight-rail"]["straight-rail-minimal"].surface_conditions = one_gravity_condition()
end