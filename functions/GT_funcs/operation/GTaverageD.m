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

function GTstruct_res = GTaverageD(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.InFields (1,:) string {isfield(GTstruct, opt.InFields)} = requiredvalue
        opt.Dim (1,:) uint32 {mustBeNonempty,mustBeGreaterThan(opt.Dim,0)} = 1
        opt.OutFields (1,:) string = ""
    end
%% GTaverageD(GTstruct, 'InFields', {value}, 'Dim', Value, 'OutFields', {'new_field'}, 'OtherFields', {'value'})
%
% This function takes as input a GTstruct and perfom the average of the
% values in the 'InFields', along the dimension 'Dim'. The result is stored
% in 'OutFields'.
%
% Parameters:
%   GTstruct: the GTstruct
%
% Other Parameters:
%   InFields ([str], required): The name of the fields containing the matrix whose dimension
%             will be averaged
%   Dim ([int]): the dimension to be averaged.
%   OutFields ([str]): the name of the Field that will be created (can overwrite
%              existing fields)
% - OtherFields: other fields to be stored (inherits from the first subject)
%
%
%
% Author: Giorgio Arcara
%
% version: 09/06/2020
%% Parsing arguments

InFields = opt.InFields;
Dim = opt.Dim;
OutFields = opt.OutFields;

%% Check input
Dim = mustBeValidDimension(GTstruct, InFields, Dim);
OutFields = mustBeValidOutFields(OutFields, InFields);

%% Do average
% intialize from original object
GTstruct_res = GTstruct;

for iE = 1:length(GTstruct)
    
    for iField = 1:length(InFields)
        
        curr_data = GTstruct(iE).(InFields{iField});
        
        GTstruct_res(iE).(OutFields{iField}) = squeeze(mean(curr_data, Dim(iField)));
        
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
