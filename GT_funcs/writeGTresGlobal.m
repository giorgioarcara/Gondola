%% writeGTresGlobal(GTres, 'ResFields',{value}, 'LabFields', {value}, 'OutFileName', 'value')
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
% - OutFileName= a string with the output file name.
%
% Author: Giorgio Arcara
%
% version: 12/1/2018


function ResTable = writeGTresGlobal(GTres, varargin)
p = inputParser;
addParameter(p, 'ResFields', [], @iscell);
addParameter(p, 'LabFields', [], @iscell);
addParameter(p, 'OutFileName', 'GT_Globalresults.txt', @ischar);


parse(p, varargin{:});

ResFields = p.Results.ResFields;
LabFields =  p.Results.LabFields;
OutFileName =  p.Results.OutFileName;


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


% create table
ResTable = table( );
for iF = 1:length(LabFields)
    ResTable.(LabFields{iF}) = export_lab(:,iF);
end;
for iRF = 1:length(ResFields)
    ResTable.(ResFields{iRF}) = res(:, iRF);
end;


%% EXPORT FILE
export_file=OutFileName;

fid = fopen(export_file, 'w');

sep=',';

fprintf(fid, ['%s', sep], ResFields{:});
fprintf(fid, ['%s', sep], LabFields{:});
fprintf(fid, '\n', '');

for i=1:size(res,1);%
    fprintf(fid, ['%d', sep], res(i,:));
    LabFields_exp = cellfun(@num2str, export_lab(i,:), 'UniformOutput', 0); % convert to str numeric fields in LabFields
    fprintf(fid, ['%s', sep], LabFields_exp{:});
    fprintf(fid, '\n', '');
end;
fclose(fid);
        
