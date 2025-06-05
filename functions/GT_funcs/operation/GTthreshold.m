function GTres_thresh = GTthreshold(GTstruct, opt);
    arguments
        GTstruct (1, :) struct
        opt.Field (1, 1) string
        opt.Perc (1, 1) uint32
        opt.NewField (1, 1) string
    end
    





%% GTthreshold - Applies a percentile-based threshold to a matrix
%
% GTres_thresh = GTthreshold(GTstruct, 'Field', 'value', 'Perc', 'value', NewField', 'value')
%
% This function applies a percentile threshold to a field in a GTstruct.
% Values above the specified percentile are retained; all others are set to zero.
%
% Inputs:
%   GTstruct (struct): GTstruct containing the matrix to perform the
%   thresholding operation on
%
%   Field (string, optional): The name of the field to be thresholded
%
%   Perc (uint32, optional): The percentile value used for thresholding
%
%   NewField (string, optional): The name for the new field where the
%   thresholded matrix will be stored
%
% Output:
%   GTres_thresh (struct): GTres_thresh: the same GTstruct with the following additional fields:
%     - Perc: the percentile value used
%     - Thresh: the threshold value computed
%     - NewField: the thresholded matrix (same size as original)
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025





% initialize results
GTres_thresh = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    temp = squeeze(GTstruct(iK).(Field)); % get original matrix % 
    temp = nonzeros(triu(temp, 1)); % get only upper matrix, getting rid of diagonal
    Thresh =  prctile(temp, Perc); % calculate Percentile
    GTres_thresh(iK).(NewField) = threshold_absolute(GTstruct(iK).(Field), Thresh);
    GTres_thresh(iK).thresh = Thresh;
    GTres_thresh(iK).Perc = Perc;

end;


end
