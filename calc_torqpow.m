function [ang,torq,power] = calc_torqpow(FP,pos)
    %足関節，膝関節，股関節の角度，トルク，トルクパワーを計算する

    nFr = size(FP(1).grf,2)/10;

    %各データの矢状面だけ抜き出す
    %計算の都合上3次元目にはゼロを入れておく
    grfR = [FP(2).grf(2:3,1:10:end); zeros(1,nFr)];
    copR = [FP(2).cop(2:3,1:10:end); zeros(1,nFr)];
    toeR = [pos.toeR(2:3,:); zeros(1,nFr)];
    heelR = [pos.heelR(2:3,:); zeros(1,nFr)];
    ankleR = [pos.ankleR(2:3,:); zeros(1,nFr)];
    kneeR = [pos.kneeR(2:3,:); zeros(1,nFr)];
    hipR = [pos.hipR(2:3,:); zeros(1,nFr)];
    ribR = [pos.ribR(2:3,:); zeros(1,nFr)];
    grfL = [FP(1).grf(2:3,1:10:end); zeros(1,nFr)];
    copL = [FP(1).cop(2:3,1:10:end); zeros(1,nFr)];
    toeL = [pos.toeL(2:3,:); zeros(1,nFr)];
    heelL = [pos.heelL(2:3,:); zeros(1,nFr)];
    ankleL = [pos.ankleL(2:3,:); zeros(1,nFr)];
    kneeL = [pos.kneeL(2:3,:); zeros(1,nFr)];
    hipL = [pos.hipL(2:3,:); zeros(1,nFr)];
    ribL = [pos.ribL(2:3,:); zeros(1,nFr)];
    hip = (hipR+hipL)/2;
    rib = (ribR+ribL)/2;
    neck = [pos.c(2:3,:); zeros(1,nFr)];
    head = [pos.head(2:3,:); zeros(1,nFr)];

    bw = mean(grfR(2,:)+grfL(2,:))/9.8;
    [mass,com3] = calc_com(pos,bw);
    com.thighR = [com3.thighR(2:3,:); zeros(1,nFr)];
    com.shankR = [com3.shankR(2:3,:); zeros(1,nFr)];
    com.footR = [com3.footR(2:3,:); zeros(1,nFr)];
    com.thighL = [com3.thighL(2:3,:); zeros(1,nFr)];
    com.shankL = [com3.shankL(2:3,:); zeros(1,nFr)];
    com.footL = [com3.footL(2:3,:); zeros(1,nFr)];
    com.trunk = [com3.trunk(2:3,:); zeros(1,nFr)];

    %ベクトルの設定
    knee2hipR = hipR-kneeR;
    ankle2kneeR = kneeR-ankleR;
    toe2heelR = heelR-toeR;
    knee2hipL = hipL-kneeL;
    ankle2kneeL = kneeL-ankleL;
    toe2heelL = heelL-toeL;
    hip2rib = rib-hip;
    rib2neck = neck-rib;
    neck2head = head-neck;

    %重力加速度と慣性モーメントの定義
    gra = 9.8;
    moi.foot = mass.foot*((norm(mean(toe2heelR,2))+norm(mean(toe2heelL,2)))/2*0.204)^2;
    moi.shank = mass.shank*((norm(mean(ankle2kneeR,2))+norm(mean(ankle2kneeL,2)))/2*0.274)^2;
    moi.thigh = mass.thigh*((norm(mean(knee2hipR,2))+norm(mean(knee2hipL,2)))/2*0.278)^2;
