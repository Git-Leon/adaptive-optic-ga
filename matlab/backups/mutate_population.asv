%% mutate population
function mutants = mutate_population(solutions, phase_range, no_genes)
    n = size(solutions,2)/2; % number of output mutants
    mutants = solutions(:,1:n) + phase_range*(rand(no_genes,n)-0.5);
end