%% GTimagesc(GTstruct, 'ResField', 'value', 'LabelFields', {value}, 'Ncols', value, 'clim', 'value')
%
% This function takes as input a GTstruct object (object with results from a
% analysis with BCT_analysis.m script) and
% create a square image with all results. Useful for
% inspection.
%
% INPUT
% - GTstruct: the GTstruct struct with the results.
% - ResField: the name of the field that will be plotted.
% - LabelFields: the name of the field to title the subplot.
% - Ncols: the number of cols of resulting image. The rows will be
% determined as consequencew
% - clim: the colors (default is automatic and is taken from min and max of
% all data). Auto = []. If "ind" is specified individual clim are made (based on
% minimum and maximum of each subject.
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GTimagesc(GTstruct, varargin);

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'LabelFields', [], @iscell);
addParameter(p, 'Ncols', [], @isnumeric);
checkContent = @(x) isnumeric(x) | ischar(x);
addParameter(p, 'clim', [], checkContent);



parse(p, varargin{:});

ResField = p.Results.ResField;
LabelFields =  p.Results.LabelFields;
Ncols =  p.Results.Ncols;
clim =  p.Results.clim;


% create global clim if auto is specified
if (~isempty('clim'));
    iField = find(strcmpi(ResField, fieldnames(GTstruct)));
    temp = struct2cell(GTstruct);
    data = [temp{iField, :, :}];
    clim = [min(data(:)), max(data(:))];
   
end

if (~isempty('Ncols'));
    Ncols=1;
end


tot_n = length(GTstruct);

% define number of cols
n_rows = round(length(GTstruct) / Ncols);


figure
for k = 1:length(GTstruct)
    
    subplot_tight(n_rows, Ncols, k, .05)
    imagesc(GTstruct(k).(ResField));
    colorbar
    
    % define title in a loop (if several fields are supplied).
    if (iscell(LabelFields) & length(LabelFields)>1)
        panel_title =[];
        for iF=1:length(LabelFields)
            panel_title = [panel_title,  ' ', GTstruct(k).(LabelFields{iF})];
        end;
    elseif (iscell(LabelFields) & length(LabelFields)==1)
        panel_title =  GTstruct(k).(LabelFields{1});
    else
        panel_title='';
    end;
    
    title( panel_title, 'FontSize', 20);

    
    % unlss clim is 'ind' (i.e., individual) clim is modified on global.
    if (~strcmpi('ind', clim)); 
        caxis(clim);
    end;
    
    
    set(gca, 'YTickLabel',[],'XTickLabel', []);

    
end;







