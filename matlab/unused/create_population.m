% FUNCTION HANDLE; create population
function solutions = create_population(phase_range, no_genes, no_members)
    solutions = phase_range*(rand(no_genes, no_members)-0.5);
end