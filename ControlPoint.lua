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
