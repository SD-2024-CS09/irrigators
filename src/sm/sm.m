classdef sm
    properties
        lowerBound
        upperBound
        currentState
    end
    
    methods
        % Constructor to initialize the bounds and set the initial state
        function obj = sm(lowerBound, upperBound)
            if lowerBound >= upperBound
                error('Lower bound must be less than upper bound.');
            end
            
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.currentState = 'Increase';  % Initialize with Increase state
        end
        
        % Method to update the state based on the current value
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
        function state = getCurrentState(obj)
            state = obj.currentState;
        end
        
        % Method to make a decision based on the current state
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

        % Setters for bounds with validation
        function obj = setLower(obj, bound)
            if bound < obj.upperBound
                obj.lowerBound = bound;
            else
                error('Lower bound must be less than upper bound.');
            end
        end

        function obj = setUpper(obj, bound)
            if bound > obj.lowerBound
                obj.upperBound = bound;
            else
                error('Upper bound must be greater than lower bound.');
            end
        end

        function obj = setBounds(obj, upper, lower)
            if upper > lower
                obj.upperBound = upper;
                obj.lowerBound = lower;
            else
                error('Lower bound must be less than upper bound.');
            end
        end
    end
end