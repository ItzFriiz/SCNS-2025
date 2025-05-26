function [position, velocity, acceleration, kinematics_time] = calculate_kinematics(finger_pos, t, bin_centers, w)
    % 计算手指在每个时间窗口的位移、速度和加速度
    %
    % 输入:
    %   finger_pos - 手指位置数据，k x 3 (z, -x, -y)
    %   t - 位置数据的时间戳，k x 1
    %   bin_centers - 时间窗口中心点，bins x 1
    %   w - 时间窗口大小(秒)，默认为0.064秒(64ms)
    %
    % 输出:
    %   position - 每个时间窗口的手指位置，bins x 2 (x, y)
    %   velocity - 每个时间窗口的手指速度，bins x 2 (x, y)
    %   acceleration - 每个时间窗口的手指加速度，bins x 2 (x, y)
    %   kinematics_time - 运动学数据对应的时间点，bins x 1
    
    if nargin < 4
        w = 0.064;
    end
    
    num_bins = length(bin_centers);
    
    % 注意原始数据为z, -x, -y
    true_x = -finger_pos(:, 2);
    true_y = -finger_pos(:, 3);
    
    position = zeros(num_bins, 2);
    velocity = zeros(num_bins, 2);
    acceleration = zeros(num_bins, 2);
    
    for i = 1:num_bins
        center_time = bin_centers(i);
        
        window_start = center_time - w/2;
        window_end = center_time + w/2;
        
        window_indices = find(t >= window_start & t <= window_end);
        
        % 如果窗口内有数据点，计算平均位置
        if ~isempty(window_indices)
            position(i, 1) = mean(true_x(window_indices));
            position(i, 2) = mean(true_y(window_indices));
        else
            % 如果当前窗口内没有数据点，使用插值
            position(i, 1) = interp1(t, true_x, center_time, 'linear', 'extrap');
            position(i, 2) = interp1(t, true_y, center_time, 'linear', 'extrap');
        end
    end
    
    % 速度：位置的一阶差分除以时间间隔
    for i = 2:num_bins
        velocity(i, :) = (position(i, :) - position(i-1, :)) / w;
    end
    % 第一个点的速度使用第二个点的值
    velocity(1, :) = velocity(2, :);
    
    % 加速度：速度的一阶差分除以时间间隔
    for i = 2:num_bins
        acceleration(i, :) = (velocity(i, :) - velocity(i-1, :)) / w;
    end
    % 第一个点的加速度使用第二个点的值
    acceleration(1, :) = acceleration(2, :);
    
    kinematics_time = bin_centers;
end