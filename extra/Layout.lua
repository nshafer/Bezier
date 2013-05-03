-- The MIT License (MIT)

-- Copyright (c) 2013 Nathan Shafer

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

Layout = Core.class(Sprite)

Layout.VERTICAL = 1
Layout.HORIZONTAL = 2

function Layout:init(options)
	options = options or {}
	self.layout = options.layout or Layout.VERTICAL
	self.space = options.space or 5
	
	self.sprites = {}
end

function Layout:addSprite(newSprite)
	table.insert(self.sprites, newSprite)
	self:addChild(newSprite)
	
	-- Layout the sprites
	local offset = 0
	for i,sprite in ipairs(self.sprites) do
		if self.layout == Layout.HORIZONTAL then
			sprite:setX(offset)
			offset = offset + sprite:getWidth() + self.space
		else
			sprite:setY(offset)
			offset = offset + sprite:getHeight() + self.space
		end
	end
end
