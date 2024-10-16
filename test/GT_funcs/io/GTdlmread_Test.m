classdef GTdlmread_Test < GondolaTest
    
    properties
        % Here test parameters
        data_folder = fullfile(fileparts(which('GondolaTest')), 'test_data', 'dlmread');
    end
    
    methods(Test)
        % Test methods
        function loadSingleFile(testCase)
            test_data = fullfile(testCase.data_folder, 'matrices_1_file');
            file_names = get_file_names(test_data);
            
            GTstruct = GTdlmread(file_names);
            
            num_struct = length(GTstruct);

            diagnostic = sprintf("There are %d loaded struct, expected 1", num_struct);

            testCase.verifyEqual(length(GTstruct),1,diagnostic);
        end

        function loadMultipleFiles(testCase)
            test_data = fullfile(testCase.data_folder, 'matrices_3_files');
            file_names = get_file_names(test_data);
            
            GTstruct = GTdlmread(file_names);
            
            num_struct = length(GTstruct);

            diagnostic = sprintf("There are %d loaded struct, expected 3", num_struct);

            testCase.verifyEqual(length(GTstruct),3,diagnostic);
        end

        function loadEmptyFile(testCase)
            test_data = fullfile(testCase.data_folder, 'matrices_empty_file');
            file_names = get_file_names(test_data);
            
            GTstruct = GTdlmread(file_names);
            
            testCase.verifyFail("Unimplemented test");
        end

        function loadWrongFormat(testCase)
            test_data = fullfile(testCase.data_folder, 'matrices_wrong_format');
            file_names = get_file_names(test_data);
            
            GTstruct = GTdlmread(file_names);
            
            testCase.verifyFail("Unimplemented test");
        end

        function loadNotNumeric(testCase)
            test_data = fullfile(testCase.data_folder, 'matrices_not_numeric');
            file_names = get_file_names(test_data);
            
            GTstruct = GTdlmread(file_names);
            
            testCase.verifyFail("Unimplemented test");
        end
    end
    
end