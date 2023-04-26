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
