%% GTsel(GTstruct, 'InField', value, 'Content', value);
%
% This function select all field based on a value found in a field.
% Call the functions multiple times to perform selection on more than one
% field
%
% INPUT: 
%
% - GTstruct: a struct for Gondola
% - InField: the field for the selection
% - Content: an expression (also with logical) to select the fields.

function GTstruct = GTsel(GTstruct, varargin)


% part to check if, in a given group
p = inputParser;
addParameter(p, 'InField', [], @ischar);
checkContent = @(x) isnumeric(x) | ischar(x);
addParameter(p, 'Content', [], checkContent);

parse(p, varargin{:});

InField = p.Results.InField;
Content =  p.Results.Content;

if (isempty(InField) |  isempty(Content))
    error('InField or Content are empty: check your code')
end;

  
fieldnames = fields(GTstruct);

iInField = strcmp(InField, fieldnames);

GTcell = struct2cell(GTstruct);

GTContent = squeeze({GTcell{iInField, :,:}});

% note I use the sel_files_bst to select, in the case Content are a cell
if ischar(Content)
[~ , ind_sel] =  sel_string(GTContent, Content);

% a different way is what happen in the case of numeric
elseif isnumeric(Content)
   GTContent2 = round(cell2mat(GTContent), 10);
   % !!! Important. I use round here cause for some reasons (approximation)
   % the Content are not 
   [~, ind] = ismember(GTContent2, round(Content, 10));
   ind_sel = find(ind);

end;

GTstruct = GTstruct(ind_sel);



  


