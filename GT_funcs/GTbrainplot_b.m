%% GTbrainplot(GTres, nodefield, edgefield, labelfields, Coords, n_cols, node_multi, brainpath, cmap, labels, camview)
%
% This function plot graph informations (nodes and edges) as specified.
% 
% INPUT: 
%       - GTres: a structure containing GT data
%       - nodefield: the field containing node information (it should be a
%       vector 1 x N). It will determine the size of nodes.
%       - edgefield: the field containing the edge information (typically a
%       binarized matrix, N x N)
%       - labelfields: the fields of the labels 
%       - Coords: a matrix with x, y, z cooridnates of the Node. 
%       - n_cols : the number of columns
%       - node_multi: the multiplier to be applied to the size of nodes.
%       - brainpath: the path containing the brain information.
%       - cmap: the colormap for nodes. If empty red nodes will be
%       displayed
%       - labels: logical, should labels be showed?.
%       - camview: a 1x2 matrix with azimuth and elevation of cam view.
%
% by default the brain data is taken from a folder 'Default/BrainMesh_ICBM152.nv'
% Coords are xyz of node coordinates.
%
% Author : Giorgio Arcara
%
% 



function GTbrainplot_b(GTres, varargin); %labelfields, Coords, n_cols, node_multi, brainpath, cmap, labels, camview)

default_brainpath = 'Default/BrainMesh_ICBM152.nv';
default_node_multi = 10/length(GTres);
default_labels = 0;
default_cmap=[1,0,0];
default_n_cols=length(GTres);
default_nodefield=[];
default_edgefield=[];
default_Coords=[];
default_camview=[0, 90];


p = inputParser;
addRequired(p, 'GTres', @isstruct);
addParameter(p, 'Coords', default_Coords, @isstruct);
addParameter(p, 'nodefield', default_nodefield,  @ischar);
addParameter(p, 'edgefield', default_edgefield, @ischar);
addParameter(p, 'labelfields', [], @iscell);
addParameter(p, 'labels', default_labels, @iscell);
addParameter(p, 'n_cols', default_n_cols, @isnumeric);
addParameter(p, 'camview', default_camview, @isnumeric);


parse(p, GTres, varargin{:});

nodefield = p.Results.nodefield;
edgefield = p.Results.edgefield;
labelfields = p.Results.labelfields;
labels = p.Results.labels;
n_cols = p.Results.n_cols;
Coords = p.Results.Coords;
camview = p.Results.camview;

% function a = findArea(width,varargin)
%    defaultHeight = 1;
%    defaultUnits = 'inches';
%    defaultShape = 'rectangle';
%    expectedShapes = {'square','rectangle','parallelogram'};
% 
%    p = inputParser;
%    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
%    addRequired(p,'width',validScalarPosNum);
%    addOptional(p,'height',defaultHeight,validScalarPosNum);
%    addParameter(p,'units',defaultUnits,@isstring);
%    addParameter(p,'shape',defaultShape,...
%                  @(x) any(validatestring(x,expectedShapes)));
%    parse(p,width,varargin{:});
%    
%    a = p.Results.width*p.Results.height; 
% end




% load brain structure info

if ~exist('brainpath') || isempty(brainpath);
    brainpath= 'Default/BrainMesh_ICBM152.nv';
end;

if ~exist('node_multi')  || isempty(node_multi);
    node_multi = 10/length(GTres);
end;

if ~exist('labels');
    labels = 0;
end;

[vertex_number Braincoord ntri tri]=MF_load(brainpath);

% define rows and columns
tot_n = length(GTres);

% define number of cols
n_rows = round(length(GTres) / n_cols);

figure('units','pixels','position',[0 0 1920 1080])

for iSubj=1:length(GTres)
    
    subplot(n_rows, n_cols, iSubj)
    
    %Brainplot = plot3(coord(1,:),coord(2,:), coord(3,:), '.', 'MarkerSize', 1e-28, 'color', [0.99 0.99 0.99]);
    
    hold on
    
    
    %% PLOT BRAIN
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.9, 0.9, 0.9],'EdgeColor','none', 'FaceAlpha', 0.9, 'EdgeAlpha', 0.9);
    camlight left;
    lighting phong
    alpha 0.3
    
    %% PLOT EDGES
    if (~isempty(edgefield))
        [edgeX, edgeY, edgeZ]= adjacency_plot_und( GTres(iSubj).(edgefield), Coords.xyz);
        plot3(edgeX, edgeY, edgeZ, 'LineWidth', 2);
    end
    
    if (~isempty(nodefield))
        
        node_values = (GTres(iSubj).(nodefield));
        node_values(node_values~=0)=node_values(node_values~=0)*node_multi;
        node_values = node_values+1; % add 1 cause I cannot plot nodes with values higher then zero.
        
        % note that I use abs to specify the node size (so values like t
        % values can be used
        scatter3(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), (abs(node_values)), node_values, 'filled');
        
        if labels
        text(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), Coords.labels);
        end;
        
        if (~exist('cmap'))
            colormap ([1, 0, 0]);
        else
            colormap(cmap);
        end;
        
        axis vis3d
        view(camview(1), camview(2));
    end;
    
    %% PLOT title
    if ~isempty(labelfields)
        % define title in a loop (if several fields are supplied).
        if (iscell(labelfields) & length(labelfields)>1)
            panel_title =[];
            for iF=1:length(labelfields)
                panel_title = [panel_title, ' ', GTres(iSubj).(labelfields{iF})];
            end;
        else
            panel_title =  GTres(iSubj).(labelfields);
        end
        
        title( panel_title );
    end;
    
    hold off
    
    % rotation won't change the size
    % get rid of axis
    set(gca, 'visible', 'off'); 

    
end;