classdef state_request_handler
    properties
        stateMachine
        requestHandler
    end

    methods
        function obj = state_request_handler(stateMachine, requestHandler)
            obj.stateMachine = stateMachine;
            obj.requestHandler = requestHandler;
        end

        % Callback to run on receiving new data from Thingspeak MQQT Broker for
        % value channels
        function updateMachineOnData(obj, ~, data)
            % Get the current decision from the state machine
            decision = obj.stateMachine.makeDecision(data);
            if decision ~= obj.stateMachine.currentState()
                success = obj.requestHandler.writeChannel(1, decision);
                if success
                    obj.stateMachine.updateState(decision);
                end
            end
        end
    end
end