%Demonstration of aliasing
clear; close all;
% parameters 
f_signal = 5.1;% has to be non-integer multiple of f_sample
f_sample = 5;% sampling frequency in Hz
dt = 1e-4;% has to be small enough compared to f_signal

% generation of original sine wave
t = 0:dt:10;
y = sin(2*pi*f_signal*t);

% sample with f_sample
dt_sample = 1/f_sample;
N_sample = round(dt_sample/dt);
t_new = t(1:N_sample:end);
y_new = y(1:N_sample:end);

% plot original signal
f = figure();
plot(t,y)
xlabel('Time (sec)')

% Add UI component 
c = uicontrol('String','Continue','Callback','uiresume(f)');
uiwait(f)

% plot re-sampled signal
hold on
plot(t_new, y_new,'x-')


