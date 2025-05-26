function [r_squared, snr] = evaluate_decoder_kalman(ground, est)
    % 为Kalman decoder计算R^2和SNR
    %
    % 输入:
    %   ground - 真实值 (num_samples x 2)
    %   est - 估计值 (num_samples x 2)
    %
    % 输出:
    %   r_squared - 决定系数 [x方向R^2, y方向R^2, 平均R^2]
    %   snr - 信噪比(dB) [x方向SNR, y方向SNR, 平均SNR]
    
    r_squared = zeros(1, 3); % [x方向, y方向, 平均]
    snr = zeros(1, 3);       % [x方向, y方向, 平均]
    
    for dim = 1:2
        actual = ground(:, dim);
        predicted = est(:, dim);
        
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