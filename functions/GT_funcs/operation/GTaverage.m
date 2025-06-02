function GTstruct_res = GTaverage(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.Fields (1,:) string {isfield(GTstruct, opt.InFields)} = requiredvalue
        opt.OtherFields (1,:) string {isfield(GTstruct, opt.OtherFields)} = {}
    end
%% GTaverage - Averages fields across a GTstruct array
%
% GTstruct_res = GTaverage(GTstruct, 'Fields', {'field1', 'field2'}, 'OtherFields', {'subject'})
% 
% This function takes a GTstruct array and computes the average of the specified
% fields across all entries. The result is a single GTstruct with the averaged
% fields and any additional fields inherited from the first struct.
%
% Inputs:
%   GTstruct (struct): GTstruct object
%
%   Fields (string, optional): Names of the fields to average
%
%   OtherFields (string, optional): Names of other fields to retain from
%   the original GTstrut
%
% Output: 
%   GTstruct_res (struct): A new struct object with averaged values in the
%   specified fields and other fields copied from the original struct
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 28/05/2025


if ~isempty(OtherFields)
    % first copy all the other fields (from the first subject)
    for iF = OtherFields
        GTstruct_res.(iF{1}) = GTstruct(1).(iF{1});
    end
    warning('OtherFields have been copied from the first element of the GTstruct')
    
end

for iField = 1:length(Fields)
    
    % This code is used to avoid a loop over all elements of the GTstruct.
    all_data_mat = [GTstruct.(Fields{iField})];
    
    % use the first object as reference to get the sizes
    all_data_mat_r = reshape(all_data_mat, size(GTstruct(1).(Fields{iField}), 1), size(GTstruct(1).(Fields{iField}), 2), size(GTstruct(1).(Fields{iField}), 3), length(GTstruct));
    
    GTstruct_res.(Fields{iField}) = mean(all_data_mat_r, length(size(all_data_mat_r)));
    
end
end


