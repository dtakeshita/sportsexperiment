function [smoothedData, optCutFreq] = autoSmooth(data, hz)
% data: raw data, hz: sampling frequency of input data
    cutFreqMin = round(hz*7/100);
    cutFreqMax = round(hz*10/100);
    % "7" & "10" is arbitrary numbers
    dim = size(data,1);
    frameNum = size(data,2);
    smoothedData = zeros(size(data));
    optCutFreq = zeros(dim,1);

    for k = 1:dim
        smoothedData_temp = zeros(cutFreqMax, frameNum);

        RMS = zeros(cutFreqMax, 1);
        for cutFreq = 1:cutFreqMax
            [B,A] = butter(2, cutFreq/(hz/2), 'low');
            % quadratic butterworth low-pass filter
            smoothedData_temp(cutFreq,:) = filtfilt(B, A, data(k,:));
            res = smoothedData_temp(cutFreq,:) - data(k,:);
            % residual error between raw data and filtered data
            RMS(cutFreq) = sqrt((res*res')/frameNum);
            % root mean squared error of each cutoff frequency
        end

        x(:,1) = cutFreqMin:cutFreqMax;
        x(:,2) = ones;
        y = RMS(cutFreqMin:cutFreqMax);
        temp = x\y;
        threshold = temp(2);
        % the intercept of the line is the threshold

        cutFreq = 1;
        while RMS(cutFreq) > threshold
            cutFreq = cutFreq+1;
        end
        optCutFreq(k) = cutFreq;
        smoothedData(k,:) = smoothedData_temp(cutFreq,:);
    end
end