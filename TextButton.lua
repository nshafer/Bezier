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

TextButton = Core.class(Sprite)

function TextButton:init(text, options)
	options = options or {}
	self.width = options.width or 60
	self.height = options.height or 20
	self.upLineColor = options.upLineColor or 0xBBBBDD
	self.upFillColor = options.upFillColor or 0xDDDDFF
	self.downLineColor = options.downLineColor or 0x8888CC
	self.downFillColor = options.downFillColor or 0xAAAAEE
	self.fontSize = options.fontSize or 12
	
	self.font = TTFont.new("NotoSans-Regular.ttf", self.fontSize)
	
	self.up = self:createButton(text, {2, self.upLineColor, 1}, {Shape.SOLID, self.upFillColor, 1})
	self.down = self:createButton(text, {2, self.upLineColor, 1}, {Shape.SOLID, self.downFillColor, 1})
	
	self.upText = TextField.new(self.font)
	self.upText:setY(self.fontSize) -- Move inside of the button
	self.up:addChild(self.upText)
	
	self.downText = TextField.new(self.font)
	self.downText:setY(self.fontSize) -- Move inside of the button
	self.down:addChild(self.downText)
	
	self:setText(text)
end

function TextButton:createButton(text, lineStyle, fillStyle)
	local button = Shape.new()
	button:setLineStyle(unpack(lineStyle))
	button:setFillStyle(unpack(fillStyle))
	button:moveTo(0, 0)
	button:lineTo(self.width, 0)
	button:lineTo(self.width, self.height)
	button:lineTo(0, self.height)
	button:closePath()
	button:endPath()
	return(button)
end

function TextButton:setUpText(text)
	self.upText:setText(text)
	self.upText:setX((self.up:getWidth() - self.upText:getWidth()) / 2 - 1)
	self.upText:setY((self.up:getHeight() - self.fontSize*.75) / 2 + self.fontSize*.75)
end

function TextButton:setDownText(text)
	self.downText:setText(text)
	self.downText:setX((self.down:getWidth() - self.downText:getWidth()) / 2 - 1)
	self.downText:setY((self.down:getHeight() - self.fontSize*.75) / 2 + self.fontSize*.75)
end

function TextButton:setText(text)
	self:setUpText(text)
	self:setDownText(text)
end