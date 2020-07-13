%% GTbinarize(GTstruct, 'InField', value, 'OutField', value)
%
% this function binarize a matrix. Positive values are retained as 1.
% Negative values or zeros, as 0. Usually it is used after the function
% GTthreshold.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - InField: a name with the field containing the matrix on which
%             apply the GTthreshold.
%
% - OutField: a string with the output name for the binarized matrix.
%
%
% OUTPUTS:
%
% GTstruct_bin: the original GTstruct with the addition one field:
%               - OutField (a as argument) the binarized matrix
%               (specified in the InField).
%
% Author: Giorgio Arcara
%
% versione: 7/03/2018


function GTstruct_bin = GTbinarize(GTstruct, varargin)
p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'OutField', [], @ischar);


parse(p, varargin{:});

InField = p.Results.InField;
OutField =  p.Results.OutField;


% initialize results
GTstruct_bin = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    Res = GTstruct_bin(iK).(InField) ~= 0 & ~isnan(GTstruct_bin(iK).(InField));
    GTstruct_bin(iK).(OutField) = double(Res);
    % note that numbers are stored as double cause several measures in BCT
    % functions expect numbers
end;


end