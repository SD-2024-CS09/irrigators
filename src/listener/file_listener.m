filename = 'C:\Users\arvma\sd\irrigators\src\listener\example.json'; % configure path to system

% checks if the file exists
if ~isfile(filename)
    error('File "%s" does not exist. Please provide a valid file.', filename);
end

% reads the latest watering status value in the JSON file
try
    jsonData = jsondecode(fileread(filename));
    if ~isfield(jsonData, 'watering')
        error('Field "watering" not found in the JSON file.');
    end
    lastWateringValue = jsonData.watering;
    fprintf('Initial watering status: %d\n', lastWateringValue);
catch ME
    error('Error reading JSON file: %s', ME.message);
end