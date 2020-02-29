%% GTfilecheck(GTfiles, indir)
%
% This function take as input several GT .mat files.
% THen it load and make some check of consistency, returning errors if an
% inconsistency is found. The first file is taken as reference and compared
% to all the others.
%
% INPUT:
% - GTfiles: a cell of file names of GT structure (as exported by
% process_conn_mat
% - indir: the search folder for the files.
%
%
% Current checks are:
%
% - check if fields are the same
% - check if RefRowNames are the same (in the same order)
% - check if frequency specification are the same
% - check if time window specified for analysis is the same.
%
% INPUT:
% - cell with file names of GTstruct files or a series
%
% Author: Giorgio Arcara
%
% version: 12/1/2018

function GTfilecheck(GTfiles, indir)
% first in a loop load all files and retrieve all info
% then in another loop make all the comparisons
% (I use this strategy because in some case the loop is not necessary)

if ~exist('indir')
    indir='';
end

if length(GTfiles)==0
    error('no files supplied');
end;

GTfiles = strcat(indir, GTfiles);

GTcheck = cell(length(GTfiles));

GTcheck = struct();

% load all data
for iFile = 1:length(GTfiles)
    curr_mat = load(GTfiles{iFile});
    curr_mat = curr_mat.Conn; % enter in the struct loaded
    
    % GET FIELD NAMES
    curr_GTfields = fields(curr_mat);
    
    GTcheck(iFile).fieldnames = curr_GTfields;
    
    % GET NODE LABELS
    GTcheck(iFile).RefRowNames = curr_mat.RefRowNames;
    
    % GET FREQUENCIES
    GTcheck(iFile).Freqs = curr_mat.Freqs;
    
    % GET TIME SPEC
    GTcheck(iFile).Time = curr_mat.Time;
end;

%% CHECKS
% all checks start with the firs object that is taken as reference and
% then loop over all the others

Ref = GTcheck(1);


fprintf('GTCheck Results:\n');

everything_ok= 1;
% loop over all subject after the first
for iCheck = 2:length(GTcheck)
    
    % fieldnames
    if ~isequal(GTcheck(iFile).fieldnames, Ref.fieldnames)
        warning(['-- Field Names are inconsistent in',  GTfiles{iFile}, 'as compared to the reference, ', GTfiles{1}], 0);
        everything_ok= 0;
    end;
    
    % fieldnames
    if ~isequal(GTcheck(iFile).RefRowNames, Ref.RefRowNames)
        warning(['-- Row Names are inconsistent in',  GTfiles{iFile}, 'as compared to the reference, ', GTfiles{1}], 0);
        everything_ok= 0;
    end;
    
    % Frequencies
    if ~isequal(GTcheck(iFile).Freqs, Ref.Freqs)
        warning(['-- Freqs are inconsistent in',  GTfiles{iFile}, 'as compared to the reference, ', GTfiles{1}], 0);
        everything_ok= 0;
    end;
    
    % Time
    if ~isequal(GTcheck(iFile).Time, Ref.Time)
        warning(['-- Time are inconsistent in',  GTfiles{iFile}, 'as compared to the reference, ', GTfiles{1}], 0);
        everything_ok= 0;
        
    end;
    
end
if everything_ok == 1
    fprintf('-- No inconsistencies found.\n');
end;
