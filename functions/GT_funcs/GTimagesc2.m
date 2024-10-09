%% GTimagesc(GTstruct1, GTstruct2, 'DataField', 'value', 'LabelFields', {value}, 'Ncols', value, 'clim', 'value', 'CoordNames', {value})
%
% This function takes as input two GTres objects (object with results from a
% analysis with BCT_analysis.m script) and
% create a square image with all results. Useful for
% inspection.
%
% INPUT
% - GTstruct1: the first struct with the results.
% - GTstruct2: the first struct of the second struct with results.
% - DataField: the name of the field tha will be plotted.
% - labelfield: the name of the field to title the subplot.
% - Ncols: the number of cols of resulting image. The rows will be
% determined as consequence
% - clim: the colors (default is automatic and is taken from min and max of
% all data). If "ind" is specified individual clim are made (based on
% minimum and maximum of each subject.
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GTimagesc2(GTstruct1, GTstruct2, varargin);

if (length(GTstruct1)~=length(GTstruct2))
    error('the length of GTstruct1 and GTstruct2 should be the same');
end;


p = inputParser;
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'LabelFields', [], @iscell);
checkContent = @(x) isnumeric(x) | ischar(x);
addParameter(p, 'clim', 'auto', checkContent);
addParameter(p, 'CoordNames', [], @iscell);
addParameter(p, 'Ncols', [], @isnumeric);


parse(p, varargin{:});

DataField = p.Results.DataField;
LabelFields =  p.Results.LabelFields;
clim =  p.Results.clim;
CoordNames =  p.Results.CoordNames;
Ncols =  p.Results.Ncols;

if ~isempty(Ncols)
    fprintf('\nGT Note that you specified Ncols, but with GTimagesc, Ncols is set always to 2\n\n');
end

% create global clim if no clim is specified
if strcmp(clim, 'auto')
    GTstruct = [GTstruct1, GTstruct2];
    iField = find(strcmpi(DataField, fieldnames(GTstruct)));
    temp = struct2cell(GTstruct);
    data = [temp{iField, :, :}];
    clim = [min(data(:)), max(data(:))];
    
end


% define rows and columns
tot_n = length(GTstruct1);
Ncols = 2;
% define number of cols
n_rows = round(length(GTstruct1)*2 / Ncols);

set(gca, 'YTickLabel',[],'XTickLabel', []);

% initialize plot index
iPlot = 0;

figure
for k = 1:length(GTstruct1)
    
    
    %% COLUMN 1
    iPlot = iPlot + 1;
    
    
    subplot(n_rows, 2, iPlot);
    
    
    %% PLOT IMAGE 1
    imagesc(GTstruct1(k).(DataField));
    colorbar
    
    %% ADD TITLE 1
    % define title in a loop (if several fields are supplied).
    if (length(LabelFields)>1)
        panel_title =[];
        for iF=1:length(LabelFields)
            panel_title = [panel_title,  ' ', GTstruct1(k).(LabelFields{iF})];
        end;
    else
        panel_title =  GTstruct1(k).(LabelFields{1});
    end
    
    title( panel_title );
    
    caxis(clim);
    
    %% SECOND COL
    iPlot = iPlot +1;
    
    subplot(n_rows, 2, iPlot);
    
    %% PLOT IMAGE 1
    imagesc(GTstruct2(k).(DataField));
    colorbar
    
    %% ADD TITLE 1
    % define title in a loop (if several fields are supplied).
    if (length(LabelFields)>1)
        panel_title =[];
        for iF=1:length(LabelFields)
            panel_title = [panel_title,  ' ', GTstruct2(k).(LabelFields{iF})];
        end;
    else
        panel_title =  GTstruct2(k).(LabelFields{1});
    end
    
    title( panel_title );
    
    caxis(clim);
    
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

%http://www.briandalessandro.com/blog/how-to-make-a-borderless-subplot-of-images-in-matlab/
function h = subplottight(n,m,i)
[c,r] = ind2sub([m n], i);
ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
if(nargout > 0)
    h = ax;
end
end


