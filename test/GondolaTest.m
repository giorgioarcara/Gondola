classdef (Abstract) GondolaTest < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        % Shared setup for the entire test class
        function startGondola(testCase)
            % add to path gondola
            test_folder = fileparts(which('GondolaTest'));
            gondola_path = fullfile(test_folder, '..');
            addpath(gondola_path);
            % start gondola
            gondola;
        end
    end
    
    methods(TestClassTeardown)
        % Setup for each test
        function removeGondola(testCase)
            gondola('remove');
        end
    end
    
end