%% GTlineplot(GTstruct, 'DataField', 'value', 'LabelFields', {value}, 'Ncols', value, 'Xlimits', 'value', 'NodeNames', {value})
%
% This function takes as input a GTstruct object (object with results from a
% analysis with BCT_analysis.m script) and
% create a lineplot with all results. Useful for
% inspection. The function also uses a customize datatip to help identify
% the Node.
%
% INPUT
% - GTstruct: the GTstruct struct with the results.
% - DataField: the name of the field tha will be plotted.
% - labelfield: the name of the field to title the subplot.
% - NodeNames: the names of the Nodes (to be displayed in the x axis).
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%
%
function fig = GTlineplot(GTstruct,varargin);

p = inputParser;
addParameter(p, 'DataField', [], @ischar);
addParameter(p, 'LabelFields', [], @iscell);
addParameter(p, 'Ncols', [], @isnumeric);
checkContent = @(x) isnumeric(x) | ischar(x);
addParameter(p, 'Xlimits', [], checkContent);
addParameter(p, 'NodeNames', [], @iscell);


parse(p, varargin{:});

DataField = p.Results.DataField;
LabelFields =  p.Results.LabelFields;
Ncols =  p.Results.Ncols;
Xlimits =  p.Results.Xlimits;
NodeNames = p.Results.NodeNames;

if isempty(NodeNames);
    CoordNames='';
end;



% initialize object to be used for the Xticks (the node labels)
curr_names = cell(1, length(GTstruct));

figure
for iSubj = 1:length(GTstruct)
    set(gca,'TickLabelInterpreter', 'none');
    
    hold on
   subj_values = GTstruct(iSubj).(DataField);

    for iN = 1:length(subj_values);
        plot([0, subj_values(iN)], [iN iN], 'black');
    end;
    % define curr name
    if ~isempty(LabelFields)
        % define title in a loop (if several fields are supplied).
        if (iscell(LabelFields) & length(LabelFields)>1)
            curr_name =[];
            for iF=1:length(LabelFields)
                curr_name = [curr_name, ' ', GTstruct(iSubj).(LabelFields{iF})];
            end;
        else
            curr_name =  GTstruct(iSubj).(LabelFields{1});
        end
        
        curr_names{iSubj} = curr_name;
    end;
    
end;

hold off

% set cursor stuff
dcm=datacursormode;
datacursormode on
set(dcm, 'updatefcn', {@myFunction, NodeNames}); % note here that I specify the argument Coord to be used in the personalized Datatip.


set(gca, 'YTick', 1:length(NodeNames), 'YTickLabel', NodeNames);% 'XTickLabelRotation', 90);

if ~isempty(Xlimits)
    set(gca, 'Xlim', Xlimits);
end;
title(curr_names)
% change legend line width (taken from
% https://it.mathworks.com/matlabcentral/answers/259402-how-to-change-the-legend-colored-linewidth-not-the-width-of-box-outline)
% [~, hObj] = legend(curr_names);
% hL=findobj(hObj,'type','line');  % get the lines, not text
% set(hL,'linewidth', 2);

end



% create a personalized datatip function
function output_txt = myFunction(obj ,event_obj, NodeNames);
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');

Name = event_obj.Target.DisplayName;

% Import x and y
y = get(get(event_obj,'Target'),'YData');
%y = get(get(event_obj,'Target'),'YData');

% Find index
index_y = find(x == pos(1));

% Set output text
output_txt = {['Node: ', NodeNames{index_y}], ...
    ['Name: ', Name]};
end




