function mutant = mutate_solution(solution, phase_range, no_genes)
    n = size(solution, 2); % second dimension; vector length
    mutant = solution + phase_range*(rand(no_genes,n)-0.5);
end