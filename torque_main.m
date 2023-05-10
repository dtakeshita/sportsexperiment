clear; close all;
load('./Data/hopping2.mat'); 
[ang,torq,power] = calc_torqpow(FP,pos_smoothed);