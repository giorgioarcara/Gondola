%% GTaverageD(GTstruct, 'InFields', {value}, 'Dim', Value, 'OutFields', {'new_field'}, 'OtherFields', {'value'})
%
% This function takes as input a GTstruct and perfom the average of the
% matrix in the 'DataField', along the dimension 'Dim' (1 2 or 3).
%
% INPUT
% - GTstruct: the GTstruct (either CMstruct or TSstruct)
% - InFields: the name of the fields containing the matrix whose dimension
%             will be averaged
% - Dim: the dimension (1, 2, 3) to be averaged.
% - OutFields : the name of the Field that will be created (can overwrite
%              existing fields)
% - OtherFields: other fields to be stored (inherits from the first subject)
%
%
%
% Author: Giorgio Arcara
%
% version: 09/06/2020
%
%

function GTstruct_res = GTaverageD(GTstruct, varargin);

p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'Dim', [], @isnumeric);
addParameter(p, 'OutFields', {'new_field'}, @iscell);
addParameter(p, 'OtherFields', [], @iscell);

parse(p, varargin{:});
InFields = p.Results.InFields;
Dim = p.Results.Dim;
OutFields = p.Results.OutFields;
OtherFields =  p.Results.OtherFields;

% intialize from original object
GTstruct_res = GTstruct;

for iE = 1:length(GTstruct)
    
    for iField = 1:length(InFields)
        
        curr_data = GTstruct(iE).(InFields{iField});
        
        GTstruct_res(iE).(OutFields{iField}) = squeeze(mean(curr_data, Dim));
        
    end    
    
end;    
