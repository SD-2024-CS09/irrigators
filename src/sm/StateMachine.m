classdef StateMachine
    properties
        lowerBound
        upperBound
        currentState
    end
    
    methods
        % Constructor to initialize the bounds and set the initial state
        function obj = StateMachine(lowerBound, upperBound)
            if lowerBound >= upperBound
                error('Lower bound must be less than upper bound.');
            end
            
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.currentState = 'Within Bounds';  % Initialize with a neutral state
        end
        
        % Method to update the state based on the input value
        function obj = updateState(obj, value)
            if value < obj.lowerBound
                obj.currentState = 'Below Lower Bound';
            elseif value > obj.upperBound
                obj.currentState = 'Above Upper Bound';
            else
                obj.currentState = 'Within Bounds';
            end
        end
        
        % Method to get the current state
        function state = getCurrentState(obj)
            state = obj.currentState;
        end
        
        % Params N/A
        % returns the decision based on state
        function decision = makeDecision(obj)
            switch obj.currentState
                case 'Below Lower Bound'
                    decision = 'Increase value';
                case 'Above Upper Bound'
                    decision = 'Decrease value';
                case 'Within Bounds'
                    decision = 'Value is within acceptable range';
                otherwise
                    decision = 'Unknown state';
            end
        end

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


