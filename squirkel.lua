--[[SQUIRKEL v1.0.0
A Löve2D pixel art scaling module with sharp, non-integer scaling support
by Thego
https://github.com/thego-dev/squirkel/
--]]

local sqkl = {}

--faster access
local lg = love.graphics

function sqkl.load(base_w, base_h)
	if base_w then
		sqkl.h = base_h or base_w
		sqkl.w = base_w
	else
		sqkl.w, sqkl.h = love.graphics.getDimensions()
	end
	
	--hack to figure out screen size, gets overwritten anyways
	love.window.setMode(0, 0)
	local width, height = love.graphics.getDimensions()
	
	sqkl.max_scale = math.min(width/sqkl.w, height/sqkl.h)
	sqkl.scale = math.max(math.floor(sqkl.max_scale)*.75, 1)
	sqkl.max_scale = math.ceil(sqkl.max_scale)
	
	sqkl.window_w, sqkl.window_h = sqkl.w * sqkl.scale, sqkl.h * sqkl.scale
	
	sqkl.x, sqkl.y = 0, 0
	
	sqkl.canvas = lg.newCanvas(sqkl.w, sqkl.h)
	sqkl.canvas:setFilter"linear"
	sqkl.scaleup = lg.newCanvas(sqkl.w*sqkl.max_scale, sqkl.h*sqkl.max_scale)
	sqkl.scaleup:setFilter"linear"
	
	
	love.window.setMode(sqkl.window_w, sqkl.window_h, {
		resizable = true, vsync = false,
		minwidth = base_w, minheight = base_h
	})
end



function sqkl.start()
	lg.setCanvas(sqkl.canvas)
	lg.clear()
end

function sqkl.stop()
	local blend_was, alpha_was = lg.getBlendMode()
	lg.setBlendMode("alpha", "premultiplied")
	
	--scale up with bilinear,
	lg.setCanvas(sqkl.scaleup)
	lg.clear()
	lg.draw(sqkl.canvas, 0, 0, 0, sqkl.max_scale)
	--scale down with nearest neighbour,
	lg.setCanvas()
	lg.draw(sqkl.scaleup, sqkl.x, sqkl.y, 0, sqkl.scale/sqkl.max_scale)
	--only the borders of pixels get blurred and everyone's happy
	
	lg.setBlendMode(blend_was, alpha_was)
end



function sqkl.resize(w, h)
	sqkl.scale = math.min(w/sqkl.w, h/sqkl.h)
	sqkl.window_w = w
	sqkl.window_h = h
	
	sqkl.x = (sqkl.window_w - sqkl.w*sqkl.scale)/2
	sqkl.y = (sqkl.window_h - sqkl.h*sqkl.scale)/2
end



sqkl.mouse = {}

function sqkl.mouse.getPosition()
	return sqkl.mouse.getX(), sqkl.mouse.getY()
end

function sqkl.mouse.getX()
	return math.floor((love.mouse.getX()-sqkl.x)/sqkl.scale)
end

function sqkl.mouse.getY()
	return math.floor((love.mouse.getY()-sqkl.y)/sqkl.scale)
end



function sqkl.border()
	return sqkl.x, sqkl.x + sqkl.w * sqkl.scale,
	       sqkl.y, sqkl.y + sqkl.h * sqkl.scale
end



function sqkl.newImage(source)
	local img = lg.newImage(source)
	img:setFilter"nearest"
	return img
end

function sqkl.newTileset(image, w, h)
	local quads = {w = w, h = h}
	
	local xtiles, ytiles = image:getWidth()/w, image:getHeight()/h
	
	for i = 0, xtiles * ytiles - 1 do
		quads[i] = love.graphics.newQuad(
			(i % xtiles) * w,
			math.floor( i / xtiles) * h,
			w, h, image:getDimensions()
		)
	end
	
	return quads
end



return sqkl
