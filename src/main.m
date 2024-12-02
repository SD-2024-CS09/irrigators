% Decalre global values that are needed in callbacks
global wateringStateMachine thingSpeakUpdateStateRequest;

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

% MQTT client for ThingSpeak sensor channels
thingSpeakMQTTClient = initMQTTClientFromConfig(mqttConfig, updateMachineOnMQTTCallback);

% Post request handlers for ThingSpeak sensor and state channels channel
thingSpeakSensorRequest = ts_connection(requestSensorConfig.channelID, requestSensorConfig.readAPIKey, requestSensorConfig.writeAPIKey);
thingSpeakUpdateStateRequest = ts_connection(requestStateConfig.channelID, requestStateConfig.readAPIKey, requestStateConfig.writeAPIKey);

% Initialize the StateMachine object
wateringStateMachine = statemachine.sm(stateMachineConfig.initalState, stateMachineConfig.lowerBound, stateMachineConfig.upperBound);

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
    newMqttClient = mqttclient(config.broker_url,Port=config.port,ClientID=cargs.client_id,Username=config.username,Password=config.password);
    topics = convertCharsToStrings(cargs.subscription_topics)';
    for topic = topics
        subscribe(newMqttClient, topic, "Callback", @mqttCallback);
    end
end

% Callback to run on receiving new data from Thingspeak MQQT Broker for
% value channels
function success = updateMachineOnMQTTCallback(topic, data)
    % Get the current decision from the state machine
    global wateringStateMachine thingSpeakUpdateStateRequest;
    decision = wateringStateMachine.makeDecision();
    if decision ~= wateringStateMachine.currentState()
        success = thingSpeakUpdateStateRequest.writeChannel(1, decision);
        if success
            wateringStateMachine.updateState(decision);
        end
    end
end