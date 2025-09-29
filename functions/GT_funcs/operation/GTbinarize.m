function GTstruct_bin = GTbinarize(GTstruct, opt)
    arguments
        GTstruct (1, :) struct
        opt.Field {mustBeTextScalar}
        opt.NewField {mustBeTextScalar}
    end
    



%% GTbinarize - Binarizes matix in a GTstruct
%
% GTstruct_bin = GTbinarize(GTstruct, 'Field', 'value', 'NewField', 'value')
% 
% This function binarizes a matrix field from a GTstruct. All positive
% values become 1; zero and negative values become 0. It is commonly used
% after thresholding
%
% Inputs:
%   GTstruct (struct): Struct containing the matrices to binarize
%
%   Field (string, optional): Name of the input field containing the
%   matrix
%
%   NewField (string, optional): Name of the output field for the binarized
%   matrix
%
% Output:
%   GTstruct_bin (struct) Same as input struct, with a new field containing
%   the binarized matrix
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025

%% Parsing Arguments
Field = opt.Field
NewField = opt.NewField

% initialize results
GTstruct_bin = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    Res = GTstruct_bin(iK).(Field) ~= 0 & ~isnan(GTstruct_bin(iK).(Field));
    GTstruct_bin(iK).(NewField) = double(Res);
    % note that numbers are stored as double cause several measures in BCT
    % functions expect numbers
end;


end