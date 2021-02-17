%% GToperation2(GTstruct1, GTstruct2, 'InFields',value,'OtherFields', value, 'operation', 'GTres=GT1-GT2')
%
% This function takes as input two GTstructs a perform an 'operation' involging the two matrices.
% the operation  can be any legal Matlab operation between matrices.
%
%
% INPUT
% - GTstruct1: the first GTstruct struct with the results
% - GTstruct2: the second GTstruct struct with the results
% - InFields: the name of the fields that will be subtracted between(GTstruct1 -
% GTstruct2)between {} brackets
% - OtherFields: the other fields to be kept between {} brackets
% - operation: a text that will be evaluated to compute some operations
% with two matrices.It should expressed as GTres = 'some operation'
%
%
%
%
%
% Author: Giorgio Arcara
%
% version: 19/05/2020
%
%


function GTstruct = GToperation2(GTstruct1, GTstruct2, varargin)

p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'OtherFields', [], @iscell);
addParameter(p, 'operation', 'GTres=GT1-GT2', @ischar);
parse(p, varargin{:});


InFields = p.Results.InFields;
OtherFields =  p.Results.OtherFields;
operation = p.Results.operation;

GTstruct = struct();

if (exist('OtherFields')&~isempty('OtherFields'))
    % first copy all the other fields
    for fn = OtherFields
        for isubj = 1:length(GTstruct1);
            GTstruct(isubj).(fn{1}) = GTstruct1(isubj).(fn{1});
        end
    end
end


% now load the data
for k=1:length(GTstruct1);
    for iField = 1:length(InFields);
        GT1 = GTstruct1(k).(InFields{iField}) ;
        GT2 = GTstruct2(k).(InFields{iField});
        eval([operation,';'])
        GTstruct(k).(InFields{iField}) = GTres;
    end;
    
end;
fprintf(['\n\n - Operation performed: ', operation, '\n'] );
warning('Be sure that the two GTstructs have the objects in the correct order!')




% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





