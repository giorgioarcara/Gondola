function GTstruct = GTsel(GTstruct, opt)
    
    arguments
        GTstruct (1,:) struct
        opt.Field {mustBeTextScalar}
        opt.Content {mustBeTextScalar}
    end

%% GTsel - selects GTstruct elements based on a matching field value
%
% GTstruct = GTsel(GTstruct, 'Field', value, 'Content', value)
%
% This function filters the elements of a GTstruct array by matching the
% value in a specified field (`Field`) with a given string (`Content`).
% Only elements where the specified field matches the content are retained.
%
% Inputs: 
%   GTstruct (struct): A GTstruct
%   
%   Field (string, optional): The name of the field used for selection
%
%   Content (strimg, optional): A string to be matched against the contents
%   of the specified field
%
% Output:
%   GTstruct (struct): A filtered GTstruct object where the values of the
%   specified field matches the given content
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% 
% Version: 28/05/2025


%% Parsing Arguments
Field = opt.Field
Content = opt.Content

if (isempty(Field) |  isempty(Content))
    error('Field or Content are empty: check your code')
end;

  
fieldnames = fields(GTstruct);

iInField = strcmp(Field, fieldnames);

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



  


