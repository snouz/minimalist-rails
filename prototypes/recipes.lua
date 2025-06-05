data:extend({
  {
    type = "recipe",
    name = "rail-minimal",
    enabled = false,
    ingredients =
    {
      {type = "item", name = "iron-stick", amount = 2},
      {type = "item", name = "steel-plate", amount = 2}
    },
    results = {{type="item", name="rail-minimal", amount=2}}
  },
})

if mods["elevated-rails"] then
  data:extend({
    {
      type = "recipe",
      name = "rail-ramp-minimal",
      enabled = false,
      ingredients =
      {
        {type = "item", name = "refined-concrete", amount = 100},
        {type = "item", name = "rail-minimal", amount = 8},
        {type = "item", name = "steel-plate", amount = 10}
      },
      results = {{type="item", name="rail-ramp-minimal", amount=1}}
    },
  })
end