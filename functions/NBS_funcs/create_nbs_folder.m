%% create_nbs_folder(mat_files, RefCoord, Freq, indir, outdir)
% This function creates a folder (from GT files) with a structure for analysis for analysis
% with NBS toolbox.
%
% INPUT
% - mat_files: a cell with names of .mat files (GT type).
% - RefCoord: a file with coordinates associated with
% - indir (optional): the path were the input files were stored
% - outdir (optional): the path where the new folder structure will be created
%
% OUTPUT
% a folder named "NBS_analysis" with the data ready to be used for NBS
% analysis. Object ar also stored as Data_Mat.
%
% AUTHOR: Giorgio Arcara
%
% Version: 10/01/2018


function [Data_mat, Coord_mat, Coord_lab] = create_nbs_folder(mat_filenames, RefCoord, Freq, indir, outdir)

if ~exist('indir')
    indir='';
end;

if ~exist('outdir')
    outdir='NBS_analysis';
    mkdir(outdir);
end;

if ~exist('Freq')
    Freq = 1;
end;


%mkdir([outdir, 'Input Data']);

%% !!! MISSING !!!
% function that make checks over all files!
% !!!

%% save .mat objects (only data)
Data_cell = cell(1, length(mat_filenames));

for iFile = 1:length(mat_filenames)
    curr_filename = mat_filenames{iFile};
    curr_file = load([indir, curr_filename]);
    
    % check if there is a field called type
    % and if the type is set to GTmat
    if isfield(curr_file, 'Conn')
        if isfield(curr_file.Conn, 'type')
            if strcmp(curr_file.Conn.type, 'GTmat')
                % the GTstruct2mat functions already contains a looop
                %GTfile2mat(curr_filename, indir, [outdir, 'Input Data/'], Freq)
                curr_conn_mat = squeeze(curr_file.Conn.conn_mat);
                % select frequencies if necessary (i.e., if there is a
                % higher dimension).
                if (length(size(curr_conn_mat))==3)
                    curr_conn_mat = curr_conn_mat(:,:,Freq);
                end;
                Data_cell{iFile}=curr_conn_mat; % get rid of fourth dimension if present.         
          
            end;
        end;
        
    else error(['the ', num2str(iFile), ' object is not recognized']);
        
    end;



% currently unsupported (make a separate call to WriteNBSDesign)

end;
Data_mat_temp = squeeze(cell2mat(Data_cell));
mat1 = squeeze(Data_cell{1}); % get as reference

Data_mat = reshape(Data_mat_temp, size(mat1, 1), size(mat1, 2), length(Data_cell));

save([outdir, 'Conn_matrices.mat'], 'Data_mat');

%% save Coordinates (get from last files)

% get from last obejct (assume they are all the same)
Scouts = curr_file.Conn.RefRowNames;

% get new Scouts name (modified to match the Reference)
NewScouts = scouts2Coord_bst(Scouts);

[Coord_mat, Coord_lab] = writeNBSCoords(NewScouts, RefCoord, outdir);

%% save NodeLabels

writeNBSlabels(NewScouts, [outdir])
