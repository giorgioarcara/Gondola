%% GTimagesc(GTres, resfield, labelfields, n_cols)
%
% This function takes as input a GTres object (object with results from a
% analysis with BCT_analysis.m script) and
% create a square image with all results. Useful for
% inspection.
%
% INPUT
% - GTres: the GTres struct with the results.
% - resfield: the name of the field tha will be plotted.
% - labelfield: the name of the field to title the subplot.
% - n_cols: the number of cols of resulting image. The rows will be
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
function fig = GThistogram(GTres, resfield, labelfields , n_cols, xlimits, ylimits);



% create global clim if auto is specified
if ( (~exist('xlimits')) | (isempty(xlimits)) );
    iField = find(strcmpi(resfield, fieldnames(GTres)));
    temp = struct2cell(GTres);
    data = [temp{iField, :, :}];
    xlimits = [min(data(:)), max(data(:))];
end

if (~exist('ylimits'))
    ylimits = [0, 100];
end;


tot_n = length(GTres);

% define number of cols
n_rows = round(length(GTres) / n_cols);



figure
for k = 1:length(GTres)
    
    subplot(n_rows, n_cols, k)
    
    numOfBins = 20;
    [histFreq, histXout] = hist(GTres(k).(resfield)(:), numOfBins);
    bar(histXout, histFreq/sum(histFreq)*100);
    
    if ~isempty(labelfields);
        
        % define title in a loop (if several fields are supplied).
        if (iscell(labelfields) & length(labelfields)>1)
            panel_title =[];
            for iF=1:length(labelfields)
                panel_title = [panel_title,  ' ', eval(['GTres(', num2str(k), ').', labelfields{iF}])];
            end;
        else
            panel_title =  eval(['GTres(', num2str(k), ').', labelfields]);
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







