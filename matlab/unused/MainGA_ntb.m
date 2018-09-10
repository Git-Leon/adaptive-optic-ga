%% Init program
clear all; close all; clc; 
diary OFF; force_delete('diary'); diary ON;
savefig = @(num) saveas(figure(num), sprintf('fig%d', num), 'bmp');
printl = @(varargin) display(arrayfun(@(i) sprintf('%c',i), cell2mat(varargin)));
progress = @(i,n,t) printl(...
    'Program running...', ...
    sprintf('\n\tIteration: %d', i), ...
    sprintf('\n\tPercentage completed: %.4f%%', (i/n)*100), ...
    sprintf('\n\tTime elapsed: %.5f seconds', t), ...
    sprintf('\n\tEstimated time remaining: %.5f minutes\n', ( (t/(i/n)) - toc)/60) );

%% Initial values
no_gens = 1000; % number of generations
no_members = 36; % number of parents / members per generation
no_genes = 10; % number of genes; polynomial coefficients
no_steps = 10; % number of loop iteration between each plot
pad_size = 2^13; % size of vector for zero padding for FFT
technique = 0; % technique for creating phase member
RangeOfPhase = 100; % Range of phase coefficient to try (+- Range) as random number
offspring_range = 0.5*RangeOfPhase;
fit_fun = @(entities) ... assign default values for fitness function
     fitnesses(entities, no_genes, RangeOfPhase, pad_size, technique);

%% Initiate parents.
% Create phase coefficient for all parents.
% (matrix of size no_genes x no_members)
parents = RangeOfPhase*(rand(no_genes, no_members)-0.5);
parent_grades = fit_fun(parents);

%% Initiate offspring
% populate offspring Fitness values vectors with zero (and convergence)
% The two values initially used are F (Fitness parameters) and parents
new_generation=zeros(no_genes, 2*no_members);
sorted_generation=zeros(size(new_generation));

%% Evolutionary Loop
for gen_i = 1:no_gens
    if (gen_i == 1)
        figure(2); figure(3); figure(1);
        pause; tic; % First pass has a pause to organize graph on screen
    end; progress(gen_i,no_gens,toc);
    
    % half of offspring are yielded by random mutations
    random_members = RangeOfPhase*(rand(no_genes,no_members/2)-0.5);
        random_members_grades = fit_fun(random_members); % Fitness of offspring ii

    % half of offspring created yielded by parents
    mutated_members = parents(:,1:no_members/2) + ...
        offspring_range*(rand(no_genes,no_members/2)-0.5);
         mutated_members_grades = fit_fun(mutated_members); % Fitness of offspring ii

    
    %figure(4);
    %plot(random_members_grades,'+r');
    %title('New random members');
    %grid on;
    
    offspring = [random_members, mutated_members];    
    offspring_grades = fit_fun(offspring); % Fitness of offspring ii

    %figure(5);
    %plot(offspring_grades,'+k');
    %title('New members from parents');
    %grid on;
    
    
    grades=[parent_grades offspring_grades]; % Fitness parameters of all parents & offspring
    new_generation=[parents offspring];
    
    % Select the best members for next generation
    [grades_sorted, order] = sort(grades);
    for ii=1:no_members
        prev_index = order(ii);
        sorted_generation(:,ii)=new_generation(:,prev_index);
    end
    
    % Create next generation (remove unwanted members)
    parent_grades=grades_sorted(1,1:no_members);
    parents=sorted_generation(:,1:no_members);
    convergence(gen_i)=mean(parent_grades(1:no_members));

%% Plot figure only every no_steps generations
    if (mod(gen_i, no_steps) == 0 || gen_i == no_members)

        
        figure(1);
        hold off;
        plot(random_members_grades,'+b','Linewidth',2);
        hold on;
        plot(mutated_members_grades,'+r','Linewidth',2);
        plot(offspring_grades,'--k','Linewidth',2);
        plot(parent_grades,'+k'); grid on;
        legend('Random members grade','Mutated members','Offspring','Next generation (best offspring + best parents) ');
        %axis([1 no_members 0 2*max(parent_grades)]);

        
        
        
        figure(2);
        title('Algorithm Convergence');
        plot(convergence,'Linewidth',2);
        grid on;
        xlabel('# of Generations');
        ylabel('Average Best Grade');
        
        [I1best,I2best,I3best,phase] = LaserPropagation(parents(:,1), pad_size, technique);

        figure(3);
%        title('Best member');
        subplot(1,2,1);
        plot(phase,'k','Linewidth',2);
        grid on;
        xlabel('space coordinate on the SLM (x)');
        title('Phase shape given by SLM (in radian)');
        
        subplot(1,2,2);
        plot(I1best,'b'); hold on; plot(I2best,'r');
        plot(I3best,'k'); hold off;
        grid on; legend('I1','I2','I3');
        xlabel('space coordinate of camera (x)');
        title('camera intensity I (number of photon)');
        axis([3500 4500 0 1])
        
    end
end; diary OFF; toc;
savefig(1); savefig(2); savefig(3);