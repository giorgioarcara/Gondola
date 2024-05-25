%% GTthreshimage(GTmat, 'CoordNames', value, 'Thresholds',[value], 'ThreshMat', value, 'DrawLabels', value)
%
% This functions perform a independent sample t-test.
%
% INPUT:
%
% - GTmat: a matrix (or vector) with results as obtained by GTmat_ttest
%         functions
% - CoordNames: the Coord labels to be plotted in X axis (and Y axis for .
%
% - Thresholds: a vector with two numbers. The first is the lower threshold
%               (i.e. lwoer number will be excluded). The second is the upper threshold
%               (higher number will be excluded.
%               In the common case to exclude value > 0.05, the Thresholds
%               should be specified like this [-Inf, 0.05]
% - ThreshMat: another matrix to exclude values in anothermatrix  (e.g. a pmat to filter a tmat.)
% - DrawLabels: should labels be plotted? default is 1.
% - Clim  : set clim
%
%
% Author: Giorgio Arcara
%
% Data : 4/02/2018;
%
%
function [tmat, pmat] = GTthreshimage(GTmat, varargin)

p = inputParser;
addParameter(p, 'CoordNames', [], @iscell);
addParameter(p, 'Thresholds', [], @isnumeric);
addParameter(p, 'ThreshMat', [], @isnumeric);
addParameter(p, 'DrawLabels', [], @isnumeric);
addParameter(p, 'Clim', [], @isnumeric);
parse(p, varargin{:});

CoordNames = p.Results.CoordNames;
Thresholds =  p.Results. Thresholds;
ThreshMat =  p.Results.ThreshMat;
DrawLabels = p.Results.DrawLabels;
Clim = p.Results.Clim;


if ~isnumeric(GTmat)
    error('Gondola Error: GTmat must be a matrix');
end


% if no Thresholds matrix is specified the GTmatt is used for Thresholds.
if isempty(ThreshMat);
    ThreshMat = GTmat;
end;

% setup axis limits
minv = min(min(GTmat));
maxv = max(max(GTmat));
minv = minv-((maxv-minv)/5);
ddd=[0.8 0.8 0.8; jet(10)];

% adjust axis in case only one value is supplied
% caxis will not work with only one value.
if (minv == maxv)
    maxv = (abs(GTmat));
    minv = -(abs(GTmat));
end;

% apply threshold if supplied.
if exist('Thresholds') & ~isempty(Thresholds)
    GTmat(ThreshMat<Thresholds(1))=NaN;
    GTmat(ThreshMat>Thresholds(2))=NaN;
end;

% rotate data if a vector is supplied (so labels of ROIs are on the y axis and can be read)
if (size(GTmat,1)==1  & size(GTmat,2)>1)
    GTmat = GTmat';
end;


figure
colormap(ddd);
imagesc(GTmat);

if isempty(Clim)
    caxis([minv, maxv]);
else
   caxis(Clim);
   
end;
%set(gca, 'clim', [minv, maxv]);
colorbar

%% CREATE LABELS (according to data type).
% case matrix
if DrawLabels
    
    set(gca,'TickLabelInterpreter', 'none');
    
    if (size(GTmat,1)>1 & size(GTmat,2)>1);
        set(gca, 'YTick', 1:length(CoordNames), 'YTickLabel', CoordNames);
        set(gca, 'XTick', 1:length(CoordNames), 'XTickLabel', CoordNames, 'XTickLabelRotation', 90);
        % case vector
    elseif (size(GTmat,1)>1  & size(GTmat,2)==1) % NOTE that I rotate the GTmat before
        set(gca, 'YTick', 1:length(CoordNames), 'YTickLabel', CoordNames);
        set(gca, 'XTick', [], 'XTickLabel', []);
        % else (case single value
    elseif (size(GTmat,1)==1  & size(GTmat,2)==1)
        set(gca, 'XTick', [])
    end;
    
else
     set(gca, 'XTick', [], 'XTickLabel', []);
     set(gca, 'YTick', [], 'YTickLabel', []);
end;



%% Data tip
dcm=datacursormode;
datacursormode off
Coord = CoordNames;
set(dcm, 'updatefcn', {@myFunction, Coord}); % note here that I specify the argument Coord to be used in the personalized Datatip.


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
