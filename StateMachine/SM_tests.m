% Define initial conditions and bounds
initialWaterLevel = 15;  % Initial water level (within bounds)
lowerBound = 10;         % Minimum acceptable water level
upperBound = 20;         % Maximum acceptable water level
depletionRate = 0.5;     % Rate at which water depletes per iteration
refillAmount = 5;        % Amount of water added when refilling

% Initialize the StateMachine object
sm = StateMachine(lowerBound, upperBound);

% Set the current water level
currentWaterLevel = initialWaterLevel;

% Start the simulation loop
while true
    % Deplete the water level
    currentWaterLevel = currentWaterLevel - depletionRate;
    
    % Update the state based on the current water level
    sm = sm.updateState(currentWaterLevel);
    
    % Get the current decision from the state machine
    decision = sm.makeDecision();
    
    % Display the current water level and state decision
    fprintf('Water Level: %.2f, State: %s, Decision: %s\n', ...
        currentWaterLevel, sm.getCurrentState(), decision);
    
    % Act based on the decision
    if strcmp(decision, 'Increase value')
        % Refill water if below lower bound
        currentWaterLevel = currentWaterLevel + refillAmount;
        fprintf('Refilling water. New Water Level: %.2f\n', currentWaterLevel);
    end
    
    % Pause for a short duration to simulate time passing
    pause(1);
end
