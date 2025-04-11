function fig = GTlineplot(GTstruct, opt);
    arguments
        GTstruct (1,:) struct
        opt.Field (1,1) string {mustBeValidVariableName}
        opt.OtherFields (1,:) string
        opt.Ncols (1,1) uint32 {mustBeNumeric} = 1 % Unused
        opt.Xlimits (1,2) double {mustBeNumeric};
        opt.NodeNames (1,:) string
    end
%% GTlineplot(GTstruct, 'Field', 'value', 'OtherFields', {value}, 'Ncols', value, 'Xlimits', 'value', 'NodeNames', {value})
%
% This function takes as input a GTstruct object (object with results from a
% analysis with BCT_analysis.m script) and
% create a lineplot with all results. Useful for
% inspection. The function also uses a customize datatip to help identify
% the Node.
%
% Parameters:
%   GTstruct (struct): a GTstruct object (a struct with results of GT analysis).
%
% Other Parameters:
%   Field ([str]): the name of the field tha will be plotted.
%   OtherFields ([str]): a cell with other fields to be added (typically subject name labels).
%   Ncols (int): unused
%   Xlimits ([Xmin, Xmax]): x limits
%   NodeNames ([str]): the names of the Nodes (to be displayed in the x axis).
%
% Author: Giorgio Arcara
%
% version: 12/01/2018
%

Field = opt.Field;
OtherFields = opt.OtherFields;
Ncols =  opt.Ncols;
Xlimits =  opt.Xlimits;
NodeNames = opt.NodeNames;

if isempty(NodeNames);
    CoordNames='';
end;



% initialize object to be used for the Xticks (the node labels)
curr_names = cell(1, length(GTstruct));

figure
for iSubj = 1:length(GTstruct)
    set(gca,'TickLabelInterpreter', 'none');
    
    hold on
   subj_values = GTstruct(iSubj).(Field);

    for iN = 1:length(subj_values);
        plot([0, subj_values(iN)], [iN iN], 'black');
    end;
    % define curr name
    if ~isempty(OtherFields)
        % define OtherFields in a loop (if several fields are supplied).
        if (iscell(OtherFields) & length(OtherFields)>1)
            curr_name =[];
            for iF=1:length(OtherFields)
                curr_name = [curr_name, ' ', GTstruct(iSubj).(OtherFields{iF})];
            end;
        else
            curr_name =  GTstruct(iSubj).(OtherFields{1});
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
OtherFields(curr_names)
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




