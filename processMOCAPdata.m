% Process MOCAP and EMG data
clear; close all;
load('./Data/hopping2.mat'); %pos_raw, pos_smoothed, EMG_raw, EMG_processed, grfz
%load('./Data/hopping_230427saved.mat');
fs_EMG = 2000;%sampling frequency of EMG data
fs_GRF = 2000;%sampling frequency of ground reaction force data
fs_pos = 200;%sampling frequency of motion capture data
%EMG_GML = smoothEMG( EMG_raw.GML,10 );%EMG of the medial gastrocnemius on the left foot
EMG_GML = EMG_raw.GML;
t_EMG = (1/fs_EMG)*(0:length(EMG_GML)-1);
t_GRF = (1/fs_GRF)*(0:length(grfz)-1);
t_pos = (1/fs_pos)*(0:length(pos_raw.head)-1);

% plot GRF & EMG data
%tiledlayout(2,2)
subplot(2,1,1)
plot(t_GRF, grfz)
%nexttile
subplot(2,1,2)
plot(t_EMG, EMG_GML)

% calc COM position from MOCAP data
m = mean(grfz/9.8);
[mass,com] = calc_com(pos_raw,m);
grfz_interp = interp1(t_GRF, grfz, t_pos);
comZ = com.all(3,:);
plot(comZ, grfz_interp)
% Calculate COM position from ground reaction force
g = 9.8;
v = cumsum(grfz/m-g)/fs_GRF;
% plot(t_GRF,v)
% extract one cycle
t0 = 0.957; t1 = 1.155;t2 = 1.3795;t3 =1.575; 
baseline = grfz(t_GRF> t0 & t_GRF< t1);
base_mean = mean(baseline);
base_std = std(baseline);
grfz_new = grfz-base_mean;
m = mean(grfz_new/9.8);
v0 = -g*(t1-t0)/2;
grfz_onecyc = grfz_new(t_GRF>t1 & t_GRF < t3);
t_onecyc = t_GRF(t_GRF>t1 & t_GRF < t3);
v = v0 + cumsum(grfz_onecyc/m-g)/fs_GRF;
% COM from motion capture data
comZ_onecyc = interp1(t_pos,comZ,t_onecyc );
comZ_onecyc = comZ_onecyc - comZ_onecyc(1);

tiledlayout('flow')
nexttile
plot(t_onecyc, v)
h = cumsum(v)/fs_GRF;

figure
plot(t_onecyc, h)
hold on
plot(t_onecyc, comZ_onecyc,'r')
xlabel('Time (s)');ylabel('Z (m)');
legend({'GRF','MOCAP'})






function [EMG_smoothed, EMG_rectified] = smoothEMG(e, fc)
    n = 2; %order of filter 
    fs = 2000;%sampling frequency of EMG data
    Wn = fc/(fs/2);%normalized cutoff frequnecy
    [z,p,k] = butter(n,Wn,'low');
     [B,A] = butter(n, Wn, 'low');
    sos = zp2sos(z,p,k);
    
    EMG_rectified = abs(e);
    EMG_smoothed = filtfilt(sos,1,EMG_rectified);
    EMG_smoothed2 =  filtfilt(B, A, EMG_rectified);
    
end
