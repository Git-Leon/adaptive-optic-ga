%% Initial Setup
clc; close all;
diary OFF; force_delete('diary'); diary ON;
organize_workspace()
printl = @(varargin) ...
    sprintf(arrayfun(@(i) sprintf('%c',i), cell2mat(varargin)),0);
report = @(results) printl(...
    sprintf('\n-----------EXECUTION FINISHED-----------'), ...
    sprintf('\n\tBest score:\t\t%g', results{2}),...
    sprintf('\n\tTime elapsed:\t%.5f seconds', toc));

%% Experimental Setup

% Initial values
no_members = 20;
no_gens = 20;
stall_lim = 8;
no_genes = 20;
phase_range = 100;
pad_size = 2^13;
min_grade = 15; % min grade for mutation

fcn_getScore = @(member, technique) ...
    fitness(member, pad_size, min_grade, technique, 5, 0);

% FUNCTION HANDLE; fitness function
fcn_getScores = @(members, technique) ...
    fitnesses(members, pad_size, min_grade, technique, 5);

% FUNCTION HANDLE; run experiment
fcn_testGA = @(technique) ... set experiment & control values
    testGA(no_members, no_gens, stall_lim, technique, no_genes, phase_range, pad_size, min_grade);


%% Run Experiment
% Get Polynomial phase; technique0 - with symmetry
tic;
[best0, fval0, exitflag0, output0, population0, scores0, results0] = fcn_testGA(0);
report0 = report(results0); % get results0

tic;
[best1,fval1, exitflag1, output1, population1, scores1, results1] = fcn_testGA(1);
report1 = report(results1); % get results1

%% Print experiment details
display(report1);
display(report0);

diary OFF;