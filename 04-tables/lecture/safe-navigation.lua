--[[ Safe Navigation ]]
-- Suppose the following situation: we want to know whether a given function from a given library is present. If we know for sure that the library itself exists, we can write something like if lib.foo then .... Otherwise, we have to write something like if lib and lib.foo then ...

-- When the level of nested tables gets deeper, this notation becomes problematic, as the next example illustrates:
zip = company and company.director and company.director.address and company.director.address.zipcode

-- This notation is not only cumbersome, but inefficient, too. It performs six table accesses in a successful access, instead of three.

-- Some programming languages, such as C#, offer a safe navigation operator (written as ?. in C#) for this task. When we write a ?. b and a is nil, the result is also nil, instead of an error. Using that operator, we could write our previous example like this:
zip = company?.director?.address?.zipcode

-- If any component in the path were nil, the safe operator would propagate that nil until the final result.

-- Lua does not offer a safe navigation operator, and we do not think it should. Lua is minimalistic. Moreover, this operator is quite controversial, with many people arguing — not without some reason — that it promotes careless programming. However, we can emulate it in Lua with a bit of extra notation.

-- If we execute a or {} when a is nil, the result is the empty table. So, if we execute (a or {}).b when a is nil, the result will be also nil. Using this idea, we can rewrite our original expression like this:
zip = (((company or {}).director or {}).address or {}).zipcode

-- Still better, we can make it a little shorter and slightly more efficient:
E = {} -- can be reused in other similar expressions
zip = (((company or E).director or E).address or E).zipcode

-- Granted, this syntax is more complex than the one with the safe navigation operator. Nevertheless, we write each field name only once, it performs the minimum required number of table accesses (three, in this example), and it requires no new operators in the language. In my personal opinion, it is a good enough substitute.
