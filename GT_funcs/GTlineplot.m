%% GTlineplot(GTstruct, 'ResField', 'value', 'LabelFields', {value}, 'Ncols', value, 'Ylimits', 'value')
%
% This function takes as input a GTstruct object (object with results from a
% analysis with BCT_analysis.m script) and
% create a lineplot with all results. Useful for
% inspection. The function also uses a customize datatip to help identify
% the Node.
%
% INPUT
% - GTstruct: the GTstruct struct with the results.
% - ResField: the name of the field tha will be plotted.
% - labelfield: the name of the field to title the subplot.
% - CoordNames: the names of the Nodes (to be displayed in the x axis).
% - Ylimits: the colors (default is automatic and is taken from min and max of
% all data). If "ind" is specified individual clim are made (based on
% minimum and maximum of each subject.
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GTlineplot(GTstruct,varargin);

p = inputParser;
addParameter(p, 'ResField', [], @ischar);
addParameter(p, 'LabelFields', [], @iscell);
addParameter(p, 'Ncols', [], @isnumeric);
checkContent = @(x) isnumeric(x) | ischar(x);
addParameter(p, 'Ylimits', [], checkContent);

parse(p, varargin{:});

ResField = p.Results.ResField;
LabelFields =  p.Results.LabelFields;
Ncols =  p.Results.Ncols;
Ylimits =  p.Results.Ylimits;


if (~exist('CoordNames'));
    CoordNames=''
end;



% initialize object to be used for the Xticks (the node labels)
curr_names = cell(1, length(GTstruct));

figure
for iSubj = 1:length(GTstruct)    
   hold on
   plot(GTstruct(iSubj).(ResField));
    
    % define curr name
    if ~isempty(LabelFields)
        % define title in a loop (if several fields are supplied).
        if (iscell(LabelFields) & length(LabelFields)>1)
            curr_name =[];
            for iF=1:length(LabelFields)
                curr_name = [curr_name, ' ', GTstruct(iSubj).(LabelFields{iF})];
            end;
        else
            curr_name =  GTstruct(iSubj).(LabelFields);
        end
        
        curr_names{iSubj} = curr_name;
    end;
    
end;

hold off

% set cursor stuff
dcm=datacursormode;
datacursormode on
Coord = CoordNames;
set(dcm, 'updatefcn', {@myFunction, Coord}); % note here that I specify the argument Coord to be used in the personalized Datatip.


set(gca, 'XTick', 1:length(CoordNames), 'XTickLabel', CoordNames, 'XTickLabelRotation', 90);

if exist('Ylimits')
    set(gca, 'Ylim', Ylimits);
end;

% change legend line width (taken from
% https://it.mathworks.com/matlabcentral/answers/259402-how-to-change-the-legend-colored-linewidth-not-the-width-of-box-outline)
[~, hObj] = legend(curr_names);
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth', 2);     

end



% create a personalized datatip function
function output_txt = myFunction(obj ,event_obj, Coord);
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');

Name = event_obj.Target.DisplayName;

% Import x and y
x = get(get(event_obj,'Target'),'XData');
%y = get(get(event_obj,'Target'),'YData');

% Find index
index_x = find(x == pos(1));

% Set output text
output_txt = {['Node: ', Coord{index_x}], ...
              ['Name: ', Name]};
end




