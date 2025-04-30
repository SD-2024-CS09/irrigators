% Functionally sm- but with numerical values 1 and 0 returned as the state
% instead of "increasing" and "decreasing" in order to be compatable with
% webserver IPC

classdef sm_numerical < handle
    properties
        lowerBound
        upperBound
        currentState
    end

    properties(Constant)
        smMax = 1;
        smMin = 0;
    end

    
    methods
        
        % Constructor to initialize the bounds and set the initial state
        % 
        % Name: sm
        % Purpose: Initialize an instance of the sm class with specified lower and upper bounds and initial state.
        % Pre: lowerBound < upperBound
        % Post: Object is created with specified bounds and inital state
        % Usage: obj = sm(10, 100, 0);
        function obj = sm_numerical(initialState, lowerBound, upperBound)
            if initialState ~= 1 && initialState ~= 0
                initialState = 0;
            end
            if lowerBound >= upperBound
                error('Lower bound must be less than upper bound.');
            end

            if lowerBound < obj.smMin
                error("Lower bound %d is below range [%d, %d]", lowerBound, obj.smMin, obj.smMax);
            end


            if upperBound >obj.smMax
                error("Upper bound %d is above range [%d, %d]", upperBound, obj.smMin, obj.smMax);
            end
            
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.currentState = initialState;  % Initialize with Increase state
        end
        
        % Method to update the state based on the current value
        %
        % Name: updateState
        % Purpose: Adjusts the current state based on a given value by switching between 'Increase' and 'Decrease' states.
        % Pre: value is a numeric type
        % Post: currentState is 1 if value <= lowerBound and was in 0
        %       currentState is 0 if value >= upperBound and was in 1
        % Usage: obj = obj.updateState(120);
        function obj = updateState(obj, newState)
            obj.currentState = newState;
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
        % Purpose: Provides a decision recommendation based on the current state, suggesting either 1 for Increase value or 0 for Decrease value.
        % Pre: None
        % Post: Returns 0 if value is above upper bounds; 1 if value is
        % below lower bounds. If value is in bounds, current state will be
        % returned.
        % Usage: decision = obj.makeDecision();
        function decision = makeDecision(obj, value)
            switch obj.currentState
                case 1
                    if value >= obj.upperBound
                        decision = 0;
                        return;
                    end
                case 0
                    if value <= obj.lowerBound
                        decision = 1;
                        return;
                    end
            end
            decision = obj.currentState;
        end

        % Setter for lower bound
        %
        % Name: setLower
        % Purpose: Sets a new lower bound if it is less than the current upper bound.
        % Pre: bound < upperBound
        % Post: lowerBound is updated to bound if condition is met; otherwise, an error is raised.
        % Usage: obj = obj.setLower(20);
        function obj = setLower(obj, bound)
            if bound > obj.upperBound
                error('Lower bound must be less than upper bound.');
            end

            if bound < obj.smMin
                error("Lower bound %d is below range [%d, %d]", bound, obj.smMin, obj.smMax);
            end

            obj.lowerBound = bound;

        end

        % Method to set the upper bound 
        %
        % Name: setUpper
        % Purpose: Sets a new upper bound if it is greater than the current lower bound.
        % Pre: bound > lowerBound
        % Post: upperBound is updated to bound if condition is met; otherwise, an error is raised.
        % Usage: obj = obj.setUpper(150);
        function obj = setUpper(obj, bound)
            if obj.lowerBound > bound
                error('Lower bound must be less than upper bound.');
            end

            if bound > obj.smMax
                error("Upper bound %d is above range [%d, %d]", bound, obj.smMin, obj.smMax);
            end

            obj.upperBound = bound;
        end

        % Method to set both bounds simultaneously with validation
        %
        % Name: setBounds
        % Purpose: Updates both lower and upper bounds, ensuring lower < upper.
        % Pre: upper > lower
        % Post: lowerBound and upperBound are updated; an error is raised if the condition is not met.
        % Usage: obj = obj.setBounds(15, 120);
        function obj = setBounds(obj, lower, upper)
            obj.setUpper(upper);
            obj.setLower(lower);
        end
    end
end
