function ResTable = writeGTstructGlobal(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.ResFields (1,:) string {mustBeValidVariableName}
        opt.OtherField (1,:) string {mustBeValidVariableName}
        opt.FileName (1,1) string = "GT_Globalresults.txt"
    end
%% writeGTstructGlobal(GTstruct, 'ResFields', {value}, 'LabFields', {value}, 'FileName', 'value')
%
% This function take as input several a GTstruct struct (as obtained by a
% BCT_analysis.m script) and export the results of a Global variable 
% (i.e., one value per each GTstruct instance) in a friendly format for statistical analysis
% Data are exported in long format.
%
% Parameters:
%   GTstruct (struct): a GTstruct object (a struct with results of GT analysis).
%
% Other Parameters:
%   ResFields ([str]): a cell with the names of the fields that should be exported
%   LabFields ([str]): a cell with other fields to be added (typically subject name labels)
%   FileName (str): a string with the output file name. Default: 'GT_Globalresults.txt'
%
% Author: Giorgio Arcara
%
% version: 30/05/2021

ResFields = opt.ResFields;
LabFields =  opt.LabFields;
FileName =  opt.FileName;


%% ResFields (numeric results to be exported, one per Subejct).

res_names = fields(GTstruct);

res_cell=squeeze(struct2cell(GTstruct));

% find indices corresponding to name
[~,  ~, ind] = intersect(ResFields, res_names, 'stable');

restemp = res_cell(ind, :);

res = cell2mat(restemp);
res = res';

%% LabFields (numeric results to be exported, one per Subject).
% find indices corresponding to name
[~,  ~, ind] = intersect(LabFields, res_names, 'stable');

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
export_file=FileName;

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
        
