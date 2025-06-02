%% writeGTresGlobal - Export global GTstruct metrics in long format
% writeGTstructGlobal(GTstruct, 'ResFields', value, 'OtherFields', value, 'FileName', value)
%
% This function takes as input a GTstruct array (typically the result of 
% a BCT analysis script) and extracts one or more global-level measures 
% (i.e., a single value per subject or file), exporting them in a format 
% suitable for statistical analysis.
%
% The output is structured in long format: each row represents a
% subject/instance, and each variable (global metric or label) is a column.
% 
% Inputs:
%   GTstruct (struct array): An array of GT structs
%   
%   ResFields (string array, optional): Names of the fields in each
%   GTstruct that contain global metrics to be exported. 
%   
%   OtheFields (string array, optional): Names of additional fields to
%   include as labels (e.g. subject ID). 
%
%   FileName (string, optional): Name of the output file. Default:
%   'GT_Globalresults.txt'. 
%
%   Output:
%   ResTable: a MATLAB table containing all requested fields, ready for
%   export or statistical analysis. 
%
% Authors: Giorgio Arcara, Ettore Napoli, Alessandro Tonin
% Version: 20/05/2025



function ResTable = writeGTresGlobal(GTstruct, opt)
    arguments
        GTstruct (1,:) struct
        opt.ResFields (1,:) string {mustBeValidVariableName}
        opt.OtherField (1,:) string {mustBeValidVariableName}
        opt.FileName (1,1) string = "GT_Globalresults.txt"
    end


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
        
