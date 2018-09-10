%progress = @(ratio) display(sprintf('\nExecution running...\n\tPercentage completed: %.4f%%\n\tTime Elapsed: %.5f seconds', ratio, toc));
clear all; close all; clc;
warning('off','MATLAB:colon:nonIntegerIndex');
plusOrMinus = @(val) (-1)^(round(rand()) + 1) * val;
randRange = @(min, max, rows,columns) (max-min).*rand(rows,columns) + min;
printl = @(varargin) display(arrayfun(@(i) sprintf('%c',i), cell2mat(varargin)));
progress = @(ratio) printl(...
    'Execution running...', ...
    sprintf('\n\tPercentage completed: %.4f%%', ratio), ...
    sprintf('\n\tTime elapsed: %.5f seconds\n', toc));
tic;

Ngen=3000;         % Number of generations
Nparents=100;      % Number of parents / members per generation
NumVar=10;         % These are the polynomial coefficients. Also number of genese
RangeOfCoeff=100; % Range of phase coefficient to try (+- Range) as random number
Npad=2^13;        % size of vector for zero padding for FFT
KidsRange=0.5*RangeOfCoeff;
Nplot= 4;        % Number of loop iteration between each plot

% Initiate parents. Create the phase coefficient for all parents.
% (matrix of size NumVar*parent_count)
PhaseCoeff = RangeOfCoeff*(rand(NumVar,Nparents)-0.5);
I1p=zeros(Npad,Nparents); I2p=zeros(Npad,Nparents); I3p=zeros(Npad,Nparents);
F=zeros(1,Nparents); 
for ii=1:Nparents
%[a,b,c] = LaserPropagation(PhaseCoeff(:,ii),Npad);
[I1p(:,ii),I2p(:,ii),I3p(:,ii)] = LaserPropagation(PhaseCoeff(:,ii),Npad);
F(ii)=FitnessFct(I1p(:,ii),I2p(:,ii),I3p(:,ii));
end

% To check intensity with flat phase
%coeff0=[0 0 0 0 0];
%[I1best,I2best,I3best] = LaserPropagation(coeff0,Npad);
%figure(3);
%plot(I1best-0.005,'b'); hold on; plot(I2best,'r');
%plot(I3best+0.005,'k'); hold off;
%grid on; legend('I1','I2','I3');
%axis([1000 3000 -0.005 1.005]);

%%%%%%%%%%%%%% KIDS %%%%%%%%%%%%%%%%
% Before loop, fill Kids Fitness values vectors with zero (and convergence)
% The two values initially used are F (Fitness parameters) and PhaseCoeff
Fk=zeros(1,Nparents); 
I1k=zeros(Npad,Nparents); I2k=zeros(Npad,Nparents); I3k=zeros(Npad,Nparents);
PhaseCoeffAll=zeros(NumVar,2*Nparents);
SortedPhaseCoeffAll=zeros(size(PhaseCoeffAll));
%convergence=zeros(1,Ngen);
for gen_i = 1:Ngen
    progress(gen_i/Ngen*100);
    
    % create Kids from parents
    % half of kids are new
    PhaseCoeffk1 = RangeOfCoeff*(rand(NumVar,Nparents/2)-0.5);
    % half of kids created from parents
    PhaseCoeffk2 = PhaseCoeff(:,1:Nparents/2)+...
        KidsRange*(rand(NumVar,Nparents/2)-0.5);
    PhaseCoeffk=[PhaseCoeffk1 PhaseCoeffk2];
    
    for ii=1:Nparents
    [I1k(:,ii),I2k(:,ii),I3k(:,ii)] = LaserPropagation(PhaseCoeffk(:,ii),Npad);
    Fk(ii)= FitnessFct(I1k(:,ii),I2k(:,ii),I3k(:,ii));
    end
    
    % Add the kids with previous parents
    Fall=[F Fk];
    PhaseCoeffAll=[PhaseCoeff PhaseCoeffk];
    
    % Select the best members for next generation
    [FsortedAll,orderAll]=sort(Fall);
    for ii=1:Nparents
        oldindex=orderAll(ii);
        SortedPhaseCoeffAll(:,ii)=PhaseCoeffAll(:,oldindex);
    end
    
    % Create next generation (remove unwanted members)
    F=FsortedAll(1,1:Nparents);
    PhaseCoeff=SortedPhaseCoeffAll(:,1:Nparents);
    convergence(gen_i)=mean(F(1:Nparents));

    % Plot figure only every Nplot generations
    if (gen_i == 1)
    figure(1);
    hold off;
    plot(Fk,'+b');
    hold on;
    plot(F,'+r'); grid on;
    legend('Kids Fitness','Next generation fitness');
    axis([1 Nparents 0 2*max(F)]);

    figure(2);
    title('Algorithm Convergence');
    %plot(1:Ngen,convergence(1:Ngen),'Linewidth',2);
    plot(convergence,'Linewidth',2);
    grid on;
    xlabel('# of Generations');
    ylabel('Average Best Grade');
    %axis([0 gen_i 0 convergence(1)]);
 
    [I1best,I2best,I3best,phase] = LaserPropagation(PhaseCoeff(:,1),Npad);
    figure(3);
    title('Best Result');
    subplot(2,1,1);
    plot(I1best,'b'); hold on; plot(I2best,'r');
    plot(I3best,'k'); hold off;
    grid on; legend('I1','I2','I3');
    %axis([500 3500 0 max(I2best)]);
    subplot(2,1,2);
    plot(phase,'k','Linewidth',2);
    grid on;
    pause; % First pass has a pause to organize graph on screen
    
    elseif (mod(gen_i,Nplot) == 1)
    figure(1);
    hold off;
    plot(Fk,'+b');
    hold on;
    plot(F,'+r'); grid on;
    legend('Kids Fitness','Next generation fitness');
    axis([1 Nparents 0 2*max(F)]);

    figure(2);
    title('Algorithm Convergence');
    %plot(1:Ngen,convergence(1:Ngen),'Linewidth',2);
    plot(convergence,'Linewidth',2);
    grid on;
    xlabel('# of Generations');
    ylabel('Average Best Grade');
    %axis([0 gen_i 0 convergence(1)]);
 
    [I1best,I2best,I3best,phase] = LaserPropagation(PhaseCoeff(:,1),Npad);
    figure(3);
    title('Best Result');
    subplot(2,1,1);
    plot(I1best,'b'); hold on; plot(I2best,'r');
    plot(I3best,'k'); hold off;
    grid on; legend('I1','I2','I3');
    %axis([500 3500 0 max(I2best)]);
    subplot(2,1,2);
    plot(phase,'k','Linewidth',2);
    grid on;
    end
end



