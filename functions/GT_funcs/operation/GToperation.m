function GTstruct = GToperation(GTstruct, opt)
    arguments
        GTstruct (1, :) struct
        opt.Fields (1, :) cell
        opt.OtherFields (1, :) cell
        opt.Operation (1, 1) string
    end
    




%% GToperation - Applies a custom operation to fields in a GTstruct
%
% GTstruct = GToperation(GTstruct, 'Fields',value,'OtherFields', value, 'Operation', value)
%
% This function takes as input a GTstruct and applies a custom operation 
% to the values stored in specified fields. The operation should be 
% expressed as a MATLAB string (e.g., "GTres = GT1.^2").
%
%
% Inputs:
%   GTstruct (struct): A GTstruct object
%
%   Fields (cell, optional): Cell array of field names in GTstruct on which
%   the operation will be applied
%
%   OtherFields (cell, optional): Cell array of other fields to be
%   inherited from the original GTstruct
%
%   Operation (string, optional): String with a MATLAB expression to be
%   applied (e.g., 'GTres = GT1.^2')
%
% Output: 
%   GTstruct (struct): The original GTstruct with an additional field
%   containing the results of the evaluated operation
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 29/05/2025
%


GTstruct = struct();

if (isempty(OtherFields))
    OtherFields = fieldnames(GTstruct1)';
end;


% first copy all the other fields
for fn = OtherFields
    for isubj = 1:length(GTstruct1);
        GTstruct(isubj).(fn{1}) = GTstruct1(isubj).(fn{1});
    end
end


% now load the data
for k=1:length(GTstruct1);
    for iField = 1:length(Fields);
        GT1 = GTstruct1(k).(Fields{iField});
        eval([Operation, ';']);
        GTstruct(k).(Fields{iField}) = GTres;
    end;
    
end;
fprintf(['\n\n - Operation performed: ', Operation, '\n'] );



% note an alternative way is to get all values
% Res = [GTstruct.InFields], reshape with 3rd dimension and then average





