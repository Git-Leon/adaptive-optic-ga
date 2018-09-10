%% Run experiment
function [x,fval, exitflag, output, population, scores, results] = ...
    testGA(no_members, no_gens, stall_lim, technique, no_genes, phase_range, pad_size, min_grade)        
        global gaopts;
        global myfuns;
        

        % FUNCTION HANDLE; mutate function
        myfuns.mutate = @(member) mutate_solution(member, phase_range, no_genes);
        
        % FUNCTION HANDLE; creation function
        fcn_create = @(no_members)...%, no_genes)...%,n_genes, no_members) ...
            createPop(phase_range, no_genes, no_members);
        
        % FUNCTION HANDLE; generate a single solution
        myfuns.createOne = @() createPop(phase_range, no_genes, 1);
        
        % FUNCTION HANDLE; fitness function
        fcn_fitness = @(entities)...%, no_genes) ... set experiment & control variables
             fitnesses(entities, pad_size, min_grade, technique, 5);
        
        % generate initial population
        initPop = fcn_create(no_genes);
                
        % set options        
        gaopts = gaoptimset(...
            'PopulationSize', no_members,...
            'Generations', no_gens,...
            'StallGenLimit', stall_lim,...
            'Display', 'iter',...                        
            'PlotFcns', getPlotOptions(1,3,10),...
            'Vectorized', 'on',...
            'CreationFcn', fcn_create, ...
            'InitialPopulation', initPop);
        
        % Call GA
        [x,fval,exitflag,output, population, scores] = ...
            ga(fcn_fitness, no_members, [],[],[],[],[],[],[],gaopts);
        
        % Save results as cell structure
        results = {x,fval,exitflag,output, population, scores};
        
        
         
        %checkscores(mems, technique, @(member, technique) ...
             %fitness(member, pad_size, min_grade, technique, 5, 0))
        
end

%% Set selected plot options for GA
function my_options = getPlotOptions(varargin)

	% declare all plot options
	all_options = { ...
        @gaplotbestf, ...           1
        @gaplotbestindiv, ...       2
        @gaplotdistance, ...        3
        @gaplotexpectation, ...     4
        @gaplotgenealogy, ...       5
        @gaplotmaxconstr, ...       6
        @gaplotrange, ...           7
        @gaplotselection, ...       8
        @gaplotscorediversity, ...  9
        @gaplotscores, ...          10
        @gaplotstopping};%          11

    % set selected plot options
    my_options = cell(1, nargin);
    for j = 1:nargin
        my_options{j} = all_options{varargin{j}};
    end
end

function scores = checkscores(members, technique, fn)
	nmems = length(members)
	for j = 1:nmems;
        scorez(j) = fn(members{j}, technique);
        display(j/nmems);
    end
    scores = scorez
end