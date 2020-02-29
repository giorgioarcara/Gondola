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
% determined as consequencew
% - clim: the colors (default is automatic and is taken from min and max of
% all data). If "ind" is specified individual clim are made (based on
% minimum and maximum of each subject.
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GTimagesc(GTres, resfield, labelfields , n_cols, clim);



% create global clim if auto is specified
if (~exist('clim'));
    iField = find(strcmpi(resfield, fieldnames(GTres)));
    temp = struct2cell(GTres);
    data = [temp{iField, :, :}];
    clim = [min(data(:)), max(data(:))];
end


tot_n = length(GTres);

% define number of cols
n_rows = round(length(GTres) / n_cols);


figure
for k = 1:length(GTres)
    
    subplot_tight(n_rows, n_cols, k, .05)
    imagesc(GTres(k).(resfield));
    colorbar
    
    % define title in a loop (if several fields are supplied).
    if (iscell(labelfields) & length(labelfields)>1)
        panel_title =[];
        for iF=1:length(labelfields)
            panel_title = [panel_title,  ' ', GTres(k).(labelfields{iF})];
        end;
    else
        panel_title =  GTres(k).(labelfields{1});
    end
    
    title( panel_title, 'FontSize', 20);
    
    % unlss clim is 'ind' (i.e., individual) clim is modified on global.
    if (~strcmpi('ind', clim)); 
        caxis(clim);
    end;
    
    
    set(gca, 'YTickLabel',[],'XTickLabel', []);
    
end;







