%% GTbrainplot(GTstruct, 'NodeField', 'value, 'EdgeField','value', 'LabelFields',{value}, 'Coords', value, 'Ncols', value, 'BrainPath','value', 'Labels', {value},'Cmap', value, 'CamView', value, 'CortexAlpha', value, 'ConnNodes', 1, 'NodeSize', 1)
%
% This function plot graph informations (nodes and edges) as specified.
%
% INPUT:
%       - GTstruct:    a structure containing GT data
%       - NodeField:   the field containing node information (it should be a
%                      vector 1 x N). It will determine the size of nodes.
%       - EdgeField:   the field containing the edge information (typically a
%                      binarized matrix, N x N)
%       - LabelFields: the fields of the Labels
%       - Coords:      a matrix with x, y, z cooridnates of the Node.
%       - Ncols :     the number of columns
%       - BrainPath:   the path containing the brain information.
%       - Cmap:        the colormap for nodes. If empty red nodes will be
%                      displayed
%       - Labels:      logical, should Labels be showed?.
%       - Camview:     in angle, default is [0, 90]
%       - Quality:     char: 'lq', for fast low quality figures. 'HQ', for
%                       high quality figures for publications
%       - CortexAlpha: alpha (transparency) for the Cortex.
%       - ConnNodes: 0 or 1. if 1 plot only connected nodes form EdgeField.
%       - Nodesize: default is 1, dimension of Nodes. Used only if
%       Nodefield is not supplied.
%
% by default the brain data is taken from a folder 'Default/BrainMesh_ICBM152.nv'
% Coords are xyz of node coordinates.
%
% Author : Giorgio Arcara
%
%



function GTbrainplot(GTstruct, varargin)

p = inputParser;
addParameter(p, 'FigureHandle', [], @(x) isgraphics(x, 'figure'));
addParameter(p,'PlotTitle', '',  @(x) ischar(x) || isstring(x) || iscell(x))
addParameter(p, 'NodeField',[], @ischar);
addParameter(p, 'EdgeField', [], @ischar);
addParameter(p, 'NodeLabels', [], @(x) iscell(x) && isvector(x));
addParameter(p, 'Coords', [],@isstruct);
addParameter(p, 'Ncols', [],@isnumeric);
addParameter(p, 'BrainPath',[], @ischar);
addParameter(p, 'Labels', false, @islogical);
addParameter(p, 'Cmap',[], @isnumeric);
addParameter(p, 'CamView',[], @isnumeric);
addParameter(p, 'Quality',[], @ischar);
addParameter(p, 'CortexAlpha',[], @isnumeric);
addParameter(p, 'ConnNodes',1, @isnumeric);
addParameter(p, 'NodeSize',1, @isnumeric);


parse(p,  varargin{:});

FigureHandle = p.Results.FigureHandle;
PlotTitle = p.Results.PlotTitle;
NodeField = p.Results.NodeField;
EdgeField = p.Results.EdgeField;
NodeLabels = p.Results.NodeLabels;
Coords = p.Results.Coords;
Ncols = p.Results.Ncols;
BrainPath = p.Results.BrainPath;
Labels = p.Results.Labels;
Cmap = p.Results.Cmap;
CamView = p.Results.CamView;
Quality = p.Results.Quality;
CortexAlpha = p.Results.CortexAlpha;
CortexAlpha = p.Results.CortexAlpha;
ConnNodes = p.Results.ConnNodes;
NodeSize = p.Results.NodeSize;


% load brain structure info

if ~exist('BrainPath') || isempty(BrainPath);
    BrainPath= 'Default/BrainMesh_ICBM152.nv';
end;

% if ~exist('node_multi')  || isempty(node_multi);
%     node_multi = 10/length(GTstruct);
% end;

if isempty(Coords)
    error('GT: you must specify a Coord struct with xyz field indicating node coordinate');
end;

if isempty(Ncols);
    Ncols = length(GTstruct);
end;

if isempty(Labels);
    Labels = 0;
end;

if isempty(Cmap)
    Cmap= [1, 0, 0];
end;

if isempty(CamView)
    CamView= [0, 90];
end;

if isempty(Quality)
    Quality='lq';
end;

if isempty(CortexAlpha)
    CortexAlpha=0.3;
end;

if ConnNodes
    fprintf('\nGT: ConnNodes set to 1: only connected nodes have been plotted\n');
end;




[vertex_number Braincoord ntri tri]=MF_load(BrainPath);

% define rows and columns
tot_n = length(GTstruct);

% define number of cols
n_rows = round(length(GTstruct) / Ncols);

if isempty(FigureHandle)
    FigureHandle = figure;
else
    figure(FigureHandle); clf;  % Clear content if reusing
end



for iSubj=1:length(GTstruct)

    subplot(n_rows, Ncols, iSubj)
    %subplot_tight(n_rows, Ncols, iSubj, .05)

    if (~isempty(NodeField)&ischar(NodeField))

        node_values = (GTstruct(iSubj).(NodeField));
        %node_values(node_values~=0)=node_values(node_values~=0)*node_multi;
    elseif (isempty(NodeField))
        % create vector of dim 1 if node size is not supplied
        node_values = repmat(NodeSize, [1, size(GTstruct(iSubj).(EdgeField),1)]);
    end;

    % exclude here Co
    if ConnNodes
        edge_matrix = GTstruct(iSubj).(EdgeField);
        node_values(~any(edge_matrix)&~any(edge_matrix'))=0;
    end;



    %Brainplot = plot3(coord(1,:),coord(2,:), coord(3,:), '.', 'MarkerSize', 1e-28, 'color', [0.99 0.99 0.99]);

    hold on

    %% PLOT BRAIN
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.8, 0.8, 0.8],'EdgeColor','none', 'FaceAlpha', 1 , 'EdgeAlpha', 1);


    %% LOW QUALITY
    if strcmp(Quality, 'lq')

        node_values = node_values*20+1; % because cannot use scatter3 with 0 values

        alpha(CortexAlpha)

        % PLOT EDGES
        if (~isempty(EdgeField))
            [edgeX, edgeY, edgeZ]= adjacency_plot_und( GTstruct(iSubj).(EdgeField), Coords.xyz);

            [row, col] = find(GTstruct(iSubj).(EdgeField));
            for i = 1:length(row)
                x = row(i);
                y = col(i);

                edge_val = GTstruct(iSubj).(EdgeField)(x,y);
                if isnan(edge_val)
                    continue %Skip if is NaN
                end

                x_coords = [Coords.xyz(x,1), Coords.xyz(y,1)];
                y_coords = [Coords.xyz(x,2), Coords.xyz(y,2)];
                z_coords = [Coords.xyz(x,3), Coords.xyz(y,3)];

                edge_val = GTstruct(iSubj).(EdgeField)(x,y);


                % Define color of edge on the plot. Red is positive, blue
                % is negative
                if edge_val > 0
                    edge_color = [0.8 0 0]; % red
                else edge_val < 0
                    edge_color = [0 0 0.8]; % blue
                end

                plot3(x_coords, y_coords, z_coords, 'LineWidth', 2, 'Color', edge_color);
            end



            % Detect connected nodes based on non-NaN edges
            edge_matrix = GTstruct(iSubj).(EdgeField);

            connected_nodes = any(~isnan(edge_matrix), 2) | any(~isnan(edge_matrix), 1)';

            scatter3(Coords.xyz(connected_nodes,1), ...
                Coords.xyz(connected_nodes,2), ...
                Coords.xyz(connected_nodes,3), ...
                abs(node_values(connected_nodes)), ...
                node_values(connected_nodes), ...
                'filled');



        end;

        % High Quality
        if strcmp(Quality, 'HQ')
            alpha(CortexAlpha)
            camlight left;
            lighting phong

            edge_matrix = GTstruct(iSubj).(EdgeField);
            [row,col] = find(edge_matrix);
            % Add coordinates and it draws the edge cilinders
            for i=1:length(col);

                x=col(i);
                y=row(i);


                X1=Coords.xyz(x,:);
                X2=Coords.xyz(y,:);

                r=edge_matrix(y,x);
                n=2000;
                cyl_color=[0.8588    0.2667    0.2157];
                Cylinder(X1,X2,r,n,cyl_color,0,0);

                hold on
            end

            hold on

            % draw the spherical nodes
            scatter3sph(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), 'size', node_values, 'trans', 1);
        end;

        if Labels && ~isempty(NodeLabels)
            text(Coords.xyz(connected_nodes,1), ...
                Coords.xyz(connected_nodes,2), ...
                Coords.xyz(connected_nodes,3), ...
                NodeLabels(connected_nodes), ...
                'FontSize', 8, 'Color', 'k', 'HorizontalAlignment', 'left');
        end




        % set colormap
        colormap(Cmap)

        % set view
        view(CamView);
        %get rid of axis
        axis off;
        % rotation won't change the size
        axis vis3d

    end;

    % %% PLOT title
    % if ~isempty(NodeLabels)
    %     % define title in a loop (if several fields are supplied).
    %     if (iscell(NodeLabels) & length(NodeLabels)>1)
    %         panel_title =[];
    %         for iF=1:length(NodeLabels)
    %             panel_title = [panel_title, ' ', GTstruct(iSubj).(NodeLabels{iF})];
    %         end;
    %     else
    %         panel_title =  GTstruct(iSubj).(NodeLabels);
    %     end
    %
    %     title( panel_title );
    % end;

    hold off

    if ~isempty(PlotTitle)
        if iscell(PlotTitle)
            if iSubj <= length(PlotTitle)
                curr_title = PlotTitle{iSubj}

            else
                curr_title = ''
            end
        else
            curr_title = PlotTitle
        end
        title(curr_title, 'Interpreter', 'none', 'FontSize', 10, 'Color','k')
    end
    




end   