-- Create a Lua program that simulates a queue data structure using a table. Implement the following operations for the queue:
-- enqueue(value): Add an element to the end of the queue.
-- dequeue(): Remove and return the element from the front of the queue.
-- isEmpty(): Check if the queue is empty.

-- Test your queue implementation with sample data.

-- Extension: You may try to implement a LIFO queue / stack as well.

-- Insert your code here

-- Test the queue operations
enqueue(queue, 1)
enqueue(queue, 2)
enqueue(queue, 3)

print("Dequeue:", dequeue(queue)) -- Should print "Dequeue: 1"
print("Dequeue:", dequeue(queue)) -- Should print "Dequeue: 2"
print("Is Empty:", isEmpty(queue)) -- Should print "Is Empty: false"
