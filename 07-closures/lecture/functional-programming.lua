--[[ Functional Programming ]]
-- To give a more concrete example of functional programming, in this section we will develop a simple system for geometric regions. The goal is to develop a system to represent geometric regions, where a region is a set of points. We want to be able to represent all kinds of shapes and to combine and modify shapes in several ways (rotation, translation, union, etc.).

-- To implement this system, we could start looking for good data structures to represent shapes; we could try an object-oriented approach and develop some hierarchy of shapes. Or we can work on a higher level of abstraction and represent our sets directly by their characteristic (or indicator) function. (The characteristic function of a set A is a function fA such that fA(x) is true if and only if x belongs to A.) Given that a geometric region is a set of points, we can represent a region by its characteristic function; that is, we represent a region by a function that, given a point, returns true if and only if the point belongs to the region.

-- As an example, the next function represents a disk (a circular region) with center (1.0, 3.0) and radius 4.5:
function disk1 (x, y)
	return (x - 1.0)^2 + (y - 3.0)^2 <= 4.5^2
end

-- With higher-order functions and lexical scoping, it is easy to define a disk factory, which creates disks with given centers and radius:
function disk (cx, cy, r)
 	return function (x, y)
 		return (x - cx)^2 + (y - cy)^2 <= r^2
 	end
end

-- A call like disk(1.0, 3.0, 4.5) will create a disk equal to disk1.

-- The next function creates axis-aligned rectangles, given the bounds:
function rect (left, right, bottom, up)
 	return function (x, y)
 		return left <= x and x <= right and bottom <= x and x <= up
 		end
end

-- In a similar fashion, we can define functions to create other basic shapes, such as triangles and non–axis-aligned rectangles. Each shape has a completely independent implementation, needing only a correct characteristic function.

-- Now let us see how to modify and combine regions. To create the complement of any region is trivial:
function complement (r)
 	return function (x, y)
 		return not r(x, y)
 	end
end

-- Union, intersection, and difference are equally simple.
function union (r1, r2)
	return function (x, y)
		return r1(x, y) or r2(x, y)
	end
end
	
function intersection (r1, r2)
	return function (x, y)
		return r1(x, y) and r2(x, y)
	end
end
	
function difference (r1, r2)
	return function (x, y)
		return r1(x, y) and not r2(x, y)
	end
end

-- The following function translates a region by a given delta:
function translate (r, dx, dy)
	return function (x, y)
		return r(x - dx, y - dy)
	end
end
   
-- To visualize a region, we can traverse the viewport testing each pixel; pixels in the region are painted black, pixels outside it are painted white. To illustrate this process in a simple way, we will write a function to generate a PBM (portable bitmap) file with the drawing of a given region.

-- PBM files have a quite simple structure. (This structure is also highly inefficient, but our emphasis here is simplicity.) In its text-mode variant, it starts with a one-line header with the string "P1"; then there is one line with the width and height of the drawing, in pixels. Finally, there is a sequence of digits, one for each image pixel (1 for black, 0 for white), separated by optional spaces and end of lines. The function plot creates a PBM file for a given region, mapping a virtual drawing area (-1,1], [-1,1) to the viewport area [1,M], [1,N].

function plot (r, M, N)
	io.write("P1\n", M, " ", N, "\n") -- header
	for i = 1, N do -- for each line
		local y = (N - i*2)/N
		for j = 1, M do -- for each column
			local x = (j*2 - M)/M
			io.write(r(x, y) and "1" or "0")
		end
		io.write("\n")
	end
end
   
-- To complete our example, the following command draws a waxing crescent moon (as seen from the Southern Hemisphere):
c1 = disk(0, 0, 1)
plot(difference(c1, translate(c1, 0.3, 0)), 20, 20)
