function [angle, torq] = get_angletorq(FP, pos, body_weight)
    grf = FP.grf(:,1:10:end);
    cop = FP.cop(:,1:10:end);
    fr_num = size(grf,2);

    %各データの矢状面だけ抜き出す
    %計算の都合上3次元目にはゼロを入れておく
    grf = [grf(1,:); grf(3,:); zeros(1,fr_num)];
    grf(:, vecnorm(grf)<10) = 0;
    cop = [cop(1,:); zeros(2,fr_num)];
    toeR = [pos.toeR(1,:); pos.toeR(3,:); zeros(1,fr_num)];
    heelR = [pos.heelR(1,:); pos.heelR(3,:); zeros(1,fr_num)];
    ankleR = [pos.ankleR(1,:); pos.ankleR(3,:); zeros(1,fr_num)];
    kneeR = [pos.kneeR(1,:); pos.kneeR(3,:); zeros(1,fr_num)];
    hipR = [pos.hipR(1,:); pos.hipR(3,:); zeros(1,fr_num)];
    ribR = [pos.ribR(1,:); pos.ribR(3,:); zeros(1,fr_num)];
    toeL = [pos.toeL(1,:); pos.toeL(3,:); zeros(1,fr_num)];
    heelL = [pos.heelL(1,:); pos.heelL(3,:); zeros(1,fr_num)];
    ankleL = [pos.ankleL(1,:); pos.ankleL(3,:); zeros(1,fr_num)];
    kneeL = [pos.kneeL(1,:); pos.kneeL(3,:); zeros(1,fr_num)];
    hipL = [pos.hipL(1,:); pos.hipL(3,:); zeros(1,fr_num)];
    ribL = [pos.ribL(1,:); pos.ribL(3,:); zeros(1,fr_num)];
    toe = (toeR + toeL) / 2;
    heel = (heelR + heelL) / 2;
    ankle = (ankleR + ankleL) / 2;
    knee = (kneeR + kneeL) / 2;
    hip = (hipR + hipL) / 2;
    rib = (ribR + ribL) / 2;

    [mass, com] = calc_com(pos, body_weight);
    com.thighR = [com.thighR(1,:); com.thighR(3,:); zeros(1,fr_num)];
    com.shankR = [com.shankR(1,:); com.shankR(3,:); zeros(1,fr_num)];
    com.footR = [com.footR(1,:); com.footR(3,:); zeros(1,fr_num)];
    com.thighL = [com.thighL(1,:); com.thighL(3,:); zeros(1,fr_num)];
    com.shankL = [com.shankL(1,:); com.shankL(3,:); zeros(1,fr_num)];
    com.footL = [com.footL(1,:); com.footL(3,:); zeros(1,fr_num)];
    com.thigh = (com.thighR + com.thighL) / 2;
    com.shank = (com.shankR + com.shankL) / 2;
    com.foot = (com.footR + com.footL) / 2;
    com.trunk = [com.trunk(1,:); com.trunk(3,:); zeros(1,fr_num)];

    %ベクトルの設定
    knee2hip = hip - knee;
    ankle2knee = knee - ankle;
    toe2heel = heel - toe;
    hip2rib = rib - hip;

    %重力加速度と慣性モーメントの定義
    gra = 9.8;
    moi.foot = mass.foot * (mean(vecnorm(toe2heel))*0.204)^2;
    moi.shank = mass.shank * (mean(vecnorm(ankle2knee))*0.274)^2;
    moi.thigh = mass.thigh * (mean(vecnorm(knee2hip))*0.278)^2;

    %まずは足関節の計算
    angle.foot = vec_angle(toe2heel);
    angle.foot(angle.foot<-2) = angle.foot(angle.foot<-2) + 2*pi;
    ang_vel.foot = dif3(angle.foot, fr_num, 1/200);
    ang_acc.foot = dif3(ang_vel.foot, fr_num, 1/200);
    vel.foot = dif3(com.foot, fr_num, 1/200);
    acc.foot = dif3(vel.foot, fr_num, 1/200);
    F_g = zeros(3, fr_num);
    F_g(2,:) = -mass.foot * gra;
    F_a = mass.foot*acc.foot - F_g - grf;
    N_d = cross(cop-com.foot, grf);
    N_p = cross(ankle-com.foot, F_a);
    torq.ankle = moi.foot*ang_acc.foot - N_d(3,:) - N_p(3,:);

    %次に膝関節の計算
    angle.shank = vec_angle(ankle2knee);
    ang_vel.shank = dif3(angle.shank, fr_num, 1/200);
    ang_acc.shank = dif3(ang_vel.shank, fr_num, 1/200);
    vel.shank = dif3(com.shank, fr_num, 1/200);
    acc.shank = dif3(vel.shank, fr_num, 1/200);
    F_g = zeros(3, fr_num);
    F_g(2,:) = -mass.shank * gra;
    F_k = mass.shank*acc.shank - F_g - (-F_a);
    N_d = -cross(ankle-com.shank, F_a);
    N_p = cross(knee-com.shank, F_k);
    torq.knee = moi.shank*ang_acc.shank - (-torq.ankle) - N_d(3,:) - N_p(3,:);

    %最後に股関節だ
    angle.thigh = vec_angle(knee2hip);
    ang_vel.thigh = dif3(angle.thigh, fr_num, 1/200);
    ang_acc.thigh = dif3(ang_vel.thigh, fr_num, 1/200);
    vel.thigh = dif3(com.thigh, fr_num, 1/200);
    acc.thigh = dif3(vel.thigh, fr_num, 1/200);
    F_g = zeros(3,fr_num);
    F_g(2,:) = -mass.thigh*gra;
    F_h = mass.thigh*acc.thigh - F_g - (-F_k);
    N_d = -cross(knee-com.thigh, F_k);
    N_p = cross(hip-com.thigh, F_h);
    torq.hip = moi.thigh*ang_acc.thigh - (-torq.knee) - N_d(3,:) - N_p(3,:);

    angle.lowtrunk = vec_angle(hip2rib);

    angle.ankle = pi - angle.foot + angle.shank;
    angle.knee = pi + angle.shank - angle.thigh;
    angle.hip = pi - angle.thigh + angle.lowtrunk;
    torq.ankle = -torq.ankle;
    torq.hip = -torq.hip;

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
    
    function [mass, com] = calc_com(pos, body_weight)
        %身体部分係数から各セグメントの部分質量と質量中心を求める
        %ついでに全身の重心も求めてる

        mass = struct;
        mass.head = 0.069 * body_weight;
        mass.trunk = 0.489 * body_weight;
        mass.upperarm = 0.027 * body_weight;
        mass.forearm = 0.022 * body_weight;
        mass.thigh = 0.11 * body_weight;
        mass.shank = 0.051 * body_weight;
        mass.foot = 0.011 * body_weight;

        com = struct;
        com.head = pos.head + (pos.chin-pos.head)*0.821;
        com.trunk = pos.shoulderC + (pos.pelvisC-pos.shoulderC)*0.493;
        com.upperarmR = pos.shoulderR + (pos.elbowR-pos.shoulderR)*0.529;
        com.forearmR = pos.elbowR + (pos.wristR-pos.elbowR)*0.5;
        com.thighR = pos.trocR + (pos.kneeR-pos.trocR)*0.475;
        com.shankR = pos.kneeR + (pos.ankleR-pos.kneeR)*0.406;
        com.footR = pos.toeR + (pos.heelR-pos.toeR)*0.595;
        com.upperarmL = pos.shoulderL + (pos.elbowL-pos.shoulderL)*0.529;
        com.forearmL = pos.elbowL + (pos.wristL-pos.elbowL)*0.5;
        com.thighL = pos.trocL + (pos.kneeL-pos.trocL)*0.475;
        com.shankL = pos.kneeL + (pos.ankleL-pos.kneeL)*0.406;
        com.footL = pos.toeL + (pos.heelL-pos.toeL)*0.595;

        com.all = (com.head*mass.head + com.trunk*mass.trunk ...
                  + (com.upperarmR+com.upperarmL)*mass.upperarm...
                  + (com.forearmR+com.forearmL)*mass.forearm...
                  + (com.thighR+com.thighL)*mass.thigh ...
                  + (com.shankR+com.shankL)*mass.shank ...
                  + (com.footR+com.footL)*mass.foot) / body_weight;
    end
end