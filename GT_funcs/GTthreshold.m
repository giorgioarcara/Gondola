%% GTthreshold(GTstruct, resfield, perc, thresh_fieldname)
%
% this function apply a threshold to a 
% GTstruct. Currently only percentile thresholds are allowed.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - resfield: a name with the field containing the matrix on which
%             apply the GTthreshold.
% - thresh: the PERCENTILE (e.g., 80) to define the threshold.
%
% - thresh_fieldname: a string with the output name for the thresholded matrix.
%
%
% OUTPUTS:
%
% GTres_thresh: the original GTstruct with the addition two fields:
%               - perc, a field with the threshold applied 
%               - thresh_name (a as argument) the tresholded matrix
%               (specified in the resfield).
%
% Author: Giorgio Arcara
%
% versione: 4/03/2018


function GTres_thresh = GThreshold(GTstruct, resfield, perc, thresh_fieldname)


% initialize results
GTres_thresh = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    temp = squeeze(GTstruct(iK).(resfield)); % get original matrix
    temp = nonzeros(triu(temp, 1)); % get only upper matrix, getting rid of diagonal
    thresh =  prctile(temp, perc); % calculate percentile
    GTres_thresh(iK).(thresh_fieldname) = threshold_absolute(GTstruct(iK).(resfield), thresh);
    GTres_thresh(iK).thresh = thresh;
    GTres_thresh(iK).perc = perc;

end;


end