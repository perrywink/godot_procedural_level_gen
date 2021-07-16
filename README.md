# godot_procedural_level_gen
A godot project implementing the drunkard walker algorithm.

It can dyamically create levels based on the params given:
- Level Size
- Level Size Resolution (How big each "cell" is)
- Chance Walker Create (Probability of spawning a walker at any given moment)
- Chance Destroy Walker (Probability of destroying a walker when the number of walkers > 1)
- Max Walkers
- Target Grid Fill Percentage (Percentage of floor space relative to grid size)
- Sprite Scale and Sprite Pixel Size (Allows for proper positioning of the sprites in Godot)

This was to mainly familiarise myself with GDScript + make something which can become useful in my future gamedev endeavours!

