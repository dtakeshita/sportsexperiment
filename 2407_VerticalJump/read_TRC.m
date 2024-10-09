function pos = read_TRC(file)
    raw_data = readmatrix(file, 'FileType', 'delimitedtext','Range', [6,2]);
    motion_data = raw_data(:,2:end)'/1000; %unit change: mm→m
    pos = set_Pname52(motion_data);
end