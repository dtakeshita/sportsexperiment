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
t0 = 3.55;
t1 = 3.8;
g = 9.8;
weight = mean(FPz(t>t0 & t<t1));
m = weight/g;
idx_t0 =  find(t >t0,1,'first');
idx_takeoff = find(t >3 & FPz==0,1,'first');
acc = FPz(idx_t0:idx_takeoff)/m - g;
vel = cumsum(acc)*dt;
plot(t(idx_t0:idx_takeoff),vel)

%離地時の重心速度と力学的エネルギー保存則を使って跳躍高を求めなさい
H0 = vel(end)^2/(2*g)

%滞空時間からも跳躍高を求めなさい
t0=4.7625;
t1=5.299;
H1 = (t1-t0)^2/8*9.8;