%% GTaverage(GTstruct, 'InFields', {value}, 'OtherFields', 'value')
%
% This function takes as input a GTstruct and perform the average of the
% data of all elements of the GTstruct in the InFields.
%
% INPUT
% - GTstruct: the GTstruct (either CMstruct or TSstruct)
% - InFields: the name of the fields that will be averaged
% - OtherFields: other fields to be stored (inherits from the first subject)
%
%
% Author: Giorgio Arcara
%
% version: 09/06/2020
%
%

function GTstruct_res = GTaverage(GTstruct, varargin);

p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'OtherFields', [], @iscell);

parse(p, varargin{:});
InFields = p.Results.InFields;
OtherFields =  p.Results.OtherFields;

if ~isempty(OtherFields)
    % first copy all the other fields (from the first subject)
    for iF = OtherFields
        GTstruct_res.(iF{1}) = GTstruct(1).(iF{1});
    end
    warning('OtherFields have been copied from the first element of the GTstruct')
    
end

for iField = 1:length(InFields)
    
    % This code is used to avoid a loop over all elements of the GTstruct.
    all_data_mat = [GTstruct.(InFields{iField})];
    
    % use the first object as reference to get the sizes
    all_data_mat_r = reshape(all_data_mat, size(GTstruct(1).(InFields{iField}), 1), size(GTstruct(1).(InFields{iField}), 2), size(GTstruct(1).(InFields{iField}), 3), length(GTstruct));
    
    GTstruct_res.(InFields{iField}) = mean(all_data_mat_r, length(size(all_data_mat_r)));
    
end



