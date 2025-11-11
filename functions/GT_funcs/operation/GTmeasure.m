function GTres = GTmeasure(GTstruct, opt)
    arguments
        GTstruct (1, :) struct
        opt.Field (1, 1) string
        opt.MeasureFunc (1, 1) string
        opt.MeasureName (1, 1) string
        opt.OutputIndex (1, 1) double = 1
    end
    

%% GTmeasure - Returns a GTstruct with a computed graph measure
% Gtres = GTmeasure(GTstruct, 'Field',value, 'MeasureFunc', value, 'MeasureName', value)
%
% This function calculates a graph theoretical measure using a
% function (typically from the BCT toolbox) specified in MeasureFunc.
% The resulting value is stored in a new field within the GTstruct.
%
% Inputs:
%   GTstruct (struct): A GTstruct object
%
%   Field (string, optional): The name of the field containing the matrix
%   for the graph theoretical measure calculation
%
%   MeasureFunc (string, optional): The name of the function to compute the
%   measure
%
%   MeasureName (string, optional): The name of the new field to strore the
%   computed graph theoretical measure
%
% Output:
%   GTres (struct): The original GTstruct with an additional field named as
%   MeasureName containing the computed graph measure
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025
%

%% Input Parser
Field = opt.Field
MeasureFunc = opt.MeasureFunc
MeasureName = opt.MeasureName
OutputIndex = opt.OutputIndex

% retrieve function
myfunc = str2func(MeasureFunc);

% initialize results
GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    [varargout{1:nargout(myfunc)}] = myfunc(GTstruct(iK).(Field));

    GTres(iK).(MeasureName) = varargout{OutputIndex};
end;


end