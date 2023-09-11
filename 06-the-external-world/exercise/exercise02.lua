-- Write a Lua program that reads student names and their corresponding scores from a file, calculates their grades, and saves the grades to an output file (could either saved to a json or text file or just output on console).

-- Load the json library (you may need to install it)
-- I'm using the json library from (https://github.com/rxi/json.lua)
-- Credits to RXI for this library
local json = require "json"

-- Function to calculate the grade based on the score
function calculate_grade(score)
    if score >= 90 then
        return "A"
    elseif score >= 80 then
        return "B"
    elseif score >= 70 then
        return "C"
    elseif score >= 60 then
        return "D"
    else
        return "F"
    end
end

-- Read student data from JSON input file
local input_file = "student.json"

-- Insert your code here
