% -------------------------------------------------------------------
% --------------- Sort members from most to least fit ---------------
% -------------------------------------------------------------------

function F = FitnessFct(I1,I2,I3)

% Define convergence as similarity between profiles

% Minimum value allowed for intensity peaks
MinOfMax=0.2;

F12=sum(abs(I1-I2));
F13=sum(abs(I1-I3));
F23=sum(abs(I2-I3));

% F is fitness parameter used
if (max(I1) < MinOfMax) || (max(I2) < MinOfMax) || (max(I3) < MinOfMax)
    % In this case, the max of intensity are too small, so we don't keep
    F=100;

else
    F=(F12+F13+F23)/3;
    %F=F13;
end





end