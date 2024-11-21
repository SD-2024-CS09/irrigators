addpath(fullfile(pwd, '../../src/sm'));

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.Verbosity;

suite = TestSuite.fromFile(fullfile(pwd, 'sm_test.m'));

runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);

results = runner.run(suite);

disp(results);
