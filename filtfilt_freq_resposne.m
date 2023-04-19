% Define the filter parameters
fs = 1000;  % Sampling frequency in Hz
fc = 50;    % Cutoff frequency in Hz
n = 4;      % Filter order

% Create a Butterworth filter
[b, a] = butter(n, fc/(fs/2));

% Generate a test signal
t = 0:1/fs:1;
x = sin(2*pi*100*t);

% Filter the signal using the filter function
y = filter(b, a, x);

% Compute the frequency response of the filtered signal
Y = fft(y);
f = linspace(0, fs, length(Y));
magY = abs(Y);
phaseY = angle(Y);

% Plot the frequency response
figure;
subplot(2, 1, 1);
plot(f, magY);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Response of Butterworth Filter');

subplot(2, 1, 2);
plot(f, phaseY);
xlabel('Frequency (Hz)');
ylabel('Phase');