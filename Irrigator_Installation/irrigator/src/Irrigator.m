global wateringStateMachine thingSpeakStateConn;

% Read config files for set up values.
commConfigFile = "/etc/irrigator/comm_config.json";
smConfigFile = "/var/lib/irrigator/sm_config.json";
wateringFile = "/var/lib/irrigator/watering.json";

commConfig = listener.JSONLoader.loadJSON(commConfigFile);
requestValConfig = commConfig.requestSensor;
requestStateConfig = commConfig.requestState;

stateMachineConfig = listener.JSONLoader.loadJSON(smConfigFile);

% Post request handlers for ThingSpeak sensor and state channels channel
thingSpeakValueConn = thingspeakcomm.request.ts_connection(requestValConfig.channelID, requestValConfig.readAPIKey, requestValConfig.writeAPIKey);
thingSpeakStateConn = thingspeakcomm.request.ts_connection(requestStateConfig.channelID, requestStateConfig.readAPIKey, requestStateConfig.writeAPIKey);

% Initialize the StateMachine object
% TODO: If Thingspeak Channel has no values or is unavaliable init to 0
startState = thingSpeakStateConn.readChannel(1);
if startState ~= 1 || startState ~= 0
    startState = 0;
    thingSpeakStateConn.writeChannel(1, 0);
end
wateringStateMachine = statemachine.sm_numerical(startState, str2double(stateMachineConfig.lowerBound), str2double(stateMachineConfig.upperBound));

fileAndServerListener = listener.file_and_service_listener(wateringFile, smConfigFile, thingSpeakValueConn);

webserverFileListenerEvent = addlistener(fileAndServerListener, 'StateChange', @onWebUpdateCallback);
boundsFileListenerEvent = addlistener(fileAndServerListener, 'BoundsChange', @onBoundsUpdateCallback);
thingspeakUpdateValueListenerEvent = addlistener(fileAndServerListener, 'UpdatePulled', @onThingSpeakValueUpdate);

fileAndServerListener.openListener(commConfig.serverComm.wateringReadDelay);


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

function onBoundsUpdateCallback(~, evtData)
global wateringStateMachine;
try
    jsonData = jsondecode(evtData.fileContents);
    if ~isfield(jsonData, 'lowerBound')
        error('Field "lowerBound" not found in the JSON file.');
    end
    if ~isfield(jsonData, 'upperBound')
        error('Field "upperBound" not found in the JSON file.');
    end
    newLower = str2double(jsonData.lowerBound);
    newUpper = str2double(jsonData.upperBound);
    wateringStateMachine.setBounds(newLower, newUpper);
catch ME
    error('Error setting bounds: %s', ME.message);
end
end

function onThingSpeakValueUpdate(~, evtData)
global wateringStateMachine thingSpeakStateConn ;

% Get the current decision from the state machine
data = evtData.tsContents;
decision = wateringStateMachine.makeDecision(data);
current = wateringStateMachine.getCurrentState();
currentChannel = thingSpeakStateConn.readChannel(1);

if currentChannel ~= 0 && currentChannel ~= 1
    warning("Unable to retreive valid machine state from thingspeak, resetting state.");
    thingSpeakStateConn.writeChannel(1, 0);
    return;
end

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


