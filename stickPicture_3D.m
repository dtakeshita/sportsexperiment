bpm = 150;
vid = VideoWriter('test.avi');
vid.FrameRate = 60;
frameNum = round(vid.FrameRate*60/bpm);

load(fullfile('.','Data','hopping2.mat'));
pos = pos_raw;

p = structfun(@(data) calc_mean(data, fr_contact_ds, frameNum), pos, 'UniformOutput', false);
center = struct;
right = struct;
left = struct;
center.head = p.head;
center.earR = p.earR;
center.earL = p.earL;
center.c = p.c;
center.shoulderR = p.shoulderR;
center.shoulderL = p.shoulderL;
center.ribR = p.ribR;
center.ribL = p.ribL;
center.hipR = p.hipR;
center.hipL = p.hipL;
right.wrist = p.wristR;
right.elbow = p.elbowR;
right.shoulder = p.shoulderR;
right.toe = p.toeR;
right.ball = p.ballR;
right.heel = p.heelR;
right.ankle = p.ankleR;
right.knee = p.kneeR;
right.hip = p.hipR;
left.wrist = p.wristL;
left.elbow = p.elbowL;
left.shoulder = p.shoulderL;
left.toe = p.toeL;
left.ball = p.ballL;
left.heel = p.heelL;
left.ankle = p.ankleL;
left.knee = p.kneeL;
left.hip = p.hipL;



figure; hold on; ax = gca;
xlim_low = min(right.elbow(1,:)) - 0.1;
xlim_up = max(left.elbow(1,:)) + 0.1;
xlim([xlim_low, xlim_up])
ylim_low = min([right.toe(2,:),left.toe(2,:)]) - 0.1;
ylim_up = max([right.heel(2,:),left.heel(2,:)]) + 0.1;
ylim([ylim_low, ylim_up])
zlim([0,max(center.head(3,:))+0.1])
daspect([1,1,1])
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
ax.ZAxis.Visible = 'off';
[x,y] = meshgrid(xlim_low:0.1:xlim_up, ylim_low:0.1:ylim_up);
z = zeros(size(x));
view(50, 10)
open(vid);
for k_repeat = 1:10
    for k_frame = 1:frameNum
        cla(ax);
        surf(x, y, z, 'EdgeColor', 'k', 'FaceAlpha', 0);
        drawLimb(right, k_frame, '#4F81BD');
        drawLimb(left, k_frame, '#4F81BD');
        drawTrunk(center, k_frame, '#4F81BD');
        writeVideo(vid,getframe(gcf));
    end
end
close(vid);

function data_mean = calc_mean(data, fr_contact, frameNum)
    data_mean = zeros(size(data,1),frameNum);
    for k_hop = 1:10
        fr = fr_contact(k_hop):fr_contact(k_hop+1);
        frq = linspace(fr_contact(k_hop),fr_contact(k_hop+1),frameNum);
        for k_dim = 1:size(data,1)
            data_mean(k_dim,:) = data_mean(k_dim,:) + interp1(fr,data(k_dim,fr),frq);
        end
    end
    data_mean = data_mean / 10;
end

function drawLimb(p, k_frame, colorName)
    plot3([p.toe(1,k_frame),p.ball(1,k_frame)], ...
        [p.toe(2,k_frame),p.ball(2,k_frame)], ...
        [p.toe(3,k_frame),p.ball(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.heel(1,k_frame),p.ball(1,k_frame)], ...
        [p.heel(2,k_frame),p.ball(2,k_frame)], ...
        [p.heel(3,k_frame),p.ball(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.heel(1,k_frame),p.ankle(1,k_frame)], ...
        [p.heel(2,k_frame),p.ankle(2,k_frame)], ...
        [p.heel(3,k_frame),p.ankle(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.toe(1,k_frame),p.ankle(1,k_frame)], ...
        [p.toe(2,k_frame),p.ankle(2,k_frame)], ...
        [p.toe(3,k_frame),p.ankle(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.knee(1,k_frame),p.ankle(1,k_frame)], ...
        [p.knee(2,k_frame),p.ankle(2,k_frame)], ...
        [p.knee(3,k_frame),p.ankle(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.knee(1,k_frame),p.hip(1,k_frame)], ...
        [p.knee(2,k_frame),p.hip(2,k_frame)], ...
        [p.knee(3,k_frame),p.hip(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.wrist(1,k_frame),p.elbow(1,k_frame)], ...
        [p.wrist(2,k_frame),p.elbow(2,k_frame)], ...
        [p.wrist(3,k_frame),p.elbow(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.shoulder(1,k_frame),p.elbow(1,k_frame)], ...
        [p.shoulder(2,k_frame),p.elbow(2,k_frame)], ...
        [p.shoulder(3,k_frame),p.elbow(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
end

function drawTrunk(p, k_frame, colorName)
    plot3([p.hipR(1,k_frame), p.hipL(1,k_frame)], ...
        [p.hipR(2,k_frame), p.hipL(2,k_frame)], ...
        [p.hipR(3,k_frame), p.hipL(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.hipR(1,k_frame), p.ribR(1,k_frame)], ...
        [p.hipR(2,k_frame), p.ribR(2,k_frame)], ...
        [p.hipR(3,k_frame), p.ribR(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.ribL(1,k_frame), p.hipL(1,k_frame)], ...
        [p.ribL(2,k_frame), p.hipL(2,k_frame)], ...
        [p.ribL(3,k_frame), p.hipL(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.shoulderR(1,k_frame), p.ribR(1,k_frame)], ...
        [p.shoulderR(2,k_frame), p.ribR(2,k_frame)], ...
        [p.shoulderR(3,k_frame), p.ribR(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.ribL(1,k_frame), p.shoulderL(1,k_frame)], ...
        [p.ribL(2,k_frame), p.shoulderL(2,k_frame)], ...
        [p.ribL(3,k_frame), p.shoulderL(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.shoulderR(1,k_frame), p.c(1,k_frame)], ...
        [p.shoulderR(2,k_frame), p.c(2,k_frame)], ...
        [p.shoulderR(3,k_frame), p.c(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.shoulderL(1,k_frame), p.c(1,k_frame)], ...
        [p.shoulderL(2,k_frame), p.c(2,k_frame)], ...
        [p.shoulderL(3,k_frame), p.c(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.earL(1,k_frame), p.c(1,k_frame)], ...
        [p.earL(2,k_frame), p.c(2,k_frame)], ...
        [p.earL(3,k_frame), p.c(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.earR(1,k_frame), p.c(1,k_frame)], ...
        [p.earR(2,k_frame), p.c(2,k_frame)], ...
        [p.earR(3,k_frame), p.c(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.earR(1,k_frame), p.head(1,k_frame)], ...
        [p.earR(2,k_frame), p.head(2,k_frame)], ...
        [p.earR(3,k_frame), p.head(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
    plot3([p.earL(1,k_frame), p.head(1,k_frame)], ...
        [p.earL(2,k_frame), p.head(2,k_frame)], ...
        [p.earL(3,k_frame), p.head(3,k_frame)], ...
        '.-', 'Color', colorName, 'LineWidth', 3);
end