%% GTimagesc2(GTres1, GTres2, resfield, labelfields, n_cols)
%
% This function takes as input two GTres objects (object with results from a
% analysis with BCT_analysis.m script) and
% create a square image with all results. Useful for
% inspection.
%
% INPUT
% - GTres1: the GTres of the first struct with the results.
% - GTres2: the GTres of the second struct with results.
% - resfield: the name of the field tha will be plotted.
% - labelfield: the name of the field to title the subplot.
% - n_cols: the number of cols of resulting image. The rows will be
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
function fig = GTimagesc(GTres1, GTres2, resfield, labelfields, clim);

if (length(GTres1)~=length(GTres2))
    error('the length of GTres1 and GTres2 should be the same');
end;

% create global clim if auto is specified
if (~exist('clim'));
    % clim of first struct
    iField1 = find(strcmpi(resfield, fieldnames(GTres1)));
    temp1 = struct2cell(GTres1);
    data1 = [temp1{iField1, :, :}];
    clim1 = [min(data1(:)), max(data1(:))];
    % clim of second struct
    iField2 = find(strcmpi(resfield, fieldnames(GTres2)));
    temp2 = struct2cell(GTres2);
    data2 = [temp2{iField2, :, :}];
    clim2 = [min(data2(:)), max(data2(:))];
    %global clim
    clim = [min([clim1, clim2]), max([clim1, clim2])]; 
end;


% define rows and columns
tot_n = length(GTres1);

n_cols = 2;
% define number of cols
n_rows = round(length(GTres1)*2 / n_cols);

set(gca, 'YTickLabel',[],'XTickLabel', []);

% initialize plot index
iPlot = 0;

figure
for k = 1:length(GTres1)
    
     
   %% COLUMN 1
    iPlot = iPlot + 1;

    
    subplot(n_rows, 2, iPlot);

    
    %% PLOT IMAGE 1
    imagesc(GTres1(k).(resfield));
    colorbar
    
    %% ADD TITLE 1
    % define title in a loop (if several fields are supplied).
    if (iscell(labelfields) & length(labelfields)>1)
        panel_title =[];
        for iF=1:length(labelfields)
            panel_title = [panel_title,  ' ', GTres1(k).(labelfields{iF})];
        end;
    else
        panel_title =  GTres1(k).(labelfields);
    end
    
    title( panel_title );
    
    % unlss clim is 'ind' (i.e., individual) clim is modified on global.
    if (~strcmpi('ind', clim)); 
        caxis(clim);
    end;
    
    %% SECOND COL
    iPlot = iPlot +1;
    
    subplot(n_rows, 2, iPlot);

    %% PLOT IMAGE 1
    imagesc(GTres2(k).(resfield));
    colorbar
    
    %% ADD TITLE 1
    % define title in a loop (if several fields are supplied).
    if (iscell(labelfields) & length(labelfields)>1)
        panel_title =[];
        for iF=1:length(labelfields)
            panel_title = [panel_title,  ' ', GTres2(k).(labelfields{iF})];
        end;
    else
        panel_title =  GTres2(k).(labelfields);
    end
    
    title( panel_title );
    
    
    set(gca, 'YTickLabel',[],'XTickLabel', []);
    
end;

%http://www.briandalessandro.com/blog/how-to-make-a-borderless-subplot-of-images-in-matlab/

function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n]);
    if(nargout > 0)
      h = ax;
    end







