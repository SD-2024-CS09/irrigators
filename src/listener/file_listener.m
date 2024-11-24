filename = 'C:\Users\arvma\sd\irrigators\src\listener\example.json'; % configure path to system

% Check if the file exists
if ~isfile(filename)
    error('File "%s" does not exist. Please provide a valid file.', filename);
else
    disp("Test")
end