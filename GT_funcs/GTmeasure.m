%% GTmeasure(GTstruct, resfield, measure_func, measure_name)
%
% this function calculates a GT measure (via a function specified as
% measure_func) and store in the results.
% The results will be a GTstruct containing all the information of the
% original plus the newly calculated GT measure.
%
% INPUTS:
%
% - GTstruct: a GTstruct
% - resfield: a name with the field containing the matrix on which
%             calculate the GT measure.
% - measure_func: the function (typically from the BCT toolbox) to
%                 calculate the measure.
% - measure_name: the name of the new measure (it will be the name of the
%                  field in the output).
% - opts : options, if necessary for gt measure.
%
% Author: Giorgio Arcara
%
% versione: 4/03/2018



function GTres = GTmeasure(GTstruct, resfield, measure_func, measure_name)

% retrieve function
myfunc = str2func(measure_func);

% initialize results
GTres = GTstruct;

% loop over all objects in GTstruct and compute the measure.
for iK = 1:length(GTstruct)
    GTres(iK).(measure_name) = myfunc(GTstruct(iK).(resfield));
end;


end