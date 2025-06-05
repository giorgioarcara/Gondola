function GTstruct_res = GTaverageD(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.Fields (1,:) string {isfield(GTstruct, opt.Fields)} = requiredvalue
        opt.Dim (1,:) uint32 {mustBeNonempty,mustBeGreaterThan(opt.Dim,0)} = 1
        opt.NewField (1,:) string = ""
        opt.OtherFields (1, :) string
    end




%% GTaverageD - Averages field values across specified dimensions
%
% GTstruct_res = GTaverageD(GTstruct, 'InFields', ["field1"], 'Dim', 3, ...
%                                        'OutFields', ["field1_avg"], ...
%                                        'OtherFields', ["subject"]);
%
% This function takes a GTstruct array and averages the content of the
% specified fields along the provided dimension (1, 2, or 3). The resulting
% averaged fields are stored under new field names (or overwrite the old ones).
%
% Inputs:
%   GTstruct (struct): GTstruct object
%
%   Fields (string, optional): Fields whose values will be averaged
%
%   Dim (uint32, optional): The dimension over which to perform the
%   averaging
%
%   NewField (string, optional): New field names to store the averages.
%   Must match the number of Fields.
%
%   Otherfields (string, optional): Names of the fields to be retained from
%   the original GTstruct
%
% Output.
%   GTstruct_res (struct): A new struct object with averaged values in the
%   specified fields and other fields copied from the original struct
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 28/05/2025


%% Check input
Dim = mustBeValidDimension(GTstruct, Fields, Dim);
NewF
ield = mustBeValidOutFields(NewField, Fields);

%% Do average
% intialize from original object
GTstruct_res = GTstruct;

for iE = 1:length(GTstruct)
    
    for iField = 1:length(Fields)
        
        curr_data = GTstruct(iE).(Fields{iField});
        
        GTstruct_res(iE).(NewField{iField}) = squeeze(mean(curr_data, Dim(iField)));
        
    end    
    
end
end

%% Validation functions
function dim = mustBeValidDimension(GTstruct, infields, dim)
    if length(dim) > 1
        dim = repmat(dim, size(infields));
    end
    if length(dim) ~= length(infields)
        eid = "GTinput:wrongLength";
        msg = "Length of dimensions must be 1 or the same length of input fields ("+length(infields)+")";
        error(eid,msg)
    end
    dim_ok = arrayfun(@(x) dim(x) <= ndims(GTstruct(1).(infields{x})), 1:length(dim));
    if ~all(dim_ok)
        eid = "GTinput:mismatchDimension";
        msg = "Selected dimensions are out of range for input fields";
        error(eid,msg)
    end
end

function out = mustBeValidOutFields(out,in)
    if strlength(out) == 0
        out = in + "_avg";
    end
    if length(out) ~= length(in)
        eid = "GTinput:wrongLength";
        msg = "Length of output fields must be the same length of input fields ("+length(infields)+")";
        error(eid,msg)
    end
    valid_names = arrayfun(@(x) isvarname(x), out);
    if ~all(valid_names)
        eid = "GTinput:nameNotValid";
        msg = "Output fields must be valid variable names (starting with letters, not containing special characters)";
        error(eid,msg)
    end
end
