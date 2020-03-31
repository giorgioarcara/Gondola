%% GTfileROIselect(GTfiles, 'ROIs',value, 'InDir',path, 'OutDir',path)
%
% This function take as input several GT .mat files.
% It loads the files create new files in which only some ROis are inclued
%
% INPUT:
% - GTfiles: a cell of file names of GT structure (as exported by
% process_conn_mat
% - ROIs: a cell with ROI names (as in Brainstorm struct)
% - InDir: the search folder for the files.
% - OutDir: the output folder where the files will be created
%
% Author: Giorgio Arcara
%
% version: 1/2/2018

function GTfileROIselect(GTfiles,varargin)
p = inputParser;
addParameter(p, 'ROIs', [], @ischar);
addParameter(p, 'InDir', [], @ischar);
addParameter(p, 'OutDir', [], @ischar);


parse(p, varargin{:});

ROIs = p.Results.ROIs;
InDir =  p.Results.InDir;
OutDir =  p.Results.OutDir;


if ~exist(InDir)
    InDir='';
end

if ~exist(OutDir)
    OutDir='';
end

if length(GTfiles)==0
    error('no files supplied');
end;


% load all data
for iFile = 1:length(GTfiles)
    curr_Conn = load([InDir, GTfiles{iFile}]);
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
    save([OutDir, GTfiles{iFile}], 'Conn')    
    
end;
