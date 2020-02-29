%% GTsel(GTres, field, value, num);
%
% This function select all field based on a value found in a field.
% Call the functions multiple times to perform selection on more than one
% field
%
% INPUT: 
%
% - GTres: a struct, resullting from BCT script analysis
% - field: the field for the selection
% - values: an expression (also with logical) to select the fields.

function GTres_sel = GTsel(GTres, field, values)
  
fieldnames = fields(GTres);

iField = strcmp(field, fieldnames);

GTcell = struct2cell(GTres);

GTvalues = squeeze({GTcell{iField, :,:}});

% note I use the sel_files_bst to select, in the case values are a cell
if ischar(values)
[~ , ind_sel] =  sel_string(GTvalues, values);

% a different way is what happen in the case of numeric
elseif isnumeric(values)
   GTvalues2 = round(cell2mat(GTvalues), 10);
   % !!! Important. I use round here cause for some reasons (approximation)
   % the values are not 
   [~, ind] = ismember(GTvalues2, round(values, 10));
   ind_sel = find(ind);

end;

GTres_sel = GTres(ind_sel);



  


