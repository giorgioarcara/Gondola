function GTbstfileScoutselect(FileNames, ROIs, opt)
    arguments
        FileNames (1,:) string
        ROIs (1,:) string
        opt.InDir (1,1) string {mustBeFolder} = './'
        opt.OutDir (1,1) string {mustBeFolder} = './'
    end
%% GTbstfileScoutselect(GTbstfiles, ROIs, 'InDir', path, 'OutDir', path)
%
% This function take as input several GT .mat files.
% It loads the files and write new files in which only some ROis are inclued
%
% Parameters:
%   FileNames ([str]): a cell of file names of GT structure (as exported by process_conn_mat)
%   ROIs ([str]): a cell with ROI names (as in Brainstorm struct)
%
% Other Parameters:
%   InDir (str): the input path. Default: './'
%   OutDir (str): the output path. Default: './new_mat_files'
%
% Author: Giorgio Arcara
%
% version: 1/2/2018


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
