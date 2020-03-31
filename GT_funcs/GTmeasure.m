%% GTmeasure(GTstruct, 'ResField',value, 'MeasureFunc', value, 'MeasureName', value)
%
% this function calculates a GT measure (via a function specified as
% MeasureFunc) and store in the results.
% The results will be a GTstruct containing all the information of the
% original plus the newly calculated GT measure.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - ResField: a name with the field containing the matrix on which
%             calculate the GT measure.
% - MeasureFunc: the function (typically from the BCT toolbox) to
%                 calculate the measure.
% - MeasureName: the name of the new measure (it will be the name of the
%                  field in the output).
% - opts : options, if necessary for gt measure.
%
% Author: Giorgio Arcara
%
% versione: 4/03/2018



function GTres = GTmeasure(GTstruct, varargin)

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'MeasureFunc', [], @isstring);
addParameter(p, 'MeasureName', [], @ischar);


parse(p, varargin{:});

ResField = p.Results.ResField;
MeasureFunc =  p.Results.MeasureFunc;
MeasureName =  p.Results.MeasureName;

% retrieve function
myfunc = str2func(MeasureFunc);

% initialize results
GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    GTres(iK).(MeasureName) = myfunc(GTstruct(iK).(ResField));
end;


end