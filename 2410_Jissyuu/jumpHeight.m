close all;
fname = 'Jump1.forces';
 [~, raw_data] = read_forces(fname);
 FPz = raw_data(:,10);%FPz of FP2 (there are 7 columns per FP)
 Fs = 2000;
 t = (0:length(FPz)-1)/Fs;
 plot(t,FPz)
xlabel('Time (sec)');ylabel('Force (N)');

% 地面反力を積分して重心速度を求めなさい。

%離地時の重心速度と力学的エネルギー保存則を使って跳躍高を求めなさい

%滞空時間からも跳躍高を求めなさい