%% GTbinarize(GTstruct, resfield, bin_fieldname)
%
% this function binarize a matrix. Positive values are retained as 1.
% Negative values or zeros, as 0. Usually it is used after the function
% GTthreshold.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - resfield: a name with the field containing the matrix on which
%             apply the GTthreshold.
%
% - bin_fieldname: a string with the output name for the binarized matrix.
%
%
% OUTPUTS:
%
% GTres_bin: the original GTstruct with the addition one field:
%               - bin_fieldname (a as argument) the binarized matrix
%               (specified in the resfield).
%
% Author: Giorgio Arcara
%
% versione: 7/03/2018


function GTres_bin = GTbinarize(GTstruct, resfield, bin_fieldname)


% initialize results
GTres_bin = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    GTres_bin(iK).(bin_fieldname) = double(GTres_bin(iK).(resfield) > 0);
    % note that numbers are stored as double cause several measures in BCT
    % functions expect numbers
end;


end