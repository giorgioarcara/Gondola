%% GTAvgrage(GTstruct, 'ResField', 'value', 'OtherFields', 'value')
%
% This function takes as input a GTstruct object (object with results from an analysis
% with a script like BCT_analysis.m) and compute the average of the
% matrices in a field.
%
% INPUT
% - GTstruct: the GTstruct struct with the results
% - ResField: the name of the fields that will be averaged
% - OtherFields: other fields to be stored (inherits from the first subject)
%
% NOTE: the function some all the values and then divide by the numbers
%       so missing values can lead to wrong resuls
%
%
% Author: Giorgio Arcara
%
% version: 04/03/2018
%
%

function Avg = GTAvgrage(GTstruct, varargin);

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'OtherFields', [], @ischar);

parse(p, varargin{:});
ResField = p.Results.ResField;
OtherFields =  p.Results.OtherFields

if nargin < 2
    error('2 inputs are mandatory')
elseif nargin == 3
    % first copy all the other fields (from the first subject)
    for fn = varargin{1}
        Avg.(fn{1}) = GTstruct(1).(fn{1});
    end
    
end

for iField = 1:length(ResField)
    
    all_data_mat = [GTstruct.(ResField{iField})];
    
    % use the first object as reference to get the sizes. and
    all_data_mat_r = reshape(all_data_mat, size(GTstruct(1).(ResField{iField}), 1), size(GTstruct(1).(ResField{iField}), 2), length(GTstruct));
    
    Avg.(ResField{iField}) = mean(all_data_mat_r, length(size(all_data_mat_r)));
    
end



