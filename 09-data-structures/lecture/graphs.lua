--[[ Graphs ]]
-- Like any decent language, Lua allows multiple implementations for graphs, each one better adapted to some particular algorithms. Here we will see a simple object-oriented implementation, where we represent nodes as objects (actually tables, of course) and arcs as references between nodes.

-- We will represent each node as a table with two fields: name, with the node's name; and adj, with the set of nodes adjacent to this one. Because we will read the graph from a text file, we need a way to find a node given its name. So, we will use an extra table mapping names to nodes. Given a name, function name2node returns the corresponding node:
local function name2node (graph, name)
	local node = graph[name]
	if not node then
		-- node does not exist; create a new one
		node = {name = name, adj = {}}
		graph[name] = node
	end
	return node
end

-- Below shows the function that builds a graph
function readgraph ()
	local graph = {}
	for line in io.lines() do
		-- split line in two names
		local namefrom, nameto = string.match(line, "(%S+)%s+(%S+)")
		-- find corresponding nodes
		local from = name2node(graph, namefrom)
		local to = name2node(graph, nameto)
		-- adds 'to' to the adjacent set of 'from'
		from.adj[to] = true
	end
	return graph
end

-- It reads a file where each line has two node names, meaning that there is an arc from the first node to the second. For each line, the function uses string.match to split the line in two names, finds the nodes corresponding to these names (creating the nodes if needed), and connects the nodes.

-- Below illustrates an algorithm to find a path between two nodes in a graph.
function findpath (curr, to, path, visited)
	path = path or {}
	visited = visited or {}
	if visited[curr] then -- node already visited?
		return nil -- no path here
	end
	visited[curr] = true -- mark node as visited
	path[#path + 1] = curr -- add it to path
	if curr == to then -- final node?
		return path
	end
	-- try all adjacent nodes
	for node in pairs(curr.adj) do
		local p = findpath(node, to, path, visited)
		if p then return p end
	end
	table.remove(path) -- remove node from path
end

-- The function findpath searches for a path between two nodes using a depth-first traversal. Its first parameter is the current node; the second is its goal; the third parameter keeps the path from the origin to the current node; the last parameter is a set with all the nodes already visited, to avoid loops. Note how the algorithm manipulates nodes directly, without using their names. For instance, visited is a set of nodes, not of node names. Similarly, path is a list of nodes.

-- To test this code, we add a function to print a path and some code to put it all to work:
function printpath (path)
	for i = 1, #path do
		print(path[i].name)
	end
end

-- Graph application (a social network example)
-- Define the graph structure for the social network
local socialNetwork = {}

-- Function to add a friendship connection between two individuals
function addFriendship(graph, person1, person2)
    local node1 = name2node(graph, person1)
    local node2 = name2node(graph, person2)
    node1.adj[node2] = true
    node2.adj[node1] = true -- Friendship is bidirectional
end

-- Function to check if two individuals are friends
function areFriends(graph, person1, person2)
    local node1 = graph[person1]
    local node2 = graph[person2]
    return node1 and node2 and node1.adj[node2]
end
	
-- Create a social network graph
addFriendship(socialNetwork, "Alice", "Bob")
addFriendship(socialNetwork, "Bob", "Charlie")
addFriendship(socialNetwork, "Alice", "Eve")
addFriendship(socialNetwork, "Eve", "David")

-- Function to find a path between two friends
function findFriendshipPath(graph, person1, person2)
    local node1 = graph[person1]
    local node2 = graph[person2]
    if not node1 or not node2 then
        return nil -- One of the persons does not exist
    end
    return findpath(node1, node2)
end

-- Find a path between two friends in the social network
local person1 = "Alice"
local person2 = "Charlie"
local path = findFriendshipPath(socialNetwork, person1, person2)

-- Print the path (if it exists)
if path then
    print("Path between " .. person1 .. " and " .. person2 .. ":")
    printpath(path)
else
    print(person1 .. " and " .. person2 .. " are not connected in the social network.")
end
