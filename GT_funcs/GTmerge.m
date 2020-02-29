% StructMerge(struct1, struct2)
%
% This function merge two structs. It assumes that the structs have
% the same number of elements that refers to the same observations.
% The fields of the second struct will be added to the first
%
%
% INPUT
% - struct1: the first struct to be merged
% - struct2: the second struct to be merged
%
%
% Author: Giorgio Arcara
%
% version: 29/08/2018
%
%

function GTstruct = GTmerge(GTstruct1, GTstruct2);

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



