%% GTimagesc(GTstruct, 'ResField', value, 'LabelFields', value, 'NCols', value, 'xlimits', value, 'ylimits', value)
%
% This function takes as input a GTstruct object (object with results from a
% analysis with BCT_analysis.m script) and
% create a square image with all results. Useful for
% inspection.
%
% INPUT
% - GTstruct: the GTstruct struct with the results.
% - ResField: the name of the field tha will be plotted.
% - LabelField: the name of the field to title the subplot.
% - NCols: the number of cols of resulting image. The rows will be
% determined as consequence
% - xlimits: if not speciied, the maximum across all subjets is used.
%           If "ind" is specified individual xlim are made (based on
%           minimum and maximum of each subject.
%
% - ylimits: if not speciied, [0, 100] is used.
%           If "ind" is specified individual ylim are made (based on
%           minimum and maximum of each subject.
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GThistogram(GTstruct, varargin);

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'LabelFields', [], @iscell);
addParameter(p, 'NCols', [], @isnumeric);
addParameter(p, 'xlimits', [], @isnumeric);
addParameter(p, 'ylimits', [], @isnumeric);


parse(p, varargin{:});

ResField = p.Results.ResField;
LabelFields =  p.Results.LabelFields;
NCols =  p.Results.NCols;
xlimits =  p.Results.xlimits;
ylimits =  p.Results.ylimits;



% create global clim if auto is specified
if isempty(xlimits)
    iField = find(strcmpi(ResField, fieldnames(GTstruct)));
    temp = struct2cell(GTstruct);
    data = [temp{iField, :, :}];
    xlimits = [min(data(:)), max(data(:))];
end

if isempty(ylimits)
    ylimits = [0, 100];
end;


tot_n = length(GTstruct);

% define number of cols
n_rows = round(length(GTstruct) / NCols);



figure
for k = 1:length(GTstruct)
    
    subplot(n_rows, NCols, k)
    
    numOfBins = 20;
    [histFreq, histXout] = hist(GTstruct(k).(ResField)(:), numOfBins);
    bar(histXout, histFreq/sum(histFreq)*100);
    
    if ~isempty(LabelFields);
        
        % define title in a loop (if several fields are supplied).
        if (iscell(LabelFields) & length(LabelFields)>1)
            panel_title =[];
            for iF=1:length(LabelFields)
                panel_title = [panel_title,  ' ', eval(['GTstruct(', num2str(k), ').', LabelFields{iF}])];
            end;
        else
            panel_title =  eval(['GTstruct(', num2str(k), ').', LabelFields{1}]);
        end
        
        title( panel_title );
        
    end; % end if empty labels
    
    % unlss clim is 'ind' (i.e., individual) clim is modified on global.
    if (~strcmpi('ind', xlimits));
        xlim(xlimits);
    end;
    if (~strcmpi('ind', ylimits));
        ylim(ylimits);
    end;
    
    ylabel('%')
    set(get(gca,'ylabel'),'rotation',0)
    
    
    
end;







