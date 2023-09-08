--[[ Arrays, Lists, and Sequences ]]
To represent a conventional array or a list, we simply use a table with integer keys. There is neither a way nor a need to declare a size; we just initialize the elements we need:
-- read 10 lines, storing them in a table
a = {}
for i = 1, 10 do
    a[i] = io.read()
end

-- Given that we can index a table with any value, we can start the indices of an array with any number that pleases us. However, it is customary in Lua to start arrays with one (and not with zero, as in C) and many facilities in Lua stick to this convention.

-- Usually, when we manipulate a list we must know its length. It can be a constant or it can be stored somewhere. Often we store the length of a list in a non-numeric field of the table; for historical reasons, several programs use the field "n" for this purpose. Often, however, the length is implicit. Remember that any non-initialized index results in nil; we can use this value as a sentinel to mark the end of the list. For instance, after we read 10 lines into a list, it is easy to know that its length is 10, because its numeric keys are 1, 2, ..., 10. This technique only works when the list does not have holes, which are nil elements inside it. We call such a list without holes a sequence.

-- For sequences, Lua offers the length operator (#). As we have seen, on strings it gives the number of bytes in the string. On tables, it gives the length of the sequence represented by the table. For instance, we could print the lines read in the last example with the following code:

-- print the lines, from 1 to #a
for i = 1, #a do
    print(a[i])
end

-- The length operator also provides a useful idiom for manipulating sequences:
a[#a + 1] = v -- appends 'v' to the end of the sequence

-- The length operator is unreliable for lists with holes (nils). It only works for sequences, which we defined as lists without holes. More precisely, a sequence is a table where the positive numeric keys comprise a set {1,...,n} for some n. (Remember that any key with value nil is actually not in the table.) In particular, a table with no numeric keys is a sequence with length zero.

-- The behavior of the length operator for lists with holes is one of the most contentious features of Lua. Over the years, there have been many proposals either to raise an error when we apply the length operator to a list with holes, or to extend its meaning to those lists. However, these proposals are easier said than done. The problem is that, because a list is actually a table, the concept of “length” is somewhat fuzzy.

-- For instance, consider the list resulting from the following code:
a = {}
a[1] = 1
a[2] = nil -- does nothing, as a[2] is already nil
a[3] = 1
a[4] = 1

-- It is easy to say that the length of this list is four, and that is has a hole at index 2. However, what can we say about the next similar example?
a = {}
a[1] = 1
a[10000] = 1

 -- Should we consider a as a list with 10000 elements, with 9998 holes? Now, the program does this:
a[10000] = nil

-- What is the list length now? Should it be 9999, because the program deleted the last element? Or maybe still 10000, as the program only changed the last element to nil? Or should the length collapse to one?

-- Another common proposal is to make the # operator return the total number of elements in the table. This semantics is clear and well defined, but not very useful or intuitive. Consider all the examples we are discussing here and think how useful would be such operator for them.

-- Yet more troubling are nils at the end of the list. What should be the length of the following list?
a = {10, 20, 30, nil, nil}

-- Remember that, for Lua, a field with nil is indistinct from an absent field. Therefore, the previous table is equal to {10, 20, 30}; its length is 3, not 5.

-- You may consider that a nil at the end of a list is a very special case. However, many lists are built by adding elements one by one. Any list with holes that was built that way must have had nils at its end along the way.

-- Despite all these discussions, most lists we use in our programs are sequences (e.g., a file line cannot be nil) and, therefore, most of the time the use of the length operator is safe. If you really need to handle lists with holes, you should store the length explicitly somewhere.
