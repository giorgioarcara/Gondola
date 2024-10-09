%% writeBNWnode(Coords, Labels, Col, Size, outdir)
%
% This function take as input coordinates and labels and returns a file
% ready to be used for visualization with BrainNetViewer software.
% Optionally Color and Size can be supplied. If not a default value of 1
% will be used.
%
% INPUT:
% - Coord: a matrix with x, y, z Coordinates, in MNI space of the nodes
% - Labels: a cell with node labels. The length should be equal to Coords.
% - Size:  vector of numbers that will be used to denote the node size
% (same length of Coord). Default is 1.
% - Color:  a vector of numbers that will be used to denote the node color (same
% length of Coord). Default is 1.
%
% Output: an ASCII .node file with the following columns: x,y,z,size,
% col, name
%

function nodes =  writeBNWnode(Coords, Labels, varargin)

if nargin < 2
  error('2 inputs are mandatory')
elseif nargin == 2
  outdir = '';
  Size = 1;
  Col = 1;
elseif nargin == 3
  Col = varargin{1};
  Size = 1;
  outdir = '';
elseif nargin == 4
  Col = varargin{1};
  Size = varargin{2};
  outdir = '';
elseif nargin == 5
  Col = varargin{1};
  Size = varargin{2};
  outdir = varargin{3};
end

% check if the dir exists otherwise it creates it
if ~exist(outdir, 'dir')  
    mkdir(outdir);
end

% 
% if ~exist('Size')
%     Size=1;
% end;
% 
% if ~exist('Col')
%     Col=1;
% end;

if (~isequal( size(Coords, 1), length(Labels)))
    error('There is an inconsistency between Coord and Labels dimensions. Check the objects');
    
else nrow = size(Coords,1);
    
end


% create node size vectors (if  only one value is supplied)
if length(Size)==1
    Size = repmat(Size, nrow, 1);
end

% create node (if  only one value is supplied)
if length(Col)==1
    Col = repmat(Col, nrow, 1);
end

%% preliminary checks of consistency

if (~isequal(length(Labels), length(Size), length(Col)))
    error('There is an inconsistency between Size or Colors and the Coords. Check the objects');
    
else nrow = size(Coords,1);
    
end

% reshape to be sure that in the following code I can concatenate.
Col = reshape(Col, length(Col), 1);
Size = reshape(Size, length(Size), 1);


mat = [Coords,  Col, Size];
% 
% 
% export_name = [outdir, 'BNW_nodes.node']

export_name = fullfile(outdir, 'BNW_nodes.node');
fprintf('*** export file *** %s \n', export_name);

fid = fopen(export_name, 'w');

for i=1:size(mat, 1);%    
    fprintf(fid, '%d\t', mat(i,:)); % print Coord
    fprintf(fid, '%s', Labels{i}); % print Coord
    fprintf(fid, '\n', '');
end
fclose(fid);

