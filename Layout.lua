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
