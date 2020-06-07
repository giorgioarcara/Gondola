%% GTaddvalue(GTstruct, 'OutFieldName', 'value', 'OutValue', [values])
%
% This function takes as input a GTstruct and create a new field with a
% defined values.
% There are two options: either specify one single value (it will be
% applied to all the elements of the GTstruct) or a vector of values.
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
% version: 31/05/2020
%
%

function GTres = GTaddvalue(GTstruct, varargin);

p = inputParser;
addParameter(p, 'OutFieldName', [], @ischar);
checkContent = @(x) isnumeric(x) | iscell(x);
addParameter(p, 'OutValue', [], checkContent);
addParameter(p, 'Elements', [], @isnumeric);

parse(p, varargin{:});
OutFieldName = p.Results.OutFieldName;
OutValue =  p.Results.OutValue;
Elements =  p.Results.Elements;

if (isempty(OutValue))
    error('You must specify the value of the new Field');
end;

if isempty(Elements)
    Elements = 1:length(GTstruct);
    fprintf('GT: Function applied to all elements of the GTstruct\n');
end;


if (length(OutValue)~=1 & length(OutValue)~=length(Elements))
    error('If OutValue is more than 1 value, it should match the length of Elements');
end;




GTres = GTstruct;

% case only, one value is specified.
if length(OutValue)==1
    
    if iscell(OutValue)
        curr_Value = OutValue{1};
    else
        curr_Value =  OutValue(1);
    end;
        
    [GTres(Elements).(OutFieldName)] = deal(curr_Value);
    
end;

% case a vector of Values is specified.
if length(OutValue)>1;
    for iE = 1:length(Elements)
        
        curr_E = Elements(iE);
        
        if iscell(OutValue)
            curr_Value = OutValue{iE};
        else
            curr_Value =  OutValue(iE);
        end;
        GTres(curr_E).(OutFieldName) = curr_Value;
    end
    
end



