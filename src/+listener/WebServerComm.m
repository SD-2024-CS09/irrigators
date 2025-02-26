global wateringStateMachine thingSpeakStateConn thingSpeakValueConn;
% Read config files for set up values.
thingSpeakCommConfigFile = "tsconfig.json";
stateMachineConfigFile = "smconfig.json";
serverConfigFile = "servercommconfig.json";

% thingSpeakCommConfig = JSONtoObj(thingSpeakCommConfigFile);
% requestStateConfig = thingSpeakCommConfig.requestState;

% stateMachineConfig = JSONtoObj(stateMachineConfigFile);

% webserverCommConfig = JSONtoObj(serverConfigFile);

% Set up MQTT Clients and Post Request Handlers for Thingspeak
% Communication

% Post request handlers for ThingSpeak sensor and state channels channel
% thingSpeakUpdateStateRequest = thingspeakcomm.request.ts_connection(requestStateConfig.channelID, requestStateConfig.readAPIKey, requestStateConfig.writeAPIKey);

thingSpeakValueConn = thingspeakcomm.request.ts_connection(2667716,'RE7V83AT4USIDZN7','6AO4PYC5RM7D1KJX');
thingSpeakStateConn = thingspeakcomm.request.ts_connection(2756308,'OHUMTAKIQY4CC2I7','LEOTSB0DZBX02WH1');

% Initialize the StateMachine object
% wateringStateMachine = statemachine.sm_numerical(stateMachineConfig.initalState, stateMachineConfig.lowerBound, stateMachineConfig.upperBound);
%wateringStateMachine = statemachine.sm_numerical(thingSpeakStateConn.readChannel(1), .1, .2);
wateringStateMachine = statemachine.sm_numerical(thingSpeakStateConn.readChannel(1), .1, .2);

fileAndServerListener = listener.file_and_service_listener('/var/irrilog/wateringstat.json', thingSpeakValueConn);
webserverFileListenerEvent = addlistener(fileAndServerListener, 'StateChange', @onWebUpdateCallback);
thingspeakUpdateValueListenerEvent = addlistener(fileAndServerListener, 'UpdatePulled', @onThingSpeakValueUpdate);
fileAndServerListener.openListener(5);


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
    value = str2num(jsonData.watering);
    updateState(value);
catch ME
    error('Error reading JSON file: %s', ME.message);
end
end

function onThingSpeakValueUpdate(~, evtData)
global wateringStateMachine thingSpeakStateConn ;

% Get the current decision from the state machine
data = evtData.tsContents;
decision = wateringStateMachine.makeDecision(data);
current = wateringStateMachine.getCurrentState();
currentChannel = thingSpeakStateConn.readChannel(1);

% Act based on the decision
if current ~= decision
    wateringStateMachine = wateringStateMachine.updateState(decision); 
end

if currentChannel ~= decision
    % Refill water if in Increase state
    thingSpeakStateConn.writeChannel(1, decision)
end
end



% Update both the local state machine and the ThingSpeak channel with new
% value
function updateState(newState)
global wateringStateMachine thingSpeakStateConn;
wateringStateMachine = wateringStateMachine.updateState(newState);
thingSpeakStateConn.writeChannel(1, newState);
end


