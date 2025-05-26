function [firing_rates, valid_units, bin_centers] = calculate_firing_rates(unit_spike, t, w)
    % 计算每个神经元的发放率
    %
    % 输入:
    %   unit_spike - 包含每个神经元放电时间戳的元胞数组(1 x u)
    %   t - 手指位置的采样时间戳(k x 1)
    %   w - 时间窗口大小(秒)，默认为0.064秒(64ms)
    %
    % 输出:
    %   firing_rates - 每个神经元在每个时间窗口的发放率
    %   valid_units - 平均发放率≥0.5Hz的神经元索引
    %   bin_centers - 时间窗口中心点(bins x 1)
    
    if nargin < 3
        w = 0.064;
    end
    
    num_units = length(unit_spike);
    
    t_start = min(t);
    t_end = max(t);
    edges = t_start:w:t_end;
    num_bins = length(edges) - 1;
    
    bin_centers = edges(1:end-1) + w/2;
    
    firing_rates = zeros(num_bins, num_units);
    
    for u = 1:num_units
        spike_times = unit_spike{u};

        if isempty(spike_times)
            continue;
        end
        spike_counts = histcounts(spike_times, edges);
        firing_rates(:, u) = spike_counts' / w;
    end
    mean_firing_rates = mean(firing_rates, 1);
    valid_units = find(mean_firing_rates >= 0.5);
end