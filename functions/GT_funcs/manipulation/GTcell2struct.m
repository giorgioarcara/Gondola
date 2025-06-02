%% GTcell2struct - converts a cell array of GTstructs into a single struct
%
% GTcell2Struct(GTcellres)
%
% This function takes as input a cell array of GTstruct objects (e.g.
% resulting from analysis at different thresholds) and combines them into a
% single struct. 
%
% Input: 
%   GTcellres (cell): A cell array of GTstruct objects
%
% Output:
%   GTstruct (struct): A struct array where each element corresponds to a
%   GTstruct previously stored in the input cell
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 20/05/2025

function GTstruct = GTcell2struct(GTcellres)
    arguments
        GTcellres (1, :) cell
    end

    
    
GTstruct = GTcellres{1};

    for iCell = 2:length(GTcellres)
        GTstruct = [GTstruct, GTcellres{iCell}];
    end;
end

    
        
    

