--[[ Proper Tail Calls ]]
-- Another interesting feature of functions in Lua is that Lua does tail-call elimination. 

-- A tail call is a goto dressed as a call. A tail call happens when a function calls another as its last action, so it has nothing else to do. For instance, in the following code, the call to g is a tail call:
function f (x) 
	x = x + 1; 
	return g(x) 
end
-- After f calls g, it has nothing else to do. In such situations, the program does not need to return to the calling function when the called function ends. Therefore, after the tail call, the program does not need to keep any information about the calling function on the stack. When g returns, control can return directly to the point that called f. Some language implementations, such as the Lua interpreter, take advantage of this fact and actually do not use any extra stack space when doing a tail call. We say that these implementations do tail-call elimination.

-- Because tail calls use no stack space, the number of nested tail calls that a program can make is unlimited. For instance, we can call the following function passing any number as argument:
function foo (n)
	if n > 0 then 
		return foo(n - 1) 
	end
end

-- It will never overflow the stack.

-- A subtle point about tail-call elimination is what is a tail call. Some apparently obvious candidates fail the criterion that the calling function has nothing else to do after the call. For instance, in the following code, the call to g is not a tail call:
function f (x) 
	g(x) 
end

-- The problem in this example is that, after calling g, f still has to discard any results from g before returning. Similarly, all the following calls fail the criterion:
return g(x) + 1 -- must do the addition
return x or g(x) -- must adjust to 1 result
return (g(x)) -- must adjust to 1 result

-- In Lua, only a call with the form return func(args) is a tail call. However, both func and its arguments can be complex expressions, because Lua evaluates them before the call. For instance, the next call is a tail call:
return x[i].foo(x[j] + a*b, i + j)
