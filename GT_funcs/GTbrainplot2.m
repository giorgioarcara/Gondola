%% GTbrainplot(GTres1, GTres2 nodefield, edgefield, labelfields, Coords, node_multi, brainpath, cmap)
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
%
% by default the brain data is taken from a folder 'Default/BrainMesh_ICBM152.nv'
% Coords are xyz of node coordinates.
%
% Author : Giorgio Arcara
%
% 

function GTbrainplot2(GTres1, GTres2, nodefield, edgefield, labelfields, Coords, node_multi, brainpath)

% load brain structure info
if (length(GTres1)~=length(GTres2))
    error('the length of GTres1 and GTres2 should be the same');
end;

if ~exist('brainpath');
    brainpath= 'Default/BrainMesh_ICBM152.nv';
end;

if ~exist('node_multi');
    node_multi = 20/length(GTres1);
end;


if (~exist('cmap'))
    cmap= [1, 0, 0];
end;



[vertex_number Braincoord ntri tri]=MF_load(brainpath);

% define rows and columns
tot_n = length(GTres1);

n_cols = 2;
% define number of cols
n_rows = round(length(GTres1)*2 / n_cols);

figure

iPlot = 0;

for iSubj=1:length(GTres1)
    
    
   %% COLUMN 1
    iPlot = iPlot + 1;

    subplot(n_rows, 2, iPlot)
    
    %Brainplot = plot3(coord(1,:),coord(2,:), coord(3,:), '.', 'MarkerSize', 1e-28, 'color', [0.99 0.99 0.99]);
    
    hold on
    
    %% PLOT BRAIN 1
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.9, 0.9, 0.9],'EdgeColor','none', 'FaceAlpha', 0.9, 'EdgeAlpha', 0.9);
    %camlight left;
    %lighting phong
    alpha 0.3
    
    %% PLOT EDGES 1
    if (~isempty(edgefield))
        [edgeX, edgeY, edgeZ]= adjacency_plot_und( GTres1(iSubj).(edgefield), Coords.xyz);
        plot3(edgeX, edgeY, edgeZ, 'LineWidth', 2)
    end
    
    %% PLOT NODE 1
    if (~isempty(nodefield))
        scatter3(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), GTres1(iSubj).(nodefield)+1,  abs(GTres1(iSubj).(nodefield))+1, 'filled');
        view(0, 90);
    end;
    
    % set cmap
    colormap(cmap)
    
    %% PLOT title 1
    
    % define title in a loop (if several fields are supplied).
    if (iscell(labelfields) & length(labelfields)>1)
        panel_title =[];
        for iF=1:length(labelfields)
            panel_title = [panel_title, ' ', GTres1(iSubj).(labelfields{iF})];
        end;
    else
        panel_title =  GTres1(iSubj).(labelfields);
    end
    
    title( panel_title );
    
    hold off
    
    %% COLUMN 2
    iPlot = iPlot + 1;
    subplot(n_rows, 2, iPlot);

    %% PLOT BRAIN 2
    Brainplot = trisurf(tri, Braincoord(1,:),Braincoord(2,:), Braincoord(3,:), 'FaceColor', [0.9, 0.9, 0.9],'EdgeColor','none', 'FaceAlpha', 0.9, 'EdgeAlpha', 0.9);
    %camlight left;
    %lighting phong
    alpha 0.2
    
    hold on
    
    
    %% PLOT EDGES 2
    if (~isempty(edgefield))
        [edgeX, edgeY, edgeZ]= adjacency_plot_und( GTres2(iSubj).(edgefield), Coords.xyz);
        plot3(edgeX, edgeY, edgeZ, 'LineWidth', 2)
       
        
    end
    
    
    %% PLOT NODE 2
    if (~isempty(nodefield))
        scatter3(Coords.xyz(:,1), Coords.xyz(:,2), Coords.xyz(:,3), GTres2(iSubj).(nodefield)+1,  abs(GTres2(iSubj).(nodefield))+1, 'filled');
        view(0, 90);

    
    %% PLOT title 2
    
    
    % define title in a loop (if several fields are supplied).
    if (iscell(labelfields) & length(labelfields)>1)
        panel_title =[];
        for iF=1:length(labelfields)
            panel_title = [panel_title, ' ', GTres2(iSubj).(labelfields{iF})];
        end;
    else
        panel_title =  GTres2(iSubj).(labelfields);
    end
    
    title( panel_title );
    
    hold off
    
    % rotation won't change the size
    %axis vis3d
    % get rid of axis
    %set(gca, 'visible', 'off'); 
    
        
end;

end;