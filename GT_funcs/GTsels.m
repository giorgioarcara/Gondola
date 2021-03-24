%% GTsels(GTstruct, 'InFields', {value}, 'Contents', {values});
%
% This function select all field based on a value found in a field.
% It calls recursively GTsel to perform more than one selection in a single
% call
%
% INPUT: 
%
% - GTstruct: a struct for Gondola
% - InField: the field for the selection
% - Content: an expression (also with logical) to select the fields.
%
% Author: Giorgio Arcara, 22/03/2021


function GTstruct = GTsels(GTstruct, varargin)


% part to check if, in a given group
p = inputParser;
addParameter(p, 'InFields', [], @iscell);
addParameter(p, 'Contents', [], @iscell);

parse(p, varargin{:});

InFields = p.Results.InFields;
Contents =  p.Results.Contents;

if (isempty(InFields) |  isempty(Contents))
    error('InFields or Contents are empty: check your code')
end;

  
fieldnames = fields(GTstruct);

for iField = 1:length(InFields)
    
    GTstruct = GTsel(GTstruct, 'InField', InFields{iField}, 'Content', Contents{iField});
end


  


