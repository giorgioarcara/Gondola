%% writeGTresGlobal(GTres, 'ResFields',{value}, 'LabFields', {value}, OutDir, 'value')
%
% This function take as input several a GTres struct (as obtained by a
% BCT_analysis.m script) and export the results of a Global variable 
% (i.e., one value per each GTres instance) in a friendly format for statistical analysis
% Data are exported in long format.
%
% INPUT:
% - GTres: a GTres object (a struct with results of GT analysis).
% - ResFields: a cell with the names of the fields that should be exported
% - LabFields: a cell with other fields to be added (typically subject name labels)
% - OutDir= a string with the directory of the file to be saved
%
% Author: Giorgio Arcara
%
% version: 12/1/2018


function writeGTresGlobal(GTres, varargin)
p = inputParser;
addParameter(p, 'ResFields', [], @iscell);
addParameter(p, 'LabFields', [], @iscell);
addParameter(p, 'OutDir', [], @isstring);


parse(p, varargin{:});

ResFields = p.Results.ResFields;
LabFields =  p.Results.LabFields;
OutDir =  p.Results.OutDir;


%% ResFields (numeric results to be exported, one per Subejct).

res_names = fields(GTres);

res_cell=squeeze(struct2cell(GTres));

% find indices corresponding to name
[~, ind, ~] = intersect(res_names, ResFields);

restemp = res_cell(ind, :);

res = cell2mat(restemp);
res = res';

%% LabFields (numeric results to be exported, one per Subject).

% find indices corresponding to name
[~, ind, ~] = intersect(res_names, LabFields);

lab = res_cell(ind, :);

lab = lab';

export_lab = lab;

%% EXPORT FILE FOR NBS
export_file=[OutDir 'GT_Globalresults.txt'];

fid = fopen(export_file, 'w');

fprintf(fid, '%s ', ResFields{:});
fprintf(fid, '%s ', LabFields{:});
fprintf(fid, '\n', '');

for i=1:size(res,1);%
    fprintf(fid, '%d ', res(i,:)); % print only Coordinates
    fprintf(fid, '%s ', export_lab{i, :});
    fprintf(fid, '\n', '');
end;
fclose(fid);
        
