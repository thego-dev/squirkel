# Squirkel
### A löve2d pixel art scaling module with sharp, non-integer scaling support
inspired by, and partially based on, [maid64](https://github.com/adekto/maid64)

version 1.0: the Essentials

-----
## Why?
The commonly known love2d pixel art scaling modules are all locked to integer scaling.
Which is okay... until you make a project with a really unconventional resolution, as I have.
- Non-integer nearest-neighbour scaling would cause uneven pixels and "shimmering" with moving objects,
- While bilinear scaling would leave things blurry.

So, what are you to do? the answer: _both, sequentially._
- Scale up the image with nearest-neighbour, to the next integer resolution past the screen's size
- Scale down to the desired size with bilinear filtering

This results in _nearly sharp pixels_ at _any resolution._

As for just using a larger native resolution with upscaled sprites: Well, except for [a nice shader on top](https://github.com/RNavega/PixelArt-Antialias-Love/tree/master),
you sorta wouldn't need a module by then, or you'd be cool enough to make it yourself. /lh

## Usage:
loading the module:
```lua
sqkl = require("squirkel")
sqkl.load()
```
The base resolution is taken from `conf.lua` by default,
but you can also use `sqkl.load(width, height)` or `sqkl.load(size)` (which results in a square aspect ratio)

The resulting window size is 75% the screen's size, minus black borders.

---
```lua
function love.draw()
	sqkl.start()
	-- [everything drawn will be scaled in this range]
	sqkl.stop()
	-- raw drawing
	-- use `left, right, up, down = sqkl.border()`
	-- to get the boundaries of the canvas for non-pixel-art ui, for example
end
```

---
```lua
function love.resize(w, h)
	sqkl.resize(w, h)
end
```

images and tilesets
---
```lua
squirrel = {
	x = 56, y = 112,
	frame = 0 -- (tilesets are 0-indexed)
}

-- formats image to have sharp pixels
squirrel.atlas = sqkl.newImage("squirrel.png")

-- 
-- ([reference image for scaling and sprite count], [sprite width], [sprite height])
squirrel.frames = sqkl.newTileset(squirrel.atlas, 16, 16)

love.graphics.draw(
	squirrel.atlas, squirrel.frames[frame],
	squirrel.x, squirrel.y
)
```
mouse
---
```lua
local mx, my = sqkl.mouse.getPosition()
-- or sqkl.mouse.getX(), sqkl.mouse.getY()

love.graphics.circle(
	"fill", mx, my, 2
)
```
