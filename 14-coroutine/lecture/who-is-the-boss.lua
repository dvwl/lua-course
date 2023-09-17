--[[ Who is the Boss? ]]
-- One of the most paradigmatic examples of coroutines is the producer–consumer problem. Let us suppose that we have a function that continually produces values (e.g., reading them from a file) and another function that continually consumes these values (e.g., writing them to another file). These two functions could look like this:
function producer ()
	while true do
		local x = io.read() -- produce new value
		send(x) -- send it to consumer
	end
end
 
function consumer ()
	while true do
		local x = receive() -- receive value from producer
		io.write(x, "\n") -- consume it
	end
end

-- (To simplify this example, both the producer and the consumer run forever. It is not hard to change them to stop when there is no more data to handle.) The problem here is how to match send with receive. It is a typical instance of the “who-has-the-main-loop” problem. Both the producer and the consumer are active, both have their own main loops, and both assume that the other is a callable service. For this particular example, it is easy to change the structure of one of the functions, unrolling its loop and making it a passive agent. However, this change of structure may be far from easy in other real scenarios.

-- Coroutines provide an ideal tool to match producers and consumers without changing their structure, because a resume–yield pair turns upside-down the typical relationship between the caller and its callee. When a coroutine calls yield, it does not enter into a new function; instead, it returns a pending call (to resume). Similarly, a call to resume does not start a new function, but returns a call to yield. This property is exactly what we need to match a send with a receive in such a way that each one acts as if it were the master and the other the slave. (That is why I called this the "who-is-the-boss" problem.) So, receive resumes the producer, so that it can produce a new value; and send yields the new value back to the consumer:
function receive ()
	local status, value = coroutine.resume(producer)
	return value
end

function send (x)
	coroutine.yield(x)
end

-- Of course, the producer must now run inside a coroutine:
producer = coroutine.create(producer)

-- In this design, the program starts by calling the consumer. When the consumer needs an item, it resumes the producer, which runs until it has an item to give to the consumer, and then stops until the consumer resumes it again. Therefore, we have what we call a consumer-driven design. Another way to write the program is to use a producer-driven design, where the consumer is the coroutine. Although the details seem reversed, the overall idea of both designs is the same.

-- We can extend this design with filters, which are tasks that sit between the producer and the consumer doing some kind of transformation in the data. A filter is a consumer and a producer at the same time, so it resumes a producer to get new values and yields the transformed values to a consumer. As a trivial example, we can add to our previous code a filter that inserts a line number at the beginning of each line. The code below shows "Producer–consumer with filters".
function receive (prod)
	local status, value = coroutine.resume(prod)
	return value
end

function send (x)
	coroutine.yield(x)
end

function producer ()
	return coroutine.create(function ()
		while true do
			local x = io.read() -- produce new value
			send(x)
		end
	end)
end

function filter (prod)
	return coroutine.create(function ()
		for line = 1, math.huge do
			local x = receive(prod) -- get new value
			x = string.format("%5d %s", line, x)
			send(x) -- send it to consumer
		end
	end)
end

function consumer (prod)
	while true do
		local x = receive(prod) -- get new value
		io.write(x, "\n") -- consume new value
	end
end

consumer(filter(producer()))

-- Its last line simply creates the components it needs, connects them, and starts the final consumer.

-- If you thought about POSIX pipes after reading the previous example, you are not alone. After all, coroutines are a kind of (non-preemptive) multithreading. With pipes, each task runs in a separate process; with coroutines, each task runs in a separate coroutine. Pipes provide a buffer between the writer (producer) and the reader (consumer) so there is some freedom in their relative speeds. This is important in the context of pipes, because the cost of switching between processes is high. With coroutines, the cost of switching between tasks is much smaller (roughly equivalent to a function call), so the writer and the reader can run hand in hand.
