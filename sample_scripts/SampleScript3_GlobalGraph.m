% Sample Script 3

gondola_path = 'C:\Users\ettor\OneDrive - Università degli Studi di Padova\Desktop\GIT_Repos\Gondola_GIT'
gondola_dir = dir(gondola_path)
addpath(genpath(gondola_path))
custom_function_path = 'C:\Users\ettor\OneDrive - Università degli Studi di Padova\Desktop\PhD\Bologna\Papers\Data_Analysis\Custom_funcs/'
addpath(genpath(custom_function_path))
gondola

% Get file names
files_dir = "C:\Users\ettor\OneDrive - Università degli Studi di Padova\Desktop\PhD\Bologna\Papers\MMCI\Exported_FC_Matrices\Sample Script/"
file_names = get_file_names(files_dir)

% Create GTstruct
GTstruct = GTloadBst(file_names, 'conn_mat', 'Field', 'mat_or', 'InDir', files_dir)

GTstruct = GTloadBst(file_names, 'conn_mat', 'Field', 'mat_or', 'InDir', files_dir)
GTstruct_fieldnames = GTgetfields_FileName(file_names, 'Fields', 'ID_Condition_FCMeasure_FreqBand', 'Ignore', '.mat')
GTstruct = GTmerge(GTstruct, GTstruct_fieldnames)

% Extract upper diagonal
GTstruct = GTdiag_mat(GTstruct, ...
    'Field', 'mat_or', ...
    'Type', 'upper', ...
    'NewValue', 'mat_diag')

%Threshold
GTstruct = GTthreshold(GTstruct, ...
    'Field', 'mat_diag', ...
    'Perc', 90, ...
    'NewField', 'mat_thresh_diag');

% Build adjency matrix (binarize the thresholded one)
GTstruct = GTbinarize(GTstruct, ...
    'Field', 'mat_thresh_diag', ...
    'NewField', 'mat_bin_diag')

% Get labels from atlas (!!! it is fundamental that the scouts are in the
% same order as the ones used for getting the matrix)
atlas_scouts = GTloadBst(file_names(1), 'RowNames', 'Field', 'scouts', 'InDir', files_dir)
atlas_scouts = atlas_scouts.scouts

% Define the scouts within each RSNs
VisualNetwork = {'G_cuneus L','G_cuneus R','G_oc-temp_med-Lingual L','G_oc-temp_med-Lingual R','G_occipital_sup L','G_occipital_sup R'}
VisualNetwork = scouts2Coord_bst(VisualNetwork)
VentralAttentionNetwork = {'G_front_middle L','G_front_middle R','G_front_sup L','G_front_sup R','G_pariet_inf-Supramar L','G_pariet_inf-Supramar R'}
VentralAttentionNetwork = scouts2Coord_bst(VentralAttentionNetwork)
SomatoMotorNetwork = {'G_postcentral L','G_postcentral R','G_precentral L','G_precentral R','G_and_S_paracentral L','G_and_S_paracentral R'}
SomatoMotorNetwork = scouts2Coord_bst(SomatoMotorNetwork)
DorsalAttentionNetwork = {'G_parietal_sup L','G_parietal_sup R','S_oc-temp_lat L','S_oc-temp_lat R','S_precentral-sup-part L','S_precentral-sup-part R'}
DorsalAttentionNetwork = scouts2Coord_bst(DorsalAttentionNetwork)
DefaultModeNetwork = {'G_and_S_cingul-Ant L','G_and_S_cingul-Ant R','G_pariet_inf-Angular L','G_front_inf-Opercular L','G_cingul-Post-ventral L','G_cingul-Post-ventral R'}
DefaultModeNetwork = scouts2Coord_bst(DefaultModeNetwork)
ExecutiveControlNetwork = {'G_pariet_inf-Angular R','G_front_inf-Opercular R','G_precuneus L','G_precuneus R','G_and_S_frontomargin L','G_and_S_frontomargin R'}
ExecutiveControlNetwork = scouts2Coord_bst(ExecutiveControlNetwork)

% Define list of all networks
networks = {'DefaultModeNetwork', 'DorsalAttentionNetwork', 'ExecutiveControlNetwork', 'SomatoMotorNetwork', 'VentralAttentionNetwork', 'VisualNetwork'}

% Create a cell array of all the scouts of interest
AllUsedScouts = [VisualNetwork, VentralAttentionNetwork, SomatoMotorNetwork, DorsalAttentionNetwork, DefaultModeNetwork, ExecutiveControlNetwork]

% Create Coord object of the whole atlas
atlas_scouts = scouts2Coord_bst(atlas_scouts)
Coord_tot = getCoords(atlas_scouts, 'Destrieux.txt')

% Create Coord object of the used scouts
Coord_RSNs = getCoords(AllUsedScouts, 'Destrieux.txt')

% Select only the nodes of interest and derivate both thresholded and
% binarized matrices
GTstruct_AllNetworks = GTNodeSel(GTstruct, ...
    'Nodes', atlas_scouts, ...
    'SelNodes',AllUsedScouts, ...
    'Field', 'mat_or', ...
    'OtherFields', {'ID', 'Condition', 'FCMeasure','FreqBand'})
GTstruct_AllNetworks = GTthreshold(GTstruct_AllNetworks,...
    'Field', 'mat_or', ...
    'Perc', 90, ...
    'NewField', 'mat_thresh')
GTstruct_AllNetworks = GTbinarize(GTstruct_AllNetworks, ...
    'Field', 'mat_thresh', ...
    'NewField', 'mat_bin')

% Compute global graph indices - Global Efficiency
GTstruct_AllNetworks = GTmeasure(GTstruct_AllNetworks, ...
    'Field', 'mat_bin', ...
    'MeasureFunc','efficiency_bin', ...
    'MeasureName','GlobalEfficiency')

% Compute global graph indices - Modularity (Ci and Q)
GTstruct_AllNetworks = GTmeasure(GTstruct_AllNetworks, ...
    "Field",'mat_bin', ...
    'MeasureFunc', 'modularity_und', ...
    'MeasureName', 'Modularity_Ci', ...
    'OutputIndex',1)

GTstruct_AllNetworks = GTmeasure(GTstruct_AllNetworks, ...
    "Field",'mat_bin', ...
    'MeasureFunc', 'modularity_und', ...
    'MeasureName', 'Modularity_Q', ...
    'OutputIndex',2)

% Export data for statistical analysis
ResTable = writeGTresGlobal(GTstruct_AllNetworks, ...
    "Fields", {'GlobalEfficiency', 'Modularity_Q'}, ...
    'OtherFields',{'ID', 'Condition', 'FCMeasure', 'FreqBand'}, ...
    'FileName', fullfile(files_dir, 'risultati_global'))
