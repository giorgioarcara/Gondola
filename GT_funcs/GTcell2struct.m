% GTcell2struct(GTcellres)
%
% This function takes as input a GTstructcell object (cell containing GTstruct
% object) and return a single struct with all objects.
%
% INPUT
% - GTcellres: the GTstruct cell with the results (usually for varying
% thresholds).
%
%
%
% Author: Giorgio Arcara
%
% version: 21/02/2018
%
%

function GTstruct = GTcell2struct(GTcellres);

GTstruct = GTcellres{1};

    for iCell = 2:length(GTcellres)
        GTstruct = [GTstruct, GTcellres{iCell}];
    end;
end

    
        
    

