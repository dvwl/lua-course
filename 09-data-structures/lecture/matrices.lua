--[[ Matrices and Multi-Dimensional Array ]]
-- There are two main ways to represent matrices in Lua. The first one is with a jagged array (an array of arrays), that is, a table wherein each element is another table. For instance, we can create a matrix of zeros with dimensions N by M with the following code:
local mt = {} -- create the matrix
local N = 2
local M = 2
local K = 2
for i = 1, N do
	local row = {} -- create a new row
	mt[i] = row
	for j = 1, M do
		row[j] = 0
	end
end

-- Because tables are objects in Lua, we have to create each row explicitly to build a matrix. On the one hand, this is certainly more verbose than simply declaring a matrix, as we do in C. On the other hand, it gives us more flexibility. For instance, we can create a triangular matrix by changing the inner loop in the previous example to for j=1,i do ... end. With this code, the triangular matrix uses only half the memory of the original one.

-- The second way to represent a matrix is by composing the two indices into a single one. Typically, we do this by multiplying the first index by a suitable constant and then adding the second index. With this approach, the following code would create our matrix of zeros with dimensions N by M:
local mt = {} -- create the matrix
for i = 1, N do
	local aux = (i - 1) * M
	for j = 1, M do
		mt[aux + j] = 0
	end
end

-- Quite often, applications use a sparse matrix, a matrix wherein most elements are zero or nil. For instance, we can represent a graph by its adjacency matrix, which has the value x in position (m,n) when there is a connection with cost x between nodes m and n. When these nodes are not connected, the value in position(m,n) is nil. To represent a graph with ten thousand nodes, where each node has about five neighbors, we will need a matrix with a hundred million entries (a square matrix with 10000 columns and 10000 rows), but approximately only fifty thousand of them will not be nil (five non-nil columns for each row, corresponding to the five neighbors of each node). Many books on data structures discuss at length how to implement such sparse matrices without wasting 800 MB of memory, but we seldom need these techniques when programming in Lua. Because we represent arrays with tables, they are naturally sparse. With our first representation (tables of tables), we will need ten thousand tables, each one with about five elements, with a grand total of fifty thousand entries. With the second representation, we will have a single table, with fifty thousand entries in it. Whatever the representation, we need space only for the non-nil elements.

-- We cannot use the length operator over sparse matrices, because of the holes (nil values) between active entries. This is not a big loss; even if we could use it, we probably would not. For most operations, it would be quite inefficient to traverse all those empty entries. Instead, we can use pairs to traverse only the non-nil elements. As an example, let us see how to do matrix multiplication with sparse matrices represented by jagged arrays.

-- Suppose we want to multiply a matrix a[M,K] by a matrix b[K,N], producing the matrix c[M,N]. The usual matrix-multiplication algorithm goes like this:
local a = {
	{1, 2},
	{3, 4}	
}
local b = {
	{5, 6},
	{7, 8}
}
local c = {
	{0, 0},
	{0, 0}
}
for i = 1, M do
	for j = 1, N do
		c[i][j] = 0
		for k = 1, K do
			c[i][j] = c[i][j] + a[i][k] * b[k][j]
		end
	end
end

-- The two outer loops traverse the entire resulting matrix, and for each element, the inner loop computes its value.

-- For sparse matrices with jagged arrays, this inner loop is a problem. Because it traverses a column of b, instead of a row, we cannot use something like pairs here: the loop has to visit each row looking whether that row has an element in that column. Instead of visiting only a few non-zero elements, the loop visits all zero elements, too. (Traversing a column can be an issue in other contexts, too, because of its loss of spatial locality.)

-- The following algorithm is quite similar to the previous one, but it reverses the order of the two inner loops. With this simple change, it avoids traversing columns:
-- assumes 'c' has zeros in all elements
for i = 1, M do
	for k = 1, K do
		for j = 1, N do
			c[i][j] = c[i][j] + a[i][k] * b[k][j]
		end
	end
end

-- Now, the middle loop traverses the row a[i], and the inner loop traverses the row b[k]. Both can use pairs, visiting only the non-zero elements. The initialization of the resulting matrix c is not an issue here, because an empty sparse matrix is naturally filled with zeros.

-- Multiplication of sparse matrices below shows the complete implementation of the above algorithm, using pairs and taking care of sparse entries. This implementation visits only the non-nil elements, and the result is naturally sparse. Moreover, the code deletes resulting entries that by chance evaluate to zero.
function mult (a, b)
	local c = {} -- resulting matrix
	for i = 1, #a do
		local resultline = {} -- will be 'c[i]'
		for k, va in pairs(a[i]) do -- 'va' is a[i][k]
			for j, vb in pairs(b[k]) do -- 'vb' is b[k][j]
				local res = (resultline[j] or 0) + va * vb
				resultline[j] = (res ~= 0) and res or nil
			end
		end
		c[i] = resultline
	end
	return c
end

-- Matrix multiplication application
-- Note: do recall how you do matrix multiplication
-- Define the 3x3 matrix 'a'
local a = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

-- Define the 3x1 matrix 'b'
local b = {
    {2},
    {4},
    {6}
}

-- Helper Function to display a matrix
function printMatrix(matrix)
    for i = 1, #matrix do
        local row = matrix[i]
        local rowStr = ""
        for j = 1, #row do
            rowStr = rowStr .. row[j] .. "\t"
        end
        print(rowStr)
    end
end

-- Call the 'mult' function to multiply 'a' by 'b'
local result = mult(a, b)

-- Display the result
print("Matrix 'a':")
printMatrix(a) --[[
Matrix 'a':
1       2       3
4       5       6
7       8       9
]]

print("\nMatrix 'b':")
printMatrix(b) --[[
Matrix 'b':
2
4
6
]]

print("\nResult of Multiplication (a * b):")
printMatrix(result) --[[
Result of Multiplication (a * b):
28
64
100	
]]