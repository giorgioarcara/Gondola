%% GTres_rand = GTrandomize(GTres, resfield, iterations, measure_func)
% 
% This function start from a GTstruct object and create a null distribution
% by randomizing the matrices (with the randomizer_bin_und function from
% BCT) and then computing a measure on these newled shuffled matrices.
% it allows to estimate null results at single subject level.
% 

function GTres_rand = GTrandomize(GTres, resfield, iterations, measure_func)
myfunc = str2func(measure_func);


% Initialize matrix from the results of the first object
sizes_GT_res = size( myfunc(GTres(1).(resfield)) );

res_size = [sizes_GT_res, iterations];

GTres_rand = zeros(res_size);

for iIter = 1:iterations
    
    GTres_rand_curr = struct();
    for iRes = 1:length(GTres);
        try
        curr_rand = randomizer_bin_und(GTres(iRes).(resfield), 1);
        catch
            curr_rand = zeros(size(GTres(iRes).(resfield)));
        end;
        GTres_rand_curr(iRes).measure = myfunc(curr_rand); % note the generic name "measure" as field
            %fprintf([num2str(iIter), num2str(iRes), '\n']);

    end;
    curr_Ave = GTaverage(GTres_rand_curr, {'measure'});
    
    GTres_rand(:,:,iIter) = curr_Ave.measure;
    
    
        
end;


end
