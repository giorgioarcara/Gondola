%% GTztransf(GTstruct, resfield, z_name)
%
% this function perform the Fisher z-transformation on correlation matrices

% INPUTS:
%
% - GTstruct: a GTstruct
% - resfield: a name with the field containing the matrix on which
%             calculate the GT measure.
% - measure_name: the name of the output field with z_score. If empty is
% "z_transf".
%
% NOTE: this measure should be used only with Correlation matrices (for
% example from Amplitude Envelope Correlation.
%
%
% Author: Giorgio Arcara
%
% versione: 16/11/2018

function GTres = GTztransf(GTstruct, resfield, z_name)

GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    GTres(iK).(z_name) = arrayfun(@z_transf, GTstruct(iK).(resfield));
end;

end


function z = z_transf(r)

z = 0.5.*(log(1+r) - log(1-r));

end
