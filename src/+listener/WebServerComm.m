global wateringStateMachine thingSpeakUpdateStateRequest;
% Read config files for set up values.
thingSpeakCommConfigFile = "tsconfig.json";
stateMachineConfigFile = "smconfig.json";
serverConfigFile = "servercommconfig.json";

thingSpeakCommConfig = JSONtoObj(thingSpeakCommConfigFile);
requestStateConfig = thingSpeakCommConfig.requestState;

stateMachineConfig = JSONtoObj(stateMachineConfigFile);

webserverCommConfig = JSONtoObj(serverConfigFile);

% Set up MQTT Clients and Post Request Handlers for Thingspeak
% Communication

% Post request handlers for ThingSpeak sensor and state channels channel
thingSpeakUpdateStateRequest = thingspeakcomm.request.ts_connection(requestStateConfig.channelID, requestStateConfig.readAPIKey, requestStateConfig.writeAPIKey);

% Initialize the StateMachine object
wateringStateMachine = statemachine.sm_numerical(stateMachineConfig.initalState, stateMachineConfig.lowerBound, stateMachineConfig.upperBound);

webserverFileListener = listener.file_listener(webserverCommConfig.fileHandle);
webserverFileListenerEvent = addlistener(webserverFileListener, 'StateChange', @onWebUpdateCallback);
webserverFileListener.openListener(webserverCommConfig.readDelay);

% Reads a Json file passed by file name into an object with JSON values as
% properties.
function newObj = JSONtoObj(jsonFile)
f = fopen(jsonFile);
raw_text = fread(f);
json = char(raw_text');
newObj = jsondecode(json);
fclose(f);
end

function onWebUpdateCallback(~, evtData)
% Checks that data from the server file update is in the correct json format
try
    jsonData = jsondecode(evtData.fileContents);
    if ~isfield(jsonData, 'watering')
        error('Field "watering" not found in the JSON file.');
    end
    value = jsonData.watering;
    updateState(value);
catch ME
    error('Error reading JSON file: %s', ME.message);
end
end

% Update both the local state machine and the ThingSpeak channel with new
% value
function updateState(newState)
global wateringStateMachine thingSpeakUpdateStateRequest;
wateringStateMachine = wateringStateMachine.updateState(newState);
thingSpeakUpdateStateRequest.writeChannel(1, newState);
end
