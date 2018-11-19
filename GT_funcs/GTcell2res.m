% GTcell2struct(GTcellres)
%
% This function takes as input a GTrescell object (cell containing GTres
% object) and return a single struct with all objects.
%
% INPUT
% - GTrescell: the GTres cell with the results (usually for varying
% thresholds).
%
%
%
% Author: Giorgio Arcara
%
% version: 21/02/2018
%
%

function GTres = GTcell2struct(GTcellres);

GTres = GTcellres{1};

    for iCell = 2:length(GTcellres)
        GTres = [GTres, GTcellres{iCell}];
    end;
end

    
        
    

