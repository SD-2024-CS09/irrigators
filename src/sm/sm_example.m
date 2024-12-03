% Define initial conditions and bounds
initialWaterLevel = 15;  % Initial water level (within bounds)
lowerBound = 10;         % Minimum acceptable water level
upperBound = 20;         % Maximum acceptable water level
depletionRate = 0.5;     % Rate at which water depletes per iteration
refillAmount = 5;        % Amount of water added when refilling

% Initialize the StateMachine object
stateMachine = sm(lowerBound, upperBound);

thingSpeakConnection = ts_connection(2667716,'RE7V83AT4USIDZN7','6AO4PYC5RM7D1KJX');

% Set the current water level
currentWaterLevel = initialWaterLevel;

% Start the simulation loop
while true
    % Update the state based on the current water level
    stateMachine = stateMachine.updateState(currentWaterLevel);
    
    % Get the current decision from the state machine
    decision = stateMachine.makeDecision();
    
    % Display the current water level, state, and decision
    fprintf('Water Level: %.2f, State: %s, Decision: %s\n', ...
        currentWaterLevel, stateMachine.getCurrentState(), decision);
    
    % Act based on the decision
    if strcmp(decision, 'Increase value')
        % Refill water if in Increase state
        currentWaterLevel = currentWaterLevel + refillAmount;
        fprintf('Refilling water. New Water Level: %.2f\n', currentWaterLevel);
        ThingSpeakConnection.writeChannel(2,1)
    elseif strcmp(decision, 'Decrease value')
        % Deplete water if in Decrease state
        currentWaterLevel = currentWaterLevel - depletionRate;
        thingSpeakConnection.writeChannel(2,0)
    end
    

    % Pause for a short duration to simulate time passing
    pause(5);
end