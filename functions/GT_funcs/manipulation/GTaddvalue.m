function GTstruct_out = GTaddvalue(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.InField (1,1) string {mustBeValidVariableName} = "new_val"
        opt.NewValue (1,:) {mustBeNonempty,mustBeShorter(opt.NewValue, GTstruct)}
        opt.Elements (1,:) uint32 {mustBeIndex(opt.Elements, GTstruct)} = 1:length(GTstruct)
    end
%% GTaddvalue(GTstruct, 'InField', 'value', 'NewValue', [values], 'Elements', [values])
%
% This function takes as input a GTstruct and create a new field with a
% the specified values.
% There are two options: either specify one single value (it will be
% applied to all the elements of the GTstruct) or a vector of values that will replace
% the GTstruct elements specified in 'Elements'.
%
% Parameters:
%   GTstruct (struct): the GTstruct struct with the results
%
% Other Parameters:
%   InField (str): A string indicating the name of the new field. Default: 'new_val'
%   NewValue ([any]): The value to initialize the new field.
%   Elements ([int]): The index of the elements of the GTstruct with the
%   new value. Default: 1:length(GTstruct)

% Author: Giorgio Arcara
%
% version: 09/06/2020
%

%% Parsing arguments
InField = opt.InField;
NewValue =  opt.NewValue;
Elements =  opt.Elements;

%% Check input
mustBeOneOrSameLength(NewValue, Elements)

%% Clean InField
GTstruct_out = GTstruct;

% case only, one value is specified.
if length(NewValue)==1
    
    if iscell(NewValue)
        curr_Value = NewValue{1};
    else
        curr_Value =  NewValue(1);
    end;
        
    [GTstruct_out(Elements).(InField)] = deal(curr_Value);
    
end;

% case a vector of Values is specified.
if length(NewValue)>1;
    for iE = 1:length(Elements)
        
        curr_E = Elements(iE);
        
        if iscell(NewValue)
            curr_Value = NewValue{iE};
        else
            curr_Value =  NewValue(iE);
        end;
        GTstruct_out(curr_E).(InField) = curr_Value;
    end
    
end

end

%% Validation functions
function mustBeShorter(val, GTstruct)
lenStruct = length(GTstruct);

if length(val) > lenStruct
    eid = "GTinput:wrongLength";
    msg = "Length of new value must shorter than input GTstruct ("+lenStruct+")";
    error(eid,msg)
end
end

function mustBeIndex(idx, GTstruct)
lenStruct = length(GTstruct);
% Check duplicated index
if length(idx)~=length(unique(idx))
    eid = "GTinput:duplicatedIndex";
    msg = "Elements index cannot have duplicated values";
    error(eid,msg)
end
% Check index out of range
if any(idx > lenStruct) || any(idx <= 0)
    eid = "GTinput:wrongIndex";
    msg = "Some of the index are out of range";
    error(eid,msg)
end
end

function mustBeOneOrSameLength(val,idx)
if length(val)~=1 && length(val)~=length(idx)
    eid = "GTinput:wrongIndex";
    msg = "Length of index and length of values must be the same";
    error(eid,msg)
end
end
