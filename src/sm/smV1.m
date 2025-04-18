% Define initial conditions and bounds
lowerBound = .1;         % Minimum acceptable water level
upperBound = .2;         % Maximum acceptable water level

% Initialize the StateMachine object
stateMachine = sm(lowerBound, upperBound);

thingSpeakValue = ts_connection(2667716,'RE7V83AT4USIDZN7','6AO4PYC5RM7D1KJX');
thingSpeakDecision = ts_connection(2756308,'OHUMTAKIQY4CC2I7','LEOTSB0DZBX02WH1');
% Set the current water level

% Start the simulation loop
while true
    currentWaterLevel = thingSpeakValue.readChannel(1);
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
        thingSpeakDecision.writeChannel(1,1)
    elseif strcmp(decision, 'Decrease value')
        % Deplete water if in Decrease state
        thingSpeakDecision.writeChannel(1,0)
    end
    
    % Pause for a short duration to simulate time passing
    pause(16);
end