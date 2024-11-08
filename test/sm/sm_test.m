classdef sm_test < matlab.unittest.TestCase
    methods (Test)
        
        % Test constructor with valid bounds
        function testConstructorValidBounds(testCase)
            sm = sm(0, 10);
            testCase.verifyEqual(sm.lowerBound, 0);
            testCase.verifyEqual(sm.upperBound, 10);
            testCase.verifyEqual(sm.currentState, 'Increase');
        end
        
        % Test constructor with invalid bounds
        function testConstructorInvalidBounds(testCase)
            testCase.verifyError(@() sm(10, 0), ?MException);
        end
        
        % Test updateState method for Increase to Decrease transition
        function testUpdateStateIncreaseToDecrease(testCase)
            sm = sm(0, 10);
            sm = sm.updateState(10);  % Value hits upper bound
            testCase.verifyEqual(sm.currentState, 'Decrease');
        end
        
        % Test updateState method for Decrease to Increase transition
        function testUpdateStateDecreaseToIncrease(testCase)
            sm = sm(0, 10);
            sm = sm.updateState(10);  % Set state to Decrease
            sm = sm.updateState(0);   % Value hits lower bound
            testCase.verifyEqual(sm.currentState, 'Increase');
        end
        
        % Test getCurrentState method
        function testGetCurrentState(testCase)
            sm = sm(0, 10);
            state = sm.getCurrentState();
            testCase.verifyEqual(state, 'Increase');
        end
        
        % Test makeDecision method in Increase state
        function testMakeDecisionIncreaseState(testCase)
            sm = sm(0, 10);
            decision = sm.makeDecision();
            testCase.verifyEqual(decision, 'Increase value');
        end
        
        % Test makeDecision method in Decrease state
        function testMakeDecisionDecreaseState(testCase)
            sm = sm(0, 10);
            sm = sm.updateState(10);  % Transition to Decrease
            decision = sm.makeDecision();
            testCase.verifyEqual(decision, 'Decrease value');
        end
        
        % Test setLower method with valid lower bound
        function testSetLowerValid(testCase)
            sm = sm(0, 10);
            sm = sm.setLower(-5);
            testCase.verifyEqual(sm.lowerBound, -5);
        end
        
        % Test setLower method with invalid lower bound
        function testSetLowerInvalid(testCase)
            sm = sm(0, 10);
            testCase.verifyError(@() sm.setLower(15), ?MException);
        end
        
        % Test setUpper method with valid upper bound
        function testSetUpperValid(testCase)
            sm = sm(0, 10);
            sm = sm.setUpper(15);
            testCase.verifyEqual(sm.upperBound, 15);
        end
        
        % Test setUpper method with invalid upper bound
        function testSetUpperInvalid(testCase)
            sm = sm(0, 10);
            testCase.verifyError(@() sm.setUpper(-5), ?MException);
        end
        
        % Test setBounds method with valid bounds
        function testSetBoundsValid(testCase)
            sm = sm(0, 10);
            sm = sm.setBounds(20, -10);
            testCase.verifyEqual(sm.upperBound, 20);
            testCase.verifyEqual(sm.lowerBound, -10);
        end
        
        % Test setBounds method with invalid bounds
        function testSetBoundsInvalid(testCase)
            sm = sm(0, 10);
            testCase.verifyError(@() sm.setBounds(-10, 20), ?MException);
        end
    end
end

