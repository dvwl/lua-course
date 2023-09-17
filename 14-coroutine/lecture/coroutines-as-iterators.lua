--[[ Coroutines as Iterators ]]
-- We can see loop iterators as a particular example of the producer–consumer pattern: an iterator produces items to be consumed by the loop body. Therefore, it seems appropriate to use coroutines to write iterators. Indeed, coroutines provide a powerful tool for this task. Again, the key feature is their ability to turn inside out the relationship between caller and callee. With this feature, we can write iterators without worrying about how to keep state between successive calls.

-- To illustrate this kind of use, let us write an iterator to traverse all permutations of a given array. It is not an easy task to write directly such an iterator, but it is not so difficult to write a recursive function that generates all these permutations. The idea is simple: put each array element in the last position, in turn, and recursively generate all permutations of the remaining elements. The code below shows "A function to generate permutations".
function permgen (a, n)
	n = n or #a -- default for 'n' is size of 'a'
	if n <= 1 then -- nothing to change?
		printResult(a)
	else
		for i = 1, n do
			-- put i-th element as the last one
			a[n], a[i] = a[i], a[n]
			
			-- generate all permutations of the other elements
			permgen(a, n - 1)
		
			-- restore i-th element
			a[n], a[i] = a[i], a[n]
		end
	end
end

-- To put it to work, we must define an appropriate printResult function and call permgen with proper arguments:
function printResult (a)
	for i = 1, #a do io.write(a[i], " ")end
	io.write("\n")
end
	
permgen ({1,2,3,4})
--> 2 3 4 1
--> 3 2 4 1
--> 3 4 2 1
--> 2 1 3 4
--> 1 2 3 4

-- After we have the generator ready, it is an automatic task to convert it to an iterator. First, we change printResult to yield:
function permgen (a, n)
	n = n or #a
	if n <= 1 then
		coroutine.yield(a)
	else
		for i = 1, n do
			-- put i-th element as the last one
			a[n], a[i] = a[i], a[n]
			
			-- generate all permutations of the other elements
			permgen(a, n - 1)
		
			-- restore i-th element
			a[n], a[i] = a[i], a[n]
		end
	end
end

Then, we define a factory that arranges for the generator to run inside a coroutine and creates the iterator
function. The iterator simply resumes the coroutine to produce the next permutation:
 function permutations (a)
 local co = coroutine.create(function () permgen(a) end)
 return function () -- iterator
 local code, res = coroutine.resume(co)
 return res
 end
 end
With this machinery in place, it is trivial to iterate over all permutations of an array with a for statement:
 for p in permutations{"a", "b", "c"} do
 printResult(p)
 end
 --> b c a
 --> c b a
 --> c a b
 --> a c b
 --> b a c
 --> a b c

-- The function permutations uses a common pattern in Lua, which packs a call to resume with its corresponding coroutine inside a function. This pattern is so common that Lua provides a special function for it: coroutine.wrap. Like create, wrap creates a new coroutine. Unlike create, wrap does not return the coroutine itself; instead, it returns a function that, when called, resumes the coroutine. Unlike the original resume, that function does not return an error code as its first result; instead, it raises the error in case of error. Using wrap, we can write permutations as follows:
function permutations (a)
	return coroutine.wrap(function () 	permgen(a) end)
end

-- Usually, coroutine.wrap is simpler to use than coroutine.create. It gives us exactly what we need from a coroutine: a function to resume it. However, it is also less flexible. There is no way to check the status of a coroutine created with wrap. Moreover, we cannot check for runtime errors.
