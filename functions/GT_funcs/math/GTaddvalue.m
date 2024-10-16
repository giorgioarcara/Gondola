%% GTaddvalue(GTstruct, 'InField', 'value', 'NewValue', [values], 'Elements', [values])
%
% This function takes as input a GTstruct and create a new field with a
% the specified values.
% There are two options: either specify one single value (it will be
% applied to all the elements of the GTstruct) or a vector of values that will replace
% the GTstruct elements specified in 'Elements'.
%
%
% INPUT
% - GTstruct: the GTstruct struct with the results
% - ResField: a string with the
% - ResValue: the value to be applied to the ResField (can be a single value of elements)
% - Elements: a vector with the elements whose value should be
%
%
%
% Author: Giorgio Arcara
%
% version: 09/06/2020
%
%

function GTstruct_res = GTaddvalue(GTstruct, varargin)
%% Parsing arguments
p = inputParser;
checkInput = @(x) ischar(x) & length(x)<=63; 
addParameter(p, 'InField', [], checkInput);
checkContent = @(x) isnumeric(x) | iscell(x);
addParameter(p, 'NewValue', [], checkContent);
addParameter(p, 'Elements', [], @isnumeric);

parse(p, varargin{:});
InField = p.Results.InField;
NewValue =  p.Results.NewValue;
Elements =  p.Results.Elements;

%% Check input
if (isempty(InField))
    error('You must specify the name of the new Field');
elseif InField(1)
end;

if (isempty(NewValue))
    error('You must specify the value of the new Field');
end;

if isempty(Elements)
    Elements = 1:length(GTstruct);
    fprintf('GT: Function applied to all elements of the GTstruct\n');
end;


if (length(NewValue)~=1 && length(NewValue)~=length(Elements))
    error('If NewValue is more than 1 value, it should match the length of Elements');
end;

%% Clean InField
% Remove starting and final spaces
InField = strip(InField);
% Substitute spaces with _
InField = strrep(InField, ' ', '_');
% Remove special characters
allowed_ascii_chars = [ ...
    48:57, ... % From 0 to 9
    65:90, ... % From A to Z
    95, ... % _
    97:122 % From a to z
    ];
InFieldAscii = double(InField);

isAllowedAscii = ismember(InFieldAscii, allowed_ascii_chars);
InFieldAsciiClean = InFieldAscii(isAllowedAscii);
InField = char(InFieldAsciiClean);


GTstruct_res = GTstruct;

% case only, one value is specified.
if length(NewValue)==1
    
    if iscell(NewValue)
        curr_Value = NewValue{1};
    else
        curr_Value =  NewValue(1);
    end;
        
    [GTstruct_res(Elements).(InField)] = deal(curr_Value);
    
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
        GTstruct_res(curr_E).(InField) = curr_Value;
    end
    
end



