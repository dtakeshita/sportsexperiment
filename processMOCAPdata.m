% Process MOCAP and EMG data
clear;
load('./Data/hopping.mat'); %pos_raw, pos_smoothed, EMG_raw, EMG_processed, 

EMGs = smoothEMG( EMG_raw.GML,10 );%EMG of the medial gastrocnemius on the left foot


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
