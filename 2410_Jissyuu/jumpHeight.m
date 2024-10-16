close all;
fname = 'Jump1.forces';
 [~, raw_data] = read_forces(fname);
 FPz = raw_data(:,10);%FPz of FP2 (there are 7 columns per FP)
 Fs = 2000;
 dt = 1/Fs;
 t = (0:length(FPz)-1)'*dt;
 plot(t,FPz)
xlabel('Time (sec)');ylabel('Force (N)');

% 地面反力を積分して重心速度を求めなさい。


%離地時の重心速度と力学的エネルギー保存則を使って跳躍高を求めなさい


%滞空時間からも跳躍高を求めなさい

function [FP, raw_data] = read_forces(file)
%[FX1	FY1	FZ1	X1	Y1	Z1	MZ1	FX2	FY2	FZ2	X2	Y2	Z2	MZ2	...] 
%7 columns per FP
    raw_data = readmatrix(file, 'FileType', 'delimitedtext','Range', [6,2]);
    FP = struct;
    FP.grf = raw_data(:, 1:3)';%FP1
    FP.cop = [raw_data(:, 4:5)'; zeros(1,size(raw_data,1))];
    FP.cop = FP.cop / 1000;
end
