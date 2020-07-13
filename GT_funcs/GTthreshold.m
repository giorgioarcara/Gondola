%% GTthreshold(GTstruct, 'InField', 'value', 'Perc', 'value', 'ThreshFieldName', "value")
%
% this function apply a threshold to a 
% GTstruct. Currently only Percentile thresholds are allowed.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - InField: a cell with the name of the field containing the matrix on which
%             apply the GTthreshold.
% - Perc: the PercENTILE (e.g., 80) to define the threshold.
%
% - ThreshFieldName: a string with the output name for the thresholded matrix.
%
%
% OUTPUTS:
%
% GTres_thresh: the original GTstruct with the addition two fields:
%               - Perc: a field with the percentile value
%               - Thresh: a field threshold applied
%               - thresh_name (a as argument) the tresholded matrix
%               (specified in the InField).
%
% Author: Giorgio Arcara
%
% versione: 4/03/2018


function GTres_thresh = GTthreshold(GTstruct, varargin);

p = inputParser;
addParameter(p, 'InField', [], @ischar);
addParameter(p, 'Perc', [], @isnumeric);
addParameter(p, 'ThreshFieldName', [], @ischar);
parse(p, varargin{:});

InField = p.Results.InField;
Perc =  p.Results.Perc;
ThreshFieldName =  p.Results.ThreshFieldName;



% initialize results
GTres_thresh = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    temp = squeeze(GTstruct(iK).(InField)); % get original matrix % 
    temp = nonzeros(triu(temp, 1)); % get only upper matrix, getting rid of diagonal
    Thresh =  prctile(temp, Perc); % calculate Percentile
    GTres_thresh(iK).(ThreshFieldName) = threshold_absolute(GTstruct(iK).(InField), Thresh);
    GTres_thresh(iK).thresh = Thresh;
    GTres_thresh(iK).Perc = Perc;

end;


end
