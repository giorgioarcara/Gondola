%% GTstatimage(Statmat, 'CoordNames','value', 'Thresholds',[value], 'ThreshMat', value)
%
% This functions perform a independent sample t-test.
%
% INPUT:
%
% - Statmat: a matrix (or vector) with results as obtained by GTmat_ttest
%         functions
% - CoordNames: the Coord labels to be plotted in X axis (and Y axis for .
%
% - Thresholds: a vector with two numbers. The first is the lower threshold
%               (i.e. lwoer number will be excluded). The second is the upper threshold
%               (higher number will be excluded. 
%               In the common case to exclude value > 0.05, the Thresholds
%               should be specified like this [-Inf, 0.05]
% - ThreshMat: another matrix to exclude values in anothermatrix  (e.g. a pmat to filter a tmat.)
%
%
% Author: Giorgio Arcara
%
% Data : 4/02/2018;
%
%
function [tmat, pmat] = GTstatimage(Statmat, CoordNames, Thresholds, ThreshMat)
p = inputParser;
addParameter(p, 'CoordNames', [], @ischar);
addParameter(p, ' Thresholds', [], @isvector);
addParameter(p, 'ThreshMat', [], @ismatrix);


parse(p, varargin{:});

CoordNames = p.Results.CoordNames;
Thresholds =  p.Results. Thresholds;
ThreshMat =  p.Results.ThreshMat;




% if no Thresholds matrix is specified the Statmatt is used for Thresholds.
if ~exist('ThreshMat');
    ThreshMat = Statmat;
end;    

% setup axis limits
minv = min(min(Statmat));
maxv = max(max(Statmat));
minv = minv-((maxv-minv)/5);
ddd=[0.8 0.8 0.8; jet(10)];

% adjust axis in case only one value is supplied
% caxis will not work with only one value.
if (minv == maxv)
    maxv = (abs(Statmat));
    minv = -(abs(Statmat));
end;

% apply threshold if supplied.
if exist('Thresholds') & ~isempty(Thresholds)
    Statmat(ThreshMat<Thresholds(1))=NaN;
    Statmat(ThreshMat>Thresholds(2))=NaN;
end;

% rotate data if a vector is supplied (so labels of ROIs are on the y axis and can be read)
if (size(Statmat,1)==1  & size(Statmat,2)>1)
    Statmat = Statmat';
end;


figure
colormap(ddd);
imagesc(Statmat);
caxis([minv, maxv]);
%set(gca, 'clim', [minv, maxv]);
colorbar

%% CREATE LABELS (according to data type).
% case matrix
if (size(Statmat,1)>1 & size(Statmat,2)>1);
    set(gca, 'YTick', 1:length(CoordNames), 'YTickLabel', CoordNames);
    set(gca, 'XTick', 1:length(CoordNames), 'XTickLabel', CoordNames, 'XTickLabelRotation', 90);
% case vector
elseif (size(Statmat,1)>1  & size(Statmat,2)==1) % NOTE that I rotate the Statmat before
    set(gca, 'YTick', 1:length(CoordNames), 'YTickLabel', CoordNames);
     set(gca, 'XTick', [], 'XTickLabel', []);
% else (case single value
elseif (size(Statmat,1)==1  & size(Statmat,2)==1)
 set(gca, 'XTick', [])
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
