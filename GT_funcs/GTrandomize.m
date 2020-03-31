%% GTstruct_rand = GTrandomize(GTstruct, 'ResField', {value}, 'MeasureFunc', 'value, 'Iterations', value)
% 
% This function start from a GTstruct object and create a null distribution
% by randomizing the matrices (with the randomizer_bin_und function from
% BCT) and then computing a measure on these newled shuffled matrices.
% it allows to estimate null results at single subject level.

% - GTstruct:    data structure to randomize
% - ResField:    a cell with the fields of the GTstruct that should be used
% - Iterations:  number indicating the number of permutation (default is
%                1000).
% - MeasureFunc: the function (typically from the BCT toolbox) to
%                compute randomization
% 

function GTstruct_rand = GTrandomize(GTstruct, varargin)
p = inputParser;
addParameter(p, 'ResField', [], @iscell);
addParameter(p, 'MeasureFunc', [], @isstring);
addParameter(p, 'Iterations', [], @isnumeric)
parse(p, varargin{:});

ResField = p.Results.ResField;
MeasureFunc =  p.Results.MeasureFunc;
Iterations =  p.Results.Iterations;

if nargin < 4
    Iterations = 1000;
else
    Iterations = varargin{2};
end

myfunc = str2func(MeasureFunc);


% Initialize matrix from the results of the first object
sizes_GT_res = size( myfunc(GTstruct(1).(ResField)) );

res_size = [sizes_GT_res, Iterations];

GTstruct_rand = zeros(res_size);

for iIter = 1:Iterations
    
    GTstruct_rand_curr = struct();
    for iRes = 1:length(GTstruct);
        try
        curr_rand = randomizer_bin_und(GTstruct(iRes).(ResField), 1);
        catch
            curr_rand = zeros(size(GTstruct(iRes).(ResField)));
        end;
        GTstruct_rand_curr(iRes).measure = myfunc(curr_rand); % note the generic name "measure" as field
            %fprintf([num2str(iIter), num2str(iRes), '\n']);

    end;
    curr_Ave = GTaverage(GTstruct_rand_curr, {'measure'});
    
    GTstruct_rand(:,:,iIter) = curr_Ave.measure;
    
    
        
end;


end
