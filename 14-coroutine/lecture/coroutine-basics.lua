--[[ Coroutine Basics ]]
-- Lua packs all its coroutine-related functions in the table coroutine. The function create creates new coroutines. It has a single argument, a function with the code that the coroutine will run (the coroutine body). It returns a value of type "thread", which represents the new coroutine. Often, the argument to create is an anonymous function, like here:
co = coroutine.create(function () print("hi") end)
print(type(co)) --> thread

-- A coroutine can be in one of four states: suspended, running, normal, and dead. We can check the state of a coroutine with the function coroutine.status:
print(coroutine.status(co)) --> suspended

-- When we create a coroutine, it starts in the suspended state; a coroutine does not run its body automatically when we create it. The function coroutine.resume (re)starts the execution of a coroutine, changing its state from suspended to running:
coroutine.resume(co) --> hi

-- (If you run this code in interactive mode, you may want to finish the previous line with a semicolon, to suppress the display of the result from resume.) In this first example, the coroutine body simply prints "hi" and terminates, leaving the coroutine in the dead state:
print(coroutine.status(co)) --> dead

-- Until now, coroutines look like nothing more than a complicated way to call functions. The real power of coroutines stems from the function yield, which allows a running coroutine to suspend its own execution so that it can be resumed later. Let us see a simple example:
co = coroutine.create(function ()
	for i = 1, 10 do
		print("co", i)
		coroutine.yield()
	end
end)

-- Now, the coroutine body does a loop, printing numbers and yielding after each print. When we resume this coroutine, it starts its execution and runs until the first yield:
coroutine.resume(co) --> co 1

-- If we check its status, we can see that the coroutine is suspended and, therefore, can be resumed:
print(coroutine.status(co)) --> suspended

-- From the coroutine's point of view, all activity that happens while it is suspended is happening inside its call to yield. When we resume the coroutine, this call to yield finally returns and the coroutine continues its execution until the next yield or until its end:
coroutine.resume(co) --> co 2
coroutine.resume(co) --> co 3
coroutine.resume(co) --> co 4
coroutine.resume(co) --> co 5
coroutine.resume(co) --> co 6
coroutine.resume(co) --> co 7
coroutine.resume(co) --> co 8
coroutine.resume(co) --> co 9
coroutine.resume(co) --> co 10
coroutine.resume(co) -- prints nothing

-- During the last call to resume, the coroutine body finishes the loop and then returns, without printing anything. If we try to resume it again, resume returns false plus an error message:
print(coroutine.resume(co)) --> false cannot resume dead coroutine

-- Note that resume runs in protected mode, like pcall. Therefore, if there is any error inside a coroutine, Lua will not show the error message, but instead will return it to the resume call.

-- When a coroutine resumes another, it is not suspended; after all, we cannot resume it. However, it is not running either, because the running coroutine is the other one. So, its own status is what we call the normal state.

-- A useful facility in Lua is that a pair resume–yield can exchange data. The first resume, which has no corresponding yield waiting for it, passes its extra arguments to the coroutine main function:
co = coroutine.create(function (a, b, c)
	print("co", a, b, c + 2)
end)
coroutine.resume(co, 1, 2, 3) --> co 1 2 5
-- A call to coroutine.resume returns, after the true that signals no errors, any arguments passed to the corresponding yield:
co = coroutine.create(function (a,b)
coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10)) --> true 30 10

-- Symmetrically, coroutine.yield returns any extra arguments passed to the corresponding resume:
co = coroutine.create (function (x)
	print("co1", x)
	print("co2", coroutine.yield())
end)
coroutine.resume(co, "hi") --> co1 hi
coroutine.resume(co, 4, 5) --> co2 4 5

-- Finally, when a coroutine ends, any values returned by its main function go to the corresponding resume:
co = coroutine.create(function ()
	return 6, 7
end)
print(coroutine.resume(co)) --> true 6 7

-- We seldom use all these facilities in the same coroutine, but all of them have their uses.

-- Although the general concept of coroutines is well understood, the details vary considerably. So, for those that already know something about coroutines, it is important to clarify these details before we go on. Lua offers what we call asymmetric coroutines. This means that it has a function to suspend the execution of a coroutine and a different function to resume a suspended coroutine. Some other languages offer symmetric coroutines, where there is only one function to transfer control from one coroutine to another.

-- Some people call asymmetric coroutines semi-coroutines. However, other people use the same term semi-coroutine to denote a restricted implementation of coroutines, where a coroutine can suspend its execution only when it is not calling any function, that is, when it has no pending calls in its control stack. In other words, only the main body of such semi-coroutines can yield. (A generator in Python is an example of this meaning of semi-coroutines.)

-- Unlike the difference between symmetric and asymmetric coroutines, the difference between coroutines and generators (as presented in Python) is a deep one; generators are simply not powerful enough to implement some of the most interesting constructions that we can write with full coroutines. Lua offers full, asymmetric coroutines.
