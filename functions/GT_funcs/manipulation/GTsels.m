function GTstruct = GTsels(GTstruct, opt)

    arguments
        GTstruct (1,:) struct
        opt.Field (1, :) cell
        opt.Content (1, :) cell
    end
    
%% GTsels - Applies multiple sequential selections on a GTstruct based on multiple field values
% 
% GTstruct = GTsels(GTstruct, 'Field', {field1, field2, ...}, 'Content', {value1, value2, ...})
% 
% This function filters a GTstruct array by applying multiple selections
% based on specified fields and corresponding content values. Internally,
% it calls the `GTsel` function recursively for each field-content pair.
%
% Inputs: 
%   GTstruct (struct): A GTstruct object
%
%   Field (cell, optional): A cell array of field names to be used for the
%   selection
%
%   Content (cell, optional): A cell array of values to match in each
%   corresponding field
%
% Output:
%   GTstruct (struct): A filtered GTstruct array containing only the elemts
%   that match all field-content pairs
%
% Notes:
%   - The dimension of 'Field' and 'Content' must match
%   - The selection is applied sequentially in the order of the provided
%   pairs
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 28/05/2025
%

if (isempty(Field) |  isempty(Content))
    error('InFields or Contents are empty: check your code')
end;

  
fieldnames = fields(GTstruct);

for iField = 1:length(Field)
    
    GTstruct = GTsel(GTstruct, 'InField', Field{iField}, 'Content', Content{iField});
end


  


