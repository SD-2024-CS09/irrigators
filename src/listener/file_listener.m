jsonFile = 'C:\Users\arvma\sd\irrigators\src\listener\example.json'; % configure path to system

% checks if the file exists
if ~isfile(jsonFile)
    error('File "%s" does not exist. Please provide a valid file.', jsonFile);
end

% reads the latest watering status value in the JSON file
try
    jsonData = jsondecode(fileread(jsonFile));
    if ~isfield(jsonData, 'watering')
        error('Field "watering" not found in the JSON file.');
    end
    lastWateringValue = jsonData.watering;
    fprintf('Initial watering status: %d\n', lastWateringValue);
catch ME
    error('Error reading JSON file: %s', ME.message);
end

% file listener loop

while true 
    pause(5) % check every 5 seconds
    
    jsondecode(fileread(jsonFile)); % refresh the data
    wateringValue = jsonData.watering;
    if wateringValue ~= lastWateringValue 
        lastWateringValue = wateringValue; % update the watering status when needed
        disp("change in watering status")
    end

end


