classdef sm
    properties
        lowerBound
        upperBound
        currentState
    end
    
    methods
        
        % Constructor to initialize the bounds and set the initial state
        % 
        % Name: sm
        % Purpose: Initialize an instance of the sm class with specified lower and upper bounds, and set the initial state to 'Increase'.
        % Pre: lowerBound < upperBound
        % Post: Object is created with specified bounds and an initial state of 'Increase'
        % Usage: obj = sm(10, 100);
        function obj = sm(lowerBound, upperBound)
            if lowerBound >= upperBound
                error('Lower bound must be less than upper bound.');
            end
            
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.currentState = 'Increase';  % Initialize with Increase state
        end
        
        % Method to update the state based on the current value
        %
        % Name: updateState
        % Purpose: Adjusts the current state based on a given value by switching between 'Increase' and 'Decrease' states.
        % Pre: value is a numeric type
        % Post: currentState is 'Increase' if value <= lowerBound and was in 'Decrease'; 
        %       currentState is 'Decrease' if value >= upperBound and was in 'Increase'
        % Usage: obj = obj.updateState(120);
        function obj = updateState(obj, value)
            switch obj.currentState
                case 'Increase'
                    if value >= obj.upperBound
                        obj.currentState = 'Decrease';
                    end
                case 'Decrease'
                    if value <= obj.lowerBound
                        obj.currentState = 'Increase';
                    end
            end
        end
        
        % Method to get the current state
        %
        % Name: getCurrentState
        % Purpose: Returns the current state of the object ('Increase' or 'Decrease').
        % Pre: None
        % Post: Returns the string 'Increase' or 'Decrease'
        % Usage: state = obj.getCurrentState();
        function state = getCurrentState(obj)
            state = obj.currentState;
        end
        
        % Method to make a decision based on the current state
        %
        % Name: makeDecision
        % Purpose: Provides a decision recommendation based on the current state, suggesting either 'Increase value' or 'Decrease value'.
        % Pre: None
        % Post: Returns 'Increase value' if currentState is 'Increase'; 'Decrease value' if currentState is 'Decrease'
        % Usage: decision = obj.makeDecision();
        function decision = makeDecision(obj)
            switch obj.currentState
                case 'Increase'
                    decision = 'Increase value';
                case 'Decrease'
                    decision = 'Decrease value';
                otherwise
                    decision = 'Unknown state';
            end
        end

        % Setter for lower bound
        %
        % Name: setLower
        % Purpose: Sets a new lower bound if it is less than the current upper bound.
        % Pre: bound < upperBound
        % Post: lowerBound is updated to bound if condition is met; otherwise, an error is raised.
        % Usage: obj = obj.setLower(20);
        function obj = setLower(obj, bound)
            if bound < obj.upperBound
                obj.lowerBound = bound;
            else
                error('Lower bound must be less than upper bound.');
            end
        end

        % Method to set the upper bound 
        %
        % Name: setUpper
        % Purpose: Sets a new upper bound if it is greater than the current lower bound.
        % Pre: bound > lowerBound
        % Post: upperBound is updated to bound if condition is met; otherwise, an error is raised.
        % Usage: obj = obj.setUpper(150);
        function obj = setUpper(obj, bound)
            if bound > obj.lowerBound
                obj.upperBound = bound;
            else
                error('Upper bound must be greater than lower bound.');
            end
        end

        % Method to set both bounds simultaneously with validation
        %
        % Name: setBounds
        % Purpose: Updates both lower and upper bounds, ensuring lower < upper.
        % Pre: upper > lower
        % Post: lowerBound and upperBound are updated; an error is raised if the condition is not met.
        % Usage: obj = obj.setBounds(15, 120);
        function obj = setBounds(obj, lower, upper)
            if upper > lower
                obj.upperBound = upper;
                obj.lowerBound = lower;
            else
                error('Lower bound must be less than upper bound.');
            end
        end
    end
end
