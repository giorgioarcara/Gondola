%% GTfileROIselect(GTfiles, ROIs, indir, outdir)
%
% This function take as input several GT .mat files.
% It loads the files create new files in which only some ROis are inclued
%
% INPUT:
% - GTfiles: a cell of file names of GT structure (as exported by
% process_conn_mat
% - ROIs: a cell with ROI names (as in Brainstorm struct)
% - indir: the search folder for the files.
% - outdir: the output folder where the files will be created
%
%
% INPUT:
% - cell with file names of GTstruct files or a series
%
% Author: Giorgio Arcara
%
% version: 1/2/2018

function GTfileROIselect(GTfiles, ROIs, indir, outdir)

if ~exist(indir)
    indir='';
end

if ~exist(outdir)
    outdir='';
end

if length(GTfiles)==0
    error('no files supplied');
end;


% load all data
for iFile = 1:length(GTfiles)
    curr_Conn = load([indir, GTfiles{iFile}]);
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
    save([outdir, GTfiles{iFile}], 'Conn')    
    
end;
