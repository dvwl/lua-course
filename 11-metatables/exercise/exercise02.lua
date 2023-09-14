-- Create a metatable to represent patient records in a healthcare system, allowing for customized operations on patient data.

-- Note: This is just an exercise. Healthcare data should be compliant with HIPAA.

-- Create a metatable patientMeta with metamethods for __index and __newindex to handle patient record access and modification.

-- Define a table patientRecord with the metatable set to patientMeta. The table should store patient information such as name, age, and diagnosis.

-- Implement the __index metamethod to retrieve patient information securely. For example, accessing patientRecord.diagnosis should require authentication.

-- Implement the __newindex metamethod to restrict unauthorized modifications to patient data.

-- Test your implementation by attempting to access and modify patient records, ensuring that the metamethods enforce the desired behavior.

-- Insert your code here


-- Define patient record table with metatable
patientRecord = setmetatable({
    name = "John Doe",
    age = 45,
    diagnosis = "Hypertension"
}, patientMeta)

-- Attempt to access and modify patient data
print(patientRecord.name) -- Access allowed
patientRecord.diagnosis = "Diabetes" -- Unauthorized modification