%     moi.lowtrunk = mass.trunk*(norm(mean(hip2neck,2))*0.346)^2;

    %まずは足関節の計算
    ang.footR = vec_angle(toe2heelR);
    ang_vel.footR = dif3(ang.footR,nFr,1/200);
    ang_acc.footR = dif3(ang_vel.footR,nFr,1/200);
    vel.footR = dif3(com.footR,nFr,1/200);
    acc.footR = dif3(vel.footR,nFr,1/200);
    ang.footL = vec_angle(toe2heelL);
    ang_vel.footL = dif3(ang.footL,nFr,1/200);
    ang_acc.footL = dif3(ang_vel.footL,nFr,1/200);
    vel.footL = dif3(com.footL,nFr,1/200);
    acc.footL = dif3(vel.footL,nFr,1/200);

    F_g = zeros(3,nFr);
    F_g(2,:) = mass.foot*gra;
    F_aR = mass.foot*acc.footR + F_g - grfR;
    F_aL = mass.foot*acc.footL + F_g - grfL;

    %端点の力が発揮するモーメントの計算
    %添字のdはdistal，pはproximal
    N_dR = cross(copR-com.footR,grfR);
    N_dL = cross(copL-com.footL,grfL);
    N_pR = cross(ankleR-com.footR,F_aR);
    N_pL = cross(ankleL-com.footL,F_aL);

    torq.ankleR = moi.foot*ang_acc.footR - N_dR(3,:) - N_pR(3,:);
    torq.ankleL = moi.foot*ang_acc.footL - N_dL(3,:) - N_pL(3,:);

    %次に膝関節の計算
    ang.shankR = vec_angle(ankle2kneeR);
    ang_vel.shankR = dif3(ang.shankR,nFr,1/200);
    ang_acc.shankR = dif3(ang_vel.shankR,nFr,1/200);
    vel.shankR = dif3(com.shankR,nFr,1/200);
    acc.shankR = dif3(vel.shankR,nFr,1/200);
    ang.shankL = vec_angle(ankle2kneeL);
    ang_vel.shankL = dif3(ang.shankL,nFr,1/200);
    ang_acc.shankL = dif3(ang_vel.shankL,nFr,1/200);
    vel.shankL = dif3(com.shankL,nFr,1/200);
    acc.shankL = dif3(vel.shankL,nFr,1/200);

    F_g = zeros(3,nFr);
    F_g(2,:) = mass.shank*gra;
    F_kR = mass.shank*acc.shankR + F_g + F_aR;
    F_kL = mass.shank*acc.shankL + F_g + F_aL;

    N_dR = -cross(ankleR-com.shankR,F_aR);
    N_dL = -cross(ankleR-com.shankL,F_aR);
    N_pR = cross(kneeR-com.shankR,F_kR);
    N_pL = cross(kneeL-com.shankL,F_kL);

    torq.kneeR = moi.shank*ang_acc.shankR + torq.ankleR - N_dR(3,:) - N_pR(3,:);
    torq.kneeL = moi.shank*ang_acc.shankL + torq.ankleL - N_dL(3,:) - N_pL(3,:);

    %最後に股関節だ
    ang.thighR = vec_angle(knee2hipR);
    ang_vel.thighR = dif3(ang.thighR,nFr,1/200);
    ang_acc.thighR = dif3(ang_vel.thighR,nFr,1/200);
    vel.thighR = dif3(com.thighR,nFr,1/200);
    acc.thighR = dif3(vel.thighR,nFr,1/200);
    ang.thighL = vec_angle(knee2hipL);
    ang_vel.thighL = dif3(ang.thighL,nFr,1/200);
    ang_acc.thighL = dif3(ang_vel.thighL,nFr,1/200);
    vel.thighL = dif3(com.thighL,nFr,1/200);
    acc.thighL = dif3(vel.thighL,nFr,1/200);

    F_g = zeros(3,nFr);
    F_g(2,:) = mass.thigh*gra;
    F_hR = mass.thigh*acc.thighR + F_g + F_kR;
    F_hL = mass.thigh*acc.thighL + F_g + F_kL;

    N_dR = -cross(kneeR-com.thighR,F_kR);
    N_dL = -cross(kneeL-com.thighL,F_kR);
    N_pR = cross(hipR-com.thighR,F_hR);
    N_pL = cross(hipL-com.thighL,F_hL);

    torq.hipR = moi.thigh*ang_acc.thighR + torq.kneeR - N_dR(3,:) - N_pR(3,:);
    torq.hipL = moi.thigh*ang_acc.thighL + torq.kneeL - N_dL(3,:) - N_pL(3,:);
    
%     %ついでに頸関節も求めてみる
%     ang.trunk = vec_angle(hip2neck);
%     ang_vel.trunk = dif3(ang.trunk,nFr,1/200);
%     ang_acc.trunk = dif3(ang_vel.trunk,nFr,1/200);
%     vel.trunk = dif3(com.trunk,nFr,1/200);
%     acc.trunk = dif3(vel.trunk,nFr,1/200);

