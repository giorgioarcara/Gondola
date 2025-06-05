function GTstruct = GTmerge(GTstruct1, GTstruct2)
    arguments
        GTstruct1 (1, :) struct
        GTstruct2 (1, :) struct
    end




%% GTMerge - merges two GTstruct objects field-wise
%
% GTstruct = GTmerge(GTstruct1, GTstruct2)
%
% This function merges two GTstruct objects by appending all fields from 
% GTstruct2 to GTstruct1. It assumes that both structs have the same number 
% of elements and correspond to the same observations.
%
% Inputs
%   GTstruct1 (struct): The base GTstruct object
%   GTstruct2 (struct): The GTstruct object whose fields will be added to GTstruct1
%
% Output:
%   GTstruct (struct): A new struct where each element includes fields from
%   both inputs
%
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% version: 28/05/2025
%
%


if nargin < 2
    error('2 inputs are mandatory')
end

if (length(GTstruct1) ~= length(GTstruct2))
    error('The two structs must have the same length');
end;

FieldNames = fieldnames(GTstruct2);

GTstruct1_table = struct2table(GTstruct1);
GTstruct2_table = struct2table(GTstruct2);

GTstruct_table = [GTstruct1_table, GTstruct2_table];

GTstruct = table2struct(GTstruct_table);

    
end



