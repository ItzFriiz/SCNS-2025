function [r_squared, snr, predicted_data] = evaluate_decoder_linear(firing_rates, data, decoder)
    % 为linear decoder计算R^2和SNR
    %
    % 输入:
    %   firing_rates - 测试集发放率数据 (num_samples x num_units)
    %   data - 测试集数据 (num_samples x 2)
    %   decoder - 解码器权重矩阵 (num_units x 2)
    %
    % 输出:
    %   r_squared - 决定系数 [x方向R^2, y方向R^2, 平均R^2]
    %   snr - 信噪比(dB) [x方向SNR, y方向SNR, 平均SNR]
    %   predicted_data - 预测结果
    
    predicted_data = firing_rates * decoder;
    
    r_squared = zeros(1, 3); % [x方向, y方向, 平均]
    snr = zeros(1, 3);       % [x方向, y方向, 平均]
    
    for dim = 1:2
        actual = data(:, dim);
        predicted = predicted_data(:, dim);
        
        % SSE
        sse = sum((actual - predicted).^2);
        
        % SST
        actual_mean = mean(actual);
        sst = sum((actual - actual_mean).^2);
        
        % R^2
        r_squared(dim) = 1 - sse/sst;
        
        % SNR(dB)
        snr(dim) = -10 * log10(1 - r_squared(dim));
    end
    
    r_squared(3) = mean(r_squared(1:2));
    snr(3) = mean(snr(1:2));
end