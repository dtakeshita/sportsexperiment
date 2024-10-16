function [FP, raw_data] = read_forces(file)
%[FX1	FY1	FZ1	X1	Y1	Z1	MZ1	FX2	FY2	FZ2	X2	Y2	Z2	MZ2	...] 
%7 columns per FP
    raw_data = readmatrix(file, 'FileType', 'delimitedtext','Range', [6,2]);
    FP = struct;
    FP.grf = raw_data(:, 1:3)';%FP1
    FP.cop = [raw_data(:, 4:5)'; zeros(1,size(raw_data,1))];
    FP.cop = FP.cop / 1000;
end