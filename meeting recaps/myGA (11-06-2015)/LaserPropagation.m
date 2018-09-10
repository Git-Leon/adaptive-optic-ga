function [I1,I2,I3,phase] = LaserPropagation(PhaseCoeff,Npad)
%
% Compute the propagation of the laser up to focus
% 
% Syntax: [I1,I2,I3] = LaserPropagation(PhaseCoeff,Npad)
% 
% PhaseCoeff = vector of size 1*NumVar
%
A2=13;  % Factor for defocusing in closer and more distant z plane
FWHM=0.4; % FHWM of laser amplitude in near field (in pixels)
NumVar=length(PhaseCoeff); % Number of polynomial coefficients

% x is space variable on the SLM (512 pixels for 4 mm). It is centered
% at x=0 and goes from -1 to +1
Nx=512; x=1:Nx; x=x-Nx/2; x=x/(Nx/2);

% Near field amplitude
amp0=exp(-2*log(2)*(x.^2)/(FWHM^2));
% Create the phase of member
%%%%% OPTION 1 : Polynomial phase %%%%%%
%phase = polyval(PhaseCoeff(1:NumVar),x);

%%%%% OPTION 2 : Polynomial phase on each side of x=0, with symmetry %%%%%%
%%%%x1=x(1:0.5*Nx); % x1 not used
x2=x(1+0.5*Nx:Nx);
phase2 = polyval(PhaseCoeff(1:NumVar),x2);
phase1 = fliplr(phase2);
phase = [phase1 phase2];

amp1=amp0.*exp(1i*phase).*exp(-1i*A2*x.^2);
amp2=amp0.*exp(1i*phase);
amp3=amp0.*exp(1i*phase).*exp(1i*A2*x.^2);

amp0FF=fftshift(fft(amp0,Npad));
amp1FF=fftshift(fft(amp1,Npad));
amp2FF=fftshift(fft(amp2,Npad));
amp3FF=fftshift(fft(amp3,Npad));

I0=abs(amp0FF).^2;
I1=abs(amp1FF).^2;
I2=abs(amp2FF).^2;
I3=abs(amp3FF).^2;

I1=I1/max(I0);
I2=I2/max(I0);
I3=I3/max(I0);

end

