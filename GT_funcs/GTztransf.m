%% GTztransf(GTstruct, 'ResField', value, 'zName', value)
%
% this function perform the Fisher z-transformation on correlation matrices

% INPUTS:
%
% - GTstruct: a GTstruct
% - ResField: the name with the field containing the matrix on which
%             calculate the GT measure.
% - zName: the name of the output field with z_score. If empty is
% 'z_transf'.
%
% NOTE: this measure should be used only with Correlation matrices (for
% example from Amplitude Envelope Correlation.
%
%
% Author: Giorgio Arcara
%
% versione: 16/11/2018

function GTres = GTztransf(GTstruct, varargin)
p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'zName', [], @ischar);

parse(p, varargin{:});

ResField = p.Results.ResField;
zName =  p.Results.zName;

if nargin < 2
    error('2 inputs are mandatory: the GTstruct and the ResFields')
elseif nargin ==2
    zName = 'z_transf';
else
    zName = varargin{2};
end

    

GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    GTres(iK).(zName) = arrayfun(@z_transf, GTstruct(iK).(ResField));
end;

end


function z = z_transf(r)

z = 0.5.*(log(1+r) - log(1-r));

end
