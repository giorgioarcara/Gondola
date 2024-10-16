classdef GTaddvalue_Test < GondolaTest
    
    properties
        % Here test parameters
        data_folder = fullfile(fileparts(which('GondolaTest')), 'test_data', 'dlmread');
        GTstruct(1,10) = struct;
    end
    
    methods(Test)
        % Test methods
        function emptyInField(testCase)

            f_handle = @() GTaddvalue(testCase.GTstruct);

            diagnostic = sprintf("InField should be mandatory input");

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function InFieldWithSpaces(testCase)

            field_w_spaces = 'test field with spaces';
            GTres = GTaddvalue(testCase.GTstruct,'InField',field_w_spaces,'NewValue',1);

            field_wout_spaces = 'test_field_with_spaces';

            testOk = zeros(1,length(GTres));

            for iGT = 1:length(GTres)
                testRes = GTres(iGT).(field_wout_spaces) == 1;
                testOk(iGT) = testRes;
            end

            allTestOk = all(testOk);

            diagnostic = sprintf("We expected to have the spaces removed from the field");

            testCase.verifyTrue(allTestOk,diagnostic)

        end

        function InFieldWithSpecialChars(testCase)

            field_w_special = 'test!?*[]{}123={}|\';
            GTres = GTaddvalue(testCase.GTstruct,'InField',field_w_special,'NewValue',1);

            field_wout_special = 'test123';

            testOk = zeros(1,length(GTres));

            for iGT = 1:length(GTres)
                testRes = GTres(iGT).(field_wout_special) == 1;
                testOk(iGT) = testRes;
            end

            allTestOk = all(testOk);

            diagnostic = sprintf("The only allowed special char is _");

            testCase.verifyTrue(allTestOk,diagnostic)

        end

        function InFieldBeginsWithNumber(testCase)

            field = '1test';
            f_handle = @() GTaddvalue(testCase.GTstruct,'InField',field,'NewValue',1);

            diagnostic = sprintf("It should not accept fields that start with a number");

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function InFieldTooLong(testCase)

            field_long = char(ones(1,100)*97);
            f_handle = @() GTaddvalue(testCase.GTstruct,'InField',field_long,'NewValue',1);


            diagnostic = sprintf("Field is (probably) truncated, but we should raise an error");

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function emptyNewValue(testCase)

            f_handle = @() GTaddvalue(testCase.GTstruct,'InField','test');

            diagnostic = sprintf("NewValue should be mandatory input");

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function wrongLength(testCase)

            f_handle = @() GTaddvalue(testCase.GTstruct,'InField','test', 'NewValue', [1,1]);

            diagnostic = sprintf("GTstruct is length %d, but NewValue is length 2", length(testCase.GTstruct));

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function singleValue(testCase)

            GTres = GTaddvalue(testCase.GTstruct,'InField','test','NewValue',1);

            testOk = zeros(1,length(GTres));

            for iGT = 1:length(GTres)
                testRes = GTres(iGT).test == 1;
                testOk(iGT) = testRes;
            end

            allTestOk = all(testOk);
            
            diagnostic = sprintf("Single value is not replicated in all the structs");

            testCase.verifyTrue(allTestOk, diagnostic)

        end

        function multipleValues(testCase)

            newValue = 1:length(testCase.GTstruct);
            GTres = GTaddvalue(testCase.GTstruct,'InField','test','NewValue',newValue);

            testOk = zeros(1,length(GTres));

            for iGT = 1:length(GTres)
                testRes = GTres(iGT).test == newValue(iGT);
                testOk(iGT) = testRes;
            end

            allTestOk = all(testOk);
            
            diagnostic = sprintf("Multiple values are not stored correctly in the structs");

            testCase.verifyTrue(allTestOk, diagnostic)

        end

        function testElements(testCase)

            newValue = 1:3;
            GTres = GTaddvalue(testCase.GTstruct,'InField','test','NewValue',newValue,'Elements',1:3);

            testOk = zeros(1,length(GTres));

            for iGT = 1:length(GTres)
                if iGT <= 3
                    testRes = GTres(iGT).test == newValue(iGT);
                else
                    testRes = isempty(GTres(iGT).test);
                end
                testOk(iGT) = testRes;
            end

            allTestOk = all(testOk);
            
            diagnostic = sprintf("Values are not addedd correctly to some elements");

            testCase.verifyTrue(allTestOk, diagnostic)


        end

        function ValueElementsDifferentLength(testCase)

            newValue = 1:3;
            f_handle = @() GTaddvalue(testCase.GTstruct,'InField','test','NewValue',newValue,'Elements',1);

            diagnostic = sprintf("We are adding 3 values to one single element");

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

        function ElementsOutOfRange(testCase)

            f_handle = @() GTaddvalue(testCase.GTstruct,'InField','test','NewValue',1,'Elements',100);

            diagnostic = sprintf("GTstruct is length %d, but we add something at index 100", length(testCase.GTstruct));

            testCase.verifyError(f_handle,?MException,diagnostic)

        end

    end
    
end