%% Function to generate a random initial population of solutions
function Population = createPop(coeff_range, no_genes, popsize)
    

    %%%%%%%%%% Generate the initial population
    % Check correct values
    if(~(no_genes>0) || ~(coeff_range>0)),
        error('Check parameters GenomeLength and ntrucks for negative values.');
    end;
    % Preallocation of population
    Population = coeff_range*(rand(no_genes, popsize)-0.5);
end
