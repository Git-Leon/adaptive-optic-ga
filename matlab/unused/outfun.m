function [state,options,optchanged] = outfun(options,state,flag)    
    popsize = gaoptimget(options,'PopulationSize');
    flag = 0;
    state = 1;    
    optchanged = 3;
end