%% GTres_rand = GTrandomize_conn(GTres, resfield, iterations)
%
% This function start from a GTstruct object and randomize the connection of the input matrices
% to create a null distribution (with the randomizer_bin_und function from
% BCT). It can be used to randomize data at single level.
%

function GTres_rand = GTrandomize_conn(GTres, resfield, varargin)

if nargin<3
    iterations = 1000;
elseif nargin == 3,
    iterations = varargin{1};
end;


for iIter = 1:iterations
    
    GTres_rand_curr = struct();
    for iRes = 1:length(GTres);
        try
            curr_rand = randomizer_bin_und(GTres(iRes).(resfield), 1);
        catch % NOTE! the try-catch is necessary to deal with the cases of no connections.
            curr_rand = zeros(size(GTres(iRes).(resfield)));
        end;
        GTres_rand_curr(iRes).(resfield) = curr_rand;
    end;
    
    if iIter ==1
        GTres_rand = GTres_rand_curr;
    else
    GTres_rand(end+1) = GTres_rand_curr;
    
end;


end
