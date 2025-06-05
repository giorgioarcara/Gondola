%% GTbstfileScoutselect - Select specific ROIs from Brainstorm connectivity matrices
% GTbstfileScoutselect(FileNames, ROIs, 'InDir', path, 'OutDir', path )
%
% GTbstfileScoutselect selects a subset of ROIs from brainstorm
% connectivity matrices and saves new .mat files  that contain only the
% specified ROIs
% 
%
% Inputs:
%   FileNames (string array):
%       Filenames of Brainstorm connectivity matrices as exported with
%       process_export_conn_mat
%   
%   ROIs (string array):
%       Names of ROIs to retain (must match names in the original
%       Brainstorm structs)
%
%   InDir (string, optional):
%       Input folder path. Default: './'
%   
%   OutDir (string, optional):
%       Output folder path. Default: './'
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
%
% Version: 19/05/2025

function GTbstfileScoutselect(FileNames, ROIs, opt)
    arguments
        FileNames (1,:) string
        ROIs (1,:) string
        opt.InDir (1,1) string {mustBeFolder} = './'
        opt.OutDir (1,1) string {mustBeFolder} = './'
    end



InDir = opt.InDir;
OutDir = opt.OutDir;


if ~exist(OutDir, 'dir')
    mkdir(OutDir)
end


% load all data
for iFile = 1:length(FileNames)
    curr_Conn = load(fullfile(InDir, FileNames{iFile}));
    curr_Conn = curr_Conn.Conn; % enter in the struct loaded
    
    [~, roi_ind, ~] = intersect(curr_Conn.RefRowNames, ROIs);
    
    curr_Conn.TF = 'this field has been erased after using GTfileROIselect function';
    
    % select in connectiviry matrix
    curr_Conn.conn_mat = squeeze(curr_Conn.conn_mat);
    curr_Conn.conn_mat = curr_Conn.conn_mat(roi_ind, roi_ind, :);
    
    % overwrite ROI names
    curr_Conn.RefRowNames = ROIs;
    
    % create object with original name
    Conn = curr_Conn;
    
    % save in ouput dir
    save(fullfile(OutDir, FileNames{iFile}), 'Conn')    
    
end;
