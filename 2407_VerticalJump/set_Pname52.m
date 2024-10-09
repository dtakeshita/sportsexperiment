function pos = set_Pname52(data)
    id = set_id;

    fieldnames_ = fieldnames(id);
    for i = 1:length(fieldnames_)
        fieldname = fieldnames_{i};
        row = 3*(id.(fieldname)-1)+1:3*id.(fieldname);
        pos.(fieldname) = data(row, :);
    end
    
    %関節中心座標算出-----------------------------------------------------------

    pos.wristR = (pos.wristIR + pos.wristOR) / 2;
    pos.elbowR = (pos.elbowIR + pos.elbowOR) / 2;
    pos.shoulderR = (pos.shoulderFR + pos.shoulderBR) / 2;
    pos.wristL = (pos.wristIL + pos.wristOL) / 2;
    pos.elbowL = (pos.elbowIL + pos.elbowOL) / 2;
    pos.shoulderL = (pos.shoulderFL + pos.shoulderBL) / 2;
    
    pos.ballR = (pos.ballIR + pos.ballOR) / 2;
    pos.ankleR = (pos.ankleIR + pos.ankleOR) / 2;
    pos.kneeR = (pos.kneeIR + pos.kneeOR) / 2;
    pos.ankleL = (pos.ankleIL + pos.ankleOL) / 2;
    pos.kneeL = (pos.kneeIL + pos.kneeOL) / 2;
    pos.ballL = (pos.ballIL + pos.ballOL) / 2;
    
    pos.asisC = (pos.asisR + pos.asisL) / 2;
    pos.psisC = (pos.psisR + pos.psisL) / 2;
    pos.psisR = (pos.asisR + pos.psisR) / 2;
    pos.psisL = (pos.asisL + pos.psisL) / 2;
    
    pos.shoulderC = (pos.shoulderR + pos.shoulderL) / 2;
    pos.ear = (pos.earR + pos.earL) / 2;
    pos.pelvisC = (pos.asisC + pos.psisC) / 2;
    pos.trocC = (pos.trocR + pos.trocL) / 2;
    
    %股関節中心 Harrington et al., JB, (2007) 参照----------------------------------------------------------
    x_pel = unitvec(pos.asisR-pos.asisL);
    s_pel = unitvec(pos.asisC-pos.psisC);
    z_pel = unitvec(cross(x_pel,s_pel));
    y_pel = unitvec(cross(z_pel,x_pel));    
    V_PW = (pos.asisR-pos.asisL);
    V_PD = (pos.asisC-pos.psisC);
    V_LLR1 = (pos.kneeIR-pos.ankleIR);
    V_LLR2 = (pos.asisR-pos.kneeIR);
    V_LLL1 = (pos.kneeIL-pos.ankleIL);
    V_LLL2 = (pos.asisL-pos.kneeIL);
    PW = ones(length(V_PW(:,1)),1)*sqrt(sum(V_PW.*V_PW));
    PD = ones(length(V_PD(:,1)),1)*sqrt(sum(V_PD.*V_PD));
    LLR1 = ones(length(V_LLR1(:,1)),1)*sqrt(sum(V_LLR1.*V_LLR1));
    LLR2 = ones(length(V_LLR2(:,1)),1)*sqrt(sum(V_LLR2.*V_LLR2));
    LLL1 = ones(length(V_LLL1(:,1)),1)*sqrt(sum(V_LLL1.*V_LLL1));
    LLL2 = ones(length(V_LLL2(:,1)),1)*sqrt(sum(V_LLL2.*V_LLL2));
    LLR = LLR1+LLR2;
    LLL = LLL1+LLL2;   
    for iFr = 1:size(pos.head,2)
        pos.hipR(:,iFr) = pos.asisC(:,iFr)+(0.28*PD(:,iFr).*x_pel(:,iFr)+0.16*PW(:,iFr).*x_pel(:,iFr)+0.0079)...
            +(-0.24*PD(:,iFr).*y_pel(:,iFr)-0.0099)...
            +(-0.16*PW(:,iFr).*z_pel(:,iFr)-0.04*LLR(:,iFr).*z_pel(:,iFr)-0.0071);       
        pos.hipL(:,iFr) = pos.asisC(:,iFr)+(-0.28*PD(:,iFr).*x_pel(:,iFr)-0.16*PW(:,iFr).*x_pel(:,iFr)-0.0079)...
            +(-0.24*PD(:,iFr).*y_pel(:,iFr)-0.0099)...
            +(-0.16*PW(:,iFr).*z_pel(:,iFr)-0.04*LLL(:,iFr).*z_pel(:,iFr)-0.0071);
    end
    
    %体幹仮想関節中心 阿江 (1992) 参照----------------------------------------------------------
    
    pos.ribC = (pos.ribR + pos.ribL) / 2;
    
    %頸関節中心 阿江 (1992) 参照----------------------------------------------------------
    
    pos.chin = (pos.c7 + pos.clav) / 2;
    
    %単位ベクトルの生成
    function UV = unitvec(V)
        VS = ones(length(V(:,1)),1)*sqrt(sum(V.*V));
        UV = V./VS;
    end
    
    function id = set_id
        id.handR = 1;
        id.wristIR = 2;
        id.wristOR = 3;
        id.elbowIR = 4;
        id.elbowOR = 5;
        id.shoulderFR = 6;
        id.shoudlerUR = 7;
        id.shoulderBR = 8;
        id.handL = 9;
        id.wristIL = 10;
        id.wristOL = 11;
        id.elbowIL = 12;
        id.elbowOL = 13;
        id.shoulderFL = 14;
        id.shoulderUL = 15;
        id.shoulderBL = 16;
        id.toeR = 17;
        id.ballIR = 18;
        id.ballOR = 19;
        id.heelR = 20;
        id.ankleIR = 21;
        id.ankleOR = 22;
        id.kneeIR = 23;
        id.kneeOR = 24;
        id.trocR = 25;
        id.toeL = 26;
        id.ballIL = 27;
        id.ballOL = 28;
        id.heelL = 29;
        id.ankleIL = 30;
        id.ankleOL = 31;
        id.kneeIL = 32;
        id.kneeOL = 33;
        id.trocL = 34;
        id.head = 35;
        id.earR = 36;
        id.earL = 37;
        id.clav = 38;
        id.c7 = 39;
        id.ribR = 40;
        id.ribL = 41;
        id.xiph = 42;
        id.asisR = 43;
        id.asisL = 44;
        id.psisR = 45;
        id.psisL = 46;
        id.t8 = 47;
        id.t11 = 48;
        id.L1 = 49;
        id.L3 = 50;
        id.LS = 51;
        id.COX = 52;
    end
end

