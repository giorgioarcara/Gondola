%% GONDOLA SAMPLE SCRIPT
clear; clc; close all

% INITIALIZE TOOLBOX (it should be in the search path).
gondola

%% DESCRIPTION
% this script perform a whole network analysis in Gondola
% using the data available with the NBS toolbox (Zalesky, Fornito,
% Bullmore, 2010).
%
% the script load the data, and the extract a network measure (node degree)


% IMPORT - Option 1
% import connectivity matrices from files
% (note you should change the path, with your path).
%file_names = get_file_names('/Users/giorgioarcara/Desktop/prova');
gondola_path = fileparts(which('gondola'));
data_path = fullfile(gondola_path, 'functions/External/NBS1.2/SchizophreniaExample/matrices');
file_names = get_file_names(data_path);
GTstruct = GTdlmread(file_names, "DataPath", data_path);

GTstruct = GTaddvalue(GTstruct,'InField', 'Subject', 'NewValue', 1:length(GTstruct));

%% IMPORT - Option 2
% load Connectivity Matrices from NBS toolbox sample data 
%(it is a node x node x subject matrix)
% NBS_data = load('matrices.mat');
% NBS_datamat = NBS_data.Mat;
% 
% % convert NBS data matrix to GTstruct containing Subject elements 
% % and a mat_or field with node x node matrix
% for iS = 1:size(NBS_datamat,3)
%     GTstruct(iS).mat_or = NBS_datamat(:,:, iS);
%     GTstruct(iS).Subject = num2str(iS)
% end;

%% add group info 
% here I manually add the information (this is based on info in NBS
% toolbox)
% first 12 files are patients with Schizophrenia
% remaining 15 files are healthy controls.
%[GTstruct(1:12).group]= deal('Schiz');
%[GTstruct(13:27).group]= deal('Healthy');
GTstruct = GTaddvalue(GTstruct, 'InField', 'group', 'NewValue',{'Schiz'}, 'Elements', 1:12);
GTstruct = GTaddvalue(GTstruct,'InField', 'group', 'NewValue',{'Healthy'}, 'Elements', 13:27);



%% Import data for Coord object
% on crucial object in Gondola, is the coord object
% Coord is a struct with 'xyz' coordinates and 'labels' of the nodes of
% connectivity matrices.

% note that the files in the next lines are loaded from 
% gondola_code/External/NBS1.2/SchizophreniaExample

%load coordinates and put in a single Coord object
Coord_xyz = readtable('COG.txt', 'Delimiter', ' ', 'ReadVariableNames', 0, 'HeaderLines', 0);
Coord_labels = readtable('nodeLabels.txt', 'Delimiter', '\t', 'ReadVariableNames', 0, 'HeaderLines', 0);
Coords.xyz = table2array(Coord_xyz);
Coords.labels = table2array(Coord_labels);

% create a backup og the GTstruct(you never know).
GTstruct0 = GTstruct;

%% use the help 
% take your time to check the help of each function
help GTmeasure
help GTaverage

%% make some operations on connectivity matrices
% use only positive values 
% Data are initially correlation data ranging from -1 to 1. Set negative
% values to 0.
GTstruct = GToperation(GTstruct, 'InFields', {'mat_or'},  'OtherFields', {'FileName', 'Subject', 'group'}, 'Operation', 'GT1(GT1<0)=0; GTres=GT1' );

% calculate threshold
GTstruct = GTthreshold(GTstruct, 'InField', 'mat_or',  'Perc', 95, 'ThreshFieldName', 'mat_thresh');
GTimagesc(GTstruct(6), 'DataField', 'mat_thresh', 'LabelFields', {'Subject'});
% binarize
GTstruct = GTbinarize(GTstruct, 'InField', 'mat_thresh', 'OutField', 'mat_bin');
GTimagesc(GTstruct(6), 'DataField', 'mat_bin', 'LabelFields', {'Subject'});

% calculate node degree
GTstruct = GTmeasure(GTstruct, 'InField', 'mat_bin', 'MeasureFunc', 'degrees_und', 'MeasureName', 'degree');


