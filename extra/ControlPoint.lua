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

ControlPoint = Core.class(Shape)
ControlPoint._type = "ControlPoint"

function ControlPoint:init(options)
	options = options or {}
	self.radius = options.radius or 6
	self.lineStyle = options.lineStyle or {1, 0x000000, 1}
	self.fillStyle = options.fillStyle or {Shape.SOLID, 0xDDDDDD, 1}

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)

	self:draw()
end

function ControlPoint:setX(x)
	Shape.setX(self, x)
	
	self:dispatchEvent(Event.new("ControlPointMove"))
end

function ControlPoint:setY(y)
	Shape.setY(self, y)
	
	self:dispatchEvent(Event.new("ControlPointMove"))
end

function ControlPoint:setPosition(x, y)
	self:setX(x)
	self:setY(y or x)
end

function ControlPoint:draw()
	self:clear()
	self:setLineStyle(unpack(self.lineStyle))
	self:setFillStyle(unpack(self.fillStyle))
	self:moveTo(-self.radius,-self.radius)
	self:lineTo(self.radius, -self.radius)
	self:lineTo(self.radius, self.radius)
	self:lineTo(-self.radius, self.radius)
	self:closePath()
	self:endPath()
end

function ControlPoint:onTouchesBegin(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) and #event.allTouches == 1 then
		-- print("ControlPoint", self, "TOUCHES_BEGIN", event.touch.x, event.touch.y)
		self.isFocus = true
		self:dispatchEvent(Event.new("ControlPointMoveBegin"))
		event:stopPropagation()
	end
end

function ControlPoint:onTouchesMove(event)
	if self.isFocus and #event.allTouches == 1 then
		-- print("ControlPoint", self, "TOUCHES_MOVE", event.touch.x, event.touch.y)
		self:setPosition(event.touch.x, event.touch.y)
		event:stopPropagation()
	end
end

function ControlPoint:onTouchesEnd(event)
	if self.isFocus and #event.allTouches == 1 then
		-- print("ControlPoint", self, "TOUCHES_END", event.touch.x, event.touch.y)
		self.isFocus = false
		self:dispatchEvent(Event.new("ControlPointMoveEnd"))
		event:stopPropagation()
	end
end

function ControlPoint:onTouchesCancel(event)
	if self.isFocus then
		self.focus = false;
		event:stopPropagation()
	end
end