%     F_g = zeros(3,nFr);
%     F_g(2,:) = mass.trunk*gra;
%     F_n = mass.trunk*acc.trunk + F_g + F_hR + F_hL;
% 
%     N_dR = -cross(hip-com.trunk,F_hR+F_hL);
%     N_pR = cross(neck-com.trunk,F_n);
% 
%     torq.neck = moi.trunk*ang_acc.trunk + torq.kneeR - N_dR(3,:) - N_pR(3,:);

    ang.foot = (ang.footR + ang.footL)/2;
    ang.shank = (ang.shankR + ang.shankL)/2;
    ang.thigh = (ang.thighR + ang.thighL)/2;
    ang.lowtrunk = vec_angle(hip2rib);
    ang.uptrunk = vec_angle(rib2neck);
    ang.head = vec_angle(neck2head);

    ang.ankle = pi+ang.foot-ang.shank;
    ang.knee = pi-ang.shank+ang.thigh;
    ang.hip = pi+ang.thigh-ang.lowtrunk;
    ang.trunk = pi+ang.lowtrunk-ang.uptrunk;
    ang.neck = pi+ang.uptrunk-ang.head;
    ang_vel.ankle = dif3(ang.ankle,nFr,1/200);
    ang_vel.knee = dif3(ang.knee,nFr,1/200);
    ang_vel.hip = dif3(ang.hip,nFr,1/200);
    ang_vel.neck = dif3(ang.neck,nFr,1/200);
%     ang_acc.ankle = dif3(ang_vel.ankle,nFr,1/200);
%     ang_acc.knee = dif3(ang_vel.knee,nFr,1/200);
%     ang_acc.hip = dif3(ang_vel.hip,nFr,1/200);
%     ang_acc.neck = dif3(ang_vel.neck,nFr,1/200);
    torq.ankle = torq.ankleR + torq.ankleL;
    torq.knee = torq.kneeR + torq.kneeL;
    torq.hip = torq.hipR + torq.hipL;
    power.ankle = torq.ankle.*ang_vel.ankle;
    power.knee = -torq.knee.*ang_vel.knee;
    power.hip = torq.hip.*ang_vel.hip;

    function theta = vec_angle(a)
        nfr = size(a,2);
        theta = zeros(1,nfr);
        for k = 1:nfr
            theta(k) = atan2(a(2,k),a(1,k));
        end
    end

    function d = dif3(data,nFr,time_int)
        d(:,1)=(-3*data(:,1)+4*data(:,2)-data(:,3))/(2*time_int);

        for iFr=2:nFr-1
            d(:,iFr)=(-data(:,iFr-1)+data(:,iFr+1))/(2*time_int);
        end

        d(:,nFr)=(data(:,nFr-2)-4*data(:,nFr-1)+3*data(:,nFr))/(2*time_int);
    end

    function [mass,com] = calc_com(pos,bodyWeight)
    %身体部分係数から各セグメントの部分質量と質量中心を求める
    %ついでに全身の重心も求めてる

    mass = struct;
    mass.all = bodyWeight;
    mass.head = mass.all*0.069;
    mass.trunk = mass.all*0.489;
    mass.upperarm = mass.all*0.027;
    mass.forearm = mass.all*0.022;
    mass.thigh = mass.all*0.11;
    mass.shank = mass.all*0.051;
    mass.foot = mass.all*0.011;
    
    com = struct;
    com.head = pos.head+(pos.c-pos.head)*0.821;
    com.trunk = pos.shouldeC+(pos.pelC-pos.shouldeC)*0.493;
    com.upperarmR = pos.shoulderR+(pos.elbowR-pos.shoulderR)*0.529;
    com.forearmR = pos.elbowR+(pos.wristR-pos.elbowR)*0.5;
    com.thighR = pos.trocR+(pos.kneeR-pos.trocR)*0.475;
    com.shankR = pos.kneeR+(pos.ankleR-pos.kneeR)*0.406;
    com.footR = pos.toeR+(pos.heelR-pos.toeR)*0.595;
    com.upperarmL = pos.shoulderL+(pos.elbowL-pos.shoulderL)*0.529;
    com.forearmL = pos.elbowL+(pos.wristL-pos.elbowL)*0.5;
    com.thighL = pos.trocL+(pos.kneeL-pos.trocL)*0.475;
    com.shankL = pos.kneeL+(pos.ankleL-pos.kneeL)*0.406;
    com.footL = pos.toeL+(pos.heelL-pos.toeL)*0.595;
    
    com.all = (com.head*mass.head + com.trunk*mass.trunk ...
        + (com.upperarmR+com.upperarmL)*mass.upperarm ...
        + (com.forearmR+com.forearmL)*mass.forearm...
        + (com.thighR+com.thighL)*mass.thigh ...
        + (com.shankR+com.shankL)*mass.shank ...
        + (com.footR+com.footL)*mass.foot) / mass.all;
    end
end