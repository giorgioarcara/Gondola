%launch this script after Gondola_sample_code

%% CREATE DESIGN AND CONTRASTS  (X in NBSglm object)
[myDesign, myContrast] = GTNBSDesign(12, 15);

% data matrix (y in GLM object). it is the vectorized version of the
% triupper of matrices.
y1 = GT2NBSdata(GTSchiz, 'InField', 'mat_or');
y2 = GT2NBSdata(GTHealthy, 'InField', 'mat_or');

y = [y1; y2];

%% create GLM
% combine effects in a single GLM.
GLM.X=myDesign;
GLM.y=y;
GLM.test='ttest';
GLM.perms=5000;
GLM.contrast=myContrast;
%GLM.exchange = GTNBSEBlocks(size(y1,1))

NBSglm_res = NBSglm(GLM);

%% calculate statistics

STATS.thresh=3.1; % arbitrary (see NBS tutorial)
STATS.alpha = 0.05; % 
STATS.size = 'Extent';
STATS.N = 74; % number of Nodes of the matrices
STATS.test_stat = NBSglm_res;

% for fdr
[N_CNT,CON_MAT,PVAL] = NBSfdr(STATS);
%for nbs statistics
[N_CNT,CON_MAT,PVAL] = NBSstats(STATS);

%% plot results
NBSstat_res.n = 1;
NBSstat_res.con_mat = CON_MAT;
NBSstat_res.node_coor = Coords.xyz;
NBSstat_res.node_label = Coords.labels;
NBSstat_res.pval(1) = PVAL;

% visualize results
NBSview(NBSstat_res)

%% plot results with GTbrainplot
GTres.mat_res=CON_MAT{1};
GTbrainplot(GTres, 'EdgeField', 'mat_res', 'Coords', Coords, 'Quality', 'HQ', 'NodeSize', 3)

