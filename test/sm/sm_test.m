classdef sm_test < matlab.unittest.TestCase
    methods (Test)
        
        % Test constructor with valid bounds
        function testConstructorValidBounds(testCase)
            smObj = sm(0, 10);
            testCase.verifyEqual(smObj.lowerBound, 0);
            testCase.verifyEqual(smObj.upperBound, 10);
            testCase.verifyEqual(smObj.currentState, 'Increase');
        end
        
        % Test constructor with invalid bounds
        function testConstructorInvalidBounds(testCase)
            testCase.verifyError(@() sm(10, 0), ?MException);
        end
        
        % Test updateState method for Increase to Decrease transition
        function testUpdateStateIncreaseToDecrease(testCase)
            smObj = sm(0, 10);
            smObj = smObj.updateState(10);  % Value hits upper bound
            testCase.verifyEqual(smObj.currentState, 'Decrease');
        end
        
        % Test updateState method for Decrease to Increase transition
        function testUpdateStateDecreaseToIncrease(testCase)
            smObj = sm(0, 10);
            smObj = smObj.updateState(10);  % Set state to Decrease
            smObj = smObj.updateState(0);   % Value hits lower bound
            testCase.verifyEqual(smObj.currentState, 'Increase');
        end
        
        % Test getCurrentState method
        function testGetCurrentState(testCase)
            smObj = sm(0, 10);
            state = smObj.getCurrentState();
            testCase.verifyEqual(state, 'Increase');
        end
        
        % Test makeDecision method in Increase state
        function testMakeDecisionIncreaseState(testCase)
            smObj = sm(0, 10);
            decision = smObj.makeDecision();
            testCase.verifyEqual(decision, 'Increase value');
        end
        
        % Test makeDecision method in Decrease state
        function testMakeDecisionDecreaseState(testCase)
            smObj = sm(0, 10);
            smObj = smObj.updateState(10);  % Transition to Decrease
            decision = smObj.makeDecision();
            testCase.verifyEqual(decision, 'Decrease value');
        end
        
        % Test setLower method with valid lower bound
        function testSetLowerValid(testCase)
            smObj = sm(0, 10);
            smObj = smObj.setLower(-5);
            testCase.verifyEqual(smObj.lowerBound, -5);
        end
        
        % Test setLower method with invalid lower bound
        function testSetLowerInvalid(testCase)
            smObj = sm(0, 10);
            testCase.verifyError(@() smObj.setLower(15), ?MException);
        end
        
        % Test setUpper method with valid upper bound
        function testSetUpperValid(testCase)
            smObj = sm(0, 10);
            smObj = smObj.setUpper(15);
            testCase.verifyEqual(smObj.upperBound, 15);
        end
        
        % Test setUpper method with invalid upper bound
        function testSetUpperInvalid(testCase)
            smObj = sm(0, 10);
            testCase.verifyError(@() smObj.setUpper(-5), ?MException);
        end
        
        % Test setBounds method with valid bounds
        function testSetBoundsValid(testCase)
            smObj = sm(0, 10);
            smObj = smObj.setBounds(-10, 20);
            testCase.verifyEqual(smObj.upperBound, 20);
            testCase.verifyEqual(smObj.lowerBound, -10);
        end
        
        % Test setBounds method with invalid bounds
        function testSetBoundsInvalid(testCase)
            smObj = sm(0, 10);
            testCase.verifyError(@() smObj.setBounds(20, -10), ?MException);
        end
    end
end

