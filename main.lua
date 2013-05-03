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

application:setBackgroundColor(0xAAAAAA)

-- Starting points
local p1 = {x=100,y=100}
local p2 = {x=800,y=250}
local p3 = {x=800,y=100}
local p4 = {x=150,y=200}

-- Layout buttons
local layout = Layout.new{layout = Layout.HORIZONTAL}
layout:setPosition(5, 5)
stage:addChild(layout)

-- Control handles
local cp1 = ControlPoint.new()
cp1:setPosition(p1.x, p1.y)
stage:addChild(cp1)

local cp2 = ControlPoint.new()
cp2:setPosition(p2.x, p2.y)
stage:addChild(cp2)

local cp3 = ControlPoint.new()
cp3:setPosition(p3.x, p3.y)
stage:addChild(cp3)

local cp4 = ControlPoint.new()
cp4:setPosition(p4.x, p4.y)
stage:addChild(cp4)

-- ControlPoint lines
local line1 = Shape.new()
stage:addChild(line1)

local line2 = Shape.new()
stage:addChild(line2)

function drawLines()
	line1:clear()
	line1:beginPath()
	line1:setLineStyle(2, 0x555555, .5)
	line1:moveTo(p1.x, p1.y)
	line1:lineTo(p2.x, p2.y)
	line1:endPath()

	line2:clear()
	line2:beginPath()
	line2:setLineStyle(2, 0x555555, .5)
	line2:moveTo(p3.x, p3.y)
	line2:lineTo(p4.x, p4.y)
	line2:endPath()
end

function createPoint(radius, color)
	local newPoint = Shape.new()
	newPoint:beginPath()
	newPoint:setFillStyle(Shape.SOLID, color, .7)
	newPoint:moveTo(-radius,-radius)
	newPoint:lineTo(radius,-radius)
	newPoint:lineTo(radius,radius)
	newPoint:lineTo(-radius,radius)
	newPoint:closePath()
	newPoint:endPath()
	return newPoint
end

local pointSprites = {}
local drawPointSprites = true
function clearPointSprites()
	for i,point in ipairs(pointSprites) do
		stage:removeChild(point)
	end
	pointSprites = {}
end

function drawPoints(points, color)
	for i,point in ipairs(points) do
		local newPoint = createPoint(2, color)
		table.insert(pointSprites, newPoint)
		stage:addChild(newPoint)
		newPoint:setPosition(point.x, point.y)
	end
end

-- Button for toggling on and off pointSprite display
function onPointSpriteButtonUp(event)
	if drawPointSprites then
		drawPointSprites = false
	else
		drawPointSprites = true
	end
	updateCurve()
end

local pointSpriteTextButton = TextButton.new("Show Pts")
local pointSpriteButton = Button.new("togglePoints", pointSpriteTextButton.up, pointSpriteTextButton.down)
pointSpriteButton:addEventListener("up", onPointSpriteButtonUp)
layout:addSprite(pointSpriteButton)


-- Button for setting curve steps
local steps = nil
function onStepsComplete(event)
	if event.buttonIndex then
		steps = tonumber(event.text)
		updateCurve()
	end
end

function onStepsButtonUp(event)
	local stepsInput = TextInputDialog.new("Steps", "Enter number of steps (or 'auto')", steps or "auto", "Cancel", "Set")
	stepsInput:addEventListener(Event.COMPLETE, onStepsComplete)
	stepsInput:show()
end

local stepsTextButton = TextButton.new("Steps")
local stepsButton = Button.new("steps", stepsTextButton.up, stepsTextButton.down)
stepsButton:addEventListener("up", onStepsButtonUp)
layout:addSprite(stepsButton)


-- Button for setting epsilon
local epsilon = .1
function onEpsilonComplete(event)
	if event.buttonIndex then
		epsilon = tonumber(event.text)
		updateCurve()
	end
end

function onEpsilonButtonUp(event)
	local epsilonInput = TextInputDialog.new("Epsilon", "Enter new epsilon (0 disables)", epsilon or "off", "Cancel", "Set")
	epsilonInput:addEventListener(Event.COMPLETE, onEpsilonComplete)
	epsilonInput:show()
end

local epsilonTextButton = TextButton.new("Epsilon")
local epsilonButton = Button.new("epsilon", epsilonTextButton.up, epsilonTextButton.down)
epsilonButton:addEventListener("up", onEpsilonButtonUp)
layout:addSprite(epsilonButton)


-- Create our Bezier curves
local curve = Bezier.new{lineStyle = {1, 0x2e6d94, 1}}
stage:addChild(curve)

local curve2 = Bezier.new{lineStyle = {40, 0x7cbe7c, 1}}
stage:addChildAt(curve2, 1)


-- Status display
local calcTime = 0
local drawTime = 0
local reduceTime = 0
local status = TextField.new(TTFont.new("NotoSans-Regular.ttf", 12), "Status")
status:setPosition(5, application:getContentHeight() - 5)
stage:addChild(status)

function updateStatus()
	local lengthStr = string.format("%.1f", curve:getLength())
	local calcTimeStr = string.format("%.2f", calcTime*1000)
	local drawTimeStr = string.format("%.2f", drawTime*1000)
	local reduceTimeStr = string.format("%.2f", reduceTime*1000)
	local totalTimeStr = string.format("%.2f", (calcTime + drawTime + reduceTime) * 1000)
	status:setText("Points: "..#curve.points..
				   " Steps: "..(steps or "A")..
				   " Length: "..lengthStr..
				   " Epsilon: "..(epsilon or "0")..
				   " Calc: "..calcTimeStr.."ms"..
				   " Draw: "..drawTimeStr.."ms"..
				   " Reduce: "..reduceTimeStr.."ms"..
				   " Total: "..totalTimeStr.."ms")
end



function updateCurve()
	-- update points
	p1 = {x=cp1:getX(),y=cp1:getY()}
	p2 = {x=cp2:getX(),y=cp2:getY()}
	p3 = {x=cp3:getX(),y=cp3:getY()}
	p4 = {x=cp4:getX(),y=cp4:getY()}

	-- Reset
	clearPointSprites()
	calcTime = 0
	drawTime = 0
	reduceTime = 0

	-- Calculate the curve
	local startTime = os.timer()
	curve:createCubicCurve(p1, p2, p3, p4, steps)
	--curve:createQuadraticCurve(p1, p2, p4, steps)
	calcTime = os.timer() - startTime
	curve2:createCubicCurve(p1, p2, p3, p4, steps)

	-- if drawPointSprites then
	-- 	drawPoints(curve:getPoints(), 0xEE0000) -- draw points in red
	-- end
	
	-- Reduce the curve
	if tonumber(epsilon) and epsilon > 0 then
		startTime = os.timer()
		curve:reduce(epsilon)
		reduceTime = os.timer() - startTime
		curve2:reduce(epsilon)
	end

	-- Draw the curve
	startTime = os.timer()
	curve:draw()
	drawTime = os.timer() - startTime
	curve2:draw()

	-- Draw points
	if drawPointSprites then
		drawPoints(curve:getPoints(), 0x2A497E) -- draw points in green
	end

	-- Draw lines between end points and control points
	drawLines()

	-- Update status on bottom of screen
	updateStatus()
end
updateCurve()

-- Redraw the curve every time a point is moved
cp1:addEventListener("ControlPointMove", updateCurve)
cp2:addEventListener("ControlPointMove", updateCurve)
cp3:addEventListener("ControlPointMove", updateCurve)
cp4:addEventListener("ControlPointMove", updateCurve)

