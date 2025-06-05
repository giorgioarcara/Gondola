%% GTaddvalue - Creates a new field with the specified values. 
% This function takes as input a GTstruct and creates a new field with the
% specified values.
% You can either:
%   - specify one single value to be applied to all elements of the
%   GTstruct
%   - provide a vector of values that will be assigned only to the GTstruct
%     elements specified in 'Elements'.
%
% Inputs:
%   GTstruct (struct): GTstruct object containing the results
%   
%   Field (string array, optional): String indicating the name of the new
%   field. Default: 'new_val'
%
%   NewValue (any, optional): the value(s) to assign. Can be a single value
%   or a vector. 
%
%   Elements (int, optional): Indices of GTstruct elements to modify.
%   Default: 1:length(GTstruct)
%
% Output:
%   GTstruct_out (struct): Modified GTstruct with the new field added
% 
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 20/05/2025
%
%
%
function GTstruct_out = GTaddvalue(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.Field (1,1) string {mustBeValidVariableName} = "new_val"
        opt.NewValue (1,:) {mustBeNonempty,mustBeShorter(opt.NewValue, GTstruct)}
        opt.Elements (1,:) uint32 {mustBeIndex(opt.Elements, GTstruct)} = 1:length(GTstruct)
    end

%% Parsing arguments
Field = opt.Field;
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
        
    [GTstruct_out(Elements).(Field)] = deal(curr_Value);
    
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
        GTstruct_out(curr_E).(Field) = curr_Value;
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
