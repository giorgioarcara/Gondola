% GTaverage(GTres, resfield, varargin)
%
% This function takes as input a GTres object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTres: the GTres struct with the results
% - resfields: the name of the fields that will be averaged
% - otherfields: otherfields to be stored (inherits from the first subject)
%
% NOTE: the function some all the values and then divide by the numebrs
%       so missing values can lead to wrong resuls
%
%
% Author: Giorgio Arcara
%
% version: 04/03/2018
%
%

function Ave = GTaverage(GTres, resfields, varargin);

if nargin < 2
    error('2 inputs are mandatory')
elseif nargin == 3
    % first copy all the other fields (from the first subject)
    for fn = varargin{1}
        Ave.(fn{1}) = GTres(1).(fn{1});
    end
    
end

for iField = 1:length(resfields)
    
    all_data_mat = [GTres.(resfields{iField})];
    
    % use the first object as reference to get the sizes. and
    all_data_mat_r = reshape(all_data_mat, size(GTres(1).(resfields{iField}), 1), size(GTres(1).(resfields{iField}), 2), length(GTres));
    
    Ave.(resfields{iField}) = mean(all_data_mat_r, length(size(all_data_mat_r)));
    
end



