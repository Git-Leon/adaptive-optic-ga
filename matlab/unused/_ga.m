function [x,fval,exitFlag,output,population,scores] = myGA(fun,nvars,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,intcon,options)
defaultopt = struct('PopulationType', 'doubleVector', ...
    'PopInitRange', [0;1], ...
    'PopulationSize', 20, ...
    'EliteCount', 2, ...
    'CrossoverFraction', 0.8, ...
    'MigrationDirection','forward', ...
    'MigrationInterval',20, ...
    'MigrationFraction',0.2, ...
    'Generations', 100, ...
    'TimeLimit', inf, ...
    'FitnessLimit', -inf, ...
    'StallGenLimit', 50, ...
    'StallTimeLimit', inf, ...
    'TolFun', 1e-6, ...
    'TolCon', 1e-6, ...
    'InitialPopulation',[], ...
    'InitialScores', [], ...
    'InitialPenalty', 10, ...
    'PenaltyFactor', 100, ...
    'PlotInterval',1, ...
    'CreationFcn',@gacreationuniform, ...
    'FitnessScalingFcn', @fitscalingrank, ...
    'SelectionFcn', @selectionstochunif, ...
    'CrossoverFcn',@crossoverscattered, ...
    'MutationFcn',{{@mutationgaussian 1  1}}, ...
    'HybridFcn',[], ...
    'Display', 'final', ...
    'PlotFcns', [], ...
    'OutputFcns', [], ...
    'Vectorized','off', ...
    'UseParallel', 'never');

% Check number of input arguments
errmsg = nargchk(1,11,nargin);
if ~isempty(errmsg)
    error(message('globaloptim:ga:numberOfInputs', errmsg));
end

% If just 'defaults' passed in, return the default options in X
if nargin == 1 && nargout <= 1 && isequal(fun,'defaults')
    x = defaultopt;
    return
end

if nargin < 11, options = [];
    if nargin < 10,  intcon = [];
        if nargin < 9,  nonlcon = [];
            if nargin < 8, ub = [];
                if nargin < 7, lb = [];
                    if nargin <6, beq = [];
                        if nargin <5, Aeq = [];
                            if nargin < 4, bineq = [];
                                if nargin < 3, Aineq = [];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

% Is third argument a structure
if nargin == 3 && isstruct(Aineq) % Old syntax
    options = Aineq; Aineq = [];
end

% Is tenth argument a structure? If so, integer constraints have not been
% specified
if nargin == 10 && isstruct(intcon)
    options = intcon;
    intcon = [];
end

% One input argument is for problem structure
if nargin == 1
    if isa(fun,'struct')
        [fun,nvars,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,intcon,rngstate,options] = separateOptimStruct(fun);
        % Reset the random number generators
        resetDfltRng(rngstate);
    else % Single input and non-structure. 
        error(message('globaloptim:ga:invalidStructInput'));
    end
end

% If fun is a cell array with additional arguments get the function handle
if iscell(fun)
    FitnessFcn = fun{1};
else
    FitnessFcn = fun;
end

% Only function handles or inlines are allowed for FitnessFcn
if isempty(FitnessFcn) ||  ~(isa(FitnessFcn,'inline') || isa(FitnessFcn,'function_handle'))
    error(message('globaloptim:ga:needFunctionHandle'));
end

% We need to check the nvars here before we call any solver
valid =  isnumeric(nvars) && isscalar(nvars)&& (nvars > 0) ...
    && (nvars == floor(nvars));
if ~valid
    error(message('globaloptim:ga:notValidNvars'));
end

% Specific checks and modification of options for mixed integer GA
if ~isempty(intcon)   
    % Check whether the user has specified options that the mixed integer
    % solver will either ignore or error.
    gaminlpvalidateoptions(options);    
    % If a user doesn't specify PopInitRange, we want to set it to the
    % bounds when we create the initial population. Need to store a flag
    % that indicates whether the user has specified PopInitRange so we can
    % do this in the creation function.
    UserSpecPopInitRange = isa(options, 'struct') && ...
        isfield(options, 'PopInitRange') && ~isempty(options.PopInitRange);
    % Change the default options for PopulationSize and EliteCount here.
    defaultopt.PopulationSize = max(min(10*nvars, 100), 40);
    defaultopt.EliteCount = floor(0.05*defaultopt.PopulationSize);
end

user_options = options;
% Use default options if empty
if ~isempty(options) && ~isa(options,'struct')
        error(message('globaloptim:ga:optionsNotAStruct'));
elseif isempty(options)
    options = defaultopt;
end
% Take defaults for parameters that are not in options structure
options = gaoptimset(defaultopt,options);

% Check for non-double inputs
msg = isoptimargdbl('GA', {'NVARS','A',   'b',   'Aeq','beq','lb','ub'}, ...
                            nvars,  Aineq, bineq, Aeq,  beq,  lb,  ub);
if ~isempty(msg)
    error('globaloptim:ga:dataType',msg);
end

[x,fval,exitFlag,output,population,scores,FitnessFcn,nvars,Aineq,bineq,Aeq,beq,lb,ub, ...
    NonconFcn,options,Iterate,type] = gacommon(nvars,fun,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,intcon,options,user_options);

if exitFlag < 0
    return;
end

% Turn constraints into right size if they are empty.
if isempty(Aineq)
    Aineq = zeros(0,nvars);
end
if isempty(bineq)
    bineq = zeros(0,1);
end
if isempty(Aeq)
    Aeq = zeros(0,nvars); 
end
if isempty(beq)
    beq = zeros(0,1);
end

% Call appropriate single objective optimization solver
if ~isempty(intcon)   
    [x,fval,exitFlag,output,population,scores] = gaminlp(FitnessFcn,nvars, ...
        Aineq,bineq,Aeq,beq,lb,ub,NonconFcn,intcon,options,output,Iterate,...
        UserSpecPopInitRange);
else    
    switch (output.problemtype)
        case 'unconstrained'
            [x,fval,exitFlag,output,population,scores] = gaunc(FitnessFcn,nvars, ...
                options,output,Iterate);
        case {'boundconstraints', 'linearconstraints'}
            [x,fval,exitFlag,output,population,scores] = galincon(FitnessFcn,nvars, ...
                Aineq,bineq,Aeq,beq,lb,ub,options,output,Iterate);
        case 'nonlinearconstr'
            [x,fval,exitFlag,output,population,scores] = gacon(FitnessFcn,nvars, ...
                Aineq,bineq,Aeq,beq,lb,ub,NonconFcn,options,output,Iterate,type);
    end
end