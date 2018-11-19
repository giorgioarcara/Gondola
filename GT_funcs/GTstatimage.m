%% GTstatimage(resmat, Coord_names, thresholds, threshmat)
%
% This functions perform a independent sample t-test.
%
% INPUT:
%
% - resmat: a matrix (or vector) with results as obtained by GTmat_ttest
%         functions
% - Coord_names: the Coord labels to be plotted in X axis (and Y axis for .
%
% - thresholds: a vector with two numbers. The first is the lower threshold
%               (i.e. lwoer number will be excluded). The second is the upper threshold
%               (higher number will be excluded. 
%               In the common case to exclude value > 0.05, the thresholds
%               should be specified like this [-Inf, 0.05]
% - threshmat: another matrix to exclude values in anothermatrix  (e.g. a pmat to filter a tmat.)
%
%
% Author: Giorgio Arcara
%
% Data : 4/02/2018;
%
%
function [tmat, pmat] = GTstatimage(resmat, Coord_names, thresholds, threshmat)

% if no thresholds matrix is specified the resmatt is used for thresholds.
if ~exist('threshmat');
    threshmat = resmat;
end;    

% setup axis limits
minv = min(min(resmat));
maxv = max(max(resmat));
minv = minv-((maxv-minv)/5)
ddd=[0.8 0.8 0.8; jet(10)];

% adjust axis in case only one value is supplied
% caxis will not work with only one value.
if (minv == maxv)
    maxv = (abs(resmat));
    minv = -(abs(resmat));
end;

% apply threshold if supplied.
if exist('thresholds') & ~isempty(thresholds)
    resmat(threshmat<thresholds(1))=NaN;
    resmat(threshmat>thresholds(2))=NaN;
end;

% rotate data if a vector is supplied (so labels of ROIs are on the y axis and can be read)
if (size(resmat,1)==1  & size(resmat,2)>1)
    resmat = resmat';
end;

colormap(ddd);
imagesc(resmat);
caxis([minv, maxv]);
colorbar

%% CREATE LABELS (according to data type).
% case matrix
if (size(resmat,1)>1 & size(resmat,2)>1);
    set(gca, 'YTick', 1:length(Coord_names), 'YTickLabel', Coord_names);
    set(gca, 'XTick', 1:length(Coord_names), 'XTickLabel', Coord_names, 'XTickLabelRotation', 90);
% case vector
elseif (size(resmat,1)>1  & size(resmat,2)==1) % NOTE that I rotate the resmat before
    set(gca, 'YTick', 1:length(Coord_names), 'YTickLabel', Coord_names);
     set(gca, 'XTick', [], 'XTickLabel', []);
% else (case single value
elseif (size(resmat,1)==1  & size(resmat,2)==1)
 set(gca, 'XTick', [])
end;


%% Data tip
dcm=datacursormode;
datacursormode off
Coord = Coord_names;
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
value = round( event_obj.Target.CData(x, y), 2);
elseif x ==1 % case vector
    value = round( event_obj.Target.CData(y), 2);
end;



% Set output text
output_txt = {['x: ', Coord{x}], ...
              ['y: ', Coord{y}], ...
              ['val:', num2str(value)]};
end
