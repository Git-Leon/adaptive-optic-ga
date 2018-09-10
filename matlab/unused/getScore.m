


function pop_score = getScore(population, technique, no_genes, coeff, pad_size)
    fit = @(members, technique) ...
        fitnesses(members, no_genes, coeff, pad_size, technique);
    %pop_score = arrayfun(@(t) fit(t, 1), population)

    %no_solutions = size(population,1)
    %no_solutions = size(population,2)
    %for j = 1:no_solutions
    pop_score = fit(population, technique)
        %pop_score(j) = fit(population(j,:), technique);
        %population(j,:)
    %end
        
end