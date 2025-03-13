local item_sounds = require("__base__.prototypes.item_sounds")
data:extend({
  {
    type = "rail-planner",
    name = "rail-minimal",
    icon = "__minimalist-rails__/graphics/icons/rail-minimal.png",
    localised_name = {"item-name.rail-minimal"},
    subgroup = "train-transport",
    order = "a[rail]-b2[rail-minimal]",
    inventory_move_sound = item_sounds.train_inventory_move,
    pick_sound = item_sounds.train_inventory_pickup,
    drop_sound = item_sounds.train_inventory_move,
    place_result = "straight-rail-minimal",
    stack_size = 100,
    weight = 10*kg,
    rails =
    {
      "straight-rail-minimal",
      "curved-rail-a-minimal",
      "curved-rail-b-minimal",
      "half-diagonal-rail-minimal"
    },
    manual_length_limit = 22.5 -- 2*(Curved-A) + 2*(Curved-B) + their planner penalty + margin
  },
})