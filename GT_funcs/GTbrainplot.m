%% GTbrainplot(GTstruct, 'NodeField', 'value, 'EdgeField','value', 'LabelFields',{value}, 'Coords', value, 'Ncols', value, 'BrainPath','value', 'Labels', {value},'Cmap', value, 'CamView', value, 'CortexAlpha', value)
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
%
% by default the brain data is taken from a folder 'Default/BrainMesh_ICBM152.nv'
% Coords are xyz of node coordinates.
%
% Author : Giorgio Arcara
%
%



function GTbrainplot(GTstruct, varargin)

p = inputParser;
addParameter(p, 'NodeField',[], @ischar);
addParameter(p, 'EdgeField', [], @ischar);
addParameter(p, 'LabelFields',[], @iscell);
addParameter(p, 'Coords', [],@isstruct);
addParameter(p, 'Ncols', [],@isnumeric);
addParameter(p, 'BrainPath',[], @ischar);
addParameter(p, 'Labels', [],@iscell);
addParameter(p, 'Cmap',[], @isnumeric);
addParameter(p, 'CamView',[], @isnumeric);
addParameter(p, 'Quality',[], @ischar);
addParameter(p, 'CortexAlpha',[], @isnumeric);


parse(p,  varargin{:});

NodeField = p.Results.NodeField;
EdgeField = p.Results.EdgeField;
LabelFields = p.Results.LabelFields;
Coords = p.Results.Coords;
Ncols = p.Results.Ncols;
BrainPath = p.Results.BrainPath;
Labels = p.Results.Labels;
Cmap = p.Results.Cmap;
CamView = p.Results.CamView;
Quality = p.Results.Quality;
CortexAlpha = p.Results.CortexAlpha;

% load brain structure info

if ~exist('BrainPath') || isempty(BrainPath);
    BrainPath= 'Default/BrainMesh_ICBM152.nv';
end;

% if ~exist('node_multi')  || isempty(node_multi);
%     node_multi = 10/length(GTstruct);
% end;
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



[vertex_number Braincoord ntri tri]=MF_load(BrainPath);

% define rows and columns
tot_n = length(GTstruct);

% define number of cols
n_rows = round(length(GTstruct) / Ncols);

figure

for iSubj=1:length(GTstruct)
    
    subplot(n_rows, Ncols, iSubj)
    %subplot_tight(n_rows, Ncols, iSubj, .05)
    
    
    %Brainplot = plot3(coord(1,:),coord(2,:), coord(3,:), '.', 'MarkerSize', 1e-28, 'color', [0.99 0.99 0.99]);
    
    hold on
    
    %% PLOT BRAIN
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.5, 0.5, 0.5],'EdgeColor','none', 'FaceAlpha', 1 , 'EdgeAlpha', 1);
    
    
    %% LOW QUALITY
    if strcmp(Quality, 'lq')
       alpha(CortexAlpha)
        
        % PLOT EDGES
        if (~isempty(EdgeField))
            [edgeX, edgeY, edgeZ]= adjacency_plot_und( GTstruct(iSubj).(EdgeField), Coords.xyz);
            plot3(edgeX, edgeY, edgeZ, 'LineWidth', 2);
        end
        %
        if (~isempty(NodeField))
            
            node_values = (GTstruct(iSubj).(NodeField));
            %node_values(node_values~=0)=node_values(node_values~=0)*node_multi;
            node_values = node_values+1; % add 1 cause I cannot plot nodes with values higher then zero.
        end
        %note that I use abs to specify the node size (so values like t
        %values can be used
        scatter3(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), (abs(node_values)), node_values, 'filled');
        
        %Extract rows and column of the connected nodes to extract the
        %coordinates
        
    end;
    
    if strcmp(Quality, 'HQ')
       alpha(CortexAlpha)
        camlight left;
        lighting phong
        
        [row,col] = find(GTstruct.(EdgeField));
        % Add coordinates and it draws the edge cilinders
        for i=1:length(col);
            
            x=col(i);
            y=row(i);
            
            
            X1=Coords.xyz(x,:);
            X2=Coords.xyz(y,:);
            
            r=1;
            n=2000;
            cyl_color=[0.8588    0.2667    0.2157];
            Cylinder(X1,X2,r,n,cyl_color,0,0);
            
            hold on
        end
        
        hold on
        
        % draw the spherical nodes
        scatter3sph(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), 'size', 3, 'trans', 1);
    end;
    
    if Labels
        text(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), Coords.Labels);
    end;
    
    % set colormap
    %colormap(Cmap)
    
    % set view
    view(CamView);
end;

%% PLOT title
if ~isempty(LabelFields)
    % define title in a loop (if several fields are supplied).
    if (iscell(LabelFields) & length(LabelFields)>1)
        panel_title =[];
        for iF=1:length(LabelFields)
            panel_title = [panel_title, ' ', GTstruct(iSubj).(LabelFields{iF})];
        end;
    else
        panel_title =  GTstruct(iSubj).(LabelFields);
    end
    
    title( panel_title );
end;

hold off

% rotation won't change the size
axis vis3d
%get rid of axis
set(gca, 'visible', 'off');


end