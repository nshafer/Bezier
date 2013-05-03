Bezier
============

This is an implementation of cubic and quadratic Bezier curves for Gideros.  Features:
* Is a Gideros "Shape" object for easy integration into your project.
* Very quick calculation of cubic and quadratic Bezier curves.
* Automatic scaling of number of steps.
* Deferred drawing (the most expensive operation) until you want it.
* Optional reduction of calculated points to just those needed.  Can generally result in a reduction of 25% to 75% depending on the curve.
* Length of curve calculation.

#Install

Just add the Bezier.lua file to your project.

#Example

```lua
local curve = Bezier.new{lineStyle={2, 0x000000, 1}, fillStyle={Shape.SOLID, 0xFF0000, 1}}
stage:addChild(curve)

local p1 = {x=50,y=50}
local p2 = {x=200,y=50}
local p3 = {x=50,y=200}
local p4 = {x=50,y=200}

curve:createCubicCurve(p1, p2, p3, p4)
curve:reduce()
curve:draw(true)
```

#Methods

###Bezier.new(options)
	Creates a new Bezier object, which inherits from Shape.

	Parameters:
		options: a table of options.

	Options:
		lineStyle: A table of lineStyle options.  See the Shape documentation for valid entries.  Example: lineStyle={2, 0x000000, 1}
		fillStyle: A table of fillStyle options.  See the Shape documentation for valid entries.  Example: fillStyle={Shape.SOLID, 0xFF0000, 1}
		autoStepScale: What percentage of the total distance between all control points to estimate number of steps.  Default: .1

###Bezier:getPoints()
	Returns a table/list of points, if any have been calculated.

###Bezier:getLength()
	Returns the total length of the curve by adding up the distance between each point in the curve.

###Bezier:draw(isClosed)
	Draws the curve using the inherited Shape methods as a series of lines.  Remember, you have to add the curve somewhere in the scene graph for it to be visible.

	Parameters:
		isClosed - Controls whether the curve is drawn as a closed path or not.  Default: false

###Bezier:createQuadraticCurve(p1, p2, p3, steps)
	Calculates the points needed to form a quadratic curve comprised of a start point (p1), a single control point (p2) and an end point (p3).

	Parameters:
		p1: Beginning of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		p2: First control point of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		p3: End of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		steps: Number of steps to create in the path.  Default: estimate based on distance between points.

###Bezier:createCubicCurve(p1, p2, p3, p4, steps)
	Calculates the points needed to form a cubic curve comprised of a start point (p1), a control point (p2), another control point (p3) and an end point (p4).

	Parameters:
		p1: Beginning of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		p2: First control point of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		p3: Second control point of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		p4: End of the path. Must be table with 'x' and 'y' keys, i.e. {x=100,y=100}
		steps: Number of steps to create in the path.  Default: estimate based on distance between points.

###Bezier:reduce(epsilon)
	Reduces the number of points in the path by examining the distance between each point and line from surrounding points.  If the point is greater than *epsilon* then it will be kept, otherwise it is discarded.

	Parameters:
		epsilon: Minimum distance from the line of the curve for a point to be kept.  Higher values result in more points being thrown away.  Default: .1



