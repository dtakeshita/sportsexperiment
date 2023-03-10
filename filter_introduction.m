clear; close all;
% parameters 
dt = 1e-4;%time step
t = 0:dt:1;%time vector
f = 2;%frquency of sine wave
fn = 50;%frequency of noise
sigma = 0.1;%amplitude of noise
% generate a noisy signal
y = sin(2*pi*f*t)+ sigma*sin(2*pi*fn*t);

%% Moving average
windowSize = 200;
y_m = movmean(y,windowSize);
% comparison
figure;
plot(t,y, t,y_m)
legend('Original','Moving averaged')

%% Filtering
% a(1)y(n) = b(1)x(n) + b(2)x(n-1) + ... + b(Nb)x(n-Nb-1) - a(2)y(n-1) - a(3)y(n-2) ...
% - a(Na)y(n-Na-1)
b = (1/windowSize)*ones(1,windowSize);
a = 1;
y_f = filter(b,a,y);
figure;
plot(t,y,t,y_f)
title('Moivng average with filter function')

%% Filtering twice
y_ff = filtfilt(b,a,y);
figure;
plot(t,y,t,y_ff)
title('Filtering forward and backward')



