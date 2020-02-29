%% GTsel(GTres, FreqField, value, DataField, value);
%
% This function start from a GT struct. It selects the data fields based on
% the selection of a Freq.

% field
%
% INPUT: 
%
% - GTres: a struct, resullting from BCT script analysis
% - field: the field for the selection
% - values: an expression (also with logical) to select the fields.

function GTres = GTFreqsel(GTres, varargin)

% part to check if, in a given group
p = inputParser;
addParameter(p, 'FreqField', [], @iscell);
addParameter(p, 'DataField', [], @iscell);


parse(p, varargin{:});

FreqField = p.Results.FreqField;
ResFields =  p.Results.ResFields;
DataField =  p.Results.DataField;




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



  


