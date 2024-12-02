% Read config files for set up values.
thingSpeakCommConfigFile = "tsconfig.json";
stateMachineConfigFile = "smconfig.json";
serverUpdateFile = "webserverpipe.json";

thingSpeakCommConfig = JSONtoObj(thingSpeakCommConfigFile);
mqttConfig = thingSpeakCommConfig.mqttSensor;
requestSensorConfig = thingSpeakCommConfig.requestSensor;
requestStateConfig = thingSpeakCommConfig.requestState;

stateMachineConfig = JSONtoObj(stateMachineConfigFile);

% Set up MQTT Clients and Post Request Handlers for Thingspeak
% Communication

% Post request handlers for ThingSpeak sensor and state channels channel
thingSpeakSensorRequest = thingspeakcomm.request.ts_connection(requestSensorConfig.channelID, requestSensorConfig.readAPIKey, requestSensorConfig.writeAPIKey);
thingSpeakUpdateStateRequest = thingspeakcomm.request.ts_connection(requestStateConfig.channelID, requestStateConfig.readAPIKey, requestStateConfig.writeAPIKey);

% Initialize the StateMachine object
wateringStateMachine = statemachine.sm(stateMachineConfig.initalState, stateMachineConfig.lowerBound, stateMachineConfig.upperBound);

% MQTT client for ThingSpeak sensor channels
updateWaterCallback = @(topic, data)updateMachineOnMQTTCallback(topic, data, wateringStateMachine, thingSpeakUpdateStateRequest);
thingSpeakMQTTClient = initMQTTClientFromConfig(mqttConfig, updateWaterCallback);

% Reads a Json file passed by file name into an object with JSON values as
% properties.
function newObj = JSONtoObj(jsonFile)
    f = fopen(jsonFile);
    raw_text = fread(f);
    json = char(raw_text');
    newObj = jsondecode(json);
    fclose(f);
end

% Initializes and returns a MQTT client subscribed to the channels in the
% specfied config.
function newMqttClient = initMQTTClientFromConfig(config, mqttCallback)
    newMqttClient = mqttclient(config.brokerURL,Port=config.port,ClientID=config.clientID,Username=config.username,Password=config.password);
    topics = convertCharsToStrings(config.topics)';
    for topic = topics
        subscribe(newMqttClient, topic, "callback", mqttCallback);
    end
end

% Callback to run on receiving new data from Thingspeak MQQT Broker for
% value channels
function updateMachineOnMQTTCallback(~, data, uStateMachine, requestHandler)
    % Get the current decision from the state machine
    decision = uStateMachine.makeDecision(data);
    if decision ~= uStateMachine.currentState()
        success = requestHandler.writeChannel(1, decision);
        if success
            uStateMachine.updateState(decision);
        end
    end
end