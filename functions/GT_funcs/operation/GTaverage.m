function GTstruct_res = GTaverage(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.InFields (1,:) string {isfield(GTstruct, opt.InFields)} = requiredvalue
        opt.OtherFields (1,:) string {isfield(GTstruct, opt.OtherFields)} = {}
    end
%% GTaverage(GTstruct, 'InFields', {'value'}, 'OtherFields', {'value'})
%
% This function takes as input a GTstruct and perform the average of the
% data of all elements of the GTstruct in the InFields. The output will be
% a new single GTstruct with the averaged fields and, eventually, the
% OtherFields inherited from the first entry of GTstruct.
%
% Parameters
%   GTstruct (struct): the GTstruct
% 
% Other Parameters:
%   InFields ([str], required): The name of the fields that will be averaged
%   OtherFields ([str]): Other fields to be stored (inherits from the first
%   subject). Default: {}

% Author: Giorgio Arcara
%
% version: 09/06/2020

%% Parsing arguments
InFields = opt.InFields;
OtherFields =  opt.OtherFields;


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
end


