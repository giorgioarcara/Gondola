%% GTimagesc(GTstruct, 'ResField', 'value', 'LabelFields', {value}, 'Ncols', value, 'clim', 'value', 'CoordNames', {value})
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
addParameter(p, 'clim', 'auto', checkContent);
addParameter(p, 'CoordNames', [], @iscell);



parse(p, varargin{:});

ResField = p.Results.ResField;
LabelFields =  p.Results.LabelFields;
Ncols =  p.Results.Ncols;
clim =  p.Results.clim;
CoordNames =  p.Results.CoordNames;


% create global clim if no clim is specified
if strcmp('clim', 'auto')
    iField = find(strcmpi(ResField, fieldnames(GTstruct)));
    temp = struct2cell(GTstruct);
    data = [temp{iField, :, :}];
    clim = [min(data(:)), max(data(:))];
    
end

if isempty(Ncols);
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
    
    
    if (~isempty(CoordNames))
        
        %% Data tip
        dcm=datacursormode;
        datacursormode off
        Coord = CoordNames;
        set(dcm, 'updatefcn', {@myFunction, Coord}); % note here that I specify the argument Coord to be used in the personalized Datatip.
        
    end;
    
end

end

% create a personalized datatip function
function output_txt = myFunction(obj ,event_obj, Coord);
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');


% in this case x and y are the ordinal position of the cursor
% hence pos(1) and pos(2).
x=pos(1);
y=pos(2);

%  CData containst tte matrix of all values.
% in this way  I retrive the displayeed value
% from the ordinal position pos(1) and pos(2)
if x > 1 % case matrix
    value = round( event_obj.Target.CData(y, x), 2);
elseif x ==1 % case vector
    value = round( event_obj.Target.CData(y), 2);
end;



% Set output text
output_txt = {['x: ', Coord{x}], ...
    ['y: ', Coord{y}], ...
    ['val:', num2str(value)]};
end
