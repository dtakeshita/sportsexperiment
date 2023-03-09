clear; close all;
% parameters 
dt = 1e-4;%time step
t = 0:dt:5;%time vector
f = 2;%frquency of sine wave
fn = 50;%frequency of noise
sigma = 0.1;%amplitude of noise
% generate a test signal
y = sin(2*pi*f*t);
% calculate time derivative
dydt = (y(3:end) - y(1:end-2))/(2*dt);%3-pont differentiation see: https://prog-you.com/numerical_diff/#i-2

% add noise
yn = y + sigma*sin(2*pi*fn*t);%Noise added
dyndt = (yn(3:end) - yn(1:end-2))/(2*dt);

% plot signals
tiledlayout(2,2)
nexttile
plot(t,y)
title('Original signal')
set(gca,'YLim',[-1.5 1.5])
nexttile
plot(t,yn)
title('Signal plus noise')
set(gca,'YLim',[-1.5 1.5])
nexttile
plot(t(2:end-1),dydt)
%hold on
%plot(t, 2*pi*f*cos(2*pi*f*t))
title('Time derivative of original signal')
set(gca,'YLim',[-15 15])
nexttile
plot(t(2:end-1),dyndt)
title('Time derivative of noisy signal')
set(gca,'YLim',[-15 15])
