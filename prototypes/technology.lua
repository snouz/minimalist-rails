data:extend({
  {
    type = "technology",
    name = "minimalist-rails",
    icon = "__minimalist-rails__/graphics/technology/minimalist-rails.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "rail-minimal"
      },
    },
    prerequisites = {"railway"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    }
  },
})