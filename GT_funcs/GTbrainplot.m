%% GTbrainplot(GTres, nodefield, edgefield, labelfields, Coords, n_cols, node_multi, brainpath, cmap, labels)
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
%
% by default the brain data is taken from a folder 'Default/BrainMesh_ICBM152.nv'
% Coords are xyz of node coordinates.
%
% Author : Giorgio Arcara
%
% 



function GTbrainplot(GTres, nodefield, edgefield, labelfields, Coords, n_cols, node_multi, brainpath, cmap, labels)

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

if (~exist('cmap'))
            cmap= [1, 0, 0];
end;

[vertex_number Braincoord ntri tri]=MF_load(brainpath);

% define rows and columns
tot_n = length(GTres);

% define number of cols
n_rows = round(length(GTres) / n_cols);

figure

for iSubj=1:length(GTres)
    
    subplot(n_rows, n_cols, iSubj)
    %subplot_tight(n_rows, n_cols, iSubj, .05)

    
    %Brainplot = plot3(coord(1,:),coord(2,:), coord(3,:), '.', 'MarkerSize', 1e-28, 'color', [0.99 0.99 0.99]);
    
    hold on
    
    %% PLOT BRAIN
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.9, 0.9, 0.9],'EdgeColor','none', 'FaceAlpha', 0.9, 'EdgeAlpha', 0.9);
    %camlight left;
    %lighting phong
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
        
        % set colormap
        colormap(cmap)
        
        % set view
        view(0, 90);
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
    %axis vis3d
    %get rid of axis
    set(gca, 'visible', 'off'); 

    
end;