%% DIVIDE IN SEPARATE STRUCTS
GTSchiz = GTsel(GTstruct, 'InField', 'group', 'Content','Schiz');
GTHealthy = GTsel(GTstruct, 'InField', 'group', 'Content', 'Healthy');

GTSchiz_ave = GTaverage(GTSchiz, 'InFields', {'mat_or', 'mat_thresh'});
GTHealthy_ave = GTaverage(GTHealthy, 'InFields', {'mat_or', 'mat_thresh'});

GTm = GToperation2(GTSchiz_ave, GTHealthy_ave, 'InFields',  {'mat_or'},  'operation', 'GTres=GT1/GT2');


%% plot some images
GTimagesc(GTSchiz(1:6), 'DataField', 'mat_or', 'LabelFields', {'Subject'}, 'Ncols', 2)
GTimagesc(GTSchiz(1:6), 'DataField', 'mat_thresh', 'LabelFields', {'Subject'}, 'Ncols', 2)
GTimagesc(GTSchiz(1:6), 'DataField', 'mat_bin', 'LabelFields', {'Subject'}, 'Ncols', 2)

%% plot node degree line
GTlineplot(GTSchiz(1), 'DataField', 'degree', 'LabelFields', {'Subject'}, 'NodeNames', Coords.labels);


%% 3D brain plot
% plot low quality brain with edges and node degrees (as node size)
GTbrainplot(GTSchiz(1), 'NodeField', 'degree', 'EdgeField', 'mat_bin','Coords', Coords, 'Quality', 'lq', 'CamView', [0, 90],'CortexAlpha', 0.1);


GTbrainplot2(GTSchiz(1:2), GTHealthy(1:2), 'NodeField', 'degree', 'EdgeField', 'mat_bin','Coords', Coords, 'Quality', 'lq', 'CamView', [0, 90],'CortexAlpha', 0.1);


% set up a high-quality plot with a similar call
% for better graphic in this case, I multiply the values of node degree by 0.5 (it would look like better).
GTSchiz_plot = GToperation(GTSchiz(1), 'InField', {'degree'}, 'OtherFields', {'mat_thresh'},  'operation', 'GTres=GT1*0.5');
GTbrainplot(GTSchiz_plot(1), 'NodeField', 'degree', 'EdgeField', 'mat_thresh','Coords', Coords, 'Quality', 'HQ', 'CamView', [0, 90],'CortexAlpha', 0.1);

%% Permutation test

[obs_diff_mat, p_mat_fdr, p_mat_unc, Rand_res] = GTpermute_bet2_test(GTHealthy, GTSchiz,  'InField', 'mat_or', 'Iterations', 1000);


GTthreshimage(obs_diff_mat, 'CoordNames', Coords.labels, 'Thresholds', [-Inf, 0.1],'ThreshMat', p_mat_fdr,'DrawLabels', 1)

%% export to Table for analysis
% this function convert results to a table for analysis in matlab, but could also be used to export to a .txt file. 
ResTable = writeGTresNode(GTstruct, 'ResFields', {'degree'}, 'LabFields', {'Subject','group'},  'NodeLabels', Coords.labels);

% to export the result to an external File.
% ResTable = writeGTresNode(GTstruct, 'ResFields', {'degree'}, 'LabFields',
% {'Subject','group'}, 'OutFileName', 'Exported_data.csv', 'NodeLabels', Coords.labels);
%reimport data back
%data = readtable('Exported_data.csv', 'ReadVariableNames', 1, 'HeaderLines', 0);

% a short non-parametric analysis with Mann-Whitney
% comparing the node degree in the Superior parietal cortex between the two
% groups
data= ResTable;

data_sel = data(strcmp(data.NodeLabels, 'Parietal_Sup_R'),:);
v1 = table2array(data_sel(strcmp(data_sel.group, 'Schiz'), 'degree'));
v2 = table2array(data_sel(strcmp(data_sel.group, 'Healthy'), 'degree'));
[P_val, ~, Umann] = ranksum(v1,v2);
P_val

%% now you can go to the next sample Script for GLM with NBS using Gondola as interface

open Step2_Gondola_NBS_sample_